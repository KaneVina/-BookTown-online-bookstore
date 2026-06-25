package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

public class AccountManagementController extends HttpServlet {

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

        CustomerDAO customerDAO = new CustomerDAO();
        AccountDAO accountDAO = new AccountDAO();

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
        if (action == null) action = "";

        CustomerDAO customerDAO = new CustomerDAO();
        AccountDAO accountDAO = new AccountDAO();

        try (PrintWriter out = response.getWriter()) {
            switch (action) {
                case "toggleCustomer": {
                    int customerID = Integer.parseInt(request.getParameter("id"));
                    String status = request.getParameter("status");
                    boolean ok = customerDAO.toggleCustomerStatus(customerID, status);
                    out.write(ok
                            ? "{\"success\":true}"
                            : "{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
                    break;
                }
                case "toggleStaff": {
                    if (!loginUser.getRole().equals("admin")) {
                        out.write("{\"success\":false,\"message\":\"Không có quyền\"}");
                        break;
                    }
                    int accountID = Integer.parseInt(request.getParameter("id"));
                    String status = request.getParameter("status");
                    boolean ok = accountDAO.toggleStaffStatus(accountID, status);
                    out.write(ok
                            ? "{\"success\":true}"
                            : "{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
                    break;
                }
                case "updateCustomer": {
                    int id = Integer.parseInt(request.getParameter("id"));
                    String fullname = request.getParameter("fullname");
                    String phone    = request.getParameter("phone");
                    String status   = request.getParameter("status");

                    if (fullname == null || fullname.trim().isEmpty()) {
                        out.write("{\"success\":false,\"message\":\"Họ tên không được để trống\"}");
                        break;
                    }
                    boolean ok = customerDAO.updateCustomerByAdmin(id, fullname.trim(), phone, status);
                    out.write(ok
                            ? "{\"success\":true}"
                            : "{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
                    break;
                }
                case "updateStaff": {
                    if (!loginUser.getRole().equals("admin")) {
                        out.write("{\"success\":false,\"message\":\"Không có quyền\"}");
                        break;
                    }
                    int id = Integer.parseInt(request.getParameter("id"));
                    String fullname = request.getParameter("fullname");
                    String phone    = request.getParameter("phone");
                    String status   = request.getParameter("status");
                    String role     = request.getParameter("role");

                    if (fullname == null || fullname.trim().isEmpty()) {
                        out.write("{\"success\":false,\"message\":\"Họ tên không được để trống\"}");
                        break;
                    }
                    if (!"staff".equals(role) && !"admin".equals(role)) {
                        out.write("{\"success\":false,\"message\":\"Vai trò không hợp lệ\"}");
                        break;
                    }
                    boolean ok = accountDAO.updateStaffByAdmin(id, fullname.trim(), phone, role, status);
                    out.write(ok
                            ? "{\"success\":true}"
                            : "{\"success\":false,\"message\":\"Cập nhật thất bại\"}");
                    break;
                }
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

    @Override
    public String getServletInfo() {
        return "Account Management Controller";
    }
}