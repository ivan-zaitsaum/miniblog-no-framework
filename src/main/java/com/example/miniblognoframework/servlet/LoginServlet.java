package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.UserDAO;
import com.example.miniblognoframework.model.User;
import com.example.miniblognoframework.utils.JwtUtil;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // Показываем форму логина
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        User user = userDAO.authenticateUser(username, password);

        // Если логин не прошёл
        if (user == null) {
            // Если клиент ожидает JSON — вернуть JSON-ошибку
            String accept = req.getHeader("Accept");
            if (accept != null && accept.contains("application/json")) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.setContentType("application/json; charset=UTF-8");
                resp.getWriter().write("{\"error\":\"Invalid credentials\"}");
            } else {
                // Иначе — обычный редирект на форму с параметром ?error=1
                resp.sendRedirect(req.getContextPath() + "/login.jsp?error=1");
            }
            return;
        }

        // Успешная аутентификация
        String accept = req.getHeader("Accept");
        if (accept != null && accept.contains("application/json")) {
            // 1) JWT–логин: возвращаем токен в JSON
            String token = JwtUtil.generateToken(user.getUsername());
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.setContentType("application/json; charset=UTF-8");
            PrintWriter out = resp.getWriter();
            out.print("{\"token\":\"" + token + "\"}");
            out.flush();
        } else {
            // 2) Форма-логин: сохраняем в сессию и редиректим на /posts
            HttpSession session = req.getSession(true);
            session.setAttribute("user", user);
            resp.sendRedirect(req.getContextPath() + "/posts");
        }
    }
}
