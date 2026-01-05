package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.customer;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.CategoryDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Categories;

import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class HeaderCategoryFilter implements Filter {

    private CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;

        List<Categories> headerCategories =
                categoryDAO.getCategoriesForHeader();

        req.setAttribute("headerCategories", headerCategories);

        chain.doFilter(request, response);
    }


}