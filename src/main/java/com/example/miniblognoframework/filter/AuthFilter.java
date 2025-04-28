package com.example.miniblognoframework.filter;

import com.example.miniblognoframework.dao.UserDAO;
import com.example.miniblognoframework.model.User;
import com.example.miniblognoframework.utils.JwtUtil;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthFilter implements Filter {

    private UserDAO userDAO;

    @Override
    public void init(FilterConfig filterConfig) {
        userDAO = new UserDAO();
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest  request  = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        User user = null;

        // 1) Попытка JWT
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            try {
                String username = JwtUtil.validateToken(authHeader.substring(7));
                user = userDAO.getUserByUsername(username);
            } catch (JwtException ignored) { }
        }

        // 2) Если не получилось — пробуем сессию
        if (user == null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                user = (User) session.getAttribute("user");
            }
        }

        if (user != null) {
            // кладём сразу объект User в request
            request.setAttribute("user", user);
            chain.doFilter(req, res);
            return;
        }

        // 3) Не авторизован ни через JWT, ни через сессию
        if ("GET".equalsIgnoreCase(request.getMethod())) {
            // перенаправляем на форму
            response.sendRedirect(request.getContextPath()
                    + "/login.jsp?redirect=" + request.getRequestURI());
        } else {
            // JSON-ответ для Ajax/Fetch
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().write("{\"error\":\"Unauthorized\"}");
        }
    }

    @Override
    public void destroy() { }
}
