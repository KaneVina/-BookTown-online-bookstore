package dao;

import model.Book;
import model.Genre;
import model.Author;
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
        return getBooks(null, offset, pageSize, orderClause);
    }

    public List<Book> getBooks(Integer genreID, int offset, int pageSize, String orderClause) {
        List<Book> books = new ArrayList<>();
        String sql = BASE_SELECT +
                     "WHERE b.status = 'available' " +
                     (genreID != null ? "AND b.genreID = ? " : "") +
                     GROUP_BY + orderClause +
                     " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            int paramIdx = 1;
            if (genreID != null) {
                ps.setInt(paramIdx++, genreID);
            }
            ps.setInt(paramIdx++, offset);
            ps.setInt(paramIdx++, pageSize);
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
        return countBooks(null);
    }

    public int countBooks(Integer genreID) {
        String sql = "SELECT COUNT(*) FROM Book WHERE status = 'available'" +
                     (genreID != null ? " AND genreID = ?" : "");
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            if (genreID != null) {
                ps.setInt(1, genreID);
            }
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

    // ── Top 5 sách bán chạy nhất (nhiều order nhất) ─────────────────
    public List<Book> getTopSellingBooks(int limit) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.bookID, b.title, b.description, b.price, b.stock_quantity, " +
                     "       b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, " +
                     "       g.genreID, g.genre_name, " +
                     "       c.contentID, c.content_name, " +
                     "       s.seriesID, s.series_name, " +
                     "       o.originID, o.origin_name, " +
                     "       b.created_at, b.updated_at, " +
                     "       ISNULL(AVG(CAST(r.rating AS FLOAT)), 0) AS avg_rating, " +
                     "       COUNT(DISTINCT r.reviewID)              AS review_count, " +
                     "       ISNULL(SUM(od.quantity), 0)             AS order_qty " +
                     "FROM Book b " +
                     "LEFT JOIN Genre      g  ON b.genreID   = g.genreID " +
                     "LEFT JOIN Content    c  ON b.contentID = c.contentID " +
                     "LEFT JOIN BookSeries s  ON b.seriesID  = s.seriesID " +
                     "LEFT JOIN BookOrigin o  ON b.originID  = o.originID " +
                     "LEFT JOIN Review     r  ON b.bookID    = r.bookID " +
                     "LEFT JOIN OrderDetail od ON b.bookID   = od.bookID " +
                     "WHERE b.status = 'available' " +
                     "GROUP BY b.bookID, b.title, b.description, b.price, b.stock_quantity, " +
                     "         b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, " +
                     "         g.genreID, g.genre_name, c.contentID, c.content_name, " +
                     "         s.seriesID, s.series_name, o.originID, o.origin_name, " +
                     "         b.created_at, b.updated_at " +
                     "ORDER BY order_qty DESC, review_count DESC, avg_rating DESC " +
                     "OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY";
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

    // ── Admin: Danh sách tất cả sách phân trang + lọc theo thể loại ────────────────────────────────────
    public List<Book> getAdminBooks(Integer genreID, int offset, int pageSize, String orderClause) {
        List<Book> books = new ArrayList<>();
        String sql = BASE_SELECT +
                     (genreID != null ? " WHERE b.genreID = ? " : "") +
                     GROUP_BY + orderClause +
                     " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            int paramIdx = 1;
            if (genreID != null) {
                ps.setInt(paramIdx++, genreID);
            }
            ps.setInt(paramIdx++, offset);
            ps.setInt(paramIdx++, pageSize);
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

    // ── Admin: Đếm tổng sách + lọc theo thể loại ──────────────────────────────────────
    public int countAdminBooks(Integer genreID) {
        String sql = "SELECT COUNT(*) FROM Book" +
                     (genreID != null ? " WHERE genreID = ?" : "");
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            if (genreID != null) {
                ps.setInt(1, genreID);
            }
            rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return 0;
    }

    // ── Lấy danh sách danh mục (Genres) ──────────────────────────────────
    public List<Genre> getGenres() {
        List<Genre> genres = new ArrayList<>();
        String sql = "SELECT genreID, genre_name FROM Genre ORDER BY genre_name";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                genres.add(new Genre(rs.getInt("genreID"), rs.getString("genre_name")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return genres;
    }

    // ── Lấy danh sách tác giả ──────────────────────────────────────────
    public List<Author> getAuthors() {
        List<Author> authors = new ArrayList<>();
        String sql = "SELECT authorID, fullname FROM Author ORDER BY fullname";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                authors.add(new Author(rs.getInt("authorID"), rs.getString("fullname")));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return authors;
    }

    // ── Lấy ID các tác giả của một cuốn sách ─────────────────────────────
    public List<Integer> getAuthorIDsByBookID(int bookID) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT authorID FROM BookAuthor WHERE bookID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBContext().getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookID);
            rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("authorID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return ids;
    }

    // ── Thêm sách mới ──────────────────────────────────────────
    public boolean createBook(Book b, List<Integer> authorIDs) {
        String sql = "INSERT INTO Book (title, description, price, stock_quantity, thumbnail, total_pages, dimensions, weight, status, genreID, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean success = false;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            
            ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getDescription());
            ps.setBigDecimal(3, b.getPrice());
            ps.setInt(4, b.getStockQuantity());
            ps.setString(5, b.getThumbnail());
            ps.setInt(6, b.getTotalPages());
            ps.setString(7, b.getDimensions());
            ps.setBigDecimal(8, b.getWeight());
            ps.setString(9, b.getStatus());
            if (b.getGenreID() > 0) {
                ps.setInt(10, b.getGenreID());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int newBookID = rs.getInt(1);
                    b.setBookID(newBookID);
                    
                    if (authorIDs != null && !authorIDs.isEmpty()) {
                        String sqlMapping = "INSERT INTO BookAuthor (bookID, authorID) VALUES (?, ?)";
                        try (PreparedStatement psMap = conn.prepareStatement(sqlMapping)) {
                            for (int authorID : authorIDs) {
                                psMap.setInt(1, newBookID);
                                psMap.setInt(2, authorID);
                                psMap.addBatch();
                            }
                            psMap.executeBatch();
                        }
                    }
                    success = true;
                }
            }
            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception rollbackEx) { rollbackEx.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            closeAll(rs, ps, conn);
        }
        return success;
    }

    // ── Cập nhật sách ──────────────────────────────────────────
    public boolean updateBook(Book b, List<Integer> authorIDs) {
        String sql = "UPDATE Book SET title = ?, description = ?, price = ?, stock_quantity = ?, " +
                     "thumbnail = ?, total_pages = ?, dimensions = ?, weight = ?, status = ?, genreID = ?, updated_at = GETDATE() " +
                     "WHERE bookID = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            
            ps = conn.prepareStatement(sql);
            ps.setString(1, b.getTitle());
            ps.setString(2, b.getDescription());
            ps.setBigDecimal(3, b.getPrice());
            ps.setInt(4, b.getStockQuantity());
            ps.setString(5, b.getThumbnail());
            ps.setInt(6, b.getTotalPages());
            ps.setString(7, b.getDimensions());
            ps.setBigDecimal(8, b.getWeight());
            ps.setString(9, b.getStatus());
            if (b.getGenreID() > 0) {
                ps.setInt(10, b.getGenreID());
            } else {
                ps.setNull(10, Types.INTEGER);
            }
            ps.setInt(11, b.getBookID());
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                String sqlDelMapping = "DELETE FROM BookAuthor WHERE bookID = ?";
                try (PreparedStatement psDel = conn.prepareStatement(sqlDelMapping)) {
                    psDel.setInt(1, b.getBookID());
                    psDel.executeUpdate();
                }
                
                if (authorIDs != null && !authorIDs.isEmpty()) {
                    String sqlMapping = "INSERT INTO BookAuthor (bookID, authorID) VALUES (?, ?)";
                    try (PreparedStatement psMap = conn.prepareStatement(sqlMapping)) {
                        for (int authorID : authorIDs) {
                            psMap.setInt(1, b.getBookID());
                            psMap.setInt(2, authorID);
                            psMap.addBatch();
                        }
                        psMap.executeBatch();
                    }
                }
                success = true;
            }
            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception rollbackEx) { rollbackEx.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            closeAll(null, ps, conn);
        }
        return success;
    }

    // ── Xóa sách ──────────────────────────────────────────────
    public boolean deleteBook(int bookID) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false);
            
            String sqlBookAuthor = "DELETE FROM BookAuthor WHERE bookID = ?";
            try (PreparedStatement psMap = conn.prepareStatement(sqlBookAuthor)) {
                psMap.setInt(1, bookID);
                psMap.executeUpdate();
            }
            
            String sqlWishList = "DELETE FROM WishList_Item WHERE bookID = ?";
            try (PreparedStatement psWish = conn.prepareStatement(sqlWishList)) {
                psWish.setInt(1, bookID);
                psWish.executeUpdate();
            }

            String sqlCartItem = "DELETE FROM CartItem WHERE bookID = ?";
            try (PreparedStatement psCart = conn.prepareStatement(sqlCartItem)) {
                psCart.setInt(1, bookID);
                psCart.executeUpdate();
            }
            
            String sqlBook = "DELETE FROM Book WHERE bookID = ?";
            ps = conn.prepareStatement(sqlBook);
            ps.setInt(1, bookID);
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                success = true;
            }
            conn.commit();
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception rollbackEx) { rollbackEx.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            closeAll(null, ps, conn);
        }
        return success;
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
