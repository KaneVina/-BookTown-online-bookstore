package dao;

import utils.DBContext;
import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.security.MessageDigest;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import model.Customer;

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

    public boolean isEmailExists(String email) {
        String sql1 = "SELECT 1 FROM Customer WHERE email = ?";
        String sql2 = "SELECT 1 FROM Account WHERE email = ?";
        try (Connection conn = new DBContext().getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(sql1)) {
                ps.setString(1, email);
                if (ps.executeQuery().next()) return true;
            }
            try (PreparedStatement ps = conn.prepareStatement(sql2)) {
                ps.setString(1, email);
                if (ps.executeQuery().next()) return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean registerCustomer(String fullname, String email, String phone, String password) {
        String sql = "INSERT INTO Customer (fullname, email, password, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, hashMD5(password));
            ps.setString(4, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("REGISTER ERROR: " + e.getMessage());
        }
        return false;
    }

    public boolean resetPasswordByEmail(String email, String newPassword) {
        String sql = "UPDATE Customer SET password = ? WHERE email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashMD5(newPassword));
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // [khang] format gọn hơn
    public boolean updateCustomer(int id, String fullname, String phone, String gender, String dob) {
        String sql = "UPDATE Customer SET fullname = ?, phone = ?, gender = ?, dob = ? WHERE customerID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, phone);
            ps.setString(3, gender);
            if (dob != null && !dob.trim().isEmpty()) {
                ps.setDate(4, java.sql.Date.valueOf(dob));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            ps.setInt(5, id);
            int row = ps.executeUpdate();
            System.out.println("Updated rows = " + row);
            return row > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // [khang] format gọn hơn
    public Customer getCustomerById(int id) {
        String sql = "SELECT customerID, fullname, email, password, phone, role, status, gender, dob "
                   + "FROM Customer WHERE customerID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Customer(
                        rs.getInt("customerID"), rs.getString("fullname"),
                        rs.getString("email"), rs.getString("password"),
                        rs.getString("phone"), rs.getString("role"),
                        rs.getString("status"), null,
                        rs.getString("gender"), rs.getDate("dob")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // [khang] format gọn hơn
    public boolean changePassword(int customerId, String currentPassword, String newPassword) {
        String checkSql  = "SELECT password FROM Customer WHERE customerID = ?";
        String updateSql = "UPDATE Customer SET password = ? WHERE customerID = ?";
        try (Connection conn = new DBContext().getConnection()) {
            PreparedStatement ps = conn.prepareStatement(checkSql);
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                String oldPassword = rs.getString("password");
                if (!oldPassword.equals(hashMD5(currentPassword))) {
                    return false;
                }
                PreparedStatement update = conn.prepareStatement(updateSql);
                update.setString(1, hashMD5(newPassword));
                update.setInt(2, customerId);
                return update.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM Customer";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customer c = new Customer();
                c.setCustomerID(rs.getInt("customerID"));
                c.setFullname(rs.getString("fullname"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setRole(rs.getString("role"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // [khang] lấy account theo email
    public Account getAccountByEmail(String email) {
        String sql = "SELECT customerID, fullname, email, phone, role, status "
                   + "FROM Customer WHERE email = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Account(
                    rs.getInt("customerID"),
                    rs.getString("fullname"),
                    rs.getString("email"),
                    rs.getString("phone") != null ? rs.getString("phone") : "",
                    "customer",
                    rs.getString("status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // [dat] cập nhật trạng thái của người dùng
    public boolean toggleCustomerStatus(int customerID, String status) {
        String sql = "UPDATE Customer SET status = ? WHERE customerID = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, customerID);
            int rows = ps.executeUpdate();
            System.out.println("customerID = " + customerID);
            System.out.println("status = " + status);
            System.out.println("rows = " + rows);
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // [dat] thêm phân trang
    public int countCustomers() {
        String sql = "SELECT COUNT(*) FROM Customer";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Customer> getCustomersPaging(int offset, int pageSize) {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM ("
                + " SELECT *, ROW_NUMBER() OVER(ORDER BY customerID DESC) AS rn "
                + " FROM Customer "
                + ") t "
                + "WHERE rn > ? AND rn <= ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, offset + pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Customer c = new Customer();
                c.setCustomerID(rs.getInt("customerID"));
                c.setFullname(rs.getString("fullname"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setRole(rs.getString("role"));
                c.setStatus(rs.getString("status"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}