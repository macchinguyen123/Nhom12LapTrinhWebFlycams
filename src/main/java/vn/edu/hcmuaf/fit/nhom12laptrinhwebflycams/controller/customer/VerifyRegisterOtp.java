package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;

@WebServlet(name = "VerifyRegisterOtp", value = "/VerifyRegisterOtp")
public class VerifyRegisterOtp extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/page/register.jsp");
            return;
        }

        String otpInput = request.getParameter("otp");
        String otpSession = (String) session.getAttribute("registerOtp");
        Long otpExpire = (Long) session.getAttribute("registerOtpExpire");
        User user = (User) session.getAttribute("registerUser");

        if (otpSession == null || otpExpire == null || user == null) {
            request.setAttribute("error", "Phiên xác thực không hợp lệ. Vui lòng đăng ký lại.");
            request.getRequestDispatcher("/page/otp.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > otpExpire) {
            request.setAttribute("error", "Mã OTP đã hết hạn. Vui lòng gửi lại mã.");
            request.getRequestDispatcher("/page/otp.jsp").forward(request, response);
            return;
        }

        if (!otpSession.equals(otpInput)) {
            request.setAttribute("error", "Mã OTP không chính xác!");
            request.getRequestDispatcher("/page/otp.jsp").forward(request, response);
            return;
        }

        // ✅ OTP ĐÚNG → LƯU USER
        userDAO.insertUser(user);

        session.invalidate(); // xoá toàn bộ OTP

        response.sendRedirect(request.getContextPath() + "/page/register-success.jsp");
    }

}