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
        CartDAO cartDAO = new CartDAO();
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

        request.setAttribute("cartItems",     cartItems);
        request.setAttribute("total",         total);
        request.setAttribute("totalQuantity", totalQuantity);

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

        String fullname      = request.getParameter("fullname");
        String phone         = request.getParameter("phone");
        String street        = request.getParameter("street");
        String district       = request.getParameter("district");
        String city          = request.getParameter("city");
        String paymentMethod = request.getParameter("payment_method");

        if (isEmpty(fullname) || isEmpty(phone) || isEmpty(street)
                || isEmpty(district) || isEmpty(city)) {

            request.getSession().setAttribute("errorMessage", "Vui lòng nhập đầy đủ thông tin giao hàng!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if (!isValidAddressPart(street) || !isValidAddressPart(district) || !isValidAddressPart(city)) {

            request.getSession().setAttribute("errorMessage", "Địa chỉ không hợp lệ, vui lòng nhập lại!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        if (!"cod".equals(paymentMethod)) {
            request.getSession().setAttribute("errorMessage", "Phương thức thanh toán chưa được hỗ trợ!");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        CartDAO  cartDAO  = new CartDAO();
        OrderDAO orderDAO = new OrderDAO();

        List<CartItem> cartItems = cartDAO.getCartItems(account.getId());

        if (cartItems.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        BigDecimal total = cartDAO.calcSubtotal(cartItems);

        int addressID = orderDAO.createTempAddress(account.getId(),
                street.trim(), district.trim(), city.trim());

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
        String trimmed = value.trim();
        if (trimmed.length() < 3) {
            return false;
        }
        return trimmed.matches(".*[a-zA-ZÀ-ỹ].*");
    }
}