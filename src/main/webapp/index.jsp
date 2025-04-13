<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<%@ page import="com.example.miniblognoframework.dao.CommentDAO" %>
<%@ page import="com.example.miniblognoframework.model.Comment" %>

<html>
<head>
    <title>Mini Blog</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .nav { overflow: auto; margin-bottom: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #336699; }
        #user-info { float: right; font-size: 14px; }
        .post { border: 1px solid #ccc; padding: 10px; margin-bottom: 10px; }
        .date { font-size: 12px; color: gray; }
    </style>
</head>
<body>
<div class="nav">
    <a href="<%= request.getContextPath() %>/posts">Home</a>
    <a href="<%= request.getContextPath() %>/form.jsp">Add Post</a>
    <%
        // Получаем текущего пользователя из сессии
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
    %>
    <a href="<%= request.getContextPath() %>/registration.jsp">Registration</a>
    <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
    <%  } else { %>
    <div id="user-info">
        Welcome, <strong><%= currentUser.getUsername() %></strong>!
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
    <% } %>
</div>

<h1>Mini Blog</h1>
<hr>

<%
    List<Post> posts = (List<Post>) request.getAttribute("posts");
    if (posts != null && !posts.isEmpty()) {
        for (Post post : posts) {
%>
<div class="post">
    <h2><%= post.getTitle() %></h2>
    <p><%= post.getContent() %></p>
    <small class="date">Created at: <%= post.getCreatedAt() %></small>
    <br>
    <small>Author: <%= post.getUsername() != null ? post.getUsername() : "Unknown" %></small>
    <br>

    <%-- Если текущий пользователь является автором поста, можно добавить кнопки Edit, Delete (как раньше) --%>
    <% if (currentUser != null && currentUser.getId() == post.getUserId()) { %>
    <a href="<%= request.getContextPath() %>/edit-post?id=<%= post.getId() %>">Edit</a> |
    <a href="<%= request.getContextPath() %>/delete-post?id=<%= post.getId() %>">Delete</a>
    <br>
    <% } %>

    <%-- Вывод комментариев для текущего поста --%>
    <%
        CommentDAO commentDAO = new CommentDAO();
        List<Comment> comments = commentDAO.getCommentsByPostId(post.getId());
        if (comments != null && !comments.isEmpty()) {
    %>
    <div class="comments">
        <h4>Comments:</h4>
        <%
            for (Comment c : comments) {
        %>
        <div class="comment">
            <p><%= c.getContent() %></p>
            <small>By <%= c.getUsername() != null ? c.getUsername() : "Unknown" %> at <%= c.getCreatedAt() %></small>
        </div>
        <%
            }
        %>
    </div>
    <%
        }
    %>

    <%-- Форма для добавления нового комментария, показывается только для залогиненного пользователя --%>
    <% if (currentUser != null) { %>
    <div class="comment-form">
        <form method="post" action="<%= request.getContextPath() %>/add-comment">
            <input type="hidden" name="postId" value="<%= post.getId() %>">
            <textarea name="comment" rows="2" cols="40" required placeholder="Your comment..."></textarea>
            <button type="submit">Submit Comment</button>
        </form>
    </div>
    <% } else { %>
    <p><a href="<%= request.getContextPath() %>/login.jsp">Login</a> to comment.</p>
    <% } %>
</div>
<hr>
<%
    }
} else {
%>
<p>No posts available.</p>
<%
    }
%>
</body>
</html>
