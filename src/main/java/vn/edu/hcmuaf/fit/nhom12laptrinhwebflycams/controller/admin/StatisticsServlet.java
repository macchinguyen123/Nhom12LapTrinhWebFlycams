package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.DashboardDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "StatisticsServlet", value = "/admin/statistics")
public class StatisticsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        DashboardDAO dao = new DashboardDAO();

        Map<String, Double> revenue8Days = dao.getRevenueLast8Days();
        Map<String, Double> revenueByMonth = dao.getRevenueByMonth();

        request.setAttribute("revenueDays", revenue8Days.keySet());
        request.setAttribute("revenueValues", revenue8Days.values());

        request.setAttribute("revenueMonths", revenueByMonth.keySet());
        request.setAttribute("revenueMonthValues", revenueByMonth.values());

        // ====== THỐNG KÊ ======
        request.setAttribute("revenueToday", dao.getRevenueToday());
        request.setAttribute("revenueMonth", dao.getRevenueThisMonth());
        request.setAttribute("ordersToday", dao.getOrdersToday());
        request.setAttribute("bestProduct", dao.getBestSellingProduct());

        // ====== ĐƠN TRONG NGÀY ======
        request.setAttribute("todayOrders", dao.getTodayOrders());

        request.getRequestDispatcher("/page/admin/statistics.jsp")
                .forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

