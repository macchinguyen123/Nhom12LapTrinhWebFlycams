package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Post;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.ArticleService;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "Blog", value = "/blog")
public class BlogController extends HttpServlet {

    private final ArticleService articleService = new ArticleService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Post> posts = articleService.getAllPosts();
        request.setAttribute("posts", posts);
        request.getRequestDispatcher("/page/blog.jsp").forward(request, response);
    }

}
