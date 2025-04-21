package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.UserDAO;
import com.example.miniblognoframework.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 1) Проверяем, что в сессии есть user
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");

        // 2) Читаем новое имя из формы
        req.setCharacterEncoding("UTF-8");
        String newUsername = req.getParameter("username");
        if (newUsername == null || newUsername.isBlank()) {
            // можно добавить flash‑сообщение об ошибке, но для простоты — редирект
            resp.sendRedirect(req.getContextPath() + "/profile?error=empty");
            return;
        }

        // 3) Обновляем в БД и в сессии
        userDAO.updateUsername(user.getId(), newUsername);
        user.setUsername(newUsername);
        session.setAttribute("user", user);

        // 4) Возвращаемся обратно на профиль
        resp.sendRedirect(req.getContextPath() + "/profile?success=1");
    }
}
