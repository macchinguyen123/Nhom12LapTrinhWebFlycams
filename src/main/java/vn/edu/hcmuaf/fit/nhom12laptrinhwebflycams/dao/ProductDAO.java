package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

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


    public List<Product> searchProducts(String keyword,
                                        String priceFilter, Double minPrice,
                                        Double maxPrice,
                                        List<String> brands,
                                        String sortBy) {

        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
                SELECT DISTINCT p.*, i.imageUrl
                FROM products p
                LEFT JOIN images i 
                  ON p.id = i.product_id AND i.imageType = 'Chính'
                WHERE p.productName LIKE ?
                """);

        // điều kiện giá
        if (minPrice != null && maxPrice != null) {
            sql.append(" AND p.finalPrice BETWEEN ? AND ? ");
        } else if (minPrice != null) {
            sql.append(" AND p.finalPrice >= ? ");
        } else if (maxPrice != null) {
            sql.append(" AND p.finalPrice <= ? ");
        }

        // brands
        if (brands != null && !brands.isEmpty()) {
            sql.append(" AND p.brandName IN (");
            sql.append(brands.stream().map(b -> "?").collect(Collectors.joining(",")));
            sql.append(") ");
        }

        // sort
        if ("low-high".equals(sortBy)) sql.append(" ORDER BY p.finalPrice ASC ");
        else if ("high-low".equals(sortBy)) sql.append(" ORDER BY p.finalPrice DESC ");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;
            ps.setString(idx++, "%" + (keyword == null ? "" : keyword) + "%");

            if (minPrice != null && maxPrice != null) {
                ps.setDouble(idx++, minPrice);
                ps.setDouble(idx++, maxPrice);
            } else if (minPrice != null) {
                ps.setDouble(idx++, minPrice);
            } else if (maxPrice != null) {
                ps.setDouble(idx++, maxPrice);
            }

            if (brands != null && !brands.isEmpty()) {
                for (String b : brands) {
                    ps.setString(idx++, b);
                }
            }

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
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    public List<Product> searchProductsInCategory(
            int categoryId,
            String keyword,
            Double minPrice,
            Double maxPrice,
            List<String> brands,
            String sortBy // "low-high" hoặc "high-low"
    ) {

        List<Product> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
            SELECT DISTINCT p.*, i.imageUrl
            FROM products p
            LEFT JOIN images i 
              ON p.id = i.product_id AND i.imageType = 'Chính'
            WHERE p.category_id = ? AND p.productName LIKE ?
            """);

        // điều kiện giá
        if (minPrice != null && maxPrice != null) {
            sql.append(" AND p.finalPrice BETWEEN ? AND ? ");
        } else if (minPrice != null) {
            sql.append(" AND p.finalPrice >= ? ");
        } else if (maxPrice != null) {
            sql.append(" AND p.finalPrice <= ? ");
        }

        // brands
        if (brands != null && !brands.isEmpty()) {
            sql.append(" AND p.brandName IN (");
            sql.append(brands.stream().map(b -> "?").collect(Collectors.joining(",")));
            sql.append(") ");
        }

        // sort theo giá
        if ("low-high".equals(sortBy)) sql.append(" ORDER BY p.finalPrice ASC ");
        else if ("high-low".equals(sortBy)) sql.append(" ORDER BY p.finalPrice DESC ");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int idx = 1;

            // categoryId
            ps.setInt(idx++, categoryId);

            // keyword
            ps.setString(idx++, "%" + (keyword == null ? "" : keyword) + "%");

            // price
            if (minPrice != null && maxPrice != null) {
                ps.setDouble(idx++, minPrice);
                ps.setDouble(idx++, maxPrice);
            } else if (minPrice != null) {
                ps.setDouble(idx++, minPrice);
            } else if (maxPrice != null) {
                ps.setDouble(idx++, maxPrice);
            }

            // brands
            if (brands != null && !brands.isEmpty()) {
                for (String b : brands) {
                    ps.setString(idx++, b);
                }
            }

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
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Product getProductById(int id) {
        ImageDAO imageDAO = new ImageDAO();
        String sql = "SELECT * FROM products WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    System.out.println("[ProductDAO] Found product name = " + rs.getString("productName"));

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
                            rs.getInt("status") == 1 // ✅ dùng kiểu int để tránh lỗi boolean
                    );
                    p.setImages(imageDAO.getImagesByProduct(p.getId()));
                    return p;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}