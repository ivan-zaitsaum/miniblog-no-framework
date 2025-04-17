<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<html>
<head>
  <title>Edit Post</title>

  <!-- 1) Подключаем общий файл темы -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

  <style>
    /* ==== ВСЕ цвета через переменные ==== */

    body {
      background-color: var(--bg-color);
      color:            var(--text-color);
      margin: 0;
      padding: 20px;
      font-family: 'Courier New', monospace;
    }

    /* Навигация */
    .nav, #header {
      margin-bottom: 20px;
      background-color: var(--card-bg);
      border-bottom: 1px solid var(--card-border);
      padding: 10px;
    }
    .nav a, #header a {
      text-decoration: none;
      color: var(--link-color);
      margin-right: 15px;
    }

    /* Контейнер формы редактирования */
    .form-container {
      background-color: var(--card-bg);
      border: 1px solid var(--card-border);
      border-radius: 10px;
      padding: 20px;
      width: 400px;
      margin: 0 auto;
    }
    .form-container h1 {
      text-align: center;
      color: var(--link-color);
      margin-bottom: 20px;
    }
    .form-container label {
      display: block;
      margin-bottom: 5px;
      color: var(--link-color);
    }
    .form-container input[type="text"],
    .form-container textarea {
      width: 100%;
      padding: 8px;
      margin-bottom: 10px;
      border: 1px solid var(--link-color);
      border-radius: 5px;
      background-color: var(--bg-color);
      color: var(--text-color);
    }
    .form-container input[type="submit"] {
      width: 100%;
      padding: 10px;
      background-color: var(--link-color);
      border: none;
      border-radius: 5px;
      font-weight: bold;
      color: var(--bg-color);
      cursor: pointer;
    }

    /* Ссылка назад */
    .back-link {
      text-align: center;
      margin-top: 20px;
    }
    .back-link a {
      color: var(--link-color);
      text-decoration: none;
    }

    /* ==== Кнопка переключения темы ==== */
    #theme-toggle {
      position: fixed;
      top: 10px;
      right: 10px;
      background: var(--link-color);
      color: var(--bg-color);
      border: none;
      padding: 6px 12px;
      border-radius: 4px;
      cursor: pointer;
      z-index: 1000;
    }
  </style>

  <!-- 2) Подключаем скрипт для темы -->
  <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>
<!-- 3) Кнопка-переключатель темы -->
<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<!-- Навигация/хедер -->
<div id="header">
  <a href="<%= request.getContextPath() %>/posts">Home</a>
  <a href="<%= request.getContextPath() %>/registration.jsp">Registration</a>
  <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
  <a href="<%= request.getContextPath() %>/logout">Logout</a>
</div>

<!-- Форма редактирования поста -->
<div class="form-container">
  <%
    Post post = (Post) request.getAttribute("post");
    if (post == null) {
  %>
  <p style="color: var(--text-faint);">Post not found.</p>
  <%
  } else {
  %>
  <h1>Edit Post</h1>
  <form action="<%= request.getContextPath() %>/edit-post" method="post">
    <input type="hidden" name="id" value="<%= post.getId() %>">

    <label for="title">Title:</label>
    <input type="text" id="title" name="title" value="<%= post.getTitle() %>" required>

    <label for="content">Content:</label>
    <textarea id="content" name="content" rows="5" required>
<%= post.getContent() %></textarea>

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
