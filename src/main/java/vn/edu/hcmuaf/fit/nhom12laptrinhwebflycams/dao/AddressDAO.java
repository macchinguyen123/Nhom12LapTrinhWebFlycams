package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {

    public void insert(Address address) throws SQLException {
        String sql = """
        INSERT INTO addresses
        (user_id, fullName, phoneNumber, addressLine, province, district, isDefault)
        VALUES (?, ?, ?, ?, ?, ?, ?)
    """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getFullName());
            ps.setString(3, address.getPhoneNumber());
            ps.setString(4, address.getAddressLine());
            ps.setString(5, address.getProvince());
            ps.setString(6, address.getDistrict());
            ps.setBoolean(7, address.isDefaultAddress());

            ps.executeUpdate();
        }
    }


    // Lấy danh sách địa chỉ theo user
    public List<Address> findByUserId(int userId) throws SQLException {
        List<Address> list = new ArrayList<>();

        String sql = "SELECT * FROM addresses WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Address a = new Address();
                a.setId(rs.getInt("id"));
                a.setUserId(userId);
                a.setFullName(rs.getString("fullName"));
                a.setPhoneNumber(rs.getString("phoneNumber"));
                a.setAddressLine(rs.getString("addressLine"));
                a.setProvince(rs.getString("province"));
                a.setDistrict(rs.getString("district"));
                a.setDefaultAddress(rs.getBoolean("isDefault"));
                list.add(a);
            }
        }
        System.out.println("RETURN LIST SIZE = " + list.size());
        return list;
    }

    public void resetDefault(int userId) throws SQLException {
        String sql = "UPDATE addresses SET isDefault = false WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
}