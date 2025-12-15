package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.CategoryDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ReviewsDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.PriceFormatter;

import java.io.IOException;

@WebServlet(name = "ProductDetailServlet", value = "/product-detail")
public class ProductDetailServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ReviewsDAO reviewsDAO = new ReviewsDAO();

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

        request.setAttribute("avgRating", String.format("%.1f", avgRating));
        request.setAttribute("reviewCount", reviewCount);
        request.setAttribute("reviews", reviewsDAO.getReviewsByProduct(id));

        request.setAttribute("formatter", new PriceFormatter());
        request.setAttribute("product", product);
        request.setAttribute("categoryName", categoryName);

        request.getRequestDispatcher("/page/product-details.jsp")
                .forward(request, response);
    }
}
