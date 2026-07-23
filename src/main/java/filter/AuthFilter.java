package filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;

/**
 * @author PHUC KHANG
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = {"/dashboard/*"})
public class AuthFilter implements Filter {

    private static final boolean debug = true;

    private FilterConfig filterConfig = null;

    public AuthFilter() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        // false: không tự tạo session mới nếu chưa có -> tránh session rác
        HttpSession session = req.getSession(false);
        Account account = (session != null)
                ? (Account) session.getAttribute("account")
                : null;

        boolean isLoggedIn = account != null;
        boolean isAuthorized = isLoggedIn
                && ("admin".equals(account.getRole()) || "staff".equals(account.getRole()));

        if (!isLoggedIn) {
            // Chưa đăng nhập -> quay về trang login
            if (debug) {
                log("AuthFilter: chua dang nhap, redirect ve /login. URI=" + req.getRequestURI());
            }
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (!isAuthorized) {
            // Đã đăng nhập nhưng không đủ quyền (chặn cus vào dashboard)
            if (debug) {
                log("AuthFilter: khong du quyen (" + account.getRole() + "), redirect ve /home. URI=" + req.getRequestURI());
            }
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        // chặn tài khoản bị vô hiệu hóa truy cập giữa chừng (session cũ)
        if ("inactive".equalsIgnoreCase(account.getStatus())) {
            session.invalidate();
            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) {
        this.filterConfig = filterConfig;
        if (filterConfig != null && debug) {
            log("AuthFilter: Initializing filter");
        }
    }

    @Override
    public void destroy() {
        this.filterConfig = null;
    }

    public void log(String msg) {
        if (filterConfig != null) {
            filterConfig.getServletContext().log(msg);
        }
    }
}