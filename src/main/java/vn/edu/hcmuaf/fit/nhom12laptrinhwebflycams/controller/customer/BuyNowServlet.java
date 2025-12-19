package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;

import java.io.IOException;

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

        if (productIdStr == null || productIdStr.isBlank()
                || quantityStr == null || quantityStr.isBlank()) {

            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        int productId = Integer.parseInt(productIdStr);
        int quantity = Integer.parseInt(quantityStr);

        ProductDAO productDAO = new ProductDAO();
        Product product = productDAO.getProductById(productId);

        OrderItems item = new OrderItems();
        item.setProductId(productId);
        item.setQuantity(quantity);
        item.setPrice(product.getFinalPrice());

        HttpSession session = req.getSession();
        session.setAttribute("BUY_NOW_ITEM", item);
        session.setAttribute("BUY_NOW_PRODUCT", product);

        // 🔥 DÒNG QUAN TRỌNG
        resp.sendRedirect(req.getContextPath() + "/page/delivery-info.jsp");
    }
}