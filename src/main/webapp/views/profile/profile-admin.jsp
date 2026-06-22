<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Thông tin tài khoản - BookTown Admin</title>
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
            body {
                background-color: #f8fafc;
                font-family: 'Inter', sans-serif;
            }
            .input-premium {
                width: 100%;
                padding: 11px 16px;
                border: 1px solid #e2e8f0;
                border-radius: 10px;
                font-size: 0.9rem;
                color: #334155;
                background-color: #ffffff;
                transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            }
            .input-premium:focus {
                outline: none;
                border-color: #004d99;
                box-shadow: 0 0 0 4px rgba(0, 77, 153, 0.12);
            }
            .input-premium-disabled {
                background-color: #f8fafc;
                color: #64748b;
                cursor: not-allowed;
                border-color: #e2e8f0;
            }
        </style>
    </head>
    <body class="text-slate-800 antialiased">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <div class="md:pl-64 flex flex-col flex-1 min-h-screen">
            <main class="py-10 px-4 sm:px-6 lg:px-8 max-w-6xl w-full mx-auto">
                <c:if test="${not empty sessionScope.message}">
                    <div id="toastMessageData" class="hidden" data-message="${fn:escapeXml(sessionScope.message)}"></div>
                    <c:remove var="message" scope="session"/>
                </c:if>

                <c:if test="${not empty sessionScope.error}">
                    <div id="toastErrorData" class="hidden" data-message="${fn:escapeXml(sessionScope.error)}"></div>
                    <c:remove var="error" scope="session"/>
                </c:if>
                <div class="mb-8 border-b border-slate-200 pb-5">
                    <h1 class="text-2xl font-bold text-slate-900 tracking-tight sm:text-3xl">Hồ sơ cá nhân</h1>
                    <p class="text-sm text-slate-500 mt-1">Quản lý thông tin định danh và tùy chỉnh tài khoản vận hành trên hệ thống.</p>
                </div>
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8 items-start">
                    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-6 text-center lg:sticky lg:top-6">

                        <h3 class="text-lg font-bold text-slate-900">${fn:escapeXml(account.fullname)}</h3>
                        <p class="text-xs font-mono text-slate-400 mt-0.5">ID: #${account.id}</p>
                        <div class="mt-5 pt-5 border-t border-slate-100 space-y-3 text-left">
                            <div class="flex items-center justify-between text-xs">
                                <span class="text-slate-400 font-medium uppercase tracking-wider">Vai trò:</span>
                                <span class="px-2.5 py-1 bg-blue-50 text-blue-700 font-semibold rounded-md uppercase tracking-wide text-[10px] border border-blue-100">${account.role}</span>
                            </div>
                            <div class="flex items-center justify-between text-xs">
                                <span class="text-slate-400 font-medium uppercase tracking-wider">Hệ thống:</span>
                                <span class="flex items-center gap-1.5 font-semibold text-emerald-700 capitalize">
                                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-500 inline-block animate-pulse"></span>
                                    ${account.status}
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="lg:grid-cols-3 lg:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                        <div class="p-6 sm:p-8">
                            <form action="${pageContext.request.contextPath}/profile" method="post" class="space-y-6">
                                <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                                    <div>
                                        <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Mã định danh (ID)</label>
                                        <input type="text" value="${account.id}" disabled class="input-premium input-premium-disabled font-mono"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Địa chỉ Email</label>
                                        <input type="email" value="${account.email}" disabled class="input-premium input-premium-disabled"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Họ và tên <span class="text-red-500">*</span></label>
                                        <input type="text" name="fullname" value="${fn:escapeXml(account.fullname)}" required class="input-premium" placeholder="Nhập tên đầy đủ"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Số điện thoại <span class="text-red-500">*</span></label>
                                        <input type="text" name="phone" value="${fn:escapeXml(account.phone)}" required class="input-premium" placeholder="Ví dụ: 0912345678"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Quyền hạn tài khoản</label>
                                        <input type="text" value="${account.role}" disabled class="input-premium input-premium-disabled uppercase tracking-wide text-xs font-semibold"/>
                                    </div>
                                    <div>
                                        <label class="block text-xs font-bold text-slate-500 uppercase tracking-wider mb-2">Trạng thái vận hành</label>
                                        <input type="text" value="${account.status}" disabled class="input-premium input-premium-disabled capitalize text-xs font-semibold text-emerald-600"/>
                                    </div>

                                </div>
                                <div class="border-t border-slate-100 pt-5 flex justify-end">
                                    <button type="submit" class="bg-primary hover:bg-primary-dark text-white px-6 py-2.5 rounded-xl font-semibold text-sm shadow-sm transition-all duration-150 hover:shadow active:scale-95 flex items-center gap-2">
                                        <span class="material-symbols-outlined text-sm">save</span>
                                        Cập nhật cấu hình
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