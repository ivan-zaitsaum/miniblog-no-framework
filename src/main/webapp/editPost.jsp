<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>
<html>
<head>
  <title>Edit Post</title>
</head>
<body>
<%
  Post post = (Post) request.getAttribute("post");
  if (post == null) {
%>
<p>Post not found.</p>
<%
} else {
%>
<h1>Edit Post</h1>
<form action="<%= request.getContextPath() %>/edit-post" method="post">
  <input type="hidden" name="id" value="<%= post.getId() %>">
  <label for="title">Title:</label><br>
  <input type="text" id="title" name="title" value="<%= post.getTitle() %>" required><br><br>
  <label for="content">Content:</label><br>
  <textarea id="content" name="content" rows="5" cols="40" required><%= post.getContent() %></textarea><br><br>
  <input type="submit" value="Save">
</form>
<%
  }
%>
<br>
<a href="<%= request.getContextPath() %>/posts">Back to posts</a>
</body>
</html>
