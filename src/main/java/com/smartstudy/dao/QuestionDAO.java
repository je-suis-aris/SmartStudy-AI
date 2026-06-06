package com.smartstudy.dao;

import com.smartstudy.model.Question;
import com.smartstudy.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class QuestionDAO {

    public boolean create(Question question) throws SQLException {
        String sql = """
                INSERT INTO questions (
                    course_id,
                    discipline_id,
                    material_id,
                    question_text,
                    option_a,
                    option_b,
                    option_c,
                    option_d,
                    correct_answer,
                    explanation,
                    generated_by_ai
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, question.getCourseId());

            if (question.getDisciplineId() > 0) {
                statement.setInt(2, question.getDisciplineId());
            } else {
                statement.setNull(2, Types.INTEGER);
            }

            if (question.getMaterialId() > 0) {
                statement.setInt(3, question.getMaterialId());
            } else {
                statement.setNull(3, Types.INTEGER);
            }

            statement.setString(4, question.getQuestionText());
            statement.setString(5, question.getOptionA());
            statement.setString(6, question.getOptionB());
            statement.setString(7, question.getOptionC());
            statement.setString(8, question.getOptionD());
            statement.setString(9, question.getCorrectAnswer());
            statement.setString(10, question.getExplanation());
            statement.setBoolean(11, question.isGeneratedByAi());

            return statement.executeUpdate() == 1;
        }
    }

    public List<Question> findByCourse(int courseId, int limit) throws SQLException {
        List<Question> questions = new ArrayList<>();

        String sql = """
                SELECT *
                FROM questions
                WHERE course_id = ?
                ORDER BY RAND()
                LIMIT ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, courseId);
            statement.setInt(2, limit);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    questions.add(map(resultSet));
                }
            }
        }

        return questions;
    }

    public List<Question> findAll() throws SQLException {
        List<Question> questions = new ArrayList<>();

        String sql = """
                SELECT *
                FROM questions
                ORDER BY id DESC
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                questions.add(map(resultSet));
            }
        }

        return questions;
    }

    public Question findById(int id) throws SQLException {
        String sql = """
                SELECT *
                FROM questions
                WHERE id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, id);

            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() ? map(resultSet) : null;
            }
        }
    }

    private Question map(ResultSet resultSet) throws SQLException {
        Question question = new Question();

        question.setId(resultSet.getInt("id"));
        question.setCourseId(resultSet.getInt("course_id"));
        question.setDisciplineId(resultSet.getInt("discipline_id"));
        question.setMaterialId(resultSet.getInt("material_id"));
        question.setQuestionText(resultSet.getString("question_text"));
        question.setOptionA(resultSet.getString("option_a"));
        question.setOptionB(resultSet.getString("option_b"));
        question.setOptionC(resultSet.getString("option_c"));
        question.setOptionD(resultSet.getString("option_d"));
        question.setCorrectAnswer(resultSet.getString("correct_answer"));
        question.setExplanation(resultSet.getString("explanation"));
        question.setGeneratedByAi(resultSet.getBoolean("generated_by_ai"));

        return question;
    }
}