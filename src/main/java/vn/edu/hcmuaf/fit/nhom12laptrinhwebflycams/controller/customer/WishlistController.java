package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.WishlistService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.PriceFormatter;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "Wishlist", value = "/wishlist")
public class WishlistController extends HttpServlet {
    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user != null) {
            List<Product> products = wishlistService.getWishlistProducts(user.getId());
            request.setAttribute("products", products);
        }
        request.setAttribute("formatter", new PriceFormatter());
        request.getRequestDispatcher("/page/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("=== [WISHLIST] POST REQUEST ===");
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        response.setContentType("application/json;charset=UTF-8");

        if (user == null) {
            System.out.println("[WISHLIST] User chưa đăng nhập");
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"success\":false,\"message\":\"NOT_LOGIN\"}");
            return;
        }

        String action = request.getParameter("action");
        String productIdRaw = request.getParameter("productId");

        System.out.println("[WISHLIST] UserId = " + user.getId());
        System.out.println("[WISHLIST] Action = " + action);
        System.out.println("[WISHLIST] ProductId = " + productIdRaw);

        if (action == null || action.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"ACTION_NULL\"}");
            return;
        }

        if (productIdRaw == null || productIdRaw.isBlank()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"PRODUCT_ID_NULL\"}");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdRaw);
        } catch (NumberFormatException e) {
            System.out.println("[WISHLIST] ProductId không hợp lệ: " + productIdRaw);
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"success\":false,\"message\":\"PRODUCT_ID_INVALID\"}");
            return;
        }

        boolean success;
        switch (action) {
            case "add":
                success = wishlistService.add(user.getId(), productId);
                System.out.println("[WISHLIST] Add result = " + success);
                break;
            case "remove":
                success = wishlistService.remove(user.getId(), productId);
                System.out.println("[WISHLIST] Remove result = " + success);
                break;
            case "toggle":
                success = wishlistService.toggleWishlist(user.getId(), productId);
                System.out.println("[WISHLIST] Toggle result = " + success);
                break;
            default:
                System.out.println("[WISHLIST] Action không hợp lệ: " + action);
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"success\":false,\"message\":\"ACTION_INVALID\"}");
                return;
        }

        response.getWriter().write("{\"success\":" + success + "}");
    }
}
