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

public class OrderHistoryController extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomer(request, response)) {
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
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomer(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "cancel":
                handleCancel(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/profile/order-history");
        }
    }

    private void showList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Account account = getAccount(request);

        String status = request.getParameter("status");

        int pageSize = PAGE_SIZE;
        int currentPage = 1;
        try {
            String p = request.getParameter("page");
            if (p != null) {
                currentPage = Math.max(1, Integer.parseInt(p));
            }
        } catch (Exception ignored) {
        }

        int totalRecords = orderDAO.countOrdersByCustomerFiltered(account.getId(), status);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        if (totalPages == 0) {
            totalPages = 1;
        }
        if (currentPage > totalPages) {
            currentPage = totalPages;
        }

        int offset = (currentPage - 1) * pageSize;

        List<Order> orders = orderDAO.getOrdersByCustomerFiltered(account.getId(), status, offset, pageSize);

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("status", status);

        String baseUrl = request.getContextPath() + "/profile/order-history?status=" + (status != null ? status : "");
        request.setAttribute("baseUrl", baseUrl);

        request.getRequestDispatcher("/views/order/order-history.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Account account = getAccount(request);

        int orderID = toInt(request.getParameter("orderID"), 0);

        Order order = orderDAO.getOrderByID(orderID);

        if (order == null || order.getCustomerID() != account.getId()) {
            response.sendRedirect(request.getContextPath() + "/profile/order-history");
            return;
        }

        List<OrderDetail> orderDetails = orderDAO.getOrderDetails(orderID);

        request.setAttribute("order", order);
        request.setAttribute("orderDetails", orderDetails);

        request.getRequestDispatcher("/views/order/order-history-detail.jsp").forward(request, response);
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        Account account = getAccount(request);
        int orderID = toInt(request.getParameter("orderID"), 0);

        String cancelReason = request.getParameter("cancelReason");
        if (cancelReason == null) {
            cancelReason = "";
        }
        cancelReason = cancelReason.trim();

        String redirectTarget = request.getParameter("redirect");
        String redirectUrl = "list".equalsIgnoreCase(redirectTarget)
                ? request.getContextPath() + "/profile/order-history"
                : request.getContextPath() + "/profile/order-history?action=detail&orderID=" + orderID;

        if (cancelReason.isEmpty()) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Vui lòng nhập lý do hủy đơn.");
            response.sendRedirect(redirectUrl);
            return;
        }
        if (cancelReason.length() < 10 || cancelReason.length() > 50) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lý do hủy phải từ 10 đến 50 ký tự.");
            response.sendRedirect(redirectUrl);
            return;
        }
        if (!cancelReason.matches(".*\\p{L}.*")) {
            HttpSession session = request.getSession();
            session.setAttribute("errorMessage", "Lý do hủy phải chứa ít nhất 1 chữ cái.");
            response.sendRedirect(redirectUrl);
            return;
        }

        Order order = orderDAO.getOrderByID(orderID);
        boolean ok = orderDAO.cancelOrder(orderID, account.getId(), cancelReason);

        HttpSession session = request.getSession();
        if (ok) {
            orderDAO.restoreStock(orderID);
            if (order != null) {
                if ("vnpay".equalsIgnoreCase(order.getPaymentMethod()) && "paid".equalsIgnoreCase(order.getPaymentStatus())) {
                    orderDAO.updatePaymentStatus(orderID, "pending_refund");

                    final Order finalOrder = order;
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                utils.EmailUtil.sendRefundPendingEmail(finalOrder.getCustomerEmail(), finalOrder);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }).start();
                } else {
                    final Order finalOrder = order;
                    final String finalReason = cancelReason;
                    new Thread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                utils.EmailUtil.sendOrderCancelledEmail(finalOrder.getCustomerEmail(), finalOrder, finalReason);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }).start();
                }
            }

            String orderCode = (order != null) ? order.getOrderCode() : String.valueOf(orderID);
            session.setAttribute("successMessage", "Đã hủy đơn hàng #" + orderCode + " thành công!");
        } else {
            session.setAttribute("errorMessage", "Không thể hủy đơn hàng này (đơn đã được xử lý).");
        }

        response.sendRedirect(redirectUrl);
    }

    private boolean isCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        Account account = (Account) session.getAttribute("account");
        if (!"customer".equals(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }

        return true;
    }

    private Account getAccount(HttpServletRequest request) {
        return (Account) request.getSession().getAttribute("account");
    }

    private int toInt(String value, int defaultVal) {
        if (value == null || value.trim().isEmpty()) {
            return defaultVal;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }
}
