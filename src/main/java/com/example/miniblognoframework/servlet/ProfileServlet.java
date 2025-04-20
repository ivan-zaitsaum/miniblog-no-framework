package com.example.miniblognoframework.servlet;

import com.example.miniblognoframework.dao.PostDAO;
import com.example.miniblognoframework.model.Post;
import com.example.miniblognoframework.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private PostDAO postDAO;

    @Override
    public void init() {
        postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        User user = (User) session.getAttribute("user");
        // загружаем его посты
        List<Post> myPosts = postDAO.getPostsByUserId(user.getId());
        req.setAttribute("myPosts", myPosts);
        req.getRequestDispatcher("/WEB-INF/profile.jsp")
                .forward(req, resp);
    }
}
