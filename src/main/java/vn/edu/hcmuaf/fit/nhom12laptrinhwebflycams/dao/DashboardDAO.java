package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import com.mysql.cj.x.protobuf.MysqlxCrud;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    // Tổng khách hàng
    public int getTotalUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tổng sản phẩm
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM products";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tổng đơn hàng
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Doanh thu tháng hiện tại
    public double getMonthlyRevenue() {
        String sql = """
            SELECT IFNULL(SUM(totalPrice),0)
            FROM orders
            WHERE MONTH(createdAt) = MONTH(CURRENT_DATE())
              AND YEAR(createdAt) = YEAR(CURRENT_DATE())
              AND status = 'Hoàn thành'
        """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public Map<String, Double> getRevenueLast30Days() {
        Map<String, Double> data = new LinkedHashMap<>();

        String sql = """
            SELECT DATE(createdAt) AS day,
                   SUM(totalPrice) AS revenue
            FROM orders
            WHERE status = 'Hoàn thành'
              AND createdAt >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
            GROUP BY DATE(createdAt)
            ORDER BY day
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                data.put(
                        rs.getString("day"),
                        rs.getDouble("revenue")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return data;
    }
    public int getUsersThisWeek() {
        String sql = """
        SELECT COUNT(*)
        FROM users
        WHERE createdAt >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public int getUsersLastWeek() {
        String sql = """
        SELECT COUNT(*)
        FROM users
        WHERE createdAt >= DATE_SUB(CURDATE(), INTERVAL 14 DAY)
          AND createdAt < DATE_SUB(CURDATE(), INTERVAL 7 DAY)
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public double getUserGrowthRate() {
        int thisWeek = getUsersThisWeek();
        int lastWeek = getUsersLastWeek();

        if (lastWeek == 0) return 100; // tránh chia cho 0

        return ((double) (thisWeek - lastWeek) / lastWeek) * 100;
    }
    public int getTotalCategories() {
        String sql = "SELECT COUNT(*) FROM categories";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public int getProcessingOrders() {
        String sql = "SELECT COUNT(*) FROM orders WHERE status = 'Đang xử lý'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public double getMonthlyTarget() {
        return 500_000_000;
    }
    public List<User> getNewUsersLast7Days() {
        List<User> list = new ArrayList<>();

        String sql = """
        SELECT fullName, phoneNumber, createdAt
        FROM users
        WHERE createdAt >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)
        ORDER BY createdAt DESC
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setFullName(rs.getString("fullName"));
                u.setPhoneNumber(rs.getString("phoneNumber"));
                u.setCreatedAt(rs.getTimestamp("createdAt"));
                list.add(u);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Orders> getRecentOrders() {
        List<Orders> list = new ArrayList<>();

        String sql = """
        SELECT o.shippingCode,
               u.fullName AS customerName,
               o.status,
               o.totalPrice
        FROM orders o
        JOIN users u ON o.user_id = u.id
        ORDER BY o.createdAt DESC
        LIMIT 10
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Orders o = new Orders();

                o.setShippingCode(rs.getString("shippingCode"));
                o.setCustomerName(rs.getString("customerName"));
                o.setTotalPrice(rs.getDouble("totalPrice"));

                String status = rs.getString("status");

                // MAP 1 LẦN DUY NHẤT
                switch (status) {
                    case "Xác nhận" -> {
                        o.setStatusLabel("Xác nhận");
                        o.setStatusClass("bg-pending");
                    }
                    case "Đang xử lý" -> {
                        o.setStatusLabel("Đang xử lý");
                        o.setStatusClass("bg-processing");
                    }
                    case "Đang giao" -> {
                        o.setStatusLabel("Đang giao");
                        o.setStatusClass("bg-shipped");
                    }
                    case "Hoàn thành" -> {
                        o.setStatusLabel("Hoàn thành");
                        o.setStatusClass("bg-complete");
                    }
                    default -> {
                        o.setStatusLabel("Hủy");
                        o.setStatusClass("bg-cancel");
                    }
                }

                list.add(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }




}
