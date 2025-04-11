package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.PostDAO;
import com.example.miniblognoframework.model.Post;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/edit-post")
public class EditPostServlet extends HttpServlet {

    private final PostDAO postDAO = new PostDAO();

    // GET: загрузка формы редактирования с данными поста
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            Post post = postDAO.getPostById(id);
            if (post != null) {
                request.setAttribute("post", post);
                request.getRequestDispatcher("/editPost.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/posts");
    }

    // POST: обработка обновлённого поста
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Получаем id поста
        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String content = request.getParameter("content");

        // Извлекаем старый пост из базы
        Post post = postDAO.getPostById(id);
        if (post != null) {
            // Обновляем только поля, которые изменились
            post.setTitle(title);
            post.setContent(content);

            // Сохраняем изменения в базе
            postDAO.updatePost(post);
        }

        // После обновления перенаправляем на список постов
        response.sendRedirect(request.getContextPath() + "/posts");
    }

}
