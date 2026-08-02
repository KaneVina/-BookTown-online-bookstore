package controller;

import dao.GenreDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Account;
import model.Genre;

public class CategoryManagementController extends HttpServlet {

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
                setFlash(request, "error", "Bạn không có quyền thêm thể loại.");
                response.sendRedirect(request.getContextPath()
                        + "/dashboard/category-management");
                return;
            }

            request.setAttribute("pageTitle", "Thêm thể loại");
            request.setAttribute("formAction", "create");
            request.getRequestDispatcher("/views/category/form.jsp")
                    .forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            if (!canManageCategory) {
                setFlash(request, "error", "Bạn không có quyền cập nhật thể loại.");
                response.sendRedirect(request.getContextPath()
                        + "/dashboard/category-management");
                return;
            }

            int id = parseInt(request.getParameter("id"));
            Genre genre = genreDAO.getGenreById(id);

            if (genre == null) {
                setFlash(request, "error", "Không tìm thấy thể loại.");
                response.sendRedirect(request.getContextPath()
                        + "/dashboard/category-management");
                return;
            }

            request.setAttribute("genre", genre);
            request.setAttribute("pageTitle", "Cập nhật thể loại");
            request.setAttribute("formAction", "update");
            request.getRequestDispatcher("/views/category/form.jsp")
                    .forward(request, response);
            return;
        }

        if ("detail".equals(action)) {
            int id = parseInt(request.getParameter("id"));
            Genre genre = genreDAO.getGenreById(id);

            if (genre == null) {
                setFlash(request, "error", "Không tìm thấy thể loại.");
                response.sendRedirect(request.getContextPath()
                        + "/dashboard/category-management");
                return;
            }

            request.setAttribute("genre", genre);
            request.getRequestDispatcher("/views/category/detail.jsp")
                    .forward(request, response);
            return;
        }

        String keyword = clean(request.getParameter("keyword"));
        List<Genre> genres = keyword.isEmpty()
                ? genreDAO.getAllGenres()
                : genreDAO.searchGenres(keyword);

        request.setAttribute("genres", genres);
        request.setAttribute("keyword", keyword);
        request.setAttribute("totalCategories", genres.size());
        request.getRequestDispatcher("/views/category/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String redirectUrl = request.getContextPath()
                + "/dashboard/category-management";

        if (!canManageCategory(request)) {
            setFlash(request, "error", "Bạn không có quyền thực hiện thao tác này.");
            response.sendRedirect(redirectUrl);
            return;
        }

        if ("create".equals(action)) {
            String name = clean(request.getParameter("genre_name"));

            String validationError = validateGenreName(name);
            if (validationError != null) {
                setFlash(request, "error", validationError);
                response.sendRedirect(redirectUrl + "?action=create");
                return;
            }

            if (genreDAO.isGenreNameExists(name)) {
                setFlash(request, "error", "Tên thể loại đã tồn tại.");
                response.sendRedirect(redirectUrl + "?action=create");
                return;
            }

            boolean success = genreDAO.insertGenre(name);
            setFlash(request, success ? "success" : "error",
                    success ? "Thêm thể loại thành công." : "Không thể thêm thể loại.");
            response.sendRedirect(redirectUrl + (success ? "" : "?action=create"));
            return;
        }

        if ("update".equals(action)) {
            int id = parseInt(request.getParameter("id"));
            String name = clean(request.getParameter("genre_name"));

            if (id <= 0) {
                setFlash(request, "error", "Mã thể loại không hợp lệ.");
                response.sendRedirect(redirectUrl);
                return;
            }

            String validationError = validateGenreName(name);
            if (validationError != null) {
                setFlash(request, "error", validationError);
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id);
                return;
            }

            if (genreDAO.isGenreNameExists(name, id)) {
                setFlash(request, "error", "Tên thể loại đã tồn tại.");
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id);
                return;
            }

            boolean success = genreDAO.updateGenre(id, name);

            if (success) {
                setFlash(request, "success", "Cập nhật thể loại thành công.");
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id);
            } else {
                setFlash(request, "error", "Không thể cập nhật thể loại.");
                response.sendRedirect(redirectUrl + "?action=detail&id=" + id);
            }
            return;
        }

        if ("delete".equals(action)) {
            int id = parseInt(request.getParameter("id"));

            if (id <= 0) {
                setFlash(request, "error", "Mã thể loại không hợp lệ.");
                response.sendRedirect(redirectUrl);
                return;
            }

            int bookCount = genreDAO.countBooksByGenre(id);
            if (bookCount > 0) {
                setFlash(request, "error", "Không thể xóa thể loại đang có sách.");
                response.sendRedirect(redirectUrl);
                return;
            }

            boolean success = genreDAO.deleteGenre(id);
            setFlash(request, success ? "success" : "error",
                    success ? "Xóa thể loại thành công." : "Không thể xóa thể loại.");
            response.sendRedirect(redirectUrl);
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

    private String validateGenreName(String name) {
        if (name == null || name.isEmpty()) {
            return "Tên thể loại không được để trống.";
        }

        if (name.length() > 100) {
            return "Tên thể loại không được vượt quá 100 ký tự.";
        }

        if (!name.matches("^[\\p{L}\\s]+$")) {
            return "Tên thể loại chỉ được chứa chữ cái và khoảng trắng, không được chứa số hoặc ký tự đặc biệt.";
        }

        return null;
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

    private void setFlash(HttpServletRequest request, String type, String message) {
        request.getSession().setAttribute(type, message);
    }
}