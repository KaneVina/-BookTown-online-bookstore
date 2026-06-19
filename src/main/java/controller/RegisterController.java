package controller;

import dao.CustomerDAO;
import utils.EmailUtil;
import java.io.IOException;
import java.util.Random;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class RegisterController extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // trim
        String fullname        = trim(request.getParameter("fullname"));
        String email           = trim(request.getParameter("email"));
        String phone           = trim(request.getParameter("phone"));
        String password        = trim(request.getParameter("password"));
        String confirmPassword = trim(request.getParameter("confirmPassword"));

        // Validate dữ liệu
        String error = validate(fullname, email, phone, password, confirmPassword);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra email đã tồn tại
        if (customerDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Email này đã được sử dụng. Vui lòng dùng email khác.");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Sinh mã OTP 6 số
        String otp = String.format("%06d", new Random().nextInt(999999));

        // Lưu thông tin vào session để OtpController xử lý tiếp
        HttpSession session = request.getSession();
        session.setAttribute("otp_fullname", fullname);
        session.setAttribute("otp_email",    email);
        session.setAttribute("otp_phone",    phone);
        session.setAttribute("otp_password", password);
        session.setAttribute("otp_code",     otp);
        session.setAttribute("otp_created",  System.currentTimeMillis());

        // Gửi OTP qua email
        try {
            EmailUtil.sendOtp(email, otp);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể gửi email OTP. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Chuyển sang trang nhập OTP
        response.sendRedirect(request.getContextPath() + "/otp");
    }

    private String validate(String fullname, String email, String phone,
                             String password, String confirmPassword) {
        // Kiểm tra không được bỏ trống
        if (fullname == null || fullname.isEmpty())
            return "Họ và tên không được để trống.";
        if (email == null || email.isEmpty())
            return "Email không được để trống.";
        if (phone == null || phone.isEmpty())
            return "Số điện thoại không được để trống.";
        if (password == null || password.isEmpty())
            return "Mật khẩu không được để trống.";
        if (confirmPassword == null || confirmPassword.isEmpty())
            return "Xác nhận mật khẩu không được để trống.";

        // Kiểm tra định dạng email
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"))
            return "Định dạng email không hợp lệ.";

        // Kiểm tra định dạng số điện thoại Việt Nam
        if (!phone.matches("^(0[35789])\\d{8}$"))
            return "Số điện thoại không đúng định dạng.";

        // Kiểm tra độ dài mật khẩu 8 - 15 ký tự
        if (password.length() < 8 || password.length() > 15)
            return "Mật khẩu phải từ 8 đến 15 ký tự.";

        // Kiểm tra mật khẩu phải có đủ chữ hoa, chữ thường, số, ký tự đặc biệt
        if (!password.matches(".*[A-Z].*"))
            return "Mật khẩu phải có ít nhất 1 chữ hoa.";
        if (!password.matches(".*[a-z].*"))
            return "Mật khẩu phải có ít nhất 1 chữ thường.";
        if (!password.matches(".*[0-9].*"))
            return "Mật khẩu phải có ít nhất 1 chữ số.";
        if (!password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?].*"))
            return "Mật khẩu phải có ít nhất 1 ký tự đặc biệt.";

        // Kiểm tra xác nhận mật khẩu
        if (!password.equals(confirmPassword))
            return "Mật khẩu xác nhận không khớp.";

        return null;
    }

    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}