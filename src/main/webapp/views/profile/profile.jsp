<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/views/layout/homepage/header.jsp" %>

<style>
    body{
        background:#f3faff;
    }
    .profile-card{
        background:#fff;
        border-radius:16px;
        border:1px solid #dbeafe;
        box-shadow:0 2px 10px rgba(0,0,0,.05);
    }
    .menu-item{
        display:flex;
        align-items:center;
        gap:12px;
        padding:12px 16px;
        border-radius:12px;
        transition:.2s;
    }
    .menu-item:hover{
        background:#eff6ff;
    }
    .menu-active{
        background:#dbeafe;
        color:#2563eb;
        font-weight:600;
    }
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
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
<div class="max-w-7xl mx-auto py-10 px-4">
    <div class="grid grid-cols-1 lg:grid-cols-4 gap-6">
        <!-- SIDEBAR -->
        <div class="lg:col-span-1">
            <div class="profile-card p-6">
                <div class="flex flex-col items-center">
                    <div class="relative">
                        <img
                            src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png"
                            class="w-24 h-24 rounded-full border-4 border-blue-200 shadow"
                            alt="Avatar">
                    </div>
                    <h2 class="mt-4 text-xl font-bold text-center">
                        ${customer.fullname}
                    </h2>

                    <div class="mt-2 px-3 py-1 rounded-full bg-yellow-100 text-yellow-700 text-sm">
                        ${customer.role}
                    </div>

                </div>
                <hr class="my-6">
                <nav class="space-y-2">
                    <a href="${pageContext.request.contextPath}/profile?id=${sessionScope.account.id}"
                       class="menu-item menu-active">
                        <span class="material-symbols-outlined">person</span>
                        Thông tin cá nhân
                    </a>
                    <a href="${pageContext.request.contextPath}/profile/order-history"
                       class="menu-item">
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
                        <span class="material-symbols-outlined">
                            logout
                        </span>
                        Đăng xuất
                    </a>
                </nav>
            </div>
        </div>

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
                        </div>
                        <div>
                            <label class="block mb-2 font-medium">
                                Email
                            </label>
                            <input
                                type="email"
                                value="${customer.email}"
                                disabled
                                class="input-style bg-gray-100">
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
    const phoneInput = document.getElementById('phone');
    const genderSelect = document.getElementById('gender');
    const dobInput = document.getElementById('dob');

    function checkFormChanges() {
        const currentValues = {
            fullname: fullnameInput.value.trim(),
            phone: phoneInput.value.trim(),
            gender: genderSelect.value,
            dob: dobInput.value
        };

        if (!currentValues.fullname) {
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
