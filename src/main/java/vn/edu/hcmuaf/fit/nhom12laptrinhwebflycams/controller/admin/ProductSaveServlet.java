package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.ProductService;

import java.io.IOException;
import java.sql.SQLException;

import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "ProductSaveServlet", value = "/admin/product-save")
public class ProductSaveServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    private ProductService productService = new ProductService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        try {
            // Đọc JSON từ frontend
            String json = req.getReader().lines().collect(Collectors.joining());
            System.out.println("Received JSON: " + json); // debug JSON

            ObjectMapper mapper = new ObjectMapper();
            Product product = mapper.readValue(json, Product.class);

            int productId = productService.saveProduct(product);

            // Trả về kết quả JSON
            Map<String, Object> result = Map.of(
                    "success", true,
                    "productId", productId);
            resp.getWriter().write(mapper.writeValueAsString(result));

        } catch (SQLException e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\":false, \"message\":\"Database error: " + e.getMessage() + "\"}");
        } catch (Exception e) {
            e.printStackTrace();
            resp.getWriter().write("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}