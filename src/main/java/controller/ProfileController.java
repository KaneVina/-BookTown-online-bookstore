package controller;

import dao.AccountDAO;
import dao.CustomerDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.Period;
import model.Account;
import model.Customer;

public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
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

        // Nếu không có id -> redirect về profile của chính user
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/profile?id=" + loginUser.getId());
            return;
        }
        idParam = idParam.trim();
        // chỉ cho phép số nguyên dương
        if (!idParam.matches("^[1-9]\\d*$")) {
            request.getRequestDispatcher("/views/error/404.jsp")
                    .forward(request, response);
            return;
        }

        int id;
        try {
            id = Integer.parseInt(idParam);
        } catch (NumberFormatException ex) {
            request.getRequestDispatcher("/views/error/404.jsp")
                    .forward(request, response);
            return;
        }

        // Chỉ cho phép người dùng xem profile của chính họ
        if (id != loginUser.getId()) {
            request.getRequestDispatcher("/views/error/404.jsp")
                    .forward(request, response);
            return;
        }
        if ("customer".equalsIgnoreCase(loginUser.getRole())) {
            CustomerDAO customerDao = new CustomerDAO();
            Customer customer = customerDao.getCustomerById(id);
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/views/profile/profile.jsp").forward(request, response);
            return;
        }
        AccountDAO accountDao = new AccountDAO();
        Account account = accountDao.getStaffById(id);
        request.setAttribute("account", account);
        request.getRequestDispatcher("/views/profile/profile-admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Account acc = (Account) session.getAttribute("account");

        String fullname = safeTrim(request.getParameter("fullname"));
        String phone = safeTrim(request.getParameter("phone"));
        String gender = request.getParameter("gender"); 
        String dob = request.getParameter("dob"); 
        if (fullname.isEmpty()) {
            session.setAttribute("error", "Họ tên không được để trống");
            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }
        if (!fullname.matches("^[\\p{L}\\s]{2,50}$")) {
            session.setAttribute("error", "Họ tên chỉ được chứa chữ cái và khoảng trắng");
            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }
        if (phone == null) phone = "";
        if (!phone.matches("^0\\d{9}$")) {
            session.setAttribute("error", "Số điện thoại phải gồm 10 số và bắt đầu bằng 0");
            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }

        boolean isCustomer = "customer".equalsIgnoreCase(acc.getRole());

        if (isCustomer) {
            // Validate dob & age for customer
            if (dob == null || dob.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng chọn ngày sinh");
                response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
                return;
            }
            try {
                LocalDate birthDate = LocalDate.parse(dob);
                LocalDate today = LocalDate.now();
                if (birthDate.isAfter(today)) {
                    session.setAttribute("error", "Ngày sinh không hợp lệ");
                    response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
                    return;
                }
                int age = Period.between(birthDate, today).getYears();
                if (age < 18 || age > 120) {
                    session.setAttribute("error", "Bạn phải từ 18 tuổi đến dưới 120 tuổi");
                    response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
                    return;
                }
            } catch (Exception ex) {
                session.setAttribute("error", "Định dạng ngày sinh không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
                return;
            }

            // Update customer
            CustomerDAO dao = new CustomerDAO();
            boolean success = dao.updateCustomer(
                    acc.getId(),
                    fullname,
                    phone,
                    gender,
                    dob
            );

            if (success) {
                Customer updated = dao.getCustomerById(acc.getId());
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
                session.setAttribute("error", "Cập nhật thất bại!");
            }

            response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
            return;
        }
        AccountDAO accountDao = new AccountDAO();
        boolean success = accountDao.updateStaff(
                acc.getId(),
                fullname,
                acc.getEmail(), // keep email unchanged
                phone,
                acc.getRole()   // keep role unchanged
        );

        if (success) {
            Account updated = accountDao.getStaffById(acc.getId());
            if (updated != null) {
                session.setAttribute("account", updated);
            }
            session.removeAttribute("error");
            session.setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            session.removeAttribute("message");
            session.setAttribute("error", "Cập nhật thất bại!");
        }
        response.sendRedirect(request.getContextPath() + "/profile?id=" + acc.getId());
    }

    private String safeTrim(String s) {
        return s == null ? "" : s.trim();
    }
}