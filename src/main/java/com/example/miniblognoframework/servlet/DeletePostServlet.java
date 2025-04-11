package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.PostDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/delete-post")
public class DeletePostServlet extends HttpServlet {

    private final PostDAO postDAO = new PostDAO();

    // GET-запрос для удаления
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            int id = Integer.parseInt(idStr);
            postDAO.deletePost(id);
        }
        response.sendRedirect(request.getContextPath() + "/posts");
    }
}
