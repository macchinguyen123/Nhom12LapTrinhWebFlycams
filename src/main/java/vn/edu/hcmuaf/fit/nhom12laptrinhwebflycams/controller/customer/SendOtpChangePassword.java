package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.MailProperties.EmailSender;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "SendOtpChangePassword", value = "/SendOtpChangePassword")
public class SendOtpChangePassword extends HttpServlet {

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
        User user = (User) session.getAttribute("user");

        // Kiểm tra đã đăng nhập chưa
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/page/login.jsp");
            return;
        }

        // Lấy thông tin user từ database
        User dbUser = userDAO.getUserByEmail(user.getEmail());
        if (dbUser == null || dbUser.getEmail() == null) {
            session.setAttribute("error", "Không tìm thấy email của bạn trong hệ thống!");
            response.sendRedirect(request.getContextPath() + "/personal?tab=repass");
            return;
        }

        try {
            // 1. Sinh OTP ngẫu nhiên (4 số giống ResendForgotPasswordOtp)
            String otp = String.valueOf((int) (Math.random() * 9000) + 1000);

            // 2. Lưu OTP vào session
            session.setAttribute("otp", otp);
            session.setMaxInactiveInterval(5 * 60); // OTP hết hạn sau 5 phút

            // 3. Gửi email (format giống ResendForgotPasswordOtp)
            EmailSender emailSender = new EmailSender();
            String title = "Xác nhận đổi mật khẩu - SKYDRONE";
            String content = "Bạn đang thực hiện thay đổi mật khẩu tài khoản. Mã OTP của bạn là";
            String thanks = "Vui lòng nhập mã OTP này để hoàn tất việc đổi mật khẩu.<br>" +
                    "<strong style='color: #dc3545;'>Lưu ý:</strong> Mã OTP có hiệu lực trong 5 phút.";
            String otpHtml = "<div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); " +
                    "padding: 25px; border-radius: 12px; text-align: center; margin: 20px 0; " +
                    "box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);'>" +
                    "<h1 style='color: #ffffff; font-size: 56px; margin: 0; " +
                    "letter-spacing: 12px; font-weight: 700; text-shadow: 2px 2px 4px rgba(0,0,0,0.2);'>"
                    + otp + "</h1>" +
                    "</div>";

            emailSender.sendVerificationEmail(
                    dbUser.getEmail(),
                    title,
                    dbUser.getUsername(),
                    otpHtml,
                    content,
                    thanks
            );

            // 4. Set flag để JSP hiển thị form OTP
            session.setAttribute("otpSent", true);

            // 5. Response success (cho AJAX)
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write("success");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("error");
        }
    }
}