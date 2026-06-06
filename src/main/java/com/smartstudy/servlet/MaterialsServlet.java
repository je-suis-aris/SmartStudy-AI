package com.smartstudy.servlet;

import com.smartstudy.dao.CourseDAO;
import com.smartstudy.dao.DisciplineDAO;
import com.smartstudy.dao.MaterialDAO;
import com.smartstudy.model.Course;
import com.smartstudy.model.Discipline;
import com.smartstudy.model.Material;
import com.smartstudy.model.User;
import com.smartstudy.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import org.apache.pdfbox.Loader;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.text.PDFTextStripper;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 10 * 1024 * 1024,
        maxRequestSize = 15 * 1024 * 1024
)
public class MaterialsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final CourseDAO courseDAO = new CourseDAO();
    private final DisciplineDAO disciplineDAO = new DisciplineDAO();
    private final MaterialDAO materialDAO = new MaterialDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            reloadPageData(req, user.getId());

            req.getRequestDispatcher("/WEB-INF/views/student/materials.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setCharacterEncoding("UTF-8");

            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String title = clean(req.getParameter("title"));
            String courseName = clean(req.getParameter("courseName"));
            String disciplineName = clean(req.getParameter("disciplineName"));

            if (title.isEmpty()) {
                showFormError(req, resp, user.getId(), "Material title is required.");
                return;
            }

            if (courseName.isEmpty()) {
                showFormError(req, resp, user.getId(), "Course name is required.");
                return;
            }

            Part pdfPart = null;

            try {
                pdfPart = req.getPart("pdfFile");
            } catch (Exception ignored) {
                pdfPart = null;
            }

            if (pdfPart == null || pdfPart.getSize() == 0) {
                showFormError(req, resp, user.getId(), "Please upload a PDF file.");
                return;
            }

            String extractedText = extractTextFromPdf(pdfPart);

            if (extractedText == null || extractedText.trim().isEmpty()) {
                showFormError(
                        req,
                        resp,
                        user.getId(),
                        "Please upload a readable PDF. Scanned PDFs may not contain extractable text."
                );
                return;
            }

            int courseId = courseDAO.findOrCreateByUserAndTitle(user.getId(), courseName);

            if (courseId <= 0) {
                showFormError(req, resp, user.getId(), "Course could not be created or found.");
                return;
            }

            int disciplineId = resolveDisciplineId(courseId, disciplineName);

            Material material = new Material();
            material.setUserId(user.getId());
            material.setCourseId(courseId);
            material.setDisciplineId(disciplineId);
            material.setTitle(title);
            material.setMaterialType("PDF");
            material.setContentText(extractedText.trim());
            material.setAiStatus("READY");
            material.setSummary(null);

            System.out.println("UPLOAD MATERIAL DEBUG");
            System.out.println("USER ID = " + user.getId());
            System.out.println("COURSE NAME = " + courseName);
            System.out.println("COURSE ID = " + courseId);
            System.out.println("DISCIPLINE NAME = " + disciplineName);
            System.out.println("DISCIPLINE ID = " + disciplineId);
            System.out.println("MATERIAL TITLE = " + title);

            boolean created = materialDAO.create(material);

            if (!created) {
                showFormError(req, resp, user.getId(), "The material could not be saved.");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/materials?uploaded=1");

        } catch (Exception e) {
            e.printStackTrace();

            try {
                User user = (User) req.getSession().getAttribute("user");

                if (user != null) {
                    showFormError(req, resp, user.getId(), "Material upload failed: " + e.getMessage());
                } else {
                    resp.sendRedirect(req.getContextPath() + "/login");
                }

            } catch (Exception secondException) {
                throw new ServletException(e);
            }
        }
    }

    private void reloadPageData(HttpServletRequest req, int userId) throws Exception {
        List<Course> courses = courseDAO.findByUser(userId);
        List<Discipline> disciplines = disciplineDAO.findAll();
        List<Material> materials = materialDAO.findByUser(userId);

        req.setAttribute("courses", courses);
        req.setAttribute("disciplines", disciplines);
        req.setAttribute("materials", materials);
    }

    private void showFormError(HttpServletRequest req, HttpServletResponse resp, int userId, String message)
            throws Exception {

        req.setAttribute("error", message);
        reloadPageData(req, userId);

        req.getRequestDispatcher("/WEB-INF/views/student/materials.jsp")
                .forward(req, resp);
    }

    private int resolveDisciplineId(int courseId, String disciplineName) throws Exception {
        disciplineName = clean(disciplineName);

        if (disciplineName.isEmpty()) {
            return 0;
        }

        Integer existingId = findDisciplineIdByCourseAndTitle(courseId, disciplineName);

        if (existingId != null && existingId > 0) {
            System.out.println("DEBUG EXISTING DISCIPLINE ID = " + existingId);
            return existingId;
        }

        return createDiscipline(courseId, disciplineName);
    }

    private Integer findDisciplineIdByCourseAndTitle(int courseId, String title) throws Exception {
        String sql =
                "SELECT id " +
                "FROM disciplines " +
                "WHERE course_id = ? " +
                "AND LOWER(title) = LOWER(?) " +
                "LIMIT 1";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ps.setString(2, title);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }

        return null;
    }

    private int createDiscipline(int courseId, String title) throws Exception {
        String sql =
                "INSERT INTO disciplines (course_id, title, description) " +
                "VALUES (?, ?, ?)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, courseId);
            ps.setString(2, title);
            ps.setString(3, "Discipline created automatically from uploaded material.");

            int affectedRows = ps.executeUpdate();

            if (affectedRows == 0) {
                return 0;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int generatedId = rs.getInt(1);

                    if (generatedId > 0) {
                        System.out.println("DEBUG CREATED DISCIPLINE ID = " + generatedId);
                        return generatedId;
                    }
                }
            }
        }

        return 0;
    }

    private String extractTextFromPdf(Part pdfPart) throws Exception {
        if (pdfPart == null || pdfPart.getSize() == 0) {
            return "";
        }

        try (InputStream inputStream = pdfPart.getInputStream()) {
            byte[] pdfBytes = inputStream.readAllBytes();

            try (PDDocument document = Loader.loadPDF(pdfBytes)) {
                PDFTextStripper stripper = new PDFTextStripper();
                return stripper.getText(document);
            }
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }
}