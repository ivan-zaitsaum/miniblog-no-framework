package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.CommentDAO;
import com.example.miniblognoframework.model.Comment;
import com.example.miniblognoframework.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/add-comment")
public class AddCommentServlet extends HttpServlet {

    private final CommentDAO commentDAO = new CommentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Проверяем, что пользователь залогинен
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");

        // Получаем параметры формы
        String commentContent = request.getParameter("comment");
        int postId = Integer.parseInt(request.getParameter("postId"));

        // Создаем новый комментарий
        Comment comment = new Comment(postId, user.getId(), commentContent);

        commentDAO.addComment(comment);

        // Перенаправляем обратно на главную страницу (или на страницу просмотра поста)
        response.sendRedirect(request.getContextPath() + "/posts");
    }
}
