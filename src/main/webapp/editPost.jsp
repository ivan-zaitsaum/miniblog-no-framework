<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  // Получаем текущего пользователя из request (AuthFilter)
  User currentUser = (User) request.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Edit Post</title>
  <!-- 1) Общий CSS для тем -->
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
    #header {
      margin-bottom: 20px;
      background-color: var(--card-bg);
      border-bottom: 1px solid var(--card-border);
      padding: 10px;
    }
    #header a {
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

  <!-- 2) Скрипт переключения темы -->
  <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>
<!-- 3) Кнопка-переключатель темы -->
<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<!-- Навигация/хедер -->
<div id="header">
  <a href="${pageContext.request.contextPath}/posts">Home</a>
  <c:choose>
    <c:when test="${currentUser == null}">
      <a href="${pageContext.request.contextPath}/registration.jsp">Registration</a>
      <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
    </c:when>
    <c:otherwise>
      <a href="${pageContext.request.contextPath}/add-post">Add Post</a>
      <a href="${pageContext.request.contextPath}/profile">Profile</a>
      <a href="${pageContext.request.contextPath}/logout">Logout</a>
      Welcome, <strong>${currentUser.username}</strong>
    </c:otherwise>
  </c:choose>
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
  <form action="${pageContext.request.contextPath}/edit-post" method="post">
    <input type="hidden" name="id" value="${post.id}"/>

    <label for="title">Title:</label>
    <input type="text" id="title" name="title" value="${post.title}" required/>

    <label for="content">Content:</label>
    <textarea id="content" name="content" rows="5" required>${post.content}</textarea>

    <input type="submit" value="Save"/>
  </form>
  <%
    }
  %>
</div>

<!-- Ссылка назад -->
<div class="back-link">
  <p><a href="${pageContext.request.contextPath}/posts">Back to posts</a></p>
</div>
</body>
</html>
