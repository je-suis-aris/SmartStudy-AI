package com.smartstudy.servlet;

import com.smartstudy.dao.UserDAO;
import com.smartstudy.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 5,
        maxRequestSize = 1024 * 1024 * 10
)
public class ProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User currentUser = (User) req.getSession().getAttribute("user");

        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setAttribute("currentUser", currentUser);
        req.getRequestDispatcher("/WEB-INF/views/student/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            req.setCharacterEncoding("UTF-8");

            User currentUser = (User) req.getSession().getAttribute("user");

            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            String fullName = req.getParameter("fullName");
            String description = req.getParameter("description");
            String preferredStudyRhythm = req.getParameter("preferredStudyRhythm");
            String learningStyle = req.getParameter("learningStyle");

            currentUser.setFullName(valueOrDefault(fullName, currentUser.getFullName()));
            currentUser.setDescription(valueOrDefault(description, ""));
            currentUser.setPreferredStudyRhythm(valueOrDefault(preferredStudyRhythm, "Balanced revision"));
            currentUser.setLearningStyle(valueOrDefault(learningStyle, "Mixed learning"));

            Part photoPart = req.getPart("profilePhoto");

            if (photoPart != null && photoPart.getSize() > 0) {
                String originalFileName = Paths.get(photoPart.getSubmittedFileName()).getFileName().toString();

                String extension = "";
                int dotIndex = originalFileName.lastIndexOf(".");

                if (dotIndex >= 0) {
                    extension = originalFileName.substring(dotIndex);
                }

                String fileName = "user_" + currentUser.getId() + "_" + System.currentTimeMillis() + extension;

                String uploadFolder = getServletContext().getRealPath("/assets/uploads/profile");

                File folder = new File(uploadFolder);

                if (!folder.exists()) {
                    folder.mkdirs();
                }

                String fullPath = uploadFolder + File.separator + fileName;
                photoPart.write(fullPath);

                String dbPath = "assets/uploads/profile/" + fileName;
                currentUser.setProfilePhoto(dbPath);
            }

            new UserDAO().updateProfile(currentUser);

            User refreshedUser = new UserDAO().findById(currentUser.getId());
            req.getSession().setAttribute("user", refreshedUser);

            resp.sendRedirect(req.getContextPath() + "/profile?success=1");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private String valueOrDefault(String value, String defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }

        return value.trim();
    }
}