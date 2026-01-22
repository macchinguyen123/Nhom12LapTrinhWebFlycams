package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import com.google.gson.Gson;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Categories;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.service.CategoryService;

import java.io.IOException;
import java.util.stream.Collectors;

@WebServlet(name = "CategorySortServlet", value = "/admin/category-sort")
public class CategorySortServlet extends HttpServlet {
    private CategoryService categoryService = new CategoryService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String json = req.getReader().lines().collect(Collectors.joining());
        Gson gson = new Gson();

        Categories[] items = gson.fromJson(json, Categories[].class);

        for (Categories item : items) {
            categoryService.updateCategorySort(item.getId(), item.getSortOrder());
        }

        resp.setStatus(HttpServletResponse.SC_OK);
    }
}