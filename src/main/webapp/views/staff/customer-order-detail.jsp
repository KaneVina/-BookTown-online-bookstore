<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Chi tiết đơn hàng - BookTown</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link
            href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap"
            rel="stylesheet">
        <style>
            body {
                font-family: 'Inter', system-ui, sans-serif;
                background-color: #f3faff;
            }

            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }

            .stepper-line::before {
                content: '';
                position: absolute;
                left: 15px;
                top: 24px;
                bottom: 0;
                width: 2px;
                background-color: #c2c6d4;
            }

            .stepper-line:last-child::before {
                display: none;
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

    <body class="bg-[#f3faff] text-[#071e27] min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <main class="md:ml-64 min-h-screen">
            <div class="p-6 max-w-[1280px] mx-auto space-y-6">

                <div class="mb-4">
                    <a href="${pageContext.request.contextPath}/dashboard/customer-order"
                       class="flex items-center gap-2 text-[#004d99] font-bold text-sm hover:underline">
                        <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                        Quay lại danh sách
                    </a>
                </div>

                <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                    <div>
                        <div class="flex items-center gap-3">
                            <h1 class="text-3xl font-bold text-[#071e27]">Đơn hàng #${order.orderCode}</h1>

                            <span
                                class="px-3 py-1 rounded-full text-sm font-semibold
                                <c:choose>
                                    <c:when test="${order.status == 'pending'}">bg-[#fff3cd] text-[#e65c00]</c:when>
                                    <c:when test="${order.status == 'confirmed'}">bg-[#dbeafe] text-[#004d99]</c:when>
                                    <c:when test="${order.status == 'shipping'}">bg-[#e0e7ff] text-[#134aa4]</c:when>
                                    <c:when test="${order.status == 'completed'}">bg-[#d4edda] text-[#2E7D32]</c:when>
                                    <c:otherwise>bg-[#ffdad6] text-[#D32F2F]</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${order.status == 'pending'}">Chờ xác nhận</c:when>
                                    <c:when test="${order.status == 'confirmed'}">Xác nhận</c:when>
                                    <c:when test="${order.status == 'shipping'}">Giao hàng</c:when>
                                    <c:when test="${order.status == 'completed'}">Hoàn thành</c:when>
                                    <c:otherwise>Hủy đơn</c:otherwise>
                                </c:choose>
                            </span>

                            <%-- Tag hoàn tiền: chỉ hiện khi VNPAY đã hủy --%>
                            <c:if test="${order.status == 'cancelled' && order.paymentMethod == 'vnpay'}">
                                <c:choose>
                                    <c:when test="${order.paymentStatus == 'pending_refund'}">
                                        <span class="px-3 py-1 rounded-full text-sm font-semibold flex items-center gap-1 bg-amber-50 text-amber-600 border border-amber-200">
                                            <span class="material-symbols-outlined text-[14px]">schedule</span>
                                            Đang hoàn tiền
                                        </span>
                                    </c:when>
                                    <c:when test="${order.paymentStatus == 'refunded'}">
                                        <span class="px-3 py-1 rounded-full text-sm font-semibold flex items-center gap-1 bg-green-50 text-green-700 border border-green-200">
                                            <span class="material-symbols-outlined text-[14px]" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                            Đã hoàn tiền
                                        </span>
                                    </c:when>
                                </c:choose>
                            </c:if>
                        </div>
                    </div>

                    <c:if test="${order.status != 'completed' && order.status != 'cancelled'}">
                        <div class="flex items-center gap-3">
                            <form action="${pageContext.request.contextPath}/dashboard/customer-order"
                                  method="POST" class="m-0 inline-block" id="statusForm">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="orderID" value="${order.orderID}">
                                <input type="hidden" name="redirect" value="detail">
                                <c:choose>
                                    <c:when test="${order.status == 'pending'}">
                                        <input type="hidden" name="status" value="confirmed">
                                        <button type="button" onclick="confirmActionDetail('Xác nhận đơn hàng', 'Bạn có chắc chắn muốn xác nhận đơn hàng này không?', 'statusForm')"
                                                class="flex items-center gap-2 px-4 py-2 bg-[#004d99] text-white rounded-lg text-sm font-semibold hover:opacity-90 shadow-sm transition-all">
                                            <span
                                                class="material-symbols-outlined text-[20px]">task_alt</span>
                                            Xác nhận đơn
                                        </button>
                                    </c:when>
                                    <c:when test="${order.status == 'confirmed'}">
                                        <input type="hidden" name="status" value="shipping">
                                        <button type="button" onclick="confirmActionDetail('Giao hàng', 'Bạn có chắc chắn muốn bắt đầu giao đơn hàng này không?', 'statusForm')"
                                                class="flex items-center gap-2 px-4 py-2 bg-[#134aa4] text-white rounded-lg text-sm font-semibold hover:opacity-90 shadow-sm transition-all">
                                            <span
                                                class="material-symbols-outlined text-[20px]">local_shipping</span>
                                            Giao hàng
                                        </button>
                                    </c:when>
                                    <c:when test="${order.status == 'shipping'}">
                                        <input type="hidden" name="status" value="completed">
                                        <button type="button" onclick="confirmActionDetail('Hoàn tất đơn', 'Bạn có chắc chắn muốn hoàn tất đơn hàng này không?', 'statusForm')"
                                                class="flex items-center gap-2 px-4 py-2 bg-[#2E7D32] text-white rounded-lg text-sm font-semibold hover:opacity-90 shadow-sm transition-all">
                                            <span
                                                class="material-symbols-outlined text-[20px]">check_circle</span>
                                            Hoàn tất đơn
                                        </button>
                                    </c:when>
                                </c:choose>
                            </form>

                            <form action="${pageContext.request.contextPath}/dashboard/customer-order"
                                  method="POST" class="m-0 inline-block" id="cancelForm">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="orderID" value="${order.orderID}">
                                <input type="hidden" name="redirect" value="detail">
                                <input type="hidden" name="status" value="cancelled">
                                <button type="button"
                                        onclick="confirmActionDetail('Hủy đơn hàng', 'Bạn có chắc muốn hủy đơn hàng này không?', 'cancelForm')"
                                        class="flex items-center gap-2 px-4 py-2 bg-[#D32F2F] text-white rounded-lg text-sm font-semibold hover:opacity-90 shadow-sm transition-all">
                                    <span class="material-symbols-outlined text-[20px]">cancel</span>
                                    Hủy đơn hàng
                                </button>
                            </form>
                        </div>
                    </c:if>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

                    <div class="lg:col-span-2 space-y-6">

                        <div class="bg-white rounded-xl shadow-sm overflow-hidden border border-[#c2c6d4]">
                            <div
                                class="p-6 border-b border-[#c2c6d4] bg-[#f3faff] flex justify-between items-center">
                                <h2 class="text-xl font-semibold text-[#071e27]">Danh sách sản phẩm</h2>
                                <span class="text-[#424752] text-sm">${orderDetails.size()} sản phẩm</span>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full text-left">
                                    <thead class="bg-[#F5F7F9]">
                                        <tr>
                                            <th class="px-6 py-4 text-sm font-semibold text-[#424752]">Sản
                                                phẩm</th>
                                            <th class="px-6 py-4 text-sm font-semibold text-[#424752]">Giá
                                            </th>
                                            <th class="px-6 py-4 text-sm font-semibold text-[#424752]">Số
                                                lượng</th>
                                            <th
                                                class="px-6 py-4 text-sm font-semibold text-[#424752] text-right">
                                                Tổng</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-[#c2c6d4]">
                                        <c:forEach var="item" items="${orderDetails}">
                                            <tr class="hover:bg-[#e6f6ff] transition-colors">
                                                <td class="px-6 py-4">
                                                    <div class="flex items-center gap-4">
                                                        <c:choose>
                                                            <c:when test="${not empty item.thumbnail}">
                                                                <img alt="${item.title}"
                                                                     class="w-12 h-16 object-cover rounded-md shadow-sm"
                                                                     src="${item.thumbnail}">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div
                                                                    class="w-12 h-16 flex items-center justify-center bg-[#dbf1fe] rounded text-[#c2c6d4]">
                                                                    <span
                                                                        class="material-symbols-outlined text-[24px]">book</span>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <div>
                                                            <p class="text-sm font-semibold text-[#004d99]">
                                                                ${item.title}</p>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td class="px-6 py-4 text-base text-[#071e27]">
                                                    <fmt:formatNumber value="${item.unitPrice}"
                                                                      pattern="#,###" />₫
                                                </td>
                                                <td class="px-6 py-4 text-base text-[#071e27]">
                                                    ${item.quantity}</td>
                                                <td
                                                    class="px-6 py-4 text-base text-right font-bold text-[#071e27]">
                                                    <fmt:formatNumber value="${item.subtotal}"
                                                                      pattern="#,###" />₫
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>

                            <div class="p-6 bg-[#f3faff] border-t border-[#c2c6d4]">
                                <div class="flex flex-col items-end gap-2">
                                    <div class="flex justify-between w-64">
                                        <span class="text-xl font-semibold text-[#071e27]">Tổng
                                            cộng:</span>
                                        <span class="text-xl font-semibold text-[#004d99]">
                                            <fmt:formatNumber value="${order.totalPrice}" pattern="#,###" />
                                            ₫
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="bg-white p-6 rounded-xl shadow-sm border border-[#c2c6d4]">
                                <div class="flex items-center gap-2 mb-4">
                                    <span class="material-symbols-outlined text-[#004d99]">payments</span>
                                    <h3
                                        class="text-sm font-semibold text-[#071e27] uppercase tracking-wider">
                                        Trạng thái thanh toán</h3>
                                </div>
                                <div class="space-y-3">
                                    <div class="flex justify-between items-center">
                                        <span class="text-sm text-[#424752]">Phương thức:</span>
                                        <span class="text-sm font-semibold text-[#071e27]">
                                            <c:choose>
                                                <c:when test="${order.paymentMethod == 'cod'}">Thanh toán
                                                    khi nhận hàng (COD)</c:when>
                                                <c:otherwise>Chuyển khoản Ngân hàng (VNPAY)</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                    <div class="flex justify-between items-center">
                                        <span class="text-sm text-[#424752]">Trạng thái:</span>
                                        <c:choose>
                                            <c:when test="${order.paymentStatus == 'paid'}">
                                                <span
                                                    class="px-3 py-1 bg-green-100 text-[#2E7D32] rounded-full text-xs font-semibold">
                                                    Đã thanh toán
                                                </span>
                                            </c:when>
                                            <c:when test="${order.paymentStatus == 'pending_refund'}">
                                                <span
                                                    class="px-3 py-1 bg-amber-100 text-amber-700 rounded-full text-xs font-semibold">
                                                    Chờ hoàn tiền
                                                </span>
                                            </c:when>
                                            <c:when test="${order.paymentStatus == 'refunded'}">
                                                <span
                                                    class="px-3 py-1 bg-blue-100 text-[#134aa4] rounded-full text-xs font-semibold">
                                                    Đã hoàn tiền
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span
                                                    class="px-3 py-1 bg-amber-100 text-[#FFA000] rounded-full text-xs font-semibold">
                                                    Chưa thanh toán
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>

                            <div class="bg-white p-6 rounded-xl shadow-sm border border-[#c2c6d4]">
                                <div class="flex items-center gap-2 mb-4">
                                    <span
                                        class="material-symbols-outlined text-[#004d99]">local_shipping</span>
                                    <h3
                                        class="text-sm font-semibold text-[#071e27] uppercase tracking-wider">
                                        Vận chuyển</h3>
                                </div>
                                <div class="space-y-3">
                                    <div class="flex justify-between items-center">
                                        <span class="text-sm text-[#424752]">Dự kiến giao:</span>
                                        <span class="text-sm text-[#071e27]">1 - 3 ngày kể từ ngày
                                            xác nhận</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="space-y-6">

                        <div class="bg-white p-6 rounded-xl shadow-sm border border-[#c2c6d4]">
                            <h3 class="text-xl font-semibold text-[#071e27] mb-6">Khách hàng</h3>
                            <div class="mb-6">
                                <p class="text-sm font-semibold text-[#071e27]">${order.customerName}</p>
                            </div>
                            <div class="space-y-4">
                                <div class="flex items-start gap-3">
                                    <span
                                        class="material-symbols-outlined text-[#727783] text-[20px]">mail</span>
                                    <div>
                                        <p class="text-xs text-[#424752]">Email</p>
                                        <p class="text-sm text-[#004d99]">${order.customerEmail}</p>
                                    </div>
                                </div>
                                <div class="flex items-start gap-3">
                                    <span
                                        class="material-symbols-outlined text-[#727783] text-[20px]">phone</span>
                                    <div>
                                        <p class="text-xs text-[#424752]">Số điện thoại</p>
                                        <p class="text-sm text-[#071e27]">${order.customerPhone}</p>
                                    </div>
                                </div>
                                <div class="flex items-start gap-3">
                                    <span
                                        class="material-symbols-outlined text-[#727783] text-[20px]">location_on</span>
                                    <div>
                                        <p class="text-xs text-[#424752]">Địa chỉ giao hàng</p>
                                        <p class="text-sm text-[#071e27] leading-relaxed">
                                            ${order.street}, ${order.district},<br>${order.city}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="bg-white p-6 rounded-xl shadow-sm border border-[#c2c6d4]">
                            <h3 class="text-xl font-semibold text-[#071e27] mb-6">Tiến trình đơn hàng</h3>
                            <div class="space-y-6">


                                <c:set var="currentStep" value="0" />
                                <c:if test="${order.status == 'pending'}"><c:set var="currentStep" value="1" /></c:if>
                                <c:if test="${order.status == 'confirmed'}"><c:set var="currentStep" value="2" /></c:if>
                                <c:if test="${order.status == 'shipping'}"><c:set var="currentStep" value="3" /></c:if>
                                <c:if test="${order.status == 'completed'}"><c:set var="currentStep" value="4" /></c:if>

                                <c:choose>
                                    <c:when test="${order.status == 'cancelled'}">
                                        <c:choose>
                                            <%-- VNPAY đang chờ hoàn tiền --%>
                                            <c:when test="${order.paymentMethod == 'vnpay' && order.paymentStatus == 'pending_refund'}">
                                                <div class="space-y-3">
                                                    <div class="flex items-center gap-3 p-4 bg-amber-50 rounded-lg border border-amber-200">
                                                        <span class="material-symbols-outlined text-amber-500 text-[22px]" style="font-variation-settings: 'FILL' 1;">schedule</span>
                                                        <div class="flex-1">
                                                            <p class="text-sm font-semibold text-amber-700">Đơn hàng đã hủy &mdash; Hoàn tiền đang xử lý</p>
                                                            <p class="text-xs text-amber-600 mt-0.5">VNPAY — Chưa xác nhận chuyển tiền</p>
                                                        </div>
                                                    </div>
                                                    <%-- Nút xác nhận hoàn tiền --%>
                                                    <form action="${pageContext.request.contextPath}/dashboard/customer-order"
                                                          method="POST" id="confirmRefundForm">
                                                        <input type="hidden" name="action" value="confirmRefund">
                                                        <input type="hidden" name="orderID" value="${order.orderID}">
                                                        <button type="button"
                                                                onclick="confirmActionDetail('Xác nhận đã hoàn tiền', 'Bạn xác nhận đã chuyển tiền hoàn cho khách thành công? Hệ thống sẽ gửi email thông báo cho khách.', 'confirmRefundForm')"
                                                                class="w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-green-600 text-white rounded-lg text-sm font-semibold hover:bg-green-700 shadow-sm transition-all">
                                                            <span class="material-symbols-outlined text-[18px]">payments</span>
                                                            Xác nhận đã hoàn tiền
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:when>
                                            <%-- VNPAY đã hoàn tiền xong --%>
                                            <c:when test="${order.paymentMethod == 'vnpay' && order.paymentStatus == 'refunded'}">
                                                <div class="flex items-center gap-3 p-4 bg-green-50 rounded-lg border border-green-200">
                                                    <span class="material-symbols-outlined text-green-600 text-[22px]" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                                    <div>
                                                        <p class="text-sm font-semibold text-green-700">Đơn hàng đã hủy &mdash; Đã hoàn tiền</p>
                                                        <p class="text-xs text-green-600 mt-0.5">VNPAY — Đã xác nhận chuyển tiền thành công</p>
                                                    </div>
                                                </div>
                                            </c:when>
                                            <%-- Mặc định (COD hoặc không có tiền hoàn) --%>
                                            <c:otherwise>
                                                <div class="flex items-center gap-3 p-4 bg-red-50 rounded-lg border border-red-200">
                                                    <span class="material-symbols-outlined text-[#D32F2F] text-[22px]">cancel</span>
                                                    <p class="text-sm font-semibold text-[#D32F2F]">Đơn hàng đã bị hủy</p>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="relative pl-8 stepper-line">
                                            <div class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                                <div class="w-3 h-3 rounded-full ${currentStep >= 4 ? 'bg-[#2E7D32]' : 'bg-[#c2c6d4]'}"></div>
                                            </div>
                                            <p class="text-sm font-semibold ${currentStep >= 4 ? 'text-[#2E7D32]' : 'text-[#071e27]'}">Hoàn thành</p>
                                        </div>

                                        <div class="relative pl-8 stepper-line">
                                            <div class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                                <div class="w-3 h-3 rounded-full ${currentStep >= 3 ? 'bg-[#134aa4]' : 'bg-[#c2c6d4]'}"></div>
                                            </div>
                                            <p class="text-sm font-semibold ${currentStep >= 3 ? 'text-[#134aa4]' : 'text-[#071e27]'}">Đang giao hàng</p>
                                        </div>

                                        <div class="relative pl-8 stepper-line">
                                            <div class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                                <div class="w-3 h-3 rounded-full ${currentStep >= 2 ? 'bg-[#004d99]' : 'bg-[#c2c6d4]'}"></div>
                                            </div>
                                            <p class="text-sm font-semibold ${currentStep >= 2 ? 'text-[#004d99]' : 'text-[#071e27]'}">Xác nhận</p>
                                        </div>

                                        <div class="relative pl-8 stepper-line">
                                            <div class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                                <div class="w-3 h-3 rounded-full ${currentStep >= 1 ? 'bg-[#FFA000]' : 'bg-[#c2c6d4]'}"></div>
                                            </div>
                                            <p class="text-sm font-semibold ${currentStep >= 1 ? 'text-[#FFA000]' : 'text-[#071e27]'}">Chờ xác nhận</p>
                                            <p class="text-sm text-[#424752]">
                                                <fmt:formatDate value="${order.createdAt}" pattern="HH:mm - dd/MM/yyyy" />
                                            </p>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <%@ include file="/views/layout/common/toast.jsp" %>

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
                    <button type="button" id="confirmAction" class="px-4 py-2 bg-[#004d99] text-white rounded-lg hover:opacity-90">
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

            function confirmActionDetail(title, message, formId) {
                openConfirmModal(title, message, function () {
                    document.getElementById(formId).submit();
                });
            }

            document.addEventListener('DOMContentLoaded', function () {
                initConfirmModal();
            });
        </script>
    </body>

</html>