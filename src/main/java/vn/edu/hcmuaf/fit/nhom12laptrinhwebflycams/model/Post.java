package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

public class Post implements Serializable {
    private int id;
    private String title;
    private String content;
    private String image;
    private Date createdAt;
    private int productId;

    public Post() {}

    public Post(int id, String title, String content, String image, Date createdAt, int productId) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.image = image;
        this.createdAt = createdAt;
        this.productId = productId;
    }

    // getters & setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }
}
