package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    private static final String FROM_EMAIL   = "khangnpce181578@fpt.edu.vn";
    private static final String APP_PASSWORD = "cdln botz auro shjm";

    public static void sendOtp(String toEmail, String otp) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });

        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress(FROM_EMAIL));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("BookTown - Mã xác thực OTP");
        message.setContent(buildEmailHtml(otp), "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private static String buildEmailHtml(String otp) {
        return "<div style='font-family:Inter,Arial,sans-serif;max-width:520px;margin:auto;background:#ffffff;border-radius:20px;overflow:hidden;box-shadow:0 4px 24px rgba(0,77,153,0.10);border:1px solid #e3eaf5;'>"
                + "<div style='background:linear-gradient(135deg,#004d99 0%,#1565c0 100%);padding:36px 32px 28px;text-align:center;'>"
                + "<div style='font-size:36px;margin-bottom:8px;'>📚</div>"
                + "<div style='color:#ffffff;font-size:26px;font-weight:800;letter-spacing:1px;'>BookTown</div>"
                + "<div style='color:#a9c7ff;font-size:13px;margin-top:4px;'>Hệ thống xác thực tài khoản</div>"
                + "</div>"
                + "<div style='padding:36px 32px;'>"
                + "<h2 style='color:#071e27;font-size:20px;font-weight:700;margin:0 0 8px;'>Xác thực Email của bạn</h2>"
                + "<p style='color:#424752;font-size:14px;margin:0 0 28px;line-height:1.6;'>Chúng tôi nhận được yêu cầu đăng ký tài khoản BookTown. Vui lòng dùng mã OTP bên dưới để hoàn tất xác thực.</p>"
                + "<div style='background:linear-gradient(135deg,#f3faff 0%,#e6f6ff 100%);border:2px dashed #004d99;border-radius:16px;padding:28px 16px;text-align:center;margin-bottom:28px;'>"
                + "<div style='color:#727783;font-size:12px;font-weight:600;letter-spacing:2px;text-transform:uppercase;margin-bottom:12px;'>Mã xác thực OTP</div>"
                + "<div style='font-size:44px;font-weight:900;letter-spacing:14px;color:#004d99;font-family:monospace;'>" + otp + "</div>"
                + "<div style='color:#727783;font-size:12px;margin-top:12px;'>⏱ Có hiệu lực trong <strong style='color:#D32F2F;'>5 phút</strong></div>"
                + "</div>"
                + "<div style='background:#fff8e1;border-left:4px solid #FFA000;border-radius:8px;padding:14px 16px;margin-bottom:24px;'>"
                + "<p style='color:#5d4037;font-size:13px;margin:0;line-height:1.6;'>⚠️ <strong>Lưu ý bảo mật:</strong> Không chia sẻ mã này với bất kỳ ai, kể cả nhân viên BookTown. Chúng tôi sẽ không bao giờ yêu cầu mã OTP của bạn.</p>"
                + "</div>"
                + "<p style='color:#727783;font-size:12px;line-height:1.6;margin:0;'>Nếu bạn không thực hiện yêu cầu này, hãy bỏ qua email này. Tài khoản của bạn vẫn an toàn.</p>"
                + "</div>"
                + "<div style='background:#f3faff;padding:20px 32px;text-align:center;border-top:1px solid #e3eaf5;'>"
                + "<p style='color:#727783;font-size:12px;margin:0;'>© 2026 BookTown · Tất cả quyền được bảo lưu</p>"
                + "<p style='margin:6px 0 0;'>"
                + "<a href='#' style='color:#004d99;font-size:12px;text-decoration:none;margin:0 8px;'>Điều khoản</a>"
                + "<span style='color:#c2c6d4;'>|</span>"
                + "<a href='#' style='color:#004d99;font-size:12px;text-decoration:none;margin:0 8px;'>Bảo mật</a>"
                + "<span style='color:#c2c6d4;'>|</span>"
                + "<a href='#' style='color:#004d99;font-size:12px;text-decoration:none;margin:0 8px;'>Liên hệ</a>"
                + "</p>"
                + "</div>"
                + "</div>";
    }
}