<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/views/layout/homepage/header.jsp" %>
<style>
    .input-style{
        width:100%;
        padding:12px 16px;
        border:1px solid #d1d5db;
        border-radius:10px;
    }
    .input-style:focus{
        outline:none;
        border-color:#2563eb;
        box-shadow:0 0 0 3px rgba(37,99,235,.15);
    }
</style>
<div class="max-w-7xl mx-auto py-10 px-4">
    <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
        <!-- SIDEBAR -->
        <c:set var="activeMenu" value="profile" scope="request"/>
        <%@ include file="/views/layout/profile/sidebar.jsp" %>

        <div class="lg:col-span-3 space-y-6">
            <c:if test="${not empty sessionScope.message}">
                <div id="toastMessageData" class="hidden" data-message="${fn:escapeXml(sessionScope.message)}"></div>
                <c:remove var="message" scope="session"/>
            </c:if>

            <c:if test="${not empty sessionScope.error}">
                <div id="toastErrorData" class="hidden" data-message="${fn:escapeXml(sessionScope.error)}"></div>
                <c:remove var="error" scope="session"/>
            </c:if>

            <div id="profile" class="profile-card p-8">
                <div class="mb-8">
                    <h1 class="text-3xl font-bold">
                        Thông tin cá nhân
                    </h1>
                    <p class="text-gray-500 mt-2">
                        Quản lý thông tin hồ sơ của bạn
                    </p>
                </div>

                <form action="${pageContext.request.contextPath}/profile"
                      method="post" id="profileForm">
                    <div class="grid md:grid-cols-2 gap-6">
                        <div>
                            <label class="block mb-2 font-medium">
                                Họ và tên
                            </label>
                            <input
                                type="text"
                                name="fullname"
                                id="fullname"
                                value="${customer.fullname}"
                                required
                                class="input-style">
                            <p id="fullnameError" class="text-red-500 text-sm mt-1 hidden"></p>
                        </div>
                        <div>
                            <label class="block mb-2 font-medium">
                                Email
                            </label>
                            <div class="flex gap-2">
                                <input
                                    type="email"
                                    value="${customer.email}"
                                    disabled
                                    class="input-style bg-gray-100">
                                <button
                                    type="button"
                                    id="openChangeEmailBtn"
                                    class="shrink-0 px-4 py-3 rounded-xl border border-primary text-primary font-medium hover:bg-primary hover:text-white transition-all">
                                    Đổi email
                                </button>
                            </div>
                        </div>
                        <div>
                            <label class="block mb-2 font-medium">
                                Số điện thoại
                            </label>
                            <input
                                type="text"
                                name="phone"
                                id="phone"
                                value="${customer.phone}"
                                class="input-style">
                            <p id="phoneError" class="text-red-500 text-sm mt-1 hidden"></p>
                        </div>
                        <div>
                            <label class="block mb-2 font-medium">
                                Trạng thái
                            </label>
                            <input
                                type="text"
                                value="${customer.status}"
                                disabled
                                class="input-style bg-gray-100">
                        </div>
                        <div>
                            <label class="block mb-2 font-medium">
                                Giới tính
                            </label>

                            <select name="gender" id="gender" class="input-style">
                                <option value="Male"
                                        ${customer.gender == 'Male' ? 'selected' : ''}>
                                    Nam
                                </option>

                                <option value="Female"
                                        ${customer.gender == 'Female' ? 'selected' : ''}>
                                    Nữ
                                </option>

                                <option value="Other"
                                        ${customer.gender == 'Other' ? 'selected' : ''}>
                                    Khác
                                </option>
                            </select>
                        </div>
                        <div>
                            <label class="block mb-2 font-medium">
                                Ngày sinh
                            </label>

                            <input
                                type="date"
                                name="dob"
                                id="dob"
                                value="${customer.dob}"
                                max="<%= java.time.LocalDate.now()%>"
                                class="input-style">
                            <p id="dobError" class="text-red-500 text-sm mt-1 hidden"></p>
                        </div>
                    </div>
                    <div class="mt-8">
                        <button
                            type="submit"
                            id="saveBtn"
                            class="bg-primary hover:bg-primary-dark text-white px-8 py-3 rounded-xl shadow disabled:bg-gray-400 disabled:cursor-not-allowed disabled:opacity-60 transition-all"
                            disabled>
                            Lưu thay đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<%@ include file="/views/layout/common/toast.jsp" %>

<!-- Modal đổi email -->
<div id="changeEmailModal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-50">
    <div class="bg-white rounded-2xl p-6 w-full max-w-md mx-4">
        <h3 class="text-xl font-bold mb-2">Đổi địa chỉ email</h3>
        <p class="text-gray-500 text-sm mb-4">
            Chúng tôi sẽ gửi mã OTP đến email mới để xác nhận trước khi cập nhật.
        </p>
        <form action="${pageContext.request.contextPath}/profile/change-email" method="post">
            <label class="block mb-2 font-medium text-sm">Email mới</label>
            <input
                type="email"
                name="newEmail"
                required
                placeholder="email-moi@example.com"
                class="input-style mb-4">
            <div class="flex justify-end gap-3">
                <button type="button" id="closeChangeEmailBtn"
                        class="px-5 py-2.5 rounded-xl border border-gray-300 text-gray-600 hover:bg-gray-50">
                    Hủy
                </button>
                <button type="submit"
                        class="px-5 py-2.5 rounded-xl bg-primary hover:bg-primary-dark text-white shadow">
                    Gửi mã OTP
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    const openChangeEmailBtn = document.getElementById('openChangeEmailBtn');
    const closeChangeEmailBtn = document.getElementById('closeChangeEmailBtn');
    const changeEmailModal = document.getElementById('changeEmailModal');

    openChangeEmailBtn.addEventListener('click', () => {
        changeEmailModal.classList.remove('hidden');
        changeEmailModal.classList.add('flex');
    });
    closeChangeEmailBtn.addEventListener('click', () => {
        changeEmailModal.classList.add('hidden');
        changeEmailModal.classList.remove('flex');
    });
    changeEmailModal.addEventListener('click', (e) => {
        if (e.target === changeEmailModal) {
            changeEmailModal.classList.add('hidden');
            changeEmailModal.classList.remove('flex');
        }
    });
</script>

<script>
    const initialValues = {
        fullname: "${customer.fullname}",
        phone: "${customer.phone}",
        gender: "${customer.gender}",
        dob: "${customer.dob}"
    };

    const form = document.getElementById('profileForm');
    const saveBtn = document.getElementById('saveBtn');
    const fullnameInput = document.getElementById('fullname');
    const fullnameError = document.getElementById('fullnameError');
    const phoneInput = document.getElementById('phone');
    const phoneError = document.getElementById('phoneError');
    const genderSelect = document.getElementById('gender');
    const dobInput = document.getElementById('dob');
    const dobError = document.getElementById('dobError');

    function setFieldError(inputEl, errorEl, message) {
        if (message) {
            errorEl.textContent = message;
            errorEl.classList.remove('hidden');
            inputEl.classList.add('border-red-500');
        } else {
            errorEl.textContent = "";
            errorEl.classList.add('hidden');
            inputEl.classList.remove('border-red-500');
        }
        return message === "";
    }

    function validateFullname() {
        const value = fullnameInput.value.trim();
        let message = "";

        if (!value) {
            message = "Họ tên không được để trống";
        } else if (/\s{2,}/.test(value)) {
            message = "Họ tên không được chứa nhiều khoảng trắng liên tiếp";
        } else if (!/^[\p{L}]+( [\p{L}]+)+$/u.test(value)) {
            message = value.split(" ").filter(Boolean).length < 2
                ? "Họ tên phải có ít nhất 2 từ, ví dụ: \"Trương Trân\""
                : "Họ tên chỉ được chứa chữ cái và khoảng trắng";
        } else if (value.length > 50) {
            message = "Họ tên không được vượt quá 50 ký tự";
        }

        return setFieldError(fullnameInput, fullnameError, message);
    }

    function validatePhone() {
        const value = phoneInput.value.trim();
        let message = "";

        if (!value) {
            message = "Số điện thoại không được để trống";
        } else if (!/^0\d{9}$/.test(value)) {
            message = "Số điện thoại phải gồm 10 số và bắt đầu bằng 02, 08, 09";
        }

        return setFieldError(phoneInput, phoneError, message);
    }

    function validateDob() {
        const value = dobInput.value;
        let message = "";

        if (value) {
            const birthDate = new Date(value);
            const today = new Date();
            if (birthDate > today) {
                message = "Ngày sinh không hợp lệ";
            } else {
                let age = today.getFullYear() - birthDate.getFullYear();
                const m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                if (age < 18 || age > 120) {
                    message = "Bạn phải từ 18 tuổi đến dưới 120 tuổi";
                }
            }
        }

        return setFieldError(dobInput, dobError, message);
    }

    function checkFormChanges() {
        const fullnameValid = validateFullname();
        const phoneValid = validatePhone();
        const dobValid = validateDob();

        const currentValues = {
            fullname: fullnameInput.value.trim(),
            phone: phoneInput.value.trim(),
            gender: genderSelect.value,
            dob: dobInput.value
        };

        if (!fullnameValid || !phoneValid || !dobValid) {
            saveBtn.disabled = true;
            return;
        }
        const hasChanges =
                currentValues.fullname !== initialValues.fullname ||
                currentValues.phone !== initialValues.phone ||
                currentValues.gender !== initialValues.gender ||
                currentValues.dob !== initialValues.dob;
        saveBtn.disabled = !hasChanges;
    }

    form.addEventListener('submit', function (e) {
        const fullnameValid = validateFullname();
        const phoneValid = validatePhone();
        const dobValid = validateDob();

        if (!fullnameValid || !phoneValid || !dobValid) {
            e.preventDefault();
            const firstError = !fullnameValid ? fullnameError.textContent
                    : !phoneValid ? phoneError.textContent
                    : dobError.textContent;
            const focusTarget = !fullnameValid ? fullnameInput : !phoneValid ? phoneInput : dobInput;
            focusTarget.focus();
            showToast(firstError, true);
        }
    });

    fullnameInput.addEventListener('input', checkFormChanges);
    fullnameInput.addEventListener('change', checkFormChanges);
    phoneInput.addEventListener('input', checkFormChanges);
    phoneInput.addEventListener('change', checkFormChanges);
    genderSelect.addEventListener('change', checkFormChanges);
    dobInput.addEventListener('change', checkFormChanges);

    checkFormChanges();

    document.addEventListener('DOMContentLoaded', function () {
        const msgEl = document.getElementById('toastMessageData');
        const errEl = document.getElementById('toastErrorData');

        if (msgEl) {
            showToast(msgEl.dataset.message);
            setTimeout(() => {
                location.reload();
            }, 2000);
        }
        if (errEl) {
            showToast(errEl.dataset.message, true);
        }
    });
</script>

<%@ include file="/views/layout/homepage/footer.jsp" %>
