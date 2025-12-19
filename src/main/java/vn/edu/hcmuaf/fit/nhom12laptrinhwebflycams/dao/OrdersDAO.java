package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;

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

}
