package dao;

import model.CartItem;
import utils.DBContext;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public List<CartItem> getCartItems(int customerID) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT ci.cartItemID, ci.cartID, ci.bookID, ci.quantity, "
                + "b.title, b.thumbnail, b.price, "
                + "STRING_AGG(a.fullname, ', ') AS authors "
                + "FROM Cart c "
                + "JOIN CartItem ci ON ci.cartID = c.cartID "
                + "JOIN Book b ON b.bookID = ci.bookID "
                + "LEFT JOIN BookAuthor ba ON ba.bookID = b.bookID "
                + "LEFT JOIN Author a ON a.authorID = ba.authorID "
                + "WHERE c.customerID = ? AND c.status = 'active' "
                + "GROUP BY ci.cartItemID, ci.cartID, ci.bookID, ci.quantity, "
                + "b.title, b.thumbnail, b.price, ci.added_at "
                + "ORDER BY ci.added_at DESC";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartItemID(rs.getInt("cartItemID"));
                    item.setCartID(rs.getInt("cartID"));
                    item.setBookID(rs.getInt("bookID"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setTitle(rs.getString("title"));
                    item.setThumbnail(rs.getString("thumbnail"));
                    item.setPrice(rs.getBigDecimal("price"));
                    String authors = rs.getString("authors");
                    item.setAuthorsDisplay(authors != null ? authors : "Dang cap nhat");
                    items.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }

    /**
     * Lấy cartID của customer. Nếu chưa có thì tạo mới.
     */
    public int getOrCreateCart(int customerID) {
        // Tìm cart active
        String sqlFind = "SELECT cartID FROM Cart WHERE customerID = ? AND status = 'active'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlFind)) {
            ps.setInt(1, customerID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("cartID");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Chưa có → tạo mới
        String sqlInsert = "INSERT INTO Cart (customerID, status) VALUES (?, 'active')";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlInsert, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, customerID);
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

    /**
     * Thêm sách vào giỏ. Nếu sách đã có trong giỏ thì cộng thêm quantity.
     */
    public boolean addToCart(int customerID, int bookID, int quantity) {
        int cartID = getOrCreateCart(customerID);
        if (cartID == -1) {
            return false;
        }

        // Kiểm tra sách đã có trong giỏ chưa
        String sqlCheck = "SELECT cartItemID, quantity FROM CartItem WHERE cartID = ? AND bookID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sqlCheck)) {
            ps.setInt(1, cartID);
            ps.setInt(2, bookID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                // Đã có → update quantity
                int newQty = rs.getInt("quantity") + quantity;
                String sqlUpdate = "UPDATE CartItem SET quantity = ? WHERE cartItemID = ?";
                try (PreparedStatement ps2 = conn.prepareStatement(sqlUpdate)) {
                    ps2.setInt(1, newQty);
                    ps2.setInt(2, rs.getInt("cartItemID"));
                    return ps2.executeUpdate() > 0;
                }
            } else {
                // Chưa có → insert mới
                String sqlInsert = "INSERT INTO CartItem (cartID, bookID, quantity) VALUES (?, ?, ?)";
                try (PreparedStatement ps2 = conn.prepareStatement(sqlInsert)) {
                    ps2.setInt(1, cartID);
                    ps2.setInt(2, bookID);
                    ps2.setInt(3, quantity);
                    return ps2.executeUpdate() > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int countCartItems(int customerID) {
        String sql = "SELECT COUNT(*) FROM CartItem ci "
                + "JOIN Cart c ON c.cartID = ci.cartID "
                + "WHERE c.customerID = ? AND c.status = 'active'";
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

    public BigDecimal calcSubtotal(List<CartItem> items) {
        return items.stream()
                .map(CartItem::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }
    // Cập nhật số lượng

    public boolean updateQuantity(int cartItemID, int newQty) {
        String sql = "UPDATE CartItem SET quantity = ? WHERE cartItemID = ?";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, newQty);
            ps.setInt(2, cartItemID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

// Xóa 1 item — có kiểm tra cartID thuộc về customer để tránh giả mạo
    public boolean removeItem(int cartItemID, int customerID) {
        String sql = "DELETE CartItem FROM CartItem "
                + "JOIN Cart ON Cart.cartID = CartItem.cartID "
                + "WHERE CartItem.cartItemID = ? AND Cart.customerID = ? AND Cart.status = 'active'";
        try (Connection conn = new DBContext().getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, cartItemID);
            ps.setInt(2, customerID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
