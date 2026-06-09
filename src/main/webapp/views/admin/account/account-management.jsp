<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Quản lý Khách hàng - BookTown</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">

        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "on-tertiary-fixed-variant": "#00429c",
                            "secondary-fixed-dim": "#e8c41d",
                            "tertiary": "#134aa4",
                            "primary": "#004d99",
                            "warning": "#FFA000",
                            "surface-container-highest": "#cfe6f2",
                            "surface-dim": "#c7dde9",
                            "tertiary-fixed-dim": "#b0c6ff",
                            "surface-container-lowest": "#ffffff",
                            "error-container": "#ffdad6",
                            "on-primary-fixed-variant": "#00468c",
                            "inverse-surface": "#1e333c",
                            "surface-variant": "#cfe6f2",
                            "on-primary": "#ffffff",
                            "on-tertiary": "#ffffff",
                            "surface-bright": "#f3faff",
                            "secondary-fixed": "#ffe16e",
                            "surface-container": "#dbf1fe",
                            "secondary": "#705d00",
                            "on-tertiary-fixed": "#001945",
                            "outline": "#727783",
                            "surface": "#FFFFFF",
                            "tertiary-container": "#3563be",
                            "primary-fixed": "#d6e3ff",
                            "on-tertiary-container": "#dde5ff",
                            "on-secondary": "#ffffff",
                            "primary-container": "#1565c0",
                            "on-secondary-fixed-variant": "#544600",
                            "on-background": "#071e27",
                            "inverse-primary": "#a9c7ff",
                            "on-primary-container": "#dae5ff",
                            "background": "#f3faff",
                            "surface-container-low": "#e6f6ff",
                            "background-alt": "#F5F7F9",
                            "on-error-container": "#93000a",
                            "secondary-container": "#fdd835",
                            "surface-tint": "#005db7",
                            "success": "#2E7D32",
                            "inverse-on-surface": "#dff4ff",
                            "tertiary-fixed": "#d9e2ff",
                            "on-secondary-fixed": "#221b00",
                            "surface-container-high": "#d5ecf8",
                            "on-error": "#ffffff",
                            "on-primary-fixed": "#001b3d",
                            "error": "#D32F2F",
                            "on-secondary-container": "#705e00",
                            "primary-fixed-dim": "#a9c7ff",
                            "on-surface-variant": "#424752",
                            "on-surface": "#071e27",
                            "outline-variant": "#c2c6d4"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "container-max": "1280px",
                            "stack-lg": "48px",
                            "gutter": "24px",
                            "stack-md": "24px",
                            "margin-desktop": "64px",
                            "base": "8px",
                            "stack-sm": "12px",
                            "margin-mobile": "16px"
                        },
                        "fontFamily": {
                            "headline-lg-mobile": ["Inter"],
                            "label-md": ["Inter"],
                            "headline-xl": ["Inter"],
                            "headline-sm": ["Inter"],
                            "headline-md": ["Inter"],
                            "headline-lg": ["Inter"],
                            "body-sm": ["Inter"],
                            "label-sm": ["Inter"],
                            "body-md": ["Inter"],
                            "body-lg": ["Inter"]
                        },
                        "fontSize": {
                            "headline-lg-mobile": ["28px", {"lineHeight": "36px", "fontWeight": "700"}],
                            "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.01em", "fontWeight": "600"}],
                            "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                            "headline-sm": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                            "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                            "headline-lg": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                            "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                            "label-sm": ["12px", {"lineHeight": "16px", "fontWeight": "500"}],
                            "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                            "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}]
                        }
                    },
                },
            }
        </script>
        <style>
            body {
                font-family: 'Inter', sans-serif;
            }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                vertical-align: middle;
            }
            .custom-scrollbar::-webkit-scrollbar {
                width: 6px;
            }
            .custom-scrollbar::-webkit-scrollbar-track {
                background: transparent;
            }
            .custom-scrollbar::-webkit-scrollbar-thumb {
                background: #cbd5e1;
                border-radius: 10px;
            }
        </style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">

        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen">
            <div class="p-gutter max-w-container-max mx-auto space-y-stack-lg">
                <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
                    <div>
                        <h2 class="font-headline-lg text-headline-lg text-on-background">Quản lý Khách hàng</h2>
                        <p class="font-body-md text-body-md text-on-surface-variant">Xem và quản lý tải khoản của BookTown.</p>
                    </div>
                </div>
                <div class="grid grid-cols-1 md:grid-cols-4 gap-6">
                    <div class="bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-2">
                        <span class="text-primary font-label-md">Tổng khách hàng</span>
                        <div class="flex items-baseline gap-2">
                            <span class="text-3xl font-bold">12,482</span>
                            <span class="text-success text-xs font-bold">+12%</span>
                        </div>
                        <span class="text-on-surface-variant text-xs">Từ tháng trước</span>
                    </div>
                    <div class="bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-2">
                        <span class="text-primary font-label-md">Voucher</span>
                        <div class="flex items-baseline gap-2">
                            <span class="text-3xl font-bold">843</span>
                        </div>
                        <span class="text-on-surface-variant text-xs">7% tổng số</span>
                    </div>
                    <div class="bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-2 border-l-4 border-secondary-container">
                        <span class="text-primary font-label-md">Đơn hàng trung bình</span>
                        <div class="flex items-baseline gap-2">
                            <span class="text-3xl font-bold">4.2</span>
                            <span class="text-on-surface-variant text-xs">đơn/năm</span>
                        </div>
                        <span class="text-on-surface-variant text-xs">Dựa trên 12 tháng qua</span>
                    </div>
                    <div class="bg-surface p-6 rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] flex flex-col gap-2">
                        <span class="text-primary font-label-md">Tỷ lệ hoạt động</span>
                        <div class="flex items-baseline gap-2">
                            <span class="text-3xl font-bold">89%</span>
                            <span class="material-symbols-outlined text-success text-sm">trending_up</span>
                        </div>
                        <span class="text-on-surface-variant text-xs">Thanh toán trong 30 ngày</span>
                    </div>
                </div>
                <div class="bg-surface rounded-2xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] overflow-hidden border border-outline-variant/30">
                    <div class="p-6 border-b border-outline-variant/30">
                        <div class="flex flex-col lg:flex-row gap-4 justify-between">
                            <div>
                                <h3 class="font-headline-sm text-headline-sm">
                                    Quản lý tài khoản
                                </h3>
                                <p class="text-sm text-on-surface-variant">
                                    Tìm kiếm và lọc tài khoản trong hệ thống
                                </p>
                            </div>
                            <a href="${pageContext.request.contextPath}/dashboard/add-staff"
                               class="bg-primary text-white px-5 py-3 rounded-xl flex items-center gap-2 hover:opacity-90">
                                <span class="material-symbols-outlined">
                                    person_add
                                </span>
                                Thêm tài khoản
                            </a>
                        </div>
                    </div>
                    <div class="p-6 border-b border-outline-variant/30">
                        <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                            <div class="md:col-span-2 relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant">
                                    search
                                </span>
                                <input
                                    type="text"
                                    placeholder="Tìm kiếm theo tên hoặc email..."
                                    class="w-full pl-11 pr-4 py-3 border border-outline-variant rounded-xl focus:ring-2 focus:ring-primary focus:border-primary">
                            </div>
                            <select class="px-4 py-3 border border-outline-variant rounded-xl focus:ring-2 focus:ring-primary">
                                <option>Tất cả vai trò</option>
                                <option>Admin</option>
                                <option>Staff</option>
                                <option>Customer</option>
                            </select>
                            <select class="px-4 py-3 border border-outline-variant rounded-xl focus:ring-2 focus:ring-primary">
                                <option>Tất cả trạng thái</option>
                                <option>Hoạt động</option>
                                <option>Đã khóa</option>
                            </select>
                        </div>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-background-alt">
                                    <th class="px-6 py-4">Tài khoản</th>
                                    <th class="px-6 py-4">Vai trò</th>
                                    <th class="px-6 py-4">Trạng thái</th>
                                    <th class="px-6 py-4 text-right">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant/20">
                                <c:forEach items="${customers}" var="c">
                                    <tr class="hover:bg-surface-container-low">
                                        <td class="px-6 py-4">
                                            <div class="font-medium">${c.fullname}</div>
                                            <div class="text-xs text-on-surface-variant">${c.email}</div>
                                        </td>
                                        <td class="px-6 py-4">
                                            <span class="px-3 py-1 rounded-full bg-secondary-container text-secondary text-xs font-bold">
                                                Customer
                                            </span>
                                        </td>
                                        <td class="px-6 py-4">
                                            <c:choose>
                                                <c:when test="${c.status == 'active'}">
                                                    <span class="status-text text-success">Hoạt động</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-text text-error">Đã khóa</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="px-6 py-4 text-right">
                                            <a href="${pageContext.request.contextPath}/dashboard/account-detail" class="text-primary">
                                                <span class="material-symbols-outlined">edit</span>
                                            </a>

                                            <form method="post"
                                                  class="toggle-form inline"
                                                  data-url="${pageContext.request.contextPath}/dashboard/account-management">
                                                <input type="hidden" name="action" value="toggleCustomer">
                                                <input type="hidden" name="id" value="${c.customerID}">
                                                <input type="hidden" name="status"
                                                       value="${c.status == 'active' ? 'inactive' : 'active'}">
                                                <button type="submit" class="text-warning ml-2">
                                                    <span class="material-symbols-outlined">
                                                        ${c.status == 'active' ? 'lock' : 'lock_open'}
                                                    </span>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${not empty staffs}">
                                    <c:forEach items="${staffs}" var="s">
                                        <tr class="hover:bg-surface-container-low">
                                            <td class="px-6 py-4">
                                                <div class="font-medium">${s.fullname}</div>
                                                <div class="text-xs text-on-surface-variant">${s.email}</div>
                                            </td>
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${s.role == 'admin'}">
                                                        <span class="px-3 py-1 rounded-full bg-error-container text-error text-xs font-bold">Admin</span>
                                                    </c:when>
                                                    <c:when test="${s.role == 'staff'}">
                                                        <span class="px-3 py-1 rounded-full bg-primary-fixed text-primary text-xs font-bold">Staff</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-3 py-1 rounded-full bg-secondary-container text-secondary text-xs font-bold">${s.role}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4">
                                                <c:choose>
                                                    <c:when test="${s.status == 'active'}">
                                                        <%-- FIX: thêm class status-text để JS cập nhật được --%>
                                                        <span class="status-text text-success">Hoạt động</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-text text-error">Đã khóa</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-4 text-right">
                                                <a href="${pageContext.request.contextPath}/dashboard/update-account?id=${s.id}" class="text-primary">
                                                    <span class="material-symbols-outlined">edit</span>
                                                </a>

                                                <c:if test="${s.role ne 'admin'}">
                                                    <form method="post"
                                                          class="toggle-form inline"
                                                          data-url="${pageContext.request.contextPath}/dashboard/account-management">
                                                        <input type="hidden" name="action" value="toggleStaff">
                                                        <input type="hidden" name="id" value="${s.id}">
                                                        <input type="hidden" name="status"
                                                               value="${s.status == 'active' ? 'inactive' : 'active'}">
                                                        <button type="submit" class="text-warning ml-2">
                                                            <span class="material-symbols-outlined">
                                                                ${s.status == 'active' ? 'lock' : 'lock_open'}
                                                            </span>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:if>

                            </tbody>
                        </table>
                    </div>
                    <%@ include file="/views/layout/common/pagination.jsp" %>
                </div>
            </div>
        </main>

        <script>
            document.querySelectorAll(".toggle-form").forEach(form => {
                form.addEventListener("submit", async function (e) {
                    e.preventDefault();

                    const row = this.closest("tr");
                    const statusText = row.querySelector(".status-text");
                    // FIX: lấy icon từ button trong form, không phải từ form.action
                    const icon = this.querySelector(".material-symbols-outlined");

                    const isActive = statusText.textContent.trim() === "Hoạt động";
                    const confirmMsg = isActive
                        ? "Bạn có chắc muốn KHÓA tài khoản này?"
                        : "Bạn có chắc muốn MỞ khóa tài khoản này?";

                    if (!confirm(confirmMsg)) return;

                    const formData = new FormData(this);

                    try {
                        // FIX: dùng data-url thay vì this.action để tránh lấy nhầm input[name="action"]
                        const url = this.dataset.url;
                        const response = await fetch(url, {
                            method: "POST",
                            body: formData
                        });

                        const text = await response.text();
                        let result;
                        try {
                            result = JSON.parse(text);
                        } catch (parseErr) {
                            console.error("Server không trả JSON:", text);
                            return;
                        }

                        if (result.success) {
                            if (isActive) {
                                icon.textContent = "lock";
                                statusText.textContent = "Đã khóa";
                                statusText.classList.replace("text-success", "text-error");
                                this.querySelector("input[name='status']").value = "active"; // lần sau mở khóa
                            } else {
                                icon.textContent = "lock_open";
                                statusText.textContent = "Hoạt động";
                                statusText.classList.replace("text-error", "text-success");
                                this.querySelector("input[name='status']").value = "inactive"; // lần sau khóa lại
                            }
                        }

                    } catch (error) {
                        console.error("Fetch error:", error);
                    }
                });
            });
        </script>
    </body>
</html>
