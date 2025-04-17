package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.PostDAO;
import com.example.miniblognoframework.model.Post;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/posts")
public class PostServlet extends HttpServlet {

    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        this.postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1) Параметр поиска
        String search = request.getParameter("q");
        if (search == null) search = "";

        // 2) Номер страницы
        String pageParam = request.getParameter("page");
        int page = 1;
        try {
            page = Integer.parseInt(pageParam);
        } catch (Exception ignored) { }

        // 3) Считаем общее число постов (с учётом поиска)
        int totalPosts = postDAO.countPosts(search);
        int pageSize   = PostDAO.PAGE_SIZE; // например 10
        int totalPages = (int)Math.ceil((double)totalPosts / pageSize);

        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        // 4) Получаем конкретную страницу
        List<Post> posts = postDAO.getPostsPage(search, page);

        // 5) Кладём всё в запрос
        request.setAttribute("posts", posts);
        request.setAttribute("searchQuery", search);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // 6) Форвардим на JSP
        request.getRequestDispatcher("/index.jsp")
                .forward(request, response);
    }
}
