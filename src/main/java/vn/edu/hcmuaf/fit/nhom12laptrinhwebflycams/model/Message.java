package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model;

import java.sql.Timestamp;

/**
 * Lớp đại diện cho một tin nhắn trong hệ thống chat.
 */
public class Message {
    private int id; // ID duy nhất của tin nhắn
    private int conversationId; // ID cuộc hội thoại chứa tin nhắn này
    private int sendUserId; // ID người gửi
    private int receiveUserId; // ID người nhận
    private String content; // Nội dung tin nhắn
    private Timestamp sendTime; // Thời điểm gửi tin nhắn
    private String status; // Trạng thái: SENT, READ

    public Message() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getConversationId() {
        return conversationId;
    }

    public void setConversationId(int conversationId) {
        this.conversationId = conversationId;
    }

    public int getSendUserId() {
        return sendUserId;
    }

    public void setSendUserId(int sendUserId) {
        this.sendUserId = sendUserId;
    }

    public int getReceiveUserId() {
        return receiveUserId;
    }

    public void setReceiveUserId(int receiveUserId) {
        this.receiveUserId = receiveUserId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getSendTime() {
        return sendTime;
    }

    public void setSendTime(Timestamp sendTime) {
        this.sendTime = sendTime;
    }

    /**
     * Lấy thời gian gửi dưới dạng Mili giây để JavaScript xử lý chính xác tuyệt đối.
     */
    public long getSendTimeMillis() {
        return sendTime != null ? sendTime.getTime() : 0;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
