package com.smartstudy.dao;

import com.smartstudy.model.Material;
import com.smartstudy.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class MaterialDAO {

    public boolean create(Material m) throws SQLException {

        if (m == null) {
            throw new SQLException("Material object is null.");
        }

        if (m.getUserId() <= 0) {
            throw new SQLException("Invalid user_id. Material cannot be saved without a valid user.");
        }

        if (m.getCourseId() <= 0) {
            throw new SQLException("Invalid course_id. Material cannot be saved without a valid course.");
        }

        String sql =
                "INSERT INTO materials " +
                "(user_id, course_id, discipline_id, title, material_type, content_text, ai_status, summary) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, m.getUserId());
            ps.setInt(2, m.getCourseId());

            if (m.getDisciplineId() > 0) {
                ps.setInt(3, m.getDisciplineId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }

            ps.setString(4, m.getTitle());
            ps.setString(5, m.getMaterialType());
            ps.setString(6, m.getContentText());
            ps.setString(7, m.getAiStatus());
            ps.setString(8, m.getSummary());

            System.out.println(
                    "DEBUG DAO INSERT MATERIAL -> user_id=" + m.getUserId()
                            + ", course_id=" + m.getCourseId()
                            + ", discipline_id=" + m.getDisciplineId()
                            + ", title=" + m.getTitle()
            );

            return ps.executeUpdate() == 1;
        }
    }

    public List<Material> findByUser(int userId) throws SQLException {
        List<Material> list = new ArrayList<>();

        String sql =
                "SELECT * " +
                "FROM materials " +
                "WHERE user_id = ? " +
                "ORDER BY id DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(map(rs));
                }
            }
        }

        return list;
    }

    public Material findById(int id) throws SQLException {
        String sql =
                "SELECT * " +
                "FROM materials " +
                "WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }

        return null;
    }

    public boolean updateProcessed(int id, String summary) throws SQLException {
        String sql =
                "UPDATE materials " +
                "SET ai_status = 'PROCESSED', summary = ? " +
                "WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, summary);
            ps.setInt(2, id);

            return ps.executeUpdate() == 1;
        }
    }

    private Material map(ResultSet rs) throws SQLException {
        Material m = new Material();

        m.setId(rs.getInt("id"));
        m.setUserId(rs.getInt("user_id"));
        m.setCourseId(rs.getInt("course_id"));

        int disciplineId = rs.getInt("discipline_id");

        if (rs.wasNull()) {
            disciplineId = 0;
        }

        m.setDisciplineId(disciplineId);
        m.setTitle(rs.getString("title"));
        m.setMaterialType(rs.getString("material_type"));
        m.setContentText(rs.getString("content_text"));
        m.setAiStatus(rs.getString("ai_status"));
        m.setSummary(rs.getString("summary"));

        return m;
    }
}