package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

public class EmailUtil {

    private static final String FROM_EMAIL = "khangnpce181578@fpt.edu.vn";
    private static final String APP_PASSWORD = "cdln botz auro shjm";

    public static void sendOtp(String toEmail, String otp) throws MessagingException, UnsupportedEncodingException {
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
        message.setFrom(new InternetAddress(FROM_EMAIL, "BookTown Support", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("BookTown - Mã xác thực đăng ký tài khoản");
        message.setContent(buildEmailHtml(otp), "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private static String buildEmailHtml(String otp) {
        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                // Phần Header
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <img src=\"https://res.cloudinary.com/dylkbydhg/image/upload/v1780127819/logoBT_1_fyixrl.png\" alt=\"BookTown Logo\" style=\"max-width: 180px; height: auto; display: block; margin: 0 auto;\" />"
                + "    </div>"
                // Phần Nội dung chính
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #333333; font-size: 20px; margin-top: 0;\">Xác thực địa chỉ email</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Xin chào người dùng,<br><br>"
                + "        Cảm ơn đã sử dụng dịch vụ của BookTown. Bạn vừa yêu cầu đăng ký tài khoản tại hệ thống của chúng tôi. Để hoàn tất quá trình, vui lòng sử dụng mã xác thực (OTP) dưới đây:"
                + "      </p>"
                // Mã OTP
                + "      <div style=\"text-align: center; margin: 35px 0;\">"
                + "        <span style=\"display: inline-block; font-size: 34px; font-weight: bold; color: #134aa4; background-color: #f0f5fa; padding: 15px 40px; border-radius: 6px; letter-spacing: 6px; border: 1px dashed #134aa4;\">"
                + otp
                + "        </span>"
                + "      </div>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        <strong>Lưu ý:</strong> Mã xác thực này có hiệu lực trong vòng 5 phút. Tuyệt đối không chia sẻ mã này với bất kỳ ai để bảo vệ tài khoản của bạn."
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">"
                + "          Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email. Hệ thống sẽ tự động hủy yêu cầu và tài khoản của bạn vẫn an toàn."
                + "        </p>"
                + "      </div>"
                + "    </div>"
                // Phần Footer
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">"
                + "        &copy; 2026 BookTown. Tất cả quyền được bảo lưu."
                + "      </p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }
}
