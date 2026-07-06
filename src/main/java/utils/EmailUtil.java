package utils;

import jakarta.mail.*;
import jakarta.mail.internet.*;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author PHUC KHANG
 */
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
                // Header
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <img src=\"https://res.cloudinary.com/dylkbydhg/image/upload/v1780127819/logoBT_1_fyixrl.png\" alt=\"BookTown Logo\" style=\"max-width: 180px; height: auto; display: block; margin: 0 auto;\" />"
                + "    </div>"
                // Nội dung
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
                // Footer
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">"
                + "        &copy; 2026 BookTown. Tất cả quyền được bảo lưu."
                + "      </p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    public static void sendRefundEmail(String toEmail, model.Order order) throws MessagingException, UnsupportedEncodingException {
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
        message.setSubject("BookTown - Thông báo hoàn tiền đơn hàng " + order.getOrderCode());
        message.setContent(buildRefundEmailHtml(order), "text/html; charset=UTF-8");

        Transport.send(message);
    }

    private static String buildRefundEmailHtml(model.Order order) {
        java.text.NumberFormat nf = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
        String formattedPrice = nf.format(order.getTotalPrice()) + "đ";

        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                // Header
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <img src=\"https://res.cloudinary.com/dylkbydhg/image/upload/v1780127819/logoBT_1_fyixrl.png\" alt=\"BookTown Logo\" style=\"max-width: 180px; height: auto; display: block; margin: 0 auto;\" />"
                + "    </div>"
                // Nội dung
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #2E7D32; font-size: 20px; margin-top: 0;\">Thông báo hoàn tiền thành công</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Xin chào quý khách,<br><br>"
                + "        Chúng tôi xin thông báo đơn hàng <strong>" + order.getOrderCode() + "</strong> của quý khách đã được hoàn tiền thành công."
                + "      </p>"
                // Chi tiết
                + "      <div style=\"background-color: #f9f9f9; padding: 15px; border-radius: 6px; margin: 20px 0; border: 1px solid #eeeeee;\">"
                + "        <table style=\"width: 100%; border-collapse: collapse; font-size: 14px;\">"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Mã đơn hàng:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">" + order.getOrderCode() + "</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Phương thức hoàn tiền:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">VNPAY (Chuyển khoản)</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Tổng số tiền hoàn:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; color: #134aa4; text-align: right;\">" + formattedPrice + "</td>"
                + "          </tr>"
                + "        </table>"
                + "      </div>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        <strong>Lưu ý:</strong> Số tiền hoàn trả sẽ được chuyển vào tài khoản ngân hàng hoặc ví liên kết của quý khách dùng để thanh toán trước đó thông qua cổng VNPAY trong vòng 2-5 ngày làm việc tùy thuộc vào ngân hàng của quý khách."
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">"
                + "          Nếu cần hỗ trợ thêm bất kỳ thông tin nào, vui lòng liên hệ bộ phận hỗ trợ khách hàng của BookTown."
                + "        </p>"
                + "      </div>"
                + "    </div>"
                // Footer
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">"
                + "        &copy; 2026 BookTown. Tất cả quyền được bảo lưu."
                + "      </p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    public static void sendStaffAccount(
            String toEmail,
            String fullName,
            String username,
            String password
    ) throws MessagingException, UnsupportedEncodingException {

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

        message.setFrom(new InternetAddress(
                FROM_EMAIL,
                "BookTown Support",
                "UTF-8"
        ));

        message.setRecipients(
                Message.RecipientType.TO,
                InternetAddress.parse(toEmail)
        );

        message.setSubject("BookTown - Tài khoản nhân viên");

        message.setContent(
                buildStaffAccountHtml(fullName, username, password),
                "text/html; charset=UTF-8"
        );

        Transport.send(message);
    }

    private static String buildStaffAccountHtml(
            String fullName,
            String username,
            String password
    ) {
        return "<div style='font-family: Arial, sans-serif;'>"
                + "<h2>Chào " + fullName + ",</h2>"
                + "<p>Tài khoản nhân viên BookTown của bạn đã được tạo thành công.</p>"
                + "<table style='border-collapse: collapse;'>"
                + "<tr>"
                + "<td style='padding:8px'><b>Tên đăng nhập:</b></td>"
                + "<td style='padding:8px'>" + username + "</td>"
                + "</tr>"
                + "<tr>"
                + "<td style='padding:8px'><b>Mật khẩu:</b></td>"
                + "<td style='padding:8px'>" + password + "</td>"
                + "</tr>"
                + "</table>"
                + "<p>Vui lòng đổi mật khẩu sau lần đăng nhập đầu tiên.</p>"
                + "<br>"
                + "<p>BookTown Team</p>"
                + "</div>";
    }
}
