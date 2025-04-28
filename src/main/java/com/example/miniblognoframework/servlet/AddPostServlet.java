package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.CategoryDAO;
import com.example.miniblognoframework.dao.PostCategoryDAO;
import com.example.miniblognoframework.dao.PostDAO;
import com.example.miniblognoframework.dao.PostTagDAO;
import com.example.miniblognoframework.dao.TagDAO;
import com.example.miniblognoframework.dao.UserDAO;
import com.example.miniblognoframework.model.Category;
import com.example.miniblognoframework.model.Post;
import com.example.miniblognoframework.model.Tag;
import com.example.miniblognoframework.model.User;
import com.example.miniblognoframework.utils.JwtUtil;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

public class AddPostServlet extends HttpServlet {

    private PostDAO postDAO;
    private PostCategoryDAO pcDAO;
    private PostTagDAO ptDAO;
    private CategoryDAO categoryDAO;
    private TagDAO tagDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        postDAO     = new PostDAO();
        pcDAO       = new PostCategoryDAO();
        ptDAO       = new PostTagDAO();
        categoryDAO = new CategoryDAO();
        tagDAO      = new TagDAO();
        userDAO     = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Получаем списки из БД
        List<Category> categories = categoryDAO.findAll();
        List<Tag>       tags       = tagDAO.findAll();

        // Кладём их в request
        req.setAttribute("allCategories", categories);
        req.setAttribute("allTags",       tags);

        // Форвардим на JSP с формой
        req.getRequestDispatcher("/form.jsp")
                .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        // Определяем User: сначала JWT, потом сессия
        User user = null;
        String header = req.getHeader("Authorization");
        if (header != null && header.startsWith("Bearer ")) {
            try {
                String username = JwtUtil.validateToken(header.substring(7));
                user = userDAO.getUserByUsername(username);
            } catch (JwtException ignored) { }
        }
        if (user == null) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
        }
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        // Создаем и сохраняем сам пост
        String title   = req.getParameter("title");
        String content = req.getParameter("content");
        Post post = new Post();
        post.setTitle(title);
        post.setContent(content);
        post.setUserId(user.getId());
        postDAO.addPost(post);

        int postId = post.getId();

        // Сохраняем категории
        String[] catIds = req.getParameterValues("categoryIds");
        if (catIds != null) {
            for (String cid : catIds) {
                pcDAO.addMapping(postId, Integer.parseInt(cid));
            }
        }

        // Сохраняем теги
        String[] tagIds = req.getParameterValues("tagIds");
        if (tagIds != null) {
            for (String tid : tagIds) {
                ptDAO.addMapping(postId, Integer.parseInt(tid));
            }
        }

        // Перенаправляем на список постов
        resp.sendRedirect(req.getContextPath() + "/posts");
    }
}
