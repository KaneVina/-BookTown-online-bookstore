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
                                            <img class="w-full h-full object-cover" src="${item.thumbnailFirst}" alt="${item.title}"/>
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
                                            <h3 class="text-[15px] font-bold text-on-surface mb-1">${item.title}</h3>
                                            <p class="text-[13px] text-on-surface-variant">${item.authorsDisplay}</p>
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
                                        <strong>
                                            <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/> đ
                                        </strong>
                                    </p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </section>

                <section class="bg-surface rounded-xl style-card border border-outline-variant p-6">
                    <div class="flex items-center justify-between mb-5">
                        <h2 class="text-[16px] font-bold text-primary flex items-center gap-2">
                            <i data-lucide="truck"></i>
                            Địa chỉ giao hàng
                        </h2>

                        <button type="button" id="btnShowAddressForm"
                                class="text-[12px] font-bold text-primary border border-primary rounded-full px-4 py-1.5 hover:bg-primary hover:text-white transition">
                            + Thêm mới
                        </button>
                    </div>

                    <div class="relative">
                        <div id="selectedAddressBox"
                             class="border-2 border-primary bg-primary/5 rounded-xl p-4 cursor-pointer flex items-center justify-between">
                            <div>
                                <p class="text-[14px] font-bold">
                                    <span id="selectedDefaultBadge"
                                          class="hidden text-[11px] bg-primary text-white px-2 py-1 rounded-full mr-2">
                                        Mặc định
                                    </span>
                                    <span id="selectedNamePhone">Chưa có địa chỉ</span>
                                </p>
                                <p id="selectedAddressText" class="text-[13px] text-on-surface-variant mt-1">
                                    Vui lòng thêm địa chỉ giao hàng trước khi thanh toán.
                                </p>
                            </div>

                            <button type="button" class="text-primary font-bold text-[13px] flex items-center gap-1">
                                Thay đổi <i data-lucide="chevron-down" class="w-4 h-4"></i>
                            </button>
                        </div>

                        <div id="addressDropdown"
                             class="hidden absolute left-0 right-0 mt-2 bg-white border border-outline-variant rounded-xl shadow-lg z-40 overflow-hidden">

                            <c:choose>
                                <c:when test="${not empty addressList}">
                                    <c:forEach var="address" items="${addressList}">
                                        <c:set var="displayRecipientName"
                                               value="${not empty address.recipientName ? address.recipientName : sessionScope.account.fullname}"/>
                                        <c:set var="displayRecipientPhone"
                                               value="${not empty address.recipientPhone ? address.recipientPhone : sessionScope.account.phone}"/>

                                        <div class="address-option p-4 cursor-pointer hover:bg-primary/5 border-b"
                                             data-id="${address.addressID}"
                                             data-deleted="false"
                                             data-fullname="${fn:escapeXml(displayRecipientName)}"
                                             data-phone="${fn:escapeXml(displayRecipientPhone)}"
                                             data-street="${fn:escapeXml(address.street)}"
                                             data-ward="${fn:escapeXml(address.district)}"
                                             data-city="${fn:escapeXml(address.city)}"
                                             data-default="${address['default']}">
                                            <div class="flex justify-between gap-3">
                                                <div>
                                                    <p class="text-[14px] font-bold">
                                                        <span class="default-option-badge ${address['default'] ? '' : 'hidden'} text-[11px] bg-primary text-white px-2 py-1 rounded-full mr-2">
                                                            Mặc định
                                                        </span>
                                                        ${displayRecipientName} - ${displayRecipientPhone}
                                                    </p>
                                                    <p class="text-[13px] text-on-surface-variant mt-1">
                                                        ${address.street}, ${address.district}, ${address.city}
                                                    </p>
                                                </div>

                                                <button type="button"
                                                        class="delete-address-btn text-red-600 text-[12px] font-bold hover:underline">
                                                    Xóa
                                                </button>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>

                                <c:otherwise>
                                    <div class="p-4 text-red-600 text-[13px] font-bold">
                                        Bạn chưa có địa chỉ. Vui lòng thêm địa chỉ giao hàng.
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div id="deleteAddressConfirm" class="hidden fixed inset-0 bg-black/40 z-[60] flex items-center justify-center">
                        <div class="bg-white rounded-xl w-[360px] shadow-xl p-6">
                            <h3 class="text-[16px] font-bold text-on-surface mb-2">Xóa địa chỉ?</h3>
                            <p class="text-[13px] text-on-surface-variant mb-5">
                                Địa chỉ này sẽ được xóa khỏi danh sách hiển thị. Bạn có chắc chắn muốn xóa không?
                            </p>
                            <div class="grid grid-cols-2 gap-3">
                                <button type="button" id="btnCancelDeleteAddress"
                                        class="bg-blue-100 text-[#071e27] py-3 rounded font-bold text-[13px]">
                                    Hủy
                                </button>
                                <button type="button" id="btnConfirmDeleteAddress"
                                        class="bg-red-600 text-white py-3 rounded font-bold text-[13px]">
                                    Xóa
                                </button>
                            </div>
                        </div>
                    </div>

                    <div id="newAddressForm" class="hidden fixed inset-0 bg-black/40 z-50 flex items-center justify-center">
                        <div class="bg-white rounded-lg w-[430px] overflow-hidden shadow-xl">
                            <div class="bg-primary text-white px-5 py-4 flex justify-between items-center">
                                <h3 class="font-bold text-[16px]">Thêm địa chỉ mới</h3>
                                <button type="button" id="btnCloseAddressForm" class="text-white text-[24px] leading-none">×</button>
                            </div>

                            <div class="p-5 space-y-4">
<div id="newRecipientFields" class="grid grid-cols-2 gap-3">
                                    <div>
                                        <label class="block text-[12px] font-bold mb-1">Họ tên người nhận</label>
                                        <input id="newFullname" type="text" placeholder="Nhập họ và tên"
                                               value="${sessionScope.account.fullname}"
                                               class="w-full border border-outline-variant rounded px-3 py-2 text-[13px]">
                                    </div>

                                    <div>
                                        <label class="block text-[12px] font-bold mb-1">Số điện thoại</label>
                                        <input id="newPhone" type="text" placeholder="Nhập số điện thoại"
                                               value="${sessionScope.account.phone}"
                                               class="w-full border border-outline-variant rounded px-3 py-2 text-[13px]">
                                    </div>
                                </div>

                                <div class="grid grid-cols-2 gap-3">
                                    <div>
                                        <label class="block text-[12px] font-bold mb-1">Tỉnh / Thành phố</label>
                                        <select id="newCity"
                                                class="w-full border border-outline-variant rounded px-3 py-2 text-[13px]">
                                            <option value="">Đang tải...</option>
                                        </select>
                                    </div>

                                    <div>
                                        <label class="block text-[12px] font-bold mb-1">Phường / Xã</label>
                                        <select id="newWard"
                                                class="w-full border border-outline-variant rounded px-3 py-2 text-[13px]">
                                            <option value="">Chọn Phường / Xã</option>
                                        </select>
                                    </div>
                                </div>

                                <div>
                                    <label class="block text-[12px] font-bold mb-1">Địa chỉ cụ thể</label>
                                    <textarea id="newStreet" rows="3" placeholder="Số nhà, tên đường..."
                                              class="w-full border border-outline-variant rounded px-3 py-2 text-[13px]"></textarea>
                                </div>

                                <label class="flex items-center gap-2 bg-blue-50 px-3 py-2 rounded text-[12px]">
                                    <input type="checkbox" id="defaultAddress">
                                    Đặt làm địa chỉ nhận hàng mặc định
                                </label>

                                <div class="grid grid-cols-2 gap-3 pt-2">
                                    <button type="button" id="btnCancelAddress"
                                            class="bg-blue-100 text-[#071e27] py-3 rounded font-bold text-[13px]">
                                        Hủy bỏ
                                    </button>

                                    <button type="button" id="btnSaveAddress"
                                            class="bg-primary text-white py-3 rounded font-bold text-[13px]">
                                        Lưu địa chỉ
                                    </button>
                                </div>
                            </div>
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
                            <input class="text-primary focus:ring-primary h-5 w-5"
                                   name="payment_method" form="checkout-form" type="radio" value="vnpay"/>
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
                            <input checked class="text-primary focus:ring-primary h-5 w-5"
                                   name="payment_method" form="checkout-form" type="radio" value="cod"/>
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
                            <span class="text-on-surface-variant">Tạm tính (${totalQuantity} sản phẩm)</span>
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

                    <form id="checkout-form" action="${pageContext.request.contextPath}/checkout" method="POST">
                        <input type="hidden" name="addressID" id="checkoutAddressID" value="">
                        <input type="hidden" name="fullname" id="checkoutFullname" value="">
                        <input type="hidden" name="phone" id="checkoutPhone" value="">
                        <input type="hidden" name="street" id="checkoutStreet" value="">
                        <input type="hidden" name="ward" id="checkoutWard" value="">
                        <input type="hidden" name="city" id="checkoutCity" value="">
                        <input type="hidden" name="district" id="checkoutDistrict" value="Không có">
                        <input type="hidden" name="isDefault" id="checkoutIsDefault" value="false">
                        <input type="hidden" name="deletedAddressIds" id="deletedAddressIds" value="">

                        <button type="submit"
                                class="w-full bg-secondary text-primary py-3.5 rounded-full font-black text-[15px]
                                shadow-sm hover:scale-[1.02] active:scale-[0.98] transition-all
                                flex items-center justify-center gap-2 uppercase tracking-wide">
                            ĐẶT HÀNG NGAY
                        </button>
                    </form>
                </div>
            </aside>
        </div>
    </main>

    <script>
        var vietnamProvinces = [];
        var addressIdCounter = Date.now();
        var deleteTargetOption = null;
        var deletedAddressIds = [];

        var ADDRESS_STORAGE_KEY = 'checkout_addresses_${sessionScope.account.id}';
        var DELETED_STORAGE_KEY = 'checkout_deleted_addresses_${sessionScope.account.id}';

        function showInputError(message) {
            showToast(message, true);
        }

        function escapeHtml(text) {
            return String(text || '')
                    .replaceAll('&', '&amp;')
                    .replaceAll('<', '&lt;')
                    .replaceAll('>', '&gt;')
                    .replaceAll('"', '&quot;')
                    .replaceAll("'", '&#039;');
        }

        function loadLocalAddresses() {
            try {
                return JSON.parse(localStorage.getItem(ADDRESS_STORAGE_KEY) || '[]');
            } catch (e) {
                return [];
            }
        }

        function saveLocalAddresses(addresses) {
            localStorage.setItem(ADDRESS_STORAGE_KEY, JSON.stringify(addresses));
        }

        function loadDeletedAddressIds() {
            try {
                return JSON.parse(localStorage.getItem(DELETED_STORAGE_KEY) || '[]');
            } catch (e) {
                return [];
            }
        }

        function saveDeletedAddressIds() {
            localStorage.setItem(DELETED_STORAGE_KEY, JSON.stringify(deletedAddressIds));
            document.getElementById('deletedAddressIds').value = deletedAddressIds.join(',');
        }

        function validateFullname(fullname) {
            var nameRegex = /^[A-Za-zÀ-ỹ\s]{2,50}$/;
            if (!fullname)
                return 'Vui lòng nhập họ tên người nhận.';
            if (!nameRegex.test(fullname))
                return 'Họ tên không hợp lệ.';
            return '';
        }

        function validatePhone(phone) {
            var phoneRegex = /^(0|\+84)(3|5|7|8|9)[0-9]{8}$/;
            if (!phone)
                return 'Vui lòng nhập số điện thoại.';
            if (!phoneRegex.test(phone))
                return 'Số điện thoại không hợp lệ.';
            return '';
        }

        function validateStreet(street) {
            var streetRegex = /[A-Za-zÀ-ỹ]/;
            if (!street)
                return 'Vui lòng nhập địa chỉ cụ thể.';
            if (street.length < 5 || !streetRegex.test(street)) {
                return 'Địa chỉ không hợp lệ. Vui lòng nhập số nhà, tên đường rõ ràng hơn.';
            }
            return '';
        }

        function validateAddressInput(fullname, phone, city, ward, street) {
            var error = validateFullname(fullname);
            if (error)
                return error;

            error = validatePhone(phone);
            if (error)
                return error;

            if (!city)
                return 'Vui lòng chọn Tỉnh / Thành phố.';
            if (!ward)
                return 'Vui lòng chọn Phường / Xã.';

            error = validateStreet(street);
            if (error)
                return error;

            return '';
        }

        function setCheckoutAddress(addressID, fullname, phone, street, ward, city, isDefault) {
            document.getElementById('checkoutAddressID').value = addressID || '';
            document.getElementById('checkoutFullname').value = fullname || '';
            document.getElementById('checkoutPhone').value = phone || '';
            document.getElementById('checkoutStreet').value = street || '';
            document.getElementById('checkoutWard').value = ward || '';
            document.getElementById('checkoutCity').value = city || '';
            document.getElementById('checkoutDistrict').value = ward || 'Không có';
            document.getElementById('checkoutIsDefault').value = isDefault ? 'true' : 'false';

            document.getElementById('selectedNamePhone').textContent = fullname && phone
                    ? fullname + ' - ' + phone
                    : 'Chưa có địa chỉ';

            document.getElementById('selectedAddressText').textContent = street && ward && city
                    ? street + ', ' + ward + ', ' + city
                    : 'Vui lòng thêm địa chỉ giao hàng trước khi thanh toán.';

            var selectedBadge = document.getElementById('selectedDefaultBadge');
            if (isDefault)
                selectedBadge.classList.remove('hidden');
            else
                selectedBadge.classList.add('hidden');
        }

        function resetSelectedAddressBox() {
            setCheckoutAddress('', '', '', '', '', '', false);
        }

        function getVisibleAddressOptions() {
            return Array.prototype.slice.call(document.querySelectorAll('.address-option')).filter(function (option) {
                return option.dataset.deleted !== 'true' && !option.classList.contains('hidden');
            });
        }

        function refreshDefaultBadges() {
            document.querySelectorAll('.address-option').forEach(function (option) {
                var badge = option.querySelector('.default-option-badge');
                if (!badge)
                    return;

                if (option.dataset.default === 'true' && option.dataset.deleted !== 'true') {
                    badge.classList.remove('hidden');
                } else {
                    badge.classList.add('hidden');
                }
            });
        }

        function syncLocalAddressesFromDom() {
            var localAddresses = [];

            document.querySelectorAll('.address-option').forEach(function (option) {
                if (option.dataset.id && option.dataset.id.indexOf('new-') === 0 && option.dataset.deleted !== 'true') {
                    localAddresses.push({
                        id: option.dataset.id,
                        fullname: option.dataset.fullname,
                        phone: option.dataset.phone,
                        street: option.dataset.street,
                        ward: option.dataset.ward,
                        city: option.dataset.city,
                        isDefault: option.dataset.default === 'true'
                    });
                }
            });

            saveLocalAddresses(localAddresses);
        }

        function isSelectedOption(option) {
            return document.getElementById('checkoutStreet').value === option.dataset.street &&
                    document.getElementById('checkoutWard').value === option.dataset.ward &&
                    document.getElementById('checkoutCity').value === option.dataset.city &&
                    document.getElementById('checkoutPhone').value === option.dataset.phone;
        }

        function selectOption(option) {
            if (!option || option.dataset.deleted === 'true')
                return;

            setCheckoutAddress(
                    option.dataset.id,
                    option.dataset.fullname,
                    option.dataset.phone,
                    option.dataset.street,
                    option.dataset.ward,
                    option.dataset.city,
                    option.dataset.default === 'true'
                    );

            document.getElementById('addressDropdown').classList.add('hidden');
        }

        function createAddressOption(address) {
            var option = document.createElement('div');
            option.className = 'address-option p-4 cursor-pointer hover:bg-primary/5 border-b';
            option.dataset.id = address.id;
            option.dataset.deleted = 'false';
            option.dataset.fullname = address.fullname;
            option.dataset.phone = address.phone;
            option.dataset.street = address.street;
            option.dataset.ward = address.ward;
            option.dataset.city = address.city;
            option.dataset.default = address.isDefault ? 'true' : 'false';

            option.innerHTML =
                    '<div class="flex justify-between gap-3">' +
                    '<div>' +
                    '<p class="text-[14px] font-bold">' +
                    '<span class="default-option-badge ' + (address.isDefault ? '' : 'hidden') + ' text-[11px] bg-primary text-white px-2 py-1 rounded-full mr-2">Mặc định</span>' +
                    escapeHtml(address.fullname) + ' - ' + escapeHtml(address.phone) +
                    '</p>' +
                    '<p class="text-[13px] text-on-surface-variant mt-1">' +
                    escapeHtml(address.street) + ', ' + escapeHtml(address.ward) + ', ' + escapeHtml(address.city) +
                    '</p>' +
                    '</div>' +
                    '<button type="button" class="delete-address-btn text-red-600 text-[12px] font-bold hover:underline">Xóa</button>' +
                    '</div>';

            bindAddressOption(option);
            return option;
        }

        function softDeleteAddress(option) {
            if (!option)
                return;

            var addressID = option.dataset.id;

            if (!addressID) {
                showInputError('Không tìm thấy địa chỉ cần xóa!');
                return;
            }

            fetch('${pageContext.request.contextPath}/checkout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body:
                        'action=deleteAddressAjax' +
                        '&addressID=' + encodeURIComponent(addressID)
            })
                    .then(function (response) {
                        return response.json();
                    })
                    .then(function (data) {
                        if (!data.success) {
                            showInputError('Xóa địa chỉ thất bại!');
                            return;
                        }

                        var wasSelected = isSelectedOption(option);

                        option.remove();

                        refreshDefaultBadges();

                        var remainingOptions = getVisibleAddressOptions();

                        if (wasSelected && remainingOptions.length > 0) {
                            var defaultOption = document.querySelector('.address-option[data-default="true"]:not(.hidden)');
                            selectOption(defaultOption || remainingOptions[0]);
                        }

                        if (remainingOptions.length === 0) {
                            resetSelectedAddressBox();
                        }

                        showToast('Đã xóa địa chỉ!', false);
                    })
                    .catch(function () {
                        showInputError('Không kết nối được server!');
                    });
        }

        function bindAddressOption(option) {
            option.addEventListener('click', function () {
                selectOption(this);
            });

            var deleteBtn = option.querySelector('.delete-address-btn');
            if (deleteBtn) {
                deleteBtn.addEventListener('click', function (e) {
                    e.stopPropagation();
                    deleteTargetOption = option;
                    document.getElementById('deleteAddressConfirm').classList.remove('hidden');
                });
            }
        }

        function applyDeletedAddressesOnReload() {
            deletedAddressIds = [];
            document.getElementById('deletedAddressIds').value = '';
        }

        function renderLocalAddresses() {
            localStorage.removeItem(ADDRESS_STORAGE_KEY);
            localStorage.removeItem(DELETED_STORAGE_KEY);
        }

        document.querySelectorAll('.address-option').forEach(bindAddressOption);
        applyDeletedAddressesOnReload();
        renderLocalAddresses();

        document.getElementById('btnCancelDeleteAddress').addEventListener('click', function () {
            deleteTargetOption = null;
            document.getElementById('deleteAddressConfirm').classList.add('hidden');
        });

        document.getElementById('btnConfirmDeleteAddress').addEventListener('click', function () {
            softDeleteAddress(deleteTargetOption);
            deleteTargetOption = null;
            document.getElementById('deleteAddressConfirm').classList.add('hidden');
        });

        document.getElementById('selectedAddressBox').addEventListener('click', function () {
            document.getElementById('addressDropdown').classList.toggle('hidden');
        });

        document.getElementById('btnShowAddressForm').addEventListener('click', function () {
            document.getElementById('newAddressForm').classList.remove('hidden');
        });

        document.getElementById('btnCloseAddressForm').addEventListener('click', closeAddressModal);
        document.getElementById('btnCancelAddress').addEventListener('click', closeAddressModal);

        var accountFullname = '${fn:escapeXml(sessionScope.account.fullname)}';
        var accountPhone = '${fn:escapeXml(sessionScope.account.phone)}';

        function resetRecipientFields() {
            document.getElementById('newFullname').value = accountFullname;
            document.getElementById('newPhone').value = accountPhone;
        }

        function closeAddressModal() {
            document.getElementById('newAddressForm').classList.add('hidden');
            resetRecipientFields();
        }

        async function loadVietnamProvinces() {
            var citySelect = document.getElementById('newCity');
            var wardSelect = document.getElementById('newWard');

            citySelect.innerHTML = '<option value="">Đang tải...</option>';
            wardSelect.innerHTML = '<option value="">Chọn Phường / Xã</option>';

            try {
                var response = await fetch('https://provinces.open-api.vn/api/v2/?depth=2');
                vietnamProvinces = await response.json();

                citySelect.innerHTML = '<option value="">Chọn Tỉnh / Thành phố</option>';

                vietnamProvinces.forEach(function (province) {
                    var option = document.createElement('option');
                    option.value = province.name;
                    option.textContent = province.name;
                    option.dataset.code = province.code;
                    citySelect.appendChild(option);
                });
            } catch (error) {
                citySelect.innerHTML = '<option value="">Không tải được dữ liệu</option>';
                showInputError('Không tải được tỉnh thành!');
            }
        }

        document.getElementById('newCity').addEventListener('change', async function () {
            var cityName = this.value;
            var wardSelect = document.getElementById('newWard');

            wardSelect.innerHTML = '<option value="">Đang tải Phường / Xã...</option>';

            var province = vietnamProvinces.find(function (item) {
                return item.name === cityName;
            });

            if (!province) {
                wardSelect.innerHTML = '<option value="">Chọn Phường / Xã</option>';
                return;
            }

            var wards = province.wards || province.communes || [];

            if (!wards.length && province.code) {
                try {
                    var response = await fetch('https://provinces.open-api.vn/api/v2/p/' + province.code + '?depth=2');
                    var provinceDetail = await response.json();
                    wards = provinceDetail.wards || provinceDetail.communes || [];
                } catch (error) {
                    wards = [];
                }
            }

            wardSelect.innerHTML = '<option value="">Chọn Phường / Xã</option>';

            wards.forEach(function (ward) {
                var option = document.createElement('option');
                option.value = ward.name;
                option.textContent = ward.name;
                wardSelect.appendChild(option);
            });
        });

        loadVietnamProvinces();
        refreshDefaultBadges();

        var defaultOption = document.querySelector('.address-option[data-default="true"]:not(.hidden)');
        var firstOption = getVisibleAddressOptions()[0];

        if (defaultOption)
            selectOption(defaultOption);
        else if (firstOption)
            selectOption(firstOption);
        else
            resetSelectedAddressBox();

        document.getElementById('btnSaveAddress').addEventListener('click', function () {
            var fullname = document.getElementById('newFullname').value.trim();
            var phone = document.getElementById('newPhone').value.trim();
            var city = document.getElementById('newCity').value;
            var ward = document.getElementById('newWard').value;
            var street = document.getElementById('newStreet').value.trim();
            var isDefault = document.getElementById('defaultAddress').checked;

            var error = validateAddressInput(fullname, phone, city, ward, street);

            if (error) {
                showInputError(error);
                return;
            }

            if (getVisibleAddressOptions().length === 0)
                isDefault = true;

            if (isDefault) {
                document.querySelectorAll('.address-option').forEach(function (option) {
                    option.dataset.default = 'false';
                });
            }

            fetch('${pageContext.request.contextPath}/checkout', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8'
                },
                body:
                        'action=saveAddress' +
                        '&street=' + encodeURIComponent(street) +
                        '&ward=' + encodeURIComponent(ward) +
                        '&city=' + encodeURIComponent(city) +
                        '&isDefault=' + encodeURIComponent(isDefault) +
                        '&fullname=' + encodeURIComponent(fullname) +
                        '&phone=' + encodeURIComponent(phone)
            })
                    .then(function (response) {
                        return response.json();
                    })
                    .then(function (data) {
                        if (!data.success) {
                            showInputError('Lỗi khi lưu địa chỉ vào database!');
                            return;
                        }

                        var address = {
                            id: String(data.addressID),
                            fullname: fullname,
                            phone: phone,
                            street: street,
                            ward: ward,
                            city: city,
                            isDefault: isDefault
                        };

                        var option = createAddressOption(address);
                        document.getElementById('addressDropdown').appendChild(option);

                        refreshDefaultBadges();
                        selectOption(option);

                        closeAddressModal();

                        document.getElementById('newStreet').value = '';
                        document.getElementById('defaultAddress').checked = false;
                        resetRecipientFields();

                        localStorage.removeItem(ADDRESS_STORAGE_KEY);
                        localStorage.removeItem(DELETED_STORAGE_KEY);
                        showToast('Đã thêm địa chỉ mới!', false);
                    })
                    .catch(function () {
                        showInputError('Không kết nối được server!');
                    });
        });

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

        document.getElementById('checkout-form').addEventListener('submit', function (e) {
            var fullname = document.getElementById('checkoutFullname').value.trim();
            var phone = document.getElementById('checkoutPhone').value.trim();
            var street = document.getElementById('checkoutStreet').value.trim();
            var ward = document.getElementById('checkoutWard').value.trim();
            var city = document.getElementById('checkoutCity').value.trim();

            if (!fullname || !phone || !street || !ward || !city) {
                e.preventDefault();
                showInputError('Bạn chưa có địa chỉ. Vui lòng nhập địa chỉ giao hàng trước khi thanh toán.');
                return false;
            }

            var error = validateAddressInput(fullname, phone, city, ward, street);
            if (error) {
                e.preventDefault();
                showInputError(error);
                return false;
            }

            document.getElementById('deletedAddressIds').value = '';
        });
    </script>

</body>
<%@ include file="/views/layout/homepage/footer.jsp" %>