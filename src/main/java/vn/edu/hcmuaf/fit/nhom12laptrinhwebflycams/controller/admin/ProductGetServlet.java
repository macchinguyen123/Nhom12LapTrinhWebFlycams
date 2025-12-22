package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ImageDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Image;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "ProductGetServlet", value = "/admin/product-get")
public class ProductGetServlet extends HttpServlet {
    private ProductDAO productDAO = new ProductDAO();
    private ImageDAO imageDAO = new ImageDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String idParam = request.getParameter("id");
        if (idParam == null) {
            response.getWriter().write("{\"success\": false, \"message\": \"Missing product ID\"}");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(productId);

            if (product != null) {

                // Lấy tất cả ảnh
                List<Image> allImages = imageDAO.getImagesByProduct(productId);

                // Lấy ảnh chính
                allImages.stream()
                        .filter(img -> "Chính".equals(img.getImageType()))
                        .findFirst()
                        .ifPresent(img -> product.setMainImage(img.getImageUrl()));

                // Lấy ảnh phụ
                List<Image> extraImages = allImages.stream()
                        .filter(img -> !"Chính".equals(img.getImageType()))
                        .collect(Collectors.toList());
                product.setImages(extraImages);

                // Chuyển sang JSON
                ObjectMapper mapper = new ObjectMapper();
                String json = mapper.writeValueAsString(product);
                response.getWriter().write(json);
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Sản phẩm không tồn tại\"}");
            }
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\": false, \"message\": \"ID không hợp lệ\"}");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}