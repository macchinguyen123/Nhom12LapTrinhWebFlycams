package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "VerifyOtp", value = "/VerifyOtp")
public class VerifyOtpController extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String otpInput = request.getParameter("otp"); // lấy từ 1 ô duy nhất

        HttpSession session = request.getSession();
        String otpSession = (String) session.getAttribute("otp");

        if (otpSession != null && otpSession.equals(otpInput)) {
            // OTP đúng → sang trang đặt mật khẩu mới
            request.getRequestDispatcher("/page/create-new-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Mã OTP không đúng!");
            request.getRequestDispatcher("/page/otp.jsp").forward(request, response);
        }
    }
}
