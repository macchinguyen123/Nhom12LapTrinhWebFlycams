package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.CategoryDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "Category", value = "/Category")
public class CategoryController extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id_raw = request.getParameter("id");

        if (id_raw == null) {
            response.sendRedirect("home");
            return;
        }

        int categoryId = Integer.parseInt(id_raw);

        // Lấy thông tin danh mục
        Categories category = categoryDAO.getCategoryById(categoryId);

        // Nếu danh mục không tồn tại → redirect
        if (category == null) {
            response.sendRedirect("page/homepage.jsp");
            return;
        }

        // Lấy danh sách sản phẩm theo danh mục
        List<Product> products = productDAO.getProductsByCategory(categoryId);

        request.setAttribute("category", category);
        request.setAttribute("products", products);

        // Chuyển sang trang JSP
        request.getRequestDispatcher("/page/category/mini-drone.jsp").forward(request, response);
        System.out.println("ID = " + id_raw);
        System.out.println("Category = " + products.toString());

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) {
    }
}
