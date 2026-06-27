package controller;

import dao.OrderDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Order;
import model.OrderDetail;

public class CustomerOrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!hasAccess(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "detail":
                showDetail(request, response);
                break;
            default:
                showList(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!hasAccess(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "updateStatus":
                handleUpdateStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
                break;
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        int pageSize = 10;
        int currentPage = 1;
        try {
            String p = request.getParameter("page");
            if (p != null) {
                currentPage = Math.max(1, Integer.parseInt(p));
            }
        } catch (Exception ignored) {
        }

        int totalRecords = orderDAO.countFilteredOrders(keyword, status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }
        int offset = (currentPage - 1) * pageSize;

        request.setAttribute("orderList", orderDAO.getAllOrders(keyword, status, offset, pageSize));
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", status);

        String baseUrl = request.getContextPath()
                + "/dashboard/customer-order?keyword=" + (keyword != null ? keyword : "")
                + "&status=" + (status != null ? status : "");
        request.setAttribute("baseUrl", baseUrl);

        request.setAttribute("countPending", orderDAO.countOrdersByStatus("pending"));
        request.setAttribute("countConfirmed", orderDAO.countOrdersByStatus("confirmed"));
        request.setAttribute("countShipping", orderDAO.countOrdersByStatus("shipping"));
        request.setAttribute("countCompleted", orderDAO.countOrdersByStatus("completed"));

        request.getRequestDispatcher("/views/staff/customer-order.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderID = parseInt(request.getParameter("orderID"), 0);
        Order order = orderDAO.getOrderByID(orderID);

        if (order == null) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Không tìm thấy đơn hàng.");
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
            return;
        }

        List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderID);

        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);

        request.getRequestDispatcher("/views/staff/customer-order-detail.jsp").forward(request, response);
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int orderID = parseInt(request.getParameter("orderID"), 0);
        String status = request.getParameter("status");
        String redirect = request.getParameter("redirect");

        HttpSession session = request.getSession();
        Account staff = (Account) session.getAttribute("account");

        boolean ok = orderDAO.updateOrderStatusAndStaff(orderID, status, staff.getId());

        if (ok) {
            session.setAttribute("successMessage", "Cập nhật trạng thái đơn hàng thành công!");
        } else {
            session.setAttribute("errorMessage", "Cập nhật trạng thái đơn hàng thất bại.");
        }

        if ("detail".equals(redirect)) {
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order?action=detail&orderID=" + orderID);
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
        }
    }

    private boolean hasAccess(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        Account user = (Account) session.getAttribute("account");
        if (user == null || !"staff".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private int parseInt(String s, int defaultVal) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return defaultVal;
        }
    }
}
