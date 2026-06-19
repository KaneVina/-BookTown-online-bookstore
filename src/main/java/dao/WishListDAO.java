package dao;

import model.Book;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class WishListDAO {

    // Helper to map Book from ResultSet (matches BookDAO's mapping logic)
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
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    authors.add(rs.getString("fullname"));
                }
            }
        }
        return authors;
    }

    // Get the existing wishlistID for a customer, or create one and return it
    public int getOrCreateWishListId(int customerId) {
        String selectSql = "SELECT wishlistID FROM WishList WHERE customerID = ?";
        String insertSql = "INSERT INTO WishList (customerID, created_at) VALUES (?, GETDATE())";
        
        try (Connection conn = new DBContext().getConnection()) {
            // Check if wishlist already exists
            try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                ps.setInt(1, customerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt("wishlistID");
                    }
                }
            }
            
            // If not, insert it
            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, customerId);
                int affected = ps.executeUpdate();
                if (affected > 0) {
                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (rs.next()) {
                            return rs.getInt(1);
                        }
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    // Add book to wishlist
    public boolean addToWishList(int customerId, int bookId) {
        int wishlistId = getOrCreateWishListId(customerId);
        if (wishlistId == -1) return false;

        // Check if book is already in wishlist items
        String checkSql = "SELECT wishlistItemID FROM WishList_Item WHERE wishlistID = ? AND bookID = ?";
        String insertSql = "INSERT INTO WishList_Item (wishlistID, bookID, added_at) VALUES (?, ?, GETDATE())";

        try (Connection conn = new DBContext().getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, wishlistId);
                ps.setInt(2, bookId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return true; // Already added
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, wishlistId);
                ps.setInt(2, bookId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Remove book from wishlist
    public boolean removeFromWishList(int customerId, int bookId) {
        String sql = "DELETE wi FROM WishList_Item wi " +
                     "JOIN WishList w ON wi.wishlistID = w.wishlistID " +
                     "WHERE w.customerID = ? AND wi.bookID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, bookId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Check if book is in wishlist
    public boolean isInWishList(int customerId, int bookId) {
        String sql = "SELECT wi.wishlistItemID FROM WishList_Item wi " +
                     "JOIN WishList w ON wi.wishlistID = w.wishlistID " +
                     "WHERE w.customerID = ? AND wi.bookID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Retrieve all books in customer's wishlist
    public List<Book> getWishListBooks(int customerId) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT b.bookID, b.title, b.description, b.price, b.stock_quantity, " +
                     "       b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, " +
                     "       g.genreID, g.genre_name, " +
                     "       c.contentID, c.content_name, " +
                     "       s.seriesID, s.series_name, " +
                     "       o.originID, o.origin_name, " +
                     "       b.created_at, b.updated_at, " +
                     "       ISNULL(AVG(CAST(r.rating AS FLOAT)), 0) AS avg_rating, " +
                     "       COUNT(DISTINCT r.reviewID)              AS review_count " +
                     "FROM Book b " +
                     "JOIN WishList_Item wi ON b.bookID = wi.bookID " +
                     "JOIN WishList w ON wi.wishlistID = w.wishlistID " +
                     "LEFT JOIN Genre      g  ON b.genreID   = g.genreID " +
                     "LEFT JOIN Content    c  ON b.contentID = c.contentID " +
                     "LEFT JOIN BookSeries s  ON b.seriesID  = s.seriesID " +
                     "LEFT JOIN BookOrigin o  ON b.originID  = o.originID " +
                     "LEFT JOIN Review     r  ON b.bookID    = r.bookID " +
                     "WHERE w.customerID = ? AND b.status = 'available' " +
                     "GROUP BY b.bookID, b.title, b.description, b.price, b.stock_quantity, " +
                     "         b.thumbnail, b.total_pages, b.dimensions, b.weight, b.status, " +
                     "         g.genreID, g.genre_name, c.contentID, c.content_name, " +
                     "         s.seriesID, s.series_name, o.originID, o.origin_name, " +
                     "         b.created_at, b.updated_at, wi.added_at " +
                     "ORDER BY wi.added_at DESC";
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book b = mapBook(rs);
                    b.setAuthors(getAuthorsByBookID(conn, b.getBookID()));
                    books.add(b);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return books;
    }

    // Move a wishlist item to cart
    public boolean moveToCart(int customerId, int bookId) {
        Connection conn = null;
        boolean success = false;
        try {
            conn = new DBContext().getConnection();
            conn.setAutoCommit(false); // transaction
            
            // 1. Get or create active cart ID for this customer
            int cartId = -1;
            String selectCartSql = "SELECT cartID FROM Cart WHERE customerID = ? AND status = 'active'";
            try (PreparedStatement psCart = conn.prepareStatement(selectCartSql)) {
                psCart.setInt(1, customerId);
                try (ResultSet rsCart = psCart.executeQuery()) {
                    if (rsCart.next()) {
                        cartId = rsCart.getInt("cartID");
                    }
                }
            }
            
            if (cartId == -1) {
                String insertCartSql = "INSERT INTO Cart (customerID, status, created_at, updated_at) VALUES (?, 'active', GETDATE(), GETDATE())";
                try (PreparedStatement psInsertCart = conn.prepareStatement(insertCartSql, Statement.RETURN_GENERATED_KEYS)) {
                    psInsertCart.setInt(1, customerId);
                    psInsertCart.executeUpdate();
                    try (ResultSet rsKeys = psInsertCart.getGeneratedKeys()) {
                        if (rsKeys.next()) {
                            cartId = rsKeys.getInt(1);
                        }
                    }
                }
            }
            
            if (cartId == -1) {
                conn.rollback();
                return false;
            }
            
            // 2. Add to CartItem
            String checkCartItemSql = "SELECT cartItemID FROM CartItem WHERE cartID = ? AND bookID = ?";
            boolean itemExists = false;
            try (PreparedStatement psCheck = conn.prepareStatement(checkCartItemSql)) {
                psCheck.setInt(1, cartId);
                psCheck.setInt(2, bookId);
                try (ResultSet rsCheck = psCheck.executeQuery()) {
                    if (rsCheck.next()) {
                        itemExists = true;
                    }
                }
            }
            
            if (itemExists) {
                String updateCartItemSql = "UPDATE CartItem SET quantity = quantity + 1 WHERE cartID = ? AND bookID = ?";
                try (PreparedStatement psUpdate = conn.prepareStatement(updateCartItemSql)) {
                    psUpdate.setInt(1, cartId);
                    psUpdate.setInt(2, bookId);
                    psUpdate.executeUpdate();
                }
            } else {
                String insertCartItemSql = "INSERT INTO CartItem (cartID, bookID, quantity, added_at) VALUES (?, ?, 1, GETDATE())";
                try (PreparedStatement psInsertItem = conn.prepareStatement(insertCartItemSql)) {
                    psInsertItem.setInt(1, cartId);
                    psInsertItem.setInt(2, bookId);
                    psInsertItem.executeUpdate();
                }
            }
            
            // 3. Remove from WishList_Item
            int wishlistId = -1;
            String selectWishSql = "SELECT wishlistID FROM WishList WHERE customerID = ?";
            try (PreparedStatement psWish = conn.prepareStatement(selectWishSql)) {
                psWish.setInt(1, customerId);
                try (ResultSet rsWish = psWish.executeQuery()) {
                    if (rsWish.next()) {
                        wishlistId = rsWish.getInt("wishlistID");
                    }
                }
            }
            
            if (wishlistId != -1) {
                String deleteWishItemSql = "DELETE FROM WishList_Item WHERE wishlistID = ? AND bookID = ?";
                try (PreparedStatement psDel = conn.prepareStatement(deleteWishItemSql)) {
                    psDel.setInt(1, wishlistId);
                    psDel.setInt(2, bookId);
                    psDel.executeUpdate();
                }
            }
            
            conn.commit();
            success = true;
        } catch (Exception e) {
            if (conn != null) {
                try { conn.rollback(); } catch (Exception rollbackEx) { rollbackEx.printStackTrace(); }
            }
            e.printStackTrace();
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (Exception closeEx) { closeEx.printStackTrace(); }
            }
        }
        return success;
    }

    public java.util.List<Long> getWishListBookIds(int customerId) {
        java.util.List<Long> ids = new java.util.ArrayList<>();
        String sql = "SELECT wi.bookID FROM WishList_Item wi " +
                     "JOIN WishList w ON wi.wishlistID = w.wishlistID " +
                     "WHERE w.customerID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getLong("bookID"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }
}
