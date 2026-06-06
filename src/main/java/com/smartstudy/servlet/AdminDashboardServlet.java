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

public class AdminDashboardServlet extends HttpServlet {

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

            UserDAO userDAO = new UserDAO();

            List<User> users = userDAO.findAll();
            List<User> pendingAdminRequests = userDAO.findPendingAdminRequests();

            int totalUsers = users.size();
            int totalStudents = 0;
            int totalAdmins = 0;

            for (User u : users) {
                if ("ADMIN".equalsIgnoreCase(u.getRole())) {
                    totalAdmins++;
                } else {
                    totalStudents++;
                }
            }

            req.setAttribute("users", users);
            req.setAttribute("pendingAdminRequests", pendingAdminRequests);
            req.setAttribute("totalUsers", totalUsers);
            req.setAttribute("totalStudents", totalStudents);
            req.setAttribute("totalAdmins", totalAdmins);
            req.setAttribute("pendingRequestsCount", pendingAdminRequests.size());

            try (Connection c = DBConnection.getConnection()) {
                req.setAttribute("totalCourses", readInt(c, "SELECT COUNT(*) FROM courses"));
                req.setAttribute("totalMaterials", readInt(c, "SELECT COUNT(*) FROM materials"));
                req.setAttribute("totalQuizzes", readInt(c, "SELECT COUNT(*) FROM quiz_results"));
                req.setAttribute("totalFlashcards", readInt(c, "SELECT COUNT(*) FROM flashcards"));
                req.setAttribute("totalGapAlerts", readInt(c, "SELECT COUNT(*) FROM gap_alerts"));
                req.setAttribute("totalStudyMinutes", readIntWithFallback(c, new String[]{
                        "SELECT COALESCE(SUM(minutes), 0) FROM study_sessions",
                        "SELECT COALESCE(SUM(duration_minutes), 0) FROM study_sessions",
                        "SELECT COALESCE(SUM(study_minutes), 0) FROM study_sessions"
                }));

                req.setAttribute("atRiskStudents", getAtRiskStudents(c));
                req.setAttribute("recentMaterials", getRecentMaterials(c));
                req.setAttribute("recentActivities", getRecentActivities(c));
            }

            req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private int readInt(Connection c, String sql) {
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception ignored) {
        }

        return 0;
    }

    private int readIntWithFallback(Connection c, String[] queries) {
        for (String sql : queries) {
            try (PreparedStatement ps = c.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }

            } catch (Exception ignored) {
            }
        }

        return 0;
    }

    private List<Map<String, Object>> getAtRiskStudents(Connection c) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT u.id AS student_id, u.full_name, u.email, " +
                "       COALESCE(AVG(qr.score * 100.0 / NULLIF(qr.total_questions, 0)), 0) AS avg_score, " +
                "       COUNT(DISTINCT ga.id) AS gap_alerts " +
                "FROM users u " +
                "LEFT JOIN quiz_results qr ON qr.user_id = u.id " +
                "LEFT JOIN gap_alerts ga ON ga.user_id = u.id " +
                "WHERE u.role = 'STUDENT' " +
                "GROUP BY u.id, u.full_name, u.email " +
                "HAVING avg_score < 50 OR gap_alerts >= 2 " +
                "ORDER BY gap_alerts DESC, avg_score ASC " +
                "LIMIT 5";

        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("student_id", rs.getInt("student_id"));
                row.put("full_name", rs.getString("full_name"));
                row.put("email", rs.getString("email"));
                row.put("avg_score", rs.getDouble("avg_score"));
                row.put("gap_alerts", rs.getInt("gap_alerts"));

                list.add(row);
            }

        } catch (Exception ignored) {
        }

        return list;
    }

    private List<Map<String, Object>> getRecentMaterials(Connection c) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT m.id, m.title, m.material_type, m.ai_status, " +
                "       u.full_name AS student_name, c.title AS course_title " +
                "FROM materials m " +
                "LEFT JOIN users u ON m.user_id = u.id " +
                "LEFT JOIN courses c ON m.course_id = c.id " +
                "ORDER BY m.id DESC " +
                "LIMIT 5";

        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("id", rs.getInt("id"));
                row.put("title", rs.getString("title"));
                row.put("material_type", rs.getString("material_type"));
                row.put("ai_status", rs.getString("ai_status"));
                row.put("student_name", rs.getString("student_name"));
                row.put("course_title", rs.getString("course_title"));

                list.add(row);
            }

        } catch (Exception ignored) {
        }

        return list;
    }

    private List<Map<String, Object>> getRecentActivities(Connection c) {
        List<Map<String, Object>> list = new ArrayList<>();

        addActivityRows(
                c,
                list,
                "SELECT full_name AS actor, email AS details, created_at AS activity_date " +
                        "FROM users " +
                        "ORDER BY id DESC " +
                        "LIMIT 3",
                "New user registered"
        );

        addActivityRows(
                c,
                list,
                "SELECT u.full_name AS actor, m.title AS details, m.id AS activity_date " +
                        "FROM materials m " +
                        "LEFT JOIN users u ON m.user_id = u.id " +
                        "ORDER BY m.id DESC " +
                        "LIMIT 3",
                "Material uploaded"
        );

        addActivityRows(
                c,
                list,
                "SELECT u.full_name AS actor, CONCAT('Score: ', qr.score, '/', qr.total_questions) AS details, qr.id AS activity_date " +
                        "FROM quiz_results qr " +
                        "LEFT JOIN users u ON qr.user_id = u.id " +
                        "ORDER BY qr.id DESC " +
                        "LIMIT 3",
                "Quiz completed"
        );

        addActivityRows(
                c,
                list,
                "SELECT u.full_name AS actor, f.front_text AS details, f.id AS activity_date " +
                        "FROM flashcards f " +
                        "LEFT JOIN users u ON f.user_id = u.id " +
                        "ORDER BY f.id DESC " +
                        "LIMIT 3",
                "Flashcard generated"
        );

        if (list.size() > 8) {
            return new ArrayList<>(list.subList(0, 8));
        }

        return list;
    }

    private void addActivityRows(Connection c, List<Map<String, Object>> list, String sql, String type) {
        try (PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();

                row.put("type", type);
                row.put("actor", rs.getString("actor"));
                row.put("details", rs.getString("details"));
                row.put("activity_date", rs.getObject("activity_date"));

                list.add(row);
            }

        } catch (Exception ignored) {
        }
    }
}