package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.MailProperties.EmailSender;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "ResendForgotPasswordOtp", value = "/ResendForgotPasswordOtp")
public class ResendForgotPasswordOtp extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

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

        User user = userDAO.getUserByEmail(email);
        if (user == null) {
            // Should not happen if flow is correct, but safe fallback
            response.sendRedirect(request.getContextPath() + "/page/forgot-password.jsp");
            return;
        }

        // 1. Sinh OTP mới
        String otp = String.valueOf((int) (Math.random() * 9000) + 1000);

        // 2. Cập nhật vào session
        session.setAttribute("otp", otp);
        session.setMaxInactiveInterval(5 * 60);

        // 3. Gửi email
        EmailSender emailSender = new EmailSender();
        String title = "Gửi lại mã OTP đặt lại mật khẩu";
        String content = "Mã OTP mới của bạn là";
        String thanks = "Vui lòng nhập mã OTP bên dưới để tiếp tục";
        String otpHtml = "<h1 style='color:red;'>" + otp + "</h1>";

        emailSender.sendVerificationEmail(
                email,
                title,
                user.getUsername(),
                otpHtml,
                content,
                thanks);

        // 4. Quay lại trang OTP
        request.setAttribute("message", "Mã OTP mới đã được gửi!");
        request.getRequestDispatcher("/page/otp-forgot-password.jsp").forward(request, response);
    }
}
