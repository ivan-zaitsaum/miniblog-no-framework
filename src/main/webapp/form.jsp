<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<html>
<head>
    <title>Add Post</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        #header {
            width: 100%;
            background: #f2f2f2;
            padding: 10px;
            text-align: right;
        }
        .form-container {
            margin-top: 20px;
        }
    </style>
</head>
<body>
<!-- Header с информацией о пользователе -->
<div id="header">
    <%
        User user = (User) session.getAttribute("user");
        if (user != null) {
    %>
    Welcome, <strong><%= user.getUsername() %></strong>!
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
    <%
    } else {
    %>
    <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
    <a href="<%= request.getContextPath() %>/registration.jsp">Register</a>
    <%
        }
    %>
</div>

<h1>Add a New Post</h1>
<div class="form-container">
    <form method="post" action="<%= request.getContextPath() %>/add-post">
        <label for="title">Title:</label><br>
        <input type="text" id="title" name="title" required><br><br>

        <label for="content">Content:</label><br>
        <textarea id="content" name="content" rows="5" cols="30" required></textarea><br><br>

        <button type="submit">Submit</button>
    </form>
</div>

<p><a href="<%= request.getContextPath() %>/posts">Back to Home Page</a></p>
</body>
</html>
