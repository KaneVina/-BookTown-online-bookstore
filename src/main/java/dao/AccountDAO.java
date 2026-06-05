/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBContext;
import utils.HashMD5;
import model.Account;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

/**
 *
 * @author PHUC KHANG
 */
public class AccountDAO {

    public Account checkLogin(String email, String password) {
        String hashedPassword = HashMD5.hash(password);
        DBContext db = new DBContext();

        // Kiểm tra bảng Customer
        String sqlCustomer = "SELECT customerID, fullname, email, phone, role, status "
                + "FROM Customer WHERE email = ? AND password = ? AND status = 'active'";
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlCustomer)) {
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
        try (Connection conn = db.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlAccount)) {
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
}
