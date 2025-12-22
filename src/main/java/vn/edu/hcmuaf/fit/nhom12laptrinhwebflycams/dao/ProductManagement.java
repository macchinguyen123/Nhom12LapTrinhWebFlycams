package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;

public class ProductManagement {
    public int insertProduct(Product p) throws SQLException {
        String sql = """
    INSERT INTO products
    (productName, brandName, category_id, price, finalPrice,
     quantity, status, description, parameter, warranty)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?)
""";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, p.getProductName());
            ps.setString(2, p.getBrandName());
            ps.setInt(3, p.getCategoryId());
            ps.setDouble(4, p.getPrice());
            ps.setDouble(5, p.getFinalPrice());
            ps.setInt(6, p.getQuantity());
            ps.setString(7, p.getStatus());
            ps.setString(8, p.getDescription());
            ps.setString(9, p.getParameter());
            ps.setString(10, p.getWarranty());

            // In ra dữ liệu chuẩn bị chèn
            System.out.println("Inserting Product:");
            System.out.println("Name: " + p.getProductName());
            System.out.println("Brand: " + p.getBrandName());
            System.out.println("Category ID: " + p.getCategoryId());
            System.out.println("Price: " + p.getPrice());
            System.out.println("Final Price: " + p.getFinalPrice());
            System.out.println("Quantity: " + p.getQuantity());
            System.out.println("Status: " + p.getStatus());
            System.out.println("Description: " + p.getDescription());
            System.out.println("Parameter: " + p.getParameter());
            System.out.println("warranty: " + p.getWarranty());

            ps.executeUpdate();
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                int id = rs.getInt(1);
                System.out.println("Insert successful, generated ID: " + id);
                return id;
            }
            System.out.println("Insert executed but no ID returned.");
        }
        return 0;
    }

    public void updateProduct(Product p) throws SQLException {
        String sql = """
        UPDATE products SET
            productName = ?, 
            brandName = ?, 
            category_id = ?,
            price = ?, 
            finalPrice = ?, 
            quantity = ?, 
            status = ?,
            description = ?, 
            parameter = ?, 
            warranty = ?
        WHERE id = ?
    """;

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, p.getProductName());
            ps.setString(2, p.getBrandName());
            ps.setInt(3, p.getCategoryId());
            ps.setDouble(4, p.getPrice());
            ps.setDouble(5, p.getFinalPrice());
            ps.setInt(6, p.getQuantity());
            ps.setString(7, p.getStatus());
            ps.setString(8, p.getDescription());
            ps.setString(9, p.getParameter());
            ps.setString(10, p.getWarranty());
            ps.setInt(11, p.getId()); // id cuối cùng

            ps.executeUpdate();
        }
    }
    public boolean deleteProduct(int productId) {
        String sqlDeleteImages = "DELETE FROM images WHERE product_id = ?";
        String sqlDeletePosts = "DELETE FROM posts WHERE product_id = ?";
        String sqlDeleteProduct = "DELETE FROM products WHERE id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            // Bắt đầu transaction
            conn.setAutoCommit(false);

            // Xóa ảnh phụ và ảnh chính
            try (PreparedStatement psImg = conn.prepareStatement(sqlDeleteImages)) {
                psImg.setInt(1, productId);
                psImg.executeUpdate();
            }

            // Xóa các bài viết liên quan
            try (PreparedStatement psPosts = conn.prepareStatement(sqlDeletePosts)) {
                psPosts.setInt(1, productId);
                psPosts.executeUpdate();
            }

            // Xóa sản phẩm
            try (PreparedStatement psProd = conn.prepareStatement(sqlDeleteProduct)) {
                psProd.setInt(1, productId);
                int affectedRows = psProd.executeUpdate();
                if (affectedRows == 0) {
                    conn.rollback();
                    return false;
                }
            }

            // Commit transaction
            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public boolean updateProductStatus(int id, String status) throws SQLException {
        String sql = "UPDATE products SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        }
    }



}
