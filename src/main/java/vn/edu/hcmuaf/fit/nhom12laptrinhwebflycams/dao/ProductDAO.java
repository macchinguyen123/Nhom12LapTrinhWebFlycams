package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    public List<Product> getProductsByCategory(int categoryId) {
        List<Product> list = new ArrayList<>();
        ImageDAO imageDAO = new ImageDAO();

        String sql = "SELECT * FROM products WHERE category_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, categoryId);
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

                // 🚀 Lấy danh sách ảnh theo product
                p.setImages(imageDAO.getImagesByProduct(p.getId()));

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM product WHERE productName LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
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
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
