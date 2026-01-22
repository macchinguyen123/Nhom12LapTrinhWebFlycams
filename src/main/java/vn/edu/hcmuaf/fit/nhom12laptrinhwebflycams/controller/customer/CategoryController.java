package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.CategoryService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.ProductService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.WishlistService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.PriceFormatter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebServlet(name = "Category", value = "/Category")
public class CategoryController extends HttpServlet {

    private final ProductService productService = new ProductService();
    private final CategoryService categoryService = new CategoryService();
    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        // ======= 1. Lấy ID danh mục ========
        String id_raw = request.getParameter("id");
        if (id_raw == null) {
            response.sendRedirect("home");
            return;
        }

        int categoryId = Integer.parseInt(id_raw);

        // Lấy thông tin category
        Categories category = categoryService.getCategoryById(categoryId);
        if (category == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        // ======= 2. Từ khóa tìm kiếm (nếu có) =======
        String keyword = request.getParameter("keyword");

        // ======= 3. Lọc theo giá =======
        String giaTuStr = request.getParameter("gia-tu");
        String giaDenStr = request.getParameter("gia-den");

        Double minPrice = null;
        Double maxPrice = null;

        try {
            if (giaTuStr != null && !giaTuStr.trim().isEmpty()) {
                String s = giaTuStr.trim().replaceAll("[^0-9]", "");
                if (!s.isEmpty())
                    minPrice = Double.parseDouble(s);
            }
        } catch (NumberFormatException ignored) {
        }

        try {
            if (giaDenStr != null && !giaDenStr.trim().isEmpty()) {
                String s = giaDenStr.trim().replaceAll("[^0-9]", "");
                if (!s.isEmpty())
                    maxPrice = Double.parseDouble(s);
            }
        } catch (NumberFormatException ignored) {
        }

        String priceFilter = request.getParameter("chon-gia");

        if ((minPrice == null && maxPrice == null) && priceFilter != null) {
            switch (priceFilter) {
                case "duoi-5000000":
                    maxPrice = 5_000_000.0;
                    break;
                case "5-10":
                    minPrice = 5_000_000.0;
                    maxPrice = 10_000_000.0;
                    break;
                case "10-20":
                    minPrice = 10_000_000.0;
                    maxPrice = 20_000_000.0;
                    break;
                case "tren-20":
                    minPrice = 20_000_000.0;
                    break;
                default:
                    break;
            }
        }

        // ======= 4. Lọc theo thương hiệu =======
        String[] brandArr = request.getParameterValues("chon-thuong-hieu");
        List<String> brandList = (brandArr != null) ? Arrays.asList(brandArr) : null;

        // ======= 5. Sắp xếp =======
        String sortParam = request.getParameter("sort"); // "asc" hoặc "desc"
        String sortBy = null; // giá trị truyền vào DAO

        if ("asc".equals(sortParam))
            sortBy = "low-high";
        else if ("desc".equals(sortParam))
            sortBy = "high-low";

        // ======= 6. Lấy danh sách sản phẩm theo category + lọc =======
        List<Product> products = productService.searchProductsInCategory(
                categoryId,
                keyword,
                minPrice,
                maxPrice,
                brandList,
                sortBy);
        // ======= 7. LOAD WISHLIST (QUAN TRỌNG) =======
        if (user != null) {
            List<Integer> wishlistProductIds = wishlistService.getWishlistProductIds(user.getId());
            request.setAttribute("wishlistProductIds", wishlistProductIds);
        }

        // ======= 7. Gửi xuống JSP =======
        request.setAttribute("category", category);
        request.setAttribute("products", products);
        request.setAttribute("formatter", new PriceFormatter());

        // ======= 8. Forward tới trang category =======
        request.getRequestDispatcher("/page/category.jsp").forward(request, response);

        System.out.println("Category ID = " + categoryId);
        System.out.println("Products count = " + products.size());
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    }
}
