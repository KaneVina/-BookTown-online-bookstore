<%-- 
    Document   : profile
    Created on : May 29, 2026, 6:36:03 PM
    Author     : Trương Trân
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

        <script>
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            primary: "#17479D",
                            "primary-dark": "#0D47A1",
                            "primary-light": "#1976D2",
                            secondary: "#FDD835",

                            background: "#f3faff",
                            surface: "#FFFFFF",
                            "on-surface": "#222222",

                            success: "#2E7D32",
                            warning: "#FFA000",
                            error: "#D32F2F",

                            "outline-variant": "#c2c6d4",
                            "surface-variant": "#cfe6f2",
                            "surface-container-low": "#e6f6ff",
                            "surface-container": "#dbf1fe",
                            "on-surface-variant": "#424752",
                            "secondary-container": "#fdd835",
                            "on-secondary-container": "#705e00"
                        },
                        fontFamily: {
                            sans: ["Inter", "sans-serif"]
                        },
                        spacing: {
                            gutter: "24px", "stack-lg": "48px",
                            "margin-desktop": "64px", "container-max": "1280px"
                        }
                    }
                }
            }

        </script>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            .active-nav-border {
                border-bottom: 2px solid #004d99;
            }
            body {
                background-color: #f3faff;
                font-family: 'Inter', sans-serif;
            }
        </style>
    </head>
    <body class="text-on-background">
        <main class="max-w-container-max mx-auto px-margin-desktop py-stack-lg flex gap-gutter">
            <aside class="w-72 flex-shrink-0">
                <div class="bg-surface rounded-xl p-6 shadow-sm border border-surface-variant">
                    <div class="flex flex-col items-center mb-8">
                        <div class="relative group cursor-pointer">
                            <div class="w-24 h-24 rounded-full overflow-hidden border-4 border-primary-container shadow-md">
                                <img alt="Profile large avatar" class="w-full h-full object-cover" src="${not empty user.avatarUrl ? user.avatarUrl : 'https://lh3.googleusercontent.com/aida-public/AB6AXuA14CZKDst5uqiMXHoDhwGQfznU1jyQzJIT5NwVfGKTs6CWTQ3kJjsI4cXq5cdYagUtBuhkOnquaRS3pbK4DTDsi7Gm32LQGG-r7biyyLwNIFJ1q-lLV41QuaOVfEE92QLtCuNcXwXtSphF2LzsX2UEi8siOV6AvCI_FfqqiK0K165iNpsg7ps6nHcBGaXjBWK4MReO2M4MgB-UwzMJw47RJc_z7MXPYsCLgZvxRZmO6e3dTnrvxkVCLokHBN0yHdrg6o2mRZ_uXA8w'}"/>
                            </div>
                            <div class="absolute bottom-0 right-0 bg-primary text-white p-1.5 rounded-full shadow-lg">
                                <span class="material-symbols-outlined text-[18px]" style="font-variation-settings: 'FILL' 1;">edit</span>
                            </div>
                        </div>
                        <h2 class="mt-4 font-headline-sm text-headline-sm text-on-surface">${not empty user.fullName ? user.fullName : 'Trương Ngọc Trân'}</h2>
                        <div class="mt-1 px-3 py-0.5 bg-secondary-container text-on-secondary-container rounded-full text-label-sm font-label-sm flex items-center gap-1">
                            <span class="material-symbols-outlined text-[14px]" style="font-variation-settings: 'FILL' 1;">stars</span>
                            ${not empty user.membership ? user.membership : 'Thành viên Vàng'}
                        </div>
                    </div>
                    <nav class="space-y-1">
                        <a class="nav-item group flex items-center gap-3 px-4 py-3 rounded-lg bg-primary-container text-primary font-label-md text-label-md transition-all active-nav" href="#thong-tin" onclick="switchTab('thong-tin')">
                            <span class="material-symbols-outlined text-[20px]" data-weight="fill" style="font-variation-settings: 'FILL' 1;">person</span>
                            Thông tin cá nhân
                        </a>
                        <a class="nav-item group flex items-center gap-3 px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-low font-label-md text-label-md transition-all" href="#doi-mat-khau" onclick="switchTab('doi-mat-khau')">
                            <span class="material-symbols-outlined text-[20px]">lock</span>
                            Đổi mật khẩu
                        </a>
                        <a class="group flex items-center gap-3 px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-low font-label-md text-label-md transition-all" href="#">
                            <span class="material-symbols-outlined text-[20px]">location_on</span>
                            Sổ địa chỉ
                        </a>
                        <a href="${pageContext.request.contextPath}/order-history"class="group flex items-center gap-3 px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-low font-label-md text-label-md transition-all" href="#">
                            <span class="material-symbols-outlined text-[20px]">history</span>
                            Lịch sử đơn hàng
                        </a>
                        <hr class="my-4 border-outline-variant opacity-30"/>
                        <a class="group flex items-center gap-3 px-4 py-3 rounded-lg text-error hover:bg-error-container/10 font-label-md text-label-md transition-all" href="${pageContext.request.contextPath}/logout">
                            <span class="material-symbols-outlined text-[20px]">logout</span>
                            Đăng xuất
                        </a>
                    </nav>
                </div>
            </aside>

            <section class="flex-1 space-y-gutter">
                <div class="content-section bg-surface rounded-xl p-8 shadow-sm border border-surface-variant" id="section-thong-tin">
                    <div class="flex items-center justify-between mb-8">
                        <div>
                            <h1 class="font-headline-md text-headline-md text-on-surface">Thông tin cá nhân</h1>
                            <p class="font-body-sm text-body-sm text-on-surface-variant mt-1">Quản lý thông tin hồ sơ của bạn để bảo mật tài khoản</p>
                        </div>
                    </div>
                    <form action="${pageContext.request.contextPath}/update-profile" method="POST" class="grid grid-cols-2 gap-x-gutter gap-y-6">
                        <div class="col-span-2 md:col-span-1">
                            <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Họ tên</label>
                            <input name="fullName" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all font-body-md text-body-md" type="text" value="${user.fullName}"/>
                        </div>
                        <div class="col-span-2 md:col-span-1">
                            <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Email</label>
                            <input class="w-full px-4 py-3 bg-background-alt border border-outline-variant rounded-lg outline-none font-body-md text-body-md text-on-surface-variant cursor-not-allowed" disabled="" type="email" value="${user.email}"/>
                        </div>
                        <div class="col-span-2 md:col-span-1">
                            <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Số điện thoại</label>
                            <input name="phone" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all font-body-md text-body-md" type="tel" value="${user.phone}"/>
                        </div>
                        <div class="col-span-2 md:col-span-1">
                            <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Ngày sinh</label>
                            <input name="birthDate" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all font-body-md text-body-md" type="date" value="${user.birthDate}"/>
                        </div>
                        <div class="col-span-2">
                            <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Giới tính</label>
                            <div class="flex gap-8">
                                <label class="flex items-center gap-2 cursor-pointer group">
                                    <input name="gender" value="Nam" ${user.gender == 'Nam' ? 'checked' : ''} class="w-5 h-5 text-primary border-outline focus:ring-primary" type="radio"/>
                                    <span class="font-body-md text-body-md text-on-surface">Nam</span>
                                </label>
                                <label class="flex items-center gap-2 cursor-pointer group">
                                    <input name="gender" value="Nữ" ${user.gender == 'Nữ' ? 'checked' : ''} class="w-5 h-5 text-primary border-outline focus:ring-primary" type="radio"/>
                                    <span class="font-body-md text-body-md text-on-surface">Nữ</span>
                                </label>
                                <label class="flex items-center gap-2 cursor-pointer group">
                                    <input name="gender" value="Khác" ${user.gender == 'Khác' ? 'checked' : ''} class="w-5 h-5 text-primary border-outline focus:ring-primary" type="radio"/>
                                    <span class="font-body-md text-body-md text-on-surface">Khác</span>
                                </label>
                            </div>
                        </div>
                        <div class="col-span-2 mt-4 pt-6 border-t border-surface-variant">
                            <button class="px-8 py-3 bg-primary text-white rounded-lg font-label-md text-label-md hover:shadow-lg active:scale-95 transition-all" type="submit">
                                Lưu thay đổi
                            </button>
                        </div>
                    </form>
                </div>

                <div class="content-section bg-surface rounded-xl p-8 shadow-sm border border-surface-variant" id="section-doi-mat-khau">
                    <div class="mb-8">
                        <h1 class="font-headline-md text-headline-md text-on-surface">Đổi mật khẩu</h1>
                        <p class="font-body-sm text-body-sm text-on-surface-variant mt-1">Để bảo mật tài khoản, vui lòng không chia sẻ mật khẩu cho người khác</p>
                    </div>
                    <form action="${pageContext.request.contextPath}/change-password" method="POST" class="max-w-md space-y-6">
                        <div>
                            <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Mật khẩu hiện tại</label>
                            <div class="relative">
                                <input name="currentPassword" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all font-body-md text-body-md" placeholder="Nhập mật khẩu hiện tại" type="password"/>
                                <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-outline cursor-pointer hover:text-primary">visibility_off</span>
                            </div>
                        </div>
                        <div>
                            <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Mật khẩu mới</label>
                            <div class="relative">
                                <input name="newPassword" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all font-body-md text-body-md" placeholder="Nhập mật khẩu mới" type="password"/>
                                <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-outline cursor-pointer hover:text-primary">visibility_off</span>
                            </div>
                            <p class="mt-2 text-[12px] text-on-surface-variant font-body-sm italic">Mật khẩu phải từ 8-20 ký tự, bao gồm chữ cái và số.</p>
                        </div>
                        <div>
                            <label class="block font-label-md text-label-md text-on-surface-variant mb-2">Xác nhận mật khẩu mới</label>
                            <div class="relative">
                                <input name="confirmPassword" class="w-full px-4 py-3 bg-white border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-transparent outline-none transition-all font-body-md text-body-md" placeholder="Xác nhận lại mật khẩu mới" type="password"/>
                                <span class="material-symbols-outlined absolute right-3 top-1/2 -translate-y-1/2 text-outline cursor-pointer hover:text-primary">visibility_off</span>
                            </div>
                        </div>
                        <div class="pt-4">
                            <button class="w-full px-8 py-3 bg-primary text-white rounded-lg font-label-md text-label-md hover:shadow-lg active:scale-95 transition-all" type="submit">
                                Cập nhật mật khẩu
                            </button>
                        </div>
                    </form>
                </div>
            </section>
        </main>

        <script>
            function switchTab(tabId) {
                const navItems = document.querySelectorAll('.nav-item');
                navItems.forEach(item => {
                    item.classList.remove('bg-primary-container', 'text-primary');
                    item.classList.add('text-on-surface-variant', 'hover:bg-surface-container-low');
                    const icon = item.querySelector('.material-symbols-outlined');
                    if (icon)
                        icon.style.fontVariationSettings = "'FILL' 0";
                });

                const activeItem = document.querySelector(`a[href="#${tabId}"]`);
                if (activeItem) {
                    activeItem.classList.add('bg-primary-container', 'text-primary');
                    activeItem.classList.remove('text-on-surface-variant', 'hover:bg-surface-container-low');
                    const activeIcon = activeItem.querySelector('.material-symbols-outlined');
                    if (activeIcon)
                        activeIcon.style.fontVariationSettings = "'FILL' 1";
                }

                const target = document.getElementById(`section-${tabId}`);
                if (target) {
                    target.scrollIntoView({behavior: 'smooth', block: 'center'});
                    target.classList.add('ring-2', 'ring-primary/20');
                    setTimeout(() => target.classList.remove('ring-2', 'ring-primary/20'), 1500);
                }
            }

            window.addEventListener('DOMContentLoaded', () => {
                const hash = window.location.hash.replace('#', '') || 'thong-tin';
                switchTab(hash);
            });
        </script>
    </body>
</html>

<%@ include file="/views/layout/homepage/footer.jsp" %>

