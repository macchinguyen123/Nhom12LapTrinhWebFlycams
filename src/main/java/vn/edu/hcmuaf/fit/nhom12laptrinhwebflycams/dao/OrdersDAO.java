package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrdersDAO {

    public int insert(Orders order) throws SQLException {
        String sql = "INSERT INTO orders " +
                "(user_id, shippingCode, totalPrice, status, address_id, phoneNumber, createdAt, paymentMethod, note) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setString(2, order.getShippingCode());
            ps.setDouble(3, order.getTotalPrice());
            ps.setString(4, order.getStatus().toDB());

            if (order.getAddressId() != null) {
                ps.setInt(5, order.getAddressId());
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }

            ps.setString(6, order.getPhoneNumber());
            ps.setTimestamp(7, order.getCreatedAt());
            ps.setString(8, order.getPaymentMethod());
            ps.setString(9, order.getNote());

            int affected = ps.executeUpdate();
            if (affected == 0) throw new SQLException("Insert order failed");

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    private Orders.Status mapStatus(String dbStatus) {
        return switch (dbStatus) {
            case "Xác nhận" -> Orders.Status.PENDING;
            case "Đang xử lý" -> Orders.Status.PROCESSING;
            case "Đang giao" -> Orders.Status.OUT_FOR_DELIVERY;
            case "Hoàn thành" -> Orders.Status.DELIVERED;
            case "Hủy" -> Orders.Status.CANCELLED;
            default -> Orders.Status.PENDING;
        };
    }

    public List<Orders> getOrdersByUser(int userId) {
        List<Orders> list = new ArrayList<>();

        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY createdAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Orders o = new Orders();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setShippingCode(rs.getString("shippingCode"));
                o.setTotalPrice(rs.getDouble("totalPrice"));
                o.setStatus(Orders.Status.fromDB(rs.getString("status")));
                o.setPhoneNumber(rs.getString("phoneNumber"));
                o.setPaymentMethod(rs.getString("paymentMethod"));
                o.setCreatedAt(rs.getTimestamp("createdAt"));
                o.setCompletedAt(rs.getTimestamp("completedAt"));
                o.setNote(rs.getString("note"));
                int addr = rs.getInt("address_id");
                o.setAddressId(rs.wasNull() ? null : addr);

                list.add(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public Orders getOrderById(int orderId, int userId) {
        String sql = "SELECT * FROM orders WHERE id = ? AND user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, userId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Orders o = new Orders();
                o.setId(rs.getInt("id"));
                o.setUserId(rs.getInt("user_id"));
                o.setShippingCode(rs.getString("shippingCode"));
                o.setTotalPrice(rs.getDouble("totalPrice"));
                o.setStatus(mapStatus(rs.getString("status")));
                int addr = rs.getInt("address_id");
                o.setAddressId(rs.wasNull() ? null : addr);
                o.setPhoneNumber(rs.getString("phoneNumber"));
                o.setCreatedAt(rs.getTimestamp("createdAt"));
                o.setPaymentMethod(rs.getString("paymentMethod"));
                o.setCompletedAt(rs.getTimestamp("completedAt"));
                o.setNote(rs.getString("note"));

                return o;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }


    public Map<String, String> getShippingInfoByOrder(int orderId) {
        Map<String, String> map = new HashMap<>();

        String sql = """
        SELECT 
            o.phoneNumber,
            COALESCE(a.fullName, 'Không xác định') AS recipientName,
            COALESCE(
                CONCAT(a.addressLine, ', ', a.district, ', ', a.province),
                'Không có địa chỉ'
            ) AS shippingAddress
        FROM orders o
        LEFT JOIN addresses a ON o.address_id = a.id
        WHERE o.id = ?
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                map.put("receiverPhone", rs.getString("phoneNumber"));
                map.put("recipientName", rs.getString("recipientName"));
                map.put("shippingAddress", rs.getString("shippingAddress"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;
    }

    public List<OrderItems> getOrderItems(int orderId) {
        List<OrderItems> list = new ArrayList<>();

        String sql = """
        SELECT
            oi.id AS oi_id,
            oi.product_id,
            oi.order_id,
            oi.quantity,
            oi.price,
            p.productName,
            COALESCE(
                (SELECT img.imageUrl 
                 FROM images img 
                 WHERE img.product_id = p.id 
                 ORDER BY img.id ASC 
                 LIMIT 1),
                'image/products/no-image.png'
            ) AS imageUrl
        FROM order_items oi
        JOIN products p ON oi.product_id = p.id
        WHERE oi.order_id = ?
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderItems item = new OrderItems();
                item.setId(rs.getInt("oi_id"));
                item.setOrderId(rs.getInt("order_id"));
                item.setProductId(rs.getInt("product_id"));
                item.setQuantity(rs.getInt("quantity"));
                item.setPrice(rs.getDouble("price"));

                Product product = new Product();
                product.setId(rs.getInt("product_id"));
                product.setProductName(rs.getString("productName"));

                // ✅ LẤY imageUrl và IN RA ĐỂ DEBUG
                String imageUrl = rs.getString("imageUrl");
                System.out.println("🖼️ Product ID: " + product.getId() + " → Image: " + imageUrl);

                product.setMainImage(imageUrl);

                item.setProduct(product);
                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void cancelOrder(int orderId, int userId) {
        String sql = """
        UPDATE orders
        SET status = 'Hủy'
        WHERE id = ?
          AND user_id = ?
          AND status = 'Xác nhận'
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getRecipientNameByOrder(int orderId) {
        String sql = """
        SELECT COALESCE(a.fullName, 'Không xác định') AS fullName
        FROM orders o
        LEFT JOIN addresses a ON o.address_id = a.id
        WHERE o.id = ?
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("fullName");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Không xác định";
    }

    public String getFullAddressByOrder(int orderId) {
        String sql = """
        SELECT 
            COALESCE(
                CONCAT(a.addressLine, ', ', a.district, ', ', a.province),
                'Không có địa chỉ'
            ) AS fullAddress
        FROM orders o
        LEFT JOIN addresses a ON o.address_id = a.id
        WHERE o.id = ?
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("fullAddress");

        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Không có địa chỉ";
    }
    /**
     * Kiểm tra xem user đã mua sản phẩm này chưa
     * @param userId ID của user
     * @param productId ID của sản phẩm
     * @return true nếu đã mua, false nếu chưa
     */
    public boolean hasUserPurchasedProduct(int userId, int productId) {
        String sql = """
            SELECT COUNT(*) > 0
            FROM orders o
            JOIN order_items oi ON o.id = oi.order_id
            WHERE o.user_id = ? 
              AND oi.product_id = ?
              AND o.status IN ('Đang xử lý', 'Đang giao', 'Hoàn thành')
            """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBoolean(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

}
