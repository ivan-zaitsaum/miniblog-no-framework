package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.UserDAO;
import com.example.miniblognoframework.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 6 * 1024 * 1024,
        maxRequestSize = 6 * 1024 * 1024
)
@WebServlet("/upload-avatar")
public class AvatarUploadServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {    // ← добавили ServletException

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");

        Part part = req.getPart("avatarFile");    // теперь OK
        if (part != null && part.getSize() > 0) {
            String submitted = part.getSubmittedFileName();
            String ext = submitted.substring(submitted.lastIndexOf('.'));
            String filename = "avatar_" + user.getId() + ext;

            File uploads = new File(getServletContext().getRealPath("/uploads"));
            if (!uploads.exists()) uploads.mkdirs();

            part.write(new File(uploads, filename).getAbsolutePath());

            // сохраняем путь в БД и в сессии
            userDAO.updateAvatar(user.getId(), filename);
            user.setAvatar(filename);
            session.setAttribute("user", user);
        }

        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}

