<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/views/layout/homepage/header.jsp" %>

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
                    <a href="${pageContext.request.contextPath}/change-password"
                       class="menu-item">
                        <span class="material-symbols-outlined">
                            lock
                        </span>
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
                    <div class="relative w-full md:w-72">
                        <input class="pl-10 pr-4 py-2 bg-white border border-gray-300 rounded-full text-sm w-full
                               focus:ring-2 focus:ring-[#17479D] focus:border-[#17479D] outline-none transition-all"
                               placeholder="Tìm kiếm đơn hàng..." type="text"/>
                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">search</span>
                    </div>
                </div>

                <div class="flex overflow-x-auto border-b border-gray-200 gap-8 no-scrollbar px-2">
                    <button class="py-3 font-semibold text-sm text-[#17479D] border-b-2 border-[#17479D] whitespace-nowrap">Tất cả</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Chờ xử lý</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Đang giao</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Hoàn thành</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Đã hủy</button>
                </div>

                <div class="space-y-4">

                    <%-- Đang giao --%>
                    <div class="profile-card p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-5">
                            <div class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200">
                                <img class="w-full h-full object-cover" alt="Book" src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=150"/>
                            </div>
                            <div class="space-y-1">
                                <p class="text-sm font-semibold text-[#17479D]">#BT-88902</p>
                                <p class="text-xs text-gray-500">Ngày đặt: 24/10/2023</p>
                                <p class="text-base font-bold text-gray-900">450.000đ</p>
                            </div>
                        </div>
                        <div class="flex items-center justify-between sm:justify-end gap-4">
                            <span class="px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-xs font-medium flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px]">local_shipping</span>
                                Đang giao
                            </span>
                            <a href="${pageContext.request.contextPath}/profile/order-history-detail">
                                <button class="px-5 py-1.5 border border-[#17479D] text-[#17479D] rounded-lg text-sm font-medium hover:bg-blue-50 transition-colors">
                                    Chi tiết
                                </button>
                            </a>
                        </div>
                    </div>

                    <div class="profile-card p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-5">
                            <div class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200">
                                <img class="w-full h-full object-cover" alt="Book" src="https://images.unsplash.com/photo-1532012197267-da84d127e765?w=150"/>
                            </div>
                            <div class="space-y-1">
                                <p class="text-sm font-semibold text-[#17479D]">#BT-88741</p>
                                <p class="text-xs text-gray-500">Ngày đặt: 18/10/2023</p>
                                <p class="text-base font-bold text-gray-900">1.280.000đ</p>
                            </div>
                        </div>
                        <div class="flex items-center justify-between sm:justify-end gap-4">
                            <span class="px-3 py-1 bg-green-50 text-green-700 rounded-full text-xs font-medium flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px]">check_circle</span>
                                Đã hoàn thành
                            </span>
                            <a href="${pageContext.request.contextPath}/profile/order-history-detail">
                                <button class="px-5 py-1.5 border border-[#17479D] text-[#17479D] rounded-lg text-sm font-medium hover:bg-blue-50 transition-colors">
                                    Chi tiết
                                </button>
                            </a>
                        </div>
                    </div>

                    <div class="profile-card p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-5">
                            <div class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200">
                                <img class="w-full h-full object-cover" alt="Book" src="https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=150"/>
                            </div>
                            <div class="space-y-1">
                                <p class="text-sm font-semibold text-[#17479D]">#BT-88622</p>
                                <p class="text-xs text-gray-500">Ngày đặt: 10/10/2023</p>
                                <p class="text-base font-bold text-gray-900">325.000đ</p>
                            </div>
                        </div>
                        <div class="flex items-center justify-between sm:justify-end gap-4">
                            <span class="px-3 py-1 bg-red-50 text-red-500 rounded-full text-xs font-medium flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px]">cancel</span>
                                Đã hủy
                            </span>
                            <a href="${pageContext.request.contextPath}/profile/order-history-detail">
                                <button class="px-5 py-1.5 border border-[#17479D] text-[#17479D] rounded-lg text-sm font-medium hover:bg-blue-50 transition-colors">
                                    Chi tiết
                                </button>
                            </a>
                        </div>
                    </div>

                    <div class="profile-card p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-5">
                            <div class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200">
                                <img class="w-full h-full object-cover" alt="Book" src="https://images.unsplash.com/photo-1512820790803-83ca734da794?w=150"/>
                            </div>
                            <div class="space-y-1">
                                <p class="text-sm font-semibold text-[#17479D]">#BT-88590</p>
                                <p class="text-xs text-gray-500">Ngày đặt: 05/10/2023</p>
                                <p class="text-base font-bold text-gray-900">210.000đ</p>
                            </div>
                        </div>
                        <div class="flex items-center justify-between sm:justify-end gap-4">
                            <span class="px-3 py-1 bg-amber-50 text-amber-600 rounded-full text-xs font-medium flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px]">pending</span>
                                Chờ xử lý
                            </span>
                            <a href="${pageContext.request.contextPath}/profile/order-history-detail">
                                <button class="px-5 py-1.5 border border-[#17479D] text-[#17479D] rounded-lg text-sm font-medium hover:bg-blue-50 transition-colors">
                                    Chi tiết
                                </button>
                            </a>
                        </div>
                    </div>

                </div>

                <div class="flex justify-center items-center gap-1.5 pt-4">
                    <button class="w-9 h-9 rounded-lg border border-gray-300 flex items-center justify-center text-gray-600 hover:bg-gray-50 transition-colors">
                        <span class="material-symbols-outlined text-[20px]">chevron_left</span>
                    </button>
                    <button class="w-9 h-9 rounded-lg bg-[#17479D] text-white font-semibold text-sm">1</button>
                    <button class="w-9 h-9 rounded-lg border border-gray-300 flex items-center justify-center text-sm text-gray-600 hover:bg-gray-50 transition-colors">2</button>
                    <button class="w-9 h-9 rounded-lg border border-gray-300 flex items-center justify-center text-sm text-gray-600 hover:bg-gray-50 transition-colors">3</button>
                    <button class="w-9 h-9 rounded-lg border border-gray-300 flex items-center justify-center text-gray-600 hover:bg-gray-50 transition-colors">
                        <span class="material-symbols-outlined text-[20px]">chevron_right</span>
                    </button>
                </div>

            </section>
        </div>

    </div>
</div>

<%@ include file="/views/layout/homepage/footer.jsp" %>
