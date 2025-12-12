package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.ProductDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Product;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "Searching", value = "/Searching")
public class Searching extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String keyword = request.getParameter("keyword"); // lấy từ khóa

        if(keyword == null) keyword = "";

        ProductDAO dao = new ProductDAO();
        List<Product> results = dao.searchProducts(keyword);

        request.setAttribute("keyword", keyword);
        request.setAttribute("products", results);

        // chuyển sang trang kết quả
        request.getRequestDispatcher("page/searching.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}