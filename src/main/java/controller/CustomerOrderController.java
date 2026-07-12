package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Order;
import model.OrderDetail;

import java.io.IOException;
import java.util.List;

public class CustomerOrderController extends HttpServlet {

    private static final int PAGE_SIZE = 4;
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
            case "confirmRefund":
                handleConfirmRefund(request, response);
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

        int currentPage = 1;
        try {
            String pageRaw = request.getParameter("page");
            if (pageRaw != null && !pageRaw.trim().isEmpty()) {
                currentPage = Math.max(1, Integer.parseInt(pageRaw));
            }
        } catch (NumberFormatException ignored) {
            currentPage = 1;
        }

        int totalRecords = orderDAO.countFilteredOrders(keyword, status);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * PAGE_SIZE;
        List<Order> orders = orderDAO.getAllOrders(keyword, status, offset, PAGE_SIZE);

        request.setAttribute("orderList", orders);
        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("totalOrders", totalRecords);
        request.setAttribute("startOrder", totalRecords == 0 ? 0 : offset + 1);
        request.setAttribute("endOrder", Math.min(offset + PAGE_SIZE, totalRecords));
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
        request.setAttribute("countPendingRefund", orderDAO.countOrdersByStatus("pending_refund"));
        request.setAttribute("countRefunded", orderDAO.countOrdersByStatus("refunded"));

        request.getRequestDispatcher("/views/staff/customer-order.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int orderID = parseInt(request.getParameter("orderID"), 0);
        Order order = orderDAO.getOrderByID(orderID);

        if (order == null) {
            request.getSession().setAttribute("errorMessage", "Không tìm thấy đơn hàng.");
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
            return;
        }

        List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderID);
        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);
        request.getRequestDispatcher("/views/staff/customer-order-detail.jsp")
                .forward(request, response);
    }

    private void handleUpdateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int orderID = parseInt(request.getParameter("orderID"), 0);
        String status = request.getParameter("status");
        String redirect = request.getParameter("redirect");

        HttpSession session = request.getSession();
        Account staff = (Account) session.getAttribute("account");
        Order order = orderDAO.getOrderByID(orderID);

        if (order != null) {
            if ("completed".equalsIgnoreCase(status)
                    && "cod".equalsIgnoreCase(order.getPaymentMethod())
                    && "unpaid".equalsIgnoreCase(order.getPaymentStatus())) {
                orderDAO.updatePaymentStatus(orderID, "paid");
            } else if ("cancelled".equalsIgnoreCase(status)
                    && "vnpay".equalsIgnoreCase(order.getPaymentMethod())
                    && "paid".equalsIgnoreCase(order.getPaymentStatus())) {

                orderDAO.updatePaymentStatus(orderID, "pending_refund");
                final Order finalOrder = order;
                new Thread(() -> {
                    try {
                        utils.EmailUtil.sendRefundPendingEmail(
                                finalOrder.getCustomerEmail(), finalOrder);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }).start();
            }
        }

        boolean ok = orderDAO.updateOrderStatusAndStaff(orderID, status, staff.getId());

        if (ok) {
            if ("cancelled".equalsIgnoreCase(status)
                    && order != null
                    && ("pending".equalsIgnoreCase(order.getStatus())
                    || "confirmed".equalsIgnoreCase(order.getStatus()))) {
                orderDAO.restoreStock(orderID);
            }
            session.setAttribute("successMessage", "Cập nhật trạng thái đơn hàng thành công!");
        } else {
            session.setAttribute("errorMessage", "Cập nhật trạng thái đơn hàng thất bại.");
        }

        if ("detail".equals(redirect)) {
            response.sendRedirect(request.getContextPath()
                    + "/dashboard/customer-order?action=detail&orderID=" + orderID);
        } else {
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
        }
    }

    private void handleConfirmRefund(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int orderID = parseInt(request.getParameter("orderID"), 0);
        HttpSession session = request.getSession();
        Order order = orderDAO.getOrderByID(orderID);

        if (order == null) {
            session.setAttribute("errorMessage", "Không tìm thấy đơn hàng.");
            response.sendRedirect(request.getContextPath() + "/dashboard/customer-order");
            return;
        }

        boolean ok = orderDAO.confirmRefund(orderID);
        if (ok) {
            final Order updatedOrder = orderDAO.getOrderByID(orderID);
            if (updatedOrder != null && updatedOrder.getCustomerEmail() != null) {
                new Thread(() -> {
                    try {
                        utils.EmailUtil.sendRefundConfirmedEmail(
                                updatedOrder.getCustomerEmail(), updatedOrder);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }).start();
            }
            session.setAttribute("successMessage",
                    "Đã xác nhận hoàn tiền và gửi email thông báo cho khách hàng!");
        } else {
            session.setAttribute("errorMessage",
                    "Không thể xác nhận hoàn tiền. Đơn hàng không ở trạng thái chờ hoàn tiền.");
        }

        response.sendRedirect(request.getContextPath()
                + "/dashboard/customer-order?action=detail&orderID=" + orderID);
    }

    private boolean hasAccess(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        Account user = (Account) session.getAttribute("account");
        if (user == null || !"staff".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }
}
