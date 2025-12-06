package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model;

import java.util.Date;

public class Orders {
    private int id;
    private int userId;
    private String shippingCode;
    private double totalPrice;
    private enum status {Pending, Processing,OutforDeliverym,Delivered,Cancelled};
    private int addressId;
    private String phoneNumber;
    private Date createdAt;
    private String paymentMethod;
    private Date completedAt;
    private String note;
}
