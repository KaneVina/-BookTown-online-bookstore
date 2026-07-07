package controller;

import dao.GenreDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import model.Account;
import model.Genre;

public class CategoryManagementController extends HttpServlet {
// category
    private final GenreDAO genreDAO = new GenreDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        boolean canManageCategory = canManageCategory(request);
        request.setAttribute("canManageCategory", canManageCategory);

        if ("create".equals(action)) {
            if (!canManageCategory) {
                response.sendRedirect(request.getContextPath() + "/category?error=" + encode("Bạn không có quyền thêm thể loại."));
                return;
            }
            request.setAttribute("pageTitle", "Thêm thể loại");
            request.setAttribute("formAction", "create");
            request.getRequestDispatcher("/views/category/form.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            if (!canManageCategory) {
                response.sendRedirect(request.getContextPath() + "/category?error=" + encode("Bạn không có quyền cập nhật thể loại."));
                return;
            }
            int id = parseInt(request.getParameter("id"));
            Genre genre = genreDAO.getGenreById(id);
            if (genre == null) {
                response.sendRedirect(request.getContextPath() + "/category?error=" + encode("Không tìm thấy thể loại."));
                return;
            }
            request.setAttribute("genre", genre);
            request.setAttribute("pageTitle", "Cập nhật thể loại");
            request.setAttribute("formAction", "update");
            request.getRequestDispatcher("/views/category/form.jsp").forward(request, response);
            return;
        }

        if ("detail".equals(action)) {
            int id = parseInt(request.getParameter("id"));
            Genre genre = genreDAO.getGenreById(id);
            if (genre == null) {
                response.sendRedirect(request.getContextPath() + "/category?error=" + encode("Không tìm thấy thể loại."));
                return;
            }
            request.setAttribute("genre", genre);
            request.getRequestDispatcher("/views/category/detail.jsp").forward(request, response);
            return;
        }

        String keyword = clean(request.getParameter("keyword"));
        List<Genre> genres = keyword.isEmpty()
                ? genreDAO.getAllGenres()
                : genreDAO.searchGenres(keyword);

        request.setAttribute("genres", genres);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalCategories", genres.size());
        request.getRequestDispatcher("/views/category/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath() + "/category";

        if (!canManageCategory(request)) {
            response.sendRedirect(redirectUrl + "?error=" + encode("Bạn không có quyền thực hiện thao tác này."));
            return;
        }

        if ("create".equals(action)) {
            String name = clean(request.getParameter("genre_name"));

            if (name.isEmpty()) {
                response.sendRedirect(redirectUrl + "?error=" + encode("Tên thể loại không được để trống."));
                return;
            }

            if (name.length() > 100) {
                response.sendRedirect(redirectUrl + "?error=" + encode("Tên thể loại không được vượt quá 100 ký tự."));
                return;
            }

            if (genreDAO.isGenreNameExists(name)) {
                response.sendRedirect(redirectUrl + "?error=" + encode("Tên thể loại đã tồn tại."));
                return;
            }

            boolean success = genreDAO.insertGenre(name);
            response.sendRedirect(redirectUrl + (success
                    ? "?success=" + encode("Thêm thể loại thành công.")
                    : "?error=" + encode("Không thể thêm thể loại.")));
            return;
        }

        if ("update".equals(action)) {
            int id = parseInt(request.getParameter("id"));
            String name = clean(request.getParameter("genre_name"));

            if (id <= 0) {
                response.sendRedirect(redirectUrl + "?error=" + encode("Mã thể loại không hợp lệ."));
                return;
            }

            if (name.isEmpty()) {
                response.sendRedirect(redirectUrl + "?error=" + encode("Tên thể loại không được để trống."));
                return;
            }

            if (name.length() > 100) {
                response.sendRedirect(redirectUrl + "?error=" + encode("Tên thể loại không được vượt quá 100 ký tự."));
                return;
            }

            if (genreDAO.isGenreNameExists(name, id)) {
                response.sendRedirect(redirectUrl + "?error=" + encode("Tên thể loại đã tồn tại."));
                return;
            }

            boolean success = genreDAO.updateGenre(id, name);
            if (success) {
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id
                        + "&success=" + encode("Cập nhật thể loại thành công."));
            } else {
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id
                        + "&error=" + encode("Không thể cập nhật thể loại."));
            }
            return;
        }

        if ("delete".equals(action)) {
            int id = parseInt(request.getParameter("id"));

            if (id <= 0) {
                response.sendRedirect(redirectUrl + "?error=" + encode("Mã thể loại không hợp lệ."));
                return;
            }

            int bookCount = genreDAO.countBooksByGenre(id);
            if (bookCount > 0) {
                response.sendRedirect(redirectUrl + "?error=" + encode("Không thể xóa thể loại đang có sách."));
                return;
            }

            boolean success = genreDAO.deleteGenre(id);
            response.sendRedirect(redirectUrl + (success
                    ? "?success=" + encode("Xóa thể loại thành công.")
                    : "?error=" + encode("Không thể xóa thể loại.")));
            return;
        }

        response.sendRedirect(redirectUrl);
    }

    private boolean canManageCategory(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        Account account = (Account) session.getAttribute("account");
        if (account == null || account.getRole() == null) {
            return false;
        }
        String role = account.getRole().trim().toLowerCase();
        return "staff".equals(role) || "admin".equals(role);
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }

    private String clean(String value) {
        return value == null ? "" : value.trim().replaceAll("\\s+", " ");
    }

    private String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
