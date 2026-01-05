package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.CategoryDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.HomeDao;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ReviewsDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Post;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.WishlistService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.PriceFormatter;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "HomeServlet", value = "/home")
public class HomeServlet extends HttpServlet {

    private final WishlistService wishlistService = new WishlistService();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HomeDao homeDao = new HomeDao();

        // Lấy 5 sản phẩm bán chạy
        List<Product> bestSellerProducts = homeDao.getBestSellerProducts(5);
        // 10 sản phẩm nổi bật theo lượt đánh giá
        List<Product> topReviewedProducts = homeDao.getTopReviewedProducts(10);

        request.setAttribute("bestSellerProducts", bestSellerProducts);
        request.setAttribute("formatter", new PriceFormatter());
        request.setAttribute("topReviewedProducts", topReviewedProducts);

        List<Product> quayPhim =
                homeDao.getProductsByCategory(1001, 8);
        List<Product> mini =
                homeDao.getProductsByCategory(1004, 8);



// Lấy 8 bài viết mới nhất
        List<Post> latestPosts = homeDao.getLatestPosts(8);
        // ======= 7. LOAD WISHLIST (QUAN TRỌNG) =======
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        if (user != null) {
            List<Integer> wishlistProductIds =
                    wishlistService.getWishlistProductIds(user.getId());
            request.setAttribute("wishlistProductIds", wishlistProductIds);
        }

        CategoryDAO categoryDAO = new CategoryDAO();

        List<Categories> headerCategories = categoryDAO.getCategoriesForHeader();
        request.setAttribute("headerCategories", headerCategories);


        request.setAttribute("latestPosts", latestPosts);
        request.setAttribute("quayPhim", quayPhim);
        request.setAttribute("mini", mini);
        request.getRequestDispatcher("/page/homepage.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}