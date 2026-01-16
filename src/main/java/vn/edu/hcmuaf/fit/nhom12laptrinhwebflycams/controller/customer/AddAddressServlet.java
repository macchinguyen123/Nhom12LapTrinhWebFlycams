package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.AddressDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/AddAddressServlet")
public class AddAddressServlet extends HttpServlet {
    private final AddressDAO dao = new AddressDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Lấy thông tin địa chỉ từ form
        String fullName = req.getParameter("fullName");
        String phoneNumber = req.getParameter("phoneNumber");
        String addressLine = req.getParameter("addressLine");
        String province = req.getParameter("province");
        String district = req.getParameter("district");
        boolean isDefault = req.getParameter("isDefault") != null;

        try {
            // ✅ KIỂM TRA ĐỊA CHỈ TRÙNG LẶP
            List<Address> existingAddresses = dao.findByUserId(user.getId());

            for (Address existing : existingAddresses) {
                if (isDuplicateAddress(existing, addressLine, province, district)) {
                    req.getSession().setAttribute("error",
                            "Địa chỉ này đã tồn tại! Vui lòng kiểm tra lại.");
                    resp.sendRedirect(req.getContextPath() + "/personal?tab=addresses");
                    return;
                }
            }

            // Tạo địa chỉ mới
            Address addr = new Address();
            addr.setUserId(user.getId());
            addr.setFullName(fullName);
            addr.setPhoneNumber(phoneNumber);
            addr.setAddressLine(addressLine);
            addr.setProvince(province);
            addr.setDistrict(district);
            addr.setDefaultAddress(isDefault);

            // Nếu đặt làm mặc định, reset địa chỉ mặc định cũ
            if (addr.isDefaultAddress()) {
                dao.resetDefault(user.getId());
            }

            dao.insert(addr);
            req.getSession().setAttribute("success", "Thêm địa chỉ thành công!");

        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi thêm địa chỉ!");
        }

        resp.sendRedirect(req.getContextPath() + "/personal?tab=addresses");
    }

    /**
     * Kiểm tra địa chỉ có trùng lặp không
     * So sánh: địa chỉ chi tiết, tỉnh/thành phố, quận/huyện
     */
    private boolean isDuplicateAddress(Address existing, String addressLine,
                                       String province, String district) {
        // Chuẩn hóa chuỗi: trim, lowercase, loại bỏ khoảng trắng thừa
        String existingAddr = normalizeString(existing.getAddressLine());
        String newAddr = normalizeString(addressLine);

        String existingProv = normalizeString(existing.getProvince());
        String newProv = normalizeString(province);

        String existingDist = normalizeString(existing.getDistrict());
        String newDist = normalizeString(district);

        // So sánh cả 3 trường
        return existingAddr.equals(newAddr)
                && existingProv.equals(newProv)
                && existingDist.equals(newDist);
    }

    /**
     * Chuẩn hóa chuỗi để so sánh
     */
    private String normalizeString(String str) {
        if (str == null) return "";
        return str.trim()
                .toLowerCase()
                .replaceAll("\\s+", " "); // Thay nhiều khoảng trắng = 1 khoảng trắng
    }
}