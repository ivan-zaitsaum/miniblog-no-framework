package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.CategoryDAO;
import com.example.miniblognoframework.dao.PostCategoryDAO;
import com.example.miniblognoframework.dao.PostDAO;
import com.example.miniblognoframework.dao.PostTagDAO;
import com.example.miniblognoframework.dao.TagDAO;
import com.example.miniblognoframework.model.Post;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/аааа")
public class FormServlet extends HttpServlet {
    private PostDAO postDAO;
    private CategoryDAO categoryDAO;
    private TagDAO     tagDAO;
    private PostCategoryDAO postCategoryDAO;
    private PostTagDAO     postTagDAO;

    @Override
    public void init() {
        postDAO         = new PostDAO();
        categoryDAO     = new CategoryDAO();
        tagDAO          = new TagDAO();
        postCategoryDAO = new PostCategoryDAO();
        postTagDAO      = new PostTagDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Загружаем списки всех категорий и тегов
        req.setAttribute("allCategories", categoryDAO.findAll());
        req.setAttribute("allTags"      , tagDAO.findAll());

        String idParam = req.getParameter("id");
        if (idParam != null) {
            // режим редактирования
            int id = Integer.parseInt(idParam);
            Post post = postDAO.getPostById(id);
            // подтягиваем выбранные категории и теги
            post.setCategoryIds(postCategoryDAO.getCategoryIds(id));
            post.setTagIds     (postTagDAO.getTagIds(id));
            req.setAttribute("post", post);
        }

        req.getRequestDispatcher("/form.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // собираем данные из формы
        int    postId = 0;
        String idParam = req.getParameter("id");
        Post   post    = new Post();

        post.setTitle  (req.getParameter("title"));
        post.setContent(req.getParameter("content"));
        post.setUserId ((Integer)req.getSession().getAttribute("userId"));

        // категории
        String[] catParams = req.getParameterValues("categoryIds");
        List<Integer> cats = new ArrayList<>();
        if (catParams != null) {
            for (String s : catParams) cats.add(Integer.parseInt(s));
        }

        // теги
        String[] tagParams = req.getParameterValues("tagIds");
        List<Integer> tags = new ArrayList<>();
        if (tagParams != null) {
            for (String s : tagParams) tags.add(Integer.parseInt(s));
        }

        if (idParam == null) {
            // новый пост
            postDAO.addPost(post);
            postId = postDAO.getLastInsertId(); // добавьте метод в DAO
        } else {
            // обновление
            postId = Integer.parseInt(idParam);
            post.setId(postId);
            postDAO.updatePost(post);
        }

        // сохраняем категории и теги
        postCategoryDAO.setCategories(postId, cats);
        postTagDAO.setTags        (postId, tags);

        resp.sendRedirect(req.getContextPath() + "/posts");
    }
}
