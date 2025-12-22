package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.AddressDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrderItemsDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.OrdersDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.OrderItems;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Orders;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "CheckoutServlet", value = "/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        User user = (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // 1. LẤY FORM DATA
        String savedAddressId = req.getParameter("savedAddress");

        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        String addressLine = req.getParameter("address");
        String province = req.getParameter("province");
        String ward = req.getParameter("ward");
        String note = req.getParameter("note");

        int addressId;

        try {
            AddressDAO addressDAO = new AddressDAO();

            // 2. NẾU CHỌN ĐỊA CHỈ CÓ SẴN
            if (savedAddressId != null && !savedAddressId.isEmpty()) {
                addressId = Integer.parseInt(savedAddressId);

            } else {
                // 3. TẠO ĐỊA CHỈ MỚI
                Address address = new Address();
                address.setUserId(user.getId());
                address.setFullName(fullName);
                address.setPhoneNumber(phone);
                address.setAddressLine(addressLine);
                address.setProvince(province);
                address.setDistrict(ward);
                address.setDefaultAddress(false);

                addressId = addressDAO.insertID(address);

                if (addressId <= 0) {
                    throw new Exception("Insert address failed");
                }
            }

            // 4. LƯU VÀO SESSION (CHO PAYMENT)
            session.setAttribute("addressId", addressId);
            session.setAttribute("phone", phone);
            session.setAttribute("note", note);

            // 5. CHUYỂN SANG TRANG THANH TOÁN
            resp.sendRedirect(req.getContextPath() + "/page/payment.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Checkout failed");
        }
    }
}