package controller;

import dao.CartDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomer(request, response)) return;

        Account account = getAccount(request);
        CartDAO cartDAO = new CartDAO();

        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

        BigDecimal subtotal = cartDAO.calcSubtotal(cartItems);
        int        totalQty = calcTotalQuantity(cartItems);

        request.getSession().setAttribute("cartCount", totalQty);

        request.setAttribute("cartItems",     cartItems);
        request.setAttribute("subtotal",      subtotal);
        request.setAttribute("total",         subtotal);
        request.setAttribute("totalQuantity", totalQty);

        request.getRequestDispatcher("/views/cart/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomer(request, response)) return;

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "add":
                handleAdd(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "remove":
                handleRemove(request, response);
                break;
            default:
                sendJson(response, "{\"ok\":false,\"message\":\"Action không hợp lệ\"}");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int bookID   = toInt(request.getParameter("bookID"),   0);
        int quantity = toInt(request.getParameter("quantity"), 1);

        if (bookID <= 0) {
            sendJson(response, "{\"ok\":false,\"message\":\"Sách không hợp lệ\"}");
            return;
        }
        if (quantity < 1) quantity = 1;

        Account account = getAccount(request);
        CartDAO cartDAO = new CartDAO();

        boolean success = cartDAO.addToCart(account.getId(), bookID, quantity);

        int cartCount = 0;
        if (success) {
            List<CartItem> cartItems = cartDAO.getCartItems(account.getId());
            cartCount = calcTotalQuantity(cartItems);
            request.getSession().setAttribute("cartCount", cartCount);
        }

        sendJson(response, "{\"ok\":" + success + ",\"cartCount\":" + cartCount + "}");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int cartItemID = toInt(request.getParameter("cartItemID"), 0);
        int newQty     = toInt(request.getParameter("quantity"),   1);

        if (cartItemID <= 0) {
            sendJson(response, "{\"ok\":false,\"message\":\"Item không hợp lệ\"}");
            return;
        }

        Account account = getAccount(request);
        CartDAO cartDAO = new CartDAO();

        if (newQty < 1) {
            cartDAO.removeItem(cartItemID, account.getId());
        } else {
            cartDAO.updateQuantity(cartItemID, newQty);
        }

        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());
        BigDecimal subtotal      = cartDAO.calcSubtotal(cartItems);
        int        cartCount     = calcTotalQuantity(cartItems);
        request.getSession().setAttribute("cartCount", cartCount);

        BigDecimal itemSubtotal = BigDecimal.ZERO;
        for (CartItem item : cartItems) {
            if (item.getCartItemID() == cartItemID) {
                itemSubtotal = item.getSubtotal();
                break;
            }
        }

        sendJson(response, "{\"ok\":true"
                + ",\"cartCount\":"    + cartCount
                + ",\"itemSubtotal\":" + itemSubtotal.longValue()
                + ",\"subtotal\":"     + subtotal.longValue()
                + ",\"total\":"        + subtotal.longValue()
                + "}");
    }

    private void handleRemove(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int cartItemID = toInt(request.getParameter("cartItemID"), 0);

        if (cartItemID <= 0) {
            sendJson(response, "{\"ok\":false,\"message\":\"Item không hợp lệ\"}");
            return;
        }

        Account account = getAccount(request);
        CartDAO cartDAO = new CartDAO();

        cartDAO.removeItem(cartItemID, account.getId());

        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());
        BigDecimal subtotal      = cartDAO.calcSubtotal(cartItems);
        int        cartCount     = calcTotalQuantity(cartItems);
        request.getSession().setAttribute("cartCount", cartCount);

        sendJson(response, "{\"ok\":true"
                + ",\"cartCount\":" + cartCount
                + ",\"subtotal\":"  + subtotal.longValue()
                + ",\"total\":"     + subtotal.longValue()
                + "}");
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

    private int calcTotalQuantity(List<CartItem> items) {
        int total = 0;
        for (CartItem item : items) {
            total += item.getQuantity();
        }
        return total;
    }

    private int toInt(String value, int defaultVal) {
        if (value == null || value.trim().isEmpty()) return defaultVal;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    private void sendJson(HttpServletResponse response, String json) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json);
    }
}