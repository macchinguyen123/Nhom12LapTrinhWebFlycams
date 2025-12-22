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

@WebServlet(name = "BuyNowFromCartServlet", value = "/BuyNowFromCart")
public class BuyNowFromCartServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String[] productIds = req.getParameterValues("productId");
        String[] quantities = req.getParameterValues("quantities");

        if (productIds == null || quantities == null) {
            resp.sendRedirect(req.getContextPath() + "/shopping-cart.jsp");
            return;
        }

        ProductDAO productDAO = new ProductDAO();
        List<OrderItems> buyNowItems = new ArrayList<>();

        for (int i = 0; i < productIds.length; i++) {
            int productId = Integer.parseInt(productIds[i]);
            int quantity = Integer.parseInt(quantities[i]);

            Product product = productDAO.getProductById(productId);

            OrderItems item = new OrderItems();
            item.setProductId(productId);
            item.setQuantity(quantity);
            item.setPrice(product.getFinalPrice());
            item.setProduct(product); // 🔥 BẮT BUỘC

            buyNowItems.add(item);
        }

        HttpSession session = req.getSession();
        session.setAttribute("BUY_NOW_ITEM", buyNowItems);

        resp.sendRedirect(req.getContextPath() + "/page/delivery-info.jsp");
    }
}