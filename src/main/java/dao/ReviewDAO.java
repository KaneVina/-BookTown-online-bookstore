package dao;

import model.Review;
import utils.DBContext;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    DBContext db = new DBContext();

    public List<Review> getReviewsByBook(int bookID) {

        List<Review> list = new ArrayList<>();

        String sql = "SELECT * " + "FROM Review " + "WHERE bookID = ? " + "ORDER BY created_at DESC";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {

                Review review = new Review();

                review.setReviewID(rs.getInt("reviewID"));
                review.setCustomerID(rs.getInt("customerID"));
                review.setBookID(rs.getInt("bookID"));
                review.setOrderDetailID(rs.getInt("orderDetailID"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(review);
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean addReview(
            int customerID,
            int bookID,
            int orderDetailID,
            int rating,
            String comment) {

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
}