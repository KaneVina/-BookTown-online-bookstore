<%@ page import="dao.GenreDAO"%>
<%@ page import="model.Genre"%>
<%@ page import="java.util.List"%>

<%
    GenreDAO genreDAO = new GenreDAO();
    List<Genre> genres = genreDAO.getAllGenres();
%>

<style>
    .category-navbar{
        display:flex;
        width:100%;
        background:#1976d2;
    }

    .category-navbar .cat-nav-item{
        flex:1;
        display:flex;
        justify-content:center;
        align-items:center;
        gap:6px;
        padding:14px 10px;
        color:#fff;
        text-decoration:none;
        font-size:15px;
        font-weight:600;
        border-right:1px solid rgba(255,255,255,.2);
        transition:.25s;
        white-space:nowrap;
    }

    .category-navbar .cat-nav-item:last-child{
        border-right:none;
    }

    .category-navbar .cat-nav-item:hover{
        background:#1565c0;
        color:#fff;
    }

    .category-navbar .cat-nav-item i{
        width:16px;
        height:16px;
    }
</style>

<nav class="category-navbar">

<%
    if(genres!=null){
        for(Genre g : genres){
%>

<a class="cat-nav-item"
   href="<%=request.getContextPath()%>/products?genreID=<%=g.getGenreID()%>">
    <i data-lucide="book-open"></i>
    <%=g.getGenreName()%>
</a>

<%
        }
    }
%>

</nav>