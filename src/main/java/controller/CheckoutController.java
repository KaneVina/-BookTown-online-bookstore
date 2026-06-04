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

public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Kiểm tra đăng nhập
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

        // 2. Lấy cart items từ DB (tái sử dụng CartDAO có sẵn)
        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

        // 3. Nếu giỏ trống thì quay về giỏ hàng
        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // 4. Tính tiền (giống CartController)
        BigDecimal subtotal   = cartDAO.calcSubtotal(cartItems);
        BigDecimal shippingFee = new BigDecimal("30000");
        BigDecimal total      = subtotal.add(shippingFee);

        // 5. Truyền sang JSP
        req.setAttribute("cartItems",   cartItems);
        req.setAttribute("subtotal",    subtotal);
        req.setAttribute("shippingFee", shippingFee);
        req.setAttribute("total",       total);

        req.getRequestDispatcher("/views/cart/checkout.jsp").forward(req, resp);
    }
}