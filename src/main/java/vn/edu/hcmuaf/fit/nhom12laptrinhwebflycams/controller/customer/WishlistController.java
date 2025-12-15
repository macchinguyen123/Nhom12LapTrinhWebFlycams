package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.WishlistDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Wishlists;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;


@WebServlet(name = "Wishlist", value = "/wishlist")
public class WishlistController extends HttpServlet {
    private final WishlistDAO wishlistDAO = new WishlistDAO();
    private final ProductDAO productDAO = new ProductDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        System.out.println("[Wishlist] User: " + user);

        List<Product> products = new ArrayList<>();

        if (user != null) {
            List<Wishlists> wishlists = wishlistDAO.getWishlistByUser(user.getId());
            System.out.println("[Wishlist] Wishlist count: " + wishlists.size());

            for (Wishlists w : wishlists) {
                Product p = productDAO.getProductById(w.getProductId());
                System.out.println("[Wishlist] ProductId: " + w.getProductId() + " → Found: " + (p != null));
                if (p != null) {
                    products.add(p);
                }
            }

            System.out.println("[Wishlist] Final product count: " + products.size());
        }

        request.setAttribute("products", products);
        request.getRequestDispatcher("/page/wishlist.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (User) (session != null ? session.getAttribute("user") : null);

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String productIdStr = request.getParameter("productId");

        if (productIdStr == null || productIdStr.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu productId");
            return;
        }

        int productId = Integer.parseInt(productIdStr);

        if ("add".equals(action)) {
            boolean success = wishlistDAO.addToWishlist(user.getId(), productId);
            if (!success) {
                System.out.println("[Wishlist] Product đã tồn tại trong wishlist, không thêm nữa.");
            }

    } else if ("remove".equals(action)) {
            wishlistDAO.removeFromWishlist(user.getId(), productId);
        }

        response.sendRedirect("wishlist");
    }





}


