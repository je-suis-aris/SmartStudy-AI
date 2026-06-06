package com.smartstudy.dao;

import com.smartstudy.model.AiFeedback;
import com.smartstudy.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AiFeedbackDAO {

    public boolean create(AiFeedback feedback) throws SQLException {
        String sql =
                "INSERT INTO ai_feedback " +
                "(user_id, course_id, feedback_type, feedback_text, created_at) " +
                "VALUES (?, ?, ?, ?, NOW())";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, feedback.getUserId());

            if (feedback.getCourseId() == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, feedback.getCourseId());
            }

            ps.setString(3, feedback.getFeedbackType());
            ps.setString(4, feedback.getFeedbackText());

            return ps.executeUpdate() == 1;
        }
    }

    public AiFeedback findLatestByType(int userId, String feedbackType) throws SQLException {
        String sql =
                "SELECT id, user_id, course_id, feedback_type, feedback_text, created_at " +
                "FROM ai_feedback " +
                "WHERE user_id = ? AND feedback_type = ? " +
                "ORDER BY id DESC " +
                "LIMIT 1";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, feedbackType);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }

        return null;
    }

    private AiFeedback map(ResultSet rs) throws SQLException {
        AiFeedback feedback = new AiFeedback();

        feedback.setId(rs.getInt("id"));
        feedback.setUserId(rs.getInt("user_id"));

        int courseId = rs.getInt("course_id");
        if (rs.wasNull()) {
            feedback.setCourseId(null);
        } else {
            feedback.setCourseId(courseId);
        }

        feedback.setFeedbackType(rs.getString("feedback_type"));
        feedback.setFeedbackText(rs.getString("feedback_text"));
        feedback.setCreatedAt(rs.getString("created_at"));

        return feedback;
    }
}