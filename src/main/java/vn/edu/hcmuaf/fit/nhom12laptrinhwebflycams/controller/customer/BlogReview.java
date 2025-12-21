package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.BlogDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Post;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "BlogReview", value = "/BlogReview")
public class BlogReview extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

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

        BlogDAO dao = new BlogDAO();

        // ✅ CHẶN BÌNH LUẬN LẦN 2
        if (dao.hasReviewed(blogId, user.getId())) {
            response.sendRedirect("article?id=" + blogId);
            return;
        }

        // ✅ LƯU BÌNH LUẬN
        dao.insert(blogId, user.getId(), content);

        // ✅ QUAY LẠI BÀI VIẾT
        response.sendRedirect("article?id=" + blogId);
    }
}