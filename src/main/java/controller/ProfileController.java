package controller;

import dao.AddressDAO;
import dao.CustomerDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;
import java.time.Period;
import java.util.List;
import model.Account;
import model.Address;
import model.Customer;

public class ProfileController extends HttpServlet {

    private void loadProfile(HttpServletRequest request, HttpServletResponse response, int id)
            throws ServletException, IOException {

        CustomerDAO customerDAO = new CustomerDAO();
        AddressDAO addressDAO = new AddressDAO();

        Customer customer = customerDAO.getCustomerById(id);
        List<Address> addresses = addressDAO.getAddressesByCustomerId(id);

        String section = request.getParameter("section");
        if (!"address".equals(section)) {
            section = "profile";
        }

        request.setAttribute("customer", customer);
        request.setAttribute("addresses", addresses);
        request.setAttribute("section", section);

        request.getRequestDispatcher("/views/profile/profile.jsp").forward(request, response);
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
        loadProfile(request, response, loginUser.getId());
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
        int customerID = acc.getId();
        String action = request.getParameter("action");

        AddressDAO addressDAO = new AddressDAO();

        if ("addAddressAjax".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");

            try {
                String street = request.getParameter("street");
                String district = request.getParameter("district");
                String city = request.getParameter("city");

                street = street == null ? "" : street.trim();
                district = district == null ? "" : district.trim();
                city = city == null ? "" : city.trim();

                if (!isValidAddressPart(street) || !isValidAddressPart(district) || !isValidAddressPart(city)) {
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
            return;
        }

        if ("updateAddressAjax".equals(action)) {
            response.setContentType("application/json;charset=UTF-8");

            try {
                int addressID = Integer.parseInt(request.getParameter("addressID"));
                String street = request.getParameter("street");
                String district = request.getParameter("district");
                String city = request.getParameter("city");

                street = street == null ? "" : street.trim();
                district = district == null ? "" : district.trim();
                city = city == null ? "" : city.trim();

                if (!isValidAddressPart(street) || !isValidAddressPart(district) || !isValidAddressPart(city)) {
                    response.getWriter().write("{\"success\":false}");
                    return;
                }

                boolean ok = addressDAO.updateAddressByCustomer(addressID, customerID, street, district, city);
                response.getWriter().write(ok ? "{\"success\":true}" : "{\"success\":false}");
            } catch (Exception e) {
                response.getWriter().write("{\"success\":false}");
            }
            return;
        }

        if ("deleteAddress".equals(action)) {
            String rawId = request.getParameter("deleteAddressID");

            try {
                int addressID = Integer.parseInt(rawId);
                boolean ok = addressDAO.deleteAddressByCustomer(addressID, customerID);

                if (ok) {
                    session.setAttribute("message", "Xóa địa chỉ thành công!");
                } else {
                    session.setAttribute("error", "Xóa địa chỉ thất bại!");
                }
            } catch (Exception e) {
                session.setAttribute("error", "Địa chỉ cần xóa không hợp lệ!");
            }

            response.sendRedirect(request.getContextPath() + "/profile?section=address");
            return;
        }

        if ("setDefaultAddress".equals(action)) {
            String rawId = request.getParameter("addressID");

            try {
                int addressID = Integer.parseInt(rawId);
                addressDAO.setDefaultAddress(addressID, customerID);
                session.setAttribute("message", "Đã đặt địa chỉ mặc định!");
            } catch (Exception e) {
                session.setAttribute("error", "Đặt mặc định thất bại!");
            }

            response.sendRedirect(request.getContextPath() + "/profile?section=address");
            return;
        }

        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");

        fullname = fullname == null ? "" : fullname.trim();
        phone = phone == null ? "" : phone.trim();

        if (fullname.isEmpty()) {
            session.setAttribute("error", "Họ tên không được để trống");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        if (!fullname.matches("^[\\p{L}\\s]{2,50}$")) {
            session.setAttribute("error", "Họ tên chỉ được chứa chữ cái và khoảng trắng");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        if (!phone.matches("^0\\d{9}$")) {
            session.setAttribute("error", "Số điện thoại phải gồm 10 số và bắt đầu bằng 0");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        if (dob == null || dob.trim().isEmpty()) {
            session.setAttribute("error", "Vui lòng chọn ngày sinh");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        try {
            LocalDate birthDate = LocalDate.parse(dob);
            LocalDate today = LocalDate.now();

            if (birthDate.isAfter(today)) {
                session.setAttribute("error", "Ngày sinh không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }

            int age = Period.between(birthDate, today).getYears();

            if (age < 18 || age > 120) {
                session.setAttribute("error", "Bạn phải từ 18 tuổi đến dưới 120 tuổi");
                response.sendRedirect(request.getContextPath() + "/profile");
                return;
            }
        } catch (Exception e) {
            session.setAttribute("error", "Định dạng ngày sinh không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/profile");
            return;
        }

        CustomerDAO customerDAO = new CustomerDAO();
        boolean success = customerDAO.updateCustomer(customerID, fullname, phone, gender, dob);

        if (success) {
            session.setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            session.setAttribute("error", "Cập nhật thông tin thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/profile");
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
