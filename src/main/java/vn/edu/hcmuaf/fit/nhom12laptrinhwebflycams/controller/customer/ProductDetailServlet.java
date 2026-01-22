package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.CategoryService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.OrderService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.ProductService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.ReviewService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.WishlistService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.PriceFormatter;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductDetailServlet", value = "/product-detail")
public class ProductDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        ProductService productService = new ProductService();
        CategoryService categoryService = new CategoryService();
        ReviewService reviewService = new ReviewService();
        OrderService orderService = new OrderService();
        WishlistService wishlistService = new WishlistService();

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

        Product product = productService.getProduct(id);
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/404.jsp");
            return;
        }

        // Tăng số lượt xem sản phẩm
        productService.incrementViewCount(id);

        // LẤY TÊN DANH MỤC (KHÔNG ĐỤNG PRODUCT)
        String categoryName = categoryService.getCategoryNameById(product.getCategoryId());
        // ====== TÍNH % KHUYẾN MÃI ======
        int discountPercent = calculateDiscountPercent(product.getPrice(), product.getFinalPrice());
        request.setAttribute("discountPercent", discountPercent);
        System.out.println("DEBUG: discountPercent = " + discountPercent); // ← THÊM DÒNG NÀY

        // ====== PHẦN THÊM: REVIEW / RATING ======
        double avgRating = reviewService.getAverageRating(id);
        int reviewCount = reviewService.countReviews(id);

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
                boolean hasPurchased = orderService.hasUserPurchasedProduct(user.getId(), id);
                // Kiểm tra xem user đã đánh giá sản phẩm này chưa
                hasReviewed = reviewService.hasUserReviewedProduct(user.getId(), id);

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
            } catch (NumberFormatException ignored) {
            }
        }

        int totalReviews = reviewService.countReviews(id);
        int totalPages = (int) Math.ceil((double) totalReviews / pageSize);

        request.setAttribute("reviews",
                reviewService.getReviewsByProductPaging(id, page, pageSize));

        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("star5", reviewService.countByStar(id, 5));
        request.setAttribute("star4", reviewService.countByStar(id, 4));
        request.setAttribute("star3", reviewService.countByStar(id, 3));
        request.setAttribute("star2", reviewService.countByStar(id, 2));
        request.setAttribute("star1", reviewService.countByStar(id, 1));
        request.setAttribute("commentCount", reviewService.countWithComment(id));

        // ===== SẢN PHẨM LIÊN QUAN =====
        List<Product> relatedProducts = productService.getRelatedProducts(
                product.getCategoryId(),
                product.getId(),
                20);
        User user = session != null ? (User) session.getAttribute("user") : null;
        // ======= 7. LOAD WISHLIST (QUAN TRỌNG) =======
        if (user != null) {
            List<Integer> wishlistProductIds = wishlistService.getWishlistProductIds(user.getId());
            request.setAttribute("wishlistProductIds", wishlistProductIds);
        }

        request.setAttribute("relatedProducts", relatedProducts);

        request.getRequestDispatcher("/page/product-details.jsp")
                .forward(request, response);
    }

    /**
     * Tính phần trăm giảm giá từ giá gốc và giá khuyến mãi
     * 
     * @param originalPrice Giá gốc
     * @param finalPrice    Giá sau khuyến mãi
     * @return Phần trăm giảm giá (làm tròn)
     */
    private int calculateDiscountPercent(double originalPrice, double finalPrice) {
        if (originalPrice <= 0 || finalPrice < 0) {
            return 0;
        }

        if (finalPrice >= originalPrice) {
            return 0; // Không có giảm giá
        }

        double discount = ((originalPrice - finalPrice) / originalPrice) * 100;
        return (int) Math.round(discount);
    }
}