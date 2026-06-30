<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đổi mật khẩu</title>
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
            .sidebar-sticky {
                position: sticky;
                top: 24px;
            }
            .input-premium {
                width: 100%;
                height: 52px;
                padding: 0 20px;
                border: 2px solid #e2e8f0;
                border-radius: 12px !important;
                transition: .3s;
            }
            .input-premium:focus {
                outline: none;
                border-color: #004d99;
                box-shadow: 0 0 0 4px rgba(0,77,153,.15);
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
            .btn-submit:hover {
                transform: translateY(-2px);
            }
            .btn-submit:disabled {
                opacity: .6;
                cursor: not-allowed;
            }
            .info-card {
                background: #f8fafc;
                padding: 16px;
                border-radius: 12px;
                border: 1px solid #e2e8f0;
            }
            .info-label {
                font-size: .75rem;
                color: #64748b;
                font-weight: 700;
                margin-bottom: 6px;
                text-transform: uppercase;
            }
            .info-value {
                font-weight: 600;
                color: #1e293b;
            }
            .separator {
                border-top: 2px solid #e2e8f0;
                margin: 24px 0;
            }
            .badge-status {
                display: flex;
                align-items: center;
                gap: 8px;
                font-weight: 600;
            }
            .status-dot {
                width: 8px;
                height: 8px;
                background: #10b981;
                border-radius: 50%;
            }
        </style>
    </head>

    <body class="text-slate-800">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <div class="md:pl-64 flex flex-col flex-1 min-h-screen">
            <main class="py-12 px-4 sm:px-6 lg:px-8 max-w-7xl w-full mx-auto">
                <div class="mb-10">
                    <h1 class="text-4xl font-bold text-slate-900">
                        Đổi mật khẩu
                    </h1>
                    <p class="text-slate-600 mt-2">
                        Cập nhật mật khẩu để tăng cường bảo mật tài khoản.
                    </p>
                </div>
                <div class="lg:col-span-2">
                    <div class="card-modern p-8 sm:p-10">
                        <form id="changePasswordForm" class="space-y-6">
                            <div>
                                <label class="form-label-modern">
                                    Mật khẩu hiện tại <span>*</span>
                                </label>
                                <div class="relative">
                                    <input
                                        type="password"
                                        id="currentPassword"
                                        name="currentPassword"
                                        required
                                        class="input-premium"
                                        placeholder="Nhập mật khẩu hiện tại">
                                    <button
                                        type="button"
                                        onclick="togglePassword('currentPassword', this)"
                                        class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-700">

                                        <span class="material-symbols-outlined">
                                            visibility
                                        </span>
                                    </button>
                                </div>
                            </div>
                            <div>
                                <label class="form-label-modern">
                                    Mật khẩu mới <span>*</span>
                                </label>
                                <div class="relative">
                                    <input
                                        type="password"
                                        id="newPassword"
                                        name="newPassword"
                                        required
                                        class="input-premium"
                                        placeholder="Ví dụ: Pass@1234">
                                    <button
                                        type="button"
                                        onclick="togglePassword('newPassword', this)"
                                        class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-700">

                                        <span class="material-symbols-outlined">
                                            visibility
                                        </span>
                                    </button>
                                </div>
                            </div>
                            <div>
                                <label class="form-label-modern">
                                    Xác nhận mật khẩu mới <span>*</span>
                                </label>
                                <div class="relative">
                                    <input
                                        type="password"
                                        id="confirmPassword"
                                        name="confirmPassword"
                                        required
                                        class="input-premium"
                                        placeholder="Nhập lại mật khẩu mới">
                                    <button
                                        type="button"
                                        onclick="togglePassword('confirmPassword', this)"
                                        class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-700">

                                        <span class="material-symbols-outlined">
                                            visibility
                                        </span>
                                    </button>
                                </div>
                            </div>
                            <div class="bg-blue-50 border border-blue-200 rounded-xl p-4">
                                <p class="text-sm text-blue-700">
                                    Mật khẩu phải từ 8 - 15 ký tự,
                                    gồm chữ hoa, chữ thường, số
                                    và ký tự đặc biệt.
                                </p>
                            </div>
                            <div class="flex justify-end gap-3">

                                <a href="${pageContext.request.contextPath}/profile" class="px-6 py-3 border border-slate-300 rounded-full font-semibold hover:bg-slate-50">
                                    Quay lại
                                </a>
                                <button type="submit" id="changeBtn" class="btn-submit">
                                    <span class="material-symbols-outlined">
                                        lock
                                    </span>

                                    Đổi mật khẩu
                                </button>
                            </div>

                        </form>
                    </div>
                </div>
            </main>
        </div>
        <%@ include file="/views/layout/common/toast.jsp" %>

        <script>
            function togglePassword(inputId, button) {
                const input = document.getElementById(inputId);
                const icon = button.querySelector("span");
                if (input.type === "password") {

                    input.type = "text";
                    icon.textContent = "visibility_off";
                } else {
                    input.type = "password";
                    icon.textContent = "visibility";
                }
            }
            document.getElementById("changePasswordForm")
                    .addEventListener("submit", async function (e) {
                        e.preventDefault();
                        const btn = document.getElementById("changeBtn");
                        btn.disabled = true;

                        const newPassword = document.getElementById("newPassword").value;
                        const confirmPassword = document.getElementById("confirmPassword").value;

                        if (newPassword !== confirmPassword) {
                            showToast("Xác nhận mật khẩu không khớp", true);
                            btn.disabled = false;
                            return;
                        }

                        const formData = new URLSearchParams();

                        formData.append("currentPassword", document.getElementById("currentPassword").value);
                        formData.append("newPassword", document.getElementById("newPassword").value);
                        formData.append("confirmPassword", document.getElementById("confirmPassword").value);
                        try {
                            const response = await fetch("${pageContext.request.contextPath}/change-password",
                                    {
                                        method: "POST",
                                        headers: {
                                            "Content-Type": "application/x-www-form-urlencoded"
                                        },
                                        body: formData.toString()
                                    }
                            );
                            const data = await response.json();
                            if (data.success) {
                                showToast(data.message);
                                document
                                        .getElementById("changePasswordForm")
                                        .reset();
                                setTimeout(() => {
                                    window.location.href =
                                            "${pageContext.request.contextPath}/profile";
                                }, 1500);
                            } else {
                                showToast(data.message, true);
                            }
                        } catch (e) {
                            showToast("Lỗi kết nối server", true);
                        }
                        btn.disabled = false;
                    });
        </script>

    </body>
</html>
