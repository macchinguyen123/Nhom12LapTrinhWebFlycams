package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ReviewsDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;

@WebServlet(name = "ReviewServlet", value = "/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    private ReviewsDAO reviewsDAO = new ReviewsDAO();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"login_required\"}");
            return;
        }

        int productId = Integer.parseInt(request.getParameter("product_id"));
        int rating = Integer.parseInt(request.getParameter("rating"));
        String content = request.getParameter("content");

        reviewsDAO.saveReview(user.getId(), productId, rating, content);

        double avg = reviewsDAO.getAverageRating(productId);
        int count = reviewsDAO.countReviews(productId);

        response.getWriter().write(
                "{\"avg\":" + String.format("%.1f", avg) + ",\"count\":" + count + "}"
        );
    }
}