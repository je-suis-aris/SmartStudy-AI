package com.smartstudy.dao;

import com.smartstudy.model.ChatConversation;
import com.smartstudy.model.ChatMessage;
import com.smartstudy.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatMessageDAO {

    public boolean create(ChatMessage message) throws SQLException {
        String sql =
                "INSERT INTO chat_messages " +
                "(student_id, admin_id, sender_id, sender_role, message_text, is_read, created_at) " +
                "VALUES (?, ?, ?, ?, ?, false, NOW())";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, message.getStudentId());

            if (message.getAdminId() == null) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, message.getAdminId());
            }

            ps.setInt(3, message.getSenderId());
            ps.setString(4, message.getSenderRole());
            ps.setString(5, message.getMessageText());

            return ps.executeUpdate() == 1;
        }
    }

    public List<ChatMessage> findByStudentId(int studentId) throws SQLException {
        List<ChatMessage> list = new ArrayList<>();

        String sql =
                "SELECT cm.id, cm.student_id, cm.admin_id, cm.sender_id, cm.sender_role, " +
                "       cm.message_text, cm.is_read, cm.created_at, " +
                "       u.full_name AS sender_name " +
                "FROM chat_messages cm " +
                "LEFT JOIN users u ON cm.sender_id = u.id " +
                "WHERE cm.student_id = ? " +
                "ORDER BY cm.created_at ASC, cm.id ASC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapMessage(rs));
                }
            }
        }

        return list;
    }

    public List<ChatConversation> findAllConversations() throws SQLException {
        List<ChatConversation> list = new ArrayList<>();

        String sql =
                "SELECT x.student_id, u.full_name AS student_name, u.email AS student_email, " +
                "       x.last_message, x.last_message_at, " +
                "       COALESCE(unread.unread_count, 0) AS unread_count " +
                "FROM ( " +
                "    SELECT cm.student_id, cm.message_text AS last_message, cm.created_at AS last_message_at " +
                "    FROM chat_messages cm " +
                "    INNER JOIN ( " +
                "        SELECT student_id, MAX(id) AS max_id " +
                "        FROM chat_messages " +
                "        GROUP BY student_id " +
                "    ) latest ON latest.max_id = cm.id " +
                ") x " +
                "LEFT JOIN users u ON x.student_id = u.id " +
                "LEFT JOIN ( " +
                "    SELECT student_id, COUNT(*) AS unread_count " +
                "    FROM chat_messages " +
                "    WHERE sender_role = 'STUDENT' AND is_read = false " +
                "    GROUP BY student_id " +
                ") unread ON unread.student_id = x.student_id " +
                "ORDER BY x.last_message_at DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                ChatConversation conversation = new ChatConversation();

                conversation.setStudentId(rs.getInt("student_id"));
                conversation.setStudentName(rs.getString("student_name"));
                conversation.setStudentEmail(rs.getString("student_email"));
                conversation.setLastMessage(rs.getString("last_message"));
                conversation.setLastMessageAt(rs.getString("last_message_at"));
                conversation.setUnreadCount(rs.getInt("unread_count"));

                list.add(conversation);
            }
        }

        return list;
    }

    public int countUnreadForAdmin() throws SQLException {
        String sql =
                "SELECT COUNT(*) " +
                "FROM chat_messages " +
                "WHERE sender_role = 'STUDENT' AND is_read = false";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }
        }

        return 0;
    }

    public int countUnreadForStudent(int studentId) throws SQLException {
        String sql =
                "SELECT COUNT(*) " +
                "FROM chat_messages " +
                "WHERE student_id = ? AND sender_role = 'ADMIN' AND is_read = false";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return 0;
    }

    public void markStudentMessagesAsRead(int studentId) throws SQLException {
        String sql =
                "UPDATE chat_messages " +
                "SET is_read = true " +
                "WHERE student_id = ? AND sender_role = 'STUDENT'";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.executeUpdate();
        }
    }

    public void markAdminMessagesAsReadForStudent(int studentId) throws SQLException {
        String sql =
                "UPDATE chat_messages " +
                "SET is_read = true " +
                "WHERE student_id = ? AND sender_role = 'ADMIN'";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setInt(1, studentId);
            ps.executeUpdate();
        }
    }

    private ChatMessage mapMessage(ResultSet rs) throws SQLException {
        ChatMessage message = new ChatMessage();

        message.setId(rs.getInt("id"));
        message.setStudentId(rs.getInt("student_id"));

        int adminId = rs.getInt("admin_id");
        if (rs.wasNull()) {
            message.setAdminId(null);
        } else {
            message.setAdminId(adminId);
        }

        message.setSenderId(rs.getInt("sender_id"));
        message.setSenderRole(rs.getString("sender_role"));
        message.setMessageText(rs.getString("message_text"));
        message.setRead(rs.getBoolean("is_read"));
        message.setCreatedAt(rs.getString("created_at"));
        message.setSenderName(rs.getString("sender_name"));

        return message;
    }
}