package dao;

import model.Review;
import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    DBContext db = new DBContext();

    // lấy review theo bookID cho trang product detail
    public List<Review> getReviewsByBook(int bookID) {
        List<Review> list = new ArrayList<>();
        String sql
                = "SELECT r.*, c.fullname "
                + "FROM Review r "
                + "JOIN Customer c ON r.customerID = c.customerID "
                + "WHERE r.bookID = ? AND r.isHidden = 0 "
                + "ORDER BY r.created_at DESC";
        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review review = new Review();

                review.setReviewID(rs.getInt("reviewID"));
                review.setCustomerID(rs.getInt("customerID"));
                review.setCustomerName(rs.getString("fullname"));
                review.setBookID(rs.getInt("bookID"));
                review.setOrderDetailID(rs.getInt("orderDetailID"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setAdminID(rs.getInt("adminID"));
                review.setAdminReply(rs.getString("adminReply"));
                review.setAdminReplyDate(rs.getTimestamp("adminReplyDate"));

                list.add(review);
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // customer thêm review mới 
    public boolean addReview(int customerID, int bookID, int orderDetailID, int rating, String comment) {

        String sql = "INSERT INTO Review " + "(customerID, bookID, orderDetailID, rating, comment, created_at) " + "VALUES (?, ?, ?, ?, ?, GETDATE())";
        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerID);
            ps.setInt(2, bookID);
            ps.setInt(3, orderDetailID);
            ps.setInt(4, rating);
            ps.setString(5, comment);
            int result = ps.executeUpdate();
            conn.close();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // kiểm tra customer có review được ko 
    public boolean canReview(int customerID, int bookID) {

        String sql
                = "SELECT 1 "
                + "FROM [Order] o "
                + "JOIN OrderDetail od ON o.orderID = od.orderID "
                + "LEFT JOIN Review r ON r.orderDetailID = od.orderDetailID "
                + "WHERE o.customerID = ? "
                + "AND od.bookID = ? "
                + "AND LOWER(o.status) = 'completed' "
                + "AND r.reviewID IS NULL";

        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerID);
            ps.setInt(2, bookID);

            ResultSet rs = ps.executeQuery();

            return rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // lấy oderDtailID để review    
    public int getReviewableOrderDetail(
            int customerID,
            int bookID) {

        String sql
                = "SELECT TOP 1 od.orderDetailID "
                + "FROM [Order] o "
                + "JOIN OrderDetail od ON o.orderID = od.orderID "
                + "WHERE o.customerID = ? "
                + "AND od.bookID = ? "
                + "AND o.status = 'completed' "
                + "AND NOT EXISTS ( "
                + "    SELECT 1 "
                + "    FROM Review r "
                + "    WHERE r.orderDetailID = od.orderDetailID "
                + ")";

        try {
            Connection conn = db.getConnection();

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, customerID);
            ps.setInt(2, bookID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                int orderDetailID
                        = rs.getInt("orderDetailID");

                conn.close();

                return orderDetailID;
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    // lấy tất cả review để admin và staff xem 
    public List<Review> getAllReviews() {
        List<Review> list = new ArrayList<>();
        // 🔥 THÊM c.status as customerStatus VÀ r.isHidden
        String sql = "SELECT r.*, c.fullname, c.status as customerStatus, b.title as bookTitle, b.thumbnail as bookCover "
                + "FROM Review r "
                + "JOIN Customer c ON r.customerID = c.customerID "
                + "JOIN Book b ON r.bookID = b.bookID "
                + "ORDER BY r.created_at DESC";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");

            while (rs.next()) {
                Review review = new Review();
                review.setReviewID(rs.getInt("reviewID"));
                review.setCustomerID(rs.getInt("customerID"));
                review.setCustomerName(rs.getString("fullname"));
                review.setCustomerStatus(rs.getString("customerStatus"));
                review.setBookID(rs.getInt("bookID"));
                review.setBookTitle(rs.getString("bookTitle"));
                review.setBookCover(rs.getString("bookCover"));
                review.setOrderDetailID(rs.getInt("orderDetailID"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setAdminID(rs.getInt("adminID") == 0 ? null : rs.getInt("adminID"));
                review.setAdminReply(rs.getString("adminReply"));
                review.setAdminReplyDate(rs.getTimestamp("adminReplyDate"));

                // lấy isHidden từ database
                review.setIsHidden(rs.getInt("isHidden") == 1);

                // Set date in format dd/MM/yyyy
                if (rs.getTimestamp("created_at") != null) {
                    review.setDate(sdf.format(rs.getTimestamp("created_at")));
                }

                String status = "Chờ duyệt";
                if (rs.getString("adminReply") != null && !rs.getString("adminReply").trim().isEmpty()) {
                    status = "Đã duyệt";
                }
                review.setStatus(status);

                list.add(review);
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // admin với staff phản hồi review 
    public boolean replyReview(
            int reviewID,
            int adminID,
            String reply) {

        String sql
                = "UPDATE Review "
                + "SET adminID = ?, "
                + "adminReply = ?, "
                + "adminReplyDate = GETDATE() "
                + "WHERE reviewID = ?";

        try {

            Connection conn = db.getConnection();

            PreparedStatement ps
                    = conn.prepareStatement(sql);

            ps.setInt(1, adminID);
            ps.setString(2, reply);
            ps.setInt(3, reviewID);

            int result = ps.executeUpdate();

            conn.close();

            return result > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ẩn review
    public boolean hideReview(int reviewID) {
        String sql = "UPDATE Review SET isHidden = 1 WHERE reviewID = ?";
        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewID);
            int result = ps.executeUpdate();
            conn.close();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // mở ẩn review
    public boolean toggleHideReview(int reviewID) {
        // 🔥 Lấy trạng thái hiện tại
        String checkSql = "SELECT isHidden FROM Review WHERE reviewID = ?";
        String updateSql = "UPDATE Review SET isHidden = ? WHERE reviewID = ?";

        try {
            Connection conn = db.getConnection();

            // Lấy trạng thái hiện tại
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setInt(1, reviewID);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                int currentStatus = rs.getInt("isHidden");
                int newStatus = currentStatus == 1 ? 0 : 1; // Toggle: 1->0, 0->1

                // Update ngược lại
                PreparedStatement updatePs = conn.prepareStatement(updateSql);
                updatePs.setInt(1, newStatus);
                updatePs.setInt(2, reviewID);
                int result = updatePs.executeUpdate();

                conn.close();
                return result > 0;
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean lockAccountByReview(int customerID) {
        String sql = "UPDATE Customer SET status = 'inactive' WHERE customerID = ?";
        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerID);
            int result = ps.executeUpdate();
            conn.close();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Review getReviewByID(int reviewID) {
        String sql = "SELECT r.*, c.fullname, c.status as customerStatus, b.title as bookTitle "
                + "FROM Review r "
                + "JOIN Customer c ON r.customerID = c.customerID "
                + "JOIN Book b ON r.bookID = b.bookID "
                + "WHERE r.reviewID = ?";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, reviewID);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Review review = new Review();
                review.setReviewID(rs.getInt("reviewID"));
                review.setCustomerID(rs.getInt("customerID"));
                review.setCustomerName(rs.getString("fullname"));
                review.setCustomerStatus(rs.getString("customerStatus"));
                review.setBookID(rs.getInt("bookID"));
                review.setBookTitle(rs.getString("bookTitle"));
                review.setOrderDetailID(rs.getInt("orderDetailID"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));
                review.setAdminID(rs.getInt("adminID") == 0 ? null : rs.getInt("adminID"));
                review.setAdminReply(rs.getString("adminReply"));
                review.setAdminReplyDate(rs.getTimestamp("adminReplyDate"));

                conn.close();
                return review;
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
