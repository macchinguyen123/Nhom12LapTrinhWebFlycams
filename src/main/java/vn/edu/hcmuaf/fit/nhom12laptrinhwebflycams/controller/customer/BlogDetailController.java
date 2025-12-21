package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.BlogDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Post;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BlogDetail", value = "/blog-detail")
public class BlogDetailController extends HttpServlet {

    private final BlogDAO blogDAO = new BlogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idRaw = request.getParameter("id");

        if (idRaw == null) {
            response.sendRedirect("blog");
            return;
        }

        try {
            int id = Integer.parseInt(idRaw);

            Post post = blogDAO.getPostById(id);

            if (post == null) {
                response.sendError(404, "Bài viết không tồn tại");
                return;
            }

            // Gợi ý bài viết liên quan
            List<Post> related = blogDAO.getAllPosts();

            request.setAttribute("post", post);
            request.setAttribute("relatedPosts", related);

            request.getRequestDispatcher("/page/article.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(400, "ID không hợp lệ");
        }

    }
}