package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.WishlistDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Wishlists;

import java.util.List;

public class WishlistService {

    private final WishlistDAO wishlistDAO = new WishlistDAO();

    // Lấy danh sách wishlist của user
    public List<Wishlists> getWishlistByUser(int userId) {
        return wishlistDAO.getWishlistByUser(userId);
    }

    // Toggle wishlist (add / remove)
    public boolean toggleWishlist(int userId, int productId) {
        if (wishlistDAO.existsInWishlist(userId, productId)) {
            return wishlistDAO.removeFromWishlist(userId, productId);
        } else {
            return wishlistDAO.addToWishlist(userId, productId);
        }
    }

    // Thêm vào wishlist
    public boolean add(int userId, int productId) {
        System.out.println("[SERVICE] Add wishlist: userId=" + userId + ", productId=" + productId);
        return wishlistDAO.addToWishlist(userId, productId);
    }

    // Xóa khỏi wishlist
    public boolean remove(int userId, int productId) {
        System.out.println("[SERVICE] Remove wishlist: userId=" + userId + ", productId=" + productId);
        return wishlistDAO.removeFromWishlist(userId, productId);
    }
    public List<Product> getWishlistProducts(int userId) {
        System.out.println("[SERVICE] get wishlist: userId=" + userId);
        return wishlistDAO.getWishlistProductsByUser(userId);
    }
    public List<Integer> getWishlistProductIds(int userId) {
        return wishlistDAO.getWishlistProductIds(userId);
    }


}
