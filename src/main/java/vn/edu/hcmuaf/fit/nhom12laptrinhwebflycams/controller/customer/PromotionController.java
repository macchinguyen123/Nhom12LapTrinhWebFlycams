package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Promotion;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.PromotionService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.WishlistService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/promotion")
public class PromotionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        PromotionService promotionService = new PromotionService();
        WishlistService wishlistService = new WishlistService();

        // ===== 1. LOAD PROMOTION + PRODUCT =====
        Map<Promotion, List<Product>> promotionMap = promotionService.getActivePromotionsWithProducts();

        request.setAttribute("promotionMap", promotionMap);

        // ===== 2. LOAD WISHLIST (QUAN TRỌNG) =====
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user != null) {
            List<Integer> wishlistProductIds = wishlistService.getWishlistProductIds(user.getId());
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
