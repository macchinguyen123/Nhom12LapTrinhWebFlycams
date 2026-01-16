package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.MailProperties.EmailSender;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.util.PasswordUtil;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.validate.Validator;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "Register", value = "/Register")

public class Register extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("page/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm");
        String phone = request.getParameter("phoneNumber");
        String birthdayStr = request.getParameter("birthday");

        boolean hasError = false;
        Date birthday = null;

        try {
            birthday = Date.valueOf(birthdayStr);
        } catch (Exception e) {
            request.setAttribute("birthdayError", "Ngày sinh không hợp lệ");
            hasError = true;
        }

        // ===== VALIDATE GIỮ NGUYÊN =====
        if (Validator.isEmpty(fullName)) {
            request.setAttribute("fullNameError", "Họ tên không được để trống");
            hasError = true;
        }

        if (!Validator.isValidEmail(email)) {
            request.setAttribute("emailError", "Email không hợp lệ");
            hasError = true;
        }

        if (Validator.containsWhitespace(username)) {
            request.setAttribute("usernameError", "Username không được chứa khoảng trắng");
            hasError = true;
        } else if (Validator.isEmpty(username)) {
            request.setAttribute("usernameError", "Username không được để trống");
            hasError = true;
        }

        if (!Validator.isValidPassword(password)) {
            request.setAttribute("passwordError",
                    "Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt");
            hasError = true;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Mật khẩu nhập lại không khớp");
            hasError = true;
        }

        if (!Validator.isValidPhoneNumber(phone)) {
            request.setAttribute("phoneError", "Số điện thoại không đúng định dạng");
            hasError = true;
        }

        if (userDAO.isPhoneNumberExists(phone)) {
            request.setAttribute("phoneError", "Số điện thoại đã tồn tại trong hệ thống");
            hasError = true;
        }

        if (userDAO.isEmailExists(email)) {
            request.setAttribute("emailError", "Email đã tồn tại");
            hasError = true;
        }

        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("usernameError", "Username đã tồn tại");
            hasError = true;
        }

        // ===== CÓ LỖI → QUAY LẠI =====
        if (hasError) {
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.setAttribute("phoneNumber", phone);
            request.getRequestDispatcher("page/register.jsp").forward(request, response);
            return;
        }

        // ===== TẠO USER (CHƯA INSERT) =====
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setUsername(username);
        user.setPassword(PasswordUtil.hashPassword(password)); // ✔ HASH
        user.setPhoneNumber(phone);
        user.setRoleId(2);
        user.setStatus(true);
        user.setBirthDate(birthday);

        // ===== SINH OTP =====
        String otp = String.valueOf((int) (Math.random() * 9000) + 1000);
        long expireTime = System.currentTimeMillis() + 5 * 60 * 1000;

        HttpSession session = request.getSession();
        session.setAttribute("registerUser", user);
        session.setAttribute("registerOtp", otp);
        session.setAttribute("registerOtpTime", System.currentTimeMillis());
        session.setAttribute("registerOtpExpire", expireTime);

        // ===== GỬI MAIL OTP =====
        EmailSender sender = new EmailSender();
        sender.sendVerificationEmail(
                email,
                "Xác thực đăng ký SKYDRONE",
                username,
                otp,
                "Mã OTP của bạn",
                "Cảm ơn bạn đã đăng ký");

        // ===== CHUYỂN SANG OTP =====
        response.sendRedirect("page/otp.jsp");
    }

}
