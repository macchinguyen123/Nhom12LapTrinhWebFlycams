package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrderDaoAdmin;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "OrderActionServlet", value = "/admin/order-action")
public class OrderActionServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    private OrderDaoAdmin dao = new OrderDaoAdmin();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            // Đảm bảo encoding đúng
            req.setCharacterEncoding("UTF-8");

            String idStr = req.getParameter("id");
            String action = req.getParameter("action");

            System.out.println("Content-Type: " + req.getContentType());
            System.out.println("ID = [" + idStr + "]");
            System.out.println("ACTION = [" + action + "]");

            if (idStr == null || idStr.isEmpty()) {
                Map<String, Object> error = new HashMap<>();
                error.put("success", false);
                error.put("message", "Missing order id");

                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().print(new Gson().toJson(error));
                return;
            }

            int orderId = Integer.parseInt(idStr);

            boolean success = false;
            String newStatus = null;

            if ("confirm".equals(action)) {
                newStatus = "Đang xử lý";
                success = dao.updateOrderStatus(orderId, newStatus);
            } else if ("cancel".equals(action)) {
                newStatus = "Hủy";
                success = dao.updateOrderStatus(orderId, newStatus);
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", success);
            result.put("status", newStatus);

            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().print(new Gson().toJson(result));

        } catch (Exception e) {
            e.printStackTrace();

            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", e.getMessage());

            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().print(new Gson().toJson(error));
        }
    }
}