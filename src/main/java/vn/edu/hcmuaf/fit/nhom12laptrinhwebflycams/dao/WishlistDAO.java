package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

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
}


