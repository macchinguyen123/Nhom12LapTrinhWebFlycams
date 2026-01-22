package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import com.mysql.cj.x.protobuf.MysqlxCrud;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.OrderService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "ConfirmedOrderManageServlet", value = "/admin/order-manage")
public class ConfirmedOrderManageServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        OrderService orderService = new OrderService();
        List<Orders> orders = orderService.getOrdersForAdmin();

        req.setAttribute("orders", orders);
        req.getRequestDispatcher(
                "/page/admin/comfirmed-order-manage.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}