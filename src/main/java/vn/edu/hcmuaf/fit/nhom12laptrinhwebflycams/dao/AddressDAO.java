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

    // Thêm địa chỉ mới
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
        return list;
    }

    // Lấy địa chỉ theo id
    public Address findById(int id) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Address a = new Address();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setFullName(rs.getString("fullName"));
                a.setPhoneNumber(rs.getString("phoneNumber"));
                a.setAddressLine(rs.getString("addressLine"));
                a.setProvince(rs.getString("province"));
                a.setDistrict(rs.getString("district"));
                a.setDefaultAddress(rs.getBoolean("isDefault"));
                return a;
            }
        }
        return null;
    }

    public void resetDefault(int userId) throws SQLException {
        String sql = "UPDATE addresses SET isDefault = false WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.executeUpdate();
        }
    }
    public void delete(int id, int userId) throws SQLException {
        String sql = "DELETE FROM addresses WHERE id=? AND user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            int rows = ps.executeUpdate();
            System.out.println("DEBUG - delete address rows = " + rows);
        }
    }
    public void update(Address addr) throws SQLException {
        String sql = "UPDATE addresses SET fullName=?, phoneNumber=?, addressLine=?, province=?, district=?, isDefault=? WHERE id=? AND user_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, addr.getFullName());
            ps.setString(2, addr.getPhoneNumber());
            ps.setString(3, addr.getAddressLine());
            ps.setString(4, addr.getProvince());
            ps.setString(5, addr.getDistrict());
            ps.setBoolean(6, addr.isDefaultAddress());
            ps.setInt(7, addr.getId());
            ps.setInt(8, addr.getUserId());
            ps.executeUpdate();
        }
    }

}

