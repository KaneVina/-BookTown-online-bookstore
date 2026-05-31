package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Book;
import service.BookService;

import java.io.IOException;
import java.util.List;

@WebServlet("/")
public class HomeController extends HttpServlet {

    private final BookService bookService = new BookService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 2.3 – Sách bán chạy / nổi bật
        List<Book> featuredBooks = bookService.getFeaturedBooks();
        req.setAttribute("featuredBooks", featuredBooks);

        // 2.1 – Sách mới về (sort newest, top 5)
        List<Book> newBooks = bookService.getNewBooks();
        req.setAttribute("newBooks", newBooks);

        req.getRequestDispatcher("/views/book/index.jsp").forward(req, resp);
    }
}