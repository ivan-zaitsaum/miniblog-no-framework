<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<%
  // Получаем текущего пользователя из request (AuthFilter)
  User currentUser = (User) request.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Login</title>

  <!-- 1) Общий CSS для тем -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

  <!-- 2) Локальные стили формы логина (теперь используют CSS-переменные) -->
  <style>
    /* контейнер логина */
    .login-container {
      background-color: var(--card-bg);
      border: 1px solid var(--card-border);
      border-radius: 10px;
      padding: 20px;
      width: 300px;
      margin: 50px auto;
    }
    .login-container h1 {
      text-align: center;
      color: var(--link-color);
      margin-bottom: 20px;
    }
    .login-container label {
      display: block;
      margin-bottom: 5px;
      color: var(--link-color);
    }
    .login-container input[type="text"],
    .login-container input[type="password"] {
      width: 100%;
      padding: 8px;
      margin-bottom: 10px;
      border: 1px solid var(--link-color);
      border-radius: 5px;
      background-color: var(--card-bg);
      color: var(--text-color);
    }
    .login-container input[type="submit"] {
      width: 100%;
      padding: 8px;
      background-color: var(--link-color);
      border: none;
      border-radius: 5px;
      font-weight: bold;
      color: var(--bg-color);
      cursor: pointer;
    }
    .login-container p {
      text-align: center;
    }
    /* навигация */
    .nav {
      margin-bottom: 20px;
      text-align: center;
    }
    .nav a {
      text-decoration: none;
      color: var(--link-color);
      margin: 0 10px;
    }
    /* Кнопка переключения темы */
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

  <!-- 3) Скрипт переключения темы -->
  <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>
<!-- 4) Кнопка-переключатель темы -->
<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<!-- Навигация -->
<div class="nav">
  <a href="${pageContext.request.contextPath}/posts">Main</a>
  <% if (currentUser == null) { %>
  <a href="${pageContext.request.contextPath}/registration.jsp">Registration</a>
  <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
  <% } else { %>
  <a href="${pageContext.request.contextPath}/add-post">Add Post</a>
  <a href="${pageContext.request.contextPath}/profile">Profile</a>
  <a href="${pageContext.request.contextPath}/logout">Logout</a>
  Welcome, <strong><%= currentUser.getUsername() %></strong>
  <% } %>
</div>

<!-- Форма логина -->
<div class="login-container">
  <h1>Login</h1>
  <% String error = request.getParameter("error"); %>
  <% if ("1".equals(error)) { %>
  <p style="color:red;">Invalid username or password.</p>
  <% } %>
  <form action="${pageContext.request.contextPath}/login" method="post">
    <label for="username">User name:</label>
    <input type="text" id="username" name="username" required>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>

    <input type="submit" value="Login">
  </form>
  <p>No account?
    <a href="${pageContext.request.contextPath}/registration.jsp">Registration</a>
  </p>
</div>
</body>
</html>
