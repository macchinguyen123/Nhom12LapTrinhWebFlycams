package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Post;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.ArticleService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "Article", value = "/article-detail")
public class Article extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int blogId = Integer.parseInt(request.getParameter("id"));
        ArticleService articleService = new ArticleService();

        Post post = articleService.getPostById(blogId);

        User user = (User) request.getSession().getAttribute("user");
        boolean hasReviewed = user != null && articleService.hasUserReviewed(blogId, user.getId());

        request.setAttribute("post", post);
        request.setAttribute("comments", articleService.getComments(blogId));
        request.setAttribute("hasReviewed", hasReviewed);

        request.getRequestDispatcher("/page/article.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}