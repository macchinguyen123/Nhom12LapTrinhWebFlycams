package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.AddressDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BuyNowServlet", value = "/BuyNowServlet")
public class BuyNowServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
    private AddressDAO addressDAO = new AddressDAO();
    private ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // ✅ Check login
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        User user = (User) session.getAttribute("user");

        String productIdStr = req.getParameter("productId");
        String quantityStr = req.getParameter("quantity");

        if (productIdStr == null || quantityStr == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        int productId;
        int quantity;

        try {
            productId = Integer.parseInt(productIdStr);
            quantity = Integer.parseInt(quantityStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        // ✅ Lấy product
        Product product = productDAO.getProductById(productId);
        if (product == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        // ✅ Tạo OrderItem
        OrderItems item = new OrderItems();
        item.setProductId(productId);
        item.setQuantity(quantity);
        item.setPrice(product.getFinalPrice());
        item.setProduct(product);

        List<OrderItems> items = new ArrayList<>();
        items.add(item);

        // ✅ Lưu BUY NOW vào session
        session.setAttribute("BUY_NOW_ITEM", items);

        // ✅ Lấy địa chỉ user
        List<Address> addresses = null;
        try {
            addresses = addressDAO.findByUserId(user.getId());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        req.setAttribute("addresses", addresses);

        // ✅ FORWARD (không redirect)
        req.getRequestDispatcher("/page/delivery-info.jsp")
                .forward(req, resp);
    }
}