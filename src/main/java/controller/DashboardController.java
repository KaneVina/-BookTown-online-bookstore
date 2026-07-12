package controller;

import dao.DashboardDAO;
import dao.GenreDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;
import model.Account;
import model.Genre;

public class DashboardController extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final GenreDAO genreDAO = new GenreDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminOrStaff(request, response)) {
            return;
        }

        String fromDate = trimToNull(request.getParameter("fromDate"));
        String toDate = trimToNull(request.getParameter("toDate"));
        Integer genreID = parseGenreID(request.getParameter("genreID"));

        String dateError = validateDateRange(fromDate, toDate);
        if (dateError != null) {
            request.setAttribute("dateError", dateError);
            fromDate = null;
            toDate = null;
        }

        BigDecimal totalRevenue = dashboardDAO.getTotalRevenue(fromDate, toDate, genreID);
        int totalOrders = dashboardDAO.getTotalOrders(fromDate, toDate, genreID);
        int totalCustomers = dashboardDAO.getTotalCustomers(fromDate, toDate, genreID);
        int totalBooks = dashboardDAO.getTotalBooks(genreID);
        int totalSoldBooks = dashboardDAO.getTotalSoldBooks(fromDate, toDate, genreID);
        Map<String, Integer> statusSummary = dashboardDAO.getOrderStatusSummary(fromDate, toDate, genreID);
        List<Map<String, Object>> revenueByCategory = dashboardDAO.getRevenueByCategory(fromDate, toDate, genreID);
        addRevenuePercentages(revenueByCategory);
        List<Map<String, Object>> topSellingBooks = dashboardDAO.getTopSellingBooks(fromDate, toDate, genreID);
        List<Map<String, Object>> recentOrders = dashboardDAO.getRecentOrders(fromDate, toDate, genreID);
        List<Genre> genres = genreDAO.getAllGenres();

        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalCustomers", totalCustomers);
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalSoldBooks", totalSoldBooks);
        request.setAttribute("statusSummary", statusSummary);
        request.setAttribute("revenueByCategory", revenueByCategory);
        request.setAttribute("topSellingBooks", topSellingBooks);
        request.setAttribute("recentOrders", recentOrders);
        request.setAttribute("genres", genres);
        request.setAttribute("fromDate", fromDate);
        request.setAttribute("toDate", toDate);
        request.setAttribute("selectedGenreID", genreID);

        request.getRequestDispatcher("/views/admin/dashboard/dashboard.jsp").forward(request, response);
    }

    private String validateDateRange(String fromDate, String toDate) {
        try {
            LocalDate from = fromDate == null ? null : LocalDate.parse(fromDate);
            LocalDate to = toDate == null ? null : LocalDate.parse(toDate);
            if (from != null && to != null && from.isAfter(to)) {
                return "Ngày bắt đầu không được lớn hơn ngày kết thúc.";
            }
            return null;
        } catch (DateTimeParseException e) {
            return "Định dạng ngày không hợp lệ.";
        }
    }

    private void addRevenuePercentages(List<Map<String, Object>> rows) {
        BigDecimal max = BigDecimal.ZERO;
        for (Map<String, Object> row : rows) {
            Object value = row.get("revenue");
            if (value instanceof BigDecimal && ((BigDecimal) value).compareTo(max) > 0) {
                max = (BigDecimal) value;
            }
        }

        for (Map<String, Object> row : rows) {
            BigDecimal revenue = row.get("revenue") instanceof BigDecimal
                    ? (BigDecimal) row.get("revenue") : BigDecimal.ZERO;
            int percentage = max.signum() == 0 ? 0
                    : revenue.multiply(BigDecimal.valueOf(100))
                            .divide(max, 0, RoundingMode.HALF_UP).intValue();
            row.put("percentage", Math.max(0, Math.min(100, percentage)));
        }
    }

    private boolean isAdminOrStaff(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Account account = session == null ? null : (Account) session.getAttribute("account");

        if (account == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        String role = account.getRole();
        if (!"admin".equalsIgnoreCase(role) && !"staff".equalsIgnoreCase(role)) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }
        return true;
    }

    private Integer parseGenreID(String raw) {
        try {
            if (raw == null || raw.trim().isEmpty() || "0".equals(raw.trim())) {
                return null;
            }
            return Integer.parseInt(raw.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private String trimToNull(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        return value.trim();
    }
}
