<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
        box-shadow: 0 2px 10px rgba(0, 0, 0, .05);
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

<link
    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
    rel="stylesheet">

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
                    <h2 class="mt-4 text-xl font-bold text-center">${sessionScope.account.fullname}
                    </h2>
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
                    <a href="${pageContext.request.contextPath}/profile/order-history"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${empty status or status == '' ? 'font-semibold text-[#17479D] border-b-2 border-[#17479D]' : 'font-medium text-gray-600 hover:text-[#17479D]'}">
                        Tất cả</a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=pending"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'pending' ? 'font-semibold text-[#17479D] border-b-2 border-[#17479D]' : 'font-medium text-gray-600 hover:text-[#17479D]'}">
                        Chờ xác nhận</a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=confirmed"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'confirmed' ? 'font-semibold text-[#17479D] border-b-2 border-[#17479D]' : 'font-medium text-gray-600 hover:text-[#17479D]'}">
                        Xác nhận</a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=shipping"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'shipping' ? 'font-semibold text-[#17479D] border-b-2 border-[#17479D]' : 'font-medium text-gray-600 hover:text-[#17479D]'}">
                        Đang giao</a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=completed"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'completed' ? 'font-semibold text-[#17479D] border-b-2 border-[#17479D]' : 'font-medium text-gray-600 hover:text-[#17479D]'}">
                        Hoàn thành</a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=cancelled"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'cancelled' ? 'font-semibold text-[#17479D] border-b-2 border-[#17479D]' : 'font-medium text-gray-600 hover:text-[#17479D]'}">
                        Hủy đơn</a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=pending_refund"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'pending_refund' ? 'font-semibold text-[#17479D] border-b-2 border-[#17479D]' : 'font-medium text-gray-600 hover:text-[#17479D]'}">
                        Chờ hoàn tiền</a>
                    <a href="${pageContext.request.contextPath}/profile/order-history?status=refunded"
                       class="py-3 text-sm whitespace-nowrap transition-colors ${status == 'refunded' ? 'font-semibold text-[#17479D] border-b-2 border-[#17479D]' : 'font-medium text-gray-600 hover:text-[#17479D]'}">
                        Đã hoàn tiền</a>
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
                                <div
                                    class="profile-card p-5 flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                                    <div class="flex items-center gap-5">
                                        <div
                                            class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200 flex items-center justify-center">
                                            <span
                                                class="material-symbols-outlined text-gray-400 text-3xl">receipt_long</span>
                                        </div>
                                        <div class="space-y-1">
                                            <p class="text-sm font-semibold text-[#17479D]">${order.orderCode}</p>
                                            <p class="text-xs text-gray-500">
                                                Ngày đặt:
                                                <fmt:formatDate value="${order.createdAt}"
                                                                pattern="dd/MM/yyyy" />
                                            </p>
                                            <p class="text-base font-bold text-gray-900">
                                                <fmt:formatNumber value="${order.totalPrice}"
                                                                  type="number" groupingUsed="true" />đ
                                            </p>
                                        </div>
                                    </div>
                                    <div
                                        class="flex items-center justify-between sm:justify-end gap-4">
                                        <c:choose>
                                            <c:when test="${order.status == 'pending'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full bg-yellow-50 text-[#e65c00] text-xs font-semibold">
                                                    Chờ xác nhận
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status == 'confirmed'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full bg-blue-50 text-[#004d99] text-xs font-semibold">
                                                    Xác nhận
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status == 'shipping'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full bg-indigo-50 text-[#134aa4] text-xs font-semibold">
                                                    Đang giao
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status == 'completed'}">
                                                <span class="inline-flex items-center px-3 py-1 rounded-full bg-green-50 text-[#2E7D32] text-xs font-semibold">
                                                    Hoàn thành
                                                </span>
                                            </c:when>
                                            <c:when test="${order.status == 'cancelled'}">
                                                <c:choose>
                                                    <c:when test="${order.paymentMethod == 'vnpay' && order.paymentStatus == 'pending_refund'}">
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full bg-amber-50 text-amber-600 text-xs font-semibold">
                                                            Chờ hoàn tiền
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${order.paymentMethod == 'vnpay' && order.paymentStatus == 'refunded'}">
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full bg-green-50 text-green-700 text-xs font-semibold">
                                                            Đã hoàn tiền
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="inline-flex items-center px-3 py-1 rounded-full bg-red-50 text-[#D32F2F] text-xs font-semibold">
                                                            Hủy đơn
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="inline-flex items-center px-3 py-1 rounded-full bg-gray-100 text-gray-600 text-xs font-semibold">
                                                    ${order.status}
                                                </span>
                                            </c:otherwise>
                                        </c:choose>

                                         <c:if test="${order.status == 'pending'}">
                                             <form method="POST" id="cancelForm_${order.orderID}"
                                                   action="${pageContext.request.contextPath}/profile/order-history">
                                                 <input type="hidden" name="action" value="cancel" />
                                                 <input type="hidden" name="orderID"
                                                        value="${order.orderID}" />
                                                 <button type="button"
                                                         onclick="confirmCancelCustomer('Hủy đơn hàng', 'Bạn có chắc muốn hủy đơn hàng ${order.orderCode}?', 'cancelForm_${order.orderID}')"
                                                         class="px-5 py-2 border border-red-500 text-red-500 rounded-lg text-sm font-medium hover:bg-red-50 transition-colors">
                                                     Hủy đơn
                                                 </button>
                                             </form>
                                         </c:if>

                                        <a
                                            href="${pageContext.request.contextPath}/profile/order-history?action=detail&orderID=${order.orderID}">
                                            <button
                                                class="px-5 py-2 border border-[#17479D] text-[#17479D] rounded-lg text-sm font-medium hover:bg-blue-50 transition-colors">
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

<!-- Confirmation Modal -->
<div id="confirmModal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[100]">
    <div class="bg-white w-[450px] rounded-xl p-6 relative">
        <button type="button" class="absolute top-3 right-4 text-2xl hover:text-gray-500 close-confirm">×</button>

        <h3 class="text-xl font-bold mb-4" id="confirmTitle">Xác nhận hành động</h3>
        <p class="text-gray-600 mb-6" id="confirmMessage">Bạn chắc chắn muốn thực hiện hành động này?</p>

        <div class="flex justify-end gap-3">
            <button type="button" class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100 close-confirm">
                Hủy
            </button>
            <button type="button" id="confirmAction" class="px-4 py-2 bg-[#17479D] text-white rounded-lg hover:opacity-90">
                Xác nhận
            </button>
        </div>
    </div>
</div>

<script>
    var confirmModal = null;
    var pendingAction = null;

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

    function openConfirmModal(title, message, action) {
        document.getElementById('confirmTitle').textContent = title;
        document.getElementById('confirmMessage').textContent = message;
        pendingAction = action;

        confirmModal.classList.remove('hidden');
        confirmModal.classList.add('flex');
    }

    function closeConfirmModal() {
        confirmModal.classList.add('hidden');
        confirmModal.classList.remove('flex');
        pendingAction = null;
    }

    function executeAction() {
        if (pendingAction) {
            pendingAction();
            closeConfirmModal();
        }
    }

    function confirmCancelCustomer(title, message, formId) {
        openConfirmModal(title, message, function() {
            document.getElementById(formId).submit();
        });
    }

    document.addEventListener('DOMContentLoaded', function () {
        initConfirmModal();
    });
</script>