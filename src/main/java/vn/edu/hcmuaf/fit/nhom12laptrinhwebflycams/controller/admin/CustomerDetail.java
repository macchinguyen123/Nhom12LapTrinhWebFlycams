package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CustomerDetail", value = "/admin/customer-detail")
public class CustomerDetail extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idRaw = req.getParameter("id");

        if (idRaw == null || idRaw.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/admin/customer-manage");
            return;
        }

        try {
            int id = Integer.parseInt(idRaw);
            User user = userDAO.findById(id);

            if (user == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/customer-manage");
                return;
            }

            List<User> users = userDAO.getAllCustomers();

            req.setAttribute("users", users);
            req.setAttribute("detailUser", user);
            req.setAttribute("showDetail", true); // ✅ Boolean true


            req.getRequestDispatcher("/page/admin/customer-manage.jsp")
                    .forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/customer-manage");
        }
    }
}