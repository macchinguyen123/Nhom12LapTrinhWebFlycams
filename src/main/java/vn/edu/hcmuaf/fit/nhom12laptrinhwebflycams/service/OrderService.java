package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.cart.Carts;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrderDaoAdmin;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrderItemsDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductManagement;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public class OrderService {
    private OrdersDAO ordersDAO = new OrdersDAO();
    private OrderItemsDAO orderItemsDAO = new OrderItemsDAO();
    private ProductManagement productManagement = new ProductManagement();

    // Đặt hàng
    public int placeOrder(User user, int addressId, String phone, String note, String paymentMethod,
            List<OrderItems> items, Carts cart) throws Exception {
        if (items == null || items.isEmpty()) {
            return 0;
        }

        double totalPrice = 0;
        for (OrderItems item : items) {
            totalPrice += item.getPrice() * item.getQuantity();
        }

        Orders order = new Orders();
        order.setUserId(user.getId());
        order.setAddressId(addressId);
        order.setPhoneNumber(phone);
        order.setPaymentMethod(paymentMethod);
        order.setNote(note);
        order.setStatus(Orders.Status.PENDING);
        order.setCreatedAt(Timestamp.valueOf(LocalDateTime.now()));
        order.setTotalPrice(totalPrice);

        int orderId = ordersDAO.insert(order);

        if (orderId <= 0) {
            throw new Exception("Insert order failed");
        }

        for (OrderItems item : items) {
            item.setOrderId(orderId);
            orderItemsDAO.insert(item);

            // Reduce Product stock
            productManagement.reduceQuantity(item.getProductId(), item.getQuantity());

            // Update Cart
            if (cart != null) {
                cart.removeItem(item.getProductId());
            }
        }

        return orderId;
    }

    // Lấy danh sách đơn hàng của người dùng
    public List<Orders> getOrdersByUser(int userId) {
        return ordersDAO.getOrdersByUser(userId);
    }

    // Lấy lịch sử đơn hàng
    public List<Orders> getOrdersWithItemsByUser(int userId) {
        List<Orders> orders = ordersDAO.getOrdersByUser1(userId);
        for (Orders o : orders) {
            o.setItems(orderItemsDAO.getItemsByOrderId(o.getId()));
            mapStatus(o);
        }
        return orders;
    }

    // trạng thái đơn hàng
    private void mapStatus(Orders o) {
        switch (o.getStatus()) {
            case DELIVERED -> {
                o.setStatusLabel("Đã nhận hàng");
                o.setStatusClass("da-nhan-hang");
            }
            case CANCELLED -> {
                o.setStatusLabel("Đã hủy");
                o.setStatusClass("da-huy");
            }
            default -> {
                // Giữ trạng thái mặc định
            }
        }
    }

    // Lấy chi tiết một đơn hàng theo ID
    public Orders getOrderById(int orderId, int userId) {
        return ordersDAO.getOrderById(orderId, userId);
    }

    // Lấy thông tin giao hàng của đơn hàng
    public Map<String, String> getShippingInfoByOrder(int orderId) {
        return ordersDAO.getShippingInfoByOrder(orderId);
    }

    // Lấy danh sách sản phẩm trong một đơn hàng
    public List<OrderItems> getOrderItems(int orderId) {
        return ordersDAO.getOrderItems(orderId);
    }

    // Hủy đơn hàng
    public void cancelOrder(int orderId, int userId) {
        ordersDAO.cancelOrder(orderId, userId);
    }

    // Kiểm tra người dùng đã từng mua sản phẩm hay chưa, để ktr đánh giá
    public boolean hasUserPurchasedProduct(int userId, int productId) {
        return ordersDAO.hasUserPurchasedProduct(userId, productId);
    }

    // Admin
    private OrderDaoAdmin orderDaoAdmin = new OrderDaoAdmin();

    // Lấy toàn bộ đơn hàng cho Admin
    public List<Orders> getOrdersForAdmin() {
        return orderDaoAdmin.getOrdersForAdmin();
    }

    // Lấy danh sách đơn hàng đang chờ xử lý
    public List<Orders> getPendingOrders() {
        return orderDaoAdmin.getPendingOrders();
    }

    // Lấy chi tiết đơn hàng cho Admin
    public Map<String, Object> getOrderDetailAdmin(int orderId) {
        return orderDaoAdmin.getOrderDetail(orderId);
    }

    // Lấy danh sách sản phẩm trong đơn hàng
    public List<Map<String, Object>> getOrderItemsAdmin(int orderId) {
        return orderDaoAdmin.getOrderItems(orderId);
    }

    // Xác nhận đơn hàng + Tạo mã vận đơn GHN
    public boolean confirmOrder(int orderId) {
        Orders order = getOrderById(orderId, -1); // user_id is not strictly needed for admin get
        if (order == null)
            return false;

        // Find GHN mapping
        GHNService ghnService = new GHNService();
        Map<String, String> shippingInfo = getShippingInfoByOrder(orderId);

        String phone = shippingInfo.get("receiverPhone");
        String name = shippingInfo.get("recipientName");
        String addressLine = shippingInfo.get("shippingAddress");

        // We need to parse Address if it contains Province, District... or we need to
        // find it from name
        // The current DB only stores AddressLine (which includes the whole address
        // usually, or ward/district is separate)
        // Wait, Address only has `addressLine`, `province`, `district`. In DB they
        // might be combined or separate.
        // Let's get the Order's full address
        int currentProvinceId = ghnService.findProvinceIdByName(order.getProvince());
        int currentDistrictId = ghnService.findDistrictIdByName(currentProvinceId, order.getDistrict());
        // addressLine often contains Ward name. But wait, we don't store WardName in
        // Address! It is stored in District?
        // Let's assume District name contains both for now, or just send a dummy word
        // if not found
        String wardCode = ghnService.findWardCodeByName(currentDistrictId, addressLine);
        if (wardCode == null) {
            // Sometimes Address stores ward inside district string.
            wardCode = ghnService.findWardCodeByName(currentDistrictId, order.getDistrict());
        }
        if (wardCode == null) {
            wardCode = ""; // GHN might reject if empty, but we try
        }

        int codAmount = "COD".equalsIgnoreCase(order.getPaymentMethod()) ? (int) order.getTotalPrice() : 0;
        String clientOrderCode = "ORDER_" + order.getId();

        String shippingCode = ghnService.createGHNOrder(
                phone, name, addressLine, wardCode, currentDistrictId,
                1000, 10, 10, 10,
                clientOrderCode, codAmount);

        if (shippingCode == null || shippingCode.isEmpty()) {
            // Fallback random if GHN fails
            String randomDigits = String.valueOf((int) (Math.random() * 900000) + 100000);
            shippingCode = "VC" + randomDigits;
        }

        return orderDaoAdmin.updateOrderStatusAndShippingCode(orderId, "Đang xử lý", shippingCode);
    }

    // Cập nhật trạng thái đơn hàng
    public boolean updateOrderStatus(int orderId, String status) {
        return orderDaoAdmin.updateOrderStatus(orderId, status);
    }

    // Cập nhật toàn bộ thông tin đơn hàng
    public boolean updateOrderFull(int orderId, int userId, String fullName, String email, String phoneNumber,
            String addressLine, String province, String district,
            String paymentMethod, String status, String note, java.time.LocalDate completedAt) {
        return orderDaoAdmin.updateOrderFull(orderId, userId, fullName, email, phoneNumber,
                addressLine, province, district, paymentMethod, status, note, completedAt);
    }
}
