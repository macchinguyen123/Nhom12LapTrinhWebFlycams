package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.DashboardDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "AdminDashboardServlet", value = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
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

        request.setAttribute("totalUsers", dao.getTotalUsers());
        request.setAttribute("totalProducts", dao.getTotalProducts());
        request.setAttribute("totalOrders", dao.getTotalOrders());
        request.setAttribute("monthlyRevenue", dao.getMonthlyRevenue());
        request.setAttribute("revenueMap", dao.getRevenueLast30Days());
        request.setAttribute("userGrowthRate", dao.getUserGrowthRate());
        request.setAttribute("totalCategories", dao.getTotalCategories());
        request.setAttribute("processingOrders", dao.getProcessingOrders());
        request.setAttribute("monthlyTarget", dao.getMonthlyTarget());

        List<User> newUsers = dao.getNewUsersLast7Days();
        request.setAttribute("newUsers", newUsers);

        request.setAttribute("recentOrders", dao.getRecentOrders());

        Map<String, Double> revenue30Days = dao.getRevenueLast30Days();
        request.setAttribute("revenueLabels", revenue30Days.keySet());
        request.setAttribute("revenueValues", revenue30Days.values());

        request.getRequestDispatcher("/page/admin/dashboard.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}