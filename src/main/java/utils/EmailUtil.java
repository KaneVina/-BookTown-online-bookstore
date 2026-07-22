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

    // ================== HÀM TIỆN ÍCH CHUNG ==================

    private static Session buildSession() {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        return Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });
    }

    private static void sendMail(String toEmail, String subject, String htmlContent)
            throws MessagingException, UnsupportedEncodingException {
        Message message = new MimeMessage(buildSession());
        message.setFrom(new InternetAddress(FROM_EMAIL, "BookTown Support", "UTF-8"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject(subject);
        message.setContent(htmlContent, "text/html; charset=UTF-8");
        Transport.send(message);
    }

    // ================== OTP ==================

    public static void sendOtp(String toEmail, String otp) throws MessagingException, UnsupportedEncodingException {
        sendMail(toEmail, "BookTown - Mã xác thực đăng ký tài khoản", buildEmailHtml(otp));
    }

    private static String buildEmailHtml(String otp) {
        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <img src=\"https://res.cloudinary.com/dylkbydhg/image/upload/v1780127819/logoBT_1_fyixrl.png\" alt=\"BookTown Logo\" style=\"max-width: 180px; height: auto; display: block; margin: 0 auto;\" />"
                + "    </div>"
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #333333; font-size: 20px; margin-top: 0;\">Xác thực địa chỉ email</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Xin chào người dùng,<br><br>"
                + "        Cảm ơn đã sử dụng dịch vụ của BookTown. Bạn vừa yêu cầu đăng ký tài khoản tại hệ thống của chúng tôi. Để hoàn tất quá trình, vui lòng sử dụng mã xác thực (OTP) dưới đây:"
                + "      </p>"
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
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">"
                + "        &copy; 2026 BookTown. Tất cả quyền được bảo lưu."
                + "      </p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    // ================== HOÀN TIỀN ==================

    /**
     * Gửi mail thông báo đơn hàng đã bị hủy và tiền SẼ được hoàn (chưa hoàn thực sự).
     * Gọi khi: hủy đơn VNPAY đã thanh toán → payment_status = 'pending_refund'
     */
    public static void sendRefundPendingEmail(String toEmail, model.Order order) throws MessagingException, UnsupportedEncodingException {
        sendMail(toEmail, "BookTown - Thông báo hủy đơn & hoàn tiền đang xử lý " + order.getOrderCode(),
                buildRefundPendingEmailHtml(order));
    }

    /**
     * Gửi mail xác nhận đã hoàn tiền thành công (staff đã chuyển tiền tay và xác nhận).
     * Gọi khi: staff bấm 'Xác nhận đã hoàn tiền' → payment_status = 'refunded'
     */
    public static void sendRefundConfirmedEmail(String toEmail, model.Order order) throws MessagingException, UnsupportedEncodingException {
        sendMail(toEmail, "BookTown - Xác nhận đã hoàn tiền đơn hàng " + order.getOrderCode(),
                buildRefundConfirmedEmailHtml(order));
    }

    /** Nội dung mail bước 1: đơn đã hủy, tiền SẼ được hoàn (chưa hoàn thực sự). */
    private static String buildRefundPendingEmailHtml(model.Order order) {
        java.text.NumberFormat nf = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
        String formattedPrice = nf.format(order.getTotalPrice()) + "đ";

        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <img src=\"https://res.cloudinary.com/dylkbydhg/image/upload/v1780127819/logoBT_1_fyixrl.png\" alt=\"BookTown Logo\" style=\"max-width: 180px; height: auto; display: block; margin: 0 auto;\" />"
                + "    </div>"
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #e65c00; font-size: 20px; margin-top: 0;\">Thông báo hủy đơn &amp; hoàn tiền đang xử lý</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Xin chào quý khách,<br><br>"
                + "        Đơn hàng <strong>" + order.getOrderCode() + "</strong> của quý khách đã được hủy thành công. "
                + "        Chúng tôi sẽ tiến hành hoàn lại số tiền thanh toán cho quý khách."
                + "      </p>"
                + "      <div style=\"background-color: #fff8f0; padding: 15px; border-radius: 6px; margin: 20px 0; border: 1px solid #ffe0b2;\">"
                + "        <table style=\"width: 100%; border-collapse: collapse; font-size: 14px;\">"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Mã đơn hàng:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">" + order.getOrderCode() + "</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Số tiền cần hoàn:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; color: #e65c00; text-align: right;\">" + formattedPrice + "</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Trạng thái hoàn tiền:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; color: #e65c00; text-align: right;\">Đang xử lý</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Thời gian dự kiến:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">2 - 5 ngày làm việc</td>"
                + "          </tr>"
                + "        </table>"
                + "      </div>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        <strong>Lưu ý:</strong> Số tiền sẽ được hoàn vào tài khoản ngân hàng hoặc ví liên kết dùng để thanh toán qua VNPAY. "
                + "        Quý khách sẽ nhận được email xác nhận khi quá trình hoàn tiền hoàn tất."
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">Nếu cần hỗ trợ, vui lòng liên hệ bộ phận hỗ trợ khách hàng của BookTown.</p>"
                + "      </div>"
                + "    </div>"
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">&copy; 2026 BookTown. Tất cả quyền được bảo lưu.</p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    /** Nội dung mail bước 2: xác nhận tiền ĐÃ được hoàn thành công. */
    private static String buildRefundConfirmedEmailHtml(model.Order order) {
        java.text.NumberFormat nf = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
        String formattedPrice = nf.format(order.getTotalPrice()) + "đ";

        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <img src=\"https://res.cloudinary.com/dylkbydhg/image/upload/v1780127819/logoBT_1_fyixrl.png\" alt=\"BookTown Logo\" style=\"max-width: 180px; height: auto; display: block; margin: 0 auto;\" />"
                + "    </div>"
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #2E7D32; font-size: 20px; margin-top: 0;\">Xác nhận hoàn tiền thành công</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Xin chào quý khách,<br><br>"
                + "        Chúng tôi xin thông báo số tiền của đơn hàng <strong>" + order.getOrderCode() + "</strong> đã được hoàn trả thành công vào tài khoản của quý khách."
                + "      </p>"
                + "      <div style=\"background-color: #f0fff4; padding: 15px; border-radius: 6px; margin: 20px 0; border: 1px solid #c8e6c9;\">"
                + "        <table style=\"width: 100%; border-collapse: collapse; font-size: 14px;\">"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Mã đơn hàng:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">" + order.getOrderCode() + "</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Phương thức hoàn tiền:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; text-align: right;\">Chuyển khoản tay (BookTown)</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Số tiền đã hoàn:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; color: #2E7D32; text-align: right;\">" + formattedPrice + "</td>"
                + "          </tr>"
                + "          <tr>"
                + "            <td style=\"padding: 5px 0; color: #777777;\">Trạng thái:</td>"
                + "            <td style=\"padding: 5px 0; font-weight: bold; color: #2E7D32; text-align: right;\">Hoàn tất ✓</td>"
                + "          </tr>"
                + "        </table>"
                + "      </div>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Số tiền đã được chuyển vào tài khoản ngân hàng hoặc ví liên kết của quý khách. "
                + "        Nếu chưa nhận được tiền sau 1-2 ngày làm việc, vui lòng liên hệ BookTown để được hỗ trợ."
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">Cảm ơn quý khách đã tin tưởng sử dụng dịch vụ của BookTown.</p>"
                + "      </div>"
                + "    </div>"
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">&copy; 2026 BookTown. Tất cả quyền được bảo lưu.</p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    // ================== TÀI KHOẢN NHÂN VIÊN ==================

    public static void sendStaffAccount(
            String toEmail,
            String fullName,
            String username,
            String password
    ) throws MessagingException, UnsupportedEncodingException {
        sendMail(toEmail, "BookTown - Tài khoản nhân viên", buildStaffAccountHtml(fullName, username, password));
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

    // ================== KHÓA / MỞ KHÓA TÀI KHOẢN ==================

    public static void sendAccountLockedEmail(String toEmail, String fullName) throws MessagingException, UnsupportedEncodingException {
        sendMail(toEmail, "BookTown - Tài khoản của bạn đã bị khóa", buildAccountStatusEmailHtml(fullName, true));
    }

    /**
     * Gửi mail thông báo tài khoản đã được MỞ KHÓA (kích hoạt lại) bởi admin/staff.
     */
    public static void sendAccountUnlockedEmail(String toEmail, String fullName) throws MessagingException, UnsupportedEncodingException {
        sendMail(toEmail, "BookTown - Tài khoản của bạn đã được mở khóa", buildAccountStatusEmailHtml(fullName, false));
    }

    private static String buildAccountStatusEmailHtml(String fullName, boolean locked) {
        String safeName = (fullName == null || fullName.trim().isEmpty()) ? "Quý khách" : fullName;
        String titleColor = locked ? "#c62828" : "#2E7D32";
        String title = locked ? "Tài khoản đã bị khóa" : "Tài khoản đã được mở khóa";
        String bodyText = locked
                ? "Tài khoản của bạn tại BookTown vừa bị <strong>khóa</strong> bởi quản trị viên. "
                  + "Trong thời gian này bạn sẽ không thể đăng nhập hoặc sử dụng các chức năng của hệ thống."
                : "Tài khoản của bạn tại BookTown vừa được <strong>mở khóa</strong>. "
                  + "Bạn có thể đăng nhập và tiếp tục sử dụng dịch vụ như bình thường.";
        String noteText = locked
                ? "Nếu bạn cho rằng đây là nhầm lẫn, vui lòng liên hệ bộ phận hỗ trợ của BookTown để được giải quyết."
                : "Nếu bạn không thực hiện hành động nào liên quan, vui lòng liên hệ bộ phận hỗ trợ của BookTown để được hỗ trợ kịp thời.";

        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <img src=\"https://res.cloudinary.com/dylkbydhg/image/upload/v1780127819/logoBT_1_fyixrl.png\" alt=\"BookTown Logo\" style=\"max-width: 180px; height: auto; display: block; margin: 0 auto;\" />"
                + "    </div>"
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: " + titleColor + "; font-size: 20px; margin-top: 0;\">" + title + "</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">"
                + "        Xin chào " + safeName + ",<br><br>"
                + "        " + bodyText
                + "      </p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">" + noteText + "</p>"
                + "      </div>"
                + "    </div>"
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">&copy; 2026 BookTown. Tất cả quyền được bảo lưu.</p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }

    // ================== HỦY ĐƠN HÀNG ==================

    public static void sendOrderCancelledEmail(String toEmail, model.Order order, String cancelReason)
            throws MessagingException, UnsupportedEncodingException {
        sendMail(toEmail, "BookTown - Đơn hàng " + order.getOrderCode() + " đã bị hủy",
                buildOrderCancelledHtml(order, cancelReason));
    }

    private static String buildOrderCancelledHtml(model.Order order, String cancelReason) {
        java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm");
        String createdAtStr = order.getCreatedAt() != null ? sdf.format(order.getCreatedAt()) : "";
        String priceStr = String.format("%,.0f", order.getTotalPrice()) + " ₫";
        String reason = (cancelReason != null && !cancelReason.trim().isEmpty()) ? cancelReason : "Không có lý do";

        return "<div style=\"font-family: Arial, sans-serif; background-color: #f4f7f6; margin: 0; padding: 30px 0;\">"
                + "  <div style=\"max-width: 600px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; border: 1px solid #e0e0e0;\">"
                + "    <div style=\"background-color: #134aa4; padding: 20px; text-align: center;\">"
                + "      <img src=\"https://res.cloudinary.com/dylkbydhg/image/upload/v1780127819/logoBT_1_fyixrl.png\" alt=\"BookTown Logo\" style=\"max-width: 180px; height: auto; display: block; margin: 0 auto;\" />"
                + "    </div>"
                + "    <div style=\"padding: 30px 40px;\">"
                + "      <h2 style=\"color: #D32F2F; font-size: 20px; margin-top: 0;\">Đơn hàng đã bị hủy</h2>"
                + "      <p style=\"color: #555555; font-size: 15px; line-height: 1.6;\">Xin chào <strong>" + (order.getCustomerName() != null ? order.getCustomerName() : "") + "</strong>,<br><br>"
                + "      Đơn hàng của bạn đã bị hủy. Dưới đây là thông tin chi tiết:</p>"
                + "      <table style=\"width: 100%; border-collapse: collapse; margin: 20px 0;\">"
                + "        <tr style=\"background-color: #f9f9f9;\">"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #555; border-bottom: 1px solid #eee;\"><b>Mã đơn hàng</b></td>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #071e27; border-bottom: 1px solid #eee;\">" + order.getOrderCode() + "</td>"
                + "        </tr>"
                + "        <tr>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #555; border-bottom: 1px solid #eee;\"><b>Ngày đặt</b></td>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #071e27; border-bottom: 1px solid #eee;\">" + createdAtStr + "</td>"
                + "        </tr>"
                + "        <tr style=\"background-color: #f9f9f9;\">"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #555; border-bottom: 1px solid #eee;\"><b>Tổng tiền</b></td>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #071e27; border-bottom: 1px solid #eee;\">" + priceStr + "</td>"
                + "        </tr>"
                + "        <tr>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #555;\"><b>Lý do hủy</b></td>"
                + "          <td style=\"padding: 10px 16px; font-size: 14px; color: #D32F2F;\"><b>" + reason + "</b></td>"
                + "        </tr>"
                + "      </table>"
                + "      <p style=\"color: #555555; font-size: 14px; line-height: 1.6;\">Nếu bạn có bất kỳ thắc mắc nào, vui lòng liên hệ BookTown để được hỗ trợ.</p>"
                + "      <div style=\"border-top: 1px solid #eeeeee; margin-top: 30px; padding-top: 20px;\">"
                + "        <p style=\"color: #888888; font-size: 13px; line-height: 1.5; margin: 0;\">Cảm ơn bạn đã sử dụng dịch vụ của BookTown!</p>"
                + "      </div>"
                + "    </div>"
                + "    <div style=\"background-color: #f9f9f9; padding: 20px; text-align: center; border-top: 1px solid #eeeeee;\">"
                + "      <p style=\"color: #999999; font-size: 13px; margin: 0;\">&copy; 2026 BookTown. Tất cả quyền được bảo lưu.</p>"
                + "    </div>"
                + "  </div>"
                + "</div>";
    }
}