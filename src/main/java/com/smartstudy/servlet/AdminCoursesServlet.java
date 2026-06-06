package com.smartstudy.servlet;

import com.smartstudy.model.User;
import com.smartstudy.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminCoursesServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User currentUser = (User) req.getSession().getAttribute("user");

            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            if (!"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
                return;
            }

            try (Connection c = DBConnection.getConnection()) {
                List<Map<String, Object>> courses = getCourses(c);
                List<Map<String, Object>> students = getStudents(c);
                List<Map<String, Object>> studentCourseStats = getStudentCourseStats(c);

                int totalCourses = courses.size();
                int totalStudents = students.size();
                int mediumCourses = 0;
                int hardCourses = 0;

                for (Map<String, Object> course : courses) {
                    String difficulty = String.valueOf(course.get("difficulty"));

                    if ("MEDIUM".equalsIgnoreCase(difficulty)) {
                        mediumCourses++;
                    }

                    if ("HARD".equalsIgnoreCase(difficulty)) {
                        hardCourses++;
                    }
                }

                req.setAttribute("courses", courses);
                req.setAttribute("students", students);
                req.setAttribute("studentCourseStats", studentCourseStats);

                req.setAttribute("totalCourses", totalCourses);
                req.setAttribute("totalStudents", totalStudents);
                req.setAttribute("mediumCourses", mediumCourses);
                req.setAttribute("hardCourses", hardCourses);
            }

            req.getRequestDispatcher("/WEB-INF/views/admin/courses.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User currentUser = (User) req.getSession().getAttribute("user");

            if (currentUser == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            if (!"ADMIN".equalsIgnoreCase(currentUser.getRole())) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Admin access required.");
                return;
            }

            req.setCharacterEncoding("UTF-8");

            String action = req.getParameter("action");

            if (action == null || action.trim().isEmpty()) {
                action = "create";
            }

            if ("create".equalsIgnoreCase(action)) {
                createCourse(req);
                resp.sendRedirect(req.getContextPath() + "/admin/courses?created=1");
                return;
            }

            if ("delete".equalsIgnoreCase(action)) {
                deleteCourse(req);
                resp.sendRedirect(req.getContextPath() + "/admin/courses?deleted=1");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/admin/courses");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private List<Map<String, Object>> getCourses(Connection c) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT c.id, c.user_id, c.title, c.description, c.exam_date, c.difficulty, " +
                "       u.full_name AS student_name, u.email AS student_email " +
                "FROM courses c " +
                "LEFT JOIN users u ON c.user_id = u.id " +
                "ORDER BY c.exam_date ASC, c.id DESC";

        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("id", rs.getInt("id"));
                row.put("user_id", rs.getInt("user_id"));
                row.put("title", rs.getString("title"));
                row.put("description", rs.getString("description"));
                row.put("exam_date", rs.getDate("exam_date"));
                row.put("difficulty", rs.getString("difficulty"));
                row.put("student_name", rs.getString("student_name"));
                row.put("student_email", rs.getString("student_email"));

                list.add(row);
            }
        }

        return list;
    }

    private List<Map<String, Object>> getStudents(Connection c) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT id, full_name, email " +
                "FROM users " +
                "WHERE role = 'STUDENT' " +
                "ORDER BY full_name ASC";

        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("id", rs.getInt("id"));
                row.put("full_name", rs.getString("full_name"));
                row.put("email", rs.getString("email"));

                list.add(row);
            }
        }

        return list;
    }

    private List<Map<String, Object>> getStudentCourseStats(Connection c) throws Exception {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT u.id AS student_id, u.full_name, u.email, COUNT(c.id) AS total_courses " +
                "FROM users u " +
                "LEFT JOIN courses c ON c.user_id = u.id " +
                "WHERE u.role = 'STUDENT' " +
                "GROUP BY u.id, u.full_name, u.email " +
                "ORDER BY total_courses DESC, u.full_name ASC";

        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("student_id", rs.getInt("student_id"));
                row.put("full_name", rs.getString("full_name"));
                row.put("email", rs.getString("email"));
                row.put("total_courses", rs.getInt("total_courses"));

                list.add(row);
            }
        }

        return list;
    }

    private void createCourse(HttpServletRequest req) throws Exception {
        String studentIdParam = req.getParameter("studentId");
        String title = req.getParameter("title");
        String description = req.getParameter("description");
        String examDateParam = req.getParameter("examDate");
        String difficulty = req.getParameter("difficulty");

        if (studentIdParam == null || studentIdParam.trim().isEmpty()) {
            throw new ServletException("Please select a student.");
        }

        if (title == null || title.trim().isEmpty()) {
            throw new ServletException("Course title is required.");
        }

        if (examDateParam == null || examDateParam.trim().isEmpty()) {
            throw new ServletException("Exam date is required.");
        }

        if (difficulty == null || difficulty.trim().isEmpty()) {
            difficulty = "MEDIUM";
        }

        int studentId = Integer.parseInt(studentIdParam);
        LocalDate examDate = LocalDate.parse(examDateParam);

        String sql =
                "INSERT INTO courses (user_id, title, description, exam_date, difficulty) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.setString(2, title.trim());
            ps.setString(3, description == null ? "" : description.trim());
            ps.setDate(4, Date.valueOf(examDate));
            ps.setString(5, difficulty.toUpperCase());

            ps.executeUpdate();
        }
    }

    private void deleteCourse(HttpServletRequest req) throws Exception {
        String courseIdParam = req.getParameter("courseId");

        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            throw new ServletException("Missing course id.");
        }

        int courseId = Integer.parseInt(courseIdParam);

        String sql = "DELETE FROM courses WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, courseId);
            ps.executeUpdate();
        }
    }
}