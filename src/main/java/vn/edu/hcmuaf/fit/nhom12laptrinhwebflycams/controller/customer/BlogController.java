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

@WebServlet(name = "Blog", value = "/blog")
public class BlogController extends HttpServlet {

    private final BlogDAO blogDAO = new BlogDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Post> posts = blogDAO.getAllPosts();
        request.setAttribute("posts", posts);
        request.getRequestDispatcher("/page/blog.jsp").forward(request, response);
    }

}
