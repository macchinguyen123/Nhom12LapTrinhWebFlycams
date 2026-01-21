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

@WebServlet("/EditAddressServlet")
public class EditAddressServlet extends HttpServlet {
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

        try {
            int id = Integer.parseInt(req.getParameter("id"));

            // Lấy thông tin mới
            String fullName = req.getParameter("fullName");
            String phoneNumber = req.getParameter("phoneNumber");
            String addressLine = req.getParameter("addressLine");
            String province = req.getParameter("province");
            String district = req.getParameter("district");
            boolean isDefault = req.getParameter("isDefault") != null;

            // KIỂM TRA TRÙNG LẶP (BỎ QUA CHÍNH NÓ)
            List<Address> existingAddresses = dao.findByUserId(user.getId());

            for (Address existing : existingAddresses) {
                // Bỏ qua địa chỉ đang sửa
                if (existing.getId() == id) continue;

                if (isDuplicateAddress(existing, addressLine, province, district)) {
                    req.getSession().setAttribute("error",
                            "Địa chỉ này đã tồn tại! Vui lòng kiểm tra lại.");
                    resp.sendRedirect(req.getContextPath() + "/personal?tab=addresses");
                    return;
                }
            }

            // Tạo object Address để update
            Address addr = new Address();
            addr.setId(id);
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

            dao.update(addr);
            req.getSession().setAttribute("success", "Cập nhật địa chỉ thành công!");

        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi cập nhật địa chỉ!");
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID địa chỉ không hợp lệ!");
        }

        resp.sendRedirect(req.getContextPath() + "/personal?tab=addresses");
    }

    /**
     * Kiểm tra địa chỉ có trùng lặp không
     */
    private boolean isDuplicateAddress(Address existing, String addressLine,
                                       String province, String district) {
        String existingAddr = normalizeString(existing.getAddressLine());
        String newAddr = normalizeString(addressLine);

        String existingProv = normalizeString(existing.getProvince());
        String newProv = normalizeString(province);

        String existingDist = normalizeString(existing.getDistrict());
        String newDist = normalizeString(district);

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
                .replaceAll("\\s+", " ");
    }
}