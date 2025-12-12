package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;


import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.validate.Validator;


import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "Register", value = "/Register")
public class Register extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("page/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy dữ liệu form
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirm"); // NEW
        String phone = request.getParameter("phoneNumber");
        String birthdayStr = request.getParameter("birthday");

        boolean hasError = false;

        Date birthday = null;
        try {
            birthday = java.sql.Date.valueOf(birthdayStr);
        } catch (Exception e) {
            request.setAttribute("birthdayError", "Ngày sinh không hợp lệ");
            hasError = true;
        }

        // ------------------ VALIDATE ------------------
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

        // ------- NEW: kiểm tra confirm password -------
        if (!password.equals(confirmPassword)) {
            request.setAttribute("confirmPasswordError", "Mật khẩu nhập lại không khớp");
            hasError = true;
        }

        if (!Validator.isValidPhoneNumber(phone)) {
            request.setAttribute("phoneError", "Số điện thoại không đúng định dạng");
            hasError = true;
        }

        UserDAO userDAO = new UserDAO();

        // ------- NEW: kiểm tra trùng email -------
        if (userDAO.isEmailExists(email)) {
            request.setAttribute("emailError", "Email đã tồn tại");
            hasError = true;
        }

        // ------- NEW: kiểm tra trùng username -------
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("usernameError", "Username đã tồn tại");
            hasError = true;
        }

        // Nếu lỗi → quay lại trang đăng ký
        if (hasError) {
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("username", username);
            request.setAttribute("phoneNumber", phone);

            request.getRequestDispatcher("page/register.jsp").forward(request, response);
            return;
        }

        // ------------------ TẠO USER ------------------
        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setUsername(username);
        user.setPassword(password);
        user.setPhoneNumber(phone);
        user.setRoleId(2);
        user.setStatus(true);
        user.setBirthDate(birthday);

        // INSERT
        boolean isInserted = userDAO.insertUser(user);

        if (!isInserted) {
            request.setAttribute("errorMessage", "Đăng ký tài khoản thất bại. Vui lòng thử lại!");
            request.getRequestDispatcher("page/register.jsp").forward(request, response);
            return;
        }

        response.sendRedirect("page/login.jsp?success=1");


    }

}
