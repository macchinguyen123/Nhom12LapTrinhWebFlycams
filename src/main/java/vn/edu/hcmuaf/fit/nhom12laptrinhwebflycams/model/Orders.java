package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model;

import java.sql.Timestamp;

public class Orders {
    private int id;
    private int userId;
    private String shippingCode;
    private double totalPrice;
    private Status status;
    private Integer addressId;
    private String phoneNumber;
    private Timestamp createdAt;
    private String paymentMethod;
    private Timestamp completedAt;
    private String note;

    public enum Status {
        PENDING, PROCESSING, OUT_FOR_DELIVERY, DELIVERED, CANCELLED;

        // Map sang DB
        public String toDB() {
            switch (this) {
                case PENDING:
                    return "Xác nhận";
                case PROCESSING:
                    return "Đang xử lý";
                case OUT_FOR_DELIVERY:
                    return "Đang giao";
                case DELIVERED:
                    return "Hoàn thành";
                case CANCELLED:
                    return "Hủy";
                default:
                    return "Xác nhận";
            }
        }
    }

    // getter/setter
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

    public String getShippingCode() {
        return shippingCode;
    }

    public void setShippingCode(String shippingCode) {
        this.shippingCode = shippingCode;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Integer getAddressId() {
        return addressId;
    }

    public void setAddressId(Integer addressId) {
        this.addressId = addressId;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}
