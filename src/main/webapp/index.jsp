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
        /* === CSS‑переменные для светлой/тёмной темы === */
        :root {
            --bg-color: #808080;
            --text-color: #ffffff;
            --nav-bg:    #2b2b2b;
            --link-color:#00ff00;
            --post-bg:   #2b2b2b;
            --input-bg:  #333333;
        }
        .dark-theme {
            --bg-color: #222222;
            --text-color: #eeeeee;
            --nav-bg:    #1b1b1b;
            --link-color:#66ccff;
            --post-bg:   #2a2a2a;
            --input-bg:  #333333;
        }

        body {
            background-color: var(--bg-color);
            color:            var(--text-color);
            font-family: 'Courier New', monospace;
            margin: 0; padding: 20px;
        }
        .nav {
            background: var(--nav-bg);
            padding: 10px;
            margin-bottom: 20px;
        }
        .nav a, .nav button {
            color: var(--link-color);
            text-decoration: none;
            margin-right: 15px;
        }
        #user-info { float: right; font-size: 14px; }

        /* Поисковая панель */
        .search-bar {
            margin: 20px 0;
        }
        .search-bar input[type="text"] {
            padding: 5px; width: 200px;
            background: var(--input-bg);
            color: var(--text-color);
            border: 1px solid var(--link-color);
            border-radius: 4px;
        }
        .search-bar button {
            padding: 5px 10px;
            background: var(--link-color);
            color: #000;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn-all {
            padding: 6px 12px;
            background: var(--link-color);
            color: #000;
            border-radius: 4px;
            border: none;
            cursor: pointer;
            margin-left: 10px;
        }

        /* Карточка поста */
        .post {
            background: var(--post-bg);
            border: 1px solid #444;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 15px;
        }
        .post h2 {
            color: var(--link-color);
            margin-bottom: 10px;
        }
        .post p { color: #d3d3d3; }
        .date {
            font-size: 12px;
            color: #aaaaaa;
        }

        /* Комментарии */
        .comments {
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px dashed #444;
        }
        .comment {
            margin-top: 5px;
            padding-left: 10px;
            border-left: 3px solid var(--link-color);
        }
        .comment-author { font-weight: bold; color: var(--link-color); }
        .comment-time { font-size: 12px; color: #bbbbbb; }
        .comment-form {
            margin-top: 10px;
        }

        /* Тёмная/светлая тема кнопка */
        #theme-toggle {
            padding: 4px 8px;
            background: none;
            border: 1px solid var(--link-color);
            border-radius: 4px;
            cursor: pointer;
        }
    </style>
</head>
<body>
<!-- Навигация -->
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
    <!-- Кнопка переключения темы -->
    <button id="theme-toggle">🌙/☀️</button>
</div>

<h1>Mini Blog</h1>
<hr>

<!-- Поисковая форма и кнопка All Posts -->
<div class="search-bar">
    <form action="<%= request.getContextPath() %>/posts" method="get" style="display:inline-block;">
        <input type="text" name="q" placeholder="Search..."
               value="<%= request.getAttribute("searchQuery")!=null
                          ? request.getAttribute("searchQuery") : "" %>"/>
        <button type="submit">Search</button>
    </form>
    <form action="<%= request.getContextPath() %>/posts" method="get" style="display:inline-block;">
        <button type="submit" class="btn-all">All Posts</button>
    </form>
</div>

<%
    List<Post> posts = (List<Post>) request.getAttribute("posts");
    CommentDAO commentDAO = new CommentDAO();
    if (posts != null && !posts.isEmpty()) {
        for (Post post : posts) {
%>
<div class="post">
    <h2><%= post.getTitle() %></h2>
    <p><%= post.getContent() %></p>
    <p class="date">
        Created at: <%= post.getCreatedAt() %>
        &nbsp;|&nbsp;
        Author: <%= post.getUsername()!=null ? post.getUsername() : "Unknown" %>
    </p>
    <% if (currentUser!=null && currentUser.getId()==post.getUserId()) { %>
    <a href="<%=request.getContextPath()%>/edit-post?id=<%=post.getId()%>"
       style="color:var(--link-color);">Edit</a> |
    <a href="<%=request.getContextPath()%>/delete-post?id=<%=post.getId()%>"
       style="color:var(--link-color);">Delete</a>
    <% } %>

    <%
        List<Comment> comments = commentDAO.getCommentsByPostId(post.getId());
        if (comments!=null && !comments.isEmpty()) {
    %>
    <div class="comments">
        <h5 style="color:var(--link-color);">Comments:</h5>
        <ul style="list-style:none; padding:0;">
            <% for (Comment c : comments) { %>
            <li class="comment">
                <p><%= c.getContent() %></p>
                <small class="comment-time">
                    By <span class="comment-author">
                               <%= c.getUsername()!=null ? c.getUsername() : "Unknown" %>
                             </span>
                    at <%= c.getCreatedAt() %>
                </small>
            </li>
            <% } %>
        </ul>
    </div>
    <% } %>

    <% if (currentUser!=null) { %>
    <div class="comment-form">
        <form method="post" action="<%= request.getContextPath() %>/add-comment">
            <input type="hidden" name="postId" value="<%=post.getId()%>">
            <textarea name="comment" rows="2" cols="50" required
                      placeholder="Enter your comment..."
                      style="background:var(--input-bg); color:var(--text-color);
                                 border:1px solid var(--link-color);
                                 border-radius:5px; padding:5px;"></textarea><br><br>
            <button type="submit"
                    style="background:var(--link-color); color:#000;
                               border:none; padding:5px 10px; border-radius:5px;">
                Submit Comment
            </button>
        </form>
    </div>
    <% } else { %>
    <p>
        <a href="<%= request.getContextPath() %>/login.jsp"
           style="color:var(--link-color);">Log in</a> to comment.
    </p>
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

<!-- Скрипт переключения темы -->
<script>
    (function(){
        const KEY = 'theme', DARK = 'dark-theme';
        const btn  = document.getElementById('theme-toggle');
        const body = document.body;
        let theme = localStorage.getItem(KEY)
            || (matchMedia('(prefers-color-scheme: dark)').matches
                ? 'dark' : 'light');
        if(theme==='dark') body.classList.add(DARK);
        function updateBtn(){
            btn.textContent = theme==='dark' ? '☀️ Light' : '🌙 Dark';
        }
        function toggle(){
            body.classList.toggle(DARK);
            theme = body.classList.contains(DARK) ? 'dark' : 'light';
            localStorage.setItem(KEY, theme);
            updateBtn();
        }
        btn.addEventListener('click', toggle);
        updateBtn();
    })();
</script>
</body>
</html>
