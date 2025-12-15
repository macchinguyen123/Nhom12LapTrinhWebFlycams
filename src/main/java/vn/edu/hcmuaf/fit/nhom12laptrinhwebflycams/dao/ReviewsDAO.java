package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Reviews;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewsDAO {

    // Thêm hoặc cập nhật review
    public void saveReview(int userId, int productId, int rating, String content) {
        String sql = """
            INSERT INTO reviews (user_id, product_id, rating, content)
            VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE rating=?, content=?, createdAt=NOW()
        """;

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
        String sql = "SELECT * FROM reviews WHERE product_id=? ORDER BY createdAt DESC";

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
}
