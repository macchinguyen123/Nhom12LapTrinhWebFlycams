package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.File;
import java.io.IOException;

@WebServlet(name = "AdminProfileServlet", value = "/admin/profile")
@MultipartConfig(maxFileSize = 5 * 1024 * 1024, // 5MB
        maxRequestSize = 10 * 1024 * 1024 // 10MB
)
public class AdminProfileServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User admin = (User) request.getSession().getAttribute("user");

        if (admin == null || admin.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Refresh thông tin admin từ DB
        User refreshedAdmin = userDAO.getUserById(admin.getId());
        if (refreshedAdmin != null) {
            request.getSession().setAttribute("user", refreshedAdmin);
            admin = refreshedAdmin;
        }

        request.setAttribute("admin", admin);

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
        if (admin == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        // Validate
        if (fullName == null || fullName.trim().isEmpty()) {
            req.getSession().setAttribute("infoMsg", "Họ tên không được để trống");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            req.getSession().setAttribute("infoMsg", "Email không hợp lệ");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        if (phone == null || !phone.matches("^0\\d{9}$")) {
            req.getSession().setAttribute("infoMsg", "Số điện thoại không hợp lệ (10 số, bắt đầu bằng 0)");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        // Lấy thông tin admin hiện tại từ DB để giữ lại các field khác
        User currentAdmin = userDAO.getUserById(admin.getId());
        if (currentAdmin == null) {
            req.getSession().setAttribute("infoMsg", "Không tìm thấy thông tin admin");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        // Cập nhật các trường cần thiết
        currentAdmin.setFullName(fullName.trim());
        currentAdmin.setEmail(email.trim());
        currentAdmin.setPhoneNumber(phone.trim());

        // Xử lý avatar
        try {
            Part avatarPart = req.getPart("avatar");

            if (avatarPart != null && avatarPart.getSize() > 0) {
                String contentType = avatarPart.getContentType();

                // Validate content type
                if (contentType == null || !contentType.startsWith("image/")) {
                    req.getSession().setAttribute("infoMsg", "File avatar phải là hình ảnh");
                    resp.sendRedirect(req.getContextPath() + "/admin/profile");
                    return;
                }

                // Validate file size (5MB)
                if (avatarPart.getSize() > 5 * 1024 * 1024) {
                    req.getSession().setAttribute("infoMsg", "File avatar không được vượt quá 5MB");
                    resp.sendRedirect(req.getContextPath() + "/admin/profile");
                    return;
                }

                String originalFileName = avatarPart.getSubmittedFileName();
                if (originalFileName == null || originalFileName.trim().isEmpty()) {
                    req.getSession().setAttribute("infoMsg", "Tên file không hợp lệ");
                    resp.sendRedirect(req.getContextPath() + "/admin/profile");
                    return;
                }

                // Tạo tên file unique
                String fileExtension = "";
                int dotIndex = originalFileName.lastIndexOf('.');
                if (dotIndex > 0) {
                    fileExtension = originalFileName.substring(dotIndex);
                }
                String fileName = System.currentTimeMillis() + fileExtension;

                // Lấy đường dẫn upload - deployment directory (temporary)
                String deploymentPath = getServletContext().getRealPath("/uploads/avatar/");
                File deployDir = new File(deploymentPath);

                // Tạo thư mục nếu chưa tồn tại
                if (!deployDir.exists()) {
                    deployDir.mkdirs();
                }

                // Lấy đường dẫn upload - source directory (persistent)
                String sourcePath = "D:/Nhom12LapTrinhWebFlycams/src/main/webapp/uploads/avatar/";
                File sourceDir = new File(sourcePath);
                if (!sourceDir.exists()) {
                    sourceDir.mkdirs();
                }

                // Lưu file vào deployment directory
                String deployFilePath = deploymentPath + File.separator + fileName;
                avatarPart.write(deployFilePath);

                // Copy file vào source directory cho tính bền vững
                String sourceFilePath = sourcePath + File.separator + fileName;
                try {
                    java.nio.file.Files.copy(
                            java.nio.file.Paths.get(deployFilePath),
                            java.nio.file.Paths.get(sourceFilePath),
                            java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                    System.out.println("Avatar saved to source: " + sourceFilePath);
                } catch (Exception copyEx) {
                    System.err.println("Failed to save avatar to source directory: " + copyEx.getMessage());
                    // Continue even if source save fails
                }

                System.out.println("Avatar saved to deployment: " + deployFilePath);

                // Cập nhật tên file vào object
                currentAdmin.setAvatar(fileName);
            }
            // Nếu không có file mới, giữ nguyên avatar cũ (đã có trong currentAdmin)

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("infoMsg", "Lỗi upload avatar: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        // Cập nhật vào database
        boolean success = userDAO.updateProfileAdmin(currentAdmin);

        if (success) {
            // Refresh lại thông tin trong session
            User updatedAdmin = userDAO.getUserById(currentAdmin.getId());
            if (updatedAdmin != null) {
                req.getSession().setAttribute("user", updatedAdmin);
            }
            req.getSession().setAttribute("infoMsg", "Cập nhật thông tin thành công");
        } else {
            req.getSession().setAttribute("infoMsg", "Cập nhật thất bại, vui lòng thử lại");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/profile");
    }

    // =========================
    // UPDATE BANK
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

        // Validate input
        if (oldPass == null || oldPass.trim().isEmpty()) {
            req.getSession().setAttribute("passMsg", "Vui lòng nhập mật khẩu cũ");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        if (newPass == null || newPass.trim().isEmpty()) {
            req.getSession().setAttribute("passMsg", "Vui lòng nhập mật khẩu mới");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        // Kiểm tra xác nhận
        if (!newPass.equals(confirmPass)) {
            req.getSession().setAttribute("passMsg", "Mật khẩu xác nhận không khớp");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        // Kiểm tra độ mạnh
        if (!isStrongPassword(newPass)) {
            req.getSession().setAttribute("passMsg",
                    "Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        // Lấy thông tin admin từ DB để kiểm tra mật khẩu
        User currentAdmin = userDAO.getUserById(admin.getId());
        if (currentAdmin == null) {
            req.getSession().setAttribute("passMsg", "Không tìm thấy thông tin admin");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        // Kiểm tra mật khẩu cũ (plaintext)
        if (!oldPass.equals(currentAdmin.getPassword())) {
            req.getSession().setAttribute("passMsg", "Mật khẩu cũ không đúng");
            resp.sendRedirect(req.getContextPath() + "/admin/profile");
            return;
        }

        // Cập nhật mật khẩu mới (plaintext)
        boolean success = userDAO.updatePassword(admin.getId(), newPass);

        if (success) {
            // Cập nhật password trong session
            admin.setPassword(newPass);
            req.getSession().setAttribute("user", admin);
            req.getSession().setAttribute("passMsg", "Đổi mật khẩu thành công");
        } else {
            req.getSession().setAttribute("passMsg", "Đổi mật khẩu thất bại, vui lòng thử lại");
        }

        resp.sendRedirect(req.getContextPath() + "/admin/profile");
    }

    private boolean isStrongPassword(String password) {
        return password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&]).{8,}$");
    }
}