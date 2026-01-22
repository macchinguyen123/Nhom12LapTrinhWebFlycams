package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.OrderService;

import java.io.IOException;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PaymentServlet", value = "/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        List<OrderItems> items = (List<OrderItems>) session.getAttribute("BUY_NOW_ITEM");

        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Integer addressId = (Integer) session.getAttribute("addressId");
        String phone = (String) session.getAttribute("phone");
        String note = (String) session.getAttribute("note");

        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null)
            paymentMethod = "COD";

        if (items == null || items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/shopping-cart.jsp");
            return;
        }

        try {
            Carts cart = (Carts) session.getAttribute("cart");
            OrderService orderService = new OrderService();
            int orderId = orderService.placeOrder(user, addressId, phone, note, paymentMethod, items, cart);

            if (cart != null) {
                session.setAttribute("cart", cart);
            }

            session.removeAttribute("BUY_NOW_ITEM");
            session.removeAttribute("note");

            List<Orders> orders = orderService.getOrdersByUser(user.getId());
            req.setAttribute("orders", orders);

            RequestDispatcher dispatcher = req.getRequestDispatcher("/page/personal-page.jsp");
            resp.sendRedirect(req.getContextPath() + "/personal?tab=orders");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Payment failed");
        }
    }
}