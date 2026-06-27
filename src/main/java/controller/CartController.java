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
import java.math.BigDecimal;
import java.util.List;

public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Account account = (Account) session.getAttribute("account");
        if (!"customer".equals(account.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());
        BigDecimal subtotal = cartDAO.calcSubtotal(cartItems);
        BigDecimal shippingFee = cartItems.isEmpty() ? BigDecimal.ZERO : new BigDecimal("30000");
        BigDecimal total = subtotal.add(shippingFee);

        // Cập nhật badge giỏ hàng trên header
        session.setAttribute("cartCount", cartItems.size());

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("subtotal", subtotal);
        req.setAttribute("shippingFee", shippingFee);
        req.setAttribute("total", total);

        req.getRequestDispatcher("/views/cart/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);

        // Chưa đăng nhập → redirect login, giữ lại URL để quay lại sau
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Account account = (Account) session.getAttribute("account");
        if (!"customer".equals(account.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "add":
                handleAdd(req, resp, account);
                break;
            case "update":
                handleUpdate(req, resp, account);
                break;
            case "remove":
                handleRemove(req, resp, account);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    // ── Thêm sản phẩm vào giỏ ────────────────────────────────────────────
    private void handleAdd(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {

        String bookIDParam = req.getParameter("bookID");
        String quantityParam = req.getParameter("quantity");

        int bookID = parseIntParam(bookIDParam, 0);
        int quantity = parseIntParam(quantityParam, 1);

        if (bookID <= 0) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }
        if (quantity < 1) {
            quantity = 1;
        }

        CartDAO cartDAO = new CartDAO();
        boolean success = cartDAO.addToCart(account.getId(), bookID, quantity);

        // Cập nhật badge cartCount trong session
        if (success) {
            int newCount = cartDAO.countCartItems(account.getId());
            req.getSession().setAttribute("cartCount", newCount);
        }

        // Redirect về trang sản phẩm vừa xem, kèm thông báo
        String referer = req.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            resp.sendRedirect(referer + (referer.contains("?") ? "&" : "?")
                    + "addResult=" + (success ? "success" : "error"));
        } else {
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    private int parseIntParam(String param, int defaultVal) {
        if (param == null || param.trim().isEmpty()) {
            return defaultVal;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {

        int cartItemID = parseIntParam(req.getParameter("cartItemID"), 0);
        int newQty = parseIntParam(req.getParameter("quantity"), 1);

        if (cartItemID <= 0) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        CartDAO cartDAO = new CartDAO();

        if (newQty < 1) {
            // Giảm xuống 0 → xóa luôn
            cartDAO.removeItem(cartItemID, account.getId());
        } else {
            cartDAO.updateQuantity(cartItemID, newQty);
        }

        // Cập nhật badge
        int newCount = cartDAO.countCartItems(account.getId());
        req.getSession().setAttribute("cartCount", newCount);

        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void handleRemove(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {

        int cartItemID = parseIntParam(req.getParameter("cartItemID"), 0);

        if (cartItemID <= 0) {
            sendJson(resp, "{\"ok\":false,\"message\":\"Item không hợp lệ\"}");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        cartDAO.removeItem(cartItemID, account.getId());

        List<CartItem> cartItemList = cartDAO.getCartItems(account.getId());
        BigDecimal subtotal = cartDAO.calcSubtotal(cartItemList);
        int newCount = calcTotalQuantity(cartItemList);

        req.getSession().setAttribute("cartCount", newCount);

        sendJson(resp, "{\"ok\":true"
                + ",\"cartCount\":" + newCount
                + ",\"subtotal\":" + subtotal.longValue()
                + ",\"total\":" + subtotal.longValue()
                + "}");
    }

    private int calcTotalQuantity(List<CartItem> items) {
        int total = 0;
        for (CartItem item : items) {
            total += item.getQuantity();
        }
        return total;
    }

    private void sendJson(HttpServletResponse resp, String json) throws IOException {
    resp.setContentType("application/json");
    resp.setCharacterEncoding("UTF-8");
    resp.getWriter().write(json);
}
}

