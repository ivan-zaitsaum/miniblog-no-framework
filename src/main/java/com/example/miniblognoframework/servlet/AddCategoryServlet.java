package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.CategoryDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/add-category")
public class AddCategoryServlet extends HttpServlet {
    private CategoryDAO dao;

    @Override
    public void init() {
        dao = new CategoryDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        if (name != null && !name.isBlank()) {
            dao.add(name.trim());
        }
        // После создания редирект обратно на форму создания поста
        resp.sendRedirect(req.getContextPath() + "/add-post");
    }
}
