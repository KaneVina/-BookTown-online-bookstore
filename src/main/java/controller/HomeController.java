package controller;

import dao.BookDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;
import java.io.IOException;
import java.util.List;

/**
 * HomeController – trang chủ.
 */
public class HomeController extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Sách bán chạy nhất (top 5 nhiều order nhất)
        List<Book> featuredBooks = bookDAO.getTopSellingBooks(5);
        req.setAttribute("featuredBooks", featuredBooks);

        // Sách mới nhất (top 5, sort newest)
        List<Book> newBooks = bookDAO.getBooks(0, 5, " ORDER BY b.created_at DESC ");
        req.setAttribute("newBooks", newBooks);

        req.getRequestDispatcher("/views/book/index.jsp").forward(req, resp);
    }
}
