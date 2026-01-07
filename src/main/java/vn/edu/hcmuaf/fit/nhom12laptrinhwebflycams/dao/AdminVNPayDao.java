package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.AdminVNPay;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;

public class AdminVNPayDao {

    /**
     * Lấy thông tin User theo ID
     */
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapUser(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setRoleId(rs.getInt("roleId"));
        user.setFullName(rs.getString("fullName"));
        user.setEmail(rs.getString("email"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setPhoneNumber(rs.getString("phoneNumber"));
        user.setAvatar(rs.getString("avatar"));
        user.setStatus(rs.getBoolean("status"));
        return user;
    }

    /**
     * Lấy thông tin tài khoản VNPay theo userId
     */
    public AdminVNPay getByUserId(int userId) {
        String sql = "SELECT * FROM admin_vnpay WHERE user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                AdminVNPay a = new AdminVNPay();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setAccountName(rs.getString("accountName"));
                a.setAccountNumber(rs.getString("accountNumber"));
                a.setBankName(rs.getString("bankName"));
                a.setQrCodeImage(rs.getString("qrCodeImage"));
                return a;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lưu hoặc cập nhật thông tin VNPay
     */
    public boolean saveOrUpdate(AdminVNPay bank) {
        if (bank == null || bank.getUserId() <= 0) {
            return false;
        }

        if (getByUserId(bank.getUserId()) == null) {
            return insert(bank);
        }
        return update(bank);
    }

    /* =========================
       INSERT
    ========================= */
    private boolean insert(AdminVNPay bank) {
        String sql = """
            INSERT INTO admin_vnpay
            (user_id, accountName, accountNumber, bankName, qrCodeImage)
            VALUES (?, ?, ?, ?, ?)
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bank.getUserId());
            ps.setString(2, bank.getAccountName());
            ps.setString(3, bank.getAccountNumber());
            ps.setString(4, bank.getBankName());
            ps.setString(5, bank.getQrCodeImage());

            return ps.executeUpdate() > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            System.out.println("Account number already exists: " + bank.getAccountNumber());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /* =========================
       UPDATE
    ========================= */
    private boolean update(AdminVNPay bank) {
        String sql = """
            UPDATE admin_vnpay
            SET accountName = ?,
                accountNumber = ?,
                bankName = ?,
                qrCodeImage = ?
            WHERE user_id = ?
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, bank.getAccountName());
            ps.setString(2, bank.getAccountNumber());
            ps.setString(3, bank.getBankName());
            ps.setString(4, bank.getQrCodeImage());
            ps.setInt(5, bank.getUserId());

            return ps.executeUpdate() > 0;

        } catch (SQLIntegrityConstraintViolationException e) {
            System.out.println("Account number already exists: " + bank.getAccountNumber());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}