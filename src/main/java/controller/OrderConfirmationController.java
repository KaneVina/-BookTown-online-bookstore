package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Order;

import java.io.IOException;

public class OrderConfirmationController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomer(request, response)) {
            return;
        }

        Account account = getAccount(request);

        String status = request.getParameter("status");
        if (!"success".equals(status)) {
            request.getRequestDispatcher("/views/error/404.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession();
        Integer justPlacedOrderID = (Integer) session.getAttribute("just_placed_order_id");

        if (justPlacedOrderID == null) {
            request.getRequestDispatcher("/views/error/404.jsp").forward(request, response);
            return;
        }

        Order order = orderDAO.getOrderByIDAndCustomer(justPlacedOrderID, account.getId());

        if (order == null) {
            request.getRequestDispatcher("/views/error/404.jsp").forward(request, response);
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/views/order/order-confirmation.jsp").forward(request, response);
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
}
