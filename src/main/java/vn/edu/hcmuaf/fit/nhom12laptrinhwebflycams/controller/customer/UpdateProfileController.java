package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;


@WebServlet("/UpdateProfileServlet")
public class UpdateProfileController extends HttpServlet {
    private UserDAO dao = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String username = req.getParameter("username");
        String fullName = req.getParameter("fullName");
        String phoneNumber = req.getParameter("phoneNumber");
        String gender = req.getParameter("gender");
        String birthDateStr = req.getParameter("birthDate"); // yyyy-MM-dd

        try {
            // Debug log input
            System.out.println("DEBUG - Input from form:");
            System.out.println("username=" + username);
            System.out.println("fullName=" + fullName);
            System.out.println("phoneNumber=" + phoneNumber);
            System.out.println("gender=" + gender);
            System.out.println("birthDateStr=" + birthDateStr);

            if (birthDateStr != null && !birthDateStr.isEmpty()) {
                Date birthDate = new SimpleDateFormat("yyyy-MM-dd").parse(birthDateStr);
                user.setBirthDate(birthDate);
                System.out.println("DEBUG - Parsed birthDate=" + birthDate);
            }

            user.setUsername(username);
            user.setFullName(fullName);
            user.setPhoneNumber(phoneNumber);
            user.setGender(gender);

            // Debug log before update
            System.out.println("DEBUG - User object before DAO update: "
                    + "id=" + user.getId()
                    + ", username=" + user.getUsername()
                    + ", fullName=" + user.getFullName()
                    + ", phone=" + user.getPhoneNumber()
                    + ", gender=" + user.getGender()
                    + ", birthDate=" + user.getBirthDate());

            dao.updateProfile(user);

            // cập nhật lại session
            req.getSession().setAttribute("user", user);

            resp.sendRedirect(req.getContextPath() + "/ProfileServlet");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", "Cập nhật thất bại!");
            req.getRequestDispatcher("/page/personal-page.jsp").forward(req, resp);
        }
    }
}
