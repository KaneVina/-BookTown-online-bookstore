package controller;

import dao.CustomerDAO;
import utils.EmailUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;

public class OtpController extends HttpServlet {

    private static final long OTP_EXPIRE_MS      = 5 * 60 * 1000L; // 5 phút
    private static final long RESEND_COOLDOWN_MS = 60 * 1000L;     // chống spam: 60 giây
    private static final int  MAX_WRONG_ATTEMPTS  = 5;              // giới hạn số lần nhập sai

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("otp_code") == null) {
            // Phân biệt luồng để redirect đúng chỗ
            String flow = (session != null) ? (String) session.getAttribute("otp_flow") : null;
            if ("forgot".equals(flow)) {
                response.sendRedirect(request.getContextPath() + "/forgot-password");
            } else {
                response.sendRedirect(request.getContextPath() + "/register");
            }
            return;
        }
        request.getRequestDispatcher("/views/auth/otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("resend".equals(action)) {
            handleResend(request, response);
        } else {
            handleVerify(request, response);
        }
    }

    // Xác thực OTP người dùng nhập 
    private void handleVerify(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("otp_code") == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        String inputOtp  = request.getParameter("otp");
        String savedOtp  = (String) session.getAttribute("otp_code");
        Long   createdAt = (Long)   session.getAttribute("otp_created");
        String flow      = (String) session.getAttribute("otp_flow"); // "register" hoặc "forgot"

        // Kiểm tra hết hạn
        if (System.currentTimeMillis() - createdAt > OTP_EXPIRE_MS) {
            invalidateCurrentOtp(session);
            session.setAttribute("otp_error", "Mã OTP đã hết hạn. Vui lòng bấm \"Gửi lại mã\" để nhận mã mới.");
            request.getRequestDispatcher("/views/auth/otp.jsp").forward(request, response);
            return;
        }

        // Kiểm tra OTP đúng không
        if (!savedOtp.equals(inputOtp)) {
            Integer attempts = (Integer) session.getAttribute("otp_attempts");
            attempts = (attempts == null) ? 1 : attempts + 1;
            session.setAttribute("otp_attempts", attempts);

            if (attempts >= MAX_WRONG_ATTEMPTS) {
                // Nhập sai quá số lần cho phép thì hủy mã hiện tại, bắt buộc gửi lại mã mới
                invalidateCurrentOtp(session);
                session.setAttribute("otp_error",
                        "Bạn đã nhập sai mã OTP quá " + MAX_WRONG_ATTEMPTS + " lần. "
                        + "Vui lòng bấm \"Gửi lại mã\" để nhận mã mới.");
            } else {
                int remaining = MAX_WRONG_ATTEMPTS - attempts;
                session.setAttribute("otp_error",
                        "Mã OTP không chính xác. Bạn còn " + remaining + " lần thử.");
            }
            request.getRequestDispatcher("/views/auth/otp.jsp").forward(request, response);
            return;
        }

        //quên mk
        if ("forgot".equals(flow)) {
            session.setAttribute("fp_verified", true);
            clearOtpAttributes(session, false);
            response.sendRedirect(request.getContextPath() + "/reset-password");
            return;
        }

//        của đăng ký
        String fullname = (String) session.getAttribute("otp_fullname");
        String email    = (String) session.getAttribute("otp_email");
        String phone    = (String) session.getAttribute("otp_phone");
        String password = (String) session.getAttribute("otp_password");

        CustomerDAO dao  = new CustomerDAO();
        boolean success  = dao.registerCustomer(fullname, email, phone, password);

        clearOtpAttributes(session, true);

        if (success) {
            session.setAttribute("register_success", "Đăng ký thành công! Vui lòng đăng nhập.");
            response.sendRedirect(request.getContextPath() + "/login");
        } else {
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo tài khoản. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        }
    }

    // Gửi lại OTP vs chống spam 60s
    private void handleResend(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("otp_email") == null) {
            response.sendRedirect(request.getContextPath() + "/register");
            return;
        }

        Long resendAt = (Long) session.getAttribute("otp_resend_at");
        long now      = System.currentTimeMillis();

        if (resendAt != null && now - resendAt < RESEND_COOLDOWN_MS) {
            long waitSec = (RESEND_COOLDOWN_MS - (now - resendAt)) / 1000;
            session.setAttribute("otp_error", "Vui lòng chờ " + waitSec + " giây trước khi gửi lại.");
            request.getRequestDispatcher("/views/auth/otp.jsp").forward(request, response);
            return;
        }

        String newOtp = String.format("%06d", new Random().nextInt(999999));
        String email  = (String) session.getAttribute("otp_email");

        session.setAttribute("otp_code",      newOtp);
        session.setAttribute("otp_created",   now);
        session.setAttribute("otp_resend_at", now);
        session.removeAttribute("otp_error");
        session.removeAttribute("otp_attempts"); // reset số lần nhập sai khi có mã mới

        try {
            EmailUtil.sendOtp(email, newOtp);
            session.setAttribute("otp_success", "Mã OTP mới đã được gửi đến email của bạn.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("otp_error", "Không thể gửi email. Vui lòng thử lại.");
        }

        request.getRequestDispatcher("/views/auth/otp.jsp").forward(request, response);
    }

    private void clearOtpAttributes(HttpSession session, boolean keepEmail) {
        session.removeAttribute("otp_code");
        session.removeAttribute("otp_created");
        session.removeAttribute("otp_resend_at");
        session.removeAttribute("otp_error");
        session.removeAttribute("otp_success");
        session.removeAttribute("otp_flow");
        session.removeAttribute("otp_fullname");
        session.removeAttribute("otp_phone");
        session.removeAttribute("otp_password");
        session.removeAttribute("otp_attempts");
        if (keepEmail) {
            session.removeAttribute("otp_email");
        }
    }

    private void invalidateCurrentOtp(HttpSession session) {
        session.removeAttribute("otp_code");
        session.removeAttribute("otp_created");
        session.removeAttribute("otp_attempts");
    }
}