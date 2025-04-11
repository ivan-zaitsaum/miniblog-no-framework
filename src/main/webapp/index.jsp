<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>
<html>
<head>
    <title>Mini Blog</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .nav a { margin-right: 15px; text-decoration: none; color: #336699; }
        .post { border: 1px solid #ccc; padding: 10px; margin-bottom: 10px; }
        .date { font-size: 12px; color: gray; }
    </style>
</head>
<body>
<div class="nav">
    <a href="<%= request.getContextPath() %>/posts">Home</a>
    <a href="<%= request.getContextPath() %>/form.jsp">Add Post</a>
    <a href="<%= request.getContextPath() %>/registration.jsp">Registration</a>
    <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
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
    <%-- Adding author information --%>
    <br>
    <small>Author: <%= post.getUsername() != null ? post.getUsername() : "Unknown" %></small>
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
