package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.OrderService;

import java.io.IOException;
import java.util.List;

@WebServlet("/purchasehistory")
public class PurchaseHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        OrderService orderService = new OrderService();

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        List<Orders> orders = orderService.getOrdersWithItemsByUser(user.getId());

        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/page/purchasehistory.jsp")
                .forward(req, resp);
    }
}
