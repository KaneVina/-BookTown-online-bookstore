package controller;

import dao.BookDAO;
import dao.LookupDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import utils.RoleGuard;
import model.Book;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * AdminProductController – quản lý sách cho Admin/Staff. URL pattern:
 * /dashboard/product-management doGet action=null → danh sách doGet
 * action=create → form tạo mới doGet action=edit&id → form sửa doPost
 * action=create → xử lý tạo doPost action=update → xử lý cập nhật doPost
 * action=delete → soft delete
 */
public class AdminProductController extends HttpServlet {

    private static final int PAGE_SIZE = 10;
    private final BookDAO bookDAO = new BookDAO();
    private final LookupDAO lookupDAO = new LookupDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Account account = requireStaff(req, resp);
        if (account == null) {
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "create":
                showForm(req, resp, null);
                break;
            case "edit":
                showEditForm(req, resp);
                break;
            default:
                showList(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        Account account = requireStaff(req, resp);
        if (account == null) {
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            action = "";
        }

        switch (action) {
            case "create":
                handleCreate(req, resp, account);
                break;
            case "update":
                handleUpdate(req, resp, account);
                break;
            case "delete":
                handleDelete(req, resp, account);
                break;
            case "restore":
                handleRestore(req, resp, account);
                break;
            default:
                resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
        }
    }

    // ── Danh sách ─────────────────────────────────────────────────────
    private void showList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int page = parsePage(req.getParameter("page"));
        String keyword = req.getParameter("keyword");
        String status = req.getParameter("status");
        Integer genreID = parseIntParam(req.getParameter("genre"));

        int total = bookDAO.countBooksAdmin(keyword, status, genreID);
        int totalPages = Math.max(1, (int) Math.ceil((double) total / PAGE_SIZE));
        if (page > totalPages) {
            page = totalPages;
        }

        List<Book> books = bookDAO.getBooksAdmin((page - 1) * PAGE_SIZE, PAGE_SIZE, keyword, status, genreID);
        Map<Integer, String> genreMap = bookDAO.getGenreMap();

        req.setAttribute("books", books);
        req.setAttribute("total", total);
        req.setAttribute("page", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("keyword", keyword);
        req.setAttribute("status", status);
        req.setAttribute("genreID", genreID);
        req.setAttribute("genreMap", genreMap);

        req.getRequestDispatcher("/views/admin/product/product-management.jsp").forward(req, resp);
    }

    // ── Form tạo mới ──────────────────────────────────────────────────
    private void showForm(HttpServletRequest req, HttpServletResponse resp, Book book)
            throws ServletException, IOException {
        lookupDAO.ensureDefaultLookups();
        req.setAttribute("book", book);
        req.setAttribute("genreMap", bookDAO.getGenreMap());
        req.setAttribute("originMap", bookDAO.getOriginMap());
        req.setAttribute("contentMap", bookDAO.getContentMap());
        req.setAttribute("seriesMap", bookDAO.getSeriesMap());
        req.setAttribute("formAction", "create");
        req.getRequestDispatcher("/views/admin/product/product-form.jsp").forward(req, resp);
    }

    // ── Form chỉnh sửa ────────────────────────────────────────────────
    private void showEditForm(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int bookID = parseID(req.getParameter("id"));
        if (bookID <= 0) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
            return;
        }
        Book book = bookDAO.getBookByID(bookID);
        if (book == null) {
            req.getSession().setAttribute("errorMessage", "Không tìm thấy sách!");
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
            return;
        }

        // Parse pipe-separated images: thumbnail|image2|image3|image4
        String[] imgParts = book.getThumbnail() != null ? book.getThumbnail().split("\\|", -1) : new String[0];
        String img1 = imgParts.length > 0 ? imgParts[0].trim() : "";
        String img2 = imgParts.length > 1 ? imgParts[1].trim() : "";
        String img3 = imgParts.length > 2 ? imgParts[2].trim() : "";
        String img4 = imgParts.length > 3 ? imgParts[3].trim() : "";
        book.setThumbnail(img1); // form shows only main image in thumbnail field
        req.setAttribute("image2", img2);
        req.setAttribute("image3", img3);
        req.setAttribute("image4", img4);

        lookupDAO.ensureDefaultLookups();
        req.setAttribute("book", book);
        req.setAttribute("genreMap", bookDAO.getGenreMap());
        req.setAttribute("originMap", bookDAO.getOriginMap());
        req.setAttribute("contentMap", bookDAO.getContentMap());
        req.setAttribute("seriesMap", bookDAO.getSeriesMap());
        req.setAttribute("formAction", "update");
        req.getRequestDispatcher("/views/admin/product/product-form.jsp").forward(req, resp);
    }

    // ── Tạo sách ─────────────────────────────────────────────────────
    private void handleCreate(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
        Book b = buildBookFromRequest(req);
        String authors = req.getParameter("authors");
        boolean ok = bookDAO.createBook(b, authors, account.getId());
        HttpSession session = req.getSession();
        if (ok) {
            session.setAttribute("successMessage", "Thêm sách thành công!");
        } else {
            session.setAttribute("errorMessage", "Thêm sách thất bại, vui lòng thử lại!");
        }
        resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
    }

    // ── Cập nhật sách ────────────────────────────────────────────────
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
        int bookID = parseID(req.getParameter("bookID"));
        if (bookID <= 0) {
            resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
            return;
        }
        Book b = buildBookFromRequest(req);
        b.setBookID(bookID);
        String authors = req.getParameter("authors");
        boolean ok = bookDAO.updateBook(b, authors, account.getId());
        HttpSession session = req.getSession();
        if (ok) {
            session.setAttribute("successMessage", "Cập nhật sách thành công!");
        } else {
            session.setAttribute("errorMessage", "Cập nhật thất bại, vui lòng thử lại!");
        }
        resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
    }

    // ── Soft delete ──────────────────────────────────────────────────
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, Account account)
            throws IOException {
        int bookID = parseID(req.getParameter("bookID"));
        HttpSession session = req.getSession();
        if (bookID > 0) {
            boolean ok = bookDAO.deleteBook(bookID, account.getId());
            if (ok) {
                session.setAttribute("successMessage", "Đã ngừng bán sách!");
            } else {
                session.setAttribute("errorMessage", "Xóa thất bại, vui lòng thử lại!");
            }
        }
        resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
    }
    private void handleRestore(HttpServletRequest req, HttpServletResponse resp, Account account)
        throws IOException {
    int bookID = parseID(req.getParameter("bookID"));
    HttpSession session = req.getSession();
    if (bookID > 0) {
        boolean ok = bookDAO.restoreBook(bookID, account.getId());
        if (ok) {
            session.setAttribute("successMessage", "Đã bán hàng lại!");
        } else {
            session.setAttribute("errorMessage", "Bán hàng lại thất bại, vui lòng thử lại!");
        }
    }
    resp.sendRedirect(req.getContextPath() + "/dashboard/product-management");
}

    // ── Build Book từ request ────────────────────────────────────────────────
    private Book buildBookFromRequest(HttpServletRequest req) {
        Book b = new Book();
        b.setTitle(req.getParameter("title"));
        b.setDescription(req.getParameter("description"));

        // Combine thumbnail + image2 + image3 + image4 into pipe-separated string
        String thumb = clean(req.getParameter("thumbnail"));
        String img2 = clean(req.getParameter("image2"));
        String img3 = clean(req.getParameter("image3"));
        String img4 = clean(req.getParameter("image4"));
        StringBuilder allImages = new StringBuilder(thumb);
        if (!img2.isEmpty()) {
            allImages.append("|").append(img2);
        }
        if (!img3.isEmpty()) {
            allImages.append("|").append(img3);
        }
        if (!img4.isEmpty()) {
            allImages.append("|").append(img4);
        }
        b.setThumbnail(allImages.toString());

        try {
            b.setPrice(new BigDecimal(req.getParameter("price")));
        } catch (Exception e) {
            b.setPrice(BigDecimal.ZERO);
        }
        try {
            b.setStockQuantity(Integer.parseInt(req.getParameter("stockQuantity")));
        } catch (Exception e) {
            b.setStockQuantity(0);
        }
        try {
            b.setTotalPages(Integer.parseInt(req.getParameter("totalPages")));
        } catch (Exception e) {
            b.setTotalPages(0);
        }
        b.setDimensions(req.getParameter("dimensions"));
        try {
            String w = req.getParameter("weight");
            if (w != null && !w.isEmpty()) {
                b.setWeight(new BigDecimal(w));
            }
        } catch (Exception e) {
        }

        String status = req.getParameter("status") != null ? req.getParameter("status") : "available";
        if (b.getStockQuantity() == 0) {
            b.setStatus("discontinued");
        } else {
            b.setStatus(status);
        }
        Integer gid = parseIntParam(req.getParameter("genreID"));
        if (gid != null) {
            b.setGenreID(gid);
        }
        Integer cid = parseIntParam(req.getParameter("contentID"));
        if (cid != null) {
            b.setContentID(cid);
        }
        Integer sid = parseIntParam(req.getParameter("seriesID"));
        if (sid != null) {
            b.setSeriesID(sid);
        }
        Integer oid = parseIntParam(req.getParameter("originID"));
        if (oid != null) {
            b.setOriginID(oid);
        }
        return b;
    }

    private String clean(String s) {
        return (s == null) ? "" : s.trim();
    }

    // ── Auth guard ───────────────────────────────────────────────────
    private Account requireStaff(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        return RoleGuard.requireStaff(req, resp);
    }

    // ── Helpers ──────────────────────────────────────────────────────
    private int parsePage(String param) {
        if (param == null) {
            return 1;
        }
        try {
            int p = Integer.parseInt(param.trim());
            return p < 1 ? 1 : p;
        } catch (Exception e) {
            return 1;
        }
    }

    private int parseID(String param) {
        if (param == null) {
            return -1;
        }
        try {
            return Integer.parseInt(param.trim());
        } catch (Exception e) {
            return -1;
        }
    }

    private Integer parseIntParam(String param) {
        if (param == null || param.trim().isEmpty()) {
            return null;
        }
        try {
            int v = Integer.parseInt(param.trim());
            return v > 0 ? v : null;
        } catch (Exception e) {
            return null;
        }
    }
}
