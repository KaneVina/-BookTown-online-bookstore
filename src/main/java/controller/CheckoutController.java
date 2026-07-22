package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.AddressDAO;
import dao.BookDAO;
import dao.VoucherDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;
import model.Address;
import model.Voucher;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.Timestamp;
import java.util.List;

public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isCustomer(request, response)) {
            return;
        }

        Account account = getAccount(request);
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "deleteAddress":
                    String addressIdRaw = request.getParameter("addressID");

                    if (addressIdRaw != null && !addressIdRaw.trim().isEmpty()) {
                        try {
                            int addressID = Integer.parseInt(addressIdRaw);
                            AddressDAO addressDAO = new AddressDAO();
                            addressDAO.deleteAddress(addressID);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }

                    response.sendRedirect(request.getContextPath() + "/checkout");
                    return;
            }
        }

        CartDAO cartDAO = new CartDAO();
        AddressDAO addressDAO = new AddressDAO();
        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Lọc bỏ sản phẩm hết hàng (stock = 0) trước khi tải trang thanh toán
        cartItems.removeIf(item -> item.getStockQuantity() == 0);

        if (cartItems.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Tất cả sản phẩm trong giỏ hàng đều đã hết hàng!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Điều chỉnh số lượng giỏ về bằng tồn kho nếu vượt quá (Option A)
        boolean hasAdjusted = false;
        for (CartItem item : cartItems) {
            if (item.getQuantity() > item.getStockQuantity()) {
                cartDAO.updateQuantity(item.getCartItemID(), item.getStockQuantity());
                item.setQuantity(item.getStockQuantity());
                hasAdjusted = true;
            }
        }

        if (hasAdjusted) {
            request.getSession().setAttribute("warningMessage",
                    "Một số sản phẩm đã được điều chỉnh xuống số lượng còn lại trong kho.");
        }

        BigDecimal total = cartDAO.calcSubtotal(cartItems);

        int totalQuantity = 0;
        for (CartItem item : cartItems) {
            totalQuantity += item.getQuantity();
        }

        List<Address> addressList = addressDAO.getAddressesByCustomerId(account.getId());
        request.setAttribute("cartItems", cartItems);
        request.setAttribute("total", total);
        request.setAttribute("totalQuantity", totalQuantity);
        request.setAttribute("addressList", addressList);

        // Nếu đang có voucher áp dụng trong session, kiểm tra lại còn hợp lệ không
        // (ví dụ giỏ hàng thay đổi khiến không còn đạt giá trị đơn tối thiểu)
        HttpSession session = request.getSession();
        Object voucherIdObj = session.getAttribute(SESSION_VOUCHER_ID);
        if (voucherIdObj != null) {
            String code = (String) session.getAttribute(SESSION_VOUCHER_CODE);
            VoucherDAO voucherDAO = new VoucherDAO();
            VoucherResult recheck = validateVoucher(code, account.getId(), total, voucherDAO);

            if (recheck.success) {
                session.setAttribute(SESSION_VOUCHER_DISCOUNT, recheck.discountAmount);
                request.setAttribute("appliedVoucherCode", recheck.voucher.getCode());
                request.setAttribute("appliedDiscount", recheck.discountAmount);
            } else {
                session.removeAttribute(SESSION_VOUCHER_ID);
                session.removeAttribute(SESSION_VOUCHER_CODE);
                session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
                // Báo cho khách biết lý do voucher bị gỡ, thay vì âm thầm biến mất
                request.setAttribute("errorMessage",
                        "Voucher \"" + code + "\" không còn áp dụng được: " + recheck.message);
            }
        }

        request.getRequestDispatcher("/views/cart/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        if (!isCustomer(request, response)) {
            return;
        }

        Account account = getAccount(request);
        String action = request.getParameter("action");

        if ("deleteAddressAjax".equals(action)) {
            deleteAddressAjax(request, response, account);
            return;
        }

        if ("saveAddress".equals(action)) {
            saveAddressAjax(request, response, account);
            return;
        }

        if ("applyVoucher".equals(action)) {
            handleApplyVoucher(request, response, account);
            return;
        }

        if ("removeVoucher".equals(action)) {
            handleRemoveVoucher(request, response);
            return;
        }

        String paymentMethod = request.getParameter("payment_method");

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Vui lòng chọn phương thức thanh toán!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        switch (paymentMethod) {
            case "vnpay":
                request.getRequestDispatcher("/vnpay-payment")
                        .forward(request, response);
                return;

            case "cod":
                break;

            default:
                request.getSession().setAttribute("errorMessage",
                        "Phương thức thanh toán chưa được hỗ trợ!");
                response.sendRedirect(request.getContextPath() + "/checkout");
                return;
        }

        CartDAO cartDAO = new CartDAO();
        OrderDAO orderDAO = new OrderDAO();

        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Lọc bỏ item hết hàng trước khi tạo đơn
        cartItems.removeIf(item -> item.getStockQuantity() == 0);

        if (cartItems.isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Tất cả sản phẩm trong giỏ đã hết hàng!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        BigDecimal total = cartDAO.calcSubtotal(cartItems);

        BookDAO bookDAO = new BookDAO();
        for (CartItem item : cartItems) {
            String stockError = bookDAO.validatePurchaseQuantity(item.getBookID(), item.getQuantity());
            if (stockError != null) {
                request.getSession().setAttribute("errorMessage",
                        item.getTitle() + ": " + stockError);
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }
        }

        // --- Áp lại voucher (nếu có) và xác thực lần cuối trước khi trừ tiền ---
        HttpSession session = request.getSession();
        Integer appliedVoucherID = (Integer) session.getAttribute(SESSION_VOUCHER_ID);
        BigDecimal finalTotal = total;

        if (appliedVoucherID != null) {
            VoucherDAO voucherDAO = new VoucherDAO();
            String appliedCode = (String) session.getAttribute(SESSION_VOUCHER_CODE);
            VoucherResult recheck = validateVoucher(appliedCode, account.getId(), total, voucherDAO);

            if (recheck.success) {
                finalTotal = total.subtract(BigDecimal.valueOf(recheck.discountAmount));
                if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
                    finalTotal = BigDecimal.ZERO;
                }
            } else {
                // Voucher không còn hợp lệ tại thời điểm đặt hàng (hết lượt, hết hạn...)
                appliedVoucherID = null;
                session.removeAttribute(SESSION_VOUCHER_ID);
                session.removeAttribute(SESSION_VOUCHER_CODE);
                session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
                request.getSession().setAttribute("errorMessage",
                        "Voucher không còn hợp lệ và đã được gỡ khỏi đơn hàng. Vui lòng kiểm tra lại.");
            }
        }

        String addressIDRaw = request.getParameter("addressID");

        if (isEmpty(addressIDRaw)) {
            request.getSession().setAttribute("errorMessage", "Vui lòng chọn địa chỉ giao hàng!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        int addressID;
        try {
            addressID = Integer.parseInt(addressIDRaw.trim());
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Địa chỉ giao hàng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        // Kiểm tra bảo mật: địa chỉ phải thuộc sở hữu của khách hàng đang đăng nhập
        AddressDAO addressDAO = new AddressDAO();
        List<Address> addresses = addressDAO.getAddressesByCustomerId(account.getId());
        boolean isOwnedByCustomer = false;
        for (Address addr : addresses) {
            if (addr.getAddressID() == addressID) {
                isOwnedByCustomer = true;
                break;
            }
        }

        if (!isOwnedByCustomer) {
            request.getSession().setAttribute("errorMessage", "Địa chỉ giao hàng không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if (!bookDAO.deductStockForOrder(cartItems)) {
            request.getSession().setAttribute("errorMessage",
                    "Một số sách trong giỏ đã hết hàng. Vui lòng kiểm tra lại!");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        int orderID = orderDAO.createOrder(account.getId(), addressID, paymentMethod, finalTotal);

        if (orderID == -1) {
            request.getSession().setAttribute("errorMessage", "Lỗi khi tạo đơn hàng, vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        orderDAO.createOrderDetails(orderID, cartItems);
        orderDAO.deductStock(orderID);
        orderDAO.clearCart(account.getId());

        // Ghi nhận voucher đã được sử dụng, chỉ sau khi đơn hàng tạo thành công.
        // insertVoucherUsage giờ atomic (check + insert cùng 1 transaction có khóa),
        // nên dù 2 request race nhau ở bước validateVoucher phía trên, chỉ 1 request
        // duy nhất ghi nhận thành công tại đây — request còn lại nhận USAGE_ALREADY_USED
        // hoặc USAGE_OUT_OF_QUANTITY.
        if (appliedVoucherID != null) {
            Integer voucherQuantity = null;
            // Lấy lại quantity của voucher để truyền vào hàm atomic (đảm bảo đúng ràng buộc hiện tại)
            Voucher appliedVoucher = new VoucherDAO().getVoucherByCode(
                    (String) session.getAttribute(SESSION_VOUCHER_CODE));
            if (appliedVoucher != null) {
                voucherQuantity = appliedVoucher.getQuantity();
            }

            int usageResult = new VoucherDAO()
                    .insertVoucherUsage(account.getId(), appliedVoucherID, voucherQuantity);

            if (usageResult != dao.VoucherDAO.USAGE_OK) {
                // Trường hợp hiếm: request khác đã dùng hết lượt/đã ghi nhận trước trong lúc
                // request này đang xử lý. Đơn hàng vẫn đã tạo thành công (không rollback đơn
                // để tránh trải nghiệm xấu hơn), nhưng log lại để đối soát/khuyến cáo khách.
                System.err.println("[Voucher] Không ghi nhận được lượt dùng voucher (mã lỗi="
                        + usageResult + ") cho customerID=" + account.getId()
                        + ", voucherID=" + appliedVoucherID);
            }

            session.removeAttribute(SESSION_VOUCHER_ID);
            session.removeAttribute(SESSION_VOUCHER_CODE);
            session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
        }

        request.getSession().setAttribute("cartCount", 0);

        response.sendRedirect(request.getContextPath() + "/order-confirmation?orderID=" + orderID);
    }

    private void deleteAddressAjax(HttpServletRequest request,
            HttpServletResponse response,
            Account account) throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        String addressIdRaw = request.getParameter("addressID");

        if (addressIdRaw == null || addressIdRaw.trim().isEmpty()) {
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Thiếu mã địa chỉ\"}"
            );
            return;
        }

        try {
            int addressID = Integer.parseInt(addressIdRaw.trim());

            AddressDAO addressDAO = new AddressDAO();
            boolean deleted = addressDAO.deleteAddressByCustomer(
                    addressID,
                    account.getId()
            );

            if (deleted) {
                response.getWriter().write("{\"success\":true}");
            } else {
                response.getWriter().write(
                        "{\"success\":false,\"message\":\"Không tìm thấy địa chỉ hoặc bạn không có quyền xóa\"}"
                );
            }
        } catch (NumberFormatException e) {
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Mã địa chỉ không hợp lệ\"}"
            );
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(
                    "{\"success\":false,\"message\":\"Lỗi server khi xóa địa chỉ\"}"
            );
        }
    }

    // =================================================================
    // VOUCHER — logic nghiệp vụ đặt tại Controller (đúng mô hình MVC2,
    // DAO chỉ đảm nhiệm truy vấn dữ liệu thuần)
    // =================================================================

    private static final String SESSION_VOUCHER_ID       = "appliedVoucherID";
    private static final String SESSION_VOUCHER_CODE     = "appliedVoucherCode";
    private static final String SESSION_VOUCHER_DISCOUNT = "appliedVoucherDiscount";

    private static class VoucherResult {
        boolean success;
        String message;
        Voucher voucher;
        double discountAmount;
    }

    /**
     * Kiểm tra toàn bộ điều kiện áp dụng voucher: tồn tại, đang active,
     * trong thời gian hiệu lực, đơn hàng đạt giá trị tối thiểu, còn lượt sử dụng,
     * khách hàng chưa từng dùng voucher này. Tính luôn số tiền được giảm (có chặn trần).
     */
    private VoucherResult validateVoucher(String code, int customerID, BigDecimal orderTotal, VoucherDAO voucherDAO) {
        VoucherResult r = new VoucherResult();

        if (code == null || code.trim().isEmpty()) {
            r.message = "Vui lòng nhập mã voucher.";
            return r;
        }

        Voucher v = voucherDAO.getVoucherByCode(code);
        if (v == null) {
            r.message = "Mã voucher không tồn tại.";
            return r;
        }

        if (!"active".equals(v.getStatus())) {
            r.message = "Voucher này không còn khả dụng.";
            return r;
        }

        Timestamp now = new Timestamp(System.currentTimeMillis());
        if (v.getStartDate() != null && v.getStartDate().after(now)) {
            r.message = "Voucher chưa tới thời gian sử dụng.";
            return r;
        }
        if (v.getEndDate() != null && v.getEndDate().before(now)) {
            r.message = "Voucher đã hết hạn.";
            return r;
        }

        if (v.getMinOrderValue() != null && orderTotal.doubleValue() < v.getMinOrderValue()) {
            r.message = "Đơn hàng chưa đạt giá trị tối thiểu "
                    + String.format("%,.0f", v.getMinOrderValue()) + "đ để dùng voucher này.";
            return r;
        }

        if (v.getQuantity() != null) {
            int usedCount = voucherDAO.getUsedCount(v.getVoucherID());
            if (usedCount >= v.getQuantity()) {
                r.message = "Voucher đã hết lượt sử dụng.";
                return r;
            }
        }

        if (voucherDAO.hasCustomerUsedVoucher(customerID, v.getVoucherID())) {
            r.message = "Bạn đã sử dụng voucher này rồi.";
            return r;
        }

        BigDecimal discount = orderTotal
                .multiply(BigDecimal.valueOf(v.getDiscountPercent()))
                .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);

        if (v.getMaxDiscountValue() != null) {
            BigDecimal maxDiscount = BigDecimal.valueOf(v.getMaxDiscountValue());
            if (discount.compareTo(maxDiscount) > 0) {
                discount = maxDiscount;
            }
        }
        if (discount.compareTo(orderTotal) > 0) {
            discount = orderTotal;
        }

        r.success = true;
        r.voucher = v;
        r.discountAmount = discount.doubleValue();
        r.message = "Áp dụng voucher thành công!";
        return r;
    }

    /** AJAX: khách hàng nhập mã voucher và bấm "Áp dụng" ở trang checkout. */
    private void handleApplyVoucher(HttpServletRequest request, HttpServletResponse response, Account account)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        String code = request.getParameter("code");

        CartDAO cartDAO = new CartDAO();
        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());
        cartItems.removeIf(item -> item.getStockQuantity() == 0);

        if (cartItems.isEmpty()) {
            response.getWriter().write("{\"success\":false,\"message\":\"Giỏ hàng trống hoặc đã hết hàng.\"}");
            return;
        }

        BigDecimal total = cartDAO.calcSubtotal(cartItems);

        VoucherDAO voucherDAO = new VoucherDAO();
        VoucherResult result = validateVoucher(code, account.getId(), total, voucherDAO);

        if (!result.success) {
            response.getWriter().write("{\"success\":false,\"message\":\"" + escapeJson(result.message) + "\"}");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute(SESSION_VOUCHER_ID, result.voucher.getVoucherID());
        session.setAttribute(SESSION_VOUCHER_CODE, result.voucher.getCode());
        session.setAttribute(SESSION_VOUCHER_DISCOUNT, result.discountAmount);

        BigDecimal newTotal = total.subtract(BigDecimal.valueOf(result.discountAmount));
        if (newTotal.compareTo(BigDecimal.ZERO) < 0) {
            newTotal = BigDecimal.ZERO;
        }

        String json = "{\"success\":true,\"message\":\"" + escapeJson(result.message) + "\","
                + "\"discountAmount\":" + result.discountAmount + ","
                + "\"newTotal\":" + newTotal.doubleValue() + "}";
        response.getWriter().write(json);
    }

    /** AJAX: khách hàng bấm gỡ voucher đang áp dụng. */
    private void handleRemoveVoucher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute(SESSION_VOUCHER_ID);
            session.removeAttribute(SESSION_VOUCHER_CODE);
            session.removeAttribute(SESSION_VOUCHER_DISCOUNT);
        }

        response.getWriter().write("{\"success\":true}");
    }

    private String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }

    private void saveAddressAjax(HttpServletRequest request, HttpServletResponse response, Account account)
            throws IOException {

        String street = request.getParameter("street");
        String ward = request.getParameter("ward");
        String city = request.getParameter("city");
        String isDefaultRaw = request.getParameter("isDefault");
        String recipientName = request.getParameter("fullname");
        String recipientPhone = request.getParameter("phone");

        response.setContentType("application/json;charset=UTF-8");

        if (isEmpty(street) || isEmpty(ward) || isEmpty(city)) {
            response.getWriter().write("{\"success\":false}");
            return;
        }

        if (!isValidAddressPart(street) || !isValidAddressPart(ward) || !isValidAddressPart(city)) {
            response.getWriter().write("{\"success\":false,\"message\":\"Địa chỉ không hợp lệ\"}");
            return;
        }

        if (!isValidRecipientName(recipientName)) {
            response.getWriter().write("{\"success\":false,\"message\":\"Họ tên người nhận không hợp lệ\"}");
            return;
        }

        if (!isValidPhone(recipientPhone)) {
            response.getWriter().write("{\"success\":false,\"message\":\"Số điện thoại người nhận không hợp lệ\"}");
            return;
        }

        Address address = new Address();
        address.setCustomerID(account.getId());
        address.setStreet(street.trim());
        address.setDistrict(ward.trim());
        address.setCity(city.trim());
        address.setCountry("Việt Nam");
        address.setDefault("true".equals(isDefaultRaw));

        address.setRecipientName(recipientName.trim());
        address.setRecipientPhone(recipientPhone.trim());

        AddressDAO addressDAO = new AddressDAO();
        int addressID = addressDAO.insertAddressAndReturnId(address);

        if (addressID == -1) {
            response.getWriter().write("{\"success\":false}");
            return;
        }

        response.getWriter().write("{\"success\":true,\"addressID\":" + addressID + "}");
    }

    private boolean isCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }

        Account account = (Account) session.getAttribute("account");
        if (!"customer".equals(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return false;
        }

        return true;
    }

    private Account getAccount(HttpServletRequest request) {
        return (Account) request.getSession().getAttribute("account");
    }

    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    private boolean isValidAddressPart(String value) {
        if (value == null) {
            return false;
        }

        String trimmed = value.trim();

        if (trimmed.length() < 3) {
            return false;
        }

        return trimmed.matches(".*[a-zA-ZÀ-ỹ].*");
    }

    private boolean isValidRecipientName(String value) {
        if (value == null) {
            return false;
        }

        String trimmed = value.trim();
        return trimmed.matches("^[\\p{L}][\\p{L}\\s.'-]{1,49}$");
    }

    private boolean isValidPhone(String value) {
        if (value == null) {
            return false;
        }

        return value.trim().matches("^0\\d{9}$");
    }
}