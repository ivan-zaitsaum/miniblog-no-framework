<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>
<html>
<head>
  <title>Edit Post</title>
  <style>
    /* Общий фон и стили страницы */
    body {
      background-color: #808080; /* gray background */
      font-family: 'Courier New', monospace;
      color: #ffffff;
      margin: 0;
      padding: 20px;
    }
    /* Навигационный блок */
    .nav {
      margin-bottom: 20px;
    }
    .nav a {
      text-decoration: none;
      color: #00ff00;
      margin-right: 15px;
    }
    #header {
      width: 100%;
      background-color: #333333;
      padding: 10px;
      text-align: right;
      border-bottom: 1px solid #00ff00;
      margin-bottom: 30px;
    }
    #header a {
      color: #00ff00;
      text-decoration: none;
      margin-left: 15px;
    }
    /* Контейнер формы редактирования */
    .form-container {
      background-color: #2b2b2b; /* black background */
      border: 1px solid #00ff00;
      border-radius: 10px;
      padding: 20px;
      width: 400px;
      margin: 0 auto; /* center horizontally */
    }
    .form-container h1 {
      text-align: center;
      color: #00ff00;
      margin-bottom: 20px;
    }
    .form-container label {
      display: block;
      margin-bottom: 5px;
      color: #00ff00;
    }
    .form-container input[type="text"],
    .form-container textarea {
      width: 100%;
      padding: 8px;
      margin-bottom: 10px;
      border: 1px solid #00ff00;
      border-radius: 5px;
      background-color: #333333;
      color: #ffffff;
    }
    .form-container input[type="submit"] {
      width: 100%;
      padding: 10px;
      background-color: #00ff00;
      border: none;
      border-radius: 5px;
      font-weight: bold;
      color: #000000;
      cursor: pointer;
    }
    .back-link {
      text-align: center;
      margin-top: 20px;
    }
    .back-link a {
      color: #00ff00;
      text-decoration: none;
    }
  </style>
</head>
<body>
<!-- Navigation header -->
<div id="header">
  <a href="<%= request.getContextPath() %>/posts">Home</a>
  <a href="<%= request.getContextPath() %>/registration.jsp">Registration</a>
  <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
  <a href="<%= request.getContextPath() %>/logout">Logout</a>
</div>

<!-- Основной контейнер редактирования поста -->
<div class="form-container">
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

    <label for="title">Title:</label>
    <input type="text" id="title" name="title" value="<%= post.getTitle() %>" required>

    <label for="content">Content:</label>
    <textarea id="content" name="content" rows="5" required><%= post.getContent() %></textarea>

    <input type="submit" value="Save">
  </form>
  <%
    }
  %>
</div>

<div class="back-link">
  <p><a href="<%= request.getContextPath() %>/posts">Back to posts</a></p>
</div>
</body>
</html>
