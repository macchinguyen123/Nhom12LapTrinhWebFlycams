package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrderItemsDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/purchasehistory")
public class PurchaseHistoryController extends HttpServlet {

    private final OrdersDAO ordersDAO = new OrdersDAO();
    private final OrderItemsDAO orderItemsDAO = new OrderItemsDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        List<Orders> orders = ordersDAO.getOrdersByUser1(user.getId());

        for (Orders o : orders) {
            o.setItems(orderItemsDAO.getItemsByOrderId(o.getId()));
            mapStatus(o);
        }

        req.setAttribute("orders", orders);
        req.getRequestDispatcher("/page/purchasehistory.jsp")
                .forward(req, resp);
    }

    private void mapStatus(Orders o) {
        switch (o.getStatus()) {

            case DELIVERED -> {
                o.setStatusLabel("Đã nhận hàng");
                o.setStatusClass("da-nhan-hang");
            }
            case CANCELLED -> {
                o.setStatusLabel("Đã hủy");
                o.setStatusClass("da-huy");
            }
        }
    }
}

