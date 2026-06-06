package com.smartstudy.dao;

import com.smartstudy.model.Course;
import com.smartstudy.util.DBConnection;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {

    public List<Course> findByUser(int userId) throws Exception {
        List<Course> courses = new ArrayList<>();

        String sql =
                "SELECT * FROM courses " +
                "WHERE user_id = ? OR user_id IS NULL " +
                "ORDER BY id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    courses.add(mapCourse(rs));
                }
            }
        }

        return courses;
    }

    public List<Course> findAll() throws SQLException {
        List<Course> courses = new ArrayList<>();

        String sql = "SELECT * FROM courses ORDER BY created_at DESC, id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                courses.add(mapCourse(rs));
            }
        }

        return courses;
    }

    public Course findById(int id) throws SQLException {
        String sql = "SELECT * FROM courses WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapCourse(rs);
                }
            }
        }

        return null;
    }

    public int findOrCreateByUserAndTitle(int userId, String title) throws Exception {
        if (title == null || title.trim().isEmpty()) {
            title = "General Course";
        }

        title = title.trim();

        String findSql =
                "SELECT id FROM courses " +
                "WHERE user_id = ? AND LOWER(title) = LOWER(?) " +
                "LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(findSql)) {

            ps.setInt(1, userId);
            ps.setString(2, title);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        }

        Course course = new Course();
        course.setUserId(userId);
        course.setTitle(title);
        course.setDescription("Course created from uploaded material");
        course.setDifficulty("MEDIUM");
        course.setExamDate(java.time.LocalDate.of(2026, 6, 20));

        return createAndReturnId(course);
    }

    public boolean create(Course course) throws SQLException {
        String sql =
                "INSERT INTO courses (user_id, title, description, exam_date, difficulty, created_at) " +
                "VALUES (?, ?, ?, ?, ?, NOW())";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (course.getUserId() <= 0) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, course.getUserId());
            }

            ps.setString(2, course.getTitle());
            ps.setString(3, course.getDescription());

            if (course.getExamDate() != null) {
                ps.setDate(4, Date.valueOf(course.getExamDate()));
            } else {
                ps.setNull(4, Types.DATE);
            }

            if (course.getDifficulty() != null && !course.getDifficulty().trim().isEmpty()) {
                ps.setString(5, course.getDifficulty());
            } else {
                ps.setString(5, "MEDIUM");
            }

            return ps.executeUpdate() == 1;
        }
    }

    public int createAndReturnId(Course course) throws SQLException {
        String sql =
                "INSERT INTO courses (user_id, title, description, exam_date, difficulty, created_at) " +
                "VALUES (?, ?, ?, ?, ?, NOW())";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (course.getUserId() <= 0) {
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, course.getUserId());
            }

            ps.setString(2, course.getTitle());
            ps.setString(3, course.getDescription());

            if (course.getExamDate() != null) {
                ps.setDate(4, Date.valueOf(course.getExamDate()));
            } else {
                ps.setNull(4, Types.DATE);
            }

            if (course.getDifficulty() != null && !course.getDifficulty().trim().isEmpty()) {
                ps.setString(5, course.getDifficulty());
            } else {
                ps.setString(5, "MEDIUM");
            }

            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        }

        throw new SQLException("Course could not be created.");
    }

    public boolean update(Course course) throws SQLException {
        String sql =
                "UPDATE courses " +
                "SET title = ?, description = ?, exam_date = ?, difficulty = ? " +
                "WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, course.getTitle());
            ps.setString(2, course.getDescription());

            if (course.getExamDate() != null) {
                ps.setDate(3, Date.valueOf(course.getExamDate()));
            } else {
                ps.setNull(3, Types.DATE);
            }

            if (course.getDifficulty() != null && !course.getDifficulty().trim().isEmpty()) {
                ps.setString(4, course.getDifficulty());
            } else {
                ps.setString(4, "MEDIUM");
            }

            ps.setInt(5, course.getId());

            return ps.executeUpdate() == 1;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM courses WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() == 1;
        }
    }

    private Course mapCourse(ResultSet rs) throws SQLException {
        Course course = new Course();

        course.setId(rs.getInt("id"));

        int userId = rs.getInt("user_id");
        if (rs.wasNull()) {
            course.setUserId(0);
        } else {
            course.setUserId(userId);
        }

        course.setTitle(rs.getString("title"));
        course.setDescription(rs.getString("description"));

        Date examDate = rs.getDate("exam_date");
        if (examDate != null) {
            course.setExamDate(examDate.toLocalDate());
        }

        try {
            course.setDifficulty(rs.getString("difficulty"));
        } catch (Exception ignored) {
            course.setDifficulty("MEDIUM");
        }

        return course;
    }
}