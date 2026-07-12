package controller;

import dao.AccountDAO;
import dao.AddressDAO;
import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDate;
import java.time.Period;
import java.util.List;
import model.Account;
import model.Address;
import model.Customer;

public class ProfileController extends HttpServlet {

    private void loadCustomerProfile(HttpServletRequest request, HttpServletResponse response, int customerID)
            throws ServletException, IOException {

        CustomerDAO customerDAO = new CustomerDAO();
        AddressDAO addressDAO = new AddressDAO();

        Customer customer = customerDAO.getCustomerById(customerID);
        List<Address> addresses = addressDAO.getAddressesByCustomerId(customerID);

        String section = request.getParameter("section");
        if (!"address".equals(section)) {
            section = "profile";
        }

        request.setAttribute("customer", customer);
        request.setAttribute("addresses", addresses);
        request.setAttribute("section", section);

        request.getRequestDispatcher("/views/profile/profile.jsp").forward(request, response);
    }

    private void loadStaffProfile(HttpServletRequest request, HttpServletResponse response, int accountID)
            throws ServletException, IOException {

        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.getStaffById(accountID);

        request.setAttribute("account", account);
        request.getRequestDispatcher("/views/profile/profile-admin.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account loginUser = (Account) session.getAttribute("account");
        String idParam = request.getParameter("id");

        // Nếu không truyền id thì tự động mở profile của tài khoản đang đăng nhập.
        if (idParam == null || idParam.trim().isEmpty()) {
            if ("customer".equalsIgnoreCase(loginUser.getRole())) {
                String section = request.getParameter("section");
                String redirectUrl = request.getContextPath() + "/profile?id=" + loginUser.getId();
                if ("address".equals(section)) {
                    redirectUrl += "&section=address";
                }
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/profile?id=" + loginUser.getId());
            }
            return;
        }

        idParam = idParam.trim();
        if (!idParam.matches("^[1-9]\\d*$")) {
            request.getRequestDispatcher("/views/error/404.jsp").forward(request, response);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException ex) {
            request.getRequestDispatcher("/views/error/404.jsp").forward(request, response);
            return;
        }

        // Không cho phép xem profile của tài khoản khác.
        if (id != loginUser.getId()) {
            request.getRequestDispatcher("/views/error/404.jsp").forward(request, response);
            return;
        }

        if ("customer".equalsIgnoreCase(loginUser.getRole())) {
            loadCustomerProfile(request, response, id);
        } else {
            loadStaffProfile(request, response, id);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account acc = (Account) session.getAttribute("account");
        int accountID = acc.getId();
        String action = request.getParameter("action");

        if ("customer".equalsIgnoreCase(acc.getRole())) {
            AddressDAO addressDAO = new AddressDAO();

            if ("addAddressAjax".equals(action)) {
                handleAddAddressAjax(request, response, accountID, addressDAO);
                return;
            }

            if ("updateAddressAjax".equals(action)) {
                handleUpdateAddressAjax(request, response, accountID, addressDAO);
                return;
            }

            if ("deleteAddress".equals(action)) {
                handleDeleteAddress(request, response, session, accountID, addressDAO);
                return;
            }

            if ("setDefaultAddress".equals(action)) {
                handleSetDefaultAddress(request, response, session, accountID, addressDAO);
                return;
            }

            updateCustomerProfile(request, response, session, acc);
            return;
        }

        updateStaffProfile(request, response, session, acc);
    }

    private void handleAddAddressAjax(HttpServletRequest request, HttpServletResponse response,
            int customerID, AddressDAO addressDAO) throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        try {
            String street = safeTrim(request.getParameter("street"));
            String district = safeTrim(request.getParameter("district"));
            String city = safeTrim(request.getParameter("city"));

            if (!isValidAddressPart(street)
                    || !isValidAddressPart(district)
                    || !isValidAddressPart(city)) {
                response.getWriter().write("{\"success\":false}");
                return;
            }

            Address address = new Address();
            address.setCustomerID(customerID);
            address.setStreet(street);
            address.setDistrict(district);
            address.setCity(city);
            address.setCountry("Việt Nam");
            address.setDefault(false);

            int addressID = addressDAO.insertAddressAndReturnId(address);

            if (addressID == -1) {
                response.getWriter().write("{\"success\":false}");
                return;
            }

            response.getWriter().write("{\"success\":true,\"addressID\":" + addressID + "}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false}");
        }
    }

    private void handleUpdateAddressAjax(HttpServletRequest request, HttpServletResponse response,
            int customerID, AddressDAO addressDAO) throws IOException {

        response.setContentType("application/json;charset=UTF-8");

        try {
            int addressID = Integer.parseInt(request.getParameter("addressID"));
            String street = safeTrim(request.getParameter("street"));
            String district = safeTrim(request.getParameter("district"));
            String city = safeTrim(request.getParameter("city"));

            if (!isValidAddressPart(street)
                    || !isValidAddressPart(district)
                    || !isValidAddressPart(city)) {
                response.getWriter().write("{\"success\":false}");
                return;
            }

            boolean ok = addressDAO.updateAddressByCustomer(
                    addressID, customerID, street, district, city);

            response.getWriter().write(ok
                    ? "{\"success\":true}"
                    : "{\"success\":false}");
        } catch (Exception e) {
            response.getWriter().write("{\"success\":false}");
        }
    }

    private void handleDeleteAddress(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, int customerID, AddressDAO addressDAO) throws IOException {

        try {
            int addressID = Integer.parseInt(request.getParameter("deleteAddressID"));
            boolean ok = addressDAO.deleteAddressByCustomer(addressID, customerID);

            if (ok) {
                session.setAttribute("message", "Xóa địa chỉ thành công!");
            } else {
                session.setAttribute("error", "Xóa địa chỉ thất bại!");
            }
        } catch (Exception e) {
            session.setAttribute("error", "Địa chỉ cần xóa không hợp lệ!");
        }

        response.sendRedirect(request.getContextPath()
                + "/profile?id=" + customerID + "&section=address");
    }

    private void handleSetDefaultAddress(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, int customerID, AddressDAO addressDAO) throws IOException {

        try {
            int addressID = Integer.parseInt(request.getParameter("addressID"));
            addressDAO.setDefaultAddress(addressID, customerID);
            session.setAttribute("message", "Đã đặt địa chỉ mặc định!");
        } catch (Exception e) {
            session.setAttribute("error", "Đặt mặc định thất bại!");
        }

        response.sendRedirect(request.getContextPath()
                + "/profile?id=" + customerID + "&section=address");
    }

    private void updateCustomerProfile(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, Account acc) throws IOException {

        String fullname = safeTrim(request.getParameter("fullname"));
        String phone = safeTrim(request.getParameter("phone"));
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");
        String redirectUrl = request.getContextPath() + "/profile?id=" + acc.getId();

        if (fullname.isEmpty()) {
            session.setAttribute("error", "Họ tên không được để trống");
            response.sendRedirect(redirectUrl);
            return;
        }

        if (!fullname.matches("^[\\p{L}\\s]{2,50}$")) {
            session.setAttribute("error", "Họ tên chỉ được chứa chữ cái và khoảng trắng");
            response.sendRedirect(redirectUrl);
            return;
        }

        if (!phone.matches("^0\\d{9}$")) {
            session.setAttribute("error", "Số điện thoại phải gồm 10 số và bắt đầu bằng 0");
            response.sendRedirect(redirectUrl);
            return;
        }

        if (dob == null || dob.trim().isEmpty()) {
            session.setAttribute("error", "Vui lòng chọn ngày sinh");
            response.sendRedirect(redirectUrl);
            return;
        }

        try {
            LocalDate birthDate = LocalDate.parse(dob);
            LocalDate today = LocalDate.now();

            if (birthDate.isAfter(today)) {
                session.setAttribute("error", "Ngày sinh không hợp lệ");
                response.sendRedirect(redirectUrl);
                return;
            }

            int age = Period.between(birthDate, today).getYears();
            if (age < 18 || age > 120) {
                session.setAttribute("error", "Bạn phải từ 18 tuổi đến 120 tuổi");
                response.sendRedirect(redirectUrl);
                return;
            }
        } catch (Exception e) {
            session.setAttribute("error", "Định dạng ngày sinh không hợp lệ");
            response.sendRedirect(redirectUrl);
            return;
        }

        CustomerDAO customerDAO = new CustomerDAO();
        boolean success = customerDAO.updateCustomer(
                acc.getId(), fullname, phone, gender, dob);

        if (success) {
            Customer updated = customerDAO.getCustomerById(acc.getId());
            if (updated != null) {
                Account refreshed = new Account(
                        updated.getCustomerID(),
                        updated.getFullname(),
                        updated.getEmail(),
                        updated.getPhone(),
                        updated.getRole(),
                        updated.getStatus()
                );
                session.setAttribute("account", refreshed);
            }
            session.removeAttribute("error");
            session.setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            session.removeAttribute("message");
            session.setAttribute("error", "Cập nhật thông tin thất bại!");
        }

        response.sendRedirect(redirectUrl);
    }

    private void updateStaffProfile(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, Account acc) throws IOException {

        String fullname = safeTrim(request.getParameter("fullname"));
        String phone = safeTrim(request.getParameter("phone"));
        String redirectUrl = request.getContextPath() + "/profile?id=" + acc.getId();

        if (fullname.isEmpty()) {
            session.setAttribute("error", "Họ tên không được để trống");
            response.sendRedirect(redirectUrl);
            return;
        }

        if (!fullname.matches("^[\\p{L}\\s]{2,50}$")) {
            session.setAttribute("error", "Họ tên chỉ được chứa chữ cái và khoảng trắng");
            response.sendRedirect(redirectUrl);
            return;
        }

        if (!phone.matches("^0\\d{9}$")) {
            session.setAttribute("error", "Số điện thoại phải gồm 10 số và bắt đầu bằng 0");
            response.sendRedirect(redirectUrl);
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        boolean success = accountDAO.updateStaff(
                acc.getId(),
                fullname,
                acc.getEmail(),
                phone,
                acc.getRole()
        );

        if (success) {
            Account updated = accountDAO.getStaffById(acc.getId());
            if (updated != null) {
                session.setAttribute("account", updated);
            }
            session.removeAttribute("error");
            session.setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            session.removeAttribute("message");
            session.setAttribute("error", "Cập nhật thông tin thất bại!");
        }

        response.sendRedirect(redirectUrl);
    }

    private boolean isValidAddressPart(String value) {
        if (value == null) {
            return false;
        }

        String trimmed = value.trim();
        return trimmed.length() >= 3
                && trimmed.matches(".*[a-zA-ZÀ-ỹ].*");
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }
}