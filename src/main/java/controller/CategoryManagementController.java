package controller;

import dao.GenreDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Genre;

public class CategoryManagementController extends HttpServlet {

    private GenreDAO genreDAO = new GenreDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        List<Genre> genres;
        System.out.println("=== CATEGORY DEBUG ===");

        if (keyword != null && !keyword.trim().isEmpty()) {
            genres = genreDAO.searchGenres(keyword);
        } else {
            genres = genreDAO.getAllGenres();
        }

        System.out.println("SIZE = " + genres.size());
        System.out.println("SIZE = " + genres.size());

for (Genre g : genres) {
    System.out.println(
        g.getGenreID() + " - " + g.getGenreName()
    );
}

        request.setAttribute("genres", genres);

        request.getRequestDispatcher(
                "/views/category/list.jsp"
        ).forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");


        if ("create".equals(action)) {

            String name =
                request.getParameter("genre_name");

            genreDAO.insertGenre(name);

        }


        if ("update".equals(action)) {

            int id = Integer.parseInt(
                request.getParameter("id")
            );

            String name =
                request.getParameter("genre_name");

            genreDAO.updateGenre(id, name);
        }


        if ("delete".equals(action)) {

            int id = Integer.parseInt(
                request.getParameter("id")
            );

            genreDAO.deleteGenre(id);
        }


        response.sendRedirect("category");
    }
}