<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "secondary-fixed-dim": "#e8c41d",
                            "on-surface-variant": "#424752",
                            "on-secondary-fixed-variant": "#544600",
                            "success": "#2E7D32",
                            "on-tertiary": "#ffffff",
                            "on-primary-container": "#dae5ff",
                            "on-secondary": "#ffffff",
                            "outline-variant": "#c2c6d4",
                            "on-primary-fixed": "#001b3d",
                            "surface-tint": "#005db7",
                            "error-container": "#ffdad6",
                            "warning": "#FFA000",
                            "surface": "#FFFFFF",
                            "on-primary": "#ffffff",
                            "on-error": "#ffffff",
                            "on-background": "#071e27",
                            "tertiary-fixed-dim": "#b0c6ff",
                            "surface-dim": "#c7dde9",
                            "on-tertiary-container": "#dde5ff",
                            "on-primary-fixed-variant": "#00468c",
                            "on-error-container": "#93000a",
                            "primary": "#004d99",
                            "surface-container": "#dbf1fe",
                            "surface-container-low": "#e6f6ff",
                            "surface-container-highest": "#cfe6f2",
                            "inverse-surface": "#1e333c",
                            "primary-fixed-dim": "#a9c7ff",
                            "surface-container-lowest": "#ffffff",
                            "on-secondary-container": "#705e00",
                            "background": "#f3faff",
                            "secondary-fixed": "#ffe16e",
                            "on-surface": "#071e27",
                            "surface-variant": "#cfe6f2",
                            "inverse-primary": "#a9c7ff",
                            "error": "#D32F2F",
                            "background-alt": "#F5F7F9",
                            "on-tertiary-fixed": "#001945",
                            "on-tertiary-fixed-variant": "#00429c",
                            "on-secondary-fixed": "#221b00",
                            "secondary-container": "#fdd835",
                            "tertiary": "#134aa4",
                            "secondary": "#705d00",
                            "primary-fixed": "#d6e3ff",
                            "tertiary-fixed": "#d9e2ff",
                            "surface-bright": "#f3faff"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "stack-sm": "12px",
                            "gutter": "24px",
                            "margin-desktop": "64px",
                            "container-max": "1280px",
                            "margin-mobile": "16px",
                            "base": "8px",
                            "stack-lg": "48px",
                            "stack-md": "24px"
                        },
                        "fontFamily": {
                            "headline-lg": ["Inter"],
                            "headline-sm": ["Inter"],
                            "label-md": ["Inter"],
                            "headline-md": ["Inter"],
                            "body-sm": ["Inter"],
                            "body-md": ["Inter"]
                        }
                    },
                },
            }
        </script>
        <style>
            body {
                font-family: 'Inter', sans-serif;
            }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            ::-webkit-scrollbar {
                width: 6px;
            }
            ::-webkit-scrollbar-track {
                background: transparent;
            }
            ::-webkit-scrollbar-thumb {
                background: #c2c6d4;
                border-radius: 10px;
            }
            ::-webkit-scrollbar-thumb:hover {
                background: #727783;
            }
        </style>
    </head>
    <body class="bg-background text-on-surface min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <main class="md:ml-64 min-h-screen">
            <div class="p-gutter max-w-container-max mx-auto">
                <div class="flex flex-col md:flex-row md:items-end justify-between gap-gutter mb-stack-lg">
                    <div>
                        <h2 class="text-headline-lg font-headline-lg text-primary">Danh sách đơn hàng</h2>
                        <p class="text-body-md text-on-surface-variant mt-1">Quản lý và cập nhật tiến độ xử lý đơn hàng của BookTown.</p>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-4 gap-gutter mb-stack-lg">
                    <div class="bg-surface p-stack-md rounded-xl shadow-sm border border-outline-variant/10 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary">
                            <span class="material-symbols-outlined">pending_actions</span>
                        </div>
                        <div>
                            <p class="text-label-sm text-on-surface-variant">Chờ duyệt</p>
                            <p class="text-headline-sm font-bold">24</p>
                        </div>
                    </div>
                    <div class="bg-surface p-stack-md rounded-xl shadow-sm border border-outline-variant/10 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-lg bg-warning/10 flex items-center justify-center text-warning">
                            <span class="material-symbols-outlined">inventory_2</span>
                        </div>
                        <div>
                            <p class="text-label-sm text-on-surface-variant">Đang đóng gói</p>
                            <p class="text-headline-sm font-bold">12</p>
                        </div>
                    </div>
                    <div class="bg-surface p-stack-md rounded-xl shadow-sm border border-outline-variant/10 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-lg bg-tertiary/10 flex items-center justify-center text-tertiary">
                            <span class="material-symbols-outlined">local_shipping</span>
                        </div>
                        <div>
                            <p class="text-label-sm text-on-surface-variant">Đang giao</p>
                            <p class="text-headline-sm font-bold">45</p>
                        </div>
                    </div>
                    <div class="bg-surface p-stack-md rounded-xl shadow-sm border border-outline-variant/10 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-lg bg-success/10 flex items-center justify-center text-success">
                            <span class="material-symbols-outlined">check_circle</span>
                        </div>
                        <div>
                            <p class="text-label-sm text-on-surface-variant">Hoàn thành (24h)</p>
                            <p class="text-headline-sm font-bold">128</p>
                        </div>
                    </div>
                </div>
                <div class="bg-surface rounded-xl shadow-sm border border-outline-variant/10 overflow-hidden">
                    <!-- Filters -->
                    <div class="p-gutter border-b border-outline-variant/10 flex flex-wrap items-center justify-between gap-stack-md bg-surface-container-low/30">
                        <div class="flex items-center gap-stack-sm overflow-x-auto">
                            <button class="px-4 py-2 rounded-full bg-primary text-white text-label-md whitespace-nowrap">Tất cả</button>
                            <button class="px-4 py-2 rounded-full bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant text-label-md whitespace-nowrap">Chờ duyệt</button>
                            <button class="px-4 py-2 rounded-full bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant text-label-md whitespace-nowrap">Đang đóng gói</button>
                            <button class="px-4 py-2 rounded-full bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant text-label-md whitespace-nowrap">Đang giao</button>
                        </div>
                        <div class="flex items-center gap-stack-sm">
                            <div class="relative hidden sm:block">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">search</span>
                                <input class="pl-10 pr-4 py-2 bg-surface-container-low border-none rounded-full w-64 font-body-sm text-body-sm focus:ring-2 focus:ring-primary focus:bg-surface" placeholder="Tìm kiếm đơn hàng..." type="text">
                            </div>
                            <div class="flex items-center gap-2 text-body-sm text-on-surface-variant">
                                <span class="material-symbols-outlined text-[18px]">calendar_today</span>
                                <span>Hôm nay, 12 Th04</span>
                            </div>
                            <div class="h-4 w-px bg-outline-variant/50"></div>
                            <button class="flex items-center gap-2 text-primary font-bold text-label-md hover:underline decoration-2">
                                <span class="material-symbols-outlined text-[18px]">filter_list</span>
                                Lọc nâng cao
                            </button>
                        </div>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-surface-container-low/50 border-b border-outline-variant/10">
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Mã đơn</th>
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Tên khách hàng</th>
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Ngày đặt</th>
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Tổng tiền</th>
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Trạng thái</th>
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold text-right">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant/5">
                                <c:choose>
                                    <c:when test="${empty orders}">
                                        <tr>
                                            <td colspan="6" class="px-gutter py-10 text-center text-on-surface-variant">
                                                Chưa có đơn hàng nào.
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="order" items="${orders}">
                                            <tr class="hover:bg-background-alt/50 transition-colors group">
                                                <td class="px-gutter py-4">
                                                    <span class="font-bold text-primary">#ORD-${order.orderID}</span>
                                                </td>

                                                <td class="px-gutter py-4">
                                                    <div class="flex items-center gap-3">
                                                        <span class="text-body-sm font-medium">
                                                            <c:choose>
                                                                <c:when test="${not empty order.customerName}">${order.customerName}</c:when>
                                                                <c:otherwise>Khách hàng</c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </td>

                                                <td class="px-gutter py-4 text-body-sm text-on-surface-variant">
                                                    <fmt:formatDate value="${order.createdAt}" pattern="HH:mm - dd/MM/yyyy" />
                                                </td>

                                                <td class="px-gutter py-4 font-bold text-body-sm">
                                                    <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true" />đ
                                                </td>

                                                <td class="px-gutter py-4">
                                                    <c:choose>
                                                        <c:when test="${order.status == 'pending' || order.status == 'Chờ duyệt'}">
                                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary-container/20 text-primary text-label-sm font-bold">
                                                                <span class="w-2 h-2 rounded-full bg-primary animate-pulse"></span>
                                                                Chờ duyệt
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'packing' || order.status == 'Đang đóng gói'}">
                                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-warning/10 text-warning text-label-sm font-bold">
                                                                <span class="w-2 h-2 rounded-full bg-warning"></span>
                                                                Đang đóng gói
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'shipping' || order.status == 'Đang giao'}">
                                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-tertiary/10 text-tertiary text-label-sm font-bold">
                                                                <span class="w-2 h-2 rounded-full bg-tertiary"></span>
                                                                Đang giao
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${order.status == 'completed' || order.status == 'Hoàn thành'}">
                                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-success/10 text-success text-label-sm font-bold">
                                                                <span class="w-2 h-2 rounded-full bg-success"></span>
                                                                Hoàn thành
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-surface-container-high text-on-surface-variant text-label-sm font-bold">
                                                                <span class="w-2 h-2 rounded-full bg-on-surface-variant"></span>
                                                                ${order.status}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td class="px-gutter py-4 text-right">
                                                    <div class="flex items-center justify-end gap-2">
                                                        <a href="${pageContext.request.contextPath}/dashboard/customer-order-detail?orderID=${order.orderID}"
                                                           class="p-2 bg-surface border border-outline-variant/30 text-primary rounded-lg hover:bg-surface-container-high transition-all active:scale-90"
                                                           title="Xem chi tiết">
                                                            <span class="material-symbols-outlined text-[18px]">visibility</span>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <div class="p-gutter border-t border-outline-variant/10 flex items-center justify-between">
                        <p class="text-body-sm text-on-surface-variant">
                            Hiển thị
                            <span class="font-bold text-on-surface">${startOrder}-${endOrder}</span>
                            trên
                            <span class="font-bold text-on-surface">${totalOrders}</span>
                            đơn hàng
                        </p>

                        <div class="flex items-center gap-2">
                            <c:choose>
                                <c:when test="${currentPage > 1}">
                                    <a href="${pageContext.request.contextPath}/dashboard/customer-order?page=${currentPage - 1}"
                                       class="p-2 rounded-lg border border-outline-variant/30 text-on-surface-variant hover:bg-surface-container-high active:scale-95 transition-all">
                                        <span class="material-symbols-outlined text-[20px]">chevron_left</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="p-2 rounded-lg border border-outline-variant/30 text-on-surface-variant opacity-30 cursor-not-allowed" disabled>
                                        <span class="material-symbols-outlined text-[20px]">chevron_left</span>
                                    </button>
                                </c:otherwise>
                            </c:choose>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="${pageContext.request.contextPath}/dashboard/customer-order?page=${i}"
                                   class="w-8 h-8 flex items-center justify-center rounded-lg text-label-sm font-bold ${i == currentPage ? 'bg-primary text-white' : 'hover:bg-surface-container-high text-on-surface-variant'}">
                                    ${i}
                                </a>
                            </c:forEach>

                            <c:choose>
                                <c:when test="${currentPage < totalPages}">
                                    <a href="${pageContext.request.contextPath}/dashboard/customer-order?page=${currentPage + 1}"
                                       class="p-2 rounded-lg border border-outline-variant/30 text-on-surface-variant hover:bg-surface-container-high active:scale-95 transition-all">
                                        <span class="material-symbols-outlined text-[20px]">chevron_right</span>
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="p-2 rounded-lg border border-outline-variant/30 text-on-surface-variant opacity-30 cursor-not-allowed" disabled>
                                        <span class="material-symbols-outlined text-[20px]">chevron_right</span>
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    </div>
                </div>
            </div>
        </main>
        <div class="fixed bottom-gutter right-gutter translate-y-20 opacity-0 transition-all duration-300 pointer-events-none" id="toast">
            <div class="bg-inverse-surface text-inverse-on-surface px-6 py-3 rounded-lg shadow-xl flex items-center gap-3">
                <span class="material-symbols-outlined text-success">check_circle</span>
                <span class="text-label-md">Đơn hàng đã được phê duyệt thành công!</span>
            </div>
        </div>
        <script>

        </script>
    </body>
</html>