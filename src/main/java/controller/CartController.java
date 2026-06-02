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

        session.setAttribute("cartCount", cartDAO.countCartItems(account.getId()));

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

        if (success) {
            int newCount = cartDAO.countCartItems(account.getId());
            req.getSession().setAttribute("cartCount", newCount);
        }

        resp.sendRedirect(req.getContextPath() + "/products?id=" + bookID
                + "&addResult=" + (success ? "success" : "error"));
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
            cartDAO.removeItem(cartItemID, account.getId());
        } else {
            cartDAO.updateQuantity(cartItemID, newQty);
        }

        int newCount = cartDAO.countCartItems(account.getId());
        req.getSession().setAttribute("cartCount", newCount);

        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void handleRemove(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {

        int cartItemID = parseIntParam(req.getParameter("cartItemID"), 0);

        if (cartItemID > 0) {
            CartDAO cartDAO = new CartDAO();
            cartDAO.removeItem(cartItemID, account.getId());

            int newCount = cartDAO.countCartItems(account.getId());
            req.getSession().setAttribute("cartCount", newCount);
        }

        resp.sendRedirect(req.getContextPath() + "/cart");
    }
}