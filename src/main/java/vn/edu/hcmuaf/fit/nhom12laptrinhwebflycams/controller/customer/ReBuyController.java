package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.CartService;

import java.io.IOException;
import java.util.List;

@WebServlet("/rebuy")
public class ReBuyController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        CartService cartService = new CartService();

        String orderIdRaw = req.getParameter("orderId");

        if (orderIdRaw == null || orderIdRaw.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/purchasehistory");
            return;
        }

        int orderId;
        try {
            orderId = Integer.parseInt(orderIdRaw);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/purchasehistory");
            return;
        }

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        // Use CartService to prepare items from previous order
        List<OrderItems> items = cartService.prepareBuyNowFromOrder(orderId, user.getId());

        if (items == null || items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/purchasehistory");
            return;
        }

        session.setAttribute("BUY_NOW_ITEM", items);

        resp.sendRedirect(req.getContextPath() + "/page/delivery-info.jsp");
    }
}
