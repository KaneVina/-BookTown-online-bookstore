package controller;

import dao.WishListDAO;
import model.Account;
import model.Book;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class WishListController extends HttpServlet {

    private final WishListDAO wishListDAO = new WishListDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account acc = (Account) session.getAttribute("account");

        if (acc == null || !acc.getRole().equals("customer")) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<Book> wishlistBooks = wishListDAO.getWishListBooks(acc.getId());
        req.setAttribute("wishlistBooks", wishlistBooks);

        req.getRequestDispatcher("/views/book/wishlist.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession();
        Account acc = (Account) session.getAttribute("account");

        if (acc == null || !acc.getRole().equals("customer")) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String bookIdParam = req.getParameter("bookID");

        if (action == null || bookIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        int bookId;
        try {
            bookId = Integer.parseInt(bookIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        String redirectUrl = req.getParameter("redirect");
        if (redirectUrl == null || redirectUrl.isEmpty()) {
            redirectUrl = req.getHeader("Referer");
        }

        if ("add".equalsIgnoreCase(action)) {
            wishListDAO.addToWishList(acc.getId(), bookId);
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                resp.sendRedirect(redirectUrl);
            } else {
                resp.sendRedirect(req.getContextPath() + "/products?id=" + bookId);
            }
        } else if ("remove".equalsIgnoreCase(action)) {
            wishListDAO.removeFromWishList(acc.getId(), bookId);
            if (redirectUrl != null && !redirectUrl.isEmpty()) {
                resp.sendRedirect(redirectUrl);
            } else {
                resp.sendRedirect(req.getContextPath() + "/wishlist");
            }
        } else if ("moveToCart".equalsIgnoreCase(action)) {
            boolean success = wishListDAO.moveToCart(acc.getId(), bookId);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/wishlist?success=moveToCart");
            } else {
                resp.sendRedirect(req.getContextPath() + "/wishlist?error=moveToCart");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }
}
