package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.CategoryDAO;
import com.example.miniblognoframework.dao.PostCategoryDAO;
import com.example.miniblognoframework.dao.PostDAO;
import com.example.miniblognoframework.dao.PostTagDAO;
import com.example.miniblognoframework.dao.TagDAO;
import com.example.miniblognoframework.model.Post;
import com.example.miniblognoframework.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/add-post")
public class AddPostServlet extends HttpServlet {

    private PostDAO postDAO;
    private CategoryDAO categoryDAO;
    private TagDAO tagDAO;
    private PostCategoryDAO postCategoryDAO;
    private PostTagDAO postTagDAO;

    @Override
    public void init() {
        postDAO          = new PostDAO();
        categoryDAO      = new CategoryDAO();
        tagDAO           = new TagDAO();
        postCategoryDAO  = new PostCategoryDAO();
        postTagDAO       = new PostTagDAO();
    }

    // Показываем форму создания (с подтянутыми allCategories и allTags)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // проверяем аутентификацию
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // подгружаем справочники
        request.setAttribute("allCategories", categoryDAO.findAll());
        request.setAttribute("allTags"      , tagDAO.findAll());

        // никаких параметров — это создание нового поста
        request.getRequestDispatcher("/form.jsp")
                .forward(request, response);
    }



    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession(false).getAttribute("user");

        // 1) Сохраняем пост и получаем его ID
        Post post = new Post();
        post.setTitle(req.getParameter("title"));
        post.setContent(req.getParameter("content"));
        post.setUserId(user.getId());
        postDAO.addPost(post);
        int postId = post.getId();  // ← правильно полученный ID

        // 2) Собираем все выбранные категории
        List<Integer> cats = new ArrayList<>();
        String[] existingCats = req.getParameterValues("categoryIds");
        if (existingCats != null) {
            for (String s : existingCats) cats.add(Integer.parseInt(s));
        }
        // 2.1) Создаём новую, если введено имя
        String newCat = req.getParameter("newCategory");
        if (newCat != null && !newCat.isBlank()) {
            int newCatId = categoryDAO.addAndGetId(newCat.trim());
            cats.add(newCatId);
        }
        postCategoryDAO.setCategories(postId, cats);

        // 3) Аналогично для тегов
        List<Integer> tags = new ArrayList<>();
        String[] existingTags = req.getParameterValues("tagIds");
        if (existingTags != null) {
            for (String s : existingTags) tags.add(Integer.parseInt(s));
        }
        String newTag = req.getParameter("newTag");
        if (newTag != null && !newTag.isBlank()) {
            int newTagId = tagDAO.addAndGetId(newTag.trim());
            tags.add(newTagId);
        }
        postTagDAO.setTags(postId, tags);

        // 4) Переходим обратно на список
        resp.sendRedirect(req.getContextPath() + "/posts");
    }
}
