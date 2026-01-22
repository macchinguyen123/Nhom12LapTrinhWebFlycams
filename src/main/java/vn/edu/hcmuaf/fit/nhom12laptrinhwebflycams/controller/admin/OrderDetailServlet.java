package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.OrderService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet(name = "OrderDetailServlet", value = "/admin/order-detail")
public class OrderDetailServlet extends HttpServlet {
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        Map<String, Object> order = orderService.getOrderDetailAdmin(id);

        resp.setContentType("application/json;charset=UTF-8");

        Gson gson = new GsonBuilder()
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .create();

        Map<String, Object> result = new HashMap<>();
        result.put("order", order);

        List<Map<String, Object>> items = orderService.getOrderItemsAdmin(id);
        result.put("items", items);

        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().print(gson.toJson(result));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}