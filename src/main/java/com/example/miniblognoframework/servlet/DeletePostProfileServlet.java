package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.PostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/delete-postp")
public class DeletePostProfileServlet extends HttpServlet {

    private final PostDAO postDAO = new PostDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null) {
            try {
                int postId = Integer.parseInt(idStr);
                postDAO.deletePost(postId);
            } catch (NumberFormatException e) {
                // можно залогировать неверный формат id
            }
        }
        response.sendRedirect(request.getContextPath() + "/profile");
    }
}
