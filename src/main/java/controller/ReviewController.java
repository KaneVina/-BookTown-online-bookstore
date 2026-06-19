package controller;

import dao.ReviewDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

import java.io.IOException;
import model.Review;

public class ReviewController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("account") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login"
            );
            return;
        }

        Account acc = (Account) session.getAttribute("account");
        String role = acc.getRole();

        // Chỉ admin và staff được phép truy cập
        if (!"admin".equalsIgnoreCase(role)
                && !"staff".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/home"
            );
            return;
        }

        ReviewDAO dao = new ReviewDAO();

        request.setAttribute(
                "reviews",
                dao.getAllReviews()
        );

        request.getRequestDispatcher(
                "/views/review/review-management.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "";
        }

        switch (action) {
            case "add":
                handleAddReview(request, response);
                break;
            case "reply":
                handleReplyReview(request, response);
                break;
            case "hide":
                handleHideReview(request, response);
                break;
            case "lock":
                handleLockAccount(request, response);
                break;
            default:
                sendJson(response,
                        "{\"success\":false,\"message\":\"Action không hợp lệ\"}");
        }
    }

    // thêm review mới
    private void handleAddReview(HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        if (!isCustomer(request)) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Vui lòng đăng nhập\"}");
            return;
        }

        Account acc = getAccount(request);
        int customerID = acc.getId();

        int bookID = toInt(request.getParameter("bookID"), 0);
        int rating = toInt(request.getParameter("rating"), 0);
        String comment = request.getParameter("comment");

        // Validate
        if (bookID <= 0) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Sách không hợp lệ\"}");
            return;
        }

        if (rating < 1 || rating > 5) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Đánh giá phải từ 1 đến 5 sao\"}");
            return;
        }

        if (comment == null || comment.trim().isEmpty()) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Vui lòng nhập nội dung đánh giá\"}");
            return;
        }

        comment = comment.trim();

        ReviewDAO dao = new ReviewDAO();

        // Kiểm tra customer có quyền review không
        int orderDetailID = dao.getReviewableOrderDetail(customerID, bookID);

        if (orderDetailID == -1) {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Bạn cần mua và nhận sách trước khi đánh giá\"}");
            return;
        }

        // Thêm review
        boolean success = dao.addReview(
                customerID,
                bookID,
                orderDetailID,
                rating,
                comment
        );

        if (success) {
            sendJson(response,
                    "{\"success\":true,\"message\":\"Đánh giá thành công\"}");
        } else {
            sendJson(response,
                    "{\"success\":false,\"message\":\"Không thể gửi đánh giá\"}");
        }
    }

    // admin/ staff phản hồi
    private void handleReplyReview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Kiểm tra admin/staff
        if (!isAdminOrStaff(request)) {
            sendJson(response, "{\"success\":false,\"message\":\"Bạn không có quyền thực hiện hành động này\"}");
            return;
        }

        Account acc = getAccount(request);
        int adminID = acc.getId();

        int reviewID = toInt(request.getParameter("reviewID"), 0);
        String reply = request.getParameter("reply");

        // Validate
        if (reviewID <= 0) {
            sendJson(response, "{\"success\":false,\"message\":\"Review không hợp lệ\"}");
            return;
        }

        if (reply == null || reply.trim().isEmpty()) {
            sendJson(response, "{\"success\":false,\"message\":\"Vui lòng nhập nội dung phản hồi\"}");
            return;
        }

        reply = reply.trim();

        ReviewDAO dao = new ReviewDAO();

        // Kiểm tra review tồn tại
        Review review = dao.getReviewByID(reviewID);
        if (review == null) {
            sendJson(response, "{\"success\":false,\"message\":\"Review không tồn tại\"}");
            return;
        }

        // Kiểm tra khách hàng có bị khóa không
        if (review.getCustomerStatus() != null && "inactive".equalsIgnoreCase(review.getCustomerStatus())) {
            sendJson(response, "{\"success\":false,\"message\":\"Không thể phản hồi - Tài khoản khách hàng đã bị khóa\"}");
            return;
        }

        // Phản hồi review
        boolean success = dao.replyReview(reviewID, adminID, reply);

        if (success) {
            sendJson(response, "{\"success\":true,\"message\":\"Phản hồi thành công\"}");
        } else {
            sendJson(response, "{\"success\":false,\"message\":\"Không thể phản hồi\"}");
        }
    }

    private void handleHideReview(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdmin(request)) {
            sendJson(response, "{\"success\":false,\"message\":\"Bạn không có quyền ẩn review\"}");
            return;
        }

        int reviewID = toInt(request.getParameter("reviewID"), 0);
        if (reviewID <= 0) {
            sendJson(response, "{\"success\":false,\"message\":\"Review không hợp lệ\"}");
            return;
        }

        ReviewDAO dao = new ReviewDAO();
        boolean success = dao.toggleHideReview(reviewID);

        if (success) {
            sendJson(response, "{\"success\":true,\"message\":\"Cập nhật trạng thái review thành công\"}");
        } else {
            sendJson(response, "{\"success\":false,\"message\":\"Không thể cập nhật review\"}");
        }
    }

    private void handleLockAccount(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdmin(request)) {
            sendJson(response, "{\"success\":false,\"message\":\"Bạn không có quyền khóa tài khoản\"}");
            return;
        }

        int reviewID = toInt(request.getParameter("reviewID"), 0);
        if (reviewID <= 0) {
            sendJson(response, "{\"success\":false,\"message\":\"Review không hợp lệ\"}");
            return;
        }

        ReviewDAO dao = new ReviewDAO();
        Review review = dao.getReviewByID(reviewID);

        if (review == null) {
            sendJson(response, "{\"success\":false,\"message\":\"Review không tồn tại\"}");
            return;
        }

        // Kiểm tra xem tài khoản đã bị khóa chưa
        if (review.getCustomerStatus() != null && "inactive".equalsIgnoreCase(review.getCustomerStatus())) {
            sendJson(response, "{\"success\":false,\"message\":\"Tài khoản khách hàng đã bị khóa rồi\"}");
            return;
        }

        boolean success = dao.lockAccountByReview(review.getCustomerID());

        if (success) {
            sendJson(response, "{\"success\":true,\"message\":\"Khóa tài khoản thành công\"}");
        } else {
            sendJson(response, "{\"success\":false,\"message\":\"Không thể khóa tài khoản\"}");
        }
    }

    private boolean isCustomer(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            return false;
        }
        Account acc = (Account) session.getAttribute("account");
        return "customer".equalsIgnoreCase(acc.getRole());
    }

    private boolean isAdminOrStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            return false;
        }
        Account acc = (Account) session.getAttribute("account");
        String role = acc.getRole();
        return "admin".equalsIgnoreCase(role) || "staff".equalsIgnoreCase(role);
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            return false;
        }
        Account acc = (Account) session.getAttribute("account");
        return "admin".equalsIgnoreCase(acc.getRole());
    }

    private Account getAccount(HttpServletRequest request) {
        return (Account) request.getSession().getAttribute("account");
    }

    private int toInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return defaultValue;
        }
    }

    @Override
    public String getServletInfo() {
        return "Review Controller";
    }

    private void sendJson(HttpServletResponse response, String json)
            throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().print(json);
    }
}
