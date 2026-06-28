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

        request.getRequestDispatcher("/views/admin/account/account-management.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        CustomerDAO customerDAO = new CustomerDAO();
        AccountDAO accountDAO = new AccountDAO();

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try (PrintWriter out = response.getWriter()) {
            if ("toggleCustomer".equals(action)) {
                int customerID = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                customerDAO.toggleCustomerStatus(customerID, status);

            } else if ("toggleStaff".equals(action)) {
                int accountID = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                accountDAO.toggleStaffStatus(accountID, status);
            }

            out.write("{\"success\":true}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\":false}");
        }
    }

    @Override
    public String getServletInfo() {
        return "Account Management Controller";
    }
}