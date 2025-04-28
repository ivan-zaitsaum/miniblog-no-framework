<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>
<%@ page import="com.example.miniblognoframework.dao.PostCategoryDAO" %>
<%@ page import="com.example.miniblognoframework.dao.PostTagDAO" %>
<%@ page import="com.example.miniblognoframework.model.Category" %>
<%@ page import="com.example.miniblognoframework.model.Tag" %>

<%
  // 1) Получаем залогиненного пользователя из request (AuthFilter)
  User currentUser = (User) request.getAttribute("user");
  if (currentUser == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
  }

  // 2) URL аватара: либо свой, либо дефолтный
  String avatarFile = currentUser.getAvatar();
  String avatarUrl  = request.getContextPath()
          + ((avatarFile != null && !avatarFile.isEmpty())
          ? "/uploads/" + avatarFile
          : "/images/default-avatar.png");

  // 3) Список его постов и DAO для категорий/тегов
  @SuppressWarnings("unchecked")
  List<Post> myPosts     = (List<Post>) request.getAttribute("myPosts");
  PostCategoryDAO catDao = new PostCategoryDAO();
  PostTagDAO     tagDao  = new PostTagDAO();
%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Mini Blog — Profile</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <style>
    body {
      font-family:'Courier New',monospace;
      background:var(--bg-color);
      color:var(--text-color);
      margin:0; padding:20px;
    }
    .nav { margin-bottom:20px; }
    .nav a, .nav img, .nav strong {
      vertical-align: middle;
      margin-right:10px;
    }
    .nav-avatar {
      width:32px; height:32px;
      border-radius:50%; object-fit:cover;
    }
    #theme-toggle {
      position:fixed; top:10px; right:10px;
      background:var(--link-color); color:var(--bg-color);
      border:none; padding:6px 12px; border-radius:4px;
      cursor:pointer; z-index:1000;
    }
    .card {
      background:var(--card-bg); border:1px solid var(--card-border);
      border-radius:10px; padding:20px; max-width:400px; margin-bottom:20px;
    }
    .card h1 { margin-top:0; color:var(--link-color); text-align:center; }
    .avatar-img { display:block; margin:0 auto 10px; width:120px; height:120px; border-radius:50%; object-fit:cover; border:2px solid var(--border-color); }
    .post {
      background:var(--card-bg); border:1px solid var(--card-border);
      border-radius:10px; padding:15px; margin-bottom:15px;
    }
    .post h2 { margin:0 0 10px; color:var(--link-color); }
    .date { font-size:12px; color:var(--text-faint); margin-bottom:8px; }
    .category-label, .tag-label {
      display:inline-block; padding:2px 6px; margin-right:4px; border-radius:4px; font-size:12px;
    }
    .category-label { background:#eef; color:#000; }
    .tag-label      { background:#fee; color:#000; }
    .actions a { color:var(--link-color); text-decoration:none; margin-right:10px; }
    .comment-form button, .card button {
      background:var(--link-color); color:var(--bg-color); border:none;
      padding:6px 12px; border-radius:5px; cursor:pointer; font-weight:bold; transition:opacity .2s;
    }
    .comment-form button:hover, .card button:hover { opacity:.8; }
  </style>
  <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>

<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<div class="nav">
  <a href="${pageContext.request.contextPath}/posts">Home</a>
  <a href="${pageContext.request.contextPath}/add-post">Add Post</a>
  <a href="${pageContext.request.contextPath}/profile">Profile</a>
  <img src="<%= avatarUrl %>" alt="Avatar" class="nav-avatar"/>
  <strong><%= currentUser.getUsername() %></strong>
  <a href="${pageContext.request.contextPath}/logout">Logout</a>
</div>

<h1>Your Profile</h1>
<hr>

<div class="card">
  <h1>Avatar</h1>
  <img src="<%= avatarUrl %>" alt="Avatar" class="avatar-img"/>

  <form method="post"
        action="${pageContext.request.contextPath}/upload-avatar"
        enctype="multipart/form-data">
    <label style="color:var(--link-color);">Upload new avatar:</label><br/>
    <input type="file" name="avatarFile" accept="image/*" required/><br/><br/>
    <button type="submit">Save Avatar</button>
  </form>

  <p><strong>Email:</strong> <%= currentUser.getEmail() %></p>

  <div id="username-display" style="margin-bottom:10px;">
    <strong>Username:</strong>
    <span><%= currentUser.getUsername() %></span>
    <button type="button" id="change-username-btn">Change</button>
  </div>

  <div id="username-edit" style="display:none; margin-bottom:10px;">
    <form method="post"
          action="${pageContext.request.contextPath}/update-profile"
          style="display:inline-block;">
      <input type="text"
             name="username"
             value="<%= currentUser.getUsername() %>"
             required
             style="padding:4px; margin-right:6px;"/>
      <button type="submit">Save</button>
      <button type="button" id="cancel-username-btn" style="background:#ccc;color:#000;">Cancel</button>
    </form>
  </div>
</div>

<script>
  document.getElementById('change-username-btn').addEventListener('click', function(){
    document.getElementById('username-display').style.display = 'none';
    document.getElementById('username-edit').style.display    = 'block';
  });
  document.getElementById('cancel-username-btn').addEventListener('click', function(){
    document.getElementById('username-edit').style.display    = 'none';
    document.getElementById('username-display').style.display = 'block';
  });
</script>

<h2>Your Posts</h2>
<% if (myPosts == null || myPosts.isEmpty()) { %>
<p>You have no posts yet.
  <a href="${pageContext.request.contextPath}/add-post" style="color:var(--link-color)">
    Create one now
  </a>.
</p>
<% } else {
  for (Post post : myPosts) {
    List<Category> cats = catDao.getCategoriesByPostId(post.getId());
    List<Tag>      tags = tagDao.getTagsByPostId(post.getId());
%>
<div class="post">
  <h2>
    <a href="${pageContext.request.contextPath}/view-post?id=<%= post.getId() %>">
      <%= post.getTitle() %>
    </a>
  </h2>
  <p class="date">Created at: <%= post.getCreatedAt() %></p>
  <p><%= post.getContent() %></p>

  <% if (!cats.isEmpty()) { %>
  <p><strong>Categories:</strong>
    <% for (Category c : cats) { %>
    <span class="category-label"><%= c.getName() %></span>
    <% } %>
  </p>
  <% } %>

  <% if (!tags.isEmpty()) { %>
  <p><strong>Tags:</strong>
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
<%   }
} %>

<p>
  <a href="${pageContext.request.contextPath}/posts" style="color:var(--link-color)">
    Back to all posts
  </a>
</p>

</body>
</html>
