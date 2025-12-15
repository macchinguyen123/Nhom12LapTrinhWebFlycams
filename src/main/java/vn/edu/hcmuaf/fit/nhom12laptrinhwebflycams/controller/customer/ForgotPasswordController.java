package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

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

        // Sinh OTP 4 số
        String otp = String.valueOf((int)(Math.random() * 9000) + 1000);

// Lưu OTP vào session
        HttpSession session = request.getSession();
        session.setAttribute("otp", otp);
        session.setAttribute("email", email);

// In ra console để test
        System.out.println("OTP thử nghiệm cho " + email + " là: " + otp);

// Gửi sang JSP để hiển thị thử nghiệm
        request.setAttribute("otpTest", otp);
        request.getRequestDispatcher("/page/otp.jsp").forward(request, response);

    }
}
