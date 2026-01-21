package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {

    // INSERT - Mặc định is_active = 1
    public boolean insert(Address address) throws SQLException {
        String sql = """
            INSERT INTO addresses
            (user_id, fullName, phoneNumber, addressLine, province, district, isDefault, is_active)
            VALUES (?, ?, ?, ?, ?, ?, ?, 1)
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
            return ps.executeUpdate() > 0;
        }
    }

    // INSERT và trả về ID
    public int insertID(Address address) throws SQLException {
        String sql = """
        INSERT INTO addresses
        (user_id, fullName, phoneNumber, addressLine, province, district, isDefault, is_active)
        VALUES (?, ?, ?, ?, ?, ?, ?, 1)
    """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getFullName());
            ps.setString(3, address.getPhoneNumber());
            ps.setString(4, address.getAddressLine());
            ps.setString(5, address.getProvince());
            ps.setString(6, address.getDistrict());
            ps.setBoolean(7, address.isDefaultAddress());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                return -1;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return -1;
    }

    // Lấy tất cả địa chỉ ĐANG HOẠT ĐỘNG của user
    public List<Address> findByUserId(int userId) throws SQLException {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAddress(rs));
                }
            }
        }
        return list;
    }

    // Tìm địa chỉ theo ID (chỉ lấy nếu đang hoạt động)
    public Address findById(int id) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE id = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToAddress(rs);
            }
        }
        return null;
    }

    // Tìm địa chỉ theo ID và userId (bảo mật hơn)
    public Address findByIdAndUserId(int id, int userId) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE id = ? AND user_id = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToAddress(rs);
            }
        }
        return null;
    }

    // Lấy địa chỉ mặc định của user
    public Address getDefaultAddress(int userId) throws SQLException {
        String sql = "SELECT * FROM addresses WHERE user_id = ? AND isDefault = 1 AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapResultSetToAddress(rs);
            }
        }
        return null;
    }

    // Reset tất cả địa chỉ của user về không mặc định
    public boolean resetDefault(int userId) throws SQLException {
        String sql = "UPDATE addresses SET isDefault = 0 WHERE user_id = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() >= 0; // Có thể không có địa chỉ nào
        }
    }

    // XÓA MỀM - Đánh dấu is_active = 0
    public boolean delete(int id, int userId) throws SQLException {
        String sql = "UPDATE addresses SET is_active = 0 WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // CẬP NHẬT địa chỉ (chỉ cập nhật nếu đang hoạt động)
    public boolean update(Address addr) throws SQLException {
        String sql = """
            UPDATE addresses 
            SET fullName=?, phoneNumber=?, addressLine=?, province=?, district=?, isDefault=? 
            WHERE id=? AND user_id=? AND is_active = 1
        """;
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
            return ps.executeUpdate() > 0;
        }
    }

    // ĐẾM số lượng địa chỉ đang hoạt động của user
    public int countActiveAddresses(int userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM addresses WHERE user_id = ? AND is_active = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    // KHÔI PHỤC địa chỉ đã xóa (tùy chọn)
    public boolean restore(int id, int userId) throws SQLException {
        String sql = "UPDATE addresses SET is_active = 1 WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        }
    }

    // XÓA CỨNG - Chỉ dùng khi thực sự cần thiết (admin)
    public boolean hardDelete(int id) throws SQLException {
        String sql = "DELETE FROM addresses WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // Lấy tất cả địa chỉ (bao gồm cả đã xóa) - cho admin
    public List<Address> findAllByUserId(int userId) throws SQLException {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToAddress(rs));
                }
            }
        }
        return list;
    }

    // MAP ResultSet sang Object
    private Address mapResultSetToAddress(ResultSet rs) throws SQLException {
        Address a = new Address();
        a.setId(rs.getInt("id"));
        a.setUserId(rs.getInt("user_id"));
        a.setFullName(rs.getString("fullName"));
        a.setPhoneNumber(rs.getString("phoneNumber"));
        a.setAddressLine(rs.getString("addressLine"));
        a.setProvince(rs.getString("province"));
        a.setDistrict(rs.getString("district"));
        a.setDefaultAddress(rs.getBoolean("isDefault"));
        // Nếu model Address có trường isActive thì thêm:
        // a.setActive(rs.getBoolean("is_active"));
        return a;
    }
}