package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerManage", value = "/admin/customer-manage")
public class CustomerManage extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<User> users = userDAO.getAllUsers();
        req.setAttribute("users", users);
        req.setAttribute("showDetail", Boolean.FALSE); // ← Dùng Boolean.FALSE

        req.getRequestDispatcher("/page/admin/customer-manage.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}