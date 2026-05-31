package dao;

import model.Book;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * BookDAO – xử lý truy vấn bảng Book (+ BookAuthor, Author, Genre).
 * Dùng DBContext để lấy Connection.
 */
public class BookDAO {

    // ── SQL base để JOIN lấy đủ thông tin sách ──────────────────────────
    private static final String BASE_SELECT =
        "SELECT b.bookID, b.title, b.description, b.price, b.stock_quantity, " +
        "       b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, " +
        "       g.genreID, g.genre_name, " +
        "       c.contentID, c.content_name, " +
        "       s.seriesID, s.series_name, " +
        "       o.originID, o.origin_name, " +
        "       b.created_at, b.updated_at, " +
        "       ISNULL(AVG(CAST(r.rating AS FLOAT)), 0) AS avg_rating, " +
        "       COUNT(DISTINCT r.reviewID)              AS review_count " +
        "FROM Book b " +
        "LEFT JOIN Genre              g ON b.genreID   = g.genreID " +
        "LEFT JOIN Content            c ON b.contentID = c.contentID " +
        "LEFT JOIN BookSeries         s ON b.seriesID  = s.seriesID " +
        "LEFT JOIN BookOrigin         o ON b.originID  = o.originID " +
        "LEFT JOIN Review             r ON b.bookID    = r.bookID ";

    private static final String GROUP_BY =
        " GROUP BY b.bookID, b.title, b.description, b.price, b.stock_quantity, " +
        "          b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, " +
        "          g.genreID, g.genre_name, c.contentID, c.content_name, " +
        "          s.seriesID, s.series_name, o.originID, o.origin_name, " +
        "          b.created_at, b.updated_at ";

    // ────────────────────────────────────────────────────────────────────

    /**
     * 2.1 – Lấy danh sách sách có phân trang và sắp xếp.
     *
     * @param page     trang hiện tại (bắt đầu từ 1)
     * @param pageSize số sản phẩm mỗi trang
     * @param sortBy   "name" | "price_asc" | "price_desc" | "newest"
     */
    public List<Book> getBooks(int page, int pageSize, String sortBy) {
        String orderClause = buildOrderClause(sortBy);
        int offset = (page - 1) * pageSize;

        String sql = BASE_SELECT +
                     "WHERE b.status = 'available' " +
                     GROUP_BY +
                     orderClause +
                     " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Book> books = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * Đếm tổng số sách available (dùng cho phân trang).
     */
    public int countBooks() {
        String sql = "SELECT COUNT(*) FROM Book WHERE status = 'available'";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * 2.2 – Lấy chi tiết 1 cuốn sách theo ID.
     */
    public Book getBookByID(int bookID) {
        String sql = BASE_SELECT +
                     "WHERE b.bookID = ? " +
                     GROUP_BY;

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, bookID));
                return b;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * 2.3 – Lấy sách nổi bật (stock_quantity cao, rating tốt, status available).
     * "Featured" = sách bán chạy / được đẩy lên homepage, lấy top 5.
     */
    public List<Book> getFeaturedBooks(int limit) {
        String sql = BASE_SELECT +
                     "WHERE b.status = 'available' " +
                     GROUP_BY +
                     " ORDER BY review_count DESC, avg_rating DESC " +
                     " OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        List<Book> books = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setFeatured(true);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    /**
     * Lấy sách liên quan (cùng genre, loại trừ bookID hiện tại), dùng cho trang detail.
     */
    public List<Book> getRelatedBooks(int bookID, int genreID, int limit) {
        String sql = BASE_SELECT +
                     "WHERE b.status = 'available' AND b.bookID <> ? AND b.genreID = ? " +
                     GROUP_BY +
                     " ORDER BY review_count DESC " +
                     " OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";

        List<Book> books = new ArrayList<>();
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookID);
            ps.setInt(2, genreID);
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    // ── Private helpers ──────────────────────────────────────────────────

    /** Map ResultSet → Book object. */
    private Book mapBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setBookID(rs.getInt("bookID"));
        b.setTitle(rs.getString("title"));
        b.setDescription(rs.getString("description"));
        b.setPrice(rs.getBigDecimal("price"));
        b.setStockQuantity(rs.getInt("stock_quantity"));
        b.setThumbnail(rs.getString("thumbnail"));
        b.setTotalPages(rs.getInt("total_pages"));
        b.setDimensions(rs.getString("dimensions"));
        b.setWeight(rs.getBigDecimal("weight"));
        b.setStatus(rs.getString("status"));

        b.setGenreID(rs.getInt("genreID"));
        b.setGenreName(rs.getString("genre_name"));
        b.setContentID(rs.getInt("contentID"));
        b.setContentName(rs.getString("content_name"));
        b.setSeriesID(rs.getInt("seriesID"));
        b.setSeriesName(rs.getString("series_name"));
        b.setOriginID(rs.getInt("originID"));
        b.setOriginName(rs.getString("origin_name"));

        b.setCreatedAt(rs.getTimestamp("created_at"));
        b.setUpdatedAt(rs.getTimestamp("updated_at"));

        b.setAvgRating(rs.getDouble("avg_rating"));
        b.setReviewCount(rs.getInt("review_count"));
        return b;
    }

    /** Lấy danh sách tên tác giả theo bookID. */
    private List<String> getAuthorsByBookID(Connection conn, int bookID) throws SQLException {
        String sql = "SELECT a.fullname FROM Author a " +
                     "JOIN BookAuthor ba ON a.authorID = ba.authorID " +
                     "WHERE ba.bookID = ?";
        List<String> authors = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                authors.add(rs.getString("fullname"));
            }
        }
        return authors;
    }

    /** Tạo ORDER BY clause từ tham số sortBy. */
    private String buildOrderClause(String sortBy) {
        if (sortBy == null) return " ORDER BY b.bookID DESC ";
        return switch (sortBy) {
            case "name"       -> " ORDER BY b.title ASC ";
            case "price_asc"  -> " ORDER BY b.price ASC ";
            case "price_desc" -> " ORDER BY b.price DESC ";
            case "newest"     -> " ORDER BY b.created_at DESC ";
            case "popular"    -> " ORDER BY review_count DESC ";
            default           -> " ORDER BY b.bookID DESC ";
        };
    }
}