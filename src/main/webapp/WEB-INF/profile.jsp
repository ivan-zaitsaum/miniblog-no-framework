<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<%@ page import="com.example.miniblognoframework.dao.PostCategoryDAO" %>
<%@ page import="com.example.miniblognoframework.dao.PostTagDAO" %>
<%@ page import="com.example.miniblognoframework.model.Category" %>
<%@ page import="com.example.miniblognoframework.model.Tag" %>

<%
  User currentUser = (User) session.getAttribute("user");
  if (currentUser == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }
  // Посты пользователя
  List<Post> myPosts = (List<Post>) request.getAttribute("myPosts");
  PostCategoryDAO catDao = new PostCategoryDAO();
  PostTagDAO      tagDao = new PostTagDAO();
%>

<!DOCTYPE html>
<html>
<head>
  <title>Mini Blog — Profile</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <style>
    /* ==== Стили точно как в index.jsp ==== */
    body {
      font-family: 'Courier New', monospace;
      background-color: var(--bg-color);
      color: var(--text-color);
      padding: 20px;
      margin: 0;
    }
    .nav {
      margin-bottom: 20px;
    }
    .nav a {
      text-decoration: none;
      color: var(--link-color);
      margin-right: 15px;
    }
    #theme-toggle {
      position: fixed; top: 10px; right: 10px;
      background: var(--link-color);
      color: var(--bg-color);
      border: none; padding: 6px 12px;
      border-radius: 4px; cursor: pointer;
      z-index: 1000;
    }
    .post {
      background-color: var(--card-bg);
      border: 1px solid var(--border-color);
      border-radius: 10px;
      padding: 15px;
      margin-bottom: 15px;
    }
    .post h2 {
      color: var(--link-color);
      margin-bottom: 10px;
    }
    .post p {
      color: var(--text-muted);
    }
    .date {
      font-size: 12px;
      color: var(--text-faint);
    }
    .category-label {
      display: inline-block;
      padding: 2px 6px;
      margin-right: 4px;
      border-radius: 4px;
      background: #eef;
      font-size: 12px;

      /* вот оно — цвет текста */
      color: #000000;
    }

    .tag-label {
      display: inline-block;
      padding: 2px 6px;
      margin-right: 4px;
      border-radius: 4px;
      background: #fee;
      font-size: 12px;

      /* и тут */
      color: #000000;
    }
    .actions a {
      color: var(--link-color);
      text-decoration: none;
      margin-right: 10px;
    }
  </style>
  <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>

<!-- Кнопка переключения темы -->
<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<!-- Навигация -->
<div class="nav">
  <a href="${pageContext.request.contextPath}/posts">Home</a>
  <a href="${pageContext.request.contextPath}/add-post">Add Post</a>
  <a href="${pageContext.request.contextPath}/profile">Profile</a>
  Welcome, <strong><%= currentUser.getUsername() %></strong>!
  <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>



<h1>Your Profile</h1>
<hr>

<form method="post" action="${pageContext.request.contextPath}/upload-avatar"
      enctype="multipart/form-data">
  <label>Upload avatar:</label><br>
  <input type="file" name="avatarFile" accept="image/*"><br><br>
  <button type="submit">Save Avatar</button>
</form>

<%-- если у пользователя уже есть аватар, показываем его --%>
<%
  String avatar = currentUser.getAvatar();
  if (avatar != null) {
%>
<img src="${pageContext.request.contextPath}/uploads/<%= avatar %>"
     alt="Avatar" style="max-width:150px; border-radius:50%;">
<% } %>

<div class="card">
  <% %>
  <p><strong>Username:</strong> <%= currentUser.getUsername() %></p>
  <p><strong>Email:</strong> <%= currentUser.getEmail() %></p>
  <!-- добавьте здесь другие поля, если нужно -->
  <% %>
</div>

<h2>Your Posts</h2>
<%
  if (myPosts == null || myPosts.isEmpty()) {
%>
<p>You have no posts yet. <a href="${pageContext.request.contextPath}/add-post">Create one now</a>.</p>
<%
} else {
  for (Post post : myPosts) {
    List<Category> cats = catDao.getCategoriesByPostId(post.getId());
    List<Tag>      tags = tagDao.getTagsByPostId(post.getId());
%>
<div class="post">
  <h2><a href="${pageContext.request.contextPath}/view-post?id=<%= post.getId() %>"
         style="color:var(--link-color); text-decoration:none;">
    <%= post.getTitle() %>
  </a>
  </h2>
  <p class="date">
    Created at: <%= post.getCreatedAt() %>
  </p>
  <p><%= post.getContent() %></p>

  <% if (!cats.isEmpty()) { %>
  <p>
    <strong>Categories:</strong>
    <% for (Category c : cats) { %>
    <span class="category-label"><%= c.getName() %></span>
    <% } %>
  </p>
  <% } %>
  <% if (!tags.isEmpty()) { %>
  <p>
    <strong>Tags:</strong>
    <% for (Tag t : tags) { %>
    <span class="tag-label"><%= t.getName() %></span>
    <% } %>
  </p>
  <% } %>

  <div class="actions">
    <a href="${pageContext.request.contextPath}/edit-post?id=<%= post.getId() %>">Edit</a>
    <a href="${pageContext.request.contextPath}/delete-post?id=<%= post.getId() %>">Delete</a>
  </div>
</div>
<%
    }
  }
%>

<p><a href="${pageContext.request.contextPath}/posts">Back to all posts</a></p>
</body>
</html>
