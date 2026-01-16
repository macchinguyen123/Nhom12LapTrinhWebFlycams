package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.AddressDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/DeleteAddressServlet")
public class DeleteAddressServlet extends HttpServlet {
    private final AddressDAO dao = new AddressDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        try {
            int id = Integer.parseInt(req.getParameter("id"));

            boolean success = dao.delete(id, user.getId());

            if (success) {
                req.getSession().setAttribute("success", "Xóa địa chỉ thành công!");
            } else {
                req.getSession().setAttribute("error", "Không tìm thấy địa chỉ hoặc bạn không có quyền xóa!");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Lỗi khi xóa địa chỉ!");
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "ID địa chỉ không hợp lệ!");
        }

        resp.sendRedirect(req.getContextPath() + "/personal?tab=addresses");
    }
}