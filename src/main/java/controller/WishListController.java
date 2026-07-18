package controller;

import dao.BookDAO;
import dao.CartDAO;
import dao.WishListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.WishlistItem;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

/**
 * WishlistController – xử lý wishlist của customer đã đăng nhập. URL: /wishlist
 */
public class WishListController extends HttpServlet {

    private final WishListDAO wishlistDAO = new WishListDAO();
    private final BookDAO bookDAO = new BookDAO();
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account account = requireCustomer(req, resp);
        if (account == null) {
            return;
        }

        List<WishlistItem> items = wishlistDAO.getWishlistItems(account.getId());
        int wishlistCount = items.size();
        req.getSession().setAttribute("wishlistCount", wishlistCount);

        req.setAttribute("wishlistItems", items);
        req.setAttribute("wishlistCount", wishlistCount);
        req.getRequestDispatcher("/views/book/wishlist.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        boolean isAjax = isAjaxRequest(req);

        Account account = requireCustomer(req, resp);
        if (account == null) {
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null || action.isBlank()) {
            action = req.getParameter("wishAction");
        }
        int bookID = parseIntParam(req.getParameter("bookID"), 0);
        if (bookID <= 0) {
            bookID = parseIntParam(req.getParameter("wishBookId"), 0);
        }
        String referer = req.getHeader("Referer");

        if (bookID <= 0) {
            respondError(req, resp, isAjax, referer,
                    req.getContextPath() + "/wishlist",
                    "invalid_book_id", "Mã sách không hợp lệ");
            return;
        }

        switch (action == null ? "" : action) {
            case "add":
                handleAdd(req, resp, account, bookID, referer, isAjax);
                break;
            case "remove":
                handleRemove(req, resp, account, bookID, referer, isAjax);
                break;
            case "moveToCart":
                handleMoveToCart(req, resp, account, bookID, referer, isAjax);
                break;
            default:
                respondError(req, resp, isAjax, referer,
                        req.getContextPath() + "/wishlist",
                        "unknown_action", "Thao tác không hợp lệ");
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp,
            Account account, int bookID, String referer, boolean isAjax) throws IOException {

        String validationError = bookDAO.validateWishlistAdd(bookID);
        if (validationError != null) {
            respondError(req, resp, isAjax, referer,
                    req.getContextPath() + "/products?id=" + bookID,
                    "invalid_book", validationError);
            return;
        }

        if (wishlistDAO.isInWishlist(account.getId(), bookID)) {
            int wCount = wishlistDAO.countWishlistItems(account.getId());
            req.getSession().setAttribute("wishlistCount", wCount);
            respondSuccess(resp, isAjax, referer,
                    req.getContextPath() + "/products?id=" + bookID,
                    "added", wCount, -1, "Sách đã có trong danh sách yêu thích");
            return;
        }

        boolean ok = wishlistDAO.addToWishlist(account.getId(), bookID);
        int wCount = wishlistDAO.countWishlistItems(account.getId());
        req.getSession().setAttribute("wishlistCount", wCount);

        if (!ok) {
            respondError(req, resp, isAjax, referer,
                    req.getContextPath() + "/products?id=" + bookID,
                    "add_failed", "Không thể thêm vào yêu thích");
            return;
        }

        respondSuccess(resp, isAjax, referer,
                req.getContextPath() + "/products?id=" + bookID,
                "added", wCount, -1, "Đã thêm vào yêu thích");
    }

    private void handleRemove(HttpServletRequest req, HttpServletResponse resp,
            Account account, int bookID, String referer, boolean isAjax) throws IOException {

        if (!wishlistDAO.isInWishlist(account.getId(), bookID)) {
            int wCount = wishlistDAO.countWishlistItems(account.getId());
            req.getSession().setAttribute("wishlistCount", wCount);
            respondSuccess(resp, isAjax, referer,
                    buildRemoveRedirect(req, referer, bookID),
                    "removed", wCount, -1, "Sách không còn trong danh sách yêu thích");
            return;
        }

        boolean ok = wishlistDAO.removeFromWishlist(account.getId(), bookID);
        int wCount = wishlistDAO.countWishlistItems(account.getId());
        req.getSession().setAttribute("wishlistCount", wCount);

        if (!ok) {
            respondError(req, resp, isAjax, referer,
                    buildRemoveRedirect(req, referer, bookID),
                    "remove_failed", "Không thể xóa khỏi yêu thích");
            return;
        }

        respondSuccess(resp, isAjax, referer,
                buildRemoveRedirect(req, referer, bookID),
                "removed", wCount, -1, "Đã xóa khỏi yêu thích");
    }

    private void handleMoveToCart(HttpServletRequest req, HttpServletResponse resp,
            Account account, int bookID, String referer, boolean isAjax) throws IOException {

        if (!wishlistDAO.isInWishlist(account.getId(), bookID)) {
            respondError(req, resp, isAjax, referer,
                    req.getContextPath() + "/wishlist",
                    "not_in_wishlist", "Sách không có trong danh sách yêu thích");
            return;
        }

        int qty = parseIntParam(req.getParameter("quantity"), 1);
        String stockError = bookDAO.validatePurchaseQuantity(bookID, qty);
        if (stockError != null) {
            respondError(req, resp, isAjax, referer,
                    req.getContextPath() + "/wishlist",
                    "out_of_stock", stockError);
            return;
        }

        boolean ok = wishlistDAO.moveToCart(account.getId(), bookID, qty);
        int wCount = wishlistDAO.countWishlistItems(account.getId());
        int cCount = cartDAO.countCartItems(account.getId());
        req.getSession().setAttribute("wishlistCount", wCount);
        req.getSession().setAttribute("cartCount", cCount);

        if (!ok) {
            respondError(req, resp, isAjax, referer,
                    req.getContextPath() + "/wishlist",
                    "move_failed", "Không thể chuyển sang giỏ hàng");
            return;
        }

        respondSuccess(resp, isAjax, referer,
                req.getContextPath() + "/wishlist",
                "moved_to_cart", wCount, cCount, "Đã chuyển sang giỏ hàng");
    }

    private String buildRemoveRedirect(HttpServletRequest req, String referer, int bookID) {
        if (referer != null && referer.contains("/wishlist")) {
            return req.getContextPath() + "/wishlist?removed=1";
        }
        return buildRedirectUrl(referer,
                req.getContextPath() + "/products?id=" + bookID,
                "wishResult=removed");
    }

    private void respondSuccess(HttpServletResponse resp, boolean isAjax, String referer,
            String fallback, String action, int wishlistCount, int cartCount, String message)
            throws IOException {
        if (isAjax) {
            String cartPart = cartCount >= 0 ? ",\"cartCount\":" + cartCount : "";
            writeJson(resp, HttpServletResponse.SC_OK,
                    String.format("{\"success\":true,\"action\":\"%s\",\"wishlistCount\":%d%s,\"message\":\"%s\"}",
                            action, wishlistCount, cartPart, escapeJson(message)));
            return;
        }

        String param = "moved_to_cart".equals(action) ? "movedToCart=1"
                : "removed".equals(action) ? "removed=1" : "wishResult=added";
        resp.sendRedirect(buildRedirectUrl(referer, fallback, param));
    }

    private void respondError(HttpServletRequest req, HttpServletResponse resp, boolean isAjax,
            String referer, String fallback, String errorCode, String message) throws IOException {
        if (isAjax) {
            writeJson(resp, HttpServletResponse.SC_BAD_REQUEST,
                    String.format("{\"success\":false,\"error\":\"%s\",\"message\":\"%s\"}",
                            escapeJson(errorCode), escapeJson(message)));
            return;
        }

        String encodedMessage = URLEncoder.encode(message, StandardCharsets.UTF_8);
        String redirect = fallback.contains("/wishlist")
                ? req.getContextPath() + "/wishlist?wishError=" + encodedMessage
                : buildRedirectUrl(referer, fallback, "wishResult=wishError&wishMessage=" + encodedMessage);
        resp.sendRedirect(redirect);
    }

    private void writeJson(HttpServletResponse resp, int status, String body) throws IOException {
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.setStatus(status);
        resp.getWriter().write(body);
    }

    private Account requireCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        Account acc = (session != null) ? (Account) session.getAttribute("account") : null;
        boolean isAjax = isAjaxRequest(req);

        if (acc == null) {
            if (isAjax) {
                writeJson(resp, HttpServletResponse.SC_UNAUTHORIZED,
                        "{\"success\":false,\"error\":\"unauthorized\",\"message\":\"Vui lòng đăng nhập\",\"redirect\":\""
                                + req.getContextPath() + "/login\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login");
            }
            return null;
        }
        if (!"customer".equals(acc.getRole())) {
            if (isAjax) {
                writeJson(resp, HttpServletResponse.SC_FORBIDDEN,
                        "{\"success\":false,\"error\":\"forbidden\",\"message\":\"Chỉ khách hàng mới dùng được yêu thích\",\"redirect\":\""
                                + req.getContextPath() + "/home\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }
            return null;
        }
        return acc;
    }

    private boolean isAjaxRequest(HttpServletRequest req) {
        return "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))
                || "true".equals(req.getParameter("ajax"));
    }

    private String buildRedirectUrl(String referer, String fallback, String extraParam) {
        String base = (referer != null && !referer.isEmpty()) ? referer : fallback;
        base = base.replaceAll("[&?]wishResult=[^&]*", "")
                .replaceAll("[&?]wishMessage=[^&]*", "")
                .replaceAll("[&?]addResult=[^&]*", "");
        return base + (base.contains("?") ? "&" : "?") + extraParam;
    }

    private int parseIntParam(String param, int defaultVal) {
        if (param == null || param.trim().isEmpty()) {
            return defaultVal;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (Exception e) {
            return defaultVal;
        }
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r");
    }
}
