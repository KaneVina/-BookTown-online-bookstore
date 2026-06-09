package dao;

import utils.DBContext;
import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {

    private String hashMD5(String input) {
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

    public Account checkLogin(String email, String password) {
        String hashedPassword = hashMD5(password);
        DBContext db = new DBContext();

        // Kiểm tra bảng Customer
        String sqlCustomer = "SELECT customerID, fullname, email, phone, role, status "
                + "FROM Customer WHERE email = ? AND password = ? AND status = 'active'";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlCustomer)) {
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
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

        // Kiểm tra bảng Account 
        String sqlAccount = "SELECT accountID, fullname, email, phone, role, status "
                + "FROM Account WHERE email = ? AND password = ? AND status = 'active'";
        try (Connection conn = db.getConnection(); PreparedStatement ps = conn.prepareStatement(sqlAccount)) {
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getInt("accountID"),
                            rs.getString("fullname"),
                            rs.getString("email"),
                            rs.getString("phone"),
                            rs.getString("role"),
                            rs.getString("status")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Account> getAllStaffs() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM Account";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Account(
                        rs.getInt("accountID"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("role"),
                        rs.getString("status")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // cập nhật trạng thái của staff 
    public boolean toggleStaffStatus(int accountID, String status) {
        String sql = "UPDATE Account SET status = ? WHERE accountID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, accountID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // thêm phân trang
    public int countStaffs() {

        String sql = "SELECT COUNT(*) FROM Account";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Account> getStaffsPaging(int offset, int pageSize) {
        List<Account> list = new ArrayList<>();
        String sql
                = "SELECT * FROM ("
                + " SELECT *, ROW_NUMBER() OVER(ORDER BY accountID DESC) AS rn "
                + " FROM Account "
                + ") t "
                + "WHERE rn > ? AND rn <= ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, offset + pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(
                        new Account(
                                rs.getInt("accountID"),
                                rs.getString("fullname"),
                                rs.getString("email"),
                                rs.getString("phone"),
                                rs.getString("role"),
                                rs.getString("status")
                        )
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
