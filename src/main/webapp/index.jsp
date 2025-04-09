<%@ page import="java.util.List" %>
<%@ page import="com.example.miniblognoframework.model.Post" %>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Mini Blog</title>
</head>
<body>
<h1>Mini Blog</h1>

<a href="<%= request.getContextPath() %>/form.jsp">+ Přidat nový příspěvek</a>

<hr>

<%
    List<com.example.miniblognoframework.model.Post> posts =
            (List<com.example.miniblognoframework.model.Post>) request.getAttribute("posts");

    if (posts != null && !posts.isEmpty()) {
        for (com.example.miniblognoframework.model.Post post : posts) {
%>
<div>
    <h2><%= post.getTitle() %></h2>
    <p><%= post.getContent() %></p>
    <small><%= post.getCreatedAt() %></small>
</div>
<hr>
<%
    }
} else {
%>
<p>Žádné příspěvky nejsou dostupné.</p>
<%
    }
%>

</body>
</html>
