package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.MailProperties.EmailSender;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "SendOtpChangePassword", value = "/SendOtpChangePassword")
class SendOtpChangePasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        User currentUser = (User) session.getAttribute("user");

        // ===== CHƯA ĐĂNG NHẬP =====
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/page/login.jsp");
            return;
        }

        // ===== LẤY USER TỪ DB =====
        User dbUser = userDAO.getUserByEmail(currentUser.getEmail());
        if (dbUser == null || dbUser.getEmail() == null) {
            session.setAttribute("error", "Không tìm thấy email của bạn trong hệ thống!");
            response.sendRedirect(request.getContextPath() + "/personal?tab=repass");
            return;
        }

        try {
            // ===== 1. SINH OTP (4 SỐ) =====
            String otp = String.valueOf((int) (Math.random() * 9000) + 1000);

            // ===== 2. LƯU OTP VÀO SESSION =====
            session.setAttribute("otp", otp);
            session.setAttribute("otpUserId", dbUser.getId());
            session.setAttribute("otpTime", System.currentTimeMillis());
            session.setMaxInactiveInterval(5 * 60); // 5 phút

            // ===== 3. GỬI EMAIL =====
            EmailSender emailSender = new EmailSender();

            String title = "Xác nhận đổi mật khẩu - SKYDRONE";
            String content = "Bạn đang thực hiện thay đổi mật khẩu tài khoản. Mã OTP của bạn là";
            String thanks = "Vui lòng nhập mã OTP này để hoàn tất việc đổi mật khẩu.<br>" +
                    "<strong style='color: #dc3545;'>Lưu ý:</strong> Mã OTP có hiệu lực trong 5 phút.";

            String otpHtml =
                    "<div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);" +
                            "padding: 25px; border-radius: 12px; text-align: center; margin: 20px 0;" +
                            "box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);'>" +
                            "<h1 style='color: #ffffff; font-size: 56px; margin: 0;" +
                            "letter-spacing: 12px; font-weight: 700;'>" +
                            otp +
                            "</h1></div>";

            emailSender.sendVerificationEmail(
                    dbUser.getEmail(),
                    title,
                    dbUser.getUsername(),
                    otpHtml,
                    content,
                    thanks
            );

            // ===== 4. FLAG HIỂN THỊ FORM OTP =====
            session.setAttribute("otpSent", true);

            // ===== 5. RESPONSE CHO AJAX =====
            response.setContentType("application/json");
            response.getWriter().write("{\"status\":\"ok\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\"}");
        }
    }
}
