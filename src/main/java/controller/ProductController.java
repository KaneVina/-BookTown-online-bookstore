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

@WebServlet({"/products", "/featured"})
public class ProductController extends HttpServlet {

    private final BookService bookService = new BookService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        switch (path) {
            case "/products" -> handleProducts(req, resp);
            case "/featured" -> handleFeatured(req, resp);
            default          -> resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ── /products ────────────────────────────────────────────────────────

    private void handleProducts(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");

        if (idParam != null) {
            handleProductDetail(req, resp, idParam);   // 2.2 – chi tiết
        } else {
            handleProductList(req, resp);               // 2.1 – danh sách
        }
    }

    /** 2.1 – Danh sách sách, phân trang + sort. URL: /products?page=1&size=10&sort=newest */
    private void handleProductList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int    page     = parseIntParam(req.getParameter("page"), 1);
        int    pageSize = parseIntParam(req.getParameter("size"), 10);
        String sort     = req.getParameter("sort");

        List<Book> books      = bookService.getBooks(page, pageSize, sort);
        int        totalPages = bookService.getTotalPages(pageSize);
        int        totalBooks = bookService.getTotalBooks();

        req.setAttribute("books",      books);
        req.setAttribute("page",       page);
        req.setAttribute("pageSize",   pageSize);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalBooks", totalBooks);
        req.setAttribute("sort",       sort);

        req.getRequestDispatcher("/views/book/index.jsp").forward(req, resp);
    }

    /** 2.2 – Chi tiết sách. URL: /products?id=1 */
    private void handleProductDetail(HttpServletRequest req, HttpServletResponse resp, String idParam)
            throws ServletException, IOException {

        int bookID = parseIntParam(idParam, 0);
        if (bookID <= 0) {
            resp.sendRedirect(req.getContextPath() + "/products");
            return;
        }

        Book book = bookService.getBookDetail(bookID);
        if (book == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy sách.");
            return;
        }

        List<Book> relatedBooks = bookService.getRelatedBooks(bookID, book.getGenreID());

        req.setAttribute("book",         book);
        req.setAttribute("relatedBooks", relatedBooks);

        req.getRequestDispatcher("/views/book/product-detail.jsp").forward(req, resp);
    }

    /** 2.3 – Sách nổi bật. URL: /featured */
    private void handleFeatured(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Book> featuredBooks = bookService.getFeaturedBooks();
        req.setAttribute("featuredBooks", featuredBooks);
        req.getRequestDispatcher("/views/book/index.jsp").forward(req, resp);
    }

    // ── Utility ──────────────────────────────────────────────────────────

    private int parseIntParam(String param, int defaultVal) {
        if (param == null || param.isBlank()) return defaultVal;
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}