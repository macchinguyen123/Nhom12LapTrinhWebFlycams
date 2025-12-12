package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model;

import java.io.Serializable;
import java.util.List;

public class Product implements Serializable {

    private int id;
    private int categoryId;
    private String brandName;
    private String productName;
    private String description;
    private String parameter;
    private double price;
    private double finalPrice;
    private String warranty;
    private int quantity;
    private boolean status;
    private List<Image> images;
    private String mainImage; // NEW FIELD

    // Constructor không tham số – bắt buộc cho JavaBean
    public Product() {
    }

    // Constructor đầy đủ
    public Product(int id, int categoryId, String brandName, String productName,
                   String description, String parameter, double price,
                   double finalPrice, String warranty, int quantity, boolean status) {
        this.id = id;
        this.categoryId = categoryId;
        this.brandName = brandName;
        this.productName = productName;
        this.description = description;
        this.parameter = parameter;
        this.price = price;
        this.finalPrice = finalPrice;
        this.warranty = warranty;
        this.quantity = quantity;
        this.status = status;
    }

    // GETTER – SETTER chuẩn JavaBean

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getParameter() {
        return parameter;
    }

    public void setParameter(String parameter) {
        this.parameter = parameter;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;

        // Cập nhật finalPrice mỗi khi price thay đổi
        this.finalPrice = price;
    }

    public double getFinalPrice() {
        return finalPrice;
    }

    public void setFinalPrice(double finalPrice) {
        this.finalPrice = finalPrice;
    }

    public String getWarranty() {
        return warranty;
    }

    public void setWarranty(String warranty) {
        this.warranty = warranty;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public List<Image> getImages() {
        return images;
    }

    public void setImages(List<Image> images) {
        this.images = images;
    }

    public String getMainImage() {
        return mainImage;
    }

    public void setMainImage(String mainImage) {
        this.mainImage = mainImage;
    }
}
