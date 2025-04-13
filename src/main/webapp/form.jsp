<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<html>
<head>
    <title>Add Post</title>
    <style>
        /* Общий фон страницы — серый */
        body {
            background-color: #808080;
            font-family: 'Courier New', monospace;
            padding: 20px;
            color: #ffffff;
            margin: 0;
        }
        /* Шапка (header) */
        #header {
            width: 100%;
            background-color: #333333;
            padding: 10px;
            text-align: right;
            border-bottom: 1px solid #00ff00;
            margin-bottom: 30px;
        }
        #header a {
            color: #00ff00;
            text-decoration: none;
            margin-left: 15px;
        }
        /* Контейнер формы - черная карточка */
        .form-container {
            background-color: #2b2b2b; /* черный фон */
            border: 1px solid #00ff00;  /* зелёная рамка */
            border-radius: 10px;        /* скругленные углы */
            padding: 20px;
            width: 400px;
            margin: 0 auto;             /* центрирование по горизонтали */
        }
        .form-container h1 {
            text-align: center;
            margin-bottom: 20px;
            color: #00ff00;
        }
        .form-container label {
            display: block;
            margin-bottom: 5px;
            color: #00ff00;
        }
        .form-container input[type="text"],
        .form-container textarea {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #00ff00;
            border-radius: 5px;
            background-color: #333333;
            color: #ffffff;
        }
        .form-container button {
            width: 100%;
            padding: 10px;
            background-color: #00ff00;
            border: none;
            border-radius: 5px;
            font-weight: bold;
            color: #000000;
            cursor: pointer;
        }
        /* Стиль для ссылки "Back to Home Page" */
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

<!-- Контейнер формы добавления поста -->
<div class="form-container">
    <h1>Add a New Post</h1>
    <form method="post" action="<%= request.getContextPath() %>/add-post">
        <label for="title">Title:</label>
        <input type="text" id="title" name="title" required>

        <label for="content">Content:</label>
        <textarea id="content" name="content" rows="5" required></textarea>

        <button type="submit">Submit</button>
    </form>
</div>

<div class="back-link">
    <p><a href="<%= request.getContextPath() %>/posts">Back to Home Page</a></p>
</div>
</body>
</html>
