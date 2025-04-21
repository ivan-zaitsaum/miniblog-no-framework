package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.PostDAO;
import com.example.miniblognoframework.dao.PostCategoryDAO;
import com.example.miniblognoframework.dao.PostTagDAO;
import com.example.miniblognoframework.dao.CategoryDAO;
import com.example.miniblognoframework.dao.TagDAO;
import com.example.miniblognoframework.model.Post;
import com.example.miniblognoframework.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/add-post")
public class AddPostServlet extends HttpServlet {

    private PostDAO postDAO;
    private PostCategoryDAO pcDAO;
    private PostTagDAO ptDAO;
    private CategoryDAO categoryDAO;
    private TagDAO tagDAO;

    @Override
    public void init() throws ServletException {
        postDAO      = new PostDAO();
        pcDAO        = new PostCategoryDAO();
        ptDAO        = new PostTagDAO();
        categoryDAO  = new CategoryDAO();
        tagDAO       = new TagDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Подготовить списки категорий и тегов
        List categories = categoryDAO.findAll();
        List tags       = tagDAO.findAll();
        req.setAttribute("allCategories", categories);
        req.setAttribute("allTags",       tags);

        // Показываем форму
        req.getRequestDispatcher("/form.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        // 1) Сохраняем сам пост
        String title   = req.getParameter("title");
        String content = req.getParameter("content");
        Post post = new Post();
        post.setTitle(title);
        post.setContent(content);
        post.setUserId(user.getId());
        postDAO.addPost(post);  // теперь post.getId() есть

        int postId = post.getId();

        // 2) Категории: checkbox name="categoryIds"
        String[] catIds = req.getParameterValues("categoryIds");
        if (catIds != null) {
            for (String cid : catIds) {
                pcDAO.addMapping(postId, Integer.parseInt(cid));
            }
        }

        // 3) Теги: checkbox name="tagIds"
        String[] tagIds = req.getParameterValues("tagIds");
        if (tagIds != null) {
            for (String tid : tagIds) {
                ptDAO.addMapping(postId, Integer.parseInt(tid));
            }
        }

        resp.sendRedirect(req.getContextPath() + "/posts");
    }
}
