package com.smartstudy.dao;

import com.smartstudy.model.QuizMistake;
import com.smartstudy.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class QuizMistakeDAO {

    public boolean create(
            int userId,
            int courseId,
            Integer materialId,
            Integer questionId,
            String questionText,
            String selectedAnswer,
            String correctAnswer,
            String correctAnswerText,
            String explanation
    ) throws SQLException {

        String sql =
                "INSERT INTO quiz_mistakes " +
                "(user_id, course_id, material_id, question_id, question_text, selected_answer, correct_answer, correct_answer_text, explanation, resolved, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, false, NOW())";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, courseId);

            if (materialId == null || materialId <= 0) {
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(3, materialId);
            }

            if (questionId == null || questionId <= 0) {
                ps.setNull(4, Types.INTEGER);
            } else {
                ps.setInt(4, questionId);
            }

            ps.setString(5, questionText);
            ps.setString(6, selectedAnswer);
            ps.setString(7, correctAnswer);
            ps.setString(8, correctAnswerText);
            ps.setString(9, explanation);

            return ps.executeUpdate() == 1;
        }
    }

    public List<QuizMistake> findRecentUnresolvedByUser(int userId, int limit) throws SQLException {
        List<QuizMistake> list = new ArrayList<>();

        String sql =
                "SELECT * FROM quiz_mistakes " +
                "WHERE user_id = ? AND resolved = false " +
                "ORDER BY created_at DESC, id DESC " +
                "LIMIT ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    QuizMistake m = new QuizMistake();

                    m.setId(rs.getInt("id"));
                    m.setUserId(rs.getInt("user_id"));
                    m.setCourseId(rs.getInt("course_id"));

                    int materialId = rs.getInt("material_id");
                    if (!rs.wasNull()) {
                        m.setMaterialId(materialId);
                    }

                    int questionId = rs.getInt("question_id");
                    if (!rs.wasNull()) {
                        m.setQuestionId(questionId);
                    }

                    m.setQuestionText(rs.getString("question_text"));
                    m.setSelectedAnswer(rs.getString("selected_answer"));
                    m.setCorrectAnswer(rs.getString("correct_answer"));
                    m.setCorrectAnswerText(rs.getString("correct_answer_text"));
                    m.setExplanation(rs.getString("explanation"));
                    m.setResolved(rs.getBoolean("resolved"));
                    m.setCreatedAt(rs.getString("created_at"));

                    list.add(m);
                }
            }
        }

        return list;
    }

    public void markAsResolvedForUser(int userId) throws SQLException {
        String sql =
                "UPDATE quiz_mistakes " +
                "SET resolved = true " +
                "WHERE user_id = ? AND resolved = false";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}