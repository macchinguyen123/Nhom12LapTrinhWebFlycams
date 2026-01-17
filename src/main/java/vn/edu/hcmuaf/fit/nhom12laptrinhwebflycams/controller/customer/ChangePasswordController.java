package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.validate.Validator;

import java.io.IOException;

@WebServlet(name = "ChangePassword", value = "/ChangePassword")
public class ChangePasswordController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
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

        // Lấy OTP từ session
        String otpSession = (String) session.getAttribute("otp");

        boolean hasError = false;

        // ================ VALIDATE ================

        // 1. Kiểm tra OTP
        if (otpSession == null) {
            session.setAttribute("error", "Vui lòng nhấn 'Gửi OTP' để nhận mã xác nhận!");
            hasError = true;
        } else if (otpInput == null || otpInput.trim().isEmpty()) {
            session.setAttribute("otpError", "Vui lòng nhập mã OTP!");
            hasError = true;
        } else if (!otpSession.equals(otpInput.trim())) {
            session.setAttribute("otpError", "Mã OTP không chính xác!");
            hasError = true;
        }

        // 2. Kiểm tra mật khẩu hiện tại
        if (!hasError) {
            User checkLogin = userDAO.login(currentUser.getEmail(), currentPassword);
            if (checkLogin == null) {
                session.setAttribute("currentPasswordError", "Mật khẩu hiện tại không đúng!");
                hasError = true;
            }
        }

        // 3. Validate mật khẩu mới
        if (!hasError && !Validator.isValidPassword(newPassword)) {
            session.setAttribute("passwordError",
                    "Mật khẩu mới phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt!");
            hasError = true;
        }

        // 4. Kiểm tra mật khẩu mới khác mật khẩu cũ
        if (!hasError && newPassword.equals(currentPassword)) {
            session.setAttribute("passwordError", "Mật khẩu mới không được giống mật khẩu cũ!");
            hasError = true;
        }

        // 5. Kiểm tra mật khẩu nhập lại
        if (!hasError && !newPassword.equals(confirmPassword)) {
            session.setAttribute("confirmPasswordError", "Mật khẩu nhập lại không khớp!");
            hasError = true;
        }

        // Nếu có lỗi, quay lại trang personal
        if (hasError) {
            session.setAttribute("otpSent", true); // Giữ form OTP hiển thị
            response.sendRedirect(request.getContextPath() + "/personal?tab=repass");
            return;
        }

        // ================ CẬP NHẬT MẬT KHẨU ================
        boolean updated = userDAO.updatePassword(currentUser.getId(), newPassword);

        if (!updated) {
            session.setAttribute("error", "Đổi mật khẩu thất bại. Vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/personal?tab=repass");
            return;
        }

        // ================ THÀNH CÔNG ================
        // Xóa OTP và flag khỏi session
        session.removeAttribute("otp");
        session.removeAttribute("otpSent");

        session.setAttribute("success", "Đổi mật khẩu thành công!");
        response.sendRedirect(request.getContextPath() + "/personal");
    }
}