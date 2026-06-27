<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.Genre"%>

<html>
<head>
<title>Category</title>
</head>

<body>

<h1>Category Management</h1>


<form action="category" method="get">

<input 
type="text" 
name="keyword"
placeholder="Search category">

<button>
Filter
</button>

<a href="category">
Reset
</a>

</form>


<br>


<form action="category" method="post">

<input type="hidden"
name="action"
value="create">


<input 
name="genre_name"
placeholder="New category">

<button>
Add
</button>

</form>


<br>


<table border="1">

<tr>
<th>ID</th>
<th>Name</th>
<th>Action</th>
</tr>


<%

List<Genre> list =
(List<Genre>)request.getAttribute("genres");


if(list != null){

for(Genre g:list){

%>


<tr>

<td>
<%=g.getGenreID()%>
</td>


<td>

<form action="category" method="post">

<input type="hidden"
name="action"
value="update">

<input type="hidden"
name="id"
value="<%=g.getGenreID()%>">

<input 
name="genre_name"
value="<%=g.getGenreName()%>">

<button>
Save
</button>

</form>

</td>


<td>

<form action="category" method="post">

<input type="hidden"
name="action"
value="delete">

<input type="hidden"
name="id"
value="<%=g.getGenreID()%>">

<button>
Delete
</button>

</form>

</td>

</tr>


<%
}
}
%>

</table>

</body>
</html>