package com.example.miniblognoframework.filter;

import com.example.miniblognoframework.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebFilter(urlPatterns = {"/posts/*", "/addPost", "/editPost", "/deletePost", "/addComment"})
public class AuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            // неавторизованные — на страницу логина
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=" + request.getRequestURI());
            return;
        }

        // пример авторизации по роли для админ‑операций
        String path = request.getServletPath();
        if ((path.equals("/deletePost") || path.equals("/editPost")) && !"ADMIN".equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Недостаточно прав");
            return;
        }

        chain.doFilter(req, res);
    }
}
