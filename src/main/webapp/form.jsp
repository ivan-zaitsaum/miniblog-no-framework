<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Post</title>

    <!-- Общий CSS для тем -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">

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

    <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>
<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<!-- Навигация/хедер -->
<div id="header">
    <a href="${pageContext.request.contextPath}/posts">Home</a>
    <c:choose>
        <c:when test="${empty user}">
            <a href="${pageContext.request.contextPath}/registration.jsp">Register</a>
            <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
        </c:when>
        <c:otherwise>
            <a href="${pageContext.request.contextPath}/add-post">Add Post</a>
            <a href="${pageContext.request.contextPath}/profile">Profile</a>
            <a href="${pageContext.request.contextPath}/logout">Logout</a>
            Welcome, <strong>${user.username}</strong>
        </c:otherwise>
    </c:choose>
</div>

<div class="form-container">
    <h1>Add a New Post</h1>
    <form method="post" action="${pageContext.request.contextPath}/add-post">
        <label for="title">Title:</label>
        <input type="text" id="title" name="title" required/>

        <label for="content">Content:</label>
        <textarea id="content" name="content" rows="5" required></textarea>

        <fieldset>
            <legend>Categories</legend>
            <c:forEach var="c" items="${allCategories}">
                <label>
                    <input type="checkbox" name="categoryIds" value="${c.id}"/>
                        ${c.name}
                </label><br/>
            </c:forEach>
        </fieldset>

        <fieldset>
            <legend>Tags</legend>
            <c:forEach var="t" items="${allTags}">
                <label>
                    <input type="checkbox" name="tagIds" value="${t.id}"/>
                        ${t.name}
                </label><br/>
            </c:forEach>
        </fieldset>

        <button type="submit">Submit Post</button>
    </form>

    <hr/>

    <h2>Add Category</h2>
    <form method="post" action="${pageContext.request.contextPath}/add-category">
        <input type="text" name="name" placeholder="Category name" required/>
        <button type="submit">Add Category</button>
    </form>

    <hr/>

    <h2>Add Tag</h2>
    <form method="post" action="${pageContext.request.contextPath}/add-tag">
        <input type="text" name="name" placeholder="Tag name" required/>
        <button type="submit">Add Tag</button>
    </form>
</div>

<div class="back-link">
    <p><a href="${pageContext.request.contextPath}/posts">Back to Home Page</a></p>
</div>
</body>
</html>
