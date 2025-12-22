package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.util.Calendar;
import java.util.TimeZone;

@WebServlet(name = "Personal", value = "/personal")
public class PersonalController extends HttpServlet {
    private UserDAO dao = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/Login");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        User user = dao.getUserById(sessionUser.getId()); // lấy từ DB
        req.setAttribute("user", user);



        if (user.getBirthDate() != null) {
            Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("Asia/Ho_Chi_Minh"));
            cal.setTime(user.getBirthDate());

            req.setAttribute("birthDay", cal.get(Calendar.DAY_OF_MONTH));
            req.setAttribute("birthMonth", cal.get(Calendar.MONTH) + 1);
            req.setAttribute("birthYear", cal.get(Calendar.YEAR));
        }

        req.setAttribute("user", user);
        req.getRequestDispatcher("/page/personal-page.jsp").forward(req, resp);

    }
}
