package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Reviews;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewsDAO {

    /**
     * Kiểm tra xem user đã đánh giá sản phẩm này chưa
     * @param userId ID của user
     * @param productId ID của sản phẩm
     * @return true nếu đã đánh giá, false nếu chưa
     */
    public boolean hasUserReviewedProduct(int userId, int productId) {
        String sql = "SELECT COUNT(*) > 0 FROM reviews WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

    // Thêm hoặc cập nhật review
    public void saveReview(int userId, int productId, int rating, String content) {
        String sql = """
                    INSERT INTO reviews (user_id, product_id, rating, content)
                    VALUES (?, ?, ?, ?)
                    ON DUPLICATE KEY UPDATE rating=?, content=?, createdAt=NOW()
                """;


        System.out.println("=== [DAO] saveReview ===");
        System.out.println("userId    = " + userId);
        System.out.println("productId = " + productId);
        System.out.println("rating    = " + rating);
        System.out.println("content   = " + content);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, rating);
            ps.setString(4, content);
            ps.setInt(5, rating);
            ps.setString(6, content);

            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Lấy danh sách review theo sản phẩm
    public List<Reviews> getReviewsByProduct(int productId) {
        List<Reviews> list = new ArrayList<>();
        String sql = """
                    SELECT r.*, u.username, u.avatar
                    FROM reviews r
                    JOIN users u ON r.user_id = u.id
                    WHERE r.product_id=?
                    ORDER BY r.createdAt DESC
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Reviews r = new Reviews();
                r.setId(rs.getInt("id"));
                r.setProductId(rs.getInt("product_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setRating(rs.getInt("rating"));
                r.setContent(rs.getString("content"));
                r.setCreatedAt(rs.getTimestamp("createdAt"));
                // ====== USER INFO ======
                r.setUsername(rs.getString("username"));
                r.setAvatar(rs.getString("avatar"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Trung bình sao
    public double getAverageRating(int productId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tổng số đánh giá
    public int countReviews(int productId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm review theo số sao
    public int countByStar(int productId, int star) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE product_id=? AND rating=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setInt(2, star);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Đếm review có bình luận
    public int countWithComment(int productId) {
        String sql = """
                    SELECT COUNT(*) 
                    FROM reviews 
                    WHERE product_id=? 
                      AND content IS NOT NULL 
                      AND TRIM(content) <> ''
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    public List<Reviews> getReviewsByProductPaging(int productId, int page, int pageSize) {
        List<Reviews> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;

        String sql = """
                SELECT r.*, u.username, u.avatar
                FROM reviews r
                JOIN users u ON r.user_id = u.id
                WHERE r.product_id = ?
                ORDER BY r.createdAt DESC
                LIMIT ? OFFSET ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setInt(2, pageSize);
            ps.setInt(3, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Reviews r = new Reviews();
                r.setId(rs.getInt("id"));
                r.setProductId(rs.getInt("product_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setRating(rs.getInt("rating"));
                r.setContent(rs.getString("content"));
                r.setCreatedAt(rs.getTimestamp("createdAt"));
                // ====== USER INFO ======
                r.setUsername(rs.getString("username"));
                r.setAvatar(rs.getString("avatar"));
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


}
