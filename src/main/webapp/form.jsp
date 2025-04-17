<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<html>
<head>
    <title>Add Post</title>

    <!-- 1) Общий CSS для тем -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

    <!-- 2) Локальные стили формы, теперь на переменных -->
    <style>
        body {
            background-color: var(--bg-color);
            color:            var(--text-color);
            font-family: 'Courier New', monospace;
            padding: 20px;
            margin: 0;
        }
        #header {
            width: 100%;
            background-color: var(--nav-bg);
            padding: 10px;
            text-align: right;
            border-bottom: 1px solid var(--link-color);
            margin-bottom: 30px;
        }
        #header a {
            color: var(--link-color);
            text-decoration: none;
            margin-left: 15px;
        }
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
            margin-bottom: 20px;
            color: var(--link-color);
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
            background-color: var(--input-bg);
            color: var(--text-color);
        }
        .form-container button {
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
        /* 3) Стили для кнопки переключения темы */
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

    <!-- 4) Скрипт переключения темы -->
    <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>
<!-- 5) Кнопка-переключатель -->
<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<!-- Header с инфой о пользователе -->
<div id="header">
    <%
        User user = (User) session.getAttribute("user");
        if (user != null) {
    %>
    Welcome, <strong><%= user.getUsername() %></strong>!
    <a href="<%= request.getContextPath() %>/logout">Logout</a>
    <% } else { %>
    <a href="<%= request.getContextPath() %>/login.jsp">Login</a>
    <a href="<%= request.getContextPath() %>/registration.jsp">Register</a>
    <% } %>
</div>

<!-- Форма добавления поста -->
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
