package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model;

/**
 * Lớp đại diện cho một cuộc hội thoại giữa User và Admin.
 */
public class Conversation {
    private int id; // ID duy nhất của cuộc hội thoại
    private int participantId; // ID của khách hàng tham gia

    private String participantName; // Tên hiển thị của khách hàng
    private String participantAvatar; // Ảnh đại diện của khách hàng
    private String lastMessage; // Nội dung tin nhắn cuối cùng
    private int lastSenderId; // ID người gửi tin nhắn cuối cùng
    private String lastMessageTime; // Thời gian tin nhắn cuối (dạng Millis hoặc String)
    private boolean hasUnread; // Coi như dấu chấm xanh: True nếu có tin mới đối với Admin

    public Conversation() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getParticipantId() {
        return participantId;
    }

    public void setParticipantId(int participantId) {
        this.participantId = participantId;
    }

    public String getParticipantName() {
        return participantName;
    }

    public void setParticipantName(String participantName) {
        this.participantName = participantName;
    }

    public String getParticipantAvatar() {
        return participantAvatar;
    }

    public void setParticipantAvatar(String participantAvatar) {
        this.participantAvatar = participantAvatar;
    }

    public String getLastMessage() {
        return lastMessage;
    }

    public void setLastMessage(String lastMessage) {
        this.lastMessage = lastMessage;
    }

    public int getLastSenderId() {
        return lastSenderId;
    }

    public void setLastSenderId(int lastSenderId) {
        this.lastSenderId = lastSenderId;
    }

    public String getLastMessageTime() {
        return lastMessageTime;
    }

    public void setLastMessageTime(String lastMessageTime) {
        this.lastMessageTime = lastMessageTime;
    }

    public boolean isHasUnread() {
        return hasUnread;
    }

    public void setHasUnread(boolean hasUnread) {
        this.hasUnread = hasUnread;
    }
}
