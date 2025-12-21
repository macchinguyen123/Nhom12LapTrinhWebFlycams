package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;


import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.BlogReview;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Post;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BlogDAO {

    // Lấy tất cả bài viết để hiển thị danh sách
    public List<Post> getAllPosts() {
        List<Post> list = new ArrayList<>();
        String sql = "SELECT id, title, content, image, createdAt, product_id FROM posts ORDER BY createdAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Post p = new Post(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("image"),
                        rs.getTimestamp("createdAt"),
                        rs.getInt("product_id")
                );
                System.out.println("Total posts: " + list.size());
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy bài viết theo ID
    public Post getPostById(int id) {
        String sql = "SELECT id, title, content, image, createdAt, product_id FROM posts WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new Post(
                        rs.getInt("id"),
                        rs.getString("title"),
                        rs.getString("content"),
                        rs.getString("image"),
                        rs.getTimestamp("createdAt"),
                        rs.getInt("product_id")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean hasReviewed(int blogId, int userId) {
        String sql = "SELECT 1 FROM blog_reviews WHERE blog_id=? AND user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, blogId);
            ps.setInt(2, userId);
            return ps.executeQuery().next();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public void insert(int blogId, int userId, String content) {
        String sql = "INSERT INTO blog_reviews(blog_id,user_id,content) VALUES(?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, blogId);
            ps.setInt(2, userId);
            ps.setString(3, content);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<Map<String, Object>> getReviewsByBlog(int blogId) {
        List<Map<String, Object>> list = new ArrayList<>();

        String sql = """
        SELECT br.content, br.createdAt, u.fullname
        FROM blog_reviews br
        JOIN users u ON br.user_id = u.id
        WHERE br.blog_id = ?
        ORDER BY br.createdAt DESC
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, blogId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("content", rs.getString("content"));
                row.put("createdAt", rs.getTimestamp("createdAt"));
                row.put("username", rs.getString("fullname"));
                list.add(row);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
