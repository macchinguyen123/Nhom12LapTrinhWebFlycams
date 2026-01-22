package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.AuthService;

import java.io.IOException;

@WebServlet(name = "ResendForgotPasswordOtp", value = "/ResendForgotPasswordOtp")
public class ResendForgotPasswordOtp extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");

        if (email == null) {
            response.sendRedirect(request.getContextPath() + "/page/forgot-password.jsp");
            return;
        }

        User user = authService.getUserByEmail(email);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/page/forgot-password.jsp");
            return;
        }

        // Send OTP via AuthService
        String title = "Gửi lại mã OTP đặt lại mật khẩu";
        String content = "Mã OTP mới của bạn là";
        String thanks = "Vui lòng nhập mã OTP bên dưới để tiếp tục";

        String otp = authService.resendOtp(email, user.getUsername(), title, content, thanks);

        // Update session
        session.setAttribute("otp", otp);
        session.setMaxInactiveInterval(5 * 60);

        // Redirect
        request.setAttribute("message", "Mã OTP mới đã được gửi!");
        request.getRequestDispatcher("/page/otp-forgot-password.jsp").forward(request, response);
    }
}
