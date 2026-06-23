<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Hồ sơ cá nhân - BookTown Admin</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">

        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            "primary": "#004d99",
                            "primary-dark": "#003366",
                            "secondary": "#705d00",
                            "success": "#2E7D32",
                            "error": "#D32F2F",
                            "warning": "#EF6C00"
                        },
                        fontFamily: {
                            sans: ['Inter', 'sans-serif'],
                        }
                    }
                }
            }
        </script>

        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                background: linear-gradient(135deg, #f0f4f9 0%, #e8eef7 100%);
                font-family: 'Inter', sans-serif;
                min-height: 100vh;
            }

            /* Input Styling */
            .input-premium {
                display: block;
                width: 100%;
                height: 52px;
                padding: 0 20px;
                border: 2px solid #e2e8f0;
                border-radius: 9999px !important;
                font-size: 0.95rem;
                color: #1e293b;
                background-color: #ffffff;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                font-weight: 500;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                -webkit-appearance: none;
                appearance: none;
            }

            .input-premium:focus {
                outline: none;
                border-color: #004d99;
                border-radius: 9999px !important;
                box-shadow: 0 0 0 4px rgba(0, 77, 153, 0.15), 0 2px 8px rgba(0, 77, 153, 0.1);
                background-color: #ffffff;
            }

            .input-premium:disabled {
                background-color: #f8fafc;
                color: #64748b;
                cursor: not-allowed;
                border-color: #e2e8f0;
                border-radius: 9999px !important;
            }

            /* Enhanced Card */
            .card-modern {
                background: white;
                border-radius: 18px;
                border: 1px solid #e2e8f0;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
                transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            }

            .card-modern:hover {
                box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
                border-color: #d4dce5;
            }

            /* Sticky sidebar with smooth transition */
            .sidebar-sticky {
                position: sticky;
                top: 24px;
            }

            /* Avatar with gradient animation */
            .avatar-gradient {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                background: linear-gradient(135deg, #004d99 0%, #0066cc 50%, #003366 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                box-shadow: 0 8px 24px rgba(0, 77, 153, 0.25);
                margin: 0 auto;
                position: relative;
                animation: gradientShift 6s ease infinite;
            }

            @keyframes gradientShift {
                0%, 100% {
                    background: linear-gradient(135deg, #004d99 0%, #0066cc 50%, #003366 100%);
                }
                50% {
                    background: linear-gradient(135deg, #003366 0%, #0066cc 50%, #004d99 100%);
                }
            }

            .avatar-gradient span {
                color: white;
                font-size: 64px;
                text-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
            }

            /* Badge with enhanced styling */
            .badge-role {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 8px 14px;
                background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
                color: #0c4a6e;
                border-radius: 9999px;
                font-weight: 700;
                font-size: 0.75rem;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                box-shadow: 0 2px 8px rgba(0, 77, 153, 0.15);
                border: 1px solid #93c5fd;
            }

            .badge-status {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                font-weight: 700;
                color: #0f766e;
                font-size: 0.85rem;
            }

            .status-dot {
                width: 8px;
                height: 8px;
                border-radius: 50%;
                background-color: #10b981;
                box-shadow: 0 0 8px #10b981;
                animation: pulse-dot 2s ease-in-out infinite;
            }

            @keyframes pulse-dot {
                0%, 100% { 
                    box-shadow: 0 0 8px rgba(16, 185, 129, 1);
                    transform: scale(1);
                }
                50% { 
                    box-shadow: 0 0 12px rgba(16, 185, 129, 0.8);
                    transform: scale(1.1);
                }
            }

            /* Form label */
            .form-label-modern {
                display: block;
                font-size: 0.8rem;
                font-weight: 700;
                color: #334155;
                margin-bottom: 10px;
                text-transform: uppercase;
                letter-spacing: 0.6px;
            }

            .form-label-modern span {
                color: #dc2626;
            }

            /* Section title */
            .section-title {
                font-size: 0.85rem;
                font-weight: 700;
                color: #475569;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 20px;
                display: flex;
                align-items: center;
                gap: 10px;
                padding-bottom: 12px;
                border-bottom: 2px solid #e2e8f0;
            }

            .section-title span {
                color: #004d99;
                font-size: 20px;
            }

            /* Enhanced Button */
            .btn-submit {
                display: inline-flex;
                align-items: center;
                gap: 10px;
                background: linear-gradient(135deg, #004d99 0%, #003366 100%);
                color: white;
                padding: 14px 28px;
                border-radius: 9999px;
                font-weight: 700;
                font-size: 0.95rem;
                border: none;
                cursor: pointer;
                box-shadow: 0 4px 12px rgba(0, 77, 153, 0.3);
                transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .btn-submit:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 20px rgba(0, 77, 153, 0.4);
                background: linear-gradient(135deg, #003366 0%, #001f3d 100%);
            }

            .btn-submit:active {
                transform: translateY(-1px);
            }

            .btn-submit:disabled {
                background: #cbd5e1;
                color: #94a3b8;
                cursor: not-allowed;
                box-shadow: none;
                transform: none;
            }

            /* Info card modern */
            .info-card {
                background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
                padding: 16px;
                border-radius: 14px;
                border: 1px solid #e2e8f0;
                transition: all 0.3s ease;
            }

            .info-card:hover {
                background: linear-gradient(135deg, #f1f5f9 0%, #e8eef7 100%);
                border-color: #cbd5e1;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            }

            .info-label {
                font-size: 0.75rem;
                font-weight: 700;
                color: #64748b;
                text-transform: uppercase;
                letter-spacing: 0.4px;
                margin-bottom: 8px;
            }

            .info-value {
                font-size: 0.95rem;
                font-weight: 600;
                color: #1e293b;
            }

            /* Separator */
            .separator {
                border-top: 2px solid #e2e8f0;
                margin: 24px 0;
            }

            /* Header animation */
            .header-section {
                animation: slideDown 0.6s cubic-bezier(0.34, 1.56, 0.64, 1);
            }

            @keyframes slideDown {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Form group animation */
            .form-group {
                animation: fadeIn 0.6s ease;
            }

            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            /* Smooth page transition */
            main {
                animation: pageLoad 0.5s ease;
            }

            @keyframes pageLoad {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            /* Responsive adjustments */
            @media (max-width: 768px) {
                .card-modern {
                    border-radius: 16px;
                }
                
                .avatar-gradient {
                    width: 100px;
                    height: 100px;
                }
                
                .avatar-gradient span {
                    font-size: 48px;
                }

                .btn-submit {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body class="text-slate-800 antialiased">
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
                <div class="header-section mb-12">
                    <h1 class="text-4xl font-bold text-slate-900 tracking-tight flex items-center gap-3 mb-2">
                        Hồ sơ cá nhân
                    </h1>
                    <p class="text-slate-600 text-base ml-14">Quản lý thông tin tài khoản và cập nhật thông tin cá nhân của bạn</p>
                </div>
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">

                    <div class="lg:col-span-1">
                        <div class="card-modern p-8 sidebar-sticky">
                            <h2 class="text-2xl font-bold text-center text-slate-900 mt-6 mb-2">
                                ${fn:escapeXml(account.fullname)}
                            </h2>
                            <p class="text-center text-sm text-slate-400 font-mono mb-6">ID #${account.id}</p>
                            <div class="separator"></div>
                            <div class="space-y-4">
                                <div class="info-card">
                                    <div class="info-label">Trạng thái</div>
                                    <div class="badge-status">
                                        <div class="status-dot"></div>
                                        <span>${account.status}</span>
                                    </div>
                                </div>

                                <div class="info-card">
                                    <div class="info-label">Loại tài khoản</div>
                                    <div class="info-value">Quản trị viên</div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="lg:col-span-2">
                        <div class="card-modern p-8 sm:p-10">
                            <div class="mb-10">
                                <h2 class="text-2xl font-bold text-slate-900 flex items-center gap-3 mb-2">
                                    <span class="material-symbols-outlined" style="color: #004d99;">edit</span>
                                    Cập nhật thông tin
                                </h2>
                                <p class="text-slate-500 text-sm ml-10">Chỉnh sửa thông tin cá nhân của bạn</p>
                            </div>
                            <div class="separator"></div>
                            <form action="${pageContext.request.contextPath}/profile" method="post" id="profileForm" class="space-y-10">
                                <div class="form-group">
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                        <div>
                                            <label class="form-label-modern">Mã định danh</label>
                                            <input type="text" value="${account.id}" disabled class="input-premium font-mono"/>
                                        </div>
                                        <div>
                                            <label class="form-label-modern">Email</label>
                                            <input type="email" value="${account.email}" disabled class="input-premium"/>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                        <div>
                                            <label class="form-label-modern">Họ và tên <span>*</span></label>
                                            <input 
                                                type="text" 
                                                name="fullname" 
                                                id="fullname"
                                                value="${fn:escapeXml(account.fullname)}" 
                                                required 
                                                class="input-premium" 
                                                placeholder="Nhập tên đầy đủ"
                                            />
                                        </div>
                                        <div>
                                            <label class="form-label-modern">Số điện thoại <span>*</span></label>
                                            <input 
                                                type="tel" 
                                                name="phone" 
                                                id="phone"
                                                value="${fn:escapeXml(account.phone)}" 
                                                required 
                                                class="input-premium" 
                                                placeholder="0912345678"
                                            />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                                        <div>
                                            <label class="form-label-modern">Trạng thái</label>
                                            <input 
                                                type="text" 
                                                value="${account.status}" 
                                                disabled 
                                                class="input-premium capitalize"
                                            />
                                        </div>
                                    </div>
                                </div>
                                <div class="separator"></div>
                                <div class="flex justify-end">
                                    <button type="submit" id="saveBtn" class="btn-submit" disabled>
                                        <span class="material-symbols-outlined">save</span>
                                        Lưu thay đổi
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

            </main>
        </div>

        <%@ include file="/views/layout/common/toast.jsp" %>

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

                const hasChanges =
                        currentFullname !== initialValues.fullname ||
                        currentPhone !== initialValues.phone;

                saveBtn.disabled = !hasChanges;
            }

            fullnameInput.addEventListener('input', checkFormChanges);
            fullnameInput.addEventListener('change', checkFormChanges);
            phoneInput.addEventListener('input', checkFormChanges);
            phoneInput.addEventListener('change', checkFormChanges);

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
