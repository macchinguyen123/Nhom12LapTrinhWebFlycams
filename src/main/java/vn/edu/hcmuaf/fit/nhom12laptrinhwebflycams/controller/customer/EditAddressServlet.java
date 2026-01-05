package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.AddressDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/EditAddressServlet")
public class EditAddressServlet extends HttpServlet {
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
        addr.setId(Integer.parseInt(req.getParameter("id")));
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
            dao.update(addr);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Tương tự, redirect về /personal?tab=addresses
        resp.sendRedirect(req.getContextPath() + "/personal?tab=addresses");
    }
}
