package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import com.mysql.cj.x.protobuf.MysqlxCrud;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrderDaoAdmin;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "UnconfirmedOrderServlet", value = "/admin/unconfirmed-orders")
public class UnconfirmedOrderServlet extends HttpServlet {
    private OrderDaoAdmin orderDAO = new OrderDaoAdmin();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Orders> orders = orderDAO.getPendingOrders();
        request.setAttribute("orders", orders);

        request.getRequestDispatcher(
                "/page/admin/uncomfirmed-order-manage.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}