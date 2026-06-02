<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
    .sidebar-link {
        display: flex;
        align-items: center;
        padding: 12px 16px;
        margin: 0 8px;
        border-radius: 12px;
        color: #424752;
        transition: all 0.2s;
    }

    .sidebar-link:hover {
        background: #dbf1fe;
    }

    .sidebar-link.active {
        background: #cfe6f2;
        color: #004d99;
        font-weight: 700;
    }
</style>

<%
    String currentPage = request.getRequestURI();
%>

<aside class="hidden md:flex flex-col h-screen w-64 fixed left-0 top-0 bg-background-alt border-r border-outline-variant py-base gap-stack-sm z-40">

    <div class="px-6 py-4">
        <h1 class="font-headline-sm font-bold text-primary">
            BookTown
        </h1>
        <p class="text-on-surface-variant">
            Quản trị viên
        </p>
    </div>

    <nav class="flex-1 space-y-1 mt-4">

        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="sidebar-link <%= currentPage.contains("dashboard") ? "active" : "" %>">
            <span class="material-symbols-outlined mr-3">dashboard</span>
            Bảng điều khiển
        </a>

        <a href="${pageContext.request.contextPath}/customer-order"
           class="sidebar-link <%= currentPage.contains("customer-order") ? "active" : "" %>">
            <span class="material-symbols-outlined mr-3">shopping_cart</span>
            Đơn hàng
        </a>

        <a href="${pageContext.request.contextPath}/admin/products"
           class="sidebar-link <%= currentPage.contains("products") ? "active" : "" %>">
            <span class="material-symbols-outlined mr-3">inventory_2</span>
            Kho hàng
        </a>

        <a href="${pageContext.request.contextPath}/admin/customers"
           class="sidebar-link <%= currentPage.contains("customers") ? "active" : "" %>">
            <span class="material-symbols-outlined mr-3">group</span>
            Khách hàng
        </a>

    </nav>

    <div class="px-4 mb-6">
        <button class="w-full bg-primary text-white py-3 rounded-lg shadow-sm hover:opacity-90">
            + Thêm sách mới
        </button>
    </div>

    <div class="border-t border-outline-variant pt-4 pb-2">

        <a href="${pageContext.request.contextPath}/settings"
           class="sidebar-link">
            <span class="material-symbols-outlined mr-3">settings</span>
            Cài đặt
        </a>

        <a href="${pageContext.request.contextPath}/logout"
           class="sidebar-link text-error">
            <span class="material-symbols-outlined mr-3">logout</span>
            Đăng xuất
        </a>

    </div>

</aside>