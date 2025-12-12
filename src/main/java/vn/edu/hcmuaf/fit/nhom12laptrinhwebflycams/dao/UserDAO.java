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

        String sql = "INSERT INTO users (roleId, fullName, birthDate, gender, email, username, password, phoneNumber, avatar, status, createdAt, updatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getFullName());

            // birthDate
            if (user.getBirthDate() != null) {
                ps.setDate(3, new java.sql.Date(user.getBirthDate().getTime()));
            } else {
                ps.setNull(3, Types.DATE);
            }

            // gender
            ps.setString(4, user.getGender() == null ? "OTHER" : user.getGender());

            ps.setString(5, user.getEmail());
            ps.setString(6, user.getUsername());
            ps.setString(7, user.getPassword());
            ps.setString(8, user.getPhoneNumber());

            // avatar
            ps.setString(9, user.getAvatar() == null ? "default.png" : user.getAvatar());

            ps.setBoolean(10, user.isStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }




    public boolean isUsernameExists(String username) {
        String sql = "SELECT id FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            return rs.next(); // nếu có → username đã tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean isEmailExists(String email) {
        String sql = "SELECT id FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            return rs.next(); // nếu có dòng → email đã tồn tại
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }





}
