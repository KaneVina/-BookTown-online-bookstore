<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String currentPage = request.getRequestURI();
    model.Account sidebarUser = (model.Account) session.getAttribute("account");
    String sidebarRole = "";
    String sidebarName = "";
    if (sidebarUser != null) {
        sidebarName = sidebarUser.getFullname();
        if ("admin".equals(sidebarUser.getRole())) {
            sidebarRole = "Quản trị viên";
        } else if ("staff".equals(sidebarUser.getRole())) {
            sidebarRole = "Nhân viên";
        } else {
            sidebarRole = sidebarUser.getRole();
        }
    }
    boolean isStaffUser = sidebarUser != null && "staff".equals(sidebarUser.getRole());
%>

<style>
    .sidebar-link {
        display: flex;
        align-items: center;
        padding: 10px 16px;
        margin: 0 8px;
        border-radius: 10px;
        color: #424752;
        font-size: 14px;
        font-weight: 500;
        text-decoration: none;
        transition: all 0.2s ease;
        gap: 10px;
    }

    .sidebar-link:hover {
        background: #dbf1fe;
        color: #004d99;
    }

    .sidebar-link.active {
        background: #cfe6f2;
        color: #004d99;
        font-weight: 700;
    }

    .sidebar-link.active .material-symbols-outlined {
        font-variation-settings: 'FILL' 1, 'wght' 400, 'GRAD' 0, 'opsz' 24;
    }

    /* User popup menu */
    .user-popup {
        display: none;
        position: absolute;
        bottom: 70px;
        left: 12px;
        right: 12px;
        background: white;
        border: 1px solid #c2c6d4;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(21,101,192,0.12);
        z-index: 100;
        overflow: hidden;
    }

    .user-popup.open {
        display: block;
        animation: popupIn 0.15s ease;
    }

    @keyframes popupIn {
        from {
            opacity: 0;
            transform: translateY(8px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .user-popup a {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 16px;
        font-size: 14px;
        color: #424752;
        text-decoration: none;
        transition: background 0.15s;
    }

    .user-popup a:hover {
        background: #e6f6ff;
        color: #004d99;
    }

    .user-popup a.danger:hover {
        background: #ffdad6;
        color: #D32F2F;
    }

    .user-popup .divider {
        height: 1px;
        background: #c2c6d4;
        margin: 4px 0;
    }

    .user-trigger {
        display: flex;
        align-items: center;
        gap: 10px;
        padding: 10px 12px;
        margin: 0 8px 8px;
        border-radius: 10px;
        cursor: pointer;
        transition: background 0.2s;
    }

    .user-trigger:hover {
        background: #dbf1fe;
    }
</style>

<aside class="hidden md:flex flex-col h-screen w-64 fixed left-0 top-0 bg-white border-r border-outline-variant z-40" style="border-color: #c2c6d4;">
    <div class="px-6 py-5 border-b">
        <a href="${pageContext.request.contextPath}/dashboard" class="flex items-center gap-3">
            <img src="${pageContext.request.contextPath}/assets/images/logo/logoBT_2.png"
                 alt="BookTown Logo"
                 class="h-9 object-contain"/>
        </a>
    </div>

    <nav class="flex-1 py-4 space-y-0.5 overflow-y-auto">

        <a href="${pageContext.request.contextPath}/dashboard"
           class="sidebar-link <%= currentPage.endsWith("/dashboard") ? "active" : ""%>">
            <span class="material-symbols-outlined">dashboard</span>
            Bảng điều khiển
        </a>

        <c:choose><c:when test="${sessionScope.account.role == 'staff'}">
        <a href="${pageContext.request.contextPath}/dashboard/customer-order"
           class="sidebar-link <%= currentPage.contains("customer-order") ? "active" : ""%>">
            <span class="material-symbols-outlined">shopping_cart</span>
            Đơn hàng
        </a>
        </c:when></c:choose>

        <% if (isStaffUser) { %>
        <a href="${pageContext.request.contextPath}/dashboard/product-management"
           class="sidebar-link <%= currentPage.contains("product-management") ? "active" : ""%>">
            <span class="material-symbols-outlined">inventory_2</span>
            Kho hàng
        </a>
        <% } %>

        <a href="${pageContext.request.contextPath}/dashboard/category-management"
           class="sidebar-link <%= currentPage.contains("/dashboard/category-management") ? "active" : ""%>">
            <span class="material-symbols-outlined">category</span>
            Thể loại
        </a>

        <a href="${pageContext.request.contextPath}/dashboard/account-management"
           class="sidebar-link <%= currentPage.contains("account-management") ? "active" : ""%>">
            <span class="material-symbols-outlined">group</span>
            Tài khoản
        </a>

        <a href="${pageContext.request.contextPath}/review"
           class="sidebar-link <%= currentPage.contains("review") ? "active" : ""%>">
            <span class="material-symbols-outlined">rate_review</span>
            Đánh giá
        </a>

        <a href="${pageContext.request.contextPath}/dashboard/voucher-management"
           class="sidebar-link <%= currentPage.contains("voucher") ? "active" : ""%>">
            <span class="material-symbols-outlined">sell</span>
            Voucher
        </a>

    </nav>

    <%-- User section với popup menu --%>
    <div class="border-t relative" style="border-color: #c2c6d4;">
        <div class="user-popup" id="userPopup">
            <a href="${pageContext.request.contextPath}/profile">
                <span class="material-symbols-outlined" style="font-size:18px;">
                    manage_accounts
                </span>
                Quản lý tài khoản
            </a>
            <a href="${pageContext.request.contextPath}/change-password">
                <span class="material-symbols-outlined" style="font-size:18px;">
                    lock_reset
                </span>
                Đổi mật khẩu
            </a>
            <div class="divider"></div>
            <a href="${pageContext.request.contextPath}/logout" class="danger">
                <span class="material-symbols-outlined"
                      style="font-size:18px; color:#D32F2F;">
                    logout
                </span>
                Đăng xuất
            </a>
        </div>

        <div class="user-trigger" id="userTrigger" onclick="toggleUserPopup()">
            <div class="flex-1 min-w-0">
                <p class="text-sm font-semibold truncate" style="color: #071e27;">
                    <%= sidebarName.isEmpty() ? "Người dùng" : sidebarName%>
                </p>
                <p class="text-xs truncate" style="color: #424752;">
                    <%= sidebarRole%>
                </p>
            </div>

            <span class="material-symbols-outlined text-sm"
                  style="color: #727783; font-size: 18px;"
                  id="userChevron">
                expand_less
            </span>
        </div>
    </div>

</aside>

<script>
    function toggleUserPopup() {
        const popup = document.getElementById('userPopup');
        const chevron = document.getElementById('userChevron');

        popup.classList.toggle('open');
        chevron.textContent =
                popup.classList.contains('open')
                ? 'expand_less'
                : 'expand_more';
    }

    document.addEventListener('click', function (e) {
        const trigger = document.getElementById('userTrigger');
        const popup = document.getElementById('userPopup');

        if (!trigger.contains(e.target) && !popup.contains(e.target)) {
            popup.classList.remove('open');
            document.getElementById('userChevron').textContent = 'expand_more';
        }
    });
</script>