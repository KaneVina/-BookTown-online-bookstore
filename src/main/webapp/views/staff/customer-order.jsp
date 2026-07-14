<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="utf-8">
                <meta content="width=device-width, initial-scale=1.0" name="viewport">
                <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
                <link
                    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap"
                    rel="stylesheet">
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
                                    "primary-container": "#1565c0",
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

            <body class="bg-background text-on-surface flex min-h-screen">
                <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
                    <main class="flex-1 md:ml-64 min-h-screen">

                        <!--header-->
                        <header class="bg-white border-b h-14 sticky top-0 z-30 flex items-center px-6"
                            style="border-color:#c2c6d4;">
                            <h2 class="font-semibold text-base" style="color:#071e27;">Quản lý Đơn hàng</h2>
                        </header>

                        <!--content-->
                        <div class="p-gutter max-w-container-max mx-auto">
                            <div class="flex flex-col md:flex-row md:items-end justify-between gap-gutter mb-stack-lg">
                                <div>
                                    <h1 class="text-2xl font-bold">Danh sách đơn hàng</h1>
                                    <p class="text-sm text-on-surface-variant mt-1">Quản lý và cập nhật tiến độ xử
                                        lý đơn hàng của BookTown.</p>
                                </div>
                            </div>

                            <div
                                class="bg-surface rounded-xl shadow-sm border border-outline-variant/10 overflow-hidden">
                                <div
                                    class="p-gutter border-b border-outline-variant/10 flex flex-wrap items-center justify-between gap-stack-md bg-surface-container-low/30">
                                    <div class="flex items-center gap-stack-sm overflow-x-auto">
                                        <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=all&keyword=${keyword}"
                                            class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${empty status or status == 'all' ? 'bg-primary text-white' : 'bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant'}">
                                            Tất cả</a>
                                        <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=pending&keyword=${keyword}"
                                            class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'pending' ? 'bg-primary text-white' : 'bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant'}">
                                            Chờ xác nhận</a>
                                        <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=confirmed&keyword=${keyword}"
                                            class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'confirmed' ? 'bg-primary text-white' : 'bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant'}">
                                            Xác nhận</a>
                                        <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=shipping&keyword=${keyword}"
                                            class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'shipping' ? 'bg-primary text-white' : 'bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant'}">
                                            Đang giao</a>
                                        <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=completed&keyword=${keyword}"
                                            class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'completed' ? 'bg-primary text-white' : 'bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant'}">
                                            Hoàn thành</a>
                                        <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=cancelled&keyword=${keyword}"
                                            class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'cancelled' ? 'bg-primary text-white' : 'bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant'}">
                                            Hủy đơn</a>
                                        <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=pending_refund&keyword=${keyword}"
                                            class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'pending_refund' ? 'bg-primary text-white' : 'bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant'}">
                                            Chờ hoàn tiền</a>
                                        <a href="${pageContext.request.contextPath}/dashboard/customer-order?status=refunded&keyword=${keyword}"
                                            class="px-4 py-2 rounded-full text-sm font-medium whitespace-nowrap ${status == 'refunded' ? 'bg-primary text-white' : 'bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant'}">
                                            Đã hoàn tiền</a>
                                    </div>

                                </div>
                                <div class="overflow-x-auto">
                                    <table class="w-full text-left border-collapse">
                                        <thead>
                                            <tr class="bg-surface-container-low/50 border-b border-outline-variant/10">
                                                <th
                                                    class="px-gutter py-3.5 text-xs text-on-surface-variant uppercase tracking-wider font-semibold">
                                                    Mã đơn</th>
                                                <th
                                                    class="px-gutter py-3.5 text-xs text-on-surface-variant uppercase tracking-wider font-semibold">
                                                    Tên khách hàng</th>
                                                <th
                                                    class="px-gutter py-3.5 text-xs text-on-surface-variant uppercase tracking-wider font-semibold">
                                                    Ngày đặt</th>
                                                <th
                                                    class="px-gutter py-3.5 text-xs text-on-surface-variant uppercase tracking-wider font-semibold">
                                                    Tổng tiền</th>
                                                <th
                                                    class="px-gutter py-3.5 text-xs text-on-surface-variant uppercase tracking-wider font-semibold">
                                                    Trạng thái</th>
                                                <th
                                                    class="px-gutter py-3.5 text-xs text-on-surface-variant uppercase tracking-wider font-semibold text-right">
                                                    Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-outline-variant/5">
                                            <c:if test="${empty orderList}">
                                                <tr>
                                                    <td colspan="6"
                                                        class="px-gutter py-8 text-center text-on-surface-variant text-sm">
                                                        Không tìm thấy đơn hàng nào.
                                                    </td>
                                                </tr>
                                            </c:if>
                                            <c:forEach var="order" items="${orderList}">
                                                <tr class="hover:bg-background-alt/50 transition-colors group">
                                                    <td class="px-gutter py-3.5">
                                                        <span
                                                            class="text-sm font-semibold text-primary">${order.orderCode}</span>
                                                    </td>
                                                    <td class="px-gutter py-3.5">
                                                        <div class="flex items-center gap-3">
                                                            <span
                                                                class="text-sm font-medium">${order.customerName}</span>
                                                        </div>
                                                    </td>
                                                    <td class="px-gutter py-3.5 text-sm text-on-surface-variant">
                                                        <fmt:formatDate value="${order.createdAt}"
                                                            pattern="HH:mm - dd/MM/yyyy" />
                                                    </td>
                                                    <td class="px-gutter py-3.5 text-sm font-semibold">
                                                        <fmt:formatNumber value="${order.totalPrice}" pattern="#,###" />
                                                        ₫
                                                    </td>
                                                    <td class="px-gutter py-3.5">
                                                        <c:choose>
                                                            <c:when test="${order.status == 'pending'}">
                                                                <span
                                                                    class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-warning/10 text-warning text-xs font-semibold">
                                                                    Chờ xác nhận
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'confirmed'}">
                                                                <span
                                                                    class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-primary-container/20 text-primary text-xs font-semibold">
                                                                    Xác nhận
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'shipping'}">
                                                                <span
                                                                    class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-tertiary/10 text-tertiary text-xs font-semibold">
                                                                    Đang giao
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'completed'}">
                                                                <span
                                                                    class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-success/10 text-success text-xs font-semibold">
                                                                    Hoàn thành
                                                                </span>
                                                            </c:when>
                                                            <c:when test="${order.status == 'cancelled'}">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${order.paymentMethod == 'vnpay' && order.paymentStatus == 'pending_refund'}">
                                                                        <span
                                                                            class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-amber-100 text-amber-700 text-xs font-semibold">
                                                                            Chờ hoàn tiền
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when
                                                                        test="${order.paymentMethod == 'vnpay' && order.paymentStatus == 'refunded'}">
                                                                        <span
                                                                            class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-blue-100 text-[#134aa4] text-xs font-semibold">
                                                                            Đã hoàn tiền
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-error/10 text-error text-xs font-semibold">
                                                                            Hủy đơn
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span
                                                                    class="inline-flex items-center px-2.5 py-0.5 rounded-full bg-error/10 text-error text-xs font-semibold">
                                                                    Hủy đơn
                                                                </span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td class="px-gutter py-3.5 text-right">
                                                        <div class="flex items-center justify-end gap-2">
                                                            <c:choose>
                                                                <c:when test="${order.status == 'pending'}">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                                        method="POST" class="inline-block m-0">
                                                                        <input type="hidden" name="action"
                                                                            value="updateStatus">
                                                                        <input type="hidden" name="orderID"
                                                                            value="${order.orderID}">
                                                                        <select name="status"
                                                                            onchange="confirmStatusChange(this)"
                                                                            class="bg-surface border border-outline-variant/30 text-on-surface rounded-lg text-xs focus:ring-primary focus:border-primary px-2 py-1 cursor-pointer">
                                                                            <option value="" disabled selected>-- Chọn
                                                                                --</option>
                                                                            <option value="confirmed">Xác nhận</option>
                                                                            <option value="cancelled">Hủy đơn</option>
                                                                        </select>
                                                                    </form>
                                                                </c:when>
                                                                <c:when test="${order.status == 'confirmed'}">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                                        method="POST" class="inline-block m-0">
                                                                        <input type="hidden" name="action"
                                                                            value="updateStatus">
                                                                        <input type="hidden" name="orderID"
                                                                            value="${order.orderID}">
                                                                        <select name="status"
                                                                            onchange="confirmStatusChange(this)"
                                                                            class="bg-surface border border-outline-variant/30 text-on-surface rounded-lg text-xs focus:ring-primary focus:border-primary px-2 py-1 cursor-pointer">
                                                                            <option value="" disabled selected>-- Chọn
                                                                                --</option>
                                                                            <option value="shipping">Đang giao</option>
                                                                            <option value="cancelled">Hủy đơn</option>
                                                                        </select>
                                                                    </form>
                                                                </c:when>
                                                                <c:when test="${order.status == 'shipping'}">
                                                                    <form
                                                                        action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                                        method="POST" class="inline-block m-0">
                                                                        <input type="hidden" name="action"
                                                                            value="updateStatus">
                                                                        <input type="hidden" name="orderID"
                                                                            value="${order.orderID}">
                                                                        <select name="status"
                                                                            onchange="confirmStatusChange(this)"
                                                                            class="bg-surface border border-outline-variant/30 text-on-surface rounded-lg text-xs focus:ring-primary focus:border-primary px-2 py-1 cursor-pointer">
                                                                            <option value="" disabled selected>-- Chọn
                                                                                --</option>
                                                                            <option value="completed">Hoàn thành
                                                                            </option>
                                                                            <option value="cancelled">Hủy đơn</option>
                                                                        </select>
                                                                    </form>
                                                                </c:when>
                                                                <c:otherwise>
                                                                </c:otherwise>
                                                            </c:choose>
                                                            <a href="${pageContext.request.contextPath}/dashboard/customer-order?action=detail&orderID=${order.orderID}"
                                                                class="p-1.5 bg-surface border border-outline-variant/30 text-primary rounded-lg hover:bg-surface-container-high transition-all inline-flex items-center active:scale-90"
                                                                title="Xem chi tiết">
                                                                <span
                                                                    class="material-symbols-outlined text-[16px]">visibility</span>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                                <div
                                    class="p-gutter border-t border-outline-variant/10 flex items-center justify-between">
                                    <p class="text-sm text-on-surface-variant">Trang ${currentPage} / ${totalPages}
                                    </p>
                                    <div class="flex items-center gap-2">
                                        <a href="${currentPage > 1 ? baseUrl.concat('&page=').concat(currentPage - 1) : '#'}"
                                            class="p-2 rounded-lg border border-outline-variant/30 text-on-surface-variant hover:bg-surface-container-high ${currentPage <= 1 ? 'opacity-30 pointer-events-none' : ''}">
                                            <span class="material-symbols-outlined text-[16px]">chevron_left</span>
                                        </a>

                                        <c:forEach var="i" begin="1" end="${totalPages}">
                                            <c:choose>
                                                <c:when test="${i == currentPage}">
                                                    <span
                                                        class="w-8 h-8 flex items-center justify-center rounded-lg bg-primary text-white text-xs font-semibold">${i}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${baseUrl}&page=${i}"
                                                        class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container-high text-on-surface-variant text-xs">${i}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>

                                        <a href="${currentPage < totalPages ? baseUrl.concat('&page=').concat(currentPage + 1) : '#'}"
                                            class="p-2 rounded-lg border border-outline-variant/30 text-on-surface-variant hover:bg-surface-container-high ${currentPage >= totalPages ? 'opacity-30 pointer-events-none' : ''}">
                                            <span class="material-symbols-outlined text-[16px]">chevron_right</span>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <%@ include file="/views/layout/dashboard/footer.jsp" %>
                    </main>
                    <%@ include file="/views/layout/common/toast.jsp" %>

                        <!-- Confirmation Modal -->
                        <div id="confirmModal"
                            class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[100]">
                            <div class="bg-white w-[450px] rounded-xl p-6 relative">
                                <button type="button"
                                    class="absolute top-3 right-4 text-2xl hover:text-gray-500 close-confirm">×</button>

                                <h3 class="text-xl font-bold mb-4" id="confirmTitle">Xác nhận hành động</h3>
                                <p class="text-gray-600 mb-6" id="confirmMessage">Bạn chắc chắn muốn thực hiện hành động
                                    này?</p>

                                <div class="flex justify-end gap-3">
                                    <button type="button"
                                        class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100 close-confirm">
                                        Hủy
                                    </button>
                                    <button type="button" id="confirmAction"
                                        class="px-4 py-2 bg-primary text-white rounded-lg hover:opacity-90">
                                        Xác nhận
                                    </button>
                                </div>
                            </div>
                        </div>

                        <script>
                            var confirmModal = null;
                            var pendingAction = null;
                            var activeSelect = null;

                            function initConfirmModal() {
                                confirmModal = document.getElementById('confirmModal');
                                document.querySelectorAll('.close-confirm').forEach(btn => {
                                    btn.addEventListener('click', closeConfirmModal);
                                });

                                if (confirmModal) {
                                    confirmModal.addEventListener('click', function (e) {
                                        if (e.target === confirmModal) {
                                            closeConfirmModal();
                                        }
                                    });
                                }

                                document.getElementById('confirmAction').addEventListener('click', executeAction);
                            }

                            function openConfirmModal(title, message, selectElement, action) {
                                document.getElementById('confirmTitle').textContent = title;
                                document.getElementById('confirmMessage').textContent = message;
                                pendingAction = action;
                                activeSelect = selectElement;

                                confirmModal.classList.remove('hidden');
                                confirmModal.classList.add('flex');
                            }

                            function closeConfirmModal() {
                                confirmModal.classList.add('hidden');
                                confirmModal.classList.remove('flex');
                                pendingAction = null;
                                if (activeSelect) {
                                    activeSelect.value = "";
                                    activeSelect = null;
                                }
                            }

                            function executeAction() {
                                if (pendingAction) {
                                    pendingAction();
                                    confirmModal.classList.add('hidden');
                                    confirmModal.classList.remove('flex');
                                    pendingAction = null;
                                    activeSelect = null;
                                }
                            }

                            document.addEventListener('DOMContentLoaded', function () {
                                initConfirmModal();
                            });

                            function confirmStatusChange(selectElement) {
                                var selectedOption = selectElement.options[selectElement.selectedIndex];
                                var nextStatusLabel = selectedOption.text.trim();
                                openConfirmModal(
                                    'Cập nhật trạng thái',
                                    'Bạn có chắc chắn muốn cập nhật trạng thái đơn hàng này thành "' + nextStatusLabel + '" không?',
                                    selectElement,
                                    function () {
                                        selectElement.form.submit();
                                    }
                                );
                            }
                        </script>

            </body>

            </html>