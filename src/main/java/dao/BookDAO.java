package dao;

import model.Book;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

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
        "LEFT JOIN Genre      g  ON b.genreID   = g.genreID " +
        "LEFT JOIN Content    c  ON b.contentID = c.contentID " +
        "LEFT JOIN BookSeries s  ON b.seriesID  = s.seriesID " +
        "LEFT JOIN BookOrigin o  ON b.originID  = o.originID " +
        "LEFT JOIN Review     r  ON b.bookID    = r.bookID ";

    private static final String GROUP_BY =
        " GROUP BY b.bookID, b.title, b.description, b.price, b.stock_quantity, " +
        "          b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, " +
        "          g.genreID, g.genre_name, c.contentID, c.content_name, " +
        "          s.seriesID, s.series_name, o.originID, o.origin_name, " +
        "          b.created_at, b.updated_at ";

    // ── Danh sách sách phân trang ────────────────────────────────────
    public List<Book> getBooks(int offset, int pageSize, String orderClause) {
        List<Book> books = new ArrayList<>();
        String sql = BASE_SELECT +
                     "WHERE b.status = 'available' " +
                     GROUP_BY + orderClause +
                     " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return books;
    }

    // ── Đếm tổng sách available ──────────────────────────────────────
    public int countBooks() {
        String sql = "SELECT COUNT(*) FROM Book WHERE status = 'available'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return 0;
    }

    // ── Lấy 1 sách theo ID ──────────────────────────────────────────
    public Book getBookByID(int bookID) {
        String sql = BASE_SELECT + "WHERE b.bookID = ? " + GROUP_BY;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookID);
            rs = ps.executeQuery();
            if (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, bookID));
                return b;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return null;
    }

    // ── Sách nổi bật ────────────────────────────────────────────────
    public List<Book> getFeaturedBooks(int limit) {
        List<Book> books = new ArrayList<>();
        String sql = BASE_SELECT +
                     "WHERE b.status = 'available' " +
                     GROUP_BY +
                     " ORDER BY review_count DESC, avg_rating DESC " +
                     " OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setFeatured(true);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return books;
    }

    // ── Sách liên quan ──────────────────────────────────────────────
    public List<Book> getRelatedBooks(int bookID, int genreID, int limit) {
        List<Book> books = new ArrayList<>();
        String sql = BASE_SELECT +
                     "WHERE b.status = 'available' AND b.bookID <> ? AND b.genreID = ? " +
                     GROUP_BY +
                     " ORDER BY review_count DESC " +
                     " OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookID);
            ps.setInt(2, genreID);
            ps.setInt(3, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                Book b = mapBook(rs);
                b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                books.add(b);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return books;
    }

    // ── Private helpers ──────────────────────────────────────────────

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

    private List<String> getAuthorsByBookID(Connection conn, int bookID) throws SQLException {
        List<String> authors = new ArrayList<>();
        String sql = "SELECT a.fullname FROM Author a " +
                     "JOIN BookAuthor ba ON a.authorID = ba.authorID WHERE ba.bookID = ?";
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookID);
            rs = ps.executeQuery();
            while (rs.next()) authors.add(rs.getString("fullname"));
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
            if (ps != null) try { ps.close(); } catch (Exception e) { e.printStackTrace(); }
        }
        return authors;
    }

    private void closeAll(ResultSet rs, PreparedStatement ps, Connection conn) {
        if (rs   != null) try { rs.close();   } catch (Exception e) { e.printStackTrace(); }
        if (ps   != null) try { ps.close();   } catch (Exception e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
    }
}
