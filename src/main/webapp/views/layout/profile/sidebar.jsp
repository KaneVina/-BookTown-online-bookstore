<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="lg:col-span-1">
    <div class="profile-card p-6">
        <div class="flex flex-col items-center">
            <div class="relative">
                <img
                    src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
                    class="w-24 h-24 rounded-full border-4 border-blue-200 shadow"
                    alt="Avatar">
            </div>
            <h2 class="mt-4 text-xl font-bold text-center">
                ${sessionScope.account.fullname}
            </h2>
            <div class="mt-2 px-3 py-1 rounded-full bg-yellow-100 text-yellow-700 text-sm">
                ${sessionScope.account.role}
            </div>
        </div>
        <hr class="my-6">
        <nav class="space-y-2">
            <a href="${pageContext.request.contextPath}/profile?id=${sessionScope.account.id}"
               class="menu-item ${activeMenu == 'profile' ? 'menu-active' : ''}">
                <span class="material-symbols-outlined">person</span>
                Thông tin cá nhân
            </a>
            <a href="${pageContext.request.contextPath}/profile/order-history"
               class="menu-item ${activeMenu == 'orders' ? 'menu-active' : ''}">
                <span class="material-symbols-outlined">receipt_long</span>
                Lịch sử đơn hàng
            </a>
            <a href="${pageContext.request.contextPath}/profile/change-password"
               class="menu-item ${activeMenu == 'password' ? 'menu-active' : ''}">
                <span class="material-symbols-outlined">lock</span>
                Đổi mật khẩu
            </a>
            <a href="${pageContext.request.contextPath}/address"
               class="menu-item ${activeMenu == 'address' ? 'menu-active' : ''}">
                <span class="material-symbols-outlined">location_on</span>
                Địa chỉ của tôi
            </a>
            <a href="${pageContext.request.contextPath}/logout"
               class="menu-item text-red-600">
                <span class="material-symbols-outlined">logout</span>
                Đăng xuất
            </a>
        </nav>
    </div>
</div>
