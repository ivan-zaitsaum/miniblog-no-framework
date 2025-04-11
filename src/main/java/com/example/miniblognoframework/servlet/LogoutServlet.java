package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.UserDAO;
import com.example.miniblognoframework.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;


@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate(); // уничтожаем сессию
        }
        // Перенаправляем пользователя на главную страницу или на страницу логина
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
