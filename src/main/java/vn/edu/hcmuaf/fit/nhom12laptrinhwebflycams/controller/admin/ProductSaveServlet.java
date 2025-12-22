package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ImageDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductManagement;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Image;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet(name = "ProductSaveServlet", value = "/admin/product-save")
public class ProductSaveServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
    private ProductManagement productDAO = new ProductManagement();
    private ImageDAO imageDAO = new ImageDAO();

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

            boolean isAdd = product.getId() == 0;
            int productId;

            if (isAdd) {
                System.out.println("Action: ADD new product");
                productId = productDAO.insertProduct(product); // trả về ID mới
            } else {
                System.out.println("Action: UPDATE product ID " + product.getId());
                productDAO.updateProduct(product);
                productId = product.getId();
            }

            System.out.println("Product ID after operation: " + productId);

            // Xóa tất cả ảnh cũ
            imageDAO.deleteImagesByProduct(productId);
            System.out.println("Deleted old images for product ID " + productId);

            // Chèn ảnh chính
            if (product.getMainImage() != null && !product.getMainImage().isEmpty()) {
                imageDAO.insertImage(productId, product.getMainImage(), "Chính");
                System.out.println("Inserted main image: " + product.getMainImage());
            }

            // Chèn các ảnh phụ
            if (product.getImages() != null) {
                for (Image img : product.getImages()) {
                    if (img.getImageUrl() != null && !img.getImageUrl().isEmpty()
                            && !img.getImageUrl().equals(product.getMainImage())) {
                        imageDAO.insertImage(productId, img.getImageUrl(), "Phụ");
                        System.out.println("Inserted extra image: " + img.getImageUrl());
                    }
                }
            }

            // Trả về kết quả JSON
            Map<String, Object> result = Map.of(
                    "success", true,
                    "productId", productId
            );
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