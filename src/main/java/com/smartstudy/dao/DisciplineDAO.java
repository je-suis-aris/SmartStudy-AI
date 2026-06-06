package com.smartstudy.dao;

import com.smartstudy.model.Discipline;
import com.smartstudy.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DisciplineDAO {

    public List<Discipline> findByCourse(int courseId) throws SQLException {
        List<Discipline> disciplines = new ArrayList<>();

        String sql = """
                SELECT *
                FROM disciplines
                WHERE course_id = ?
                ORDER BY title
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {

            statement.setInt(1, courseId);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    disciplines.add(map(resultSet));
                }
            }
        }

        return disciplines;
    }

    public List<Discipline> findAll() throws SQLException {
        List<Discipline> disciplines = new ArrayList<>();

        String sql = """
                SELECT *
                FROM disciplines
                ORDER BY title
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                disciplines.add(map(resultSet));
            }
        }

        return disciplines;
    }

    private Discipline map(ResultSet resultSet) throws SQLException {
        Discipline discipline = new Discipline();

        discipline.setId(resultSet.getInt("id"));
        discipline.setCourseId(resultSet.getInt("course_id"));
        discipline.setTitle(resultSet.getString("title"));
        discipline.setDescription(resultSet.getString("description"));

        return discipline;
    }
}