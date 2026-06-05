/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.CustomerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.Period;
import model.Account;
import model.Customer;

/**
 *
 * @author Trương Trân
 */
public class ProfileController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login");
            return;
        }

        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        int id = Integer.parseInt(idParam);

        // user đang đăng nhập
        Account loginUser = (Account) session.getAttribute("account");

        // nếu id trên URL khác id của user đăng nhập
        if (id != loginUser.getId()) {

            request.getRequestDispatcher("/views/error/404.jsp")
                    .forward(request, response);

            return;
        }

        CustomerDAO dao = new CustomerDAO();

        Customer customer = dao.getCustomerById(id);

        System.out.println("Customer = " + customer);

        if (customer != null) {
            System.out.println("Name = " + customer.getFullname());
        }

        request.setAttribute("customer", customer);

        request.getRequestDispatcher("/views/profile/profile.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect("login");
            return;
        }

        Account acc = (Account) session.getAttribute("account");

        String fullname = request.getParameter("fullname");
        String phone = request.getParameter("phone");
        String gender = request.getParameter("gender");
        String dob = request.getParameter("dob");

        fullname = fullname.trim();
        phone = phone.trim();

        if (fullname.isEmpty()) {
            session.setAttribute("error",
                    "Họ tên không được để trống");

            response.sendRedirect(
                    request.getContextPath()
                    + "/profile?id="
                    + acc.getId());

            return;
        }

        if (!fullname.matches("^[\\p{L}\\s]{2,50}$")) {
            session.setAttribute("error",
                    "Họ tên chỉ được chứa chữ cái và khoảng trắng");

            response.sendRedirect(
                    request.getContextPath()
                    + "/profile?id="
                    + acc.getId());

            return;
        }

        if (!phone.matches("^0\\d{9}$")) {
            session.setAttribute("error",
                    "Số điện thoại phải gồm 10 số và bắt đầu bằng 0");

            response.sendRedirect(
                    request.getContextPath()
                    + "/profile?id="
                    + acc.getId());

            return;
        }

        if (dob == null || dob.trim().isEmpty()) {
            session.setAttribute("error",
                    "Vui lòng chọn ngày sinh");

            response.sendRedirect(
                    request.getContextPath()
                    + "/profile?id="
                    + acc.getId());
            return;
        }

        try {
            LocalDate birthDate = LocalDate.parse(dob);
            LocalDate today = LocalDate.now();

            // Không cho chọn ngày tương lai
            if (birthDate.isAfter(today)) {
                session.setAttribute("error",
                        "Ngày sinh không hợp lệ");

                response.sendRedirect(
                        request.getContextPath()
                        + "/profile?id="
                        + acc.getId());
                return;
            }

            int age = Period.between(birthDate, today).getYears();

            // Giới hạn tuổi tối thiểu
            if (age < 18 || age > 120) {
                session.setAttribute("error",
                        "Bạn phải từ 18 tuổi đến dưới 120 tuổi");

                response.sendRedirect(
                        request.getContextPath()
                        + "/profile?id="
                        + acc.getId());
                return;
            }

        } catch (Exception e) {
            session.setAttribute("error",
                    "Định dạng ngày sinh không hợp lệ");

            response.sendRedirect(
                    request.getContextPath()
                    + "/profile?id="
                    + acc.getId());
            return;
        }

        CustomerDAO dao = new CustomerDAO();

        boolean success = dao.updateCustomer(
                acc.getId(),
                fullname,
                phone,
                gender,
                dob
        );

        if (success) {
            session.removeAttribute("error");
            session.setAttribute(
                    "message",
                    "Cập nhật thông tin thành công!"
            );
        } else {
            session.removeAttribute("message");
            session.setAttribute(
                    "error",
                    "Cập nhật thất bại!"
            );
        }

        response.sendRedirect(
                request.getContextPath()
                + "/profile?id="
                + acc.getId()
        );
    }
}
