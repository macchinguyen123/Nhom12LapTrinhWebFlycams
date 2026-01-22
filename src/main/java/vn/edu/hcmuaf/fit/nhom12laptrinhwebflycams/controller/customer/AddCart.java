package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.CartService;

import java.io.IOException;

@WebServlet(name = "AddCart", value = "/add-cart")
public class AddCart extends HttpServlet {
    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        response.setContentType("application/json;charset=UTF-8");

        try {
            String pid = request.getParameter("productId");
            String quantityStr = request.getParameter("quantity");

            System.out.println("[AddCart] ProductId: " + pid + ", Quantity: " + quantityStr);

            if (pid == null || pid.isEmpty()) {
                response.getWriter().write("{\"success\":false,\"message\":\"Thiếu ID sản phẩm\"}");
                return;
            }

            int productId = Integer.parseInt(pid);
            int quantity = 1;
            if (quantityStr != null && !quantityStr.isEmpty()) {
                quantity = Integer.parseInt(quantityStr);
            }

            Carts cart = (Carts) session.getAttribute("cart");
            if (cart == null)
                cart = new Carts();

            // Delegate to Service
            boolean added = cartService.addToCart(cart, productId, quantity);

            if (added) {
                session.setAttribute("cart", cart);
                System.out.println("[AddCart] Added to cart. Total items: " + cart.totalQuantity());
                response.getWriter().write("{\"success\":true,\"totalQuantity\":" + cart.totalQuantity() + "}");
            } else {
                System.out.println("[AddCart] Product not found for ID: " + productId);
                response.getWriter().write("{\"success\":false,\"message\":\"Sản phẩm không tồn tại\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"success\":false,\"message\":\"Lỗi server: " + e.getMessage() + "\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward POST request sang GET để xử lý
        doGet(request, response);
    }
}