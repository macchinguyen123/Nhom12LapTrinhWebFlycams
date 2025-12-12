package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model;

public class Wishlists {
    private int id;
    private int userId;
    private int productId;

    public Wishlists(int id, int userId, int productId) {
        this.id = id;
        this.userId = userId;
        this.productId = productId;
    }


    public int getId() {
        return id;
    }

    public int getProductId() {
        return productId;
    }

    public int getUserId() {
        return userId;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }
}
