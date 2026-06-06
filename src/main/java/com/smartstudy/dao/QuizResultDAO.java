package com.smartstudy.dao;

import com.smartstudy.model.QuizResult;
import com.smartstudy.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class QuizResultDAO {

    public boolean create(QuizResult result) throws SQLException {
        String sql = """
                INSERT INTO quiz_results (
                    user_id,
                    course_id,
                    discipline_id,
                    score,
                    total_questions,
                    duration_seconds
                )
                VALUES (?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, result.getUserId());
            statement.setInt(2, result.getCourseId());

            if (result.getDisciplineId() > 0) {
                statement.setInt(3, result.getDisciplineId());
            } else {
                statement.setNull(3, Types.INTEGER);
            }

            statement.setInt(4, result.getScore());
            statement.setInt(5, result.getTotalQuestions());
            statement.setInt(6, result.getDurationSeconds());

            return statement.executeUpdate() == 1;
        }
    }

    public List<QuizResult> findByUser(int userId) throws SQLException {
        List<QuizResult> results = new ArrayList<>();

        String sql = """
                SELECT qr.*, c.title AS course_title
                FROM quiz_results qr
                JOIN courses c ON qr.course_id = c.id
                WHERE qr.user_id = ?
                ORDER BY qr.id DESC
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    results.add(map(resultSet));
                }
            }
        }

        return results;
    }

    public double averageScore(int userId) throws SQLException {
        String sql = """
                SELECT AVG(score / total_questions * 100) AS avg_score
                FROM quiz_results
                WHERE user_id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, userId);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? resultSet.getDouble("avg_score") : 0;
            }
        }
    }

    private QuizResult map(ResultSet resultSet) throws SQLException {
        QuizResult result = new QuizResult();

        result.setId(resultSet.getInt("id"));
        result.setUserId(resultSet.getInt("user_id"));
        result.setCourseId(resultSet.getInt("course_id"));
        result.setDisciplineId(resultSet.getInt("discipline_id"));
        result.setScore(resultSet.getInt("score"));
        result.setTotalQuestions(resultSet.getInt("total_questions"));
        result.setDurationSeconds(resultSet.getInt("duration_seconds"));
        result.setCreatedAt(resultSet.getString("created_at"));

        try {
            result.setCourseTitle(resultSet.getString("course_title"));
        } catch (SQLException ignored) {
            
        }

        return result;
    }
}