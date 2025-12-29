package vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.controller.admin;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.dao.PromotionDAO;
import vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Promotion;

import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@WebServlet("/admin/promotion-manage")
public class PromotionManageServlet extends HttpServlet {

    private PromotionDAO promotionDAO;

    @Override
    public void init() {
        promotionDAO = new PromotionDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Promotion> promotions = promotionDAO.getAllPromotions();

        Map<Integer, String> scopeMap = new HashMap<>();
        for (Promotion p : promotions) {
            scopeMap.put(p.getId(),
                    promotionDAO.getPromotionScope(p.getId()));
        }

        req.setAttribute("promotions", promotions);
        req.setAttribute("scopeMap", scopeMap);

        req.getRequestDispatcher("/page/admin/promotion-manage.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String action = req.getParameter("action");

        if ("add".equals(action)) {
            Promotion p = new Promotion();
            p.setName(req.getParameter("name"));
            p.setDiscountValue(Double.parseDouble(req.getParameter("discountValue")));
            p.setDiscountType(req.getParameter("discountType"));
            p.setStartDate(Date.valueOf(req.getParameter("startDate")));
            p.setEndDate(Date.valueOf(req.getParameter("endDate")));

            String scope = req.getParameter("scope");

            promotionDAO.insertPromotion(p, scope);
        }
        else if ("delete".equals(action)) {

            int id = Integer.parseInt(req.getParameter("id"));
            promotionDAO.deleteById(id);
        }
        else if ("edit".equals(action)) {

            Promotion p = new Promotion();
            p.setId(Integer.parseInt(req.getParameter("id")));
            p.setName(req.getParameter("name"));
            p.setDiscountValue(
                    Double.parseDouble(req.getParameter("discountValue"))
            );
            p.setDiscountType(req.getParameter("discountType"));
            p.setStartDate(Date.valueOf(req.getParameter("startDate")));
            p.setEndDate(Date.valueOf(req.getParameter("endDate")));

            promotionDAO.update(p);
        }

        resp.sendRedirect(req.getContextPath() + "/admin/promotion-manage");
    }
}


