package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Wishlists;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class WishlistDAO {
    public List<Wishlists> getWishlistByUser(int userId) {
        List<Wishlists> list = new ArrayList<>();
        String sql = "SELECT id, user_id, product_id FROM wishlists WHERE user_id = ? ORDER BY id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Wishlists l = new Wishlists(
                            rs.getInt("id"),
                            rs.getInt("user_id"),
                            rs.getInt("product_id")
                    );
                    list.add(l);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public boolean addToWishlist(int userId, int productId) {
        if (existsInWishlist(userId, productId)) {
            return false;
        }

        String sql = "INSERT INTO wishlists(user_id, product_id) VALUES(?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeFromWishlist(int userId, int productId) {
        String sql = "DELETE FROM wishlists WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            int rows = ps.executeUpdate();
            return rows > 0; //

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean existsInWishlist(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM wishlists WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<Product> getWishlistProductsByUser(int userId) {
        List<Product> list = new ArrayList<>();
        String sql = """
            SELECT p.*, pi.imageUrl
                          FROM wishlists w
                          JOIN products p ON w.product_id = p.id
                          LEFT JOIN images pi ON p.id = pi.product_id AND pi.imageType = 'Chính'
                          WHERE w.user_id = ?
                          ORDER BY w.id DESC
 
    """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product(
                        rs.getInt("id"),
                        rs.getInt("category_id"),
                        rs.getString("brandName"),
                        rs.getString("productName"),
                        rs.getString("description"),
                        rs.getString("parameter"),
                        rs.getDouble("price"),
                        rs.getDouble("finalPrice"),
                        rs.getString("warranty"),
                        rs.getInt("quantity"),
                        rs.getBoolean("status")
                );
                p.setMainImage(rs.getString("imageUrl"));
                list.add(p);
                System.out.println("[SERVICE] get wishlist: thành công=" + userId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Integer> getWishlistProductIds(int userId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT product_id FROM wishlists WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("product_id"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }



}


