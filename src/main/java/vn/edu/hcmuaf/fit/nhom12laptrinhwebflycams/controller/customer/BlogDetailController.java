package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.BlogDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Post;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;


@WebServlet(name = "BlogDetailController", value = "/article")
public class BlogDetailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int postId = Integer.parseInt(request.getParameter("id"));

        BlogDAO dao = new BlogDAO();
        Post post = dao.getPostById(postId);

        request.setAttribute("post", post);
        request.setAttribute("morePosts", dao.getMorePosts(postId));
        request.setAttribute("relatedPosts", dao.getRelatedPosts(postId));

        // ===== DANH SÁCH BÌNH LUẬN =====
        request.setAttribute("comments", dao.getReviewsByBlog(postId));

        // ===== QUAN TRỌNG: KIỂM TRA ĐÃ BÌNH LUẬN CHƯA =====
        boolean hasReviewed = false;
        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            hasReviewed = dao.hasReviewed(postId, user.getId());
        }

        request.setAttribute("hasReviewed", hasReviewed);

        request.getRequestDispatcher("/page/article.jsp")
                .forward(request, response);
    }

}