package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.PasswordUtil;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.validate.Validator;

import java.io.IOException;

@WebServlet(name = "ChangePassword", value = "/ChangePassword")
public class ChangePasswordController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

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

        boolean hasError = false;

        // ------------------ VALIDATE ------------------
        // ------------------ VALIDATE ------------------
        User checkLogin = userDAO.login(currentUser.getEmail(), currentPassword);
        if (checkLogin == null) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng");
            hasError = true;
        }

        if (!Validator.isValidPassword(newPassword)) {
            request.setAttribute("error", "Mật khẩu mới phải ≥8 ký tự, có chữ hoa, chữ thường, số và ký tự đặc biệt");
            hasError = true;
        }

        if (newPassword.equals(currentPassword)) {
            request.setAttribute("error", "Mật khẩu mới không được giống mật khẩu cũ");
            hasError = true;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu nhập lại không khớp");
            hasError = true;
        }

        String otpSession = (String) session.getAttribute("otp");
        if (otpSession == null || !otpSession.equals(otpInput)) {
            request.setAttribute("error", "Mã OTP không đúng hoặc chưa được gửi");
            hasError = true;
        }

        if (hasError) {
            request.getRequestDispatcher("page/personal-page.jsp").forward(request, response);
            return;
        }

        // ------------------ UPDATE PASSWORD ------------------
        String hashedNewPassword = PasswordUtil.hashPassword(newPassword);
        boolean updated = userDAO.updatePassword(currentUser.getId(), hashedNewPassword);

        if (!updated) {
            request.setAttribute("error", "Đổi mật khẩu thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("page/personal-page.jsp").forward(request, response);
            return;
        }

        // Thành công
        session.removeAttribute("otp");
        request.setAttribute("success", "Đổi mật khẩu thành công!");
        request.getRequestDispatcher("page/personal-page.jsp").forward(request, response);
    }
}