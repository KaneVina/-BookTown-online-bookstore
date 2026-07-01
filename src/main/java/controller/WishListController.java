package controller;

import dao.BookDAO;
import dao.WishListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.WishlistItem;

import java.io.IOException;
import java.util.List;

/**
 * WishlistController – xử lý wishlist của customer đã đăng nhập. URL: /wishlist
 * doGet → hiển thị trang wishlist doPost action=add → thêm sách doPost
 * action=remove → xóa sách doPost action=moveToCart → chuyển sang giỏ hàng
 */
public class WishListController extends HttpServlet {

    private final WishListDAO wishlistDAO = new WishListDAO();
    private final BookDAO bookDAO = new BookDAO();

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

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))
                || "true".equals(req.getParameter("ajax"));

        Account account = requireCustomer(req, resp);
        if (account == null) {
            return;
        }

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        int bookID = parseIntParam(req.getParameter("bookID"), 0);
        String referer = req.getHeader("Referer");

        if (bookID <= 0) {
            if (isAjax) {
                resp.setContentType("application/json");
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"success\":false,\"error\":\"invalid_book_id\"}");
            } else {
                redirect(resp, referer, req.getContextPath() + "/wishlist");
            }
            return;
        }

        switch (action == null ? "" : action) {
            case "add": {
                boolean ok = wishlistDAO.addToWishlist(account.getId(), bookID);
                int wCount = wishlistDAO.countWishlistItems(account.getId());
                req.getSession().setAttribute("wishlistCount", wCount);
                if (isAjax) {
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(String.format("{\"success\":%b,\"action\":\"added\",\"wishlistCount\":%d}", ok, wCount));
                } else {
                    String redirectUrl = buildRedirectUrl(referer,
                            req.getContextPath() + "/products?id=" + bookID,
                            "wishResult=" + (ok ? "added" : "wishError"));
                    resp.sendRedirect(redirectUrl);
                }
                break;
            }
            case "remove": {
                boolean ok = wishlistDAO.removeFromWishlist(account.getId(), bookID);
                int wCount = wishlistDAO.countWishlistItems(account.getId());
                req.getSession().setAttribute("wishlistCount", wCount);
                if (isAjax) {
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(String.format("{\"success\":%b,\"action\":\"removed\",\"wishlistCount\":%d}", ok, wCount));
                } else {
                    String back = (referer != null && referer.contains("/wishlist"))
                            ? req.getContextPath() + "/wishlist?removed=1"
                            : buildRedirectUrl(referer,
                                    req.getContextPath() + "/products?id=" + bookID,
                                    "wishResult=removed");
                    resp.sendRedirect(back);
                }
                break;
            }
            case "moveToCart": {
                wishlistDAO.moveToCart(account.getId(), bookID);
                int qty = parseIntParam(req.getParameter("quantity"), 1);
                wishlistDAO.moveToCart(account.getId(), bookID, qty);
                int wCount = wishlistDAO.countWishlistItems(account.getId());
                int cCount = new dao.CartDAO().countCartItems(account.getId());
                req.getSession().setAttribute("wishlistCount", wCount);
                req.getSession().setAttribute("cartCount", cCount);
                if (isAjax) {
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    resp.getWriter().write(String.format("{\"success\":true,\"action\":\"moved_to_cart\",\"wishlistCount\":%d,\"cartCount\":%d}", wCount, cCount));
                } else {
                    resp.sendRedirect(req.getContextPath() + "/wishlist?movedToCart=1");
                }
                break;
            }
            default:
                if (isAjax) {
                    resp.setContentType("application/json");
                    resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    resp.getWriter().write("{\"success\":false,\"error\":\"unknown_action\"}");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/wishlist");
                }
        }
    }

    // ── Helper: guard customer ────────────────────────────────────────
    private Account requireCustomer(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        Account acc = (session != null) ? (Account) session.getAttribute("account") : null;

        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))
                || "true".equals(req.getParameter("ajax"));

        if (acc == null) {
            if (isAjax) {
                resp.setContentType("application/json");
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.getWriter().write("{\"success\":false,\"error\":\"unauthorized\",\"redirect\":\"" + req.getContextPath() + "/login\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/login");
            }
            return null;
        }
        if (!"customer".equals(acc.getRole())) {
            if (isAjax) {
                resp.setContentType("application/json");
                resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
                resp.getWriter().write("{\"success\":false,\"error\":\"forbidden\",\"redirect\":\"" + req.getContextPath() + "/home\"}");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }
            return null;
        }
        return acc;
    }

    private void redirect(HttpServletResponse resp, String referer, String fallback)
            throws IOException {
        resp.sendRedirect(referer != null && !referer.isEmpty() ? referer : fallback);
    }

    private String buildRedirectUrl(String referer, String fallback, String extraParam) {
        String base = (referer != null && !referer.isEmpty()) ? referer : fallback;
        // Xóa param wishResult cũ nếu có
        base = base.replaceAll("[&?]wishResult=[^&]*", "")
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
}
