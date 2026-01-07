package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.PromotionDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Promotion;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.WishlistService;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/promotion")
public class PromotionController extends HttpServlet {

    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PromotionDAO promotionDAO = new PromotionDAO();
        ProductDAO productDAO = new ProductDAO();

        // ===== 1. LOAD PROMOTION + PRODUCT =====
        List<Promotion> promotions = promotionDAO.getActivePromotions();
        Map<Promotion, List<Product>> promotionMap = new LinkedHashMap<>();

        for (Promotion promo : promotions) {
            List<Product> products =
                    productDAO.getProductsByPromotion(promo.getId());

            if (!products.isEmpty()) {
                promotionMap.put(promo, products);
            }
        }

        request.setAttribute("promotionMap", promotionMap);

        // ===== 2. LOAD WISHLIST (QUAN TRỌNG) =====
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user != null) {
            List<Integer> wishlistProductIds =
                    wishlistService.getWishlistProductIds(user.getId());
            request.setAttribute("wishlistProductIds", wishlistProductIds);
        }

        // ===== 3. FORWARD =====
        request.getRequestDispatcher("/page/promotion.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
