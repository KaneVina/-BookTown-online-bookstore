package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ResetPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Bảo vệ trang: phải đã xác thực OTP thành công mới được vào
        if (session == null
                || !Boolean.TRUE.equals(session.getAttribute("fp_verified"))
                || session.getAttribute("otp_email") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Bảo vệ: kiểm tra session hợp lệ
        if (session == null
                || !Boolean.TRUE.equals(session.getAttribute("fp_verified"))
                || session.getAttribute("otp_email") == null) {
            response.sendRedirect(request.getContextPath() + "/forgot-password");
            return;
        }

        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        String email           = (String) session.getAttribute("otp_email");

        // ── Validate ──────────────────────────────────────────────────────

        // Không được để trống
        if (newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Vui lòng nhập đầy đủ mật khẩu.");
            request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        // Phải khớp nhau
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu xác nhận không khớp. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        // Độ dài 8–15 ký tự, có chữ hoa, chữ thường và số
        if (!isValidPassword(newPassword)) {
            request.setAttribute("errorMessage", "Mật khẩu phải từ 8–15 ký tự, gồm chữ hoa, chữ thường và số.");
            request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        // ── Cập nhật DB ───────────────────────────────────────────────────
        // Thử update bảng Customer trước, nếu không có thì thử bảng Account
        CustomerDAO customerDAO = new CustomerDAO();
        AccountDAO  accountDAO  = new AccountDAO();

        boolean updated = customerDAO.resetPasswordByEmail(email, newPassword);
        if (!updated) {
            updated = accountDAO.resetPasswordByEmail(email, newPassword);
        }

        if (!updated) {
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật mật khẩu. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/auth/reset-password.jsp").forward(request, response);
            return;
        }

        // ── Thành công: dọn session và redirect về login ──────────────────
        session.removeAttribute("fp_verified");
        session.removeAttribute("otp_email");

        session.setAttribute("register_success", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập.");
        response.sendRedirect(request.getContextPath() + "/login");
    }

    // Kiểm tra mật khẩu hợp lệ: 8–15 ký tự, có chữ hoa, chữ thường, số
    private boolean isValidPassword(String password) {
        if (password.length() < 8 || password.length() > 15) return false;
        boolean hasUpper  = password.chars().anyMatch(Character::isUpperCase);
        boolean hasLower  = password.chars().anyMatch(Character::isLowerCase);
        boolean hasDigit  = password.chars().anyMatch(Character::isDigit);
        return hasUpper && hasLower && hasDigit;
    }
}