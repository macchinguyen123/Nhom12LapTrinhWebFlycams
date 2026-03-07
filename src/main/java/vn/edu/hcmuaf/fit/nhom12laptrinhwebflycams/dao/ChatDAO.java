package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Conversation;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Message;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Lớp truy xuất dữ liệu (DAO) cho các tính năng liên quan đến Chat.
 */
public class ChatDAO {

    /**
     * Lấy cuộc hội thoại hiện có hoặc tạo mới nếu chưa tồn tại cho khách hàng.
     */
    public Conversation getOrCreateConversation(int participantId) {
        String selectSql = "SELECT * FROM conversations WHERE participantId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(selectSql)) {
            ps.setInt(1, participantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Conversation c = new Conversation();
                c.setId(rs.getInt("id"));
                c.setParticipantId(rs.getInt("participantId"));
                return c;
            } else {
                // Tạo mới cuộc hội thoại nếu khách hàng lần đầu nhắn tin
                String insertSql = "INSERT INTO conversations (participantId) VALUES (?)";
                try (PreparedStatement psInsert = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                    psInsert.setInt(1, participantId);
                    psInsert.executeUpdate();
                    ResultSet rsKey = psInsert.getGeneratedKeys();
                    if (rsKey.next()) {
                        Conversation c = new Conversation();
                        c.setId(rsKey.getInt(1));
                        c.setParticipantId(participantId);
                        return c;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lưu tin nhắn vào cơ sở dữ liệu.
     */
    public boolean saveMessage(Message msg) {
        String sql = "INSERT INTO messages (conversationId, sendUserId, receiveUserId, content, sendTime, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, msg.getConversationId());
            ps.setInt(2, msg.getSendUserId());
            ps.setInt(3, msg.getReceiveUserId());
            ps.setString(4, msg.getContent());
            // Sử dụng thời gian hiện hành của Server Java thay vì NOW() để đồng bộ với millisecond serializer
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.setString(6, msg.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Lấy tất cả tin nhắn của một cuộc hội thoại.
     */
    public List<Message> getMessages(int conversationId) {
        List<Message> list = new ArrayList<>();
        String sql = "SELECT * FROM messages WHERE conversationId = ? ORDER BY sendTime ASC, id ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Message m = new Message();
                m.setId(rs.getInt("id"));
                m.setConversationId(rs.getInt("conversationId"));
                m.setSendUserId(rs.getInt("sendUserId"));
                m.setReceiveUserId(rs.getInt("receiveUserId"));
                m.setContent(rs.getString("content"));
                // Timestamp gốc sẽ được Gson Serializer xử lý thành Millis sau đó
                m.setSendTime(rs.getTimestamp("sendTime"));
                m.setStatus(rs.getString("status"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Lấy danh sách hội thoại cho Admin, bao gồm tin nhắn cuối và đếm tin chưa đọc.
     */
    public List<Conversation> getAdminConversations() {
        List<Conversation> list = new ArrayList<>();
        // Đếm tin nhắn từ khách hàng (sendUserId = c.participantId) mà trạng thái vẫn là 'SENT'
        String sql = "SELECT c.*, u.fullName, u.avatar, " +
                "(SELECT content FROM messages WHERE conversationId = c.id ORDER BY id DESC LIMIT 1) as lastMsg, " +
                "(SELECT sendTime FROM messages WHERE conversationId = c.id ORDER BY id DESC LIMIT 1) as lastTime, " +
                "(SELECT sendUserId FROM messages WHERE conversationId = c.id ORDER BY id DESC LIMIT 1) as lastSenderId, " +
                "(SELECT COUNT(*) FROM messages WHERE conversationId = c.id AND status = 'SENT' AND sendUserId = c.participantId) as unreadCount " +
                "FROM conversations c " +
                "JOIN users u ON c.participantId = u.id " +
                "WHERE u.roleId != 1 AND EXISTS (SELECT 1 FROM messages WHERE conversationId = c.id) " +
                "ORDER BY (SELECT MAX(id) FROM messages WHERE conversationId = c.id) DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Conversation c = new Conversation();
                c.setId(rs.getInt("id"));
                c.setParticipantId(rs.getInt("participantId"));
                c.setParticipantName(rs.getString("fullName"));
                c.setParticipantAvatar(rs.getString("avatar"));
                c.setLastMessage(rs.getString("lastMsg"));
                c.setLastSenderId(rs.getInt("lastSenderId"));
                Timestamp t = rs.getTimestamp("lastTime");
                c.setLastMessageTime(t != null ? String.valueOf(t.getTime()) : "");
                c.setHasUnread(rs.getInt("unreadCount") > 0);
                list.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đánh dấu tin nhắn trong cuộc hội thoại là đã đọc.
     */
    public void markAsRead(int conversationId, int readerId) {
        // Đánh dấu tất cả tin nhắn gửi ĐẾN người đọc hiện tại (hoặc gửi đến Admin nếu readerId là Admin) là READ
        // Tuy nhiên cách đơn giản nhất cho Messenger logic: Đánh dấu mọi tin nhắn của đối phương là READ
        String sql = "UPDATE messages SET status = 'READ' " +
                "WHERE conversationId = ? AND status = 'SENT' AND sendUserId != ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, conversationId);
            ps.setInt(2, readerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Đếm tổng số tin nhắn chưa đọc của một người dùng.
     */
    public int getUnreadCountForUser(int userId) {
        String sql = "SELECT COUNT(*) FROM messages " +
                "WHERE receiveUserId = ? AND status = 'SENT'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
}


