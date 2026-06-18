package controller;

import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import utils.VNPayConfig;

import java.io.IOException;
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

        // 4. So sánh chữ ký - dùng equalsIgnoreCase vì VNPAY có thể trả về chữ hoa/thường
        boolean isValidSignature = calculatedHash.equalsIgnoreCase(vnp_SecureHash);

        // Debug - xem log trong NetBeans console
        System.out.println("=== VNPAY RETURN ===");
        System.out.println("calculatedHash : " + calculatedHash);
        System.out.println("vnp_SecureHash : " + vnp_SecureHash);
        System.out.println("isValidSignature: " + isValidSignature);
        System.out.println("vnp_ResponseCode: " + request.getParameter("vnp_ResponseCode"));

        // 5. Lấy mã kết quả và orderID
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");

        int orderID = 0;
        try {
            orderID = Integer.parseInt(request.getParameter("vnp_TxnRef"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        HttpSession session = request.getSession(false);

        if (isValidSignature && "00".equals(vnp_ResponseCode)) {
            // ===== THANH TOÁN THÀNH CÔNG =====

            orderDAO.updatePaymentStatus(orderID, "paid");
            orderDAO.updateOrderStatus(orderID, "confirmed");

            // Xóa cart - lấy customerID từ DB, không cần session
            orderDAO.clearCartByOrderID(orderID);

            // Cập nhật cartCount trong session nếu còn
            if (session != null) {
                session.setAttribute("cartCount", 0);
            }

            // Chuyển sang trang xác nhận - giống luồng COD
            response.sendRedirect(request.getContextPath()
                    + "/order-confirmation?orderID=" + orderID);

        } else {
            // ===== THANH TOÁN THẤT BẠI =====

            // Hủy đơn - chỉ cần orderID, không cần session
            orderDAO.cancelOrderBySystem(orderID);

            if (session != null) {
                session.setAttribute("errorMessage",
                        "Thanh toán VNPAY thất bại! Mã lỗi: " + vnp_ResponseCode);
            }

            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}