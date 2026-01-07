package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.CategoryDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ReviewsDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.WishlistService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.PriceFormatter;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", value = "/product-detail")
public class ProductDetailServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ReviewsDAO reviewsDAO = new ReviewsDAO();
    private final OrdersDAO ordersDAO = new OrdersDAO();
    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");
        if (idRaw == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idRaw);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Product product = productDAO.getProductById(id);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/404.jsp");
            return;
        }

        // LẤY TÊN DANH MỤC (KHÔNG ĐỤNG PRODUCT)
        String categoryName = categoryDAO.getCategoryNameById(product.getCategoryId());

        // ====== PHẦN THÊM: REVIEW / RATING ======
        double avgRating = reviewsDAO.getAverageRating(id);
        int reviewCount = reviewsDAO.countReviews(id);

        int fullStars = (int) avgRating;
        boolean hasHalfStar = (avgRating - fullStars) >= 0.5;

        // ====== KIỂM TRA USER ĐÃ ĐĂNG NHẬP VÀ ĐÃ MUA SẢN PHẨM CHƯA ======
        HttpSession session = request.getSession(false);
        boolean canReview = false;
        boolean isLoggedIn = false;
        boolean hasReviewed = false;

        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null) {
                isLoggedIn = true;
                // Kiểm tra xem user đã mua sản phẩm này chưa
                boolean hasPurchased = ordersDAO.hasUserPurchasedProduct(user.getId(), id);
                // Kiểm tra xem user đã đánh giá sản phẩm này chưa
                hasReviewed = reviewsDAO.hasUserReviewedProduct(user.getId(), id);

                // User chỉ có thể đánh giá nếu đã mua và chưa đánh giá
                canReview = hasPurchased && !hasReviewed;
            }
        }

        request.setAttribute("avgRating", avgRating);
        request.setAttribute("reviewCount", reviewCount);
        request.setAttribute("fullStars", fullStars);
        request.setAttribute("hasHalfStar", hasHalfStar);
        request.setAttribute("canReview", canReview);
        request.setAttribute("isLoggedIn", isLoggedIn);
        request.setAttribute("hasReviewed", hasReviewed);

        request.setAttribute("formatter", new PriceFormatter());
        request.setAttribute("product", product);
        request.setAttribute("categoryName", categoryName);

        int page = 1;
        int pageSize = 5;

        String pageRaw = request.getParameter("page");
        if (pageRaw != null) {
            try {
                page = Integer.parseInt(pageRaw);
            } catch (NumberFormatException ignored) {}
        }

        int totalReviews = reviewsDAO.countReviews(id);
        int totalPages = (int) Math.ceil((double) totalReviews / pageSize);

        request.setAttribute("reviews",
                reviewsDAO.getReviewsByProductPaging(id, page, pageSize));

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("star5", reviewsDAO.countByStar(id, 5));
        request.setAttribute("star4", reviewsDAO.countByStar(id, 4));
        request.setAttribute("star3", reviewsDAO.countByStar(id, 3));
        request.setAttribute("star2", reviewsDAO.countByStar(id, 2));
        request.setAttribute("star1", reviewsDAO.countByStar(id, 1));
        request.setAttribute("commentCount", reviewsDAO.countWithComment(id));

        // ===== SẢN PHẨM LIÊN QUAN =====
        List<Product> relatedProducts = productDAO.getRelatedProducts(
                product.getCategoryId(),
                product.getId(),
                20
        );
        User user = session != null ? (User) session.getAttribute("user") : null;
        // ======= 7. LOAD WISHLIST (QUAN TRỌNG) =======
        if (user != null) {
            List<Integer> wishlistProductIds =
                    wishlistService.getWishlistProductIds(user.getId());
            request.setAttribute("wishlistProductIds", wishlistProductIds);
        }

        request.setAttribute("relatedProducts", relatedProducts);

        request.getRequestDispatcher("/page/product-details.jsp")
                .forward(request, response);
    }
}