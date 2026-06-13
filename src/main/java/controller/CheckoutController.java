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

/**
 *
 * @author Kim Chi
 */
public class CheckoutController extends HttpServlet {

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
        List<CartItem> cartItemList = cartDAO.getCartItems(account.getId());

        if (cartItemList.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        BigDecimal subtotal = cartDAO.calcSubtotal(cartItemList);

        int totalQuantity = 0;
        for (CartItem item : cartItemList) {
            totalQuantity += item.getQuantity();
        }

        req.setAttribute("cartItems", cartItemList);
        req.setAttribute("total", subtotal);
        req.setAttribute("totalQuantity", totalQuantity);

        req.getRequestDispatcher("/views/cart/checkout.jsp").forward(req, resp);
    }
}
