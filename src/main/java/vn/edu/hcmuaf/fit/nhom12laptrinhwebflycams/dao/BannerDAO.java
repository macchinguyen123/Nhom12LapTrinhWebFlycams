package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Banner;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BannerDAO extends DBConnection {

    // Lấy tất cả banner
    public List<Banner> getAllBanners() {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM banner ORDER BY order_index ASC, id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Banner b = new Banner(
                        rs.getInt("id"),
                        rs.getString("type"),
                        rs.getString("image_url"),
                        rs.getString("video_url"),
                        rs.getString("link"),
                        rs.getInt("order_index"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy banner theo trạng thái
    public List<Banner> getBannersByStatus(String status) {
        List<Banner> list = new ArrayList<>();
        String sql = "SELECT * FROM banner WHERE status = ? ORDER BY order_index ASC, id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Banner b = new Banner(
                        rs.getInt("id"),
                        rs.getString("type"),
                        rs.getString("image_url"),
                        rs.getString("video_url"),
                        rs.getString("link"),
                        rs.getInt("order_index"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
                list.add(b);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy banner theo ID
    public Banner getBannerById(int id) {
        String sql = "SELECT * FROM banner WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Banner(
                        rs.getInt("id"),
                        rs.getString("type"),
                        rs.getString("image_url"),
                        rs.getString("video_url"),
                        rs.getString("link"),
                        rs.getInt("order_index"),
                        rs.getString("status"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Thêm banner mới
    public boolean addBanner(Banner banner) {
        String sql = "INSERT INTO banner (type, image_url, video_url, link, order_index, status) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, banner.getType());
            ps.setString(2, banner.getImageUrl());
            ps.setString(3, banner.getVideoUrl());
            ps.setString(4, banner.getLink());
            ps.setInt(5, banner.getOrderIndex());
            ps.setString(6, banner.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật banner
    public boolean updateBanner(Banner banner) {
        String sql = "UPDATE banner SET type = ?, image_url = ?, video_url = ?, " +
                "link = ?, order_index = ?, status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, banner.getType());
            ps.setString(2, banner.getImageUrl());
            ps.setString(3, banner.getVideoUrl());
            ps.setString(4, banner.getLink());
            ps.setInt(5, banner.getOrderIndex());
            ps.setString(6, banner.getStatus());
            ps.setInt(7, banner.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa banner
    public boolean deleteBanner(int id) {
        String sql = "DELETE FROM banner WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật trạng thái banner
    public boolean updateBannerStatus(int id, String status) {
        String sql = "UPDATE banner SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Lấy banner active để hiển thị trên trang chủ
    public List<Banner> getActiveBanners() {
        return getBannersByStatus("active");
    }

    // Đếm số lượng banner
    public int countBanners() {
        String sql = "SELECT COUNT(*) FROM banner";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm banner theo trạng thái
    public int countBannersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM banner WHERE status = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}