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
    private AddressDAO dao = new AddressDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String addressLine = request.getParameter("addressLine");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        boolean isDefault = request.getParameter("isDefault") != null;

        Address address = new Address();
        address.setId(id);
        address.setUserId(user.getId());
        address.setFullName(fullName);
        address.setPhoneNumber(phoneNumber);
        address.setAddressLine(addressLine);
        address.setProvince(province);
        address.setDistrict(district);
        address.setDefaultAddress(isDefault);

        try {
            if (isDefault) {
                dao.resetDefault(user.getId());
            }
            dao.update(address);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/ListAddressServlet#addresses-section");
    }
}
