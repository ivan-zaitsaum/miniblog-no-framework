package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.CategoryDAO;
import com.example.miniblognoframework.dao.TagDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class AddTagServlet extends HttpServlet {
    private TagDAO      tagDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        tagDAO      = new TagDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // Добавляем новый тег
        String name = req.getParameter("name");
        if (name != null && !name.isBlank()) {
            tagDAO.addTag(name.trim());
        }

        // Восстанавливаем состояние формы поста
        String prevTitle   = req.getParameter("prevTitle");
        String prevContent = req.getParameter("prevContent");
        String[] catIds    = req.getParameterValues("categoryIds");
        String[] tagIds    = req.getParameterValues("tagIds");

        // Собираем отмеченные чекбоксы
        Map<Integer, Boolean> selCatMap = new HashMap<>();
        if (catIds != null) {
            for (String cid : catIds) {
                selCatMap.put(Integer.valueOf(cid), true);
            }
        }
        Map<Integer, Boolean> selTagMap = new HashMap<>();
        if (tagIds != null) {
            for (String tid : tagIds) {
                selTagMap.put(Integer.valueOf(tid), true);
            }
        }

        // Прокидываем в request-атрибуты
        req.setAttribute("prevTitle",   prevTitle);
        req.setAttribute("prevContent", prevContent);
        req.setAttribute("selCatMap",   selCatMap);
        req.setAttribute("selTagMap",   selTagMap);

        // Обновлённые списки
        req.setAttribute("allCategories", categoryDAO.findAll());
        req.setAttribute("allTags",       tagDAO.findAll());

        // Forward на form.jsp
        req.getRequestDispatcher("/form.jsp").forward(req, resp);
    }
}
