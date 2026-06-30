package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import dao.OrderDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

public class AccountManagementController extends HttpServlet {

    private CustomerDAO customerDAO;
    private AccountDAO accountDAO;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account loginUser = (Account) session.getAttribute("account");
        if (loginUser == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        customerDAO = new CustomerDAO();
        accountDAO = new AccountDAO();

        int pageSize = 5;
        int currentPage = 1;

        try {
            String p = request.getParameter("page");
            if (p != null) {
                currentPage = Math.max(1, Integer.parseInt(p));
            }
        } catch (Exception e) {
        }

        int offset = (currentPage - 1) * pageSize;

        if (loginUser.getRole().equals("staff")) {
            int totalRecords = customerDAO.countCustomers();
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            request.setAttribute("customers", customerDAO.getCustomersPaging(offset, pageSize));
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("baseUrl", request.getContextPath() + "/dashboard/account-management?");

        } else if (loginUser.getRole().equals("admin")) {
            int totalRecords = customerDAO.countCustomers() + accountDAO.countStaffs();
            int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

            request.setAttribute("customers", customerDAO.getCustomersPaging(offset, pageSize));
            request.setAttribute("staffs", accountDAO.getStaffsPaging(offset, pageSize));
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("baseUrl", request.getContextPath() + "/dashboard/account-management?");
        }

        request.getRequestDispatcher("/views/admin/account/account-management.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Account loginUser = (session != null) ? (Account) session.getAttribute("account") : null;

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        if (loginUser == null) {
            response.setStatus(401);
            response.getWriter().write("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        customerDAO = new CustomerDAO();
        accountDAO = new AccountDAO();

        try (PrintWriter out = response.getWriter()) {
            switch (action) {
                case "toggleCustomer":
                    handleToggleCustomer(request, out);
                    break;
                case "toggleStaff":
                    handleToggleStaff(request, out, loginUser);
                    break;
                case "updateCustomer":
                    handleUpdateCustomer(request, out);
                    break;
                case "updateStaff":
                    handleUpdateStaff(request, out, loginUser);
                    break;
                case "customerStats":
                    getCustomerStats(request, out);
                    break;
                default:
                    out.write("{\"success\":false,\"message\":\"Action không hợp lệ\"}");
                    break;
            }
        } catch (NumberFormatException e) {
            response.setStatus(400);
            response.getWriter().write("{\"success\":false,\"message\":\"ID không hợp lệ\"}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\":false,\"message\":\"Lỗi server\"}");
        }
    }

    private void handleToggleCustomer(HttpServletRequest request, PrintWriter out)
            throws NumberFormatException {
        int customerID = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        boolean ok = customerDAO.toggleCustomerStatus(customerID, status);
        out.write(ok
                ? "{\"success\":true}"
                : "{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
    }

    private void handleToggleStaff(HttpServletRequest request, PrintWriter out, Account loginUser)
            throws NumberFormatException {
        if (!loginUser.getRole().equals("admin")) {
            out.write("{\"success\":false,\"message\":\"Không có quyền\"}");
            return;
        }

        int accountID = Integer.parseInt(request.getParameter("id"));
        String status = request.getParameter("status");

        boolean ok = accountDAO.toggleStaffStatus(accountID, status);
        out.write(ok
                ? "{\"success\":true}"
                : "{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
    }

    private void handleUpdateCustomer(HttpServletRequest request, PrintWriter out)
            throws NumberFormatException {
        int id = Integer.parseInt(request.getParameter("id"));
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");

        if (fullname == null || fullname.trim().isEmpty()) {
            out.write("{\"success\":false,\"message\":\"Họ tên không được để trống\"}");
            return;
        }

        String phoneError = validatePhone(phone);
        if (phoneError != null) {
            out.write("{\"success\":false,\"message\":\"" + phoneError + "\"}");
            return;
        }

        boolean ok = customerDAO.updateCustomerByAdmin(
                id,
                fullname.trim(),
                phone != null ? phone.trim() : "",
                status
        );
        out.write(ok
                ? "{\"success\":true}"
                : "{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
    }

    private void handleUpdateStaff(HttpServletRequest request, PrintWriter out, Account loginUser)
            throws NumberFormatException {
        if (!loginUser.getRole().equals("admin")) {
            out.write("{\"success\":false,\"message\":\"Không có quyền\"}");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");
        String role = request.getParameter("role");
        if (fullname == null || fullname.trim().isEmpty()) {
            out.write("{\"success\":false,\"message\":\"Họ tên không được để trống\"}");
            return;
        }

        if (!"staff".equals(role) && !"admin".equals(role)) {
            out.write("{\"success\":false,\"message\":\"Vai trò không hợp lệ\"}");
            return;
        }

        String phoneError = validatePhone(phone);
        if (phoneError != null) {
            out.write("{\"success\":false,\"message\":\"" + phoneError + "\"}");
            return;
        }

        boolean ok = accountDAO.updateStaffByAdmin(
                id,
                fullname.trim(),
                phone != null ? phone.trim() : "",
                role,
                status
        );
        out.write(ok
                ? "{\"success\":true}"
                : "{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
    }

    private String validatePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return "Số điện thoại không được để trống";
        }

        String trimmedPhone = phone.trim();

        if (!trimmedPhone.matches("^[0-9+\\-\\s\\(\\)]*$")) {
            return "Số điện thoại chứa ký tự không hợp lệ";
        }

        String normalized = trimmedPhone.replaceAll("[\\s\\-\\(\\)]", "");

        if (!normalized.matches("^(0|\\+84)[0-9]{9,10}$")) {
            return "Số điện thoại không hợp lệ. Vui lòng nhập số hợp lệ (bắt đầu bằng 0 hoặc +84)";
        }

        String digitsOnly = normalized.replaceAll("[^0-9]", "");

        if (digitsOnly.length() < 10 || digitsOnly.length() > 11) {
            return "Số điện thoại phải có 10-11 chữ số";
        }

        return null;
    }

    private void getCustomerStats(
            HttpServletRequest request,
            PrintWriter out) {

        int customerId
                = Integer.parseInt(request.getParameter("id"));

        OrderDAO orderDAO = new OrderDAO();

        int totalOrders
                = orderDAO.getTotalOrdersByCustomer(customerId);

        double totalSpent
                = orderDAO.getTotalSpentByCustomer(customerId);

        out.write(
                "{"
                + "\"success\":true,"
                + "\"totalOrders\":" + totalOrders + ","
                + "\"totalSpent\":" + totalSpent
                + "}"
        );
    }

    @Override
    public String getServletInfo() {
        return "Account Management Controller";
    }
}
