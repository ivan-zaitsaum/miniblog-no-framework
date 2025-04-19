<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<%@ page import="com.example.miniblognoframework.model.Category" %>
<%@ page import="com.example.miniblognoframework.model.Tag" %>

<html>
<head>
    <title>Add Post</title>
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

    <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>
<div id="header">
    <%
        User user = (User) session.getAttribute("user");
        if (user!=null) {
    %>
    Welcome, <strong><%=user.getUsername()%></strong>!
    <a href="<%=request.getContextPath()%>/logout">Logout</a>
    <%
    } else {
    %>
    <a href="<%=request.getContextPath()%>/login.jsp">Login</a>
    <a href="<%=request.getContextPath()%>/registration.jsp">Register</a>
    <%
        }
    %>
</div>

<div class="form-container">

    <!-- ==== 1) Форма добавления категории ==== -->
    <h2>Add Category</h2>
    <form method="post" action="${pageContext.request.contextPath}/add-category">
        <input type="text" name="name" placeholder="Category name" required/>
        <button type="submit">Add Category</button>
    </form>

    <hr/>

    <!-- ==== 2) Форма добавления тега ==== -->
    <h2>Add Tag</h2>
    <form method="post" action="${pageContext.request.contextPath}/add-tag">
        <input type="text" name="name" placeholder="Tag name" required/>
        <button type="submit">Add Tag</button>
    </form>

    <hr/>

    <!-- ==== 3) Основная форма создания поста ==== -->
    <h1>Add a New Post</h1>
    <form method="post" action="${pageContext.request.contextPath}/add-post">
        <label for="title">Title:</label>
        <input type="text" id="title" name="title" required/>

        <label for="content">Content:</label>
        <textarea id="content" name="content" rows="5" required></textarea>

        <!-- Существующие категории -->
        <fieldset>
            <legend>Categories</legend>
            <%
                List<Category> cats = (List<Category>)request.getAttribute("allCategories");
                if (cats!=null) for (Category c:cats) {
            %>
            <label>
                <input type="checkbox" name="categoryIds" value="<%=c.getId()%>"/>
                <%=c.getName()%>
            </label><br/>
            <%
                    }
            %>
        </fieldset>

        <!-- Существующие теги -->
        <fieldset>
            <legend>Tags</legend>
            <%
                List<Tag> tags = (List<Tag>)request.getAttribute("allTags");
                if (tags!=null) for (Tag t:tags) {
            %>
            <label>
                <input type="checkbox" name="tagIds" value="<%=t.getId()%>"/>
                <%=t.getName()%>
            </label><br/>
            <%
                    }
            %>
        </fieldset>

        <button type="submit">Submit Post</button>
    </form>

</div>

<p><a href="<%=request.getContextPath()%>/posts">Back to Home Page</a></p>
</body>
</html>
