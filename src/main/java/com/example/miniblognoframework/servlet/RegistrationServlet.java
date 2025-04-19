package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.UserDAO;
import com.example.miniblognoframework.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/register")
public class RegistrationServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = new User(username, email, password, "User");
        userDAO.addUser(user);

        // Перенаправляем на страницу логина после регистрации
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
