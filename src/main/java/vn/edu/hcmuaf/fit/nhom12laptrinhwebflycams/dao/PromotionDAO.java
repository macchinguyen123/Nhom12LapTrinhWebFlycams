package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Promotion;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PromotionDAO {


    // ================== GET ALL ==================
    public List<Promotion> getAllPromotions() {
        List<Promotion> list = new ArrayList<>();
        String sql = "SELECT id, name, discountValue, discountType, startDate, endDate FROM promotion ORDER BY startDate DESC";

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

    // ================== INSERT ==================
    public void insertPromotion(Promotion p, String scope,
                                List<String> productIds, List<String> categoryIds) {

        String sqlPromotion = "INSERT INTO promotion (name, discountValue, discountType, startDate, endDate) VALUES (?, ?, ?, ?, ?)";
        String sqlTarget = "INSERT INTO promotion_target (promotion_id, targetType, product_id, category_id) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // 1️⃣ Insert promotion
            PreparedStatement ps = conn.prepareStatement(sqlPromotion, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, p.getName());
            ps.setDouble(2, p.getDiscountValue());
            ps.setString(3, p.getDiscountType());
            ps.setTimestamp(4, new Timestamp(p.getStartDate().getTime()));
            ps.setTimestamp(5, new Timestamp(p.getEndDate().getTime()));
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            rs.next();
            int promotionId = rs.getInt(1);
            p.setId(promotionId);

            // 2️⃣ Insert targets
            PreparedStatement psTarget = conn.prepareStatement(sqlTarget);
            if ("ALL".equals(scope)) {
                psTarget.setInt(1, promotionId);
                psTarget.setString(2, "tất cả");
                psTarget.setNull(3, Types.INTEGER);
                psTarget.setNull(4, Types.INTEGER);
                psTarget.executeUpdate();

            } else if ("PRODUCT".equals(scope)) {
                for (String id : productIds) {
                    psTarget.setInt(1, promotionId);
                    psTarget.setString(2, "sản phẩm");
                    psTarget.setInt(3, Integer.parseInt(id.trim()));
                    psTarget.setNull(4, Types.INTEGER);
                    psTarget.executeUpdate();
                }

            } else if ("CATEGORY".equals(scope)) {
                for (String id : categoryIds) {
                    psTarget.setInt(1, promotionId);
                    psTarget.setString(2, "danh mục");
                    psTarget.setNull(3, Types.INTEGER);
                    psTarget.setInt(4, Integer.parseInt(id.trim()));
                    psTarget.executeUpdate();
                }
            }

            conn.commit();

            // 3️⃣ Apply promotion
            applyPromotionToProducts(p, scope, productIds, categoryIds);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }



        public List<Promotion> getActivePromotions() {
            List<Promotion> list = new ArrayList<>();

            String sql = """
            SELECT id, name, discountValue, discountType, startDate, endDate
            FROM promotion
            WHERE NOW() BETWEEN startDate AND endDate
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
                    p.setStartDate(rs.getDate("startDate"));
                    p.setEndDate(rs.getDate("endDate"));
                    list.add(p);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }

            return list;
        }

    // ================== UPDATE ==================
    public void updatePromotionWithScope(Promotion p, String scope,
                                         List<String> productIds, List<String> categoryIds) {

        String sqlUpdate = "UPDATE promotion SET name=?, discountValue=?, discountType=?, startDate=?, endDate=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            // 1️⃣ Update promotion info
            try (PreparedStatement ps = conn.prepareStatement(sqlUpdate)) {
                ps.setString(1, p.getName());
                ps.setDouble(2, p.getDiscountValue());
                ps.setString(3, p.getDiscountType());
                ps.setTimestamp(4, new Timestamp(p.getStartDate().getTime()));
                ps.setTimestamp(5, new Timestamp(p.getEndDate().getTime()));
                ps.setInt(6, p.getId());
                ps.executeUpdate();
            }

            // 2️⃣ Delete old targets
            try (PreparedStatement ps = conn.prepareStatement("DELETE FROM promotion_target WHERE promotion_id=?")) {
                ps.setInt(1, p.getId());
                ps.executeUpdate();
            }

            // 3️⃣ Insert new targets
            String sqlTarget = "INSERT INTO promotion_target (promotion_id, targetType, product_id, category_id) VALUES (?, ?, ?, ?)";
            PreparedStatement psTarget = conn.prepareStatement(sqlTarget);

            if ("ALL".equals(scope)) {
                psTarget.setInt(1, p.getId());
                psTarget.setString(2, "tất cả");
                psTarget.setNull(3, Types.INTEGER);
                psTarget.setNull(4, Types.INTEGER);
                psTarget.executeUpdate();

            } else if ("PRODUCT".equals(scope)) {
                for (String id : productIds) {
                    psTarget.setInt(1, p.getId());
                    psTarget.setString(2, "sản phẩm");
                    psTarget.setInt(3, Integer.parseInt(id.trim()));
                    psTarget.setNull(4, Types.INTEGER);
                    psTarget.executeUpdate();
                }

            } else if ("CATEGORY".equals(scope)) {
                for (String id : categoryIds) {
                    psTarget.setInt(1, p.getId());
                    psTarget.setString(2, "danh mục");
                    psTarget.setNull(3, Types.INTEGER);
                    psTarget.setInt(4, Integer.parseInt(id.trim()));
                    psTarget.executeUpdate();
                }
            }

            conn.commit();

            // 4️⃣ Apply promotion
            applyPromotionToProducts(p, scope, productIds, categoryIds);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================== APPLY PROMOTION ==================
    private void applyPromotionToProducts(Promotion p, String scope,
                                          List<String> productIds, List<String> categoryIds) {

        if (p == null) return;

        try (Connection conn = DBConnection.getConnection()) {

            if ("ALL".equals(scope)) {
                // RESET tất cả về price gốc trước
                String resetSql = "UPDATE products SET finalPrice = price";
                try (PreparedStatement psReset = conn.prepareStatement(resetSql)) {
                    psReset.executeUpdate();
                }

                // Apply promotion mới
                String sql = "UPDATE products SET finalPrice = CASE WHEN ? = '%' THEN price * (1 - ? / 100) ELSE price - ? END WHERE finalPrice - ? >= 0";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, p.getDiscountType());
                    ps.setDouble(2, p.getDiscountValue());
                    ps.setDouble(3, p.getDiscountValue());
                    ps.setDouble(4, p.getDiscountValue());
                    int rowsUpdated = ps.executeUpdate();
                    System.out.println("✅ Updated " + rowsUpdated + " products (ALL)");
                }

            } else if ("PRODUCT".equals(scope) && !productIds.isEmpty()) {
                // RESET các sản phẩm cụ thể về giá gốc
                String placeholders = String.join(",", productIds);
                String resetSql = "UPDATE products SET finalPrice = price WHERE id IN (" + placeholders + ")";
                try (PreparedStatement psReset = conn.prepareStatement(resetSql)) {
                    psReset.executeUpdate();
                }

                // Apply promotion
                String sql = "UPDATE products SET finalPrice = CASE WHEN ? = '%' THEN price * (1 - ? / 100) ELSE GREATEST(price - ?, 0) END WHERE id IN (" + placeholders + ")";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, p.getDiscountType());
                    ps.setDouble(2, p.getDiscountValue());
                    ps.setDouble(3, p.getDiscountValue());
                    int rowsUpdated = ps.executeUpdate();
                    System.out.println("✅ Updated " + rowsUpdated + " products (PRODUCT)");
                }

            } else if ("CATEGORY".equals(scope) && !categoryIds.isEmpty()) {
                // RESET category về giá gốc
                String placeholders = String.join(",", categoryIds);
                String resetSql = "UPDATE products SET finalPrice = price WHERE category_id IN (" + placeholders + ")";
                try (PreparedStatement psReset = conn.prepareStatement(resetSql)) {
                    psReset.executeUpdate();
                }

                // Apply promotion
                String sql = "UPDATE products SET finalPrice = CASE WHEN ? = '%' THEN price * (1 - ? / 100) ELSE GREATEST(price - ?, 0) END WHERE category_id IN (" + placeholders + ")";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, p.getDiscountType());
                    ps.setDouble(2, p.getDiscountValue());
                    ps.setDouble(3, p.getDiscountValue());
                    int rowsUpdated = ps.executeUpdate();
                    System.out.println("✅ Updated " + rowsUpdated + " products in category");
                }
            }

        } catch (Exception e) {
            System.out.println("❌ Error applying promotion:");
            e.printStackTrace();
        }
    }

    // ================== BETTER VERSION: Chỉ apply promotion tốt nhất ==================
    private void applyBestPromotionToAllProducts() {
        String sql = """
        UPDATE products p
        SET finalPrice = (
            SELECT CASE
                WHEN pr.discountType = '%' 
                THEN p.price * (1 - pr.discountValue / 100)
                ELSE GREATEST(p.price - pr.discountValue, 0)
            END
            FROM promotion pr
            JOIN promotion_target pt ON pr.id = pt.promotion_id
            WHERE NOW() BETWEEN pr.startDate AND pr.endDate
              AND (
                  pt.targetType = 'tất cả'
                  OR (pt.targetType = 'sản phẩm' AND pt.product_id = p.id)
                  OR (pt.targetType = 'danh mục' AND pt.category_id = p.category_id)
              )
            ORDER BY (
                CASE
                    WHEN pr.discountType = '%' 
                    THEN p.price * pr.discountValue / 100
                    ELSE pr.discountValue
                END
            ) DESC
            LIMIT 1
        )
        WHERE EXISTS (
            SELECT 1
            FROM promotion pr
            JOIN promotion_target pt ON pr.id = pt.promotion_id
            WHERE NOW() BETWEEN pr.startDate AND pr.endDate
              AND (
                  pt.targetType = 'tất cả'
                  OR (pt.targetType = 'sản phẩm' AND pt.product_id = p.id)
                  OR (pt.targetType = 'danh mục' AND pt.category_id = p.category_id)
              )
        )
    """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            int rows = ps.executeUpdate();
            System.out.println("✅ Applied best promotion to " + rows + " products");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    // ================== DELETE ==================
    public void deleteById(int promotionId) {
        resetFinalPrice(promotionId);
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps1 = conn.prepareStatement("DELETE FROM promotion_target WHERE promotion_id=?");
                 PreparedStatement ps2 = conn.prepareStatement("DELETE FROM promotion WHERE id=?")) {
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

    // ================== RESET GIÁ ==================
    private void resetFinalPrice(int promotionId) {
        String sql = """
            UPDATE products
            SET finalPrice = price
            WHERE id IN (
                SELECT product_id
                FROM promotion_target
                WHERE promotion_id = ?
                  AND product_id IS NOT NULL
            )
            OR category_id IN (
                SELECT category_id
                FROM promotion_target
                WHERE promotion_id = ?
                  AND category_id IS NOT NULL
            )
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promotionId);
            ps.setInt(2, promotionId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================== GET SCOPE ==================
    public String getPromotionScope(int promotionId) {
        String sql = "SELECT DISTINCT targetType FROM promotion_target WHERE promotion_id = ?";
        List<String> types = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, promotionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) types.add(rs.getString("targetType"));
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (types.contains("tất cả")) return "Toàn bộ sản phẩm";
        if (types.size() >= 2) return "Sản phẩm + Danh mục";
        if (types.contains("sản phẩm")) return "Sản phẩm";
        if (types.contains("danh mục")) return "Danh mục";
        return "—";
    }




}
