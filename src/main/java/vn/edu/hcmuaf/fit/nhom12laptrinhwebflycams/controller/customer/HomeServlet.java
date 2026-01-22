package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.PriceFormatter;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {

        private final WishlistService wishlistService = new WishlistService();

        @Override
        protected void doGet(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {

                ProductService productService = new ProductService();
                BannerService bannerService = new BannerService();
                ArticleService articleService = new ArticleService();
                CategoryService categoryService = new CategoryService();

                // ======= BANNER =======
                // Lấy tất cả banner active, đã sắp xếp theo order_index
                List<Banner> activeBanners = bannerService.getActiveBanners();
                request.setAttribute("banners", activeBanners);
                // Lấy 5 sản phẩm bán chạy
                List<Product> bestSellerProducts = productService.getBestSellerProducts(5);
                // 10 sản phẩm nổi bật theo lượt xem
                List<Product> topReviewedProducts = productService.getTopViewedProducts(10);

                request.setAttribute("bestSellerProducts", bestSellerProducts);
                request.setAttribute("formatter", new PriceFormatter());
                request.setAttribute("topReviewedProducts", topReviewedProducts);

                List<Product> quayPhim = productService.getProductsByCategory(1001, 8);
                List<Product> mini = productService.getProductsByCategory(1004, 8);

                // Lấy 8 bài viết mới nhất
                List<Post> latestPosts = articleService.getLatestPosts(8);
                // ======= 7. LOAD WISHLIST (QUAN TRỌNG) =======
                HttpSession session = request.getSession(false);
                User user = session != null ? (User) session.getAttribute("user") : null;
                if (user != null) {

                        List<Integer> wishlistProductIds = wishlistService.getWishlistProductIds(user.getId());
                        request.setAttribute("wishlistProductIds", wishlistProductIds);
                }

                List<Categories> headerCategories = categoryService.getCategoriesForHeader();
                request.setAttribute("headerCategories", headerCategories);

                request.setAttribute("latestPosts", latestPosts);
                request.setAttribute("quayPhim", quayPhim);
                request.setAttribute("mini", mini);
                request.getRequestDispatcher("/page/homepage.jsp")
                                .forward(request, response);
        }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                        throws ServletException, IOException {

        }
}