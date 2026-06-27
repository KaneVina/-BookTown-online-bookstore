<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Genre"%>

<%
Genre genre = (Genre) request.getAttribute("genre");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Category Form</title>
</head>
<body>

<h2><%=genre == null ? "Create Category" : "Update Category"%></h2>

<form action="category" method="post">

    <input type="hidden" name="id"
           value="<%=genre != null ? genre.getGenreID() : ""%>">

    Category Name:
    <input type="text" name="name" required
           value="<%=genre != null ? genre.getGenreName() : ""%>">

    <br><br>

    <button type="submit">Save</button>
    <a href="category">Back</a>

</form>

</body>
</html>