package dao;

import model.Voucher;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * @author PHUC KHANG
 */
public class VoucherDAO {
    private String buildWhere(String keyword, String status) {
        StringBuilder where = new StringBuilder("WHERE 1=1 ");
        if (keyword != null && !keyword.trim().isEmpty()) {
            where.append("AND v.code LIKE ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            if ("expired".equals(status)) {
                where.append("AND v.end_date < GETDATE() ");
            } else {
                where.append("AND v.status = ? ");
            }
        }
        return where.toString();
    }

    private int bindParams(PreparedStatement ps, String keyword, String status, int idx)
            throws SQLException {
        if (keyword != null && !keyword.trim().isEmpty()) {
            ps.setString(idx++, "%" + keyword.trim() + "%");
        }
        if (status != null && !status.trim().isEmpty() && !"expired".equals(status)) {
            ps.setString(idx++, status);
        }
        return idx;
    }

    public List<Voucher> getAllVouchers(String keyword, String status, int offset, int pageSize) {
        List<Voucher> list = new ArrayList<>();

        String sql = "SELECT * FROM ("
                + "  SELECT v.voucherID, v.code, v.discount_percent, v.quantity, "
                + "         v.start_date, v.end_date, v.status, "
                + "         COUNT(cv.customerVoucherID) AS usedCount, "
                + "         ROW_NUMBER() OVER (ORDER BY v.voucherID DESC) AS rn "
                + "  FROM Voucher v "
                + "  LEFT JOIN CustomerVoucher cv ON v.voucherID = cv.voucherID AND cv.is_used = 1 "
                + buildWhere(keyword, status)
                + "  GROUP BY v.voucherID, v.code, v.discount_percent, v.quantity, "
                + "           v.start_date, v.end_date, v.status"
                + ") t WHERE t.rn > ? AND t.rn <= ?";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            int idx = bindParams(ps, keyword, status, 1);
            ps.setInt(idx++, offset);
            ps.setInt(idx,   offset + pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Voucher> getAllVouchers(String keyword, String status) {
        List<Voucher> list = new ArrayList<>();

        String sql = "SELECT v.voucherID, v.code, v.discount_percent, v.quantity, "
                + "v.start_date, v.end_date, v.status, "
                + "COUNT(cv.customerVoucherID) AS usedCount "
                + "FROM Voucher v "
                + "LEFT JOIN CustomerVoucher cv ON v.voucherID = cv.voucherID AND cv.is_used = 1 "
                + buildWhere(keyword, status)
                + "GROUP BY v.voucherID, v.code, v.discount_percent, v.quantity, "
                + "v.start_date, v.end_date, v.status "
                + "ORDER BY v.voucherID DESC";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            bindParams(ps, keyword, status, 1);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }


    public int countFiltered(String keyword, String status) {
        String sql = "SELECT COUNT(*) FROM Voucher v " + buildWhere(keyword, status);
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            bindParams(ps, keyword, status, 1);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean addVoucher(String code, double discountPercent, Integer quantity,
                              Timestamp startDate, Timestamp endDate, String status) {
        String sql = "INSERT INTO Voucher (code, discount_percent, quantity, start_date, end_date, status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code.toUpperCase().trim());
            ps.setDouble(2, discountPercent);
            if (quantity != null && quantity > 0) ps.setInt(3, quantity);
            else                                   ps.setNull(3, Types.INTEGER);
            ps.setTimestamp(4, startDate);
            ps.setTimestamp(5, endDate);
            ps.setString(6, status);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateVoucher(int voucherID, String code, double discountPercent,
                                 Integer quantity, Timestamp startDate, Timestamp endDate,
                                 String status) {
        String sql = "UPDATE Voucher SET code=?, discount_percent=?, quantity=?, "
                + "start_date=?, end_date=?, status=? WHERE voucherID=?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, code.toUpperCase().trim());
            ps.setDouble(2, discountPercent);
            if (quantity != null && quantity > 0) ps.setInt(3, quantity);
            else                                   ps.setNull(3, Types.INTEGER);
            ps.setTimestamp(4, startDate);
            ps.setTimestamp(5, endDate);
            ps.setString(6, status);
            ps.setInt(7, voucherID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }


    public boolean deleteVoucher(int voucherID) {
        String deleteCv = "DELETE FROM CustomerVoucher WHERE voucherID = ?";
        String deleteV  = "DELETE FROM Voucher WHERE voucherID = ?";
        try (Connection conn = new DBContext().getConnection()) {
            conn.setAutoCommit(false);
            try {
                PreparedStatement ps1 = conn.prepareStatement(deleteCv);
                ps1.setInt(1, voucherID);
                ps1.executeUpdate();

                PreparedStatement ps2 = conn.prepareStatement(deleteV);
                ps2.setInt(1, voucherID);
                ps2.executeUpdate();

                conn.commit();
                return true;
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean toggleStatus(int voucherID, String newStatus) {
        String sql = "UPDATE Voucher SET status=? WHERE voucherID=?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, voucherID);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

 
    public int countTotal() {
        return countBySQL("SELECT COUNT(*) FROM Voucher");
    }

    public int countActive() {
        return countBySQL("SELECT COUNT(*) FROM Voucher WHERE status='active' AND (end_date IS NULL OR end_date >= GETDATE())");
    }

    public int countExpired() {
        return countBySQL("SELECT COUNT(*) FROM Voucher WHERE end_date < GETDATE()");
    }

    public int countTotalUsed() {
        return countBySQL("SELECT COUNT(*) FROM CustomerVoucher WHERE is_used = 1");
    }

    private int countBySQL(String sql) {
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


    private Voucher mapRow(ResultSet rs) throws SQLException {
        return new Voucher(
                rs.getInt("voucherID"),
                rs.getString("code"),
                rs.getDouble("discount_percent"),
                rs.getObject("quantity") != null ? rs.getInt("quantity") : null,
                rs.getTimestamp("start_date"),
                rs.getTimestamp("end_date"),
                rs.getString("status"),
                rs.getInt("usedCount")
        );
    }
}