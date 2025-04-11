package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.PostDAO;
import com.example.miniblognoframework.model.Post;
import com.example.miniblognoframework.model.User; // убедись, что этот класс есть

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/add-post")
public class AddPostServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Проверяем, существует ли сессия и сохранён ли в ней объект пользователя
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // Если пользователь не аутентифицирован, перенаправляем его на страницу логина
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");

        String title = request.getParameter("title");
        String content = request.getParameter("content");

        // Создаем новый пост и связываем его с идентификатором пользователя
        Post post = new Post(title, content, user.getId());

        PostDAO dao = new PostDAO();
        dao.addPost(post);

        response.sendRedirect(request.getContextPath() + "/posts");
    }
}
