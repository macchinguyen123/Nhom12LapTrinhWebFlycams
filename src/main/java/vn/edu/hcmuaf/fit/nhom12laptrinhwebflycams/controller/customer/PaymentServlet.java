package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrderItemsDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;

@WebServlet(name = "PaymentServlet", value = "/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        // 1. Lấy user từ session
        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        Integer addressId = (Integer) session.getAttribute("addressId"); // có thể null



        // 3. Lấy payment method
        String paymentMethod = req.getParameter("paymentMethod");
        if (paymentMethod == null) {
            paymentMethod = "COD"; // default
        }

        // 4. Lấy note nếu có
        String note = (String) session.getAttribute("note");

        // 5. Lấy sản phẩm mua ngay
        Object itemObj = session.getAttribute("BUY_NOW_ITEM");
        Object productObj = session.getAttribute("BUY_NOW_PRODUCT");

        if (itemObj == null || productObj == null) {
            resp.sendRedirect(req.getContextPath() + "/shoppingcart.jsp");
            return;
        }

        OrderItems item = (OrderItems) itemObj;
        Product product = (Product) productObj;

        try {
            // 6. Tạo order
            Orders order = new Orders();
            order.setUserId(user.getId());
            order.setAddressId(addressId);
            order.setPhoneNumber((String) session.getAttribute("phone"));
            order.setPaymentMethod(paymentMethod);
            order.setNote(note);
            order.setStatus(Orders.Status.PENDING);
            order.setCreatedAt(Timestamp.valueOf(LocalDateTime.now()));
            order.setTotalPrice(item.getPrice() * item.getQuantity());

            OrdersDAO ordersDAO = new OrdersDAO();
            int orderId = ordersDAO.insert(order); // insert và lấy ID

            if (orderId == -1) {
                throw new Exception("Insert order failed");
            }

            // 7. Tạo order items
            OrderItemsDAO orderItemsDAO = new OrderItemsDAO();
            item.setOrderId(orderId);
            orderItemsDAO.insert(item);

            // 8. Xóa session mua ngay
            session.removeAttribute("BUY_NOW_ITEM");
            session.removeAttribute("BUY_NOW_PRODUCT");

            // 9. Redirect về personal-page
            resp.sendRedirect(req.getContextPath() + "/page/personal-page.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Insert order failed");
        }
    }
}