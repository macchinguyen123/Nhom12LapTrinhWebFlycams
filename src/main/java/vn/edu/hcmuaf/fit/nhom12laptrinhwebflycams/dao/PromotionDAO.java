package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Promotion;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {

    public List<Promotion> getAllPromotions() {

        List<Promotion> list = new ArrayList<>();

        String sql = """
            SELECT id, name, discountValue, discountType, startDate, endDate
            FROM promotion
            ORDER BY startDate DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Promotion p = new Promotion();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setDiscountValue(rs.getDouble("discountValue"));
                p.setDiscountType(rs.getString("discountType"));
                p.setStartDate(rs.getTimestamp("startDate"));
                p.setEndDate(rs.getTimestamp("endDate"));
                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void insertPromotion(Promotion p, String scope) {

        String sqlPromotion = """
            INSERT INTO promotion
            (name, discountValue, discountType, startDate, endDate)
            VALUES (?, ?, ?, ?, ?)
        """;

        String sqlTarget = """
            INSERT INTO promotion_target
            (promotion_id, targetType)
            VALUES (?, ?)
        """;

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            PreparedStatement ps = conn.prepareStatement(
                    sqlPromotion, Statement.RETURN_GENERATED_KEYS);

            ps.setString(1, p.getName());
            ps.setDouble(2, p.getDiscountValue());
            ps.setString(3, p.getDiscountType());
            ps.setTimestamp(4, new Timestamp(p.getStartDate().getTime()));
            ps.setTimestamp(5, new Timestamp(p.getEndDate().getTime()));

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (!rs.next()) throw new SQLException("Không lấy được ID khuyến mãi");

            int promotionId = rs.getInt(1);

            PreparedStatement psTarget = conn.prepareStatement(sqlTarget);

            switch (scope) {
                case "ALL" -> {
                    psTarget.setInt(1, promotionId);
                    psTarget.setString(2, "tất cả");
                    psTarget.executeUpdate();
                }
                case "PRODUCT" -> {
                    psTarget.setInt(1, promotionId);
                    psTarget.setString(2, "sản phẩm");
                    psTarget.executeUpdate();
                }
                case "CATEGORY" -> {
                    psTarget.setInt(1, promotionId);
                    psTarget.setString(2, "danh mục");
                    psTarget.executeUpdate();
                }
            }

            conn.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getPromotionScope(int promotionId) {

        String sql = """
            SELECT DISTINCT targetType
            FROM promotion_target
            WHERE promotion_id = ?
        """;

        List<String> types = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, promotionId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                types.add(rs.getString("targetType"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (types.contains("tất cả")) return "Toàn bộ sản phẩm";
        if (types.size() == 2) return "Sản phẩm + Danh mục";
        if (types.contains("sản phẩm")) return "Sản phẩm";
        if (types.contains("danh mục")) return "Danh mục";

        return "—";
    }

    public void delete(int id) {

        String sqlTarget = "DELETE FROM promotion_target WHERE promotion_id = ?";
        String sqlPromotion = "DELETE FROM promotion WHERE id = ?";

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(sqlTarget);
                 PreparedStatement ps2 = conn.prepareStatement(sqlPromotion)) {

                ps1.setInt(1, id);
                ps1.executeUpdate();

                ps2.setInt(1, id);
                ps2.executeUpdate();

                conn.commit();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void deleteById(int promotionId) {

        String deleteTargetSql = """
        DELETE FROM promotion_target
        WHERE promotion_id = ?
    """;

        String deletePromotionSql = """
        DELETE FROM promotion
        WHERE id = ?
    """;

        try (Connection conn = DBConnection.getConnection()) {

            conn.setAutoCommit(false); // transaction

            try (
                    PreparedStatement ps1 = conn.prepareStatement(deleteTargetSql);
                    PreparedStatement ps2 = conn.prepareStatement(deletePromotionSql)
            ) {
                ps1.setInt(1, promotionId);
                ps1.executeUpdate();

                ps2.setInt(1, promotionId);
                ps2.executeUpdate();

                conn.commit();
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updatePromotionWithScope(Promotion p, String scope) {

        String updatePromotion = """
        UPDATE promotion
        SET name=?, discountValue=?, discountType=?, startDate=?, endDate=?
        WHERE id=?
    """;

        String deleteTarget = "DELETE FROM promotion_target WHERE promotion_id=?";

        String insertTarget = """
        INSERT INTO promotion_target(promotion_id, targetType)
        VALUES (?, ?)
    """;

        try (Connection con = DBConnection.getConnection()) {
            con.setAutoCommit(false);

            // update promotion
            try (PreparedStatement ps = con.prepareStatement(updatePromotion)) {
                ps.setString(1, p.getName());
                ps.setDouble(2, p.getDiscountValue());
                ps.setString(3, p.getDiscountType());
                ps.setDate(4, new Date(p.getStartDate().getTime()));
                ps.setDate(5, new Date(p.getEndDate().getTime()));
                ps.setInt(6, p.getId());
                ps.executeUpdate();
            }

            // clear old scope
            try (PreparedStatement ps = con.prepareStatement(deleteTarget)) {
                ps.setInt(1, p.getId());
                ps.executeUpdate();
            }

            // insert new scope
            try (PreparedStatement ps = con.prepareStatement(insertTarget)) {
                if ("ALL".equals(scope)) {
                    ps.setInt(1, p.getId());
                    ps.setString(2, "tất cả");
                    ps.executeUpdate();
                } else {
                    ps.setInt(1, p.getId());
                    ps.setString(2,
                            scope.equals("PRODUCT") ? "sản phẩm" : "danh mục");
                    ps.executeUpdate();
                }
            }

            con.commit();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void update(Promotion p) {

        String sql = """
        UPDATE promotion
        SET name = ?,
            discountValue = ?,
            discountType = ?,
            startDate = ?,
            endDate = ?
        WHERE id = ?
    """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, p.getName());
            ps.setDouble(2, p.getDiscountValue());
            ps.setString(3, p.getDiscountType());
            ps.setDate(4, new Date(p.getStartDate().getTime()));
            ps.setDate(5, new Date(p.getEndDate().getTime()));
            ps.setInt(6, p.getId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
