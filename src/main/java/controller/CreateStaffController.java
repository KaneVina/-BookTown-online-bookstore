package controller;

import dao.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import utils.EmailUtil;

public class CreateStaffController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account loginUser = (Account) session.getAttribute("account");
        if (loginUser == null || !loginUser.getRole().equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setAttribute("mode", "add");
        request.getRequestDispatcher("/views/admin/account/create-staff.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.setStatus(401);
            response.getWriter().write("{\"success\":false,\"message\":\"Chưa đăng nhập\"}");
            return;
        }
        Account loginUser = (Account) session.getAttribute("account");
        if (loginUser == null || !loginUser.getRole().equals("admin")) {
            response.setStatus(403);
            response.getWriter().write("{\"success\":false,\"message\":\"Không có quyền thực hiện\"}");
            return;
        }
        AccountDAO dao = new AccountDAO();
        try (PrintWriter out = response.getWriter()) {
            String mode = request.getParameter("mode");
            String fullname = request.getParameter("fullname");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String role = request.getParameter("role");
            String password = request.getParameter("password");
            String status = request.getParameter("status");

            // Validate bắt buộc
            if (fullname == null || fullname.trim().isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Vui lòng nhập họ tên\"}");
                return;
            }
            if (email == null || email.trim().isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Vui lòng nhập email\"}");
                return;
            }
            if (role == null || role.trim().isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Vui lòng chọn vai trò\"}");
                return;
            }
            // Chỉ cho phép tạo staff hoặc admin
            if (!role.equals("staff") && !role.equals("admin")) {
                out.write("{\"success\":false,\"message\":\"Vai trò không hợp lệ\"}");
                return;
            }
            if (password == null || password.trim().isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Vui lòng nhập mật khẩu\"}");
                return;
            }
            if (password.length() < 6) {
                out.write("{\"success\":false,\"message\":\"Mật khẩu phải ít nhất 6 ký tự\"}");
                return;
            }
            if (phone == null || phone.trim().isEmpty()) {
                out.write("{\"success\":false,\"message\":\"Vui lòng nhập số điện thoại\"}");
                return;
            }

            String phoneError = validatePhone(phone);
            if (phoneError != null) {
                out.write("{\"success\":false,\"message\":\"" + phoneError + "\"}");
                return;
            }
            // Mặc định status = active nếu không truyền
            if (status == null || status.isEmpty()) {
                status = "active";
            }

            if (dao.isEmailExists(email.trim())) {
                out.write("{\"success\":false,\"message\":\"Email đã tồn tại trong hệ thống\"}");
                return;
            }

            if ("add".equals(mode)) {
                boolean ok = dao.registerStaff(
                        fullname.trim(),
                        email.trim(),
                        phone.trim(),
                        password,
                        role.trim(),
                        status
                );
                if (ok) {
                    try {
                        EmailUtil.sendStaffAccount(
                                email.trim(),
                                fullname.trim(),
                                email.trim(), // username hiện tại
                                password
                        );
                    } catch (Exception e) {
                        e.printStackTrace();
                    }

                    out.write("{\"success\":true,\"message\":\"Tạo tài khoản thành công\"}");
                } else {
                    out.write("{\"success\":false,\"message\":\"Tạo tài khoản thất bại, vui lòng thử lại\"}");
                }
            } else {
                out.write("{\"success\":false,\"message\":\"Action không hợp lệ\"}");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(500);
            response.getWriter().write("{\"success\":false,\"message\":\"Lỗi server: " + e.getMessage() + "\"}");
        }
    }

    private String validatePhone(String phone) {
        if (phone == null || phone.trim().isEmpty()) {
            return "Vui lòng nhập số điện thoại";
        }

        String trimmedPhone = phone.trim();

        // Chỉ cho phép số, +, -, khoảng trắng, ()
        if (!trimmedPhone.matches("^[0-9+\\-\\s\\(\\)]*$")) {
            return "Số điện thoại chứa ký tự không hợp lệ";
        }

        // Loại bỏ khoảng trắng, dấu -, ()
        String normalized = trimmedPhone.replaceAll("[\\s\\-\\(\\)]", "");

        // Kiểm tra định dạng Việt Nam
        if (!normalized.matches("^(0|\\+84)[0-9]{9,10}$")) {
            return "Số điện thoại không hợp lệ. Phải bắt đầu bằng 0 hoặc +84";
        }

        String digitsOnly = normalized.replaceAll("[^0-9]", "");

        if (digitsOnly.length() < 10 || digitsOnly.length() > 11) {
            return "Số điện thoại phải có 10-11 chữ số";
        }

        return null;
    }

    @Override
    public String getServletInfo() {
        return "Create Staff Controller";
    }
}
