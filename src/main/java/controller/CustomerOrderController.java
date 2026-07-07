package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order;

import java.io.IOException;
import java.util.List;

public class CustomerOrderController extends HttpServlet {

    private static final int PAGE_SIZE = 4;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = 1;

        try {
            String pageRaw = req.getParameter("page");
            if (pageRaw != null && !pageRaw.trim().isEmpty()) {
                page = Integer.parseInt(pageRaw);
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        if (page < 1) {
            page = 1;
        }

        OrderDAO orderDAO = new OrderDAO();

        int totalOrders = orderDAO.countAllOrders();
        int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);

        if (totalPages == 0) {
            totalPages = 1;
        }

        if (page > totalPages) {
            page = totalPages;
        }

        int offset = (page - 1) * PAGE_SIZE;

        List<Order> orders = orderDAO.getAllOrdersPaging(offset, PAGE_SIZE);

        req.setAttribute("orders", orders);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("totalOrders", totalOrders);
        req.setAttribute("startOrder", totalOrders == 0 ? 0 : offset + 1);
        req.setAttribute("endOrder", Math.min(offset + PAGE_SIZE, totalOrders));

        req.getRequestDispatcher("/views/staff/customer-order.jsp").forward(req, resp);
    }
}