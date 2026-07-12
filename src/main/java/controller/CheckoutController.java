package controller;

import dao.CartDAO;
import dao.OrderDAO;
import dao.AddressDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.CartItem;
import model.Address;

import java.io.IOException;
import java.math.BigDecimal;
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

        if ("deleteAddress".equals(action)) {
            String addressIdRaw = request.getParameter("addressID");

            if (addressIdRaw != null && !addressIdRaw.trim().isEmpty()) {
                try {
                    int addressID = Integer.parseInt(addressIdRaw);
                    AddressDAO addressDAO = new AddressDAO();
                    addressDAO.deleteAddressByCustomer(addressID, account.getId());
                } catch (NumberFormatException e) {
                    e.printStackTrace();
                }
            }

            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        CartDAO cartDAO = new CartDAO();
        AddressDAO addressDAO = new AddressDAO();

        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
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

        if ("saveAddress".equals(action)) {
            saveAddressAjax(request, response, account);
            return;
        }

        if ("deleteAddressAjax".equals(action)) {
            deleteAddressAjax(request, response, account);
            return;
        }

        if ("setDefaultAddressAjax".equals(action)) {
            setDefaultAddressAjax(request, response, account);
            return;
        }

        String selectedAddressIdRaw = request.getParameter("addressID");
        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String street = request.getParameter("street");
        String ward = request.getParameter("ward");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String paymentMethod = request.getParameter("payment_method");

        if (isEmpty(fullname) || isEmpty(phone) || isEmpty(street)
                || isEmpty(ward) || isEmpty(city)) {

            request.getSession().setAttribute(
                    "errorMessage",
                    "Bạn chưa có địa chỉ. Vui lòng nhập địa chỉ giao hàng trước khi thanh toán."
            );
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if (isEmpty(district)) {
            district = "Không có";
        }

        if (!isValidFullname(fullname)) {
            request.getSession().setAttribute("errorMessage", "Họ tên người nhận không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if (!isValidPhone(phone)) {
            request.getSession().setAttribute("errorMessage", "Số điện thoại không hợp lệ!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if (!isValidAddressPart(street) || !isValidAddressPart(ward) || !isValidAddressPart(city)) {
            request.getSession().setAttribute("errorMessage", "Địa chỉ không hợp lệ, vui lòng nhập lại!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if ("vnpay".equals(paymentMethod)) {
            request.getRequestDispatcher("/vnpay-payment").forward(request, response);
            return;
        }

        if (!"cod".equals(paymentMethod)) {
            request.getSession().setAttribute("errorMessage", "Phương thức thanh toán chưa được hỗ trợ!");
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

        BigDecimal total = cartDAO.calcSubtotal(cartItems);

        AddressDAO addressDAO = new AddressDAO();

        int addressID = -1;

        if (!isEmpty(selectedAddressIdRaw)) {
            try {
                int selectedAddressID = Integer.parseInt(selectedAddressIdRaw.trim());
                Address selectedAddress = addressDAO.getAddressByIdAndCustomer(selectedAddressID, account.getId());
                if (selectedAddress != null) {
                    addressID = selectedAddress.getAddressID();
                }
            } catch (NumberFormatException ignored) {
                addressID = -1;
            }
        }

        if (addressID == -1) {
            Address address = new Address();
            address.setCustomerID(account.getId());
            address.setStreet(street.trim());
            address.setDistrict(ward.trim());
            address.setCity(city.trim());
            address.setCountry("Việt Nam");
            address.setDefault(false);

            addressID = addressDAO.insertAddressAndReturnId(address);
        }

        if (addressID == -1) {
            request.getSession().setAttribute("errorMessage", "Lỗi khi lưu địa chỉ, vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        int orderID = orderDAO.createOrder(account.getId(), addressID, paymentMethod, total);

        if (orderID == -1) {
            request.getSession().setAttribute("errorMessage", "Lỗi khi tạo đơn hàng, vui lòng thử lại!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        orderDAO.createOrderDetails(orderID, cartItems);
        orderDAO.clearCart(account.getId());

        request.getSession().setAttribute("cartCount", 0);

        response.sendRedirect(request.getContextPath() + "/order-confirmation?orderID=" + orderID);
    }

    private void saveAddressAjax(HttpServletRequest request, HttpServletResponse response, Account account)
            throws IOException {

        String street = request.getParameter("street");
        String ward = request.getParameter("ward");
        String city = request.getParameter("city");
        String isDefaultRaw = request.getParameter("isDefault");

        response.setContentType("application/json;charset=UTF-8");

        if (isEmpty(street) || isEmpty(ward) || isEmpty(city)) {
            response.getWriter().write("{\"success\":false}");
            return;
        }

        if (!isValidAddressPart(street) || !isValidAddressPart(ward) || !isValidAddressPart(city)) {
            response.getWriter().write("{\"success\":false}");
            return;
        }

        Address address = new Address();
        address.setCustomerID(account.getId());
        address.setStreet(street.trim());
        address.setDistrict(ward.trim());
        address.setCity(city.trim());
        address.setCountry("Việt Nam");
        address.setDefault("true".equals(isDefaultRaw));

        AddressDAO addressDAO = new AddressDAO();
        int addressID = addressDAO.insertAddressAndReturnId(address);

        if (addressID == -1) {
            response.getWriter().write("{\"success\":false}");
            return;
        }

        response.getWriter().write("{\"success\":true,\"addressID\":" + addressID + "}");
    }

    private void deleteAddressAjax(HttpServletRequest request, HttpServletResponse response, Account account)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        String addressIdRaw = request.getParameter("addressID");

        if (isEmpty(addressIdRaw)) {
            response.getWriter().write("{\"success\":false}");
            return;
        }

        try {
            int addressID = Integer.parseInt(addressIdRaw);
            AddressDAO addressDAO = new AddressDAO();
            boolean ok = addressDAO.deleteAddressByCustomer(addressID, account.getId());

            response.getWriter().write("{\"success\":" + ok + "}");
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false}");
        }
    }

    private void setDefaultAddressAjax(HttpServletRequest request, HttpServletResponse response, Account account)
            throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        String addressIdRaw = request.getParameter("addressID");

        if (isEmpty(addressIdRaw)) {
            response.getWriter().write("{\"success\":false}");
            return;
        }

        try {
            int addressID = Integer.parseInt(addressIdRaw);
            AddressDAO addressDAO = new AddressDAO();
            addressDAO.setDefaultAddress(addressID, account.getId());

            response.getWriter().write("{\"success\":true}");
        } catch (NumberFormatException e) {
            response.getWriter().write("{\"success\":false}");
        }
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

    private boolean isValidFullname(String fullname) {
        String trimmed = fullname.trim();
        return trimmed.matches("^[A-Za-zÀ-ỹ\\s]{2,50}$");
    }

    private boolean isValidPhone(String phone) {
        String trimmed = phone.trim();
        return trimmed.matches("^(0|\\+84)(3|5|7|8|9)[0-9]{8}$");
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
}
