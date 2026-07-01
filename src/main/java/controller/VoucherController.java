package controller;

import dao.VoucherDAO;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import model.Account;

public class VoucherController extends HttpServlet {

    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!hasAccess(request, response)) return;
        voucherDAO.autoExpireVouchers();

        String keyword = trimOrNull(request.getParameter("keyword"));
        String status  = trimOrNull(request.getParameter("status"));

        int pageSize    = 10;
        int currentPage = parseIntSafe(request.getParameter("page"), 1);
        if (currentPage < 1) currentPage = 1;

        int totalRecords = voucherDAO.countFiltered(keyword, status);
        int totalPages   = Math.max(1, (int) Math.ceil((double) totalRecords / pageSize));
        if (currentPage > totalPages) currentPage = totalPages;

        int offset = (currentPage - 1) * pageSize;

        request.setAttribute("voucherList",    voucherDAO.getAllVouchers(keyword, status, offset, pageSize));
        request.setAttribute("currentPage",    currentPage);
        request.setAttribute("totalPages",     totalPages);

        String encodedKeyword = keyword != null
                ? URLEncoder.encode(keyword, StandardCharsets.UTF_8.name()) : "";
        String encodedStatus  = status  != null
                ? URLEncoder.encode(status,  StandardCharsets.UTF_8.name()) : "";

        String baseUrl = request.getContextPath()
                + "/dashboard/voucher-management?keyword=" + encodedKeyword
                + "&status=" + encodedStatus;
        request.setAttribute("baseUrl", baseUrl);

        request.setAttribute("totalVouchers",   voucherDAO.countTotal());
        request.setAttribute("activeVouchers",  voucherDAO.countActive());
        request.setAttribute("expiredVouchers", voucherDAO.countExpired());
        request.setAttribute("totalUsed",       voucherDAO.countTotalUsed());

        request.getRequestDispatcher("/views/admin/voucher/voucher-management.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!hasAccess(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        try {
            switch (action == null ? "" : action) {
                case "add":    handleAdd(request, response);    break;
                case "edit":   handleEdit(request, response);   break;
                case "delete": handleDelete(request, response); break;
                case "toggle": handleToggle(request, response); break;
                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            }
        } catch (Exception e) {
            e.printStackTrace();
            setFlash(request, false, null, "Đã xảy ra lỗi, vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
        }
    }

    // ---------------------------------------------------------------
    // ADD — status luôn là "active", không nhận từ form
    // ---------------------------------------------------------------
    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        VoucherInput input = validateVoucherInput(request, true);
        if (input.errorMsg != null) {
            setFlash(request, false, null, input.errorMsg);
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            return;
        }

        boolean ok = voucherDAO.addVoucher(
                input.code, input.discount, input.quantity,
                input.startDate, input.endDate,
                "active",                          // luôn active khi tạo mới
                input.minOrderValue, input.maxDiscountValue);

        setFlash(request, ok,
                "Thêm voucher " + input.code.toUpperCase() + " thành công!",
                "Thêm voucher thất bại. Mã code có thể đã tồn tại.");
        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    // ---------------------------------------------------------------
    // EDIT — status lấy từ form (toggle)
    // ---------------------------------------------------------------
    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int voucherID = parseIntSafe(request.getParameter("voucherID"), 0);
        if (voucherID <= 0) {
            setFlash(request, false, null, "Voucher không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            return;
        }

        VoucherInput input = validateVoucherInput(request, false);
        if (input.errorMsg != null) {
            setFlash(request, false, null, input.errorMsg);
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            return;
        }

        boolean ok = voucherDAO.updateVoucher(
                voucherID, input.code, input.discount, input.quantity,
                input.startDate, input.endDate, input.status,
                input.minOrderValue, input.maxDiscountValue);

        setFlash(request, ok,
                "Cập nhật voucher thành công!",
                "Cập nhật thất bại. Mã code có thể đã tồn tại hoặc voucher không còn tồn tại.");
        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int voucherID = parseIntSafe(request.getParameter("voucherID"), 0);
        if (voucherID <= 0) {
            setFlash(request, false, null, "Voucher không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            return;
        }

        int result = voucherDAO.deleteVoucher(voucherID);
        switch (result) {
            case  1: setFlash(request, true,  "Xóa voucher thành công!", null); break;
            case -1: setFlash(request, false, null, "Không thể xóa voucher đã được khách hàng sử dụng."); break;
            default: setFlash(request, false, null, "Xóa voucher thất bại."); break;
        }
        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    private void handleToggle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int    voucherID = parseIntSafe(request.getParameter("voucherID"), 0);
        String newStatus = request.getParameter("newStatus");

        if (voucherID <= 0 || newStatus == null
                || (!newStatus.equals("active") && !newStatus.equals("inactive"))) {
            setFlash(request, false, null, "Yêu cầu không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            return;
        }

        boolean ok  = voucherDAO.toggleStatus(voucherID, newStatus);
        String  msg = "active".equals(newStatus) ? "Đã kích hoạt voucher." : "Đã vô hiệu hóa voucher.";
        setFlash(request, ok, msg, "Thao tác thất bại. Voucher có thể đã expired.");
        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    // ---------------------------------------------------------------
    // Input DTO
    // ---------------------------------------------------------------
    private static class VoucherInput {
        String    code;
        double    discount;
        Integer   quantity;
        Timestamp startDate;
        Timestamp endDate;
        String    status;
        Double    minOrderValue;
        Double    maxDiscountValue;
        String    errorMsg;
    }

    /**
     * @param isCreate true = form tạo mới (không đọc status, validate startDate >= hôm nay)
     *                 false = form chỉnh sửa (đọc status từ toggle)
     */
    private VoucherInput validateVoucherInput(HttpServletRequest request, boolean isCreate) {
        VoucherInput v = new VoucherInput();

        // --- Code ---
        String code = request.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            v.errorMsg = "Mã voucher không được để trống.";
            return v;
        }
        v.code = code.trim().toUpperCase();

        // --- Discount ---
        try {
            v.discount = Double.parseDouble(request.getParameter("discountPercent"));
        } catch (NumberFormatException e) {
            v.errorMsg = "Giá trị giảm giá không hợp lệ.";
            return v;
        }
        if (v.discount <= 0 || v.discount > 100) {
            v.errorMsg = "Giảm giá phải lớn hơn 0 và không vượt quá 100%.";
            return v;
        }

        // --- Quantity ---
        String quantityStr = request.getParameter("quantity");
        if (quantityStr != null && !quantityStr.trim().isEmpty()) {
            try {
                int q = Integer.parseInt(quantityStr.trim());
                if (q <= 0) {
                    v.errorMsg = "Số lượng phải lớn hơn 0. Để trống nếu không giới hạn.";
                    return v;
                }
                v.quantity = q;
            } catch (NumberFormatException e) {
                v.errorMsg = "Số lượng không hợp lệ.";
                return v;
            }
        }

        // --- Min order value ---
        String minOrderStr = request.getParameter("minOrderValue");
        if (minOrderStr != null && !minOrderStr.trim().isEmpty()) {
            try {
                double minVal = Double.parseDouble(minOrderStr.trim());
                if (minVal < 0) {
                    v.errorMsg = "Đơn hàng tối thiểu không được âm.";
                    return v;
                }
                v.minOrderValue = minVal;
            } catch (NumberFormatException e) {
                v.errorMsg = "Giá trị đơn hàng tối thiểu không hợp lệ.";
                return v;
            }
        }

        // --- Max discount value ---
        String maxDiscStr = request.getParameter("maxDiscountValue");
        if (maxDiscStr != null && !maxDiscStr.trim().isEmpty()) {
            try {
                double maxVal = Double.parseDouble(maxDiscStr.trim());
                if (maxVal <= 0) {
                    v.errorMsg = "Số tiền giảm tối đa phải lớn hơn 0. Để trống nếu không giới hạn.";
                    return v;
                }
                v.maxDiscountValue = maxVal;
            } catch (NumberFormatException e) {
                v.errorMsg = "Giá trị giảm tối đa không hợp lệ.";
                return v;
            }
        }

        // --- Dates ---
        v.startDate = parseDate(request.getParameter("startDate"));
        v.endDate   = parseDate(request.getParameter("endDate"));

        // Validate startDate >= hôm nay (chỉ khi tạo mới)
        if (isCreate && v.startDate != null) {
            Timestamp today = Timestamp.valueOf(LocalDate.now().atStartOfDay());
            if (v.startDate.before(today)) {
                v.errorMsg = "Ngày bắt đầu không được là ngày trong quá khứ.";
                return v;
            }
        }

        // startDate phải trước endDate
        if (v.startDate != null && v.endDate != null && !v.startDate.before(v.endDate)) {
            v.errorMsg = "Ngày bắt đầu phải trước ngày kết thúc.";
            return v;
        }

        // --- Status (chỉ edit mới đọc, create luôn active) ---
        if (!isCreate) {
            String statusParam = request.getParameter("status");
            if ("active".equals(statusParam) || "inactive".equals(statusParam)) {
                v.status = statusParam;
            } else {
                v.status = "on".equals(request.getParameter("statusToggle")) ? "active" : "inactive";
            }
        }

        return v;
    }

    // ---------------------------------------------------------------
    // Helpers
    // ---------------------------------------------------------------
    private boolean hasAccess(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        Account user = (Account) session.getAttribute("account");
        if (user == null || "customer".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private Timestamp parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) return null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            return new Timestamp(sdf.parse(dateStr.trim()).getTime());
        } catch (Exception e) {
            return null;
        }
    }

    private int parseIntSafe(String s, int defaultVal) {
        try { return Integer.parseInt(s); } catch (Exception e) { return defaultVal; }
    }

    private String trimOrNull(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        return s.trim();
    }

    private void setFlash(HttpServletRequest request, boolean ok,
                          String successMsg, String errorMsg) {
        HttpSession session = request.getSession();
        if (ok) {
            if (successMsg != null) session.setAttribute("successMessage", successMsg);
        } else {
            if (errorMsg   != null) session.setAttribute("errorMessage",   errorMsg);
        }
    }
}