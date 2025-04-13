<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Registration</title>
  <style>
    /* Общий стиль страницы */
    body {
      background-color: #808080; /* серый фон */
      font-family: 'Courier New', monospace;
      color: #ffffff;
      padding: 20px;
      margin: 0;
    }
    /* Навигационное меню */
    .nav {
      margin-bottom: 20px;
    }
    .nav a {
      text-decoration: none;
      color: #00ff00; /* ярко-зелёный */
      margin-right: 15px;
    }
    /* Стиль контейнера формы - черная карточка */
    .form-container {
      background-color: #2b2b2b; /* черный фон карточки */
      border: 1px solid #00ff00;
      border-radius: 10px;
      padding: 20px;
      width: 400px;
      margin: 50px auto; /* центрирование по горизонтали */
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
    .form-container input[type="email"],
    .form-container input[type="password"] {
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
<!-- Навигация -->
<div class="nav">
  <a href="<%= request.getContextPath() %>/posts">Main</a> |
  <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
</div>

<!-- Контейнер формы регистрации -->
<div class="form-container">
  <h1>User Registration</h1>
  <form action="<%= request.getContextPath() %>/register" method="post">
    <label for="username">Username:</label>
    <input type="text" id="username" name="username" required>

    <label for="email">Email:</label>
    <input type="email" id="email" name="email" required>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>

    <input type="submit" value="Register">
  </form>
  <p style="text-align: center;">Already registered? <a href="<%= request.getContextPath() %>/login.jsp" style="color: #00ff00;">Login</a></p>
</div>

<div class="back-link">
  <p><a href="<%= request.getContextPath() %>/posts">Back to Home Page</a></p>
</div>
</body>
</html>
