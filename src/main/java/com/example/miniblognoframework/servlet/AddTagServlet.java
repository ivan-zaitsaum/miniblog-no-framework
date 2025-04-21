package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.TagDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/add-tag")
public class AddTagServlet extends HttpServlet {
    private TagDAO tagDAO;

    @Override
    public void init() {
        tagDAO = new TagDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String name = req.getParameter("name");
        if (name != null && !name.isBlank()) {
            tagDAO.addTag(name.trim());
        }
        resp.sendRedirect(req.getContextPath() + "/add-post");
    }
}
