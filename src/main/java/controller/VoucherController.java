/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.VoucherDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import model.Account;

/**
 *
 * @author PHUC KHANG
 */
public class VoucherController extends HttpServlet {

    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!hasAccess(request, response)) {
            return;
        }

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        // Pagination
        int pageSize = 10;
        int currentPage = 1;
        try {
            String p = request.getParameter("page");
            if (p != null) {
                currentPage = Math.max(1, Integer.parseInt(p));
            }
        } catch (Exception ignored) {
        }

        int totalRecords = voucherDAO.countFiltered(keyword, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        int offset = (currentPage - 1) * pageSize;

        // Set attributes
        request.setAttribute("voucherList", voucherDAO.getAllVouchers(keyword, status, offset, pageSize));
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        String baseUrl = request.getContextPath()
                + "/dashboard/voucher-management?keyword=" + (keyword != null ? keyword : "")
                + "&status=" + (status != null ? status : "");
        request.setAttribute("baseUrl", baseUrl);

        // Thống kê
        request.setAttribute("totalVouchers", voucherDAO.countTotal());
        request.setAttribute("activeVouchers", voucherDAO.countActive());
        request.setAttribute("expiredVouchers", voucherDAO.countExpired());
        request.setAttribute("totalUsed", voucherDAO.countTotalUsed());

        // Forward — phải là dòng CUỐI CÙNG
        request.getRequestDispatcher("/views/admin/voucher/voucher-management.jsp")
                .forward(request, response);
    }

    // ---- POST: thêm / sửa / xóa / toggle ----
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!hasAccess(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            switch (action == null ? "" : action) {

                case "add":
                    handleAdd(request, response);
                    break;

                case "edit":
                    handleEdit(request, response);
                    break;

                case "delete":
                    handleDelete(request, response);
                    break;

                case "toggle":
                    handleToggle(request, response);
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Đã xảy ra lỗi, vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
        }
    }

    // ---- Thêm voucher ----
    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String code = request.getParameter("code");
        String discountStr = request.getParameter("discountPercent");
        String quantityStr = request.getParameter("quantity");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        boolean statusToggle = "on".equals(request.getParameter("statusToggle"));
        String status = statusToggle ? "active" : "inactive";

        double discount = 0;
        try {
            discount = Double.parseDouble(discountStr);
        } catch (Exception ignored) {
        }

        Integer quantity = null;
        try {
            int q = Integer.parseInt(quantityStr);
            if (q > 0) {
                quantity = q;
            }
        } catch (Exception ignored) {
        }

        Timestamp startDate = parseDate(startDateStr);
        Timestamp endDate = parseDate(endDateStr);

        boolean ok = voucherDAO.addVoucher(code, discount, quantity, startDate, endDate, status);

        setFlashMessage(request, ok,
                "Thêm voucher " + code.toUpperCase() + " thành công!",
                "Thêm voucher thất bại, mã code có thể đã tồn tại.");

        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    // ---- Sửa voucher ----
    private void handleEdit(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int voucherID = parseInt(request.getParameter("voucherID"), 0);
        String code = request.getParameter("code");
        String discountStr = request.getParameter("discountPercent");
        String quantityStr = request.getParameter("quantity");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        boolean statusToggle = "on".equals(request.getParameter("statusToggle"));
        String status = statusToggle ? "active" : "inactive";

        double discount = 0;
        try {
            discount = Double.parseDouble(discountStr);
        } catch (Exception ignored) {
        }

        Integer quantity = null;
        try {
            int q = Integer.parseInt(quantityStr);
            if (q > 0) {
                quantity = q;
            }
        } catch (Exception ignored) {
        }

        Timestamp startDate = parseDate(startDateStr);
        Timestamp endDate = parseDate(endDateStr);

        boolean ok = voucherDAO.updateVoucher(voucherID, code, discount, quantity, startDate, endDate, status);

        setFlashMessage(request, ok,
                "Cập nhật voucher thành công!",
                "Cập nhật voucher thất bại.");

        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    // ---- Xóa voucher ----
    private void handleDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int voucherID = parseInt(request.getParameter("voucherID"), 0);
        boolean ok = voucherDAO.deleteVoucher(voucherID);

        setFlashMessage(request, ok,
                "Xóa voucher thành công!",
                "Xóa voucher thất bại.");

        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    // ---- Toggle status ----
    private void handleToggle(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int voucherID = parseInt(request.getParameter("voucherID"), 0);
        String newStatus = request.getParameter("newStatus");

        boolean ok = voucherDAO.toggleStatus(voucherID, newStatus);

        String msg = "active".equals(newStatus) ? "Đã kích hoạt voucher." : "Đã vô hiệu hóa voucher.";
        setFlashMessage(request, ok, msg, "Thao tác thất bại.");

        response.sendRedirect(request.getContextPath() + "/dashboard/voucher-management");
    }

    // ---- Helpers ----
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
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            return new Timestamp(sdf.parse(dateStr).getTime());
        } catch (Exception e) {
            return null;
        }
    }

    private int parseInt(String s, int defaultVal) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return defaultVal;
        }
    }

    private void setFlashMessage(HttpServletRequest request, boolean ok,
            String successMsg, String errorMsg) {
        HttpSession session = request.getSession();
        if (ok) {
            session.setAttribute("successMessage", successMsg);
        } else {
            session.setAttribute("errorMessage", errorMsg);
        }
    }

}
