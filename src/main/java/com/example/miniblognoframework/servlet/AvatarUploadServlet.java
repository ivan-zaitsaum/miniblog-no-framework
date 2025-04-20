package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.UserDAO;
import com.example.miniblognoframework.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.*;
import java.nio.file.Paths;

@WebServlet("/upload-avatar")
@MultipartConfig(
        fileSizeThreshold = 1024*1024,   // 1MB
        maxFileSize       = 5*1024*1024, // 5MB
        maxRequestSize    = 6*1024*1024  // 6MB
)
public class AvatarUploadServlet extends HttpServlet {
    private UserDAO userDao = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1) Убедимся, что юзер залогинен
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath()+"/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");

        // 2) Определим реальный путь к папке /uploads в webapp
        String uploadsPath = req.getServletContext().getRealPath("/uploads");
        File uploadsDir = new File(uploadsPath);
        if (!uploadsDir.exists()) {
            uploadsDir.mkdirs();
        }

        // 3) Получим файл из формы
        Part filePart = req.getPart("avatarFile");
        if (filePart != null && filePart.getSize() > 0) {
            //оригинальное имя
            String submitted = Paths.get(filePart.getSubmittedFileName())
                    .getFileName().toString();
            //сгенерируем уникальное
            String filename = System.currentTimeMillis() + "_" + submitted;
            File dest = new File(uploadsDir, filename);

            //сохраним на диск
            try (InputStream in = filePart.getInputStream();
                 OutputStream out = new FileOutputStream(dest)) {
                in.transferTo(out);
            }

            // 4) Сохраним имя в БД и обновим сессию
            userDao.updateAvatar(user.getId(), filename);
            user.setAvatar(filename);
            session.setAttribute("user", user);
        }

        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}
