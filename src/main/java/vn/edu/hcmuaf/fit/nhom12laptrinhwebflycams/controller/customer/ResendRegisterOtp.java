package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.MailProperties.EmailSender;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "ResendRegisterOtp", value = "/ResendRegisterOtp")
public class ResendRegisterOtp extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("registerUser");

        if (user == null) {
            response.sendRedirect("page/register.jsp");
            return;
        }

        String otp = String.valueOf((int)(Math.random() * 9000) + 1000);
        long expireTime = System.currentTimeMillis() + 5 * 60 * 1000;

        session.setAttribute("registerOtp", otp);
        session.setAttribute("registerOtpTime", System.currentTimeMillis());
        session.setAttribute("registerOtpExpire", expireTime);

        EmailSender emailSender = new EmailSender();
        emailSender.sendVerificationEmail(
                user.getEmail(),
                "OTP mới - SKYDRONE",
                user.getUsername(),
                otp,
                "Mã OTP mới của bạn",
                "Vui lòng sử dụng mã mới"
        );

        response.sendRedirect("page/otp.jsp");
    }
}