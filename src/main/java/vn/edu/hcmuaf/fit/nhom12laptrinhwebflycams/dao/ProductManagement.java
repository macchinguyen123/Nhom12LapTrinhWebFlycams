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
        productName=?, brandName=?, category_id=?,
        price=?, finalPrice=?, quantity=?, status=?,
        description=?, parameter=?, warranty=?
        WHERE id=?
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
            ps.setInt(10, p.getId());
            ps.setString(11, p.getWarranty());

            ps.executeUpdate();
        }
    }
}
