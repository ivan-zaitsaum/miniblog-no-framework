<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Login</title>
  <style>
    body {
      font-family: 'Courier New', monospace;
      background-color: #808080; /* grey background */
      color: #ffffff;
      margin: 0;
      padding: 20px;
    }
    /* Navigation styles */
    .nav {
      margin-bottom: 20px;
    }
    .nav a {
      text-decoration: none;
      color: #00ff00;
      margin-right: 15px;
    }
    /* Стили для контейнера логина */
    .login-container {
      background-color: #2b2b2b; /* black card */
      border: 1px solid #444444;
      border-radius: 10px; /* rounded corners */
      padding: 20px;
      width: 300px;
      margin: 50px auto; /* center horizontally */
    }
    .login-container h1 {
      text-align: center;
      color: #00ff00;
      margin-bottom: 20px;
    }
    .login-container label {
      display: block;
      margin-bottom: 5px;
      color: #00ff00;
    }
    .login-container input[type="text"],
    .login-container input[type="password"] {
      width: 100%;
      padding: 8px;
      margin-bottom: 10px;
      border: 1px solid #00ff00;
      border-radius: 5px;
      background-color: #333333;
      color: #ffffff;
    }
    .login-container input[type="submit"] {
      width: 100%;
      padding: 8px;
      background-color: #00ff00;
      border: none;
      border-radius: 5px;
      font-weight: bold;
      color: #000000;
      cursor: pointer;
    }
    .login-container p {
      text-align: center;
    }
  </style>
</head>
<body>
<div class="nav">
  <a href="<%= request.getContextPath() %>/posts">Main</a> |
  <a href="<%= request.getContextPath() %>/registration.jsp">Registration</a>
</div>

<div class="login-container">
  <h1>Login</h1>
  <% String error = request.getParameter("error"); %>
  <% if ("1".equals(error)) { %>
  <p style="color:red; text-align: center;">Invalid username or password.</p>
  <% } %>
  <form action="<%= request.getContextPath() %>/login" method="post">
    <label for="username">User name:</label>
    <input type="text" id="username" name="username" required>

    <label for="password">Password:</label>
    <input type="password" id="password" name="password" required>

    <input type="submit" value="Login">
  </form>
  <p>No account? <a href="<%= request.getContextPath() %>/registration.jsp" style="color: #00ff00;">Registration</a></p>
</div>
</body>
</html>
