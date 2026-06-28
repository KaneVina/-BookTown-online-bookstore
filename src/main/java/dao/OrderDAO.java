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

    private static final String BASE_SELECT_ORDER
            = "SELECT o.orderID, o.customerID, o.addressID, o.processed_by, o.status, "
            + "       o.payment_method, o.payment_status, o.total_price, o.created_at, "
            + "       a.street, a.district, a.city "
            + "FROM [Order] o "
            + "LEFT JOIN Address a ON a.addressID = o.addressID ";


    public int createOrder(int customerID, int addressID,
            String paymentMethod, BigDecimal totalPrice) {

        String sql = "INSERT INTO [Order] (customerID, addressID, status, payment_method, "
                + "payment_status, total_price, created_at) "
                + "VALUES (?, ?, N'pending', ?, ?, ?, GETDATE())";

        String paymentStatus = "unpaid";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {

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

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

      String sqlCloseCart = "UPDATE Cart SET status = 'checked_out' "
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
        String sql = "SELECT o.orderID, o.customerID, o.addressID, o.processed_by, o.status, "
                + "       o.payment_method, o.payment_status, o.total_price, o.created_at, "
                + "       a.street, a.district, a.city, c.fullname AS customerName, "
                + "       c.email AS customerEmail, c.phone AS customerPhone "
                + "FROM [Order] o "
                + "LEFT JOIN Address a ON a.addressID = o.addressID "
                + "LEFT JOIN Customer c ON c.customerID = o.customerID "
                + "WHERE o.orderID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setCustomerName(rs.getString("customerName"));
                    order.setCustomerEmail(rs.getString("customerEmail"));
                    order.setCustomerPhone(rs.getString("customerPhone"));
                    return order;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public int countOrdersByCustomer(int customerID) {
        String sql = "SELECT COUNT(*) FROM [Order] WHERE customerID = ?";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

    public int countOrdersByCustomerFiltered(int customerID, String status) {
        boolean filterStatus = status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status);
        String sql = "SELECT COUNT(*) FROM [Order] WHERE customerID = ?"
                + (filterStatus ? " AND status = ?" : "");

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            if (filterStatus) {
                ps.setString(2, status.trim());
            }
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

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

    public List<Order> getOrdersByCustomerFiltered(int customerID, String status, int offset, int pageSize) {
        List<Order> orders = new ArrayList<>();
        boolean filterStatus = status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status);

        String sql = BASE_SELECT_ORDER
                + "WHERE o.customerID = ? "
                + (filterStatus ? "AND o.status = ? " : "")
                + "ORDER BY o.created_at DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, customerID);
            if (filterStatus) {
                ps.setString(idx++, status.trim());
            }
            ps.setInt(idx++, offset);
            ps.setInt(idx, pageSize);
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

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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
        int processedByVal = rs.getInt("processed_by");
        if (!rs.wasNull()) {
            order.setProcessedBy(processedByVal);
        } else {
            order.setProcessedBy(null);
        }
        return order;
    }

    // Cập nhật trạng thái thanh toán
    public boolean updatePaymentStatus(int orderID, String paymentStatus) {
        String sql = "UPDATE [Order] SET payment_status = ? WHERE orderID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, paymentStatus);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Cập nhật trạng thái đơn hàng (dùng cho VNPAY confirm)
    public boolean updateOrderStatus(int orderID, String status) {
        String sql = "UPDATE [Order] SET status = ? WHERE orderID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hủy đơn hàng do hệ thống (không cần kiểm tra customerID)
    public boolean cancelOrderBySystem(int orderID) {
        String sql = "UPDATE [Order] SET status = 'cancelled' WHERE orderID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa cart dựa vào orderID - dùng cho VNPAY callback
    public boolean clearCartByOrderID(int orderID) {
        // Bước 1: lấy customerID từ Order
        String sqlGetCustomer = "SELECT customerID FROM [Order] WHERE orderID = ?";
        int customerID = -1;
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlGetCustomer)) {
            ps.setInt(1, orderID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                customerID = rs.getInt("customerID");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }

        if (customerID == -1) {
            return false;
        }

        // Bước 2: gọi lại clearCart có sẵn
        return clearCart(customerID);
    }

    public List<Order> getAllOrders(String keyword, String status, int offset, int pageSize) {
        List<Order> list = new ArrayList<>();

        // Tự động hủy các đơn 'pending' quá 2 ngày trước khi lấy danh sách
        String sqlAutoCancel = "UPDATE [Order] SET status = N'cancelled' "
                + "WHERE status = N'pending' "
                + "AND created_at < DATEADD(DAY, -2, GETDATE())";
        try (Connection connCancel = new DBContext().getConnection();
             PreparedStatement psCancel = connCancel.prepareStatement(sqlAutoCancel)) {
            psCancel.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        StringBuilder sql = new StringBuilder(
            "SELECT o.orderID, o.customerID, o.addressID, o.processed_by, o.status, "
            + "       o.payment_method, o.payment_status, o.total_price, o.created_at, "
            + "       a.street, a.district, a.city, c.fullname AS customerName, "
            + "       c.email AS customerEmail, c.phone AS customerPhone "
            + "FROM [Order] o "
            + "LEFT JOIN Address a ON a.addressID = o.addressID "
            + "LEFT JOIN Customer c ON c.customerID = o.customerID "
            + "WHERE 1=1 "
        );
        
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (c.fullname LIKE ? OR c.phone LIKE ? OR CAST(o.orderID AS VARCHAR) LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND o.status = ? ");
            params.add(status.trim());
        }
        
        sql.append("ORDER BY o.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            ps.setInt(index++, offset);
            ps.setInt(index++, pageSize);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = mapOrder(rs);
                    order.setCustomerName(rs.getString("customerName"));
                    order.setCustomerEmail(rs.getString("customerEmail"));
                    order.setCustomerPhone(rs.getString("customerPhone"));
                    list.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countFilteredOrders(String keyword, String status) {
        StringBuilder sql = new StringBuilder(
            "SELECT COUNT(*) FROM [Order] o "
            + "LEFT JOIN Customer c ON c.customerID = o.customerID "
            + "WHERE 1=1 "
        );
        
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (c.fullname LIKE ? OR c.phone LIKE ? OR CAST(o.orderID AS VARCHAR) LIKE ?) ");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        if (status != null && !status.trim().isEmpty() && !"all".equalsIgnoreCase(status)) {
            sql.append("AND o.status = ? ");
            params.add(status.trim());
        }
        
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int index = 1;
            for (Object param : params) {
                ps.setObject(index++, param);
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countOrdersByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM [Order] WHERE status = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateOrderStatusAndStaff(int orderID, String status, int staffID) {
        String sql = "UPDATE [Order] SET status = ?, processed_by = ? WHERE orderID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, staffID);
            ps.setInt(3, orderID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
