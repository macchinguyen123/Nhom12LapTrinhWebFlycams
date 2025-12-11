package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model;

import java.io.Serializable;

public class Categories implements Serializable {

    private int id;
    private String categoryName;
    private String image;
    private String status;

    // Constructor không tham số (BẮT BUỘC CHO JAVABEAN)
    public Categories() {
    }

    // Constructor đầy đủ (không bắt buộc)
    public Categories(int id, String categoryName, String image, String status) {
        this.id = id;
        this.categoryName = categoryName;
        this.image = image;
        this.status = status;
    }


    // Getter & Setter CHUẨN JAVABEAN
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}
