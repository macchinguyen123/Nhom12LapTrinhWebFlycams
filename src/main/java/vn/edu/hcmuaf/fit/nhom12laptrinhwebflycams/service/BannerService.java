package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.BannerDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Banner;

import java.util.List;

public class BannerService {
    private BannerDAO bannerDAO = new BannerDAO();

    //Lấy danh sách banner đang hoạt động
    public List<Banner> getActiveBanners() {
        return bannerDAO.getActiveBanners();
    }

    //Lấy toàn bộ banner
    public List<Banner> getAllBanners() {
        return bannerDAO.getAllBanners();
    }

    //Lấy thông tin chi tiết banner theo ID
    public Banner getBannerById(int id) {
        return bannerDAO.getBannerById(id);
    }

    //thêm banner
    public boolean addBanner(Banner banner) {
        return bannerDAO.addBanner(banner);
    }

    public boolean updateBanner(Banner banner) {
        return bannerDAO.updateBanner(banner);
    }

    public boolean deleteBanner(int id) {
        return bannerDAO.deleteBanner(id);
    }
}
