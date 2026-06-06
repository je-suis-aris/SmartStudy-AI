package com.smartstudy.dao;

import com.smartstudy.model.Flashcard;
import com.smartstudy.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class FlashcardDAO {

    public boolean create(
            int userId,
            int courseId,
            int materialId,
            String frontText,
            String backText
    ) throws SQLException {

        return create(
                userId,
                courseId,
                materialId,
                frontText,
                backText,
                "AI",
                null
        );
    }

    public boolean create(
            int userId,
            int courseId,
            int materialId,
            String frontText,
            String backText,
            String generationSource,
            String generationBatch
    ) throws SQLException {

        String sql =
                "INSERT INTO flashcards " +
                "(user_id, course_id, material_id, front_text, back_text, generation_source, generation_batch, created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, courseId);

            if (materialId <= 0) {
                ps.setNull(3, Types.INTEGER);
            } else {
                ps.setInt(3, materialId);
            }

            ps.setString(4, frontText);
            ps.setString(5, backText);
            ps.setString(6, generationSource == null ? "AI" : generationSource);
            ps.setString(7, generationBatch);

            return ps.executeUpdate() == 1;
        }
    }

    public List<Flashcard> findByUser(int userId) throws SQLException {
        List<Flashcard> list = new ArrayList<>();

        String sql =
                "SELECT f.id, f.user_id, f.course_id, f.material_id, " +
                "       f.front_text, f.back_text, f.created_at, " +
                "       f.generation_source, f.generation_batch, " +
                "       c.title AS course_title, " +
                "       m.title AS material_title " +
                "FROM flashcards f " +
                "LEFT JOIN courses c ON f.course_id = c.id " +
                "LEFT JOIN materials m ON f.material_id = m.id " +
                "WHERE f.user_id = ? " +
                "ORDER BY f.created_at DESC, f.id DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapFlashcard(rs));
                }
            }
        }

        return list;
    }

    public List<Flashcard> findByUserAndMaterial(int userId, int materialId) throws SQLException {
        List<Flashcard> list = new ArrayList<>();

        String sql =
                "SELECT f.id, f.user_id, f.course_id, f.material_id, " +
                "       f.front_text, f.back_text, f.created_at, " +
                "       f.generation_source, f.generation_batch, " +
                "       c.title AS course_title, " +
                "       m.title AS material_title " +
                "FROM flashcards f " +
                "LEFT JOIN courses c ON f.course_id = c.id " +
                "LEFT JOIN materials m ON f.material_id = m.id " +
                "WHERE f.user_id = ? AND f.material_id = ? " +
                "ORDER BY f.created_at DESC, f.id DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, materialId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapFlashcard(rs));
                }
            }
        }

        return list;
    }

    public List<String> findBatchesByUser(int userId) throws SQLException {
        List<String> batches = new ArrayList<>();

        String sql =
                "SELECT DISTINCT generation_batch " +
                "FROM flashcards " +
                "WHERE user_id = ? AND generation_batch IS NOT NULL " +
                "ORDER BY generation_batch DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    batches.add(rs.getString("generation_batch"));
                }
            }
        }

        return batches;
    }

    private Flashcard mapFlashcard(ResultSet rs) throws SQLException {
        Flashcard f = new Flashcard();

        f.setId(rs.getInt("id"));
        f.setUserId(rs.getInt("user_id"));
        f.setCourseId(rs.getInt("course_id"));

        int materialId = rs.getInt("material_id");
        if (!rs.wasNull()) {
            f.setMaterialId(materialId);
        }

        f.setFrontText(rs.getString("front_text"));
        f.setBackText(rs.getString("back_text"));
        f.setCreatedAt(rs.getString("created_at"));

        f.setCourseTitle(rs.getString("course_title"));
        f.setMaterialTitle(rs.getString("material_title"));

        try {
            f.setGenerationSource(rs.getString("generation_source"));
        } catch (Exception ignored) {
            f.setGenerationSource("AI");
        }

        try {
            f.setGenerationBatch(rs.getString("generation_batch"));
        } catch (Exception ignored) {
            f.setGenerationBatch(null);
        }

        return f;
    }
}