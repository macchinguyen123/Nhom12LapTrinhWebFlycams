package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "Login", value = "/Login")
public class Login extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String input = request.getParameter("loginInput");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        User user = dao.login(input, password);

        // Sai thông tin
        if (user == null) {
            request.setAttribute("error", "Sai thông tin đăng nhập!");
            request.getRequestDispatcher("/page/login.jsp").forward(request, response);
            return;
        }

        // Tạo session và lưu JavaBean
        HttpSession session = request.getSession();
        session.setAttribute("user", user);

        // chuyển hướng theo role
        if (user.getRoleId() == 1) {
            response.sendRedirect("admin/dashboard.jsp");
        } else {
            response.sendRedirect("page/homepage.jsp");
        }
    }
}