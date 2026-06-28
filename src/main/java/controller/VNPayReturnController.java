package controller;

import dao.CartDAO;
import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;
import model.Order;
import utils.VNPayConfig;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.*;

public class VNPayReturnController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Lấy tất cả tham số VNPAY gửi về, bỏ qua vnp_SecureHash
        Map<String, String> vnp_Params = new HashMap<>();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String key = entry.getKey();
            if (!key.equals("vnp_SecureHash") && !key.equals("vnp_SecureHashType")) {
                vnp_Params.put(key, entry.getValue()[0]);
            }
        }

        // 2. Lấy chữ ký VNPAY gửi về
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");

        // 3. Tự tính lại chữ ký
        String calculatedHash = VNPayConfig.hashAllFields(vnp_Params);

        // 4. So sánh chữ ký
        boolean isValidSignature = calculatedHash.equalsIgnoreCase(vnp_SecureHash);

        // Debug
        System.out.println("=== VNPAY RETURN ===");
        System.out.println("calculatedHash : " + calculatedHash);
        System.out.println("vnp_SecureHash : " + vnp_SecureHash);
        System.out.println("isValidSignature: " + isValidSignature);
        System.out.println("vnp_ResponseCode: " + request.getParameter("vnp_ResponseCode"));

        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");

        HttpSession session = request.getSession(false);

        if (isValidSignature && "00".equals(vnp_ResponseCode)) {
            // ===== THANH TOÁN THÀNH CÔNG =====

            // Lấy thông tin giao hàng đã lưu trong session
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            Account account = (Account) session.getAttribute("account");
            if (account == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String street   = (String)     session.getAttribute("vnpay_street");
            String district = (String)     session.getAttribute("vnpay_district");
            String city     = (String)     session.getAttribute("vnpay_city");
            BigDecimal total = (BigDecimal) session.getAttribute("vnpay_total");

            if (street == null || district == null || city == null || total == null) {
                // Session hết hạn hoặc dữ liệu bị mất
                session.setAttribute("errorMessage", "Phiên thanh toán hết hạn, vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            // ✅ CHỈ tạo đơn hàng thật tại đây — khi chắc chắn thanh toán thành công
            CartDAO cartDAO = new CartDAO();
            List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

            int addressID = orderDAO.createTempAddress(account.getId(), street, district, city);
            if (addressID == -1) {
                session.setAttribute("errorMessage", "Lỗi khi lưu địa chỉ!");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            int orderID = orderDAO.createOrder(account.getId(), addressID, "vnpay", total);
            if (orderID == -1) {
                session.setAttribute("errorMessage", "Lỗi khi tạo đơn hàng!");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            orderDAO.createOrderDetails(orderID, cartItems);

            // Cập nhật trạng thái đơn hàng: đã thanh toán + đã xác nhận
            orderDAO.updatePaymentStatus(orderID, "paid");
            orderDAO.updateOrderStatus(orderID, "confirmed");

            // Xóa giỏ hàng
            orderDAO.clearCart(account.getId());

            // Xóa dữ liệu VNPAY pending khỏi session
            session.removeAttribute("vnpay_txnRef");
            session.removeAttribute("vnpay_fullname");
            session.removeAttribute("vnpay_phone");
            session.removeAttribute("vnpay_street");
            session.removeAttribute("vnpay_district");
            session.removeAttribute("vnpay_city");
            session.removeAttribute("vnpay_total");

            // Hiển thị thông báo thành công
            Order order = orderDAO.getOrderByID(orderID);
            String orderCode = (order != null) ? order.getOrderCode() : "BT-" + orderID;
            session.setAttribute("cartCount", 0);
            session.setAttribute("successMessage",
                    "Thanh toán VNPAY thành công! Mã đơn hàng: " + orderCode);

            response.sendRedirect(request.getContextPath()
                    + "/order-confirmation?orderID=" + orderID);

        } else {
            // ===== THANH TOÁN THẤT BẠI HOẶC NGƯỜI DÙNG HỦY =====
            // ✅ Không có đơn hàng nào được tạo → không cần cancelOrderBySystem()

            // Xóa dữ liệu pending khỏi session cho sạch
            if (session != null) {
                session.removeAttribute("vnpay_txnRef");
                session.removeAttribute("vnpay_fullname");
                session.removeAttribute("vnpay_phone");
                session.removeAttribute("vnpay_street");
                session.removeAttribute("vnpay_district");
                session.removeAttribute("vnpay_city");
                session.removeAttribute("vnpay_total");

                String msg = "24".equals(vnp_ResponseCode)
                        ? "Bạn đã hủy giao dịch VNPAY!"
                        : "Thanh toán VNPAY thất bại! Vui lòng thử lại.";
                session.setAttribute("errorMessage", msg);
            }

            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}