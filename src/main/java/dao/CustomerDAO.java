package dao;

import utils.DBContext;
import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;

public class CustomerDAO {

    public static String hashMD5(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] bytes = md.digest(input.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (Exception e) {
            return input;
        }
    }

    // Kiểm tra email đã tồn tại trong Customer hoặc Account chưa
    public boolean isEmailExists(String email) {
        String sql1 = "SELECT 1 FROM Customer WHERE email = ?";
        String sql2 = "SELECT 1 FROM Account WHERE email = ?";
        try (Connection conn = new DBContext().getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql1)) {
                ps.setString(1, email);
                if (ps.executeQuery().next()) {
                    return true;
                }
            }
            try (PreparedStatement ps = conn.prepareStatement(sql2)) {
                ps.setString(1, email);
                if (ps.executeQuery().next()) {
                    return true;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Thêm customer mới vào database
//    public boolean registerCustomer(String fullname, String email, String phone, String password) {
//        String sql = "INSERT INTO Customer (fullname, email, password, phone) VALUES (?, ?, ?, ?)";
//        try (Connection conn = new DBContext().getConnection();
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setString(1, fullname);
//            ps.setString(2, email);
//            ps.setString(3, hashMD5(password));
//            ps.setString(4, phone);
//            return ps.executeUpdate() > 0;
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//        return false;
//    }
    public boolean registerCustomer(String fullname, String email, String phone, String password) {
        String sql = "INSERT INTO Customer (fullname, email, password, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, hashMD5(password));
            ps.setString(4, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace(); // 
            System.out.println("REGISTER ERROR: " + e.getMessage()); // thêm dòng này
        }
        return false;
    }

    public boolean updateCustomer(int id, String fullname, String phone) {
        String sql = "UPDATE Customer "
                + "SET fullname = ?, phone = ? "
                + "WHERE customerID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setInt(3, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("ERROR: " + e.getMessage()); // thêm dòng này
        }
        return false;
    }
}
