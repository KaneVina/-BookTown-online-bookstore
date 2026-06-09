package controller;

import dao.CartDAO;
import model.CartItem;
import dao.AccountDAO;
import model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        AccountDAO accountDAO = new AccountDAO();
        Account acc = accountDAO.checkLogin(email, password);

        if (acc != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", acc);
            session.setMaxInactiveInterval(30 * 60);

            if ("customer".equals(acc.getRole())) {
                CartDAO cartDAO = new CartDAO();
                java.util.List<CartItem> items = cartDAO.getCartItems(acc.getId());
                int totalQty = 0;
                for (CartItem item : items) {
                    totalQty += item.getQuantity();
                }
                session.setAttribute("cartCount", totalQty);
            }

            Cookie emailCookie = new Cookie("savedEmail", email);
            emailCookie.setMaxAge(24 * 60 * 60);
            emailCookie.setHttpOnly(true);
            response.addCookie(emailCookie);

            if (acc.getRole().equals("admin") || acc.getRole().equals("staff")) {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("errorMessage", "Email hoặc mật khẩu không chính xác!");
            request.setAttribute("enteredEmail", email);
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
    }
}
