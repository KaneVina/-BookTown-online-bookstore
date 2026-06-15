package dao;

import model.CartItem;
import model.Order;
import model.OrderDetail;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private static final String BASE_SELECT_ORDER =
            "SELECT o.orderID, o.customerID, o.addressID, o.processed_by, o.status, "
          + "       o.payment_method, o.payment_status, o.total_price, o.created_at, "
          + "       a.street, a.district, a.city "
          + "FROM [Order] o "
          + "LEFT JOIN Address a ON a.addressID = o.addressID ";

    public int createTempAddress(int customerID, String street, String district, String city) {
        String sql = "INSERT INTO Address (customerID, street, district, city, country, is_default) "
                   + "VALUES (?, ?, ?, ?, N'Việt Nam', 0)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, customerID);
            ps.setString(2, street);
            ps.setString(3, district);
            ps.setString(4, city);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public int createOrder(int customerID, int addressID,
                           String paymentMethod, BigDecimal totalPrice) {

        String sql = "INSERT INTO [Order] (customerID, addressID, status, payment_method, "
                   + "payment_status, total_price, created_at) "
                   + "VALUES (?, ?, N'pending', ?, ?, ?, GETDATE())";

        String paymentStatus = "unpaid";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, customerID);
            ps.setInt(2, addressID);
            ps.setString(3, paymentMethod);
            ps.setString(4, paymentStatus);
            ps.setBigDecimal(5, totalPrice);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public boolean createOrderDetails(int orderID, List<CartItem> cartItems) {
        String sql = "INSERT INTO OrderDetail (orderID, bookID, quantity, unit_price) "
                   + "VALUES (?, ?, ?, ?)";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (CartItem item : cartItems) {
                ps.setInt(1, orderID);
                ps.setInt(2, item.getBookID());
                ps.setInt(3, item.getQuantity());
                ps.setBigDecimal(4, item.getPrice());
                ps.addBatch();
            }

            ps.executeBatch();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean clearCart(int customerID) {
        String sqlDeleteItems = "DELETE CartItem FROM CartItem "
                + "JOIN Cart ON Cart.cartID = CartItem.cartID "
                + "WHERE Cart.customerID = ? AND Cart.status = 'active'";

        String sqlCloseCart = "UPDATE Cart SET status = 'completed' "
                + "WHERE customerID = ? AND status = 'active'";

        try (Connection conn = new DBContext().getConnection()) {

            try (PreparedStatement ps = conn.prepareStatement(sqlDeleteItems)) {
                ps.setInt(1, customerID);
                ps.executeUpdate();
            }

            try (PreparedStatement ps = conn.prepareStatement(sqlCloseCart)) {
                ps.setInt(1, customerID);
                ps.executeUpdate();
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Order getOrderByID(int orderID) {
        String sql = BASE_SELECT_ORDER + "WHERE o.orderID = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return mapOrder(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public int countOrdersByCustomer(int customerID) {
        String sql = "SELECT COUNT(*) FROM [Order] WHERE customerID = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<Order> getOrdersByCustomer(int customerID, int offset, int pageSize) {
        List<Order> orders = new ArrayList<>();

        String sql = BASE_SELECT_ORDER
                   + "WHERE o.customerID = ? "
                   + "ORDER BY o.created_at DESC "
                   + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerID);
            ps.setInt(2, offset);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                orders.add(mapOrder(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return orders;
    }

    public List<OrderDetail> getOrderDetails(int orderID) {
        List<OrderDetail> details = new ArrayList<>();

        String sql = "SELECT od.orderDetailID, od.orderID, od.bookID, od.quantity, od.unit_price, "
                   + "       b.title, b.thumbnail "
                   + "FROM OrderDetail od "
                   + "JOIN Book b ON b.bookID = od.bookID "
                   + "WHERE od.orderID = ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetail d = new OrderDetail();
                d.setOrderDetailID(rs.getInt("orderDetailID"));
                d.setOrderID(rs.getInt("orderID"));
                d.setBookID(rs.getInt("bookID"));
                d.setQuantity(rs.getInt("quantity"));
                d.setUnitPrice(rs.getBigDecimal("unit_price"));
                d.setTitle(rs.getString("title"));
                d.setThumbnail(rs.getString("thumbnail"));
                details.add(d);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return details;
    }

    public boolean cancelOrder(int orderID, int customerID) {
        String sql = "UPDATE [Order] SET status = 'cancelled' "
                   + "WHERE orderID = ? AND customerID = ? AND status = 'pending'";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            ps.setInt(2, customerID);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private Order mapOrder(ResultSet rs) throws Exception {
        Order order = new Order();
        order.setOrderID(rs.getInt("orderID"));
        order.setCustomerID(rs.getInt("customerID"));
        order.setAddressID(rs.getInt("addressID"));
        order.setStatus(rs.getString("status"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setPaymentStatus(rs.getString("payment_status"));
        order.setTotalPrice(rs.getBigDecimal("total_price"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setStreet(rs.getString("street"));
        order.setDistrict(rs.getString("district"));
        order.setCity(rs.getString("city"));
        return order;
    }
}