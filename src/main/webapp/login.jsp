<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Вход</title>
</head>
<body>
<div class="nav">
  <a href="<%= request.getContextPath() %>/posts">Main</a> |
  <a href="<%= request.getContextPath() %>/registration.jsp">Registration</a>
</div>
<h1>Вход в систему</h1>
<% String error = request.getParameter("error"); %>
<% if ("1".equals(error)) { %>
<p style="color:red;">Invalid username or password.</p>
<% } %>
<form action="<%= request.getContextPath() %>/login" method="post">
  <label>User name:</label><br>
  <input type="text" name="username" required><br><br>

  <label>Password:</label><br>
  <input type="password" name="password" required><br><br>

  <input type="submit" value="Войти">
</form>
<p>No account? <a href="<%= request.getContextPath() %>/registration.jsp">Registration</a></p>
</body>
</html>
