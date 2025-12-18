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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        User user = (User) request.getSession().getAttribute("user");
        System.out.println("[Servlet] user = " + user);
        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"login_required\"}");
            return;
        }

        try {
            String productIdRaw = request.getParameter("product_id");
            String ratingRaw = request.getParameter("rating");
            String content = request.getParameter("content");
            System.out.println("[Servlet] product_id = " + productIdRaw);
            System.out.println("[Servlet] rating     = " + ratingRaw);
            System.out.println("[Servlet] content    = " + content);

            if (productIdRaw == null || ratingRaw == null || content == null) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"missing_param\"}");
                return;
            }

            int productId = Integer.parseInt(productIdRaw);
            int rating = Integer.parseInt(ratingRaw);

            reviewsDAO.saveReview(user.getId(), productId, rating, content);

            double avg = reviewsDAO.getAverageRating(productId);
            int count = reviewsDAO.countReviews(productId);

            response.getWriter().write(
                    "{\"avg\":" + String.format("%.1f", avg) +
                            ",\"count\":" + count + "}"
            );

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"server_error\"}");
        }
    }
}