<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Přidat příspěvek</title>
</head>
<body>
<h1>Přidat nový příspěvek</h1>

<form method="post" action="add-post">


    <label for="title">Titulek:</label><br>
    <input type="text" id="title" name="title" required><br><br>

    <label for="content">Obsah:</label><br>
    <textarea id="content" name="content" rows="5" cols="30" required></textarea><br><br>

    <button type="submit">Odeslat</button>
</form>

<a href="index.jsp">Zpět na hlavní stránku</a>
</body>
</html>
