package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "SendOtpChangePassword", value = "/SendOtpChangePassword")
public class SendOtpChangePasswordController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/page/login.jsp");
            return;
        }

        // Sinh OTP 4 số
        String otp = String.valueOf((int) (Math.random() * 9000) + 1000);
        session.setAttribute("otp", otp);
        session.setAttribute("otpUserId", currentUser.getId());
        session.setAttribute("otpTime", System.currentTimeMillis());

        // Trả về JSON để AJAX xử lý
        response.setContentType("application/json");
        response.getWriter().write("{\"status\":\"ok\"}");
    }
}
