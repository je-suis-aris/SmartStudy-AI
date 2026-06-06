package com.smartstudy.dao;

import com.smartstudy.model.DashboardStats;
import com.smartstudy.util.DBConnection;

import java.sql.*;
import java.util.*;

public class DashboardDAO {

    public DashboardStats stats(int userId) throws SQLException {
        DashboardStats s = new DashboardStats();

        try (Connection c = DBConnection.getConnection()) {

            s.setTotalCourses(count(
                    c,
                    "SELECT COUNT(*) FROM courses WHERE user_id = ? OR user_id IS NULL",
                    userId
            ));

            s.setTotalMaterials(count(
                    c,
                    "SELECT COUNT(*) FROM materials WHERE user_id = ?",
                    userId
            ));

            s.setTotalStudyMinutes(count(
                    c,
                    "SELECT COALESCE(SUM(minutes_spent), 0) FROM study_sessions WHERE user_id = ?",
                    userId
            ));

            String avgSql =
                    "SELECT COALESCE(AVG((score * 100.0) / NULLIF(total_questions, 0)), 0) " +
                    "FROM quiz_results " +
                    "WHERE user_id = ?";

            try (PreparedStatement ps = c.prepareStatement(avgSql)) {
                ps.setInt(1, userId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        s.setAverageScore(rs.getDouble(1));
                    }
                }
            }
        }

        return s;
    }

    public List<Map<String, Object>> alerts(int userId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT * FROM gap_alerts " +
                "WHERE user_id = ? AND solved = false " +
                "ORDER BY FIELD(severity, 'HIGH', 'MEDIUM', 'LOW')";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("message", rs.getString("message"));
                    m.put("severity", rs.getString("severity"));
                    list.add(m);
                }
            }
        }

        return list;
    }

    public List<Map<String, Object>> todayPlan(int userId) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql =
                "SELECT spi.*, c.title AS course_title " +
                "FROM study_plan_items spi " +
                "JOIN courses c ON spi.course_id = c.id " +
                "WHERE spi.user_id = ? AND spi.plan_date = CURRENT_DATE " +
                "ORDER BY spi.id";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("task", rs.getString("task_title"));
                    m.put("course", rs.getString("course_title"));
                    m.put("minutes", rs.getInt("estimated_minutes"));
                    m.put("completed", rs.getBoolean("completed"));
                    list.add(m);
                }
            }
        }

        return list;
    }

    public void addStudySession(int userId, int courseId, int minutesSpent) throws SQLException {
        String sql =
                "INSERT INTO study_sessions (user_id, course_id, minutes_spent, session_date) " +
                "VALUES (?, ?, ?, CURRENT_DATE)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, courseId);
            ps.setInt(3, minutesSpent);

            ps.executeUpdate();
        }
    }

    private int count(Connection c, String sql, int userId) throws SQLException {
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }
}