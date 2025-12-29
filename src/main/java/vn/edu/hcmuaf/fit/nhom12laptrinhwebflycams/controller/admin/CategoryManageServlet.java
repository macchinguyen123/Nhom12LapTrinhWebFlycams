package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.CategoryDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Categories;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet(name = "CategoryManageServlet", value = "/admin/category-manage")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 100 // 100 MB
)
public class CategoryManageServlet extends HttpServlet {

    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("delete".equals(action)) {
            handleDelete(req, resp);
            return;
        }

        List<Categories> list = categoryDAO.getAllCategoriesAdmin();
        req.setAttribute("categories", list);
        req.getRequestDispatcher("/page/admin/category-manage.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action"); // add or update

        if ("add".equals(action)) {
            handleAdd(req, resp);
        } else if ("update".equals(action)) {
            handleUpdate(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/category-manage");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String name = req.getParameter("categoryName");
        String status = req.getParameter("status");

        String imagePath = "default.png";
        Part filePart = req.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            // Basic filename sanitization
            fileName = System.currentTimeMillis() + "_" + fileName.replaceAll("\\s+", "_");

            String uploadPath = req.getServletContext().getRealPath("/image");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists())
                uploadDir.mkdir();

            filePart.write(uploadPath + File.separator + fileName);
            imagePath = "image/" + fileName; // Relative path for DB
        }

        Categories c = new Categories();
        c.setCategoryName(name);
        c.setStatus(status);
        c.setImage(imagePath);

        categoryDAO.insert(c);
        resp.sendRedirect(req.getContextPath() + "/admin/category-manage");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        int id = Integer.parseInt(req.getParameter("id"));
        String name = req.getParameter("categoryName");
        String status = req.getParameter("status");
        String oldImage = req.getParameter("oldImage");

        String imagePath = oldImage;
        Part filePart = req.getPart("image");
        if (filePart != null && filePart.getSize() > 0) {
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            fileName = System.currentTimeMillis() + "_" + fileName.replaceAll("\\s+", "_");

            String uploadPath = req.getServletContext().getRealPath("/image");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists())
                uploadDir.mkdir();

            filePart.write(uploadPath + File.separator + fileName);
            imagePath = "image/" + fileName;
        }

        Categories c = new Categories(id, name, imagePath, status);
        categoryDAO.update(c);
        resp.sendRedirect(req.getContextPath() + "/admin/category-manage");
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                categoryDAO.delete(id);
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        resp.sendRedirect(req.getContextPath() + "/admin/category-manage");
    }
}
