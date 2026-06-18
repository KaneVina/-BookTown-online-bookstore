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
import utils.VNPayConfig;

import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

public class VNPayController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/checkout");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Account account = (Account) session.getAttribute("account");

        String fullname      = request.getParameter("fullname");
        String phone         = request.getParameter("phone");
        String street        = request.getParameter("street");
        String district      = request.getParameter("district");
        String city          = request.getParameter("city");

        if (isEmpty(fullname) || isEmpty(phone) || isEmpty(street)
                || isEmpty(district) || isEmpty(city)) {
            session.setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin giao hàng!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());
        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }
        BigDecimal total = cartDAO.calcSubtotal(cartItems);

        OrderDAO orderDAO = new OrderDAO();
        int addressID = orderDAO.createTempAddress(account.getId(),
                street.trim(), district.trim(), city.trim());
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

        session.setAttribute("pendingOrderID", orderID);

        String vnpayUrl = buildVNPayUrl(request, orderID, total);

        response.sendRedirect(vnpayUrl);
    }

    private String buildVNPayUrl(HttpServletRequest request, int orderID, BigDecimal total)
            throws IOException {

        long amount = total.longValue() * 100;

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        String vnp_CreateDate = formatter.format(cld.getTime());
        cld.add(Calendar.MINUTE, 15);
        String vnp_ExpireDate = formatter.format(cld.getTime());

        Map<String, String> vnp_Params = new HashMap<>();
        vnp_Params.put("vnp_Version",    VNPayConfig.vnp_Version);
        vnp_Params.put("vnp_Command",    VNPayConfig.vnp_Command);
        vnp_Params.put("vnp_TmnCode",    VNPayConfig.vnp_TmnCode);
        vnp_Params.put("vnp_Amount",     String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode",   VNPayConfig.vnp_CurrCode);
        vnp_Params.put("vnp_TxnRef",     String.valueOf(orderID));          
        vnp_Params.put("vnp_OrderInfo",  "Thanh toan don hang #BT-" + orderID);
        vnp_Params.put("vnp_OrderType",  VNPayConfig.vnp_OrderType);
        vnp_Params.put("vnp_Locale",     VNPayConfig.vnp_Locale);
        vnp_Params.put("vnp_ReturnUrl",  VNPayConfig.vnp_ReturnUrl);
        vnp_Params.put("vnp_IpAddr",     VNPayConfig.getIpAddress(request));
        vnp_Params.put("vnp_CreateDate", vnp_CreateDate);
        vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

        List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
        Collections.sort(fieldNames);

        StringBuilder hashData = new StringBuilder();
        StringBuilder query    = new StringBuilder();

        Iterator<String> itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName  = itr.next();
            String fieldValue = vnp_Params.get(fieldName);
            if (fieldValue != null && fieldValue.length() > 0) {
                hashData.append(fieldName).append("=")
                        .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()))
                     .append("=")
                     .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                if (itr.hasNext()) {
                    query.append("&");
                    hashData.append("&");
                }
            }
        }

        String secureHash = VNPayConfig.hmacSHA512(VNPayConfig.vnp_HashSecret, hashData.toString());
        query.append("&vnp_SecureHash=").append(secureHash);

        return VNPayConfig.vnp_PayUrl + "?" + query.toString();
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}