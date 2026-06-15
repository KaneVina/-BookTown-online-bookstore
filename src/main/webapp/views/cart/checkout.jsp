<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>
<body class="bg-background-alt text-on-background font-body-md min-h-screen">
    <main class="max-w-[1280px] mx-auto px-4 md:px-16 py-12 min-h-[716px] text-[#071e27]">
        <h1 class="text-[20px] font-bold mb-stack-md text-primary pl-3 border-l-4 border-secondary">
            THANH TOÁN AN TOÀN
        </h1>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-gutter items-start">

            <div class="lg:col-span-8 space-y-6">

                <section class="bg-surface rounded-xl style-card border border-outline-variant overflow-hidden">
                    <div class="p-6 border-b border-surface-container flex items-center justify-between">
                        <h2 class="text-[16px] font-bold text-primary flex items-center gap-2">
                            <i data-lucide="shopping-bag"></i>
                            Kiểm tra đơn hàng
                        </h2>
                        <a href="${pageContext.request.contextPath}/cart"
                           class="text-[13px] text-primary hover:underline font-medium">
                            ← Quay lại giỏ hàng
                        </a>
                    </div>

                    <div class="divide-y divide-surface-container">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="p-6 flex flex-col sm:flex-row gap-6 hover:bg-surface-variant/20 transition-colors">

                                <div class="w-24 h-36 bg-surface-container-low flex-shrink-0 rounded-lg overflow-hidden border border-outline-variant">
                                    <c:choose>
                                        <c:when test="${not empty item.thumbnail}">
                                            <img class="w-full h-full object-cover"
                                                 src="${item.thumbnail}"
                                                 alt="${item.title}"/>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-full h-full flex items-center justify-center text-on-surface-variant">
                                                <i data-lucide="book-open"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="flex-grow">
                                    <div class="flex justify-between items-start">
                                        <div>
                                            <h3 class="text-[15px] font-bold text-on-surface mb-1">
                                                ${item.title}
                                            </h3>
                                            <p class="text-[13px] text-on-surface-variant">
                                                ${item.authorsDisplay}
                                            </p>
                                            <div class="mt-4">
                                                <span class="text-[13px] text-on-surface-variant">
                                                    Số lượng: <strong>${item.quantity}</strong>
                                                </span>
                                            </div>

                                        </div>
                                        <span class="text-[17px] font-bold text-primary whitespace-nowrap">
                                            <fmt:formatNumber value="${item.subtotal}" type="number" groupingUsed="true"/> đ
                                        </span>
                                    </div>
                                    <p class="text-[16px] text-on-surface-variant mt-1">
                                        Đơn giá:
                                        <strong> <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> đ</strong>
                                    </p>
                                </div>

                            </div>
                        </c:forEach>
                    </div>
                </section>

                <section class="bg-surface rounded-xl style-card border border-outline-variant p-6">
                    <div class="flex items-center gap-2 mb-6">
                        <h2 class="text-[16px] font-bold text-primary flex items-center gap-2">
                            <i data-lucide="truck"></i> Địa chỉ giao hàng
                        </h2>
                    </div>
                    <%-- Họ tên và SĐT lấy từ account, hiển thị sẵn để xác nhận --%>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-[13px] font-medium text-on-surface-variant mb-1">
                                Họ và tên <span class="text-error">*</span>
                            </label>
                            <input type="text" name="fullname" form="checkout-form"
                                   value="${sessionScope.account.fullname}"
                                   required
                                   class="w-full border border-outline-variant rounded-lg px-4 py-2.5
                                          focus:outline-none focus:border-primary text-[14px]"/>
                        </div>
                        <div>
                            <label class="block text-[13px] font-medium text-on-surface-variant mb-1">
                                Số điện thoại <span class="text-error">*</span>
                            </label>
                            <input type="text" name="phone" form="checkout-form"
                                   value="${sessionScope.account.phone}"
                                   required
                                   placeholder="VD: 0901234567"
                                   class="w-full border border-outline-variant rounded-lg px-4 py-2.5
                                          focus:outline-none focus:border-primary text-[14px]"/>
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-[13px] font-medium text-on-surface-variant mb-1">
                                Số nhà, tên đường <span class="text-error">*</span>
                            </label>
                            <input type="text" name="street" form="checkout-form"
                                   placeholder="VD: 600 Nguyễn Văn Cừ"
                                   required
                                   class="w-full border border-outline-variant rounded-lg px-4 py-2.5
                                          focus:outline-none focus:border-primary text-[14px]"/>
                        </div>
                        <div>
                            <label class="block text-[13px] font-medium text-on-surface-variant mb-1">
                                Quận / Huyện <span class="text-error">*</span>
                            </label>
                            <input type="text" name="district" form="checkout-form"
                                   placeholder="VD: Ninh Kiều"
                                   required
                                   class="w-full border border-outline-variant rounded-lg px-4 py-2.5
                                          focus:outline-none focus:border-primary text-[14px]"/>
                        </div>
                        <div>
                            <label class="block text-[13px] font-medium text-on-surface-variant mb-1">
                                Tỉnh / Thành phố <span class="text-error">*</span>
                            </label>
                            <input type="text" name="city" form="checkout-form"
                                   placeholder="VD: Cần Thơ"
                                   required
                                   class="w-full border border-outline-variant rounded-lg px-4 py-2.5
                                          focus:outline-none focus:border-primary text-[14px]"/>
                        </div>
                    </div>
                </section>

                <section class="bg-surface rounded-xl style-card border border-outline-variant p-6">
                    <h2 class="text-[16px] font-bold text-primary flex items-center gap-2 mb-6">
                        <i data-lucide="wallet-cards"></i> Phương thức thanh toán
                    </h2>
                    <div class="space-y-3" id="paymentGroup">
                        <label class="payment-card flex items-center justify-between p-4 border border-outline-variant rounded-[10px] cursor-pointer hover:bg-surface-variant/20 transition-all">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 rounded-full bg-surface-container flex items-center justify-center text-on-surface-variant">
                                    <i data-lucide="credit-card"></i>
                                </div>
                                <div>
                                    <p class="text-[14px] font-bold text-on-surface-variant">VNPAY</p>
                                    <p class="text-[12px] text-on-surface-variant">Thanh toán điện tử nhanh</p>
                                </div>
                            </div>
                            <input class="text-primary focus:ring-primary h-5 w-5" name="payment_method" form="checkout-form" type="radio" value="vnpay"/>
                        </label>
                        <label class="payment-card flex items-center justify-between p-4 border-2 border-primary bg-primary/5 rounded-[10px] cursor-pointer transition-all">
                            <div class="flex items-center gap-4">
                                <div class="w-10 h-10 rounded-full bg-white border border-primary/20 flex items-center justify-center text-primary">
                                    <i data-lucide="banknote"></i>
                                </div>
                                <div>
                                    <p class="text-[14px] font-bold">Cash on Delivery (COD)</p>
                                    <p class="text-[12px] text-on-surface-variant">Thanh toán khi nhận hàng</p>
                                </div>
                            </div>
                            <input checked="checked" class="text-primary focus:ring-primary h-5 w-5" name="payment_method" form="checkout-form" type="radio" value="cod"/>
                        </label>
                    </div>
                </section>

            </div>

            <aside class="lg:col-span-4 sticky top-6">
                <div class="bg-surface rounded-xl style-card border border-outline-variant p-6">
                    <h2 class="text-[16px] font-black text-primary uppercase border-l-4 border-secondary pl-3 mb-6">
                        Tóm tắt đơn hàng
                    </h2>

                    <div class="space-y-3 mb-6">
                        <div class="flex justify-between text-[14px]">
                            <span class="text-on-surface-variant">
                                Tạm tính (${totalQuantity} sản phẩm)
                            </span>
                            <span class="font-bold">
                                <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> đ
                            </span>
                        </div>
                        <div class="flex justify-between text-[14px] text-green-600">
                            <span>Giảm giá voucher</span>
                            <span id="discountDisplay" class="font-bold">- 0 đ</span>
                        </div>
                        <div class="pt-4 border-t border-surface-container flex justify-between items-end">
                            <span class="text-[15px] font-bold text-primary">Tổng cộng</span>
                            <span class="text-[22px] font-black text-primary">
                                <fmt:formatNumber value="${total}" type="number" groupingUsed="true"/> đ
                            </span>
                        </div>
                    </div>
                    <form id="checkout-form"
                          action="${pageContext.request.contextPath}/checkout"
                          method="POST">
                        <button type="submit"
                                class="w-full bg-secondary text-primary py-3.5 rounded-full font-black text-[15px]
                                       shadow-sm hover:scale-[1.02] active:scale-[0.98] transition-all
                                       flex items-center justify-center gap-2 uppercase tracking-wide">
                            ĐẶT HÀNG NGAY
                        </button>
                    </form>

                    <p class="text-center text-[12px] text-on-surface-variant leading-relaxed mt-3">
                        Bằng việc nhấn vào nút "Đặt hàng ngay", bạn đã đồng ý với
                        <a class="text-primary underline font-medium" href="#">Điều khoản dịch vụ</a> của BookTown.
                    </p>

                    <div class="mt-8 pt-6 border-t border-surface-container grid grid-cols-3 gap-4">
                        <div class="flex flex-col items-center gap-1.5 text-center">
                            <i data-lucide="shield-check" class="text-primary"></i>
                            <span class="text-[10px] font-black text-primary uppercase">BẢO MẬT</span>
                        </div>
                        <div class="flex flex-col items-center gap-1.5 text-center">
                            <i data-lucide="truck" class="text-primary"></i>
                            <span class="text-[10px] font-black text-primary uppercase">THEO DÕI</span>
                        </div>
                        <div class="flex flex-col items-center gap-1.5 text-center">
                            <i data-lucide="refresh-cw" class="text-primary"></i>
                            <span class="text-[10px] font-black text-primary uppercase">ĐỔI TRẢ 30 NGÀY</span>
                        </div>
                    </div>
                </div>
            </aside>

        </div>
    </main>

    <script>
        document.querySelectorAll('#paymentGroup input[type="radio"]').forEach(function (radio) {
            radio.addEventListener('change', function () {
                document.querySelectorAll('.payment-card').forEach(function (card) {
                    card.classList.remove('border-2', 'border-primary', 'bg-primary/5');
                    card.classList.add('border', 'border-outline-variant');
                });
                var selected = this.closest('.payment-card');
                selected.classList.remove('border', 'border-outline-variant');
                selected.classList.add('border-2', 'border-primary', 'bg-primary/5');
            });
        });

        treet/district/city) phải >= 3 ký tự và có ít nhất 1 chữ cái
        var checkoutForm = document.getElementById('checkout-form');
        if (checkoutForm) {
            checkoutForm.addEventListener('submit', function (e) {
                var fields = [
                    {name: 'street',   label: 'Số nhà, tên đường'},
                    {name: 'district', label: 'Quận / Huyện'},
                    {name: 'city',     label: 'Tỉnh / Thành phố'}
                ];
                var letterRegex = /[a-zA-ZÀ-ỹ]/;

                for (var i = 0; i < fields.length; i++) {
                    var input = checkoutForm.elements[fields[i].name];
                    var value = input.value.trim();

                    if (value.length < 3 || !letterRegex.test(value)) {
                        e.preventDefault();
                        showToast(fields[i].label + ' không hợp lệ, vui lòng nhập lại!', true);
                        input.focus();
                        return false;
                    }
                }
            });
        }
    </script>
</body>
<%@ include file="/views/layout/homepage/footer.jsp" %>
