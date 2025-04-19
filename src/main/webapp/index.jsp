<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<%@ page import="com.example.miniblognoframework.dao.CommentDAO" %>
<%@ page import="com.example.miniblognoframework.model.Comment" %>
<html>
<head>
    <title>Mini Blog</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
    <style>
        body { font-family: 'Courier New', monospace; background-color: var(--bg-color); color: var(--text-color); padding: 20px; margin: 0; }
        .nav { margin-bottom: 20px; }
        .nav a { text-decoration: none; color: var(--link-color); margin-right: 15px; }
        #user-info { float: right; font-size: 14px; }
        .search-bar { margin: 20px 0; }
        .search-bar input { padding: 5px; width: 200px; border: 1px solid var(--link-color); border-radius: 4px; background: var(--card-bg); color: var(--text-color); }
        .search-bar button { padding: 5px 10px; background: var(--link-color); color: var(--bg-color); border: none; border-radius: 4px; }
        .post { background-color: var(--card-bg); border: 1px solid var(--border-color); border-radius: 10px; padding: 15px; margin-bottom: 15px; }
        .post h2 { color: var(--link-color); margin-bottom: 10px; }
        .post p { color: var(--text-muted); }
        .date { font-size: 12px; color: var(--text-faint); }
        .comments { margin-top: 10px; padding-top: 10px; border-top: 1px dashed var(--border-color); }
        .comment { margin-top: 5px; padding-left: 10px; border-left: 3px solid var(--link-color); }
        .comment-author { font-weight: bold; color: var(--link-color); }
        .comment-time { font-size: 12px; color: var(--text-faint); }
        .comment-form { margin-top: 10px; }
        .btn-all { display: inline-block; padding: 6px 12px; background-color: var(--link-color); color: var(--bg-color); text-decoration: none; border-radius: 4px; margin-left: 10px; }
        #theme-toggle { position: fixed; top: 10px; right: 10px; background: var(--link-color); color: var(--bg-color); border: none; padding: 6px 12px; border-radius: 4px; cursor: pointer; z-index: 1000; }
        .pagination a { margin: 0 4px; text-decoration: none; }
        .pagination a.active { font-weight: bold; }
    </style>
    <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>
<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<div class="nav">
    <a href="${pageContext.request.contextPath}/posts">Home</a>
    <a href="${pageContext.request.contextPath}/add-post">Add Post</a>
    <%
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
    %>
    <a href="${pageContext.request.contextPath}/registration.jsp">Registration</a>
    <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
    <%
    } else {
    %>
    Welcome, <strong><%= currentUser.getUsername() %></strong>!
    <a href="${pageContext.request.contextPath}/logout">Logout</a>
    <%
        }
    %>
</div>

<h1>Mini Blog</h1>
<hr>

<div class="search-bar">
    <form action="${pageContext.request.contextPath}/posts" method="get" style="display:inline-block;">
        <input type="text" name="q" placeholder="Search..."
               value="${request.getAttribute("searchQuery") != null ? request.getAttribute("searchQuery") : ""}"/>
        <button type="submit">Search</button>
    </form>
    <a href="${pageContext.request.contextPath}/posts" class="btn-all">All Posts</a>
</div>

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
        Created at: <%= post.getCreatedAt() %> |
        Author: <%= post.getUsername() != null ? post.getUsername() : "Unknown" %>
    </p>
    <% if (currentUser != null && currentUser.getId() == post.getUserId()) { %>
    <a href="${pageContext.request.contextPath}/edit-post?id=<%= post.getId() %>"
       style="color:var(--link-color)">Edit</a> |
    <a href="${pageContext.request.contextPath}/delete-post?id=<%= post.getId() %>"
       style="color:var(--link-color)">Delete</a>
    <% } %>

    <%
        List<Comment> comments = commentDAO.getCommentsByPostId(post.getId());
        if (comments != null && !comments.isEmpty()) {
    %>
    <div class="comments">
        <h5 style="color:var(--link-color)">Comments:</h5>
        <ul style="list-style:none; padding-left:0;">
            <%
                for (Comment c : comments) {
            %>
            <li class="comment">
                <p><%= c.getContent() %></p>
                <small class="comment-time">
                    By <span class="comment-author">
                        <%= c.getUsername() != null ? c.getUsername() : "Unknown" %>
                    </span> at <%= c.getCreatedAt() %>
                </small>
            </li>
            <%
                }
            %>
        </ul>
    </div>
    <% } %>

    <% if (currentUser != null) { %>
    <div class="comment-form">
        <form method="post" action="${pageContext.request.contextPath}/add-comment">
            <input type="hidden" name="postId" value="<%= post.getId() %>">
            <textarea name="comment" rows="2" cols="50" required
                      placeholder="Enter your comment..."
                      style="background:var(--card-bg);color:var(--text-color);
                             border:1px solid var(--link-color);
                             border-radius:5px;padding:5px;"></textarea>
            <br><br>
            <button type="submit" style="background:var(--link-color);
                                              color:var(--bg-color);
                                              border:none;padding:5px 10px;
                                              border-radius:5px;">
                Submit Comment
            </button>
        </form>
    </div>
    <% } else { %>
    <p><a href="${pageContext.request.contextPath}/login.jsp"
          style="color:var(--link-color)">Log in</a> to comment.</p>
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

<%  // Блок пагинации %>
<%
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages  = (Integer) request.getAttribute("totalPages");
    String  searchQuery = (String) request.getAttribute("searchQuery");
    if (totalPages != null && totalPages > 1) {
%>
<div class="pagination" style="margin-top:20px;">
    <%
        for (int i = 1; i <= totalPages; i++) {
            String url = request.getContextPath() + "/posts?page=" + i;
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                url += "&q=" + URLEncoder.encode(searchQuery, "UTF-8");
            }
            String cls = (i == currentPage) ? "active" : "";
    %>
    <a href="<%= url %>" class="<%= cls %>"
       style="margin:0 4px;<%= cls.equals("active") ? "font-weight:bold;" : "" %>">
        <%= i %>
    </a>
    <%
        }
    %>
</div>
<%
    }
%>

</body>
</html>
