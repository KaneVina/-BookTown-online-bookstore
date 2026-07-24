<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Hồ sơ cá nhân - BookTown Admin</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined" rel="stylesheet">
        <style>
            body {
                background: linear-gradient(135deg, #f0f4f9 0%, #e8eef7 100%);
                font-family: 'Inter', sans-serif;
                min-height: 100vh;
            }
            .card-modern {
                background: white;
                border-radius: 18px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1), 0 2px 4px -1px rgba(0,0,0,0.06);
            }
            .input-premium {
                width: 100%;
                height: 52px;
                padding: 0 20px;
                border: 2px solid #e2e8f0;
                border-radius: 12px !important;
                transition: .3s;
                font-weight: 500;
                color: #1e293b;
            }
            .input-premium:focus {
                outline: none;
                border-color: #004d99;
                box-shadow: 0 0 0 4px rgba(0,77,153,.15);
            }
            .input-premium:disabled {
                background: #f8fafc;
                color: #64748b;
                cursor: not-allowed;
            }
            .form-label-modern {
                display: block;
                margin-bottom: 10px;
                font-size: .8rem;
                font-weight: 700;
                color: #334155;
                text-transform: uppercase;
            }
            .form-label-modern span {
                color: red;
            }
            .btn-submit {
                display: inline-flex;
                align-items: center;
                gap: 10px;
                background: linear-gradient(135deg,#004d99,#003366);
                color: white;
                padding: 14px 28px;
                border-radius: 9999px;
                font-weight: 700;
                border: none;
                cursor: pointer;
                transition: .3s;
            }
            .btn-submit:hover:not(:disabled) {
                transform: translateY(-2px);
            }
            .btn-submit:disabled {
                background: #cbd5e1;
                color: #94a3b8;
                cursor: not-allowed;
            }
            .btn-outline-premium {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 0 20px;
                height: 52px;
                border-radius: 12px;
                border: 2px solid #004d99;
                color: #004d99;
                font-weight: 700;
                background: white;
                cursor: pointer;
                white-space: nowrap;
                transition: .3s;
            }
            .btn-outline-premium:hover {
                background: #004d99;
                color: white;
            }
            .info-card {
                background: #f8fafc;
                padding: 24px;
                border-radius: 14px;
                border: 1px solid #e2e8f0;
            }
            .info-label {
                font-size: .75rem;
                color: #64748b;
                font-weight: 700;
                margin-bottom: 6px;
                text-transform: uppercase;
            }
            .badge-status {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-weight: 600;
                background: #fef9c3;
                color: #854d0e;
                padding: 6px 16px;
                border-radius: 9999px;
                font-size: .85rem;
            }
            .separator {
                border-top: 2px solid #e2e8f0;
                margin: 28px 0;
            }
        </style>
    </head>

    <body class="text-slate-800">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <div class="md:pl-64 flex flex-col flex-1 min-h-screen">
            <main class="py-12 px-4 sm:px-6 lg:px-8 max-w-7xl w-full mx-auto">
                <c:if test="${not empty sessionScope.message}">
                    <div id="toastMessageData" class="hidden" data-message="${fn:escapeXml(sessionScope.message)}"></div>
                    <c:remove var="message" scope="session"/>
                </c:if>
                <c:if test="${not empty sessionScope.error}">
                    <div id="toastErrorData" class="hidden" data-message="${fn:escapeXml(sessionScope.error)}"></div>
                    <c:remove var="error" scope="session"/>
                </c:if>

                <div class="mb-10">
                    <h1 class="text-4xl font-bold text-slate-900">
                        Hồ sơ cá nhân
                    </h1>
                    <p class="text-slate-600 mt-2">
                        Quản lý thông tin tài khoản và cập nhật thông tin cá nhân của bạn.
                    </p>
                </div>

                <div class="lg:col-span-2">
                    <div class="card-modern p-8 sm:p-10">
                        <form action="${pageContext.request.contextPath}/profile" method="post" id="profileForm" class="space-y-6">

                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label class="form-label-modern" for="fullname">
                                        Họ và tên <span>*</span>
                                    </label>
                                    <input
                                        type="text"
                                        name="fullname"
                                        id="fullname"
                                        value="${fn:escapeXml(account.fullname)}"
                                        required
                                        class="input-premium"
                                        placeholder="Nhập tên đầy đủ">
                                </div>
                                <div>
                                    <label class="form-label-modern" for="phone">
                                        Số điện thoại <span>*</span>
                                    </label>
                                    <input
                                        type="tel"
                                        name="phone"
                                        id="phone"
                                        value="${fn:escapeXml(account.phone)}"
                                        required
                                        class="input-premium"
                                        placeholder="0912345678">
                                </div>
                                         <div>
                                    <label class="form-label-modern text-slate-500">Mã ID</label>
                                    <input type="text" value="${account.id}" disabled class="input-premium font-mono">
                                </div>
                                <div>
                                    <label class="form-label-modern text-slate-500">Email</label>
                                    <div class="flex gap-2">
                                        <input type="email" value="${account.email}" disabled class="input-premium">
                                        <button
                                            type="button"
                                            id="openChangeEmailBtn"
                                            class="btn-outline-premium">
                                            Đổi email
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="flex justify-end">
                                <button type="submit" id="saveBtn" class="btn-submit" disabled>
                                    <span class="material-symbols-outlined">save</span>
                                    Lưu thay đổi
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </main>
        </div>

        <%@ include file="/views/layout/common/toast.jsp" %>

        <!-- Modal đổi email -->
        <div id="changeEmailModal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-50">
            <div class="bg-white rounded-2xl p-6 w-full max-w-md mx-4 card-modern">
                <h3 class="text-xl font-bold mb-2 text-slate-800">Đổi địa chỉ email</h3>
                <p class="text-slate-500 text-sm mb-4">
                    Chúng tôi sẽ gửi mã OTP đến email mới để xác nhận trước khi cập nhật.
                </p>
                <form action="${pageContext.request.contextPath}/profile/change-email" method="post">
                    <label class="form-label-modern" for="newEmail">Email mới</label>
                    <input
                        type="email"
                        name="newEmail"
                        id="newEmail"
                        required
                        placeholder="email-moi@example.com"
                        class="input-premium mb-4">
                    <div class="flex justify-end gap-3">
                        <button type="button" id="closeChangeEmailBtn"
                                class="px-5 py-2.5 rounded-xl border border-slate-300 text-slate-600 hover:bg-slate-50">
                            Hủy
                        </button>
                        <button type="submit" class="btn-submit">
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
                fullname: "${account.fullname}",
                phone: "${account.phone}"
            };

            const saveBtn = document.getElementById('saveBtn');
            const fullnameInput = document.getElementById('fullname');
            const phoneInput = document.getElementById('phone');

            function checkFormChanges() {
                const currentFullname = fullnameInput.value.trim();
                const currentPhone = phoneInput.value.trim();

                if (!currentFullname || !currentPhone) {
                    saveBtn.disabled = true;
                    return;
                }

                const hasChanges = currentFullname !== initialValues.fullname || currentPhone !== initialValues.phone;
                saveBtn.disabled = !hasChanges;
            }

            ['input', 'change'].forEach(evt => {
                fullnameInput.addEventListener(evt, checkFormChanges);
                phoneInput.addEventListener(evt, checkFormChanges);
            });

            checkFormChanges();

            document.addEventListener('DOMContentLoaded', function () {
                const msgEl = document.getElementById('toastMessageData');
                const errEl = document.getElementById('toastErrorData');

                if (msgEl && typeof showToast === 'function') {
                    showToast(msgEl.dataset.message);
                }
                if (errEl && typeof showToast === 'function') {
                    showToast(errEl.dataset.message, true);
                }
            });
        </script>
    </body>
</html>
