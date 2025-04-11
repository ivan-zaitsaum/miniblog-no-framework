<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Registration</title>
</head>
<body>
<div class="nav">
  <a href="<%= request.getContextPath() %>/posts">Main</a> |
  <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
</div>
<h1>User Registration</h1>
<form action="<%= request.getContextPath() %>/register" method="post">
  <label>Username::</label><br>
  <input type="text" name="username" required><br><br>

  <label>Email:</label><br>
  <input type="email" name="email" required><br><br>

  <label>Password:</label><br>
  <input type="password" name="password" required><br><br>

  <input type="submit" value="Register">
</form>
<p>Already registered <a href="<%= request.getContextPath() %>/login.jsp">Login</a></p>
</body>
</html>
