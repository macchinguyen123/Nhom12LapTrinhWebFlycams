package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.ArticleService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Post;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "BlogReview", value = "/BlogReview")
public class BlogReview extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        int blogId = Integer.parseInt(request.getParameter("blogId"));
        String content = request.getParameter("content");

        ArticleService articleService = new ArticleService();

        // CHẶN BÌNH LUẬN LẦN 2
        if (articleService.hasUserReviewed(blogId, user.getId())) {
            response.sendRedirect(request.getContextPath() + "/article?id=" + blogId);

            return;
        }

        // SAU KHI LƯU BÌNH LUẬN
        articleService.addReview(blogId, user.getId(), content);
        response.sendRedirect(request.getContextPath() + "/article?id=" + blogId);

    }
}