package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrderItemsDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/rebuy")
public class ReBuyController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

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

        OrderItemsDAO orderItemsDAO = new OrderItemsDAO();
        List<OrderItems> items = orderItemsDAO.getItemsByOrderId(orderId);

        if (items == null || items.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/purchasehistory");
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("BUY_NOW_ITEM", items);

        resp.sendRedirect(req.getContextPath() + "/page/payment.jsp");
    }
}
