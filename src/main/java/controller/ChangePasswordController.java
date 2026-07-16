package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

public class ChangePasswordController extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account acc = (Account) session.getAttribute("account");

        if ("customer".equalsIgnoreCase(acc.getRole())) {
            request.getRequestDispatcher(
                    "/views/profile/changePassword.jsp"
            ).forward(request, response);
        } else {
            request.getRequestDispatcher(
                    "/views/profile/changePassword-admin.jsp"
            ).forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Chưa đăng nhập\"}"
            );
            return;
        }

        Account acc = (Account) session.getAttribute("account");

        if (acc == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Chưa đăng nhập\"}"
            );
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        try (PrintWriter out = response.getWriter()) {

            String validationError = validatePasswordChange(
                    currentPassword,
                    newPassword,
                    confirmPassword
            );

            if (validationError != null) {
                out.write(
                        "{\"success\":false,\"message\":\""
                        + validationError
                        + "\"}"
                );
                return;
            }

            boolean success;

            if ("customer".equalsIgnoreCase(acc.getRole())) {

                success = customerDAO.changePassword(
                        acc.getId(),
                        currentPassword.trim(),
                        newPassword
                );

            } else {

                success = accountDAO.changePassword(
                        acc.getId(),
                        currentPassword.trim(),
                        newPassword
                );
            }

            if (success) {

                session.invalidate();
                out.write(
                        "{\"success\":true,\"message\":\"Đổi mật khẩu thành công\"}"
                );

            } else {

                out.write(
                        "{\"success\":false,\"message\":\"Mật khẩu hiện tại không đúng\"}"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);

            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Đã xảy ra lỗi hệ thống\"}"
            );
        }
    }

    private String validatePasswordChange(
            String currentPassword,
            String newPassword,
            String confirmPassword) {

        if (currentPassword == null || currentPassword.trim().isEmpty()) {
            return "Vui lòng nhập mật khẩu hiện tại";
        }

        if (newPassword == null || newPassword.isEmpty()) {
            return "Vui lòng nhập mật khẩu mới";
        }

        if (confirmPassword == null || confirmPassword.isEmpty()) {
            return "Vui lòng xác nhận mật khẩu mới";
        }

        currentPassword = currentPassword.trim();

        // Không cho phép khoảng trắng ở bất kỳ vị trí nào
        if (newPassword.matches(".*\\s.*")) {
            return "Mật khẩu không được chứa khoảng trắng";
        }

        if (confirmPassword.matches(".*\\s.*")) {
            return "Mật khẩu xác nhận không được chứa khoảng trắng";
        }

        String error = validateNewPassword(newPassword);

        if (error != null) {
            return error;
        }

        if (currentPassword.equals(newPassword)) {
            return "Mật khẩu mới phải khác mật khẩu hiện tại";
        }

        if (!newPassword.equals(confirmPassword)) {
            return "Xác nhận mật khẩu không khớp";
        }

        return null;
    }

    private String validateNewPassword(String newPassword) {

        if (newPassword == null || newPassword.isEmpty()) {
            return "Mật khẩu không được để trống";
        }

        if (newPassword.length() < 8) {
            return "Mật khẩu phải ít nhất 8 ký tự";
        }

        if (newPassword.length() > 15) {
            return "Mật khẩu không được vượt quá 15 ký tự";
        }

        String passwordPattern
                = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&.#^_+=-])[A-Za-z\\d@$!%*?&.#^_+=-]{8,15}$";

        if (!newPassword.matches(passwordPattern)) {
            return "Mật khẩu phải chứa chữ hoa, chữ thường, số và ký tự đặc biệt";
        }

        return null;
    }

    @Override
    public String getServletInfo() {
        return "Change Password Controller";
    }
}