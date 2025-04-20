package com.example.miniblognoframework.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;

@WebServlet("/userfiles/*")
public class UserFilesServlet extends HttpServlet {
    // сюда указываем внешнюю папку
    private static final String BASE_DIR = "C:\\Users\\tutom\\Desktop\\diplom\\BPP\\MiniBlogNoFramework\\uploads";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // получим остаток URL после /userfiles/, например "/1234_image.png"
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        File file = new File(BASE_DIR, path.substring(1));
        if (!file.exists() || !file.isFile()) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        // простой миметайп
        String mime = getServletContext().getMimeType(file.getName());
        if (mime == null) mime = "application/octet-stream";
        resp.setContentType(mime);
        resp.setContentLengthLong(file.length());
        try (var in = new FileInputStream(file);
             var out = resp.getOutputStream()) {
            in.transferTo(out);
        }
    }
}
