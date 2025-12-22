package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BuyNowServlet", value = "/BuyNowServlet")
public class BuyNowServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String productIdStr = req.getParameter("productId");
        String quantityStr = req.getParameter("quantity");

        if (productIdStr == null || quantityStr == null) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        int quantity = Integer.parseInt(quantityStr);

        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.getProductById(productId);

        // 🔥 tạo item
        OrderItems item = new OrderItems();
        item.setProductId(productId);
        item.setQuantity(quantity);
        item.setPrice(product.getFinalPrice());
        item.setProduct(product); // 🔥 DÒNG QUAN TRỌNG

        // 🔥 đưa vào LIST để dùng chung với cart
        List<OrderItems> items = new ArrayList<>();
        items.add(item);

        HttpSession session = req.getSession();
        session.setAttribute("BUY_NOW_ITEM", items);

        resp.sendRedirect(req.getContextPath() + "/page/delivery-info.jsp");
    }
}