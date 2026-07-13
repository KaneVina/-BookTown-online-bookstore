package controller;

import dao.BookDAO;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Book;

import java.io.IOException;
import java.util.List;

public class DashboardController extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Auth guard
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        Account acc = (Account) session.getAttribute("account");
        if (!"admin".equals(acc.getRole()) && !"staff".equals(acc.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // Stats tổng quan sách
        int totalBooks       = bookDAO.countAllBooks();
        int availableBooks   = bookDAO.countBooksByStatus("available");
        int outOfStockBooks  = bookDAO.countBooksByStatus("out_of_stock");
        int discontinuedBooks = bookDAO.countBooksByStatus("discontinued");

        // Danh sách sách mới thêm gần đây (8 cuốn)
        List<Book> recentBooks = bookDAO.getRecentBooksAdmin(8);

        // Tổng nhân viên
        int totalStaffs = accountDAO.countStaffs();

        req.setAttribute("totalBooks",        totalBooks);
        req.setAttribute("availableBooks",    availableBooks);
        req.setAttribute("outOfStockBooks",   outOfStockBooks);
        req.setAttribute("discontinuedBooks", discontinuedBooks);
        req.setAttribute("recentBooks",       recentBooks);
        req.setAttribute("totalStaffs",       totalStaffs);

        req.getRequestDispatcher("/views/admin/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        doGet(req, resp);
    }
}
