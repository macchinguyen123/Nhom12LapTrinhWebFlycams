package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.AdminVNPayDao;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.AdminVNPay;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "AdminProfileServlet", value = "/admin/profile")
@MultipartConfig
public class AdminProfileServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private AdminVNPayDao vnpayDAO = new AdminVNPayDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User admin = (User) request.getSession().getAttribute("user");

        if (admin == null || admin.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        AdminVNPay bank = vnpayDAO.getByUserId(admin.getId());

        request.setAttribute("admin", admin);
        request.setAttribute("bank", bank);

        request.getRequestDispatcher("/page/admin/profile-admin.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (action) {
            case "update-info":
                updateInfo(request, response);
                break;
            case "update-bank":
                updateBank(request, response);
                break;
            case "change-password":
                changePassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    // =========================
    // UPDATE INFO
    // =========================
    private void updateInfo(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        User admin = (User) req.getSession().getAttribute("user");

        admin.setFullName(req.getParameter("fullName"));
        admin.setEmail(req.getParameter("email"));
        admin.setPhoneNumber(req.getParameter("phone"));

        Part avatarPart = req.getPart("avatar");
        if (avatarPart != null && avatarPart.getSize() > 0) {
            String fileName = System.currentTimeMillis()
                    + "_" + avatarPart.getSubmittedFileName();

            avatarPart.write(getServletContext()
                    .getRealPath("/uploads/avatar/") + fileName);

            admin.setAvatar(fileName);
        }

        userDAO.updateProfile(admin);

        // cập nhật lại session
        req.getSession().setAttribute("user", admin);

        resp.sendRedirect(req.getContextPath() + "/admin/profile");
    }

    // =========================
    // UPDATE BANK (stub)
    // =========================
    private void updateBank(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {

        User admin = (User) req.getSession().getAttribute("user");

        AdminVNPay bank = new AdminVNPay();
        bank.setUserId(admin.getId());
        bank.setBankName(req.getParameter("bankName"));
        bank.setAccountNumber(req.getParameter("accountNumber"));
        bank.setAccountName(req.getParameter("accountName"));

        Part qrPart = req.getPart("qr");
        if (qrPart != null && qrPart.getSize() > 0) {
            String qrName = System.currentTimeMillis() + "_" + qrPart.getSubmittedFileName();
            qrPart.write(getServletContext()
                    .getRealPath("/uploads/qr/") + qrName);
            bank.setQrCodeImage(qrName);
        }

        vnpayDAO.saveOrUpdate(bank);
        resp.sendRedirect(req.getContextPath() + "/admin/profile");
    }


    // =========================
    // CHANGE PASSWORD (stub)
    // =========================
    private void changePassword(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User admin = (User) req.getSession().getAttribute("user");
        if (admin == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String oldPass = req.getParameter("oldPassword");
        String newPass = req.getParameter("newPassword");
        String confirmPass = req.getParameter("confirmPassword");

        if (!newPass.equals(confirmPass)) {
            req.getSession().setAttribute("passMsg", "Mật khẩu xác nhận không khớp");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        if (!isStrongPassword(newPass)) {
            req.getSession().setAttribute("passMsg", "Mật khẩu chưa đủ mạnh");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        if (!vnpayDAO.checkPassword(admin.getId(), oldPass)) {
            req.getSession().setAttribute("passMsg", "Mật khẩu cũ không đúng");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        userDAO.updatePassword(admin.getId(), newPass);

        req.getSession().setAttribute("passMsg", "Đổi mật khẩu thành công");
        resp.sendRedirect(req.getContextPath() + "/admin/profile");
    }

    private boolean isStrongPassword(String password) {
        return password.matches(
                "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&]).{8,}$"
        );
    }


}
