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

}


