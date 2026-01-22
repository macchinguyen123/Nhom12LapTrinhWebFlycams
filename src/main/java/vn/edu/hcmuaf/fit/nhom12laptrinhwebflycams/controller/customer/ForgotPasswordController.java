package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.AuthService;

import java.io.IOException;

@WebServlet(name = "ForgotPassword", value = "/ForgotPassword")
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        AuthService authService = new AuthService();
        String otp = authService.forgotPassword(email);

        if (otp == null) {
            request.setAttribute("message", "Email không tồn tại trong hệ thống!");
            request.getRequestDispatcher("/page/forgot-password.jsp").forward(request, response);
            return;
        }

        // 2 Lưu OTP vào session
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);
        session.setMaxInactiveInterval(5 * 60); // OTP hết hạn sau 5 phút

        // 4 Chuyển sang trang nhập OTP
        request.setAttribute("message", "OTP đã được gửi về email của bạn!");
        request.getRequestDispatcher("/page/otp-forgot-password.jsp").forward(request, response);
    }
}
