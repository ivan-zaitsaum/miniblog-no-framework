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
        /* Общий фон страницы — серый */
        body {
            font-family: 'Courier New', monospace;  /* шрифт, напоминающий код */
            background-color: #808080;  /* серый фон */
            color: #ffffff;             /* по умолчанию белый текст */
            padding: 20px;
            margin: 0;
        }

        /* Стили для навигации */
        .nav {
            margin-bottom: 20px;
        }
        .nav a {
            text-decoration: none;
            color: #00ff00; /* ярко-зелёный для ссылок */
            margin-right: 15px;
        }
        #user-info {
            float: right;
            font-size: 14px;
        }

        /* Стили карточки поста */
        .post {
            background-color: #2b2b2b; /* чёрный фон карточки */
            border: 1px solid #444444;
            border-radius: 10px;         /* скруглённые углы */
            padding: 15px;
            margin-bottom: 15px;
        }

        .post h2 {
            color: #00ff00;             /* ярко-зелёный заголовок */
            margin-bottom: 10px;
        }

        .post p {
            color: #d3d3d3;             /* светло-серый текст для контента */
        }

        .date {
            font-size: 12px;
            color: #aaaaaa;             /* еще более светлый оттенок для даты */
        }

        /* Стили для комментариев */
        .comments {
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px dashed #444444;
        }
        .comment {
            margin-top: 5px;
            padding-left: 10px;
            border-left: 3px solid #00ff00;
        }
        .comment-author {
            font-weight: bold;
            color: #00ff00;
        }
        .comment-time {
            font-size: 12px;
            color: #bbbbbb;
        }

        /* Стили для формы комментариев */
        .comment-form {
            margin-top: 10px;
        }
    </style>
</head>
<body>
<!-- Навигационная панель -->
<div class="nav">
    <a href="<%= request.getContextPath() %>/posts">Home</a>
    <a href="<%= request.getContextPath() %>/form.jsp">Add Post</a>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
    %>
    <a href="<%= request.getContextPath() %>/registration.jsp">Registration</a>
    <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
    <%
    } else {
    %>
    <div id="user-info">
        Welcome, <strong><%= currentUser.getUsername() %></strong>!
        <a href="<%= request.getContextPath() %>/logout">Logout</a>
    </div>
    <%
        }
    %>
</div>

<h1>Mini Blog</h1>
<hr>

<%
    List<Post> posts = (List<Post>) request.getAttribute("posts");
    if (posts != null && !posts.isEmpty()) {
        CommentDAO commentDAO = new CommentDAO();
        for (Post post : posts) {
%>
<div class="post">
    <h2><%= post.getTitle() %></h2>
    <p><%= post.getContent() %></p>
    <p class="date">
        Created at: <%= post.getCreatedAt() %> &nbsp;&nbsp;|&nbsp;&nbsp;
        Author: <%= post.getUsername() != null ? post.getUsername() : "Unknown" %>
    </p>

    <%-- Если текущий пользователь является автором, можно добавить кнопки Edit, Delete --%>
    <% if (currentUser != null && currentUser.getId() == post.getUserId()) { %>
    <a href="<%= request.getContextPath() %>/edit-post?id=<%= post.getId() %>" style="color: #00ff00;">Edit</a> |
    <a href="<%= request.getContextPath() %>/delete-post?id=<%= post.getId() %>" style="color: #00ff00;">Delete</a>
    <% } %>

    <!-- Вывод комментариев для данного поста -->
    <%
        List<Comment> comments = commentDAO.getCommentsByPostId(post.getId());
        if (comments != null && !comments.isEmpty()) {
    %>
    <div class="comments">
        <h5 style="color: #00ff00;">Comments:</h5>
        <ul style="list-style: none; padding-left: 0;">
            <%
                for (Comment comment : comments) {
            %>
            <li class="comment">
                <p><%= comment.getContent() %></p>
                <small class="comment-time">
                    By <span class="comment-author"><%= comment.getUsername() != null ? comment.getUsername() : "Unknown" %></span>
                    at <%= comment.getCreatedAt() %>
                </small>
            </li>
            <%
                }
            %>
        </ul>
    </div>
    <%
        }
    %>

    <%-- Форма для добавления нового комментария (только для залогиненных пользователей) --%>
    <% if (currentUser != null) { %>
    <div class="comment-form">
        <form method="post" action="<%= request.getContextPath() %>/add-comment">
            <input type="hidden" name="postId" value="<%= post.getId() %>">
            <textarea name="comment" rows="2" cols="50" required placeholder="Enter your comment..." style="background-color: #333; color: #fff; border: 1px solid #00ff00; border-radius: 5px; padding: 5px;"></textarea>
            <br><br>
            <button type="submit" style="background-color: #00ff00; color: #000; border: none; padding: 5px 10px; border-radius: 5px;">Submit Comment</button>
        </form>
    </div>
    <% } else { %>
    <p><a href="<%= request.getContextPath() %>/login.jsp" style="color: #00ff00;">Log in</a> to comment.</p>
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
