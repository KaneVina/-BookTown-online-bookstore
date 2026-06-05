/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBContext;
import utils.HashMD5;
import java.sql.Connection;
import java.sql.PreparedStatement;

/**
 *
 * @author PHUC KHANG
 */
public class CustomerDAO {

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
    public boolean registerCustomer(String fullname, String email, String phone, String password) {
        String sql = "INSERT INTO Customer (fullname, email, password, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullname);
            ps.setString(2, email);
            ps.setString(3, HashMD5.hash(password));
            ps.setString(4, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("REGISTER ERROR: " + e.getMessage());
        }
        return false;
    }
}
