package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.PostDAO;
import com.example.miniblognoframework.dao.CategoryDAO;
import com.example.miniblognoframework.dao.TagDAO;
import com.example.miniblognoframework.model.Post;
import com.example.miniblognoframework.model.Category;
import com.example.miniblognoframework.model.Tag;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/posts")
public class PostServlet extends HttpServlet {
    private PostDAO postDAO;
    private CategoryDAO categoryDAO;
    private TagDAO tagDAO;

    @Override
    public void init() throws ServletException {
        this.postDAO     = new PostDAO();
        this.categoryDAO = new CategoryDAO();
        this.tagDAO      = new TagDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1) Параметры фильтра/поиска
        String searchParam = req.getParameter("q");
        if (searchParam == null) searchParam = "";

        Integer categoryId = null;
        if (req.getParameter("category") != null && !req.getParameter("category").isEmpty()) {
            categoryId = Integer.valueOf(req.getParameter("category"));
        }

        Integer tagId = null;
        if (req.getParameter("tag") != null && !req.getParameter("tag").isEmpty()) {
            tagId = Integer.valueOf(req.getParameter("tag"));
        }

        int page = 1;
        try { page = Integer.parseInt(req.getParameter("page")); }
        catch (Exception ignored) {}

        // 2) Выбор DAO-метода по фильтру
        List<Post> posts;
        int totalCount;
        if (categoryId != null) {
            posts      = postDAO.getPostsByCategory(categoryId, page);
            totalCount = postDAO.countPostsByCategory(categoryId);
        }
        else if (tagId != null) {
            posts      = postDAO.getPostsByTag(tagId, page);
            totalCount = postDAO.countPostsByTag(tagId);
        }
        else {
            posts      = postDAO.getPostsPage(searchParam, page);
            totalCount = postDAO.countPosts(searchParam);
        }

        int totalPages = (int)Math.ceil(totalCount / (double)PostDAO.PAGE_SIZE);
        if (page < 1)       page = 1;
        if (page > totalPages) page = totalPages;

        // 3) Списки категорий и тегов для выпадающих списков
        List<Category> categories = categoryDAO.findAll();
        List<Tag>       tags       = tagDAO.findAll();

        // 4) Кладём всё в request
        req.setAttribute("posts", posts);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);

        req.setAttribute("searchQuery", searchParam);
        req.setAttribute("selectedCategory", categoryId);
        req.setAttribute("selectedTag", tagId);

        req.setAttribute("categories", categories);
        req.setAttribute("tags", tags);

        // 5) Форвардим на JSP
        req.getRequestDispatcher("/index.jsp")  // или "/WEB-INF/posts.jsp"
                .forward(req, resp);
    }
}
