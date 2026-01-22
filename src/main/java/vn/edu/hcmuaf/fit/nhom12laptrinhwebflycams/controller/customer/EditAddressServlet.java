package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.AddressService;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/EditAddressServlet")
public class EditAddressServlet extends HttpServlet {

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

            AddressService addressService = new AddressService();
            boolean success = addressService.updateAddress(addr);

            if (!success) {
                req.getSession().setAttribute("error",
                        "Địa chỉ này đã tồn tại! Vui lòng kiểm tra lại.");
            } else {
                req.getSession().setAttribute("success", "Cập nhật địa chỉ thành công!");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi cập nhật địa chỉ!");
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID địa chỉ không hợp lệ!");
        }

        resp.sendRedirect(req.getContextPath() + "/personal?tab=addresses");
    }
}