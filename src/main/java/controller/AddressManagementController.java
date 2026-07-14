package controller;

import dao.AddressDAO;
import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import model.Account;
import model.Address;
import model.Customer;

public class AddressManagementController extends HttpServlet {

    private final AddressDAO addressDAO = new AddressDAO();

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Account account = getLoggedInCustomer(request, response);
        if (account == null) {
            return;
        }

        CustomerDAO customerDAO = new CustomerDAO();
        Customer customer = customerDAO.getCustomerById(account.getId());
        List<Address> addresses = addressDAO.getAddressesByCustomerId(account.getId());

        request.setAttribute("customer", customer);
        request.setAttribute("addresses", addresses);
        request.getRequestDispatcher("/views/address/list.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        Account account = getLoggedInCustomer(request, response);
        if (account == null) {
            return;
        }

        String action = safeTrim(request.getParameter("action"));

        switch (action) {
            case "addAddressAjax":
                addAddressAjax(request, response, account.getId());
                return;

            case "updateAddressAjax":
                updateAddressAjax(request, response, account.getId());
                return;

            case "deleteAddress":
                deleteAddress(request, response, account.getId());
                return;

            case "setDefaultAddress":
                setDefaultAddress(request, response, account.getId());
                return;

            default:
                response.sendRedirect(request.getContextPath() + "/address");
        }
    }

    private void addAddressAjax(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {

        String street = safeTrim(request.getParameter("street"));
        String district = safeTrim(request.getParameter("district"));
        String city = safeTrim(request.getParameter("city"));

        if (!isValidAddress(street, district, city)) {
            writeJson(response, false, "Dữ liệu địa chỉ không hợp lệ");
            return;
        }

        Address address = new Address();
        address.setCustomerID(customerID);
        address.setStreet(street);
        address.setDistrict(district);
        address.setCity(city);
        address.setCountry("Việt Nam");
        address.setDefault(false);

        int newId = addressDAO.insertAddressAndReturnId(address);
        writeJson(response, newId > 0,
                newId > 0 ? "Thêm địa chỉ thành công" : "Thêm địa chỉ thất bại");
    }

    private void updateAddressAjax(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {

        Integer addressID = parsePositiveInt(request.getParameter("addressID"));
        String street = safeTrim(request.getParameter("street"));
        String district = safeTrim(request.getParameter("district"));
        String city = safeTrim(request.getParameter("city"));

        if (addressID == null || !isValidAddress(street, district, city)) {
            writeJson(response, false, "Dữ liệu địa chỉ không hợp lệ");
            return;
        }

        boolean success = addressDAO.updateAddressByCustomer(
                addressID,
                customerID,
                street,
                district,
                city
        );

        writeJson(response, success,
                success ? "Cập nhật địa chỉ thành công" : "Không tìm thấy địa chỉ");
    }

    private void deleteAddress(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {

        Integer addressID = parsePositiveInt(request.getParameter("addressID"));
        HttpSession session = request.getSession();

        if (addressID == null) {
            session.setAttribute("error", "Địa chỉ không hợp lệ!");
        } else if (addressDAO.deleteAddressByCustomer(addressID, customerID)) {
            session.setAttribute("message", "Xóa địa chỉ thành công!");
        } else {
            session.setAttribute("error", "Xóa địa chỉ thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/address");
    }

    private void setDefaultAddress(HttpServletRequest request,
            HttpServletResponse response,
            int customerID) throws IOException {

        Integer addressID = parsePositiveInt(request.getParameter("addressID"));
        HttpSession session = request.getSession();

        if (addressID == null) {
            session.setAttribute("error", "Địa chỉ không hợp lệ!");
        } else {
            addressDAO.setDefaultAddress(addressID, customerID);
            session.setAttribute("message", "Đã đặt địa chỉ mặc định!");
        }

        response.sendRedirect(request.getContextPath() + "/address");
    }

    private Account getLoggedInCustomer(HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        Account account = (Account) session.getAttribute("account");

        if (!"customer".equalsIgnoreCase(account.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }

        return account;
    }

    private boolean isValidAddress(String street, String district, String city) {
        return street.length() >= 3
                && district.length() >= 2
                && city.length() >= 2;
    }

    private Integer parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(value);
            return number > 0 ? number : null;
        } catch (Exception e) {
            return null;
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private void writeJson(HttpServletResponse response,
            boolean success,
            String message) throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        try (PrintWriter out = response.getWriter()) {
            out.print("{\"success\":" + success
                    + ",\"message\":\"" + escapeJson(message) + "\"}");
        }
    }

    private String escapeJson(String value) {
        return value.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\r", "\\r")
                .replace("\n", "\\n");
    }
}