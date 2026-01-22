package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.AddressService;

import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet(name = "CheckoutServlet", value = "/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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

        try {
            AddressService addressService = new AddressService();
            int addressId = addressService.processCheckoutAddress(user.getId(), savedAddressId, fullName, phone,
                    addressLine, province, ward);

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