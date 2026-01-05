package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.AddressDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;
import java.util.Map;

@WebServlet(name = "Personal", value = "/personal")
public class Personal extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final OrdersDAO ordersDAO = new OrdersDAO();
    private final AddressDAO addressDAO = new AddressDAO(); // 🔹 THÊM AddressDAO

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        long startTime = System.currentTimeMillis();

        HttpSession session = request.getSession(false);

        // ❌ Chưa login
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        // ✅ Lấy user từ session
        User sessionUser = (User) session.getAttribute("user");
        System.out.println("✅ PERSONAL PAGE - USER ID: " + sessionUser.getId());

        // 🔹 LẤY USER MỚI NHẤT TỪ DB (chỉ khi cần refresh)
        User user;
        String refresh = request.getParameter("refresh");

        if ("true".equals(refresh)) {
            long t1 = System.currentTimeMillis();
            user = userDAO.getUserById(sessionUser.getId());
            System.out.println("⏱️ getUserById (refreshed): " + (System.currentTimeMillis() - t1) + "ms");

            if (user == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/Login");
                return;
            }

            // Cập nhật session
            session.setAttribute("user", user);
        } else {
            // Dùng user từ session (nhanh hơn)
            user = sessionUser;
        }

        request.setAttribute("user", user);

        // 🔹 LẤY DANH SÁCH ĐƠN HÀNG
        long t2 = System.currentTimeMillis();
        List<Orders> orders = ordersDAO.getOrdersByUser(user.getId());
        System.out.println("⏱️ getOrdersByUser: " + (System.currentTimeMillis() - t2) + "ms | Orders: " + orders.size());
        request.setAttribute("orders", orders);

        // 🔹 LẤY DANH SÁCH ĐỊA CHỈ
        try {
            long t6 = System.currentTimeMillis();
            List<Address> addresses = addressDAO.findByUserId(user.getId());
            System.out.println("⏱️ getAddressesByUserId: " + (System.currentTimeMillis() - t6) + "ms | Addresses: " + addresses.size());
            request.setAttribute("addresses", addresses);
        } catch (SQLException e) {
            System.err.println("❌ Error loading addresses: " + e.getMessage());
            e.printStackTrace();
        }

        // 🔹 XEM CHI TIẾT ĐƠN HÀNG (NẾU CÓ orderId)
        String orderIdParam = request.getParameter("orderId");
        Orders selectedOrder = null;
        List<OrderItems> orderItems = null;

        if (orderIdParam != null && !orderIdParam.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdParam);

                long t3 = System.currentTimeMillis();
                selectedOrder = ordersDAO.getOrderById(orderId, user.getId());
                System.out.println("⏱️ getOrderById: " + (System.currentTimeMillis() - t3) + "ms");

                if (selectedOrder != null) {
                    // 🔸 LẤY CHI TIẾT SẢN PHẨM
                    long t4 = System.currentTimeMillis();
                    orderItems = ordersDAO.getOrderItems(orderId);
                    System.out.println("⏱️ getOrderItems: " + (System.currentTimeMillis() - t4) + "ms | Items: " + orderItems.size());

                    // 🔸 TÍNH NGÀY DỰ KIẾN (createdAt + 3 ngày)
                    LocalDateTime created = selectedOrder.getCreatedAt()
                            .toInstant()
                            .atZone(ZoneId.systemDefault())
                            .toLocalDateTime();

                    LocalDateTime expected = created.plusDays(3);
                    Date expectedDate = Date.from(expected.atZone(ZoneId.systemDefault()).toInstant());

                    request.setAttribute("expectedDeliveryDate", expectedDate);
                    request.setAttribute("orderItems", orderItems);

                    // 🔸 LẤY THÔNG TIN GIAO HÀNG
                    long t5 = System.currentTimeMillis();
                    Map<String, String> shippingInfo = ordersDAO.getShippingInfoByOrder(orderId);
                    System.out.println("⏱️ getShippingInfo: " + (System.currentTimeMillis() - t5) + "ms");

                    request.setAttribute("shippingInfo", shippingInfo);
                    request.setAttribute("activeTab", "orders");
                }
            } catch (NumberFormatException e) {
                System.err.println("❌ Invalid orderId: " + orderIdParam);
            }
        }

        // 🔹 CHECK TAB PARAM (để giữ tab active khi quay lại)
        String tabParam = request.getParameter("tab");
        if ("orders".equals(tabParam)) {
            request.setAttribute("activeTab", "orders");
        } else if ("addresses".equals(tabParam)) {
            request.setAttribute("activeTab", "addresses");
        }

        // 🔹 SET ATTRIBUTE CHO JSP
        request.setAttribute("selectedOrder", selectedOrder);

        long totalTime = System.currentTimeMillis() - startTime;
        System.out.println("⏱️ TOTAL SERVLET TIME: " + totalTime + "ms\n");

        request.getRequestDispatcher("/page/personal-page.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("cancelOrder".equals(action)) {
            try {
                int orderId = Integer.parseInt(request.getParameter("orderId"));

                ordersDAO.cancelOrder(orderId, user.getId());

                System.out.println("✅ Order #" + orderId + " cancelled by user #" + user.getId());

                // ✅ REDIRECT VỀ TAB ĐƠN MUA (GIỮ TAB ACTIVE)
                response.sendRedirect(request.getContextPath() + "/personal?tab=orders");
                return;

            } catch (NumberFormatException e) {
                System.err.println("❌ Cancel order failed: " + e.getMessage());
            }
        }

        // 🔁 Quay lại personal-page
        response.sendRedirect(request.getContextPath() + "/personal");
    }
}