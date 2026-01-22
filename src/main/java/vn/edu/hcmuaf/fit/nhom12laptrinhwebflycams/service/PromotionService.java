package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.PromotionDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Promotion;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class PromotionService {
    private PromotionDAO promotionDAO = new PromotionDAO();
    private ProductDAO productDAO = new ProductDAO();

    // lấy danh sách khuyến mãi và sản phẩm.
    public Map<Promotion, List<Product>> getActivePromotionsWithProducts() {
        List<Promotion> promotions = promotionDAO.getActivePromotions();
        Map<Promotion, List<Product>> promotionMap = new LinkedHashMap<>();

        for (Promotion promo : promotions) {
            List<Product> products = productDAO.getProductsByPromotion(promo.getId());
            if (!products.isEmpty()) {
                promotionMap.put(promo, products);
            }
        }
        return promotionMap;
    }

    // Admin Lấy toàn bộ danh sách khuyến mãi (không phân biệt trạng thái)
    public List<Promotion> getAllPromotions() {
        return promotionDAO.getAllPromotions();
    }

    //Lấy phạm vi áp dụng của khuyến mãi
    public String getPromotionScope(int promotionId) {
        return promotionDAO.getPromotionScope(promotionId);
    }

    //Lấy danh sách toàn bộ sản phẩm để admin thêm chọn sản phẩm thêm khuyến mãi
    public List<Product> getAllProducts() {
        return promotionDAO.getAllProducts();
    }

    // Lấy danh sách toàn bộ danh mục sản phẩm
    public List<Categories> getAllCategories() {
        return promotionDAO.getAllCategories();
    }

    //Lấy danh sách ID sản phẩm được áp dụng cho một khuyến mãi
    public List<Integer> getProductIdsForPromotion(int promotionId) {
        return promotionDAO.getProductIdsForPromotion(promotionId);
    }

    //Lấy danh sách ID danh mục được áp dụng cho một khuyến mãi
    public List<Integer> getCategoryIdsForPromotion(int promotionId) {
        return promotionDAO.getCategoryIdsForPromotion(promotionId);
    }

    //Thêm khuyến mãi mới (Admin)
    public void addPromotion(Promotion p, String scope, List<String> productIds, List<String> categoryIds) {
        promotionDAO.insertPromotion(p, scope, productIds, categoryIds);
    }

    //Cập nhật khuyến mãi (Admin)
    public void updatePromotion(Promotion p, String scope, List<String> productIds, List<String> categoryIds) {
        promotionDAO.updatePromotionWithScope(p, scope, productIds, categoryIds);
    }

    //Xóa khuyến mãi theo ID (Admin)
    public void deletePromotion(int id) {
        promotionDAO.deleteById(id);
    }
}
