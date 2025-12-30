package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrderItemsDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "PaymentServlet", value = "/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();


        List<OrderItems> items =
                (List<OrderItems>) session.getAttribute("BUY_NOW_ITEM");


        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Integer addressId = (Integer) session.getAttribute("addressId");
        String phone = (String) session.getAttribute("phone");
        String note = (String) session.getAttribute("note");

        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null) paymentMethod = "COD";

        if (items == null || items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/shopping-cart.jsp");
            return;
        }

        try {
            double totalPrice = 0;
            for (OrderItems item : items) {
                totalPrice += item.getPrice() * item.getQuantity();
            }

            Orders order = new Orders();
            order.setUserId(user.getId());
            order.setAddressId(addressId);
            order.setPhoneNumber(phone);
            order.setPaymentMethod(paymentMethod);
            order.setNote(note);
            order.setStatus(Orders.Status.PENDING);
            order.setCreatedAt(Timestamp.valueOf(LocalDateTime.now()));
            order.setTotalPrice(totalPrice);

            OrdersDAO ordersDAO = new OrdersDAO();
            int orderId = ordersDAO.insert(order);

            if (orderId <= 0) {
                throw new Exception("Insert order failed");
            }

            OrderItemsDAO orderItemsDAO = new OrderItemsDAO();
            for (OrderItems item : items) {
                item.setOrderId(orderId);
                orderItemsDAO.insert(item);
            }

            session.removeAttribute("BUY_NOW_ITEM");
            session.removeAttribute("note");

            List<Orders> orders = ordersDAO.getOrdersByUser(user.getId());
            req.setAttribute("orders", orders);

            RequestDispatcher dispatcher = req.getRequestDispatcher("/page/personal-page.jsp");
            resp.sendRedirect(req.getContextPath() + "/personal?tab=orders");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Payment failed");
        }
    }
}