package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet(name = "SearchSuggestion", value = "/search-suggestion")
public class SearchSuggestion extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String keyword = request.getParameter("keyword");

        response.setContentType("application/json;charset=UTF-8");

        if (keyword == null || keyword.trim().isEmpty()) {
            response.getWriter().write("[]");
            return;
        }

        List<Map<String, Object>> suggestions =
                productDAO.getProductSuggestions(keyword);

        response.getWriter().write(new Gson().toJson(suggestions));
    }


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}