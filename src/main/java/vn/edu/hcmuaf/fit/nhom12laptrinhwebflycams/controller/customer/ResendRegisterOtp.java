package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.AuthService;

import java.io.IOException;

@WebServlet(name = "ResendRegisterOtp", value = "/ResendRegisterOtp")
public class ResendRegisterOtp extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("registerUser");

        if (user == null) {
            response.sendRedirect("page/register.jsp");
            return;
        }

        // Send OTP via AuthService
        String title = "OTP mới - SKYDRONE";
        String content = "Mã OTP mới của bạn";
        String thanks = "Vui lòng sử dụng mã mới";

        String otp = authService.resendOtp(user.getEmail(), user.getUsername(), title, content, thanks);

        long expireTime = System.currentTimeMillis() + 5 * 60 * 1000;

        session.setAttribute("registerOtp", otp);
        session.setAttribute("registerOtpTime", System.currentTimeMillis());
        session.setAttribute("registerOtpExpire", expireTime);

        response.sendRedirect("page/otp.jsp");
    }
}