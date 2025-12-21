package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.service;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ImageDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;

public class ProductService {

    private ProductDAO productDAO = new ProductDAO();

    ImageDAO imageDAO = new ImageDAO();

    public Product getProduct(int productId) {
        Product product = productDAO.getProductById(productId);

        if (product != null) {
            product.setImages(imageDAO.getImagesByProduct(product.getId()));
        }

        return product;
    }
}
