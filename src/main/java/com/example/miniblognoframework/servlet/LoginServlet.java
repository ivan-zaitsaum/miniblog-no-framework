package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.UserDAO;
import com.example.miniblognoframework.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.authenticateUser(username, password);
        if (user != null) {
            // Получаем сессию (создаём, если её нет)
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user); // сохраняем пользователя в сессии
            response.sendRedirect(request.getContextPath() + "/posts");
        } else {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
        }
    }

    // Для GET-запросов можно показывать страницу логина:
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
}
