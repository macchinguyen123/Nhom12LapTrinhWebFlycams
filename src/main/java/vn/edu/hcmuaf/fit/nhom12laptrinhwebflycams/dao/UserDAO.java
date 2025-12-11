package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;

public class UserDAO {

    public User login(String input, String password) {
        String sql = "SELECT * FROM users WHERE (email = ? OR phoneNumber = ?) AND password = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, input);
            ps.setString(2, input);
            ps.setString(3, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setRoleId(rs.getInt("roleId"));
                user.setFullName(rs.getString("fullName"));
                user.setEmail(rs.getString("email"));
                user.setUsername(rs.getString("username"));
                user.setPhoneNumber(rs.getString("phoneNumber"));
                user.setAvatar(rs.getString("avatar"));
                user.setStatus(rs.getBoolean("status"));
                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    public boolean insertUser(User user) {
        String sql = "INSERT INTO users (roleId, fullName, birthDate, email, username, password, phoneNumber, status, createdAt, updatedAt)\n" +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())\n";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getFullName());
            ps.setDate(3, new java.sql.Date(user.getBirthDate().getTime()));
            ps.setString(4, user.getEmail());
            ps.setString(5, user.getUsername());
            ps.setString(6, user.getPassword());
            ps.setString(7, user.getPhoneNumber());
            ps.setBoolean(8, user.isStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


}
