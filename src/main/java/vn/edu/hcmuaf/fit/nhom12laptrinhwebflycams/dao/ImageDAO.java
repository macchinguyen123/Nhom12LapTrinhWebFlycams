package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Image;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ImageDAO {

    public List<Image> getImagesByProduct(int productId) {
        List<Image> list = new ArrayList<>();
        String sql = "SELECT * FROM images WHERE product_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Image img = new Image(
                        rs.getInt("id"),
                        rs.getInt("product_id"),
                        rs.getString("imageUrl"),
                        rs.getString("imageType")
                );
                list.add(img);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
