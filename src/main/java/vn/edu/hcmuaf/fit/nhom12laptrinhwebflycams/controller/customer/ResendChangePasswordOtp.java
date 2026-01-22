package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.AuthService;

import java.io.IOException;

@WebServlet(name = "ResendChangePasswordOtp", value = "/ResendChangePasswordOtp")
public class ResendChangePasswordOtp extends HttpServlet {

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
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/page/login.jsp");
            return;
        }

        User dbUser = authService.getUserByEmail(user.getEmail());
        if (dbUser == null) {
            response.sendRedirect(request.getContextPath() + "/personal?tab=repass");
            return;
        }

        try {
            // Send OTP via AuthService
            String title = "Gửi lại mã OTP đổi mật khẩu - SKYDRONE";
            String content = "Mã OTP mới của bạn là";
            String thanks = "Vui lòng nhập mã OTP này để hoàn tất việc đổi mật khẩu.<br>" +
                    "<strong style='color: #dc3545;'>Lưu ý:</strong> Mã OTP có hiệu lực trong 5 phút.";

            String otp = authService.resendOtp(dbUser.getEmail(), dbUser.getUsername(), title, content, thanks);

            // Update session
            session.setAttribute("otp", otp);
            session.setMaxInactiveInterval(5 * 60);
            session.setAttribute("otpSent", true);

            // Response
            response.setContentType("text/plain; charset=UTF-8");
            response.getWriter().write("success");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("error");
        }
    }
}