<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!–– header.jsp ––>
<head>
  <meta charset="UTF-8">
  <title><c:out value="${pageTitle != null ? pageTitle : 'MiniBlog'}"/></title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/theme.css">
  <!-- ваш общий CSS -->
  <script src="${pageContext.request.contextPath}/js/theme.js" defer></script>
</head>
<body>
<button onclick="toggleTheme()"
        style="position:fixed; top:10px; right:10px; z-index:1000;">
  Toggle Theme
</button>
