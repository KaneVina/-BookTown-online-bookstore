package controller;

import dao.BookDAO;
import dao.WishListDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import model.Account;
import model.Book;

public class HomeController extends HttpServlet {

    private final BookDAO bookDAO = new BookDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Sách nổi bật: top 5 theo số lượng đặt hàng (OrderDetail)
        List<Book> featuredBooks = bookDAO.getFeaturedByOrders(5);
        req.setAttribute("featuredBooks", featuredBooks);

        // Sách mới nhất: top 5 theo created_at DESC
        List<Book> newBooks = bookDAO.getNewBooks(5);
        req.setAttribute("newBooks", newBooks);

        // Wishlist badge cho header (nếu đã đăng nhập) & load list sách yêu thích
        HttpSession session = req.getSession(false);
        Set<Integer> wishlistBookIds = new HashSet<>();
        if (session != null) {
            Account account = (Account) session.getAttribute("account");
            if (account != null && "customer".equals(account.getRole())) {
                WishListDAO wDAO = new WishListDAO();
                wDAO.getWishlistItems(account.getId()).forEach(wi -> wishlistBookIds.add(wi.getBookID()));
                session.setAttribute("wishlistCount", wDAO.countWishlistItems(account.getId()));
            }
        }
        req.setAttribute("wishlistBookIds", wishlistBookIds);

        // Toast messages từ redirect parameters
        String addResult = req.getParameter("addResult");
        if ("success".equals(addResult)) {
            req.setAttribute("successMessage", "Đã thêm vào giỏ hàng!");
        } else if ("error".equals(addResult)) {
            req.setAttribute("errorMessage", "Không thể thêm vào giỏ hàng.");
        }
        String wishResult = req.getParameter("wishResult");
        if ("added".equals(wishResult)) {
            req.setAttribute("successMessage", "Đã thêm vào yêu thích!");
        } else if ("removed".equals(wishResult)) {
            req.setAttribute("successMessage", "Đã xóa khỏi yêu thích!");
        } else if ("wishError".equals(wishResult)) {
            String wishMessage = req.getParameter("wishMessage");
            req.setAttribute("errorMessage",
                    wishMessage != null && !wishMessage.isBlank()
                            ? wishMessage
                            : "Có lỗi xảy ra, vui lòng thử lại.");
        }

        req.getRequestDispatcher("/views/book/index.jsp").forward(req, resp);
    }
}
