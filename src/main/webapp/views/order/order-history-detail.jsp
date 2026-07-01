<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>
<!DOCTYPE html>
<html lang="vi" class="light">

    <head>
        <meta charset="utf-8" />
        <meta content="width=device-width, initial-scale=1.0" name="viewport" />
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap"
            rel="stylesheet" />
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                display: inline-block;
                vertical-align: middle;
            }

            body {
                background-color: #f3faff;
            }
        </style>
    </head>

    <body class="text-[#071e27] antialiased bg-[#f3faff]">
        <main class="max-w-[1280px] mx-auto px-4 md:px-16 py-12">

            <div
                class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
                <div>
                    <nav class="flex items-center gap-2 mb-2">
                        <a class="text-xs font-medium text-[#424752] hover:text-[#004d99] transition-colors"
                           href="${pageContext.request.contextPath}/profile/order-history">
                            Đơn hàng của tôi</a>
                        <span
                            class="material-symbols-outlined text-xs text-[#727783]">chevron_right</span>
                        <span class="text-xs text-[#004d99] font-bold">Chi tiết đơn hàng</span>
                    </nav>

                    <div class="flex flex-wrap items-center gap-3">
                        <h1 class="text-2xl font-bold text-[#071e27]">Đơn hàng ${order.orderCode}
                        </h1>

                        <span class="px-3 py-1 font-bold text-xs rounded-full flex items-center
                              <c:choose>
                                  <c:when test='${order.status == "pending"}'>bg-yellow-50 text-[#e65c00]
                                  </c:when>
                                  <c:when test='${order.status == "confirmed"}'>bg-blue-50 text-[#004d99]
                                  </c:when>
                                  <c:when test='${order.status == "shipping"}'>bg-indigo-50
                                      text-[#134aa4]</c:when>
                                  <c:when test='${order.status == "completed"}'>bg-green-50
                                      text-[#2E7D32]</c:when>
                                  <c:otherwise>bg-red-50 text-[#D32F2F]</c:otherwise>
                              </c:choose>">
                            <c:choose>
                                <c:when test="${order.status == 'pending'}">Chờ xác nhận
                                </c:when>
                                <c:when test="${order.status == 'confirmed'}">Xác nhận
                                </c:when>
                                <c:when test="${order.status == 'shipping'}">Đang giao
                                </c:when>
                                <c:when test="${order.status == 'completed'}">Hoàn thành
                                </c:when>
                                <c:when test="${order.status == 'cancelled'}">Hủy đơn
                                </c:when>
                                <c:otherwise>${order.status}</c:otherwise>
                            </c:choose>
                        </span>
                    </div>

                    <p class="text-xs text-[#424752] mt-1.5">
                        Ngày đặt: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy • HH:mm" />
                    </p>
                </div>

                <div class="flex gap-3 w-full md:w-auto">
                    <c:if test="${order.status == 'pending'}">
                        <form id="cancelOrderForm" method="POST"
                              action="${pageContext.request.contextPath}/profile/order-history">
                            <input type="hidden" name="action" value="cancel" />
                            <input type="hidden" name="orderID" value="${order.orderID}" />
                            <button type="button" onclick="confirmCancelOrder()"
                                    class="flex-1 md:flex-none px-5 py-2 bg-white border border-[#D32F2F] text-[#D32F2F] font-semibold text-sm rounded-lg hover:bg-red-50 transition-colors">
                                Hủy đơn hàng
                            </button>
                        </form>
                    </c:if>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-12 gap-6">
                <div class="lg:col-span-8 space-y-6">
                    <c:set var="step" value="1" />
                    <c:if test="${order.status == 'confirmed'}">
                        <c:set var="step" value="2" />
                    </c:if>
                    <c:if test="${order.status == 'shipping'}">
                        <c:set var="step" value="3" />
                    </c:if>
                    <c:if test="${order.status == 'completed'}">
                        <c:set var="step" value="4" />
                    </c:if>

                    <c:choose>
                        <c:when test="${order.status == 'cancelled'}">
                            <section
                                class="bg-red-50 border border-red-200 rounded-xl p-6 flex items-center gap-3">
                                <span
                                    class="material-symbols-outlined text-red-500">cancel</span>
                                <p class="text-sm font-semibold text-red-700">
                                    Đơn hàng này đã bị hủy.</p>
                            </section>
                        </c:when>
                        <c:otherwise>
                            <section
                                class="bg-white p-6 rounded-xl border border-[#c2c6d4] shadow-sm">
                                <h2 class="text-lg font-bold text-[#071e27] mb-6">
                                    Trạng thái vận chuyển</h2>

                                <div class="relative flex justify-between items-start">
                                    <div class="absolute top-5 left-0 w-full h-1 bg-gray-200 z-0 rounded-full">
                                        <div class="h-full bg-[#004d99] rounded-full transition-all"
                                             style="width: ${(step - 1) * 100 / 3}%;">
                                        </div>
                                    </div>

                                    <div
                                        class="relative z-10 flex flex-col items-center text-center">
                                        <div
                                            class="w-10 h-10 rounded-full bg-[#004d99] text-white flex items-center justify-center mb-2 shadow-sm">
                                            <span
                                                class="material-symbols-outlined text-[22px]"
                                                style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                        </div>
                                        <span
                                            class="text-xs font-bold text-[#004d99]">Đã
                                            đặt hàng</span>
                                        <span
                                            class="text-[11px] text-[#424752] mt-0.5">
                                            <fmt:formatDate
                                                value="${order.createdAt}"
                                                pattern="dd/MM/yyyy" />
                                        </span>
                                    </div>

                                    <div
                                        class="relative z-10 flex flex-col items-center text-center ${step < 2 ? 'opacity-40' : ''}">
                                        <div
                                            class="w-10 h-10 rounded-full flex items-center justify-center mb-2 shadow-sm
                                            ${step > 2 ? 'bg-[#004d99] text-white' : (step == 2 ? 'bg-[#e6f6ff] text-[#004d99] border-2 border-[#004d99]' : 'bg-gray-100 text-gray-500 border border-gray-200')}">
                                            <span
                                                class="material-symbols-outlined text-[22px]">
                                                <c:choose>
                                                    <c:when test="${step > 2}">
                                                        check_circle</c:when>
                                                    <c:otherwise>pending
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <span
                                            class="text-xs font-bold text-[#071e27]">Xác nhận</span>
                                    </div>

                                    <div
                                        class="relative z-10 flex flex-col items-center text-center ${step < 3 ? 'opacity-40' : ''}">
                                        <div
                                            class="w-10 h-10 rounded-full flex items-center justify-center mb-2 shadow-sm
                                            ${step > 3 ? 'bg-[#004d99] text-white' : (step == 3 ? 'bg-[#e6f6ff] text-[#004d99] border-2 border-[#004d99]' : 'bg-gray-100 text-gray-500 border border-gray-200')}">
                                            <span
                                                class="material-symbols-outlined text-[22px]">local_shipping</span>
                                        </div>
                                        <span
                                            class="text-xs font-semibold text-[#071e27]">Đang
                                            giao</span>
                                    </div>

                                    <div
                                        class="relative z-10 flex flex-col items-center text-center ${step < 4 ? 'opacity-40' : ''}">
                                        <div
                                            class="w-10 h-10 rounded-full flex items-center justify-center mb-2 shadow-sm
                                            ${step == 4 ? 'bg-[#004d99] text-white' : 'bg-gray-100 text-gray-500 border border-gray-200'}">
                                            <span
                                                class="material-symbols-outlined text-[22px]">package_2</span>
                                        </div>
                                        <span
                                            class="text-xs font-semibold text-[#071e27]">Đã
                                            nhận</span>
                                    </div>
                                </div>
                            </section>
                        </c:otherwise>
                    </c:choose>

                    <section
                        class="bg-white rounded-xl border border-[#c2c6d4] shadow-sm overflow-hidden">
                        <div class="p-5 border-b border-[#c2c6d4] bg-[#F5F7F9]">
                            <h2 class="text-base font-bold text-[#071e27]">Sản phẩm
                                trong đơn (${orderDetails.size()})</h2>
                        </div>
                        <div class="divide-y divide-[#c2c6d4]">
                            <c:forEach var="item" items="${orderDetails}">
                                <div
                                    class="p-5 flex gap-5 hover:bg-[#F5F7F9] transition-colors group">
                                    <div
                                        class="w-20 h-28 bg-gray-100 rounded-lg overflow-hidden border border-gray-200 shadow-sm flex-shrink-0">
                                        <c:choose>
                                            <c:when
                                                test="${not empty item.thumbnail}">
                                                <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                                                     alt="${item.title}"
                                                     src="${item.thumbnail}" />
                                            </c:when>
                                            <c:otherwise>
                                                <div
                                                    class="w-full h-full flex items-center justify-center text-gray-300">
                                                    <span
                                                        class="material-symbols-outlined text-3xl">menu_book</span>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>

                                    <div
                                        class="flex-1 flex flex-col justify-between">
                                        <div
                                            class="flex justify-between items-start gap-4">
                                            <div>
                                                <h3
                                                    class="font-bold text-[#071e27] text-base group-hover:text-[#004d99] transition-colors">
                                                    ${item.title}</h3>
                                                <p
                                                    class="text-xs font-medium text-gray-500 mt-2">
                                                    Số lượng: ${item.quantity}</p>
                                                <p
                                                    class="text-xs text-[#424752] mt-0.5">
                                                    Đơn giá:
                                                    <fmt:formatNumber
                                                        value="${item.unitPrice}"
                                                        type="number"
                                                        groupingUsed="true" />đ
                                                </p>
                                            </div>
                                            <p
                                                class="font-bold text-[#004d99] text-base">
                                                <fmt:formatNumber
                                                    value="${item.subtotal}"
                                                    type="number"
                                                    groupingUsed="true" />đ
                                            </p>
                                        </div>
                                        <div
                                            class="mt-3 flex items-center gap-3 text-xs">
                                            <a href="${pageContext.request.contextPath}/products?id=${item.bookID}"
                                               class="text-[#004d99] font-semibold hover:underline">Xem
                                                chi tiết</a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </section>
                </div>

                <div class="lg:col-span-4 space-y-6">

                    <section
                        class="bg-white p-5 rounded-xl border border-[#c2c6d4] shadow-sm">
                        <div class="flex justify-between items-center mb-4">
                            <h2
                                class="text-xs font-bold uppercase tracking-wider text-[#424752]">
                                Địa chỉ nhận hàng</h2>
                            <span
                                class="material-symbols-outlined text-[#004d99] text-[20px]">location_on</span>
                        </div>
                        <div class="space-y-1 text-sm">
                            <p class="font-bold text-[#071e27]">
                                ${sessionScope.account.fullname}</p>
                            <p class="text-xs text-[#424752]">${sessionScope.account.phone}
                            </p>
                            <p class="text-xs text-[#424752] leading-relaxed">
                                ${order.street}, ${order.district}, ${order.city}
                            </p>
                        </div>
                    </section>

                    <section
                        class="bg-white p-5 rounded-xl border border-[#c2c6d4] shadow-sm">
                        <div class="flex justify-between items-center mb-4">
                            <h2
                                class="text-xs font-bold uppercase tracking-wider text-[#424752]">
                                Thanh toán</h2>
                            <span
                                class="material-symbols-outlined text-[#004d99] text-[20px]">payments</span>
                        </div>

                        <div
                            class="flex items-center gap-3 mb-5 p-3 bg-[#e6f6ff] rounded-lg border border-[#c2c6d4]">
                            <div
                                class="bg-white px-1.5 py-0.5 rounded border border-gray-200 shadow-sm flex items-center justify-center">
                                <span
                                    class="material-symbols-outlined text-[16px] text-[#424752]">
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'cod'}">
                                            payments</c:when>
                                        <c:otherwise>credit_card</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div>
                                <p class="text-xs font-bold text-[#071e27]">
                                    <c:choose>
                                        <c:when test="${order.paymentMethod == 'cod'}">Thanh
                                            toán khi nhận hàng (COD)</c:when>
                                        <c:otherwise>Chuyển khoản Ngân hàng (VNPAY)</c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="text-[11px] text-[#424752] mt-0.5">
                                    <c:choose>
                                        <c:when test="${order.paymentStatus == 'paid'}">Đã
                                            thanh toán</c:when>
                                        <c:when test="${order.paymentStatus == 'refunded'}">
                                            Đã hoàn tiền</c:when>
                                        <c:otherwise>Chưa thanh toán</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>

                        <div class="space-y-2.5 text-xs">
                            <div
                                class="pt-3 border-t border-[#c2c6d4] flex justify-between items-baseline">
                                <span class="text-sm font-bold text-[#071e27]">Tổng thanh
                                    toán</span>
                                <span class="text-lg font-bold text-[#004d99]">
                                    <fmt:formatNumber value="${order.totalPrice}"
                                                      type="number" groupingUsed="true" />đ
                                </span>
                            </div>
                        </div>
                    </section>
                </div>
            </div>
        </main>

        <!-- Confirmation Modal -->
        <div id="confirmModal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-[9999]">
            <div class="bg-white w-[450px] rounded-xl p-6 relative">
                <button type="button" class="absolute top-3 right-4 text-2xl hover:text-gray-500 close-confirm">×</button>

                <h3 class="text-xl font-bold mb-4" id="confirmTitle">Xác nhận hành động</h3>
                <p class="text-gray-600 mb-6" id="confirmMessage">Bạn chắc chắn muốn thực hiện hành động này?</p>

                <div class="flex justify-end gap-3">
                    <button type="button" class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100 close-confirm">
                        Hủy
                    </button>
                    <button type="button" id="confirmAction" class="px-4 py-2 bg-[#004d99] text-white rounded-lg hover:opacity-90">
                        Xác nhận
                    </button>
                </div>
            </div>
        </div>

        <script>
            (function() {
                var confirmModal = null;
                var pendingAction = null;

                function initConfirmModal() {
                    confirmModal = document.getElementById('confirmModal');
                    document.querySelectorAll('.close-confirm').forEach(function(btn) {
                        btn.addEventListener('click', closeConfirmModal);
                    });

                    if (confirmModal) {
                        confirmModal.addEventListener('click', function (e) {
                            if (e.target === confirmModal) {
                                closeConfirmModal();
                            }
                        });
                    }

                    var confirmActionBtn = document.getElementById('confirmAction');
                    if (confirmActionBtn) {
                        confirmActionBtn.addEventListener('click', executeAction);
                    }
                }

                window.openConfirmModal = function(title, message, action) {
                    document.getElementById('confirmTitle').textContent = title;
                    document.getElementById('confirmMessage').textContent = message;
                    pendingAction = action;

                    if (confirmModal) {
                        confirmModal.classList.remove('hidden');
                        confirmModal.classList.add('flex');
                    }
                };

                function closeConfirmModal() {
                    if (confirmModal) {
                        confirmModal.classList.add('hidden');
                        confirmModal.classList.remove('flex');
                    }
                    pendingAction = null;
                }

                function executeAction() {
                    if (pendingAction) {
                        pendingAction();
                        closeConfirmModal();
                    }
                }

                if (document.readyState === 'loading') {
                    document.addEventListener('DOMContentLoaded', initConfirmModal);
                } else {
                    initConfirmModal();
                }
            })();

            function confirmCancelOrder() {
                openConfirmModal(
                    'Hủy đơn hàng',
                    'Bạn có chắc chắn muốn hủy đơn hàng này không?',
                    function() {
                        document.getElementById('cancelOrderForm').submit();
                    }
                );
            }
        </script>
    </body>

</html>
<%@ include file="/views/layout/homepage/footer.jsp" %>