package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "ResetPassword", value = "/ResetPassword")
public class ResetPasswordController extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");

        boolean hasError = false;

        // ------------------ VALIDATE ------------------
        if (!vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.validate.Validator.isValidPassword(password)) {
            request.setAttribute("passwordError",
                    "Mật khẩu phải có chữ hoa, chữ thường, số và ký tự đặc biệt");
            hasError = true;
        }

        if (!password.equals(confirm)) {
            request.setAttribute("confirmPasswordError", "Mật khẩu nhập lại không khớp");
            hasError = true;
        }

        if (hasError) {
            request.getRequestDispatcher("/page/create-new-password.jsp").forward(request, response);
            return;
        }

        // ------------------ CẬP NHẬT ------------------
        User user = userDAO.getUserByEmail(email);
        if (user != null) {
            boolean updated = userDAO.updatePassword(user.getId(), password);
            if (updated) {
                // ✅ Sau khi đổi mật khẩu thành công → quay về login.jsp
                response.sendRedirect(request.getContextPath() + "/page/login.jsp?resetSuccess=1");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật mật khẩu!");
                request.getRequestDispatcher("/page/create-new-password.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Không tìm thấy tài khoản!");
            request.getRequestDispatcher("/page/create-new-password.jsp").forward(request, response);
        }
    }
}
