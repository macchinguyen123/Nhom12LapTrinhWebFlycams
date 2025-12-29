package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Categories> getAllCategories() {
        List<Categories> list = new ArrayList<>();
        String sql = "SELECT * FROM categories WHERE status = 'Hiện'";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Categories c = new Categories(
                        rs.getInt("id"),
                        rs.getString("categoryName"),
                        rs.getString("image"),
                        rs.getString("status"));
                list.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Categories getCategoryById(int id) {
        Categories c = null;
        String sql = "SELECT * FROM categories WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                c = new Categories(
                        rs.getInt("id"),
                        rs.getString("categoryName"),
                        rs.getString("image"),
                        rs.getString("status"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return c;
    }

    public String getCategoryNameById(int id) {
        String sql = "SELECT categoryName FROM categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next())
                return rs.getString("categoryName");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insert(Categories c) {
        String sql = "INSERT INTO categories (categoryName, image, status) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCategoryName());
            ps.setString(2, c.getImage());
            ps.setString(3, c.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean update(Categories c) {
        String sql = "UPDATE categories SET categoryName = ?, image = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCategoryName());
            ps.setString(2, c.getImage());
            ps.setString(3, c.getStatus());
            ps.setInt(4, c.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM categories WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Categories> getAllCategoriesAdmin() {
        List<Categories> list = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY id DESC"; // Get ALL (including Hidden)
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Categories c = new Categories(
                        rs.getInt("id"),
                        rs.getString("categoryName"),
                        rs.getString("image"),
                        rs.getString("status"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
