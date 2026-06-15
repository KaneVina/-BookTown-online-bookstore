package controller;

import dao.AccountDAO;
import dao.CartDAO;
import model.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.CartItem;

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
                List<CartItem> items = cartDAO.getCartItems(acc.getId());

                int total = 0;
                for (CartItem item : items) {
                    total += item.getQuantity();
                }
                session.setAttribute("cartCount", total);
            }

            Cookie emailCookie = new Cookie("savedEmail", email);
            emailCookie.setMaxAge(24 * 60 * 60);
            emailCookie.setHttpOnly(true);
            response.addCookie(emailCookie);

            if (acc.getRole().equals("admin") || acc.getRole().equals("staff")) {
                response.sendRedirect(request.getContextPath() + "/dashboard/account-management");
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
