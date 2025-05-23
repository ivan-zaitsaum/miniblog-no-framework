<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.example.miniblognoframework.model.User" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>
<%@ page import="com.example.miniblognoframework.model.Comment" %>
<%@ page import="com.example.miniblognoframework.dao.CommentDAO" %>
<%@ page import="com.example.miniblognoframework.dao.PostCategoryDAO" %>
<%@ page import="com.example.miniblognoframework.dao.PostTagDAO" %>
<%@ page import="com.example.miniblognoframework.model.Category" %>
<%@ page import="com.example.miniblognoframework.model.Tag" %>
<%@ page import="com.example.miniblognoframework.dao.CategoryDAO" %>
<%@ page import="com.example.miniblognoframework.dao.TagDAO" %>

<%
    // Текущий пользователь из AuthFilter
    User currentUser = (User) request.getAttribute("user");

    // Аватар
    String avatarFile = currentUser != null ? currentUser.getAvatar() : null;
    String avatarUrl = request.getContextPath()
            + ((avatarFile != null && !avatarFile.isEmpty())
            ? "/uploads/" + avatarFile
            : "/images/default-avatar.png");

    // Для фильтров
    CategoryDAO categoryDAO = new CategoryDAO();
    TagDAO      tagDAO      = new TagDAO();
    List<Category> categories = categoryDAO.findAll();
    List<Tag>       tagList    = tagDAO.findAll();

    // Параметры поиска/фильтров
    String searchQuery = request.getParameter("q");
    if (searchQuery == null) searchQuery = "";

    String catParam = request.getParameter("category");
    Integer selectedCategory = (catParam != null && !catParam.isEmpty())
            ? Integer.valueOf(catParam) : null;

    String tagParam = request.getParameter("tag");
    Integer selectedTag = (tagParam != null && !tagParam.isEmpty())
            ? Integer.valueOf(tagParam) : null;

    // Посты и пагинация
    @SuppressWarnings("unchecked")
    List<Post> posts       = (List<Post>) request.getAttribute("posts");
    Integer    currentPage = (Integer)    request.getAttribute("currentPage");
    Integer    totalPages  = (Integer)    request.getAttribute("totalPages");
    if (currentPage == null) currentPage = 1;
    if (totalPages  == null) totalPages  = 1;

    // DAO для комментариев и связей
    CommentDAO      commentDAO = new CommentDAO();
    PostCategoryDAO pcDao      = new PostCategoryDAO();
    PostTagDAO      ptDao      = new PostTagDAO();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Mini Blog</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/theme.css">
    <style>
        body { font-family:'Courier New',monospace; background:var(--bg-color); color:var(--text-color); margin:0; padding:20px; }
        .nav { margin-bottom:20px; }
        .nav a { color:var(--link-color); text-decoration:none; margin-right:15px; }
        #theme-toggle { position:fixed; top:10px; right:10px; background:var(--link-color); color:var(--bg-color); border:none; padding:6px 12px; border-radius:4px; cursor:pointer; z-index:1000; }
        .search-bar { margin:20px 0; }
        .search-bar input, .search-bar select { padding:5px; border-radius:4px; border:1px solid var(--link-color); background:var(--card-bg); color:var(--text-color); }
        .search-bar button, .search-bar .btn-all { padding:5px 10px; border:none; border-radius:4px; cursor:pointer; text-decoration:none; display:inline-block; }
        .search-bar button { background:var(--link-color); color:var(--bg-color); }
        .search-bar .btn-all { background:#ccc; color:#000; margin-left:8px; }
        .post { background:var(--card-bg); border:1px solid var(--border-color); border-radius:10px; padding:15px; margin-bottom:15px; }
        .post h2 { color:var(--link-color); margin-bottom:8px; }
        .date { font-size:12px; color:var(--text-faint); margin-bottom:8px; }
        .category-label { display:inline-block; padding:2px 6px; margin-right:4px; border-radius:4px; background:#eef; color:#000; font-size:12px; }
        .tag-label      { display:inline-block; padding:2px 6px; margin-right:4px; border-radius:4px; background:#fee; color:#000; font-size:12px; }
        .pagination a { margin:0 4px; text-decoration:none; }
        .pagination a.active { font-weight:bold; }
        .nav-avatar { width:32px; height:32px; border-radius:50%; vertical-align:middle; margin-left:8px; }
        .comment-form button { background:var(--link-color); color:var(--bg-color); border:none; padding:6px 12px; border-radius:5px; cursor:pointer; font-weight:bold; transition:opacity 0.2s; }
        .comment-form button:hover { opacity:0.8; }
        .comment-form textarea { background:var(--card-bg); color:var(--text-color); border:1px solid var(--link-color); border-radius:5px; padding:5px; background-clip:padding-box; }
    </style>
    <script src="<%=request.getContextPath()%>/js/theme.js" defer></script>
</head>
<body>

<button id="theme-toggle" onclick="toggleTheme()">Toggle Theme</button>

<div class="nav">
    <a href="<%=request.getContextPath()%>/posts">Home</a>
    <% if (currentUser == null) { %>
    <a href="<%=request.getContextPath()%>/registration.jsp">Registration</a>
    <a href="<%=request.getContextPath()%>/login.jsp">Login</a>
    <% } else { %>
    <a href="<%=request.getContextPath()%>/add-post">Add Post</a>
    <a href="<%=request.getContextPath()%>/profile">Profile</a>
    <a href="<%=request.getContextPath()%>/logout">Logout</a>
    Welcome, <strong><%=currentUser.getUsername()%></strong>
    <img src="<%=avatarUrl%>" alt="Avatar" class="nav-avatar"/>
    <% } %>
</div>

<h1>Mini Blog</h1>
<hr/>

<div class="search-bar">
    <form action="<%=request.getContextPath()%>/posts" method="get" style="display:flex;gap:8px;">
        <input type="text" name="q" placeholder="Search..." value="<%=searchQuery%>"/>
        <select name="category">
            <option value="">All Categories</option>
            <% for (Category c : categories) { %>
            <option value="<%=c.getId()%>" <%= (selectedCategory != null && c.getId() == selectedCategory) ? "selected" : "" %>>
                <%=c.getName()%>
            </option>
            <% } %>
        </select>
        <select name="tag">
            <option value="">All Tags</option>
            <% for (Tag t : tagList) { %>
            <option value="<%=t.getId()%>" <%= (selectedTag != null && t.getId() == selectedTag) ? "selected" : "" %>>
                <%=t.getName()%>
            </option>
            <% } %>
        </select>
        <button type="submit">Filter</button>
        <a href="<%=request.getContextPath()%>/posts" class="btn-all">All Posts</a>
    </form>
</div>

<% if (posts == null || posts.isEmpty()) { %>
<p>No posts available.</p>
<% } else {
    for (Post post : posts) {
%>
<div class="post">
    <h2>
        <a href="<%=request.getContextPath()%>/view-post?id=<%=post.getId()%>"><%=post.getTitle()%></a>
    </h2>
    <p class="date">Created at: <%=post.getCreatedAt()%> | Author: <%=post.getUsername()%></p>
    <p><%=post.getContent()%></p>

    <%
        List<Category> pcats = pcDao.getCategoriesByPostId(post.getId());
        if (!pcats.isEmpty()) {
    %>
    <p><strong>Categories:</strong>
        <% for (Category c : pcats) { %>
        <span class="category-label"><%=c.getName()%></span>
        <% } %>
    </p>
    <% } %>

    <%
        List<Tag> ptags = ptDao.getTagsByPostId(post.getId());
        if (!ptags.isEmpty()) {
    %>
    <p><strong>Tags:</strong>
        <% for (Tag t : ptags) { %>
        <span class="tag-label"><%=t.getName()%></span>
        <% } %>
    </p>
    <% } %>

    <% if (currentUser != null && currentUser.getId() == post.getUserId()) { %>
    <a href="<%=request.getContextPath()%>/edit-post?id=<%=post.getId()%>">Edit</a> |
    <a href="<%=request.getContextPath()%>/delete-post?id=<%=post.getId()%>">Delete</a>
    <% } %>

    <%
        List<Comment> comments = commentDAO.getCommentsByPostId(post.getId());
        if (comments != null && !comments.isEmpty()) {
    %>
    <div class="comments">
        <h5>Comments:</h5>
        <ul>
            <% for (Comment c : comments) { %>
            <li>
                <p><%=c.getContent()%></p>
                <small>By <strong><%=c.getUsername()%></strong> at <%=c.getCreatedAt()%></small>
            </li>
            <% } %>
        </ul>
    </div>
    <% } %>

    <% if (currentUser != null) { %>
    <div class="comment-form">
        <form method="post" action="<%=request.getContextPath()%>/add-comment">
            <input type="hidden" name="postId" value="<%=post.getId()%>"/>
            <textarea name="comment" rows="2" required></textarea><br/>
            <button type="submit">Submit Comment</button>
        </form>
    </div>
    <% } else { %>
    <p><a href="<%=request.getContextPath()%>/login.jsp">Log in</a> to comment.</p>
    <% } %>
</div>
<hr/>
<% } } %>

<% if (totalPages > 1) { %>
<div class="pagination">
    <% for (int i = 1; i <= totalPages; i++) {
        String url = request.getContextPath()
                + "/posts?page=" + i
                + (!searchQuery.isEmpty() ? "&q=" + URLEncoder.encode(searchQuery, "UTF-8") : "")
                + (selectedCategory != null ? "&category=" + selectedCategory : "")
                + (selectedTag != null ? "&tag=" + selectedTag : "");
    %>
    <a href="<%=url%>" <%= (i == currentPage) ? "class=\"active\"" : "" %>>
        <%=i%>
    </a>
    <% } %>
</div>
<% } %>

</body>
</html>
