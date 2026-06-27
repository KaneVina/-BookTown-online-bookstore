<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Genre"%>

<%
Genre genre = (Genre) request.getAttribute("genre");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Category Detail</title>
</head>
<body>

<h2>Category Detail</h2>

<% if (genre != null) { %>

<p><b>ID:</b> <%=genre.getGenreID()%></p>
<p><b>Name:</b> <%=genre.getGenreName()%></p>

<% } else { %>

<p>Category not found.</p>

<% } %>

<a href="category">Back</a>

</body>
</html>