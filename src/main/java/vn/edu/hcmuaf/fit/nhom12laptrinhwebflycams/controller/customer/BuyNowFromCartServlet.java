package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.AddressDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BuyNowFromCartServlet", value = "/BuyNowFromCart")
public class BuyNowFromCartServlet extends HttpServlet {

    private ProductDAO productDAO = new ProductDAO();
    private AddressDAO addressDAO = new AddressDAO();
    private OrdersDAO ordersDAO = new OrdersDAO(); // ← SỬA LẠI TÊN

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        //  Check login
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        User user = (User) session.getAttribute("user");

        List<OrderItems> buyNowItems = new ArrayList<>();

        String orderIdParam = req.getParameter("orderId");

        if (orderIdParam != null && !orderIdParam.isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdParam);

                // Lấy thông tin đơn hàng cũ (dùng method có sẵn)
                Orders oldOrder = ordersDAO.getOrderById(orderId, user.getId());

                if (oldOrder == null) {
                    // Đơn hàng không tồn tại hoặc không thuộc về user này
                    resp.sendRedirect(req.getContextPath() + "/purchase-history");
                    return;
                }

                // Lấy danh sách sản phẩm từ đơn hàng cũ (dùng method có sẵn)
                List<OrderItems> oldItems = ordersDAO.getOrderItems(orderId);

                for (OrderItems oldItem : oldItems) {
                    // Lấy thông tin sản phẩm mới nhất
                    Product product = productDAO.getProductById(oldItem.getProductId());

                    if (product == null) continue; // Sản phẩm đã bị xóa

                    OrderItems item = new OrderItems();
                    item.setProductId(product.getId());
                    item.setQuantity(oldItem.getQuantity()); // Giữ nguyên số lượng
                    item.setPrice(product.getFinalPrice()); // Lấy giá mới nhất
                    item.setProduct(product);

                    buyNowItems.add(item);
                }

            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/purchase-history");
                return;
            }
        }

        else {
            String[] productIds = req.getParameterValues("productId");
            String[] quantities = req.getParameterValues("quantities");

            if (productIds == null || quantities == null) {
                resp.sendRedirect(req.getContextPath() + "/page/shoppingcart.jsp");
                return;
            }

            try {
                for (int i = 0; i < productIds.length; i++) {
                    int productId = Integer.parseInt(productIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);

                    Product product = productDAO.getProductById(productId);
                    if (product == null) continue;

                    OrderItems item = new OrderItems();
                    item.setProductId(productId);
                    item.setQuantity(quantity);
                    item.setPrice(product.getFinalPrice());
                    item.setProduct(product);

                    buyNowItems.add(item);
                }
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/page/shoppingcart.jsp");
                return;
            }
        }

        // ========================================
        //  KIỂM TRA VÀ LƯU SESSION
        // ========================================
        if (buyNowItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/page/shoppingcart.jsp");
            return;
        }

        //  Lưu BUY NOW vào session
        session.setAttribute("BUY_NOW_ITEM", buyNowItems);

        //  Lấy địa chỉ user
        List<Address> addresses = null;
        try {
            addresses = addressDAO.findByUserId(user.getId());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        req.setAttribute("addresses", addresses);

        // Forward sang trang giao hàng
        req.getRequestDispatcher("/page/delivery-info.jsp")
                .forward(req, resp);
    }
}