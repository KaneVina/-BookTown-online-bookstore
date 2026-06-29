<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/views/layout/homepage/header.jsp" %>

<%@ include file="/views/layout/common/toast.jsp" %>

<body class="text-on-background">
<main class="max-w-[1280px] mx-auto px-4 md:px-16 py-12 min-h-[716px] text-[#071e27]">

    <h1 class="text-3xl font-extrabold mb-12 text-[#071e27]">Giỏ hàng của bạn</h1>

    <div class="grid grid-cols-12 gap-6">

        <div class="col-span-12 lg:col-span-8 space-y-6" id="cart-list">

            <c:choose>

                <c:when test="${empty cartItems}">
                    <div class="flex flex-col items-center justify-center py-20 space-y-6">
                        <i data-lucide="shopping-cart" class="w-16 h-16 text-[#c2c6d4]"></i>
                        <p class="text-2xl text-[#424752]">Giỏ hàng của bạn đang trống</p>
                        <a href="${pageContext.request.contextPath}/home"
                           class="bg-[#1565c0] text-white px-8 py-3 rounded-xl font-semibold hover:brightness-95 transition-all">
                            Tiếp tục mua sắm
                        </a>
                    </div>
                </c:when>

                <c:otherwise>
                    <c:forEach var="item" items="${cartItems}">
                        <div class="bg-white rounded-xl p-6 flex flex-col md:flex-row items-center gap-6
                                    transition-transform duration-200 ease-out hover:-translate-y-0.5"
                             id="cart-item-${item.cartItemID}"
                             style="box-shadow: 0 4px 20px rgba(21,101,192,0.08);">

                            <%-- Ảnh bìa sách --%>
                            <div class="w-24 h-36 flex-shrink-0 overflow-hidden rounded-lg bg-[#e6f6ff]">
                                <c:choose>
                                    <c:when test="${not empty item.thumbnail}">
                                        <img class="w-full h-full object-cover"
                                             src="${item.thumbnailFirst}"
                                             alt="${item.title}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-full h-full flex items-center justify-center text-[#c2c6d4]">
                                            <i data-lucide="book-open" class="w-10 h-10"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="flex-grow space-y-1">
                                <a href="${pageContext.request.contextPath}/products?id=${item.bookID}">
                                    <h3 class="text-xl font-bold text-[#004d99] hover:underline">${item.title}</h3>
                                </a>
                                <p class="text-sm text-[#424752]">Tác giả: ${item.authorsDisplay}</p>
                                <p class="text-base text-[#004d99] font-bold mt-2">
                                    <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> đ
                                </p>
                            </div>

                            <div class="flex flex-col items-center md:items-end gap-4">

                                <div class="flex items-center border border-[#c2c6d4] rounded-lg overflow-hidden bg-[#e6f6ff]">
                                    <button class="px-3 py-1 hover:bg-[#cfe6f2] transition-colors font-bold"
                                            onclick="updateQty(${item.cartItemID}, ${item.quantity - 1})">−</button>
                                    <span class="px-4 py-1 text-base border-x border-[#c2c6d4]"
                                          id="qty-${item.cartItemID}">${item.quantity}</span>
                                    <button class="px-3 py-1 hover:bg-[#cfe6f2] transition-colors font-bold"
                                            onclick="updateQty(${item.cartItemID}, ${item.quantity + 1})">+</button>
                                </div>

                                <div class="text-right">
                                    <p class="text-xs text-[#424752]">Tạm tính</p>
                                    <p class="text-xl font-bold text-[#004d99]"
                                       id="subtotal-item-${item.cartItemID}">
                                        <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/> đ
                                    </p>
                                </div>

                                <button class="text-[#D32F2F] hover:bg-[#ffdad6]/20 p-2 rounded-full transition-all duration-200"
                                        onclick="removeItem(${item.cartItemID})"
                                        title="Xóa khỏi giỏ hàng">
                                    <i data-lucide="trash-2" class="w-5 h-5"></i>
                                </button>

                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>

            </c:choose>
        </div>

        <c:if test="${not empty cartItems}">
        <div class="col-span-12 lg:col-span-4">
            <div class="bg-white rounded-xl p-8 sticky top-24 space-y-6"
                 style="box-shadow: 0 4px 20px rgba(21,101,192,0.08);">

                <h2 class="text-2xl font-bold text-[#071e27] border-b border-[#c2c6d4] pb-4">Tóm tắt đơn hàng</h2>

                <div class="space-y-4">
                    <div class="flex justify-between items-center text-base">
                        <span class="text-[#424752]">
                            Tạm tính (<span id="item-count">${totalQuantity}</span> sản phẩm)
                        </span>
                        <span class="font-semibold" id="summary-subtotal">
                            <fmt:formatNumber value="${subtotal}" type="number" groupingUsed="true"/> đ
                        </span>
                    </div>
                    <div class="flex justify-between items-center text-base text-[#2E7D32]">
                        <span class="font-medium">Giảm giá voucher</span>
                        <span class="font-semibold" id="voucher-discount">- 0 đ</span>
                    </div>
                </div>

                <div class="mb-6">
                        <div class="flex rounded-[4px] overflow-hidden border border-outline-variant">
                            <input id="voucherInput"
                                   class="flex-1 bg-surface-container-low border-none px-4 py-2 text-[14px] focus:ring-0"
                                   placeholder="Mã giảm giá" type="text"/>
                            <button onclick="applyVoucher()"
                                    class="bg-secondary text-primary px-4 font-bold text-[13px] hover:opacity-90">
                                Áp dụng
                            </button>
                        </div>
                        <p id="voucherMsg" class="mt-1 text-[12px] hidden"></p>
                    </div>

                <div class="border-t border-[#c2c6d4] pt-6">
                    <div class="flex justify-between items-end mb-8">
                        <span class="text-xl font-bold text-[#071e27]">Tổng cộng</span>
                        <p class="text-[#004d99] font-extrabold text-3xl" id="summary-total">
                            <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> đ
                        </p>
                    </div>

                    <div id="checkout-btn-wrap">
                        <c:if test="${not empty cartItems}">
                            <a href="${pageContext.request.contextPath}/checkout">
                                <button class="w-full bg-[#fdd835] hover:bg-[#e8c41d] text-[#705e00] py-4 rounded-xl
                                               font-bold text-xl shadow-md hover:shadow-lg transition-all duration-200
                                               flex items-center justify-center gap-3 active:scale-95">
                                   MUA HÀNG
                                </button>
                            </a>
                        </c:if>
                    </div>
                </div>

                <div class="pt-4 flex items-center gap-2 justify-center text-[#424752] text-xs opacity-60">
                    <i data-lucide="shield-check" class="w-4 h-4"></i>
                    Thanh toán an toàn &amp; bảo mật 100%
                </div>

            </div>
        </div>
        </c:if>

    </div>
</main>

<script>
    var CART_URL = '${pageContext.request.contextPath}/cart';

    function formatPrice(amount) {
        return Number(amount).toLocaleString('vi-VN') + ' đ';
    }

    function updateSummary(data) {
        document.getElementById('summary-subtotal').textContent = formatPrice(data.subtotal);
        document.getElementById('summary-total').textContent    = formatPrice(data.total);
        document.getElementById('item-count').textContent       = data.cartCount;

        var badge = document.getElementById('cart-count');
        if (badge) badge.textContent = data.cartCount;
    }

    function updateQty(cartItemID, newQty) {
        if (newQty < 1) {
            removeItem(cartItemID);
            return;
        }

        fetch(CART_URL, {
            method:  'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body:    'action=update&cartItemID=' + cartItemID + '&quantity=' + newQty
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (!data.ok) {
                showToast(data.message || 'Có lỗi xảy ra', true);
                return;
            }

            document.getElementById('qty-' + cartItemID).textContent = newQty;

            document.getElementById('subtotal-item-' + cartItemID).textContent
                = formatPrice(data.itemSubtotal);

            var card       = document.getElementById('cart-item-' + cartItemID);
            var buttons    = card.querySelectorAll('button');
            buttons[0].setAttribute('onclick', 'updateQty(' + cartItemID + ',' + (newQty - 1) + ')');
            buttons[1].setAttribute('onclick', 'updateQty(' + cartItemID + ',' + (newQty + 1) + ')');

            updateSummary(data);
            showToast('Đã cập nhật số lượng');
        })
        .catch(function(err) {
            console.error(err);
            showToast('Không kết nối được server', true);
        });
    }

    function removeItem(cartItemID) {
        if (!confirm('Bạn có chắc muốn xóa sản phẩm này?')) return;

        fetch(CART_URL, {
            method:  'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body:    'action=remove&cartItemID=' + cartItemID
        })
        .then(function(res) { return res.json(); })
        .then(function(data) {
            if (!data.ok) {
                showToast(data.message || 'Có lỗi xảy ra', true);
                return;
            }

            var row = document.getElementById('cart-item-' + cartItemID);
            if (row) row.remove();

            var remaining = document.querySelectorAll('[id^="cart-item-"]').length;
            if (remaining === 0) {
                document.getElementById('cart-list').innerHTML =
                    '<div class="flex flex-col items-center justify-center py-20 space-y-6">' +
                    '<i data-lucide="shopping-cart" class="w-16 h-16 text-[#c2c6d4]"></i>' +
                    '<p class="text-2xl text-[#424752]">Giỏ hàng của bạn đang trống</p>' +
                    '<a href="${pageContext.request.contextPath}/home" ' +
                    'class="bg-[#1565c0] text-white px-8 py-3 rounded-xl font-semibold">Tiếp tục mua sắm</a>' +
                    '</div>';
                var summaryCol = document.querySelector('.lg\\:col-span-4');
                if (summaryCol) summaryCol.style.display = 'none';
                if (typeof lucide !== 'undefined') lucide.createIcons();
            }

            updateSummary(data);
            showToast('Đã xóa sản phẩm khỏi giỏ hàng');
        })
        .catch(function(err) {
            console.error(err);
            showToast('Không kết nối được server', true);
        });
    }
</script>

</body>
<%@ include file="/views/layout/homepage/footer.jsp" %>
