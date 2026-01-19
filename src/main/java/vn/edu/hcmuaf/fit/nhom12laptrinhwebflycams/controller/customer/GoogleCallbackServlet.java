package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import org.apache.http.NameValuePair;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.UserDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.User;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet(name = "GoogleCallbackServlet", value = "/google-callback")
public class GoogleCallbackServlet extends HttpServlet {
    private static final String CLIENT_ID = "75476416232-ge5966lp069m7494drdfhlh319d82t6l.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:8080/Nhom12LapTrinhWebFlycams/google-callback";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String code = request.getParameter("code");

        if (code == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        try (CloseableHttpClient client = HttpClients.createDefault()) {

            // 1. Đổi code lấy access token
            HttpPost post = new HttpPost("https://oauth2.googleapis.com/token");
            List<NameValuePair> params = new ArrayList<>();
            params.add(new BasicNameValuePair("code", code));
            params.add(new BasicNameValuePair("client_id", CLIENT_ID));
            params.add(new BasicNameValuePair("client_secret", CLIENT_SECRET));
            params.add(new BasicNameValuePair("redirect_uri", REDIRECT_URI));
            params.add(new BasicNameValuePair("grant_type", "authorization_code"));
            post.setEntity(new UrlEncodedFormEntity(params));

            CloseableHttpResponse tokenResponse = client.execute(post);
            String tokenJson = EntityUtils.toString(tokenResponse.getEntity());

            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> tokenData = mapper.readValue(tokenJson, Map.class);
            String accessToken = (String) tokenData.get("access_token");

            // 2. Lấy info Google
            HttpGet get = new HttpGet("https://www.googleapis.com/oauth2/v2/userinfo");
            get.setHeader("Authorization", "Bearer " + accessToken);
            CloseableHttpResponse userResponse = client.execute(get);

            String userJson = EntityUtils.toString(userResponse.getEntity());
            Map<String, Object> userInfo = mapper.readValue(userJson, Map.class);

            String email = (String) userInfo.get("email");

            // 3. CHECK EMAIL TRONG DB
            UserDAO userDAO = new UserDAO();
            User user = userDAO.findByEmail(email);

            if (user == null) {
                // ❌ Email không tồn tại
                request.getSession().setAttribute("error",
                        "Email Google này chưa được đăng ký trong hệ thống");
                response.sendRedirect(request.getContextPath() + "/Login");
                return;
            }

            // 4. LOGIN THÀNH CÔNG
            request.getSession().setAttribute("user", user);

            // 5. Redirect đúng
            response.sendRedirect(request.getContextPath() + "/home");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }
}