package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.AddressDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/AddAddressServlet")
public class AddAddressServlet extends HttpServlet {
    private final AddressDAO dao = new AddressDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Address addr = new Address();
        addr.setUserId(user.getId());
        addr.setFullName(req.getParameter("fullName"));
        addr.setPhoneNumber(req.getParameter("phoneNumber"));
        addr.setAddressLine(req.getParameter("addressLine"));
        addr.setProvince(req.getParameter("province"));
        addr.setDistrict(req.getParameter("district"));
        addr.setDefaultAddress(req.getParameter("isDefault") != null);

        try {
            if (addr.isDefaultAddress()) {
                dao.resetDefault(user.getId());
            }
            dao.insert(addr);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        resp.sendRedirect(req.getContextPath() + "/ListAddressServlet");
    }
}
