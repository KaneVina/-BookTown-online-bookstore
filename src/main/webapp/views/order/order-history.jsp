<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<style>
    body {
        background: #f3faff;
    }
    .profile-card {
        background: #fff;
        border-radius: 16px;
        border: 1px solid #dbeafe;
        box-shadow: 0 2px 10px rgba(0,0,0,.05);
    }
    .menu-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 16px;
        border-radius: 12px;
        transition: .2s;
    }
    .menu-item:hover {
        background: #eff6ff;
    }
    .menu-active {
        background: #dbeafe;
        color: #2563eb;
        font-weight: 600;
    }
</style>

<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">

<div class="max-w-7xl mx-auto py-10 px-4">
    <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">

        <div class="lg:col-span-1">
            <div class="profile-card p-6">
                <div class="flex flex-col items-center">
                    <div class="relative">
                        <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
                             class="w-24 h-24 rounded-full border-4 border-blue-200 shadow"
                             alt="Avatar">
                    </div>
                    <h2 class="mt-4 text-xl font-bold text-center">${sessionScope.account.fullname}</h2>
                    <div class="mt-2 px-3 py-1 rounded-full bg-yellow-100 text-yellow-700 text-sm">
                        ${sessionScope.account.role}
                    </div>
                </div>

                <hr class="my-6">

                <nav class="space-y-2">
                    <a href="${pageContext.request.contextPath}/profile?id=${sessionScope.account.id}"
                       class="menu-item">
                        <span class="material-symbols-outlined">person</span>
                        Thông tin cá nhân
                    </a>

                    <a href="${pageContext.request.contextPath}/profile/order-history"
                       class="menu-item menu-active">
                        <span class="material-symbols-outlined">receipt_long</span>
                        Lịch sử đơn hàng
                    </a>

                    <a href="${pageContext.request.contextPath}/profile?id=${sessionScope.account.id}&section=address"
                       class="menu-item">
                        <span class="material-symbols-outlined">location_on</span>
                        Địa chỉ của tôi
                    </a>

                    <a href="${pageContext.request.contextPath}/change-password"
                       class="menu-item">
                        <span class="material-symbols-outlined">lock</span>
                        Đổi mật khẩu
                    </a>

                    <a href="${pageContext.request.contextPath}/logout"
                       class="menu-item text-red-600">
                        <span class="material-symbols-outlined">logout</span>
                        Đăng xuất
                    </a>
                </nav>
            </div>
        </div>

        <div class="lg:col-span-3">
            <section class="space-y-6">

                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <h1 class="text-2xl font-bold text-[#17479D]">Lịch sử đơn hàng của tôi</h1>
                </div>

                <div class="flex overflow-x-auto border-b border-gray-200 gap-8 no-scrollbar px-2">
                    <button class="py-3 font-semibold text-sm text-[#17479D] border-b-2 border-[#17479D] whitespace-nowrap">Tất cả</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Chờ xử lý</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Đang giao</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Hoàn thành</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Đã hủy</button>
                </div>

                <div class="space-y-4">

                    <c:choose>
                        <c:when test="${empty orders}">
                            <div class="profile-card p-10 text-center text-gray-500">
                                Bạn chưa có đơn hàng nào.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="order" items="${orders}">
                                <div class="profile-card p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                                    <div class="flex items-center gap-5">
                                        <div class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200 flex items-center justify-center">
                                            <span class="material-symbols-outlined text-gray-400 text-3xl">receipt_long</span>
                                        </div>
                                        <div class="space-y-1">
                                            <p class="text-sm font-semibold text-[#17479D]">${order.orderCode}</p>
                                            <p class="text-xs text-gray-500">
                                                Ngày đặt:
                                                <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy"/>
                                            </p>
                                            <p class="text-base font-bold text-gray-900">
                                                <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/>đ
                                            </p>
                                        </div>
                                    </div>
                                    <div class="flex items-center justify-between sm:justify-end gap-4">
                                        <span class="px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-xs font-medium flex items-center gap-1.5">
                                            <span class="material-symbols-outlined text-[16px]">local_shipping</span>
                                            <c:choose>
                                                <c:when test="${order.status == 'pending'}">Chờ xác nhận</c:when>
                                                <c:when test="${order.status == 'confirmed'}">Đã xác nhận</c:when>
                                                <c:when test="${order.status == 'shipping'}">Đang giao</c:when>
                                                <c:when test="${order.status == 'completed'}">Hoàn thành</c:when>
                                                <c:when test="${order.status == 'cancelled'}">Đã hủy</c:when>
                                                <c:otherwise>${order.status}</c:otherwise>
                                            </c:choose>
                                        </span>

                                        <c:if test="${order.status == 'pending'}">
                                            <form method="POST"
                                                  action="${pageContext.request.contextPath}/profile/order-history"
                                                  onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng ${order.orderCode}?');">
                                                <input type="hidden" name="action" value="cancel"/>
                                                <input type="hidden" name="orderID" value="${order.orderID}"/>
                                                <button type="submit"
                                                        class="px-5 py-2 border border-red-500 text-red-500 rounded-lg text-sm font-medium hover:bg-red-50 transition-colors">
                                                    Hủy đơn
                                                </button>
                                            </form>
                                        </c:if>

                                        <a href="${pageContext.request.contextPath}/profile/order-history?action=detail&orderID=${order.orderID}">
                                            <button class="px-5 py-2 border border-[#17479D] text-[#17479D] rounded-lg text-sm font-medium hover:bg-blue-50 transition-colors">
                                                Chi tiết
                                            </button>
                                        </a>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>

                </div>

                <c:if test="${not empty orders}">
                    <%@ include file="/views/layout/common/pagination.jsp" %>
                </c:if>

            </section>
        </div>

    </div>
</div>

<%@ include file="/views/layout/homepage/footer.jsp" %>
