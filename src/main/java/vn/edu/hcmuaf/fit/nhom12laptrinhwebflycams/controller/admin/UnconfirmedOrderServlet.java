package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import com.mysql.cj.x.protobuf.MysqlxCrud;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.OrderService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UnconfirmedOrderServlet", value = "/admin/unconfirmed-orders")
public class UnconfirmedOrderServlet extends HttpServlet {
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Orders> orders = orderService.getPendingOrders();
        request.setAttribute("orders", orders);

        request.getRequestDispatcher(
                "/page/admin/uncomfirmed-order-manage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}