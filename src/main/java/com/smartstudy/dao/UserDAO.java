package com.smartstudy.dao;

import com.smartstudy.model.User;
import com.smartstudy.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    public User login(String email, String passwordHash) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, passwordHash);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }

        return null;
    }

    public boolean create(User u) throws SQLException {
        String sql =
                "INSERT INTO users " +
                "(full_name, email, password_hash, role, description, profile_photo, " +
                "preferred_study_rhythm, learning_style, admin_request_status, admin_request_reason, admin_request_created_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, u.getFullName());
            ps.setString(2, u.getEmail());
            ps.setString(3, u.getPasswordHash());
            ps.setString(4, u.getRole());
            ps.setString(5, u.getDescription());
            ps.setString(6, u.getProfilePhoto());
            ps.setString(7, u.getPreferredStudyRhythm());
            ps.setString(8, u.getLearningStyle());
            ps.setString(9, u.getAdminRequestStatus());
            ps.setString(10, u.getAdminRequestReason());

            if ("PENDING".equalsIgnoreCase(u.getAdminRequestStatus())) {
                ps.setTimestamp(11, new Timestamp(System.currentTimeMillis()));
            } else {
                ps.setNull(11, Types.TIMESTAMP);
            }

            return ps.executeUpdate() == 1;
        }
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT id FROM users WHERE email = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<User> findAll() throws SQLException {
        List<User> list = new ArrayList<>();

        String sql = "SELECT * FROM users ORDER BY id DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }
        }

        return list;
    }

    public List<User> findPendingAdminRequests() throws SQLException {
        List<User> list = new ArrayList<>();

        String sql =
                "SELECT * FROM users " +
                "WHERE admin_request_status = 'PENDING' " +
                "ORDER BY admin_request_created_at DESC, id DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(map(rs));
            }
        }

        return list;
    }

    public boolean updateRole(int id, String role) throws SQLException {
        String sql = "UPDATE users SET role = ? WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, role);
            ps.setInt(2, id);

            return ps.executeUpdate() == 1;
        }
    }

    public boolean approveAdminRequest(int userId) throws SQLException {
        String sql =
                "UPDATE users " +
                "SET role = 'ADMIN', " +
                "admin_request_status = 'APPROVED', " +
                "admin_request_reviewed_at = NOW() " +
                "WHERE id = ? AND admin_request_status = 'PENDING'";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            return ps.executeUpdate() == 1;
        }
    }

    public boolean rejectAdminRequest(int userId) throws SQLException {
        String sql =
                "UPDATE users " +
                "SET admin_request_status = 'REJECTED', " +
                "admin_request_reviewed_at = NOW() " +
                "WHERE id = ? AND admin_request_status = 'PENDING'";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);

            return ps.executeUpdate() == 1;
        }
    }

    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, id);

            return ps.executeUpdate() == 1;
        }
    }

    public boolean updateProfile(User user) throws SQLException {
        String sql =
                "UPDATE users " +
                "SET full_name = ?, " +
                "description = ?, " +
                "profile_photo = ?, " +
                "preferred_study_rhythm = ?, " +
                "learning_style = ? " +
                "WHERE id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getDescription());
            ps.setString(3, user.getProfilePhoto());
            ps.setString(4, user.getPreferredStudyRhythm());
            ps.setString(5, user.getLearningStyle());
            ps.setInt(6, user.getId());

            return ps.executeUpdate() == 1;
        }
    }

    public User findById(int id) throws SQLException {
        String sql = "SELECT * FROM users WHERE id = ?";

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

    public boolean updatePasswordByEmail(String email, String newPasswordHash) throws SQLException {
        String sql = "UPDATE users SET password_hash = ? WHERE email = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, newPasswordHash);
            ps.setString(2, email);

            return ps.executeUpdate() == 1;
        }
    }

    private User map(ResultSet rs) throws SQLException {
        User u = new User();

        u.setId(rs.getInt("id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(rs.getString("role"));
        u.setDescription(rs.getString("description"));

        try {
            u.setProfilePhoto(rs.getString("profile_photo"));
        } catch (SQLException ignored) {
            u.setProfilePhoto(null);
        }

        try {
            u.setPreferredStudyRhythm(rs.getString("preferred_study_rhythm"));
        } catch (SQLException ignored) {
            u.setPreferredStudyRhythm("Balanced revision");
        }

        try {
            u.setLearningStyle(rs.getString("learning_style"));
        } catch (SQLException ignored) {
            u.setLearningStyle("Mixed learning");
        }

        try {
            u.setAdminRequestStatus(rs.getString("admin_request_status"));
        } catch (SQLException ignored) {
            u.setAdminRequestStatus("NONE");
        }

        try {
            u.setAdminRequestReason(rs.getString("admin_request_reason"));
        } catch (SQLException ignored) {
            u.setAdminRequestReason(null);
        }

        try {
            u.setAdminRequestCreatedAt(rs.getString("admin_request_created_at"));
        } catch (SQLException ignored) {
            u.setAdminRequestCreatedAt(null);
        }

        try {
            u.setAdminRequestReviewedAt(rs.getString("admin_request_reviewed_at"));
        } catch (SQLException ignored) {
            u.setAdminRequestReviewedAt(null);
        }

        return u;
    }
}