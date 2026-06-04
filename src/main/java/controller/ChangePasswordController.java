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
import model.Account;

/**
 *
 * @author Trương Trân
 */
public class ChangePasswordController extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("account") == null) {

            response.sendRedirect("login");
            return;
        }

        request.getRequestDispatcher(
                "/views/profile/changePassword.jsp")
                .forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        Account acc = (Account) session.getAttribute("account");

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Không được để trống
        if (currentPassword == null || currentPassword.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {

            session.setAttribute("error", "Vui lòng nhập đầy đủ thông tin");
            response.sendRedirect(request.getContextPath() + "/change-password");
            return;
        }
        // kiểm tra độ dài của mật khẩu
        if (newPassword.length() < 8 || newPassword.length() > 15) {

            session.setAttribute("error", "Mật khẩu phải từ 8 đến 15 ký tự");
            response.sendRedirect(request.getContextPath() + "/change-password");
            return;
        }

        // mật khẩu mới ko khớp với mật khẩu hiện tại
        if (currentPassword.equals(newPassword)) {

            session.setAttribute("error", "Mật khẩu mới phải khác mật khẩu hiện tại");
            response.sendRedirect(request.getContextPath() + "/change-password");
            return;
        }

        // nếu mật khẩu mới ko khớp với xác nhận mật khẩu
        if (!newPassword.equals(confirmPassword)) {

            session.setAttribute("error", "Xác nhận mật khẩu không khớp");
            response.sendRedirect(request.getContextPath() + "/change-password");
            return;
        }

        // kiểm tra độ mạnh của mật khẩu
        if (!newPassword.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{6,50}$")) {
            session.setAttribute("error", "Mật khẩu phải chứa chữ hoa, chữ thường và số");
            response.sendRedirect(request.getContextPath() + "/change-password");

            return;
        }

        CustomerDAO dao = new CustomerDAO();

        boolean success = dao.changePassword(acc.getId(), currentPassword, newPassword);

        if (success) {
            session.setAttribute("message", "Đổi mật khẩu thành công");
        } else {
            session.setAttribute("error", "Mật khẩu hiện tại không đúng");
        }
        response.sendRedirect(request.getContextPath() + "/change-password");
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
