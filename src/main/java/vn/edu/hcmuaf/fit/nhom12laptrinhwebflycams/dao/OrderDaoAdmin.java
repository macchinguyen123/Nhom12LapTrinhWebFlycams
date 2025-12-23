package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDaoAdmin {
    public List<Orders> getPendingOrders() {
        List<Orders> list = new ArrayList<>();

        String sql = """
        SELECT o.id,
               o.shippingCode,
               o.totalPrice,
               o.status,
               o.phoneNumber,
               o.createdAt,
               o.paymentMethod,
               u.fullName
        FROM orders o
        JOIN users u ON o.user_id = u.id
        WHERE o.status = 'Xác nhận'
        ORDER BY o.createdAt DESC
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Orders o = new Orders();
                o.setId(rs.getInt("id"));
                o.setShippingCode(rs.getString("shippingCode"));
                o.setTotalPrice(rs.getDouble("totalPrice"));
                o.setPhoneNumber(rs.getString("phoneNumber"));
                o.setCreatedAt(rs.getTimestamp("createdAt"));
                o.setPaymentMethod(rs.getString("paymentMethod"));
                o.setCustomerName(rs.getString("fullName"));

                // ===== STATUS =====
                Orders.Status status = Orders.Status.fromDB(rs.getString("status"));
                o.setStatus(status);

                // ===== VIEW HELPER =====
                o.setStatusLabel("Chưa xác nhận");
                o.setStatusClass("bg-warning text-dark");

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public Map<String, Object> getOrderDetail(int orderId) {
        Map<String, Object> map = new HashMap<>();

        String sql = """
        SELECT 
            o.id,
            o.totalPrice,
            o.phoneNumber,
            o.createdAt,
            o.shippingCode,
            o.paymentMethod,
            o.note,
            o.status,
            u.fullName,
            u.email,
            a.addressLine
        FROM orders o
        JOIN users u ON o.user_id = u.id
        LEFT JOIN addresses a ON o.address_id = a.id
        WHERE o.id = ?
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                map.put("id", rs.getInt("id"));
                map.put("customerName", rs.getString("fullName"));
                map.put("email", rs.getString("email"));
                map.put("phoneNumber", rs.getString("phoneNumber"));
                map.put("totalPrice", rs.getDouble("totalPrice"));
                map.put("createdAt", rs.getTimestamp("createdAt"));
                map.put("shippingCode", rs.getString("shippingCode"));
                map.put("paymentMethod", rs.getString("paymentMethod"));
                map.put("note", rs.getString("note"));
                map.put("status", rs.getString("status"));
                map.put("address", rs.getString("addressLine"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }

    public List<Map<String, Object>> getOrderItems(int orderId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT 
            p.productName,
            oi.quantity,
            oi.price
        FROM order_items oi
        JOIN products p ON oi.product_id = p.id
        WHERE oi.order_id = ?
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            int count = 0;
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("productName", rs.getString("productName"));
                map.put("quantity", rs.getInt("quantity"));
                map.put("price", rs.getDouble("price"));
                list.add(map);
                count++;

                String productName = rs.getString("productName");
                int quantity = rs.getInt("quantity");
                double price = rs.getDouble("price");
                System.out.println("Item " + count + ": "
                        + productName + " | "
                        + quantity + " | "
                        + price);
                System.out.println("Thành công");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET `status` = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("Update orderId=" + orderId + ", status=" + status);

            ps.setString(1, status);
            ps.setInt(2, orderId);

            int rows = ps.executeUpdate();
            System.out.println("Rows affected = " + rows);

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Orders> getOrdersForAdmin() {
        List<Orders> list = new ArrayList<>();

        String sql = """
            SELECT 
                o.id,
                o.user_id,
                o.shippingCode,
                o.status,
                o.createdAt,
                CONCAT(
                    a.addressLine, ', ',
                    a.district, ', ',
                    a.province
                ) AS fullAddress
            FROM orders o
            LEFT JOIN addresses a ON o.address_id = a.id
            WHERE o.status <> 'Xác nhận'
            ORDER BY o.createdAt DESC
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Orders o = new Orders();

                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setShippingCode(rs.getString("shippingCode"));

                // map status
                Orders.Status status =
                        Orders.Status.fromDB(rs.getString("status"));
                o.setStatus(status);

                o.setCreatedAt(rs.getTimestamp("createdAt"));
                o.setFullAddress(rs.getString("fullAddress"));

                // set label + class cho view
                setStatusView(o);

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private void setStatusView(Orders o) {
        switch (o.getStatus()) {
            case PROCESSING -> {
                o.setStatusLabel("Đang xử lý");
                o.setStatusClass("bg-warning text-dark");
            }
            case OUT_FOR_DELIVERY -> {
                o.setStatusLabel("Đang giao hàng");
                o.setStatusClass("bg-primary");
            }
            case DELIVERED -> {
                o.setStatusLabel("Giao thành công");
                o.setStatusClass("bg-success");
            }
            case CANCELLED -> {
                o.setStatusLabel("Đã hủy");
                o.setStatusClass("bg-danger");
            }
            default -> {
                o.setStatusLabel("Xác nhận");
                o.setStatusClass("bg-secondary");
            }
        }
    }

}
