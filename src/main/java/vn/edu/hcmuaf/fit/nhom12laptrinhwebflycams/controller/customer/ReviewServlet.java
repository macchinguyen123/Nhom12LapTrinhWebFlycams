package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.OrderService;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.ReviewService;

import java.io.IOException;

@WebServlet(name = "ReviewServlet", value = "/ReviewServlet")
public class ReviewServlet extends HttpServlet {
    private ReviewService reviewService = new ReviewService();
    private OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Có thể xử lý GET nếu cần
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");

        // Kiểm tra đăng nhập
        User user = (User) request.getSession().getAttribute("user");
        System.out.println("[Servlet] user = " + user);

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"status\":\"login_required\",\"message\":\"Bạn cần đăng nhập để đánh giá\"}");
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
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Thiếu thông tin\"}");
                return;
            }

            int productId = Integer.parseInt(productIdRaw);
            int rating = Integer.parseInt(ratingRaw);

            // Kiểm tra xem user đã mua sản phẩm này chưa
            if (!orderService.hasUserPurchasedProduct(user.getId(), productId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter()
                        .write("{\"status\":\"error\",\"message\":\"Bạn chỉ có thể đánh giá sản phẩm đã mua\"}");
                return;
            }

            // Kiểm tra xem user đã đánh giá sản phẩm này chưa
            if (reviewService.hasUserReviewedProduct(user.getId(), productId)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.getWriter().write("{\"status\":\"error\",\"message\":\"Bạn đã đánh giá sản phẩm này rồi\"}");
                return;
            }

            // Lưu đánh giá
            reviewService.saveReview(user.getId(), productId, rating, content);

            // Tính toán lại điểm trung bình
            double avg = reviewService.getAverageRating(productId);
            int count = reviewService.countReviews(productId);

            response.getWriter().write(
                    "{\"status\":\"success\"," +
                            "\"message\":\"Cảm ơn bạn đã đánh giá!\"," +
                            "\"avg\":" + String.format("%.1f", avg) +
                            ",\"count\":" + count + "}");

        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Dữ liệu không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"status\":\"error\",\"message\":\"Lỗi server\"}");
        }
    }
}