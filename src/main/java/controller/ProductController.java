package controller;

import dao.BookDAO;
import dao.ReviewDAO;
import dao.WishListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Book;
import java.io.IOException;
import java.util.List;
import model.Review;

/**
 * ProductController
 */
public class ProductController extends HttpServlet {

    private static final int DEFAULT_PAGE_SIZE = 10;

    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        String actionParam = req.getParameter("action");

        String action;
        if (idParam != null) {
            action = "detail";
        } else if (actionParam != null) {
            action = actionParam.trim().toLowerCase();
        } else {
            action = "list";
        }

        switch (action) {
            case "list":
                showList(req, resp);
                break;
            case "detail":
                showDetail(req, resp, idParam);
                break;
            case "featured":
                showFeatured(req, resp);
                break;
            default:
                show404(req, resp, "Hành động không tồn tại: " + action);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            // case "addToCart": handleAddToCart(req, resp); break;
            default:
                resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    // Danh sách sách, phân trang + sort
    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int page = 1;
        int pageSize = 12;
        String pageParam = req.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        Integer genreID = null;
        String genreIDParam = req.getParameter("genreID");
        if (genreIDParam != null && !genreIDParam.isEmpty()) {
            try {
                genreID = Integer.parseInt(genreIDParam);
            } catch (NumberFormatException e) {
                genreID = null;
            }
        }

        String sortParam = req.getParameter("sort");
        String order = buildOrderClause(sortParam);

        int offset = (page - 1) * pageSize;

        List<Book> books = bookDAO.getBooks(genreID, offset, pageSize, order);
        int totalBooks = bookDAO.countBooks(genreID);
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);

        req.setAttribute("books", books);
        req.setAttribute("page", page);
        req.setAttribute("pageSize", pageSize);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalBooks", totalBooks);
        req.setAttribute("sort", sortParam);
        req.setAttribute("activeGenreID", genreID);

        req.getRequestDispatcher("/views/book/book-index.jsp").forward(req, resp);
    }

    // Chi tiết 1 cuốn sách
    private void showDetail(HttpServletRequest req, HttpServletResponse resp, String idParam)
            throws ServletException, IOException {

        int bookID = parseID(idParam);
        if (bookID <= 0) {
            show404(req, resp, "ID sách không hợp lệ: " + idParam);
            return;
        }

        Book book = bookDAO.getBookByID(bookID);
        if (book == null) {
            show404(req, resp, "Không tìm thấy sách với ID = " + bookID);
            return;
        }

        ReviewDAO reviewDAO = new ReviewDAO();

        List<Review> reviews = reviewDAO.getReviewsByBook(bookID);

        req.setAttribute("reviews", reviews);

        List<Book> relatedBooks = bookDAO.getRelatedBooks(bookID, book.getGenreID(), 4);

        boolean isInWishlist = false;
        HttpSession session = req.getSession();
        Account acc = (Account) session.getAttribute("account");

        boolean canReview = false;

        if (acc != null && "customer".equalsIgnoreCase(acc.getRole())) {
            canReview = reviewDAO.canReview(acc.getId(), bookID);
        }

        req.setAttribute("canReview", canReview);

        if (acc != null && acc.getRole().equals("customer")) {
            WishListDAO wishListDAO = new WishListDAO();
            isInWishlist = wishListDAO.isInWishList(acc.getId(), bookID);
        }

        req.setAttribute("book", book);
        req.setAttribute("relatedBooks", relatedBooks);
        req.setAttribute("isInWishlist", isInWishlist);

        req.getRequestDispatcher("/views/book/product-detail.jsp").forward(req, resp);
    }

    // Sách nổi bật
    private void showFeatured(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Book> featuredBooks = bookDAO.getFeaturedBooks(5);
        int totalBooks = bookDAO.countBooks();

        req.setAttribute("featuredBooks", featuredBooks);
        req.setAttribute("books", featuredBooks);
        req.setAttribute("page", 1);
        req.setAttribute("pageSize", featuredBooks.size());
        req.setAttribute("totalPages", 1);
        req.setAttribute("totalBooks", totalBooks);
        req.setAttribute("sort", "popular");

        req.getRequestDispatcher("/views/book/book-index.jsp").forward(req, resp);
    }

    // 404 handler
    private void show404(HttpServletRequest req, HttpServletResponse resp, String message)
            throws ServletException, IOException {
        resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
        req.setAttribute("errorMessage", message);
        req.setAttribute("backUrl", req.getContextPath() + "/products");
        req.getRequestDispatcher("/views/error/404.jsp").forward(req, resp);
    }

    private int parsePage(String param) {
        if (param == null || param.trim().isEmpty()) {
            return 1;
        }
        try {
            int p = Integer.parseInt(param.trim());
            return p < 1 ? 1 : p;
        } catch (Exception e) {
            return 1;
        }
    }

    private int parsePageSize(String param) {
        if (param == null || param.trim().isEmpty()) {
            return DEFAULT_PAGE_SIZE;
        }
        try {
            int s = Integer.parseInt(param.trim());
            return s < 1 ? DEFAULT_PAGE_SIZE : s;
        } catch (Exception e) {
            return DEFAULT_PAGE_SIZE;
        }
    }

    private int parseID(String param) {
        if (param == null || param.trim().isEmpty()) {
            return -1;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (Exception e) {
            return -1;
        }
    }

    private String buildOrderClause(String sortBy) {
        if (sortBy == null || sortBy.trim().isEmpty()) {
            return " ORDER BY b.bookID DESC ";
        }
        switch (sortBy.trim()) {
            case "name":
                return " ORDER BY b.title ASC ";
            case "price_asc":
                return " ORDER BY b.price ASC ";
            case "price_desc":
                return " ORDER BY b.price DESC ";
            case "newest":
                return " ORDER BY b.created_at DESC ";
            case "popular":
                return " ORDER BY review_count DESC ";
            default:
                return " ORDER BY b.bookID DESC ";
        }
    }
}
