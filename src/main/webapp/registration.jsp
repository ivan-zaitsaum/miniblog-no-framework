<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>User Registration</title>

  <!-- 1) Общий CSS для тем -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

  <!-- 2) Локальные стили формы регистрации -->
  <style>
    body {
      margin: 0; padding: 20px;
      background-color: var(--bg-color);
      color: var(--text-color);
      font-family: 'Courier New', monospace;
    }
    .nav {
      margin-bottom: 20px;
      text-align: center;
    }
    .nav a {
      text-decoration: none;
      color: var(--link-color);
      margin: 0 10px;
    }
    .form-container {
      background-color: var(--card-bg);
      border: 1px solid var(--link-color);
      border-radius: 10px;
      padding: 20px;
      width: 400px;
      margin: 50px auto;
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
    .form-container input[type="email"],
    .form-container input[type="password"] {
      width: 100%;
      padding: 8px;
      margin-bottom: 10px;
      border: 1px solid var(--link-color);
      border-radius: 5px;
      background-color: var(--card-bg);
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
    .back-link {
      text-align: center;
      margin-top: 20px;
    }
    .back-link a {
      color: var(--link-color);
      text-decoration: none;
    }
    /* Кнопка переключения темы */
    #theme-toggle {
      position: fixed;
      top: 10px; right: 10px;
      background: var(--link-color);
      color: var(--bg-color);
      border: none;
      padding: 6px 12px;
      border-radius: 4px;
      cursor: pointer;
      z-index: 1000;
    }
  </style>

  <!-- 3) Скрипт переключения темы -->
  <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>
<!-- 4) Кнопка-переключатель темы -->
<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<%-- Получаем user из сессии, если залогинен --%>
<%
  User currentUser = (User) session.getAttribute("user");
%>

<!-- Навигация -->
<div class="nav">
  <a href="${pageContext.request.contextPath}/posts">Main</a>
  <% if (currentUser == null) { %>
  <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
  <a href="${pageContext.request.contextPath}/register">Register</a>
  <% } else { %>
  <a href="${pageContext.request.contextPath}/add-post">Add Post</a>
  <a href="${pageContext.request.contextPath}/profile">Profile</a>
  <a href="${pageContext.request.contextPath}/logout">Logout</a>
  &nbsp;Welcome, <strong><%= currentUser.getUsername() %></strong>
  <% } %>
</div>

<!-- Форма регистрации -->
<div class="form-container">
  <h1>User Registration</h1>
  <form action="${pageContext.request.contextPath}/register" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required />

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required />

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required />

    <input type="submit" value="Register" />
  </form>
  <p style="text-align:center;">
    Already registered?
    <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
  </p>
</div>

<div class="back-link">
  <p>
    <a href="${pageContext.request.contextPath}/posts">Back to Home Page</a>
  </p>
</div>
</body>
</html>
