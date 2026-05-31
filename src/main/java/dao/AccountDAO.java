package dao;

import utils.DBContext;
import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AccountDAO {
    public Account checkLogin(String email, String password) {
        DBContext db = new DBContext();

        String sqlCustomer = "SELECT customerID, fullname, email, phone, status "
                + "FROM Customer WHERE email = ? AND password = ? AND status = 'active'";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlCustomer)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                        rs.getInt("customerID"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        "customer",
                        rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String sqlStaff = "SELECT staffID, fullname, email, phone, status "
                + "FROM Staff WHERE email = ? AND password = ? AND status = 'active'";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlStaff)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                        rs.getInt("staffID"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        "staff",
                        rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        String sqlAdmin = "SELECT adminID, fullname, email, phone, status "
                + "FROM Admin WHERE email = ? AND password = ? AND status = 'active'";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlAdmin)) {
            ps.setString(1, email);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                        rs.getInt("adminID"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        "admin",
                        rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}