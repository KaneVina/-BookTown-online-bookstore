package controller;

import dao.AddressDAO;
import dao.CartDAO;
import dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Address;
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

        Map<String, String> vnp_Params = new HashMap<>();
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            String key = entry.getKey();
            if (!key.equals("vnp_SecureHash") && !key.equals("vnp_SecureHashType")) {
                vnp_Params.put(key, entry.getValue()[0]);
            }
        }

        String vnp_SecureHash = request.getParameter("vnp_SecureHash");
        String calculatedHash = VNPayConfig.hashAllFields(vnp_Params);
        boolean isValidSignature = calculatedHash.equalsIgnoreCase(vnp_SecureHash);
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        HttpSession session = request.getSession(false);

        if (isValidSignature && "00".equals(vnp_ResponseCode)) {
            if (session == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            Account account = (Account) session.getAttribute("account");
            if (account == null) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            String street = (String) session.getAttribute("vnpay_street");
            String district = (String) session.getAttribute("vnpay_district");
            String city = (String) session.getAttribute("vnpay_city");
            BigDecimal total = (BigDecimal) session.getAttribute("vnpay_total");

            if (street == null || district == null || city == null || total == null) {
                session.setAttribute("errorMessage", "Phiên thanh toán hết hạn, vui lòng thử lại!");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
            }

            CartDAO cartDAO = new CartDAO();
            List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

            AddressDAO addressDAO = new AddressDAO();
            List<Address> addresses = addressDAO.getAddressesByCustomerId(account.getId());
            int addressID = -1;
            for (Address addr : addresses) {
                if (street.equals(addr.getStreet())
                        && district.equals(addr.getDistrict())
                        && city.equals(addr.getCity())) {
                    addressID = addr.getAddressID();
                    break;
                }
            }

            if (addressID == -1) {
                session.setAttribute("errorMessage", "Không tìm thấy địa chỉ giao hàng!");
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
            orderDAO.updatePaymentStatus(orderID, "paid");
            orderDAO.clearCart(account.getId());

            session.removeAttribute("vnpay_txnRef");
            session.removeAttribute("vnpay_fullname");
            session.removeAttribute("vnpay_phone");
            session.removeAttribute("vnpay_street");
            session.removeAttribute("vnpay_district");
            session.removeAttribute("vnpay_city");
            session.removeAttribute("vnpay_total");

            Order order = orderDAO.getOrderByID(orderID);
            String orderCode = (order != null) ? order.getOrderCode() : "BT-" + orderID;
            session.setAttribute("cartCount", 0);
            session.setAttribute("successMessage",
                    "Thanh toán VNPAY thành công! Mã đơn hàng: " + orderCode);

            response.sendRedirect(request.getContextPath()
                    + "/order-confirmation?orderID=" + orderID);

        } else {
            if (session != null) {
                session.removeAttribute("vnpay_txnRef");
                session.removeAttribute("vnpay_fullname");
                session.removeAttribute("vnpay_phone");
                session.removeAttribute("vnpay_street");
                session.removeAttribute("vnpay_district");
                session.removeAttribute("vnpay_city");
                session.removeAttribute("vnpay_total");

                String msg;

                switch (vnp_ResponseCode) {
                    case "24":
                        msg = "Bạn đã hủy giao dịch VNPAY!";
                        break;

                    default:
                        msg = "Thanh toán VNPAY thất bại! Vui lòng thử lại.";
                        break;
                }
            }
            response.sendRedirect(request.getContextPath() + "/checkout");
        }
    }
}
