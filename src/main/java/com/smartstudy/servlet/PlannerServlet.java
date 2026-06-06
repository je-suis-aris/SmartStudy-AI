package com.smartstudy.servlet;

import com.smartstudy.dao.CourseDAO;
import com.smartstudy.model.User;
import com.smartstudy.service.PlannerRecommendationService;
import com.smartstudy.service.StudyPlanService;
import com.smartstudy.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class PlannerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {
            User user = (User) req.getSession().getAttribute("user");

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/login");
                return;
            }

            req.setAttribute("courses", new CourseDAO().findByUser(user.getId()));
            req.setAttribute("plan", plan(user.getId()));
            req.setAttribute("completedPlan", completedPlan(user.getId()));
            req.setAttribute("recommendations", recommendations(user.getId()));
            req.setAttribute("realStudySeconds", totalRealStudySeconds(user.getId()));

            req.getRequestDispatcher("/WEB-INF/views/student/planner.jsp")
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

            String action = req.getParameter("action");

            if ("generate".equals(action) || action == null || action.trim().isEmpty()) {
                generatePlan(req, user);
                resp.sendRedirect(req.getContextPath() + "/planner");
                return;
            }

            if ("startTask".equals(action)) {
                int taskId = Integer.parseInt(req.getParameter("taskId"));
                startTask(user.getId(), taskId);
                resp.sendRedirect(req.getContextPath() + "/planner");
                return;
            }

            if ("finishTask".equals(action)) {
                int taskId = Integer.parseInt(req.getParameter("taskId"));
                finishTask(user.getId(), taskId);
                resp.sendRedirect(req.getContextPath() + "/planner");
                return;
            }

            if ("resetTask".equals(action)) {
                int taskId = Integer.parseInt(req.getParameter("taskId"));
                resetTask(user.getId(), taskId);
                resp.sendRedirect(req.getContextPath() + "/planner");
                return;
            }

            if ("generateRecommendations".equals(action)) {
                new PlannerRecommendationService().generateAndSaveRecommendations(user.getId());
                resp.sendRedirect(req.getContextPath() + "/planner");
                return;
            }

            resp.sendRedirect(req.getContextPath() + "/planner");

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private void generatePlan(HttpServletRequest req, User user) throws Exception {
        int courseId = Integer.parseInt(req.getParameter("courseId"));
        LocalDate examDate = LocalDate.parse(req.getParameter("examDate"));
        String difficulty = req.getParameter("difficulty");

        String preferredStudyRhythm = user.getPreferredStudyRhythm();
        String learningStyle = user.getLearningStyle();

        if (preferredStudyRhythm == null || preferredStudyRhythm.trim().isEmpty()) {
            preferredStudyRhythm = "Balanced revision";
        }

        if (learningStyle == null || learningStyle.trim().isEmpty()) {
            learningStyle = "Mixed learning";
        }

        new StudyPlanService().generatePlan(
                user.getId(),
                courseId,
                examDate,
                difficulty,
                preferredStudyRhythm,
                learningStyle
        );
    }

    private void startTask(int userId, int taskId) throws SQLException {
        String sql =
                "UPDATE study_plan_items " +
                "SET status = 'IN_PROGRESS', started_at = NOW(), completed = false " +
                "WHERE id = ? AND user_id = ? AND (status IS NULL OR status <> 'DONE')";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private void finishTask(int userId, int taskId) throws SQLException {
        String sql =
                "UPDATE study_plan_items " +
                "SET actual_seconds = COALESCE(actual_seconds, 0) + " +
                "CASE " +
                "WHEN started_at IS NULL THEN estimated_minutes * 60 " +
                "ELSE TIMESTAMPDIFF(SECOND, started_at, NOW()) " +
                "END, " +
                "completed = true, " +
                "status = 'DONE', " +
                "completed_at = NOW(), " +
                "started_at = NULL " +
                "WHERE id = ? AND user_id = ? AND (status IS NULL OR status <> 'DONE')";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private void resetTask(int userId, int taskId) throws SQLException {
        String sql =
                "UPDATE study_plan_items " +
                "SET completed = false, status = 'TODO', started_at = NULL, completed_at = NULL, actual_seconds = 0 " +
                "WHERE id = ? AND user_id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, taskId);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
    }

    private List<Map<String, Object>> plan(int userId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT spi.*, c.title AS course_title " +
                "FROM study_plan_items spi " +
                "JOIN courses c ON spi.course_id = c.id " +
                "WHERE spi.user_id = ? " +
                "ORDER BY spi.plan_date ASC, spi.id ASC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTask(rs));
                }
            }
        }

        return list;
    }

    private List<Map<String, Object>> completedPlan(int userId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT spi.*, c.title AS course_title " +
                "FROM study_plan_items spi " +
                "JOIN courses c ON spi.course_id = c.id " +
                "WHERE spi.user_id = ? AND (spi.completed = true OR spi.status = 'DONE') " +
                "ORDER BY spi.completed_at DESC, spi.id DESC " +
                "LIMIT 6";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapTask(rs));
                }
            }
        }

        return list;
    }

    private Map<String, Object> mapTask(ResultSet rs) throws SQLException {
        Map<String, Object> m = new HashMap<>();

        m.put("id", rs.getInt("id"));
        m.put("date", rs.getDate("plan_date"));
        m.put("task", rs.getString("task_title"));
        m.put("course", rs.getString("course_title"));
        m.put("minutes", rs.getInt("estimated_minutes"));
        m.put("completed", rs.getBoolean("completed"));

        try {
            m.put("description", rs.getString("description"));
        } catch (Exception ignored) {
            m.put("description", "");
        }

        try {
            m.put("priority", rs.getString("priority"));
        } catch (Exception ignored) {
            m.put("priority", "MEDIUM");
        }

        try {
            m.put("generatedBy", rs.getString("generated_by"));
        } catch (Exception ignored) {
            m.put("generatedBy", "RULE");
        }

        try {
            String status = rs.getString("status");
            m.put("status", status == null ? "TODO" : status);
        } catch (Exception ignored) {
            m.put("status", "TODO");
        }

        try {
            m.put("actualSeconds", rs.getInt("actual_seconds"));
        } catch (Exception ignored) {
            m.put("actualSeconds", 0);
        }

        try {
            m.put("startedAt", rs.getTimestamp("started_at"));
        } catch (Exception ignored) {
            m.put("startedAt", null);
        }

        try {
            m.put("completedAt", rs.getTimestamp("completed_at"));
        } catch (Exception ignored) {
            m.put("completedAt", null);
        }

        return m;
    }

    private List<Map<String, Object>> recommendations(int userId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT * FROM planner_recommendations " +
                "WHERE user_id = ? " +
                "ORDER BY created_at DESC, id DESC " +
                "LIMIT 3";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();

                    m.put("title", rs.getString("title"));
                    m.put("body", rs.getString("body"));
                    m.put("source", rs.getString("source"));

                    list.add(m);
                }
            }
        }

        return list;
    }

    private int totalRealStudySeconds(int userId) throws SQLException {
        String sql =
                "SELECT COALESCE(SUM(actual_seconds), 0) AS total_seconds " +
                "FROM study_plan_items " +
                "WHERE user_id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total_seconds");
                }
            }
        }

        return 0;
    }
}