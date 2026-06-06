package com.smartstudy.servlet;

import com.smartstudy.dao.UserDAO;
import com.smartstudy.model.User;
import com.smartstudy.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AdminStudentDetailsServlet extends HttpServlet {

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

            String idParam = req.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                throw new ServletException("Missing student id.");
            }

            int studentId = Integer.parseInt(idParam);

            UserDAO userDAO = new UserDAO();
            User student = userDAO.findById(studentId);

            if (student == null) {
                throw new ServletException("Student not found.");
            }

            if ("ADMIN".equalsIgnoreCase(student.getRole())) {
                throw new ServletException("This page is intended for student accounts only.");
            }

            try (Connection c = DBConnection.getConnection()) {

                int totalCourses = readInt(c, new String[]{
                        "SELECT COUNT(*) FROM courses WHERE user_id = ?"
                }, studentId);

                int totalMaterials = readInt(c, new String[]{
                        "SELECT COUNT(*) FROM materials WHERE user_id = ?"
                }, studentId);

                int totalFlashcards = readInt(c, new String[]{
                        "SELECT COUNT(*) FROM flashcards WHERE user_id = ?"
                }, studentId);

                int totalGapAlerts = readInt(c, new String[]{
                        "SELECT COUNT(*) FROM gap_alerts WHERE user_id = ?"
                }, studentId);

                int totalPlanTasks = readInt(c, new String[]{
                        "SELECT COUNT(*) FROM study_plan_items WHERE user_id = ?"
                }, studentId);

                int completedPlanTasks = readInt(c, new String[]{
                        "SELECT COUNT(*) FROM study_plan_items WHERE user_id = ? AND completed = 1",
                        "SELECT COUNT(*) FROM study_plan_items WHERE user_id = ? AND completed = true"
                }, studentId);

                int totalStudyMinutes = readInt(c, new String[]{
                        "SELECT COALESCE(SUM(minutes), 0) FROM study_sessions WHERE user_id = ?",
                        "SELECT COALESCE(SUM(duration_minutes), 0) FROM study_sessions WHERE user_id = ?",
                        "SELECT COALESCE(SUM(study_minutes), 0) FROM study_sessions WHERE user_id = ?",
                        "SELECT COALESCE(SUM(actual_minutes), 0) FROM study_plan_items WHERE user_id = ?"
                }, studentId);

                double averageScore = readDouble(c, new String[]{
                        "SELECT COALESCE(AVG(score * 100.0 / total_questions), 0) FROM quiz_results WHERE user_id = ? AND total_questions > 0",
                        "SELECT COALESCE(AVG(score), 0) FROM quiz_results WHERE user_id = ?"
                }, studentId);

                List<Map<String, Object>> courses = readRows(c,
                        "SELECT id, title, description, exam_date FROM courses WHERE user_id = ? ORDER BY id DESC",
                        studentId
                );

                List<Map<String, Object>> recentQuizzes = readRows(c,
                        "SELECT qr.id, qr.course_id, qr.score, qr.total_questions, qr.duration_seconds, c.title AS course_title " +
                                "FROM quiz_results qr " +
                                "LEFT JOIN courses c ON qr.course_id = c.id " +
                                "WHERE qr.user_id = ? " +
                                "ORDER BY qr.id DESC " +
                                "LIMIT 8",
                        studentId
                );

                List<Map<String, Object>> recentPlanTasks = readRows(c,
                        "SELECT spi.id, spi.course_id, spi.plan_date, spi.task_title, spi.description, spi.estimated_minutes, spi.completed, spi.priority, spi.generated_by, c.title AS course_title " +
                                "FROM study_plan_items spi " +
                                "LEFT JOIN courses c ON spi.course_id = c.id " +
                                "WHERE spi.user_id = ? " +
                                "ORDER BY spi.plan_date DESC, spi.id DESC " +
                                "LIMIT 10",
                        studentId
                );

                List<Map<String, Object>> gapAlerts = readRows(c,
                        "SELECT id, course_id, message, severity FROM gap_alerts WHERE user_id = ? ORDER BY id DESC LIMIT 8",
                        studentId
                );

                List<Map<String, Object>> adaptiveFlashcards = readRows(c,
                        "SELECT id, course_id, material_id, front_text, back_text, generation_source, generation_batch, created_at " +
                                "FROM flashcards " +
                                "WHERE user_id = ? " +
                                "ORDER BY id DESC " +
                                "LIMIT 10",
                        studentId
                );

                req.setAttribute("student", student);

                req.setAttribute("totalCourses", totalCourses);
                req.setAttribute("totalMaterials", totalMaterials);
                req.setAttribute("totalFlashcards", totalFlashcards);
                req.setAttribute("totalGapAlerts", totalGapAlerts);
                req.setAttribute("totalPlanTasks", totalPlanTasks);
                req.setAttribute("completedPlanTasks", completedPlanTasks);
                req.setAttribute("totalStudyMinutes", totalStudyMinutes);
                req.setAttribute("averageScore", averageScore);

                req.setAttribute("courses", courses);
                req.setAttribute("recentQuizzes", recentQuizzes);
                req.setAttribute("recentPlanTasks", recentPlanTasks);
                req.setAttribute("gapAlerts", gapAlerts);
                req.setAttribute("adaptiveFlashcards", adaptiveFlashcards);
            }

            req.getRequestDispatcher("/WEB-INF/views/admin/student-details.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private int readInt(Connection c, String[] queries, int userId) {
        for (String sql : queries) {
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            } catch (Exception ignored) {
            }
        }

        return 0;
    }

    private double readDouble(Connection c, String[] queries, int userId) {
        for (String sql : queries) {
            try (PreparedStatement ps = c.prepareStatement(sql)) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getDouble(1);
                    }
                }
            } catch (Exception ignored) {
            }
        }

        return 0.0;
    }

    private List<Map<String, Object>> readRows(Connection c, String sql, int userId) {
        List<Map<String, Object>> rows = new ArrayList<>();

        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                int columnCount = rs.getMetaData().getColumnCount();

                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();

                    for (int i = 1; i <= columnCount; i++) {
                        String columnName = rs.getMetaData().getColumnLabel(i);
                        row.put(columnName, rs.getObject(i));
                    }

                    rows.add(row);
                }
            }
        } catch (Exception ignored) {
        }

        return rows;
    }
}