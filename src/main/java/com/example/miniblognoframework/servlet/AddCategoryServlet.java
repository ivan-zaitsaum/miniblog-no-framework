package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.CategoryDAO;
import com.example.miniblognoframework.dao.TagDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/add-category")
public class AddCategoryServlet extends HttpServlet {
    private CategoryDAO categoryDAO;
    private TagDAO      tagDAO;

    @Override
    public void init() throws ServletException {
        categoryDAO = new CategoryDAO();
        tagDAO      = new TagDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // 1) Добавляем категорию
        String name = req.getParameter("name");
        if (name != null && !name.isBlank()) {
            categoryDAO.addCategory(name.trim());
        }

        // 2) Собираем состояние формы
        String prevTitle   = req.getParameter("prevTitle");
        String prevContent = req.getParameter("prevContent");
        String[] catIds    = req.getParameterValues("categoryIds");
        String[] tagIds    = req.getParameterValues("tagIds");

        // 3) Восстанавливаем отмеченные чекбоксы
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

        // 4) Кладём в request
        req.setAttribute("prevTitle",   prevTitle);
        req.setAttribute("prevContent", prevContent);
        req.setAttribute("selCatMap",   selCatMap);
        req.setAttribute("selTagMap",   selTagMap);

        // 5) Подгружаем обновлённые списки
        req.setAttribute("allCategories", categoryDAO.findAll());
        req.setAttribute("allTags",       tagDAO.findAll());

        // 6) Форвардим обратно на форму
        req.getRequestDispatcher("/form.jsp").forward(req, resp);
    }
}
