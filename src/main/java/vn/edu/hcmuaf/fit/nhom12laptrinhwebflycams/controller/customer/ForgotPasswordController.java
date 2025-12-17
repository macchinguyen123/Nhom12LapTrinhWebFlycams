package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.MailProperties.EmailSender;

import java.io.IOException;

@WebServlet(name = "ForgotPassword", value = "/ForgotPassword")
public class ForgotPasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        User user = userDAO.getUserByEmail(email);

        if (user == null) {
            request.setAttribute("message", "Email không tồn tại trong hệ thống!");
            request.getRequestDispatcher("/page/forgot-password.jsp").forward(request, response);
            return;
        }

        // 1️⃣ Sinh OTP 4 số
        String otp = String.valueOf((int)(Math.random() * 9000) + 1000);

        // 2️⃣ Lưu OTP vào session
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);
        session.setMaxInactiveInterval(5 * 60); // OTP hết hạn sau 5 phút

        // 3️⃣ Gửi OTP qua email
        EmailSender emailSender = new EmailSender();

        String title = "Mã OTP đặt lại mật khẩu";
        String content = "Mã OTP của bạn là";
        String thanks = "Vui lòng nhập mã OTP bên dưới để tiếp tục";
        String otpHtml = "<h1 style='color:red;'>" + otp + "</h1>";

        emailSender.sendVerificationEmail(
                email,
                title,
                user.getUsername(), // hoặc user.getFullName()
                otpHtml,
                content,
                thanks
        );

        // 4️⃣ Chuyển sang trang nhập OTP
        request.setAttribute("message", "OTP đã được gửi về email của bạn!");
        request.getRequestDispatcher("/page/otp.jsp").forward(request, response);
    }
}
