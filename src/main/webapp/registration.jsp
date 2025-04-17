<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Registration</title>

  <!-- 1) Общий CSS для тем -->
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

  <!-- 2) Локальные стили формы регистрации (используют CSS-переменные) -->
  <style>
    body {
      margin: 0; padding: 20px;
      background-color: var(--bg-color);
      color: var(--text-color);
      font-family: 'Courier New', monospace;
    }
    .nav {
      margin-bottom: 20px;
    }
    .nav a {
      text-decoration: none;
      color: var(--link-color);
      margin-right: 15px;
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

  <!-- 3) Скрипт для переключения темы -->
  <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>
<!-- 4) Кнопка-переключатель темы -->
<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<!-- Навигация -->
<div class="nav">
  <a href="<%= request.getContextPath() %>/posts">Main</a> |
  <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
</div>

<!-- Форма регистрации -->
<div class="form-container">
  <h1>User Registration</h1>
  <form action="<%= request.getContextPath() %>/register" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username"   name="username" required>

    <label for="email">Email:</label>
    <input type="email" id="email"      name="email"    required>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>

    <input type="submit" value="Register">
  </form>
  <p style="text-align:center;">
    Already registered?
    <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
  </p>
</div>

<div class="back-link">
  <p>
    <a href="<%= request.getContextPath() %>/posts">Back to Home Page</a>
  </p>
</div>
</body>
</html>
