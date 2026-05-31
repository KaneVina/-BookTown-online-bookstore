package service;

import dao.BookDAO;
import model.Book;

import java.util.List;

/**
 * BookService – tầng nghiệp vụ, nằm giữa Controller và DAO.
 * Chứa logic phân trang, validation tham số.
 */
public class BookService {

    private static final int DEFAULT_PAGE_SIZE = 10;
    private final BookDAO bookDAO = new BookDAO();

    // ── 2.1 View Product ────────────────────────────────────────────────

    /**
     * Lấy danh sách sách có phân trang và sắp xếp.
     */
    public List<Book> getBooks(int page, int pageSize, String sortBy) {
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = DEFAULT_PAGE_SIZE;
        return bookDAO.getBooks(page, pageSize, sortBy);
    }

    /**
     * Tính tổng số trang.
     */
    public int getTotalPages(int pageSize) {
        if (pageSize < 1) pageSize = DEFAULT_PAGE_SIZE;
        int total = bookDAO.countBooks();
        return (int) Math.ceil((double) total / pageSize);
    }

    public int getTotalBooks() {
        return bookDAO.countBooks();
    }

    // ── 2.2 View Product Detail ──────────────────────────────────────────

    /**
     * Lấy chi tiết sách. Trả về null nếu không tìm thấy.
     */
    public Book getBookDetail(int bookID) {
        if (bookID <= 0) return null;
        return bookDAO.getBookByID(bookID);
    }

    /**
     * Lấy sách liên quan để hiển thị ở cuối trang detail.
     */
    public List<Book> getRelatedBooks(int bookID, int genreID) {
        return bookDAO.getRelatedBooks(bookID, genreID, 4);
    }

    // ── 2.3 View Featured Product ────────────────────────────────────────

    /**
     * Lấy danh sách sách nổi bật cho homepage.
     */
    public List<Book> getFeaturedBooks() {
        return bookDAO.getFeaturedBooks(5);
    }

    /**
     * Lấy sách mới nhất cho section "Sách Mới Về" trên homepage.
     */
    public List<Book> getNewBooks() {
        return bookDAO.getBooks(1, 5, "newest");
    }
}