package dao;

import java.sql.*;
import java.util.*;
import model.Address;
import utils.DBContext;

public class AddressDAO {

    DBContext db = new DBContext();

    public List<Address> getAllAddresses() {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT addressID, customerID, street, district, city, country, is_default FROM Address ORDER BY addressID DESC";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(new Address(
                        rs.getInt("addressID"),
                        rs.getInt("customerID"),
                        rs.getString("street"),
                        rs.getString("district"),
                        rs.getString("city"),
                        rs.getString("country"),
                        rs.getBoolean("is_default")
                ));
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Address getAddressById(int id) {
        String sql = "SELECT addressID, customerID, street, district, city, country, is_default FROM Address WHERE addressID=?";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Address a = new Address(
                        rs.getInt("addressID"),
                        rs.getInt("customerID"),
                        rs.getString("street"),
                        rs.getString("district"),
                        rs.getString("city"),
                        rs.getString("country"),
                        rs.getBoolean("is_default")
                );
                conn.close();
                return a;
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void insertAddress(Address a) {
        String sql = "INSERT INTO Address(customerID, street, district, city, country, is_default) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, a.getCustomerID());
            ps.setString(2, a.getStreet());
            ps.setString(3, a.getDistrict());
            ps.setString(4, a.getCity());
            ps.setString(5, a.getCountry());
            ps.setBoolean(6, a.isDefault());

            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateAddress(Address a) {
        String sql = "UPDATE Address SET customerID=?, street=?, district=?, city=?, country=?, is_default=? WHERE addressID=?";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, a.getCustomerID());
            ps.setString(2, a.getStreet());
            ps.setString(3, a.getDistrict());
            ps.setString(4, a.getCity());
            ps.setString(5, a.getCountry());
            ps.setBoolean(6, a.isDefault());
            ps.setInt(7, a.getAddressID());

            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteAddress(int id) {
        String sql = "DELETE FROM Address WHERE addressID=?";

        try {
            Connection conn = db.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void setDefaultAddress(int addressID, int customerID) {
        String sql1 = "UPDATE Address SET is_default=0 WHERE customerID=?";
        String sql2 = "UPDATE Address SET is_default=1 WHERE addressID=?";

        try {
            Connection conn = db.getConnection();

            PreparedStatement ps1 = conn.prepareStatement(sql1);
            ps1.setInt(1, customerID);
            ps1.executeUpdate();

            PreparedStatement ps2 = conn.prepareStatement(sql2);
            ps2.setInt(1, addressID);
            ps2.executeUpdate();

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public List<Address> getAddressesByCustomerId(int customerID) {
    List<Address> list = new ArrayList<>();

    String sql = "SELECT addressID, customerID, street, district, city, country, is_default "
            + "FROM Address "
            + "WHERE customerID = ? "
            + "ORDER BY is_default DESC, addressID DESC";

    try {
        Connection conn = db.getConnection();
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, customerID);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            list.add(new Address(
                    rs.getInt("addressID"),
                    rs.getInt("customerID"),
                    rs.getString("street"),
                    rs.getString("district"),
                    rs.getString("city"),
                    rs.getString("country"),
                    rs.getBoolean("is_default")
            ));
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    return list;
}
    public int insertAddressAndReturnId(Address a) {
    String sql = "INSERT INTO Address(customerID, street, district, city, country, is_default) "
            + "VALUES (?, ?, ?, ?, ?, ?)";

    try {
        Connection conn = db.getConnection();

        if (a.isDefault()) {
            PreparedStatement reset = conn.prepareStatement(
                    "UPDATE Address SET is_default = 0 WHERE customerID = ?"
            );
            reset.setInt(1, a.getCustomerID());
            reset.executeUpdate();
            reset.close();
        }

        PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);

        ps.setInt(1, a.getCustomerID());
        ps.setString(2, a.getStreet());
        ps.setString(3, a.getDistrict());
        ps.setString(4, a.getCity());
        ps.setString(5, a.getCountry());
        ps.setBoolean(6, a.isDefault());

        ps.executeUpdate();

        ResultSet rs = ps.getGeneratedKeys();

        if (rs.next()) {
            int id = rs.getInt(1);
            conn.close();
            return id;
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

    return -1;
}
}