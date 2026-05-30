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

        String fullname        = trim(request.getParameter("fullname"));
        String email           = trim(request.getParameter("email"));
        String phone           = trim(request.getParameter("phone"));
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        // Validate phía server
        String error = validate(fullname, email, phone, password, confirmPassword);
        if (error != null) {
            request.setAttribute("errorMessage", error);
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Kiểm tra email đã tồn tại chưa
        if (customerDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Email này đã được sử dụng. Vui lòng dùng email khác.");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }

        // Sinh OTP
        String otp = String.format("%06d", new Random().nextInt(999999));

        // Lưu vào session — đúng key mà OtpController dùng
        HttpSession session = request.getSession();
        session.setAttribute("otp_fullname", fullname);
        session.setAttribute("otp_email",    email);
        session.setAttribute("otp_phone",    phone);
        session.setAttribute("otp_password", password); // OtpController → CustomerDAO sẽ hash
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
        if (fullname == null || fullname.isEmpty())
            return "Họ và tên không được để trống.";
        if (email == null || email.isEmpty())
            return "Email không được để trống.";
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$"))
            return "Định dạng email không hợp lệ.";
        if (phone == null || phone.isEmpty())
            return "Số điện thoại không được để trống.";
        if (!phone.matches("^(0[35789])\\d{8}$"))
            return "Số điện thoại không đúng định dạng.";
        if (password == null || password.isEmpty())
            return "Mật khẩu không được để trống.";
        if (password.length() < 6)
            return "Mật khẩu phải tối thiểu 6 ký tự.";
        if (!password.equals(confirmPassword))
            return "Mật khẩu xác nhận không khớp.";
        return null;
    }

    private String trim(String s) {
        return s != null ? s.trim() : null;
    }
}