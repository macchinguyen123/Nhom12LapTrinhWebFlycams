package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.AddressDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Address;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "AddAddressServlet", value = "/AddAddressServlet")
public class AddAddressServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        System.out.println("===== AddressServlet doGet START =====");

        User user = (User) req.getSession().getAttribute("user");
        System.out.println("USER  = " + user);
        HttpSession s = req.getSession(false);
        System.out.println("ADDRESS SESSION ID = " + (s != null ? s.getId() : "NULL"));


        if (user == null) {
            System.out.println("USER IS NULL → redirect login");
            resp.sendRedirect("login.jsp");
            return;
        }

        System.out.println("USER ID = " + user.getId());

        AddressDAO dao = new AddressDAO();
        try {
            List<Address> list = dao.findByUserId(user.getId());

            System.out.println("ADDRESS LIST SIZE = " + list.size());

            if (!list.isEmpty()) {
                Address a = list.get(0);
                System.out.println("FIRST ADDRESS:");
                System.out.println(" - FullName: " + a.getFullName());
                System.out.println(" - Phone: " + a.getPhoneNumber());
                System.out.println(" - Default: " + a.isDefaultAddress());
            }

            req.setAttribute("addresses", list);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new ServletException(e);
        }

        System.out.println("FORWARD TO JSP");
        System.out.println("===== AddressServlet doGet END =====");

        req.getRequestDispatcher("/page/personal-page.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy user từ session
        User user = (User) request.getSession().getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // 2. Lấy dữ liệu từ form
        Address address = new Address();
        address.setUserId(user.getId());
        address.setFullName(request.getParameter("fullName"));
        address.setPhoneNumber(request.getParameter("phoneNumber"));
        address.setAddressLine(request.getParameter("addressLine"));
        address.setProvince(request.getParameter("province"));
        address.setDistrict(request.getParameter("district"));
        address.setDefaultAddress(request.getParameter("isDefault") != null);

        AddressDAO dao = new AddressDAO();

        try {
            // 3. Nếu là địa chỉ mặc định → reset cái cũ
            if (address.isDefaultAddress()) {
                dao.resetDefault(user.getId());
            }

            dao.insert(address);
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        // 4. Quay về section địa chỉ
        response.sendRedirect(
                request.getContextPath() + "/AddAddressServlet#addresses-section"
        );
    }
}