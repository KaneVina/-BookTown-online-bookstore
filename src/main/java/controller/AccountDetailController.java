package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Customer;

public class AccountDetailController extends HttpServlet {

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

        // Lấy role và id từ query param
        // VD: /dashboard/account-detail?role=customer&id=5
        //     /dashboard/account-detail?role=staff&id=3
        String role = request.getParameter("role");
        String idParam = request.getParameter("id");

        if (idParam == null || role == null) {
            response.sendRedirect(request.getContextPath() + "/dashboard/account-management");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);

            if ("customer".equals(role)) {
                CustomerDAO customerDAO = new CustomerDAO();
                Customer customer = customerDAO.getCustomerById(id);

                if (customer == null) {
                    response.sendRedirect(request.getContextPath() + "/dashboard/account-management");
                    return;
                }

                request.setAttribute("targetCustomer", customer);
                request.setAttribute("targetRole", "customer");

            } else if ("staff".equals(role) || "admin".equals(role)) {
                // Chỉ admin mới được xem chi tiết staff
                if (!"admin".equals(loginUser.getRole())) {
                    response.sendRedirect(request.getContextPath() + "/dashboard/account-management");
                    return;
                }

                AccountDAO accountDAO = new AccountDAO();
                // Tìm staff trong danh sách (dùng getAllStaffs vì chưa có getStaffById)
                Account staff = accountDAO.getAllStaffs()
                        .stream()
                        .filter(a -> a.getId() == id)
                        .findFirst()
                        .orElse(null);

                if (staff == null) {
                    response.sendRedirect(request.getContextPath() + "/dashboard/account-management");
                    return;
                }

                request.setAttribute("targetStaff", staff);
                request.setAttribute("targetRole", role);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/dashboard/account-management");
            return;
        }

        request.getRequestDispatcher("/views/admin/account/account-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý cập nhật thông tin nếu cần sau này
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Account Detail Controller";
    }
}