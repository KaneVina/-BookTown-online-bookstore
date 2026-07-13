package controller;

<<<<<<< HEAD
import dao.AccountDAO;
import dao.BookDAO;
import dao.DashboardDAO;
import dao.GenreDAO;
=======
import dao.BookDAO;
import dao.AccountDAO;
>>>>>>> main
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Book;
import model.Genre;

import java.io.IOException;
<<<<<<< HEAD
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Map;

public class DashboardController extends HttpServlet {

    private final DashboardDAO dashboardDAO = new DashboardDAO();
    private final GenreDAO genreDAO = new GenreDAO();
=======
import java.util.List;

public class DashboardController extends HttpServlet {

>>>>>>> main
    private final BookDAO bookDAO = new BookDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
<<<<<<< HEAD
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

        // Code mới: số liệu bán hàng, lọc ngày và lọc thể loại.
        BigDecimal totalRevenue = dashboardDAO.getTotalRevenue(fromDate, toDate, genreID);
        int totalOrders = dashboardDAO.getTotalOrders(fromDate, toDate, genreID);
        int totalCustomers = dashboardDAO.getTotalCustomers(fromDate, toDate, genreID);
        int totalBooks = dashboardDAO.getTotalBooks(genreID);
        int totalSoldBooks = dashboardDAO.getTotalSoldBooks(fromDate, toDate, genreID);
        Map<String, Integer> statusSummary = dashboardDAO.getOrderStatusSummary(
                fromDate, toDate, genreID);
        List<Map<String, Object>> revenueByCategory = dashboardDAO.getRevenueByCategory(
                fromDate, toDate, genreID);
        addRevenuePercentages(revenueByCategory);
        List<Map<String, Object>> topSellingBooks = dashboardDAO.getTopSellingBooks(
                fromDate, toDate, genreID);
        List<Map<String, Object>> recentOrders = dashboardDAO.getRecentOrders(
                fromDate, toDate, genreID);
        List<Genre> genres = genreDAO.getAllGenres();

        // Giữ code cũ: thống kê kho sách và nhân viên.
        int allBooks = bookDAO.countAllBooks();
        int availableBooks = bookDAO.countBooksByStatus("available");
        int outOfStockBooks = bookDAO.countBooksByStatus("out_of_stock");
        int discontinuedBooks = bookDAO.countBooksByStatus("discontinued");
        List<Book> recentBooks = bookDAO.getRecentBooksAdmin(8);
        int totalStaffs = accountDAO.countStaffs();

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

        request.setAttribute("allBooks", allBooks);
        request.setAttribute("availableBooks", availableBooks);
        request.setAttribute("outOfStockBooks", outOfStockBooks);
        request.setAttribute("discontinuedBooks", discontinuedBooks);
        request.setAttribute("recentBooks", recentBooks);
        request.setAttribute("totalStaffs", totalStaffs);

        request.getRequestDispatcher("/views/admin/dashboard/dashboard.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
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
            BigDecimal revenue = toBigDecimal(value);
            if (revenue.compareTo(max) > 0) {
                max = revenue;
            }
        }

        for (Map<String, Object> row : rows) {
            BigDecimal revenue = toBigDecimal(row.get("revenue"));
            int percentage = max.signum() == 0 ? 0
                    : revenue.multiply(BigDecimal.valueOf(100))
                            .divide(max, 0, RoundingMode.HALF_UP)
                            .intValue();
            row.put("percentage", Math.max(0, Math.min(100, percentage)));
        }
    }

    private BigDecimal toBigDecimal(Object value) {
        if (value instanceof BigDecimal) {
            return (BigDecimal) value;
        }
        if (value instanceof Number) {
            return BigDecimal.valueOf(((Number) value).doubleValue());
        }
        return BigDecimal.ZERO;
    }

    private boolean isAdminOrStaff(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        Account account = session == null
                ? null : (Account) session.getAttribute("account");

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
        return value == null || value.trim().isEmpty() ? null : value.trim();
=======
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Auth guard
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Account acc = (Account) session.getAttribute("account");
        if (!"admin".equals(acc.getRole()) && !"staff".equals(acc.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Stats tổng quan sách
        int totalBooks       = bookDAO.countAllBooks();
        int availableBooks   = bookDAO.countBooksByStatus("available");
        int outOfStockBooks  = bookDAO.countBooksByStatus("out_of_stock");
        int discontinuedBooks = bookDAO.countBooksByStatus("discontinued");

        // Danh sách sách mới thêm gần đây (8 cuốn)
        List<Book> recentBooks = bookDAO.getRecentBooksAdmin(8);

        // Tổng nhân viên
        int totalStaffs = accountDAO.countStaffs();

        req.setAttribute("totalBooks",        totalBooks);
        req.setAttribute("availableBooks",    availableBooks);
        req.setAttribute("outOfStockBooks",   outOfStockBooks);
        req.setAttribute("discontinuedBooks", discontinuedBooks);
        req.setAttribute("recentBooks",       recentBooks);
        req.setAttribute("totalStaffs",       totalStaffs);

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
>>>>>>> main
    }
}
