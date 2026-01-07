package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.ProductService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;

import java.io.IOException;

@WebServlet(name = "AddCart", value = "/add-cart")
public class AddCart extends HttpServlet {
    private ProductService productService = new ProductService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String pid = request.getParameter("productId");
        if (pid == null || pid.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/page/shoppingcart.jsp");
            return;
        }

        int productId = Integer.parseInt(pid);

        String q = request.getParameter("quantity");
        int quantity = 1;
        if (q != null && !q.isEmpty()) {
            quantity = Integer.parseInt(q);
        }

        HttpSession session = request.getSession();
        Carts cart = (Carts) session.getAttribute("cart");
        if (cart == null) cart = new Carts();

        Product product = productService.getProduct(productId);
        if (product != null) {
            cart.addItem(product, quantity);
            session.setAttribute("cart", cart);
        }

        // Kiểm tra xem request có phải từ AJAX không
        String ajaxHeader = request.getHeader("X-Requested-With");
        boolean isAjax = "XMLHttpRequest".equals(ajaxHeader);

        if (isAjax) {
            // Trả về JSON response cho AJAX
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"success\":true,\"cartSize\":" + cart.getItems().size() + "}");
        } else {
            // Redirect như bình thường nếu không phải AJAX
            response.sendRedirect(request.getContextPath() + "/page/shoppingcart.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward POST request sang GET để xử lý
        doGet(request, response);
    }
}