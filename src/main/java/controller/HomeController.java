package controller;

import dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Book;

public class HomeController extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Sách nổi bật (top 5 theo review + rating)
        List<Book> featuredBooks = bookDAO.getFeaturedBooks(5);
        req.setAttribute("featuredBooks", featuredBooks);

        // Sách mới nhất (top 5, sort newest)
        List<Book> newBooks = bookDAO.getBooks(0, 5, " ORDER BY b.created_at DESC ");
        req.setAttribute("newBooks", newBooks);

        req.getRequestDispatcher("/views/book/index.jsp").forward(req, resp);
    }
}
