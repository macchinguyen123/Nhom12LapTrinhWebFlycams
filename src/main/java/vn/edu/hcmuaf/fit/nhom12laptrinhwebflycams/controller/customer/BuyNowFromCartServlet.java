package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.AddressService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.CartService;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "BuyNowFromCartServlet", value = "/BuyNowFromCart")
public class BuyNowFromCartServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Check login
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        User user = (User) session.getAttribute("user");

        List<OrderItems> buyNowItems;
        CartService cartService = new CartService();

        String orderIdParam = req.getParameter("orderId");

        if (orderIdParam != null && !orderIdParam.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdParam);
                buyNowItems = cartService.prepareBuyNowFromOrder(orderId, user.getId());

                if (buyNowItems.isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/purchase-history");
                    return;
                }
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/purchase-history");
                return;
            }
        } else {
            String[] productIds = req.getParameterValues("productId");
            String[] quantities = req.getParameterValues("quantities");

            if (productIds == null || quantities == null) {
                resp.sendRedirect(req.getContextPath() + "/page/shoppingcart.jsp");
                return;
            }

            buyNowItems = cartService.prepareBuyNowFromSelection(productIds, quantities);
        }

        // ========================================
        // KIỂM TRA VÀ LƯU SESSION
        // ========================================
        if (buyNowItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/page/shoppingcart.jsp");
            return;
        }

        // Lưu BUY NOW vào session
        session.setAttribute("BUY_NOW_ITEM", buyNowItems);

        // Lấy địa chỉ user
        AddressService addressService = new AddressService();
        List<Address> addresses = null;
        try {
            addresses = addressService.findByUserId(user.getId());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        req.setAttribute("addresses", addresses);

        // Forward sang trang giao hàng
        req.getRequestDispatcher("/page/delivery-info.jsp")
                .forward(req, resp);
    }
}