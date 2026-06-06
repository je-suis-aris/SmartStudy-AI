package com.smartstudy.dao;

import com.smartstudy.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class RememberTokenDAO {

    public void createToken(int userId, String selector, String tokenHash, int daysValid) throws SQLException {
        String sql =
                "INSERT INTO remember_tokens(user_id, selector, token_hash, expires_at) " +
                "VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL ? DAY))";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, selector);
            ps.setString(3, tokenHash);
            ps.setInt(4, daysValid);

            ps.executeUpdate();
        }
    }

    public RememberToken findBySelector(String selector) throws SQLException {
        String sql =
                "SELECT id, user_id, selector, token_hash, expires_at " +
                "FROM remember_tokens " +
                "WHERE selector = ? AND expires_at > NOW()";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, selector);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    RememberToken token = new RememberToken();

                    token.setId(rs.getInt("id"));
                    token.setUserId(rs.getInt("user_id"));
                    token.setSelector(rs.getString("selector"));
                    token.setTokenHash(rs.getString("token_hash"));
                    token.setExpiresAt(rs.getString("expires_at"));

                    return token;
                }
            }
        }

        return null;
    }

    public void deleteBySelector(String selector) throws SQLException {
        String sql = "DELETE FROM remember_tokens WHERE selector = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, selector);
            ps.executeUpdate();
        }
    }

    public void deleteByUserId(int userId) throws SQLException {
        String sql = "DELETE FROM remember_tokens WHERE user_id = ?";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }

    public void deleteExpiredTokens() throws SQLException {
        String sql = "DELETE FROM remember_tokens WHERE expires_at <= NOW()";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.executeUpdate();
        }
    }

    public static class RememberToken {
        private int id;
        private int userId;
        private String selector;
        private String tokenHash;
        private String expiresAt;

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getUserId() {
            return userId;
        }

        public void setUserId(int userId) {
            this.userId = userId;
        }

        public String getSelector() {
            return selector;
        }

        public void setSelector(String selector) {
            this.selector = selector;
        }

        public String getTokenHash() {
            return tokenHash;
        }

        public void setTokenHash(String tokenHash) {
            this.tokenHash = tokenHash;
        }

        public String getExpiresAt() {
            return expiresAt;
        }

        public void setExpiresAt(String expiresAt) {
            this.expiresAt = expiresAt;
        }
    }
}