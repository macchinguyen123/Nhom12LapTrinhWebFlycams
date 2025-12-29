package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.DashboardDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "StatisticsServlet", value = "/admin/statistics")
public class StatisticsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Chưa login
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Không phải admin
        if (user.getRoleId() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        DashboardDAO dao = new DashboardDAO();

        // Lấy danh sách đơn hàng trong ngày
        List<Orders> todayOrders = dao.getTodayOrders();
        request.setAttribute("todayOrders", todayOrders);

        // Lấy các chỉ số tổng quan cho ngày hôm nay
        request.setAttribute("totalOrdersToday", dao.getTotalOrdersToday());
        request.setAttribute("processingOrdersToday", dao.getProcessingOrdersToday());
        request.setAttribute("revenueToday", dao.getRevenueToday());
        request.setAttribute("newCustomersToday", dao.getNewCustomersToday());

        request.getRequestDispatcher("/page/admin/statistics.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
