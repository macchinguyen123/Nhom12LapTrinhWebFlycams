package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.AuthService;

import java.io.IOException;

@WebServlet(name = "ChangePassword", value = "/ChangePassword")
public class ChangePasswordController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("user");

        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/page/login.jsp");
            return;
        }

        // Lấy dữ liệu form
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm");
        String otpInput = request.getParameter("otp");
        String otpSession = (String) session.getAttribute("otp");

        AuthService authService = new AuthService();
        String error = authService.changePassword(
                currentUser.getId(),
                currentUser.getEmail(),
                currentPassword,
                newPassword,
                confirmPassword,
                otpSession,
                otpInput);

        if (error != null) {
            request.setAttribute("error", error);
            request.getRequestDispatcher("page/personal-page.jsp").forward(request, response);
            return;
        }

        // Thành công
        session.removeAttribute("otp");
        session.removeAttribute("otpSent");
        session.setAttribute("success", "Đổi mật khẩu thành công!");

        // Redirect để clean URL và reload trang sạch
        response.sendRedirect(request.getContextPath() + "/personal");
    }
}