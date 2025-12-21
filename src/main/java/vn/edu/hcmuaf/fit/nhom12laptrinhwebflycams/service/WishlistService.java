package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.WishlistDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Wishlists;

import java.util.List;

public class WishlistService {
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    public List<Wishlists> getWishlistByUser(int userId) {
        return wishlistDAO.getWishlistByUser(userId);
    }

    public List<Product> getWishlistProducts(int userId) {
        return wishlistDAO.getWishlistProductsByUser(userId);
    }

    public List<Integer> getWishlistProductIds(int userId) {
        return wishlistDAO.getWishlistProductIds(userId);
    }

    public boolean add(int userId, int productId) {
        boolean result = wishlistDAO.addToWishlist(userId, productId);
        System.out.println("[SERVICE] Add wishlist: userId=" + userId + ", productId=" + productId + ", result=" + result);
        return result;
    }

    public boolean remove(int userId, int productId) {
        boolean result = wishlistDAO.removeFromWishlist(userId, productId);
        System.out.println("[SERVICE] Remove wishlist: userId=" + userId + ", productId=" + productId + ", result=" + result);
        return result;
    }

    public boolean toggleWishlist(int userId, int productId) {
        boolean result;
        if (wishlistDAO.existsInWishlist(userId, productId)) {
            result = wishlistDAO.removeFromWishlist(userId, productId);
            System.out.println("[SERVICE] Toggle remove: userId=" + userId + ", productId=" + productId + ", result=" + result);
        } else {
            result = wishlistDAO.addToWishlist(userId, productId);
            System.out.println("[SERVICE] Toggle add: userId=" + userId + ", productId=" + productId + ", result=" + result);
        }
        return result;
    }
}
