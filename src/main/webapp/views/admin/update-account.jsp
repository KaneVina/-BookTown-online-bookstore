<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <title>Chỉnh sửa tài khoản | BookTown Admin</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            body {
                font-family: 'Inter', sans-serif;
            }
            .glass-card {
                background: rgba(255, 255, 255, 0.8);
                backdrop-filter: blur(8px);
                border: 1px solid rgba(255, 255, 255, 0.3);
            }
        </style>
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "background": "#f3faff",
                            "tertiary-fixed": "#d9e2ff",
                            "on-tertiary": "#ffffff",
                            "inverse-surface": "#1e333c",
                            "surface-container-highest": "#cfe6f2",
                            "warning": "#FFA000",
                            "on-background": "#071e27",
                            "inverse-primary": "#a9c7ff",
                            "success": "#2E7D32",
                            "surface-dim": "#c7dde9",
                            "on-secondary-container": "#705e00",
                            "on-primary-container": "#dae5ff",
                            "surface": "#FFFFFF",
                            "surface-container-high": "#d5ecf8",
                            "on-surface": "#071e27",
                            "surface-container": "#dbf1fe",
                            "primary-fixed-dim": "#a9c7ff",
                            "surface-container-lowest": "#ffffff",
                            "on-surface-variant": "#424752",
                            "surface-container-low": "#e6f6ff",
                            "outline": "#727783",
                            "secondary-container": "#fdd835",
                            "on-primary-fixed": "#001b3d",
                            "error-container": "#ffdad6",
                            "surface-bright": "#f3faff",
                            "background-alt": "#F5F7F9",
                            "on-error": "#ffffff",
                            "on-secondary": "#ffffff",
                            "on-tertiary-container": "#dde5ff",
                            "tertiary-fixed-dim": "#b0c6ff",
                            "primary-container": "#1565c0",
                            "on-primary-fixed-variant": "#00468c",
                            "on-tertiary-fixed": "#001945",
                            "tertiary": "#134aa4",
                            "secondary-fixed-dim": "#e8c41d",
                            "secondary-fixed": "#ffe16e",
                            "surface-variant": "#cfe6f2",
                            "on-error-container": "#93000a",
                            "inverse-on-surface": "#dff4ff",
                            "on-primary": "#ffffff",
                            "secondary": "#705d00",
                            "on-secondary-fixed-variant": "#544600",
                            "tertiary-container": "#3563be",
                            "surface-tint": "#005db7",
                            "on-tertiary-fixed-variant": "#00429c",
                            "on-secondary-fixed": "#221b00",
                            "outline-variant": "#c2c6d4",
                            "primary-fixed": "#d6e3ff",
                            "error": "#D32F2F",
                            "primary": "#004d99"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "stack-md": "24px",
                            "stack-lg": "48px",
                            "gutter": "24px",
                            "base": "8px",
                            "margin-mobile": "16px",
                            "stack-sm": "12px",
                            "margin-desktop": "64px",
                            "container-max": "1280px"
                        },
                        "fontFamily": {
                            "headline-lg": ["Inter"],
                            "body-md": ["Inter"],
                            "label-sm": ["Inter"],
                            "label-md": ["Inter"],
                            "headline-sm": ["Inter"],
                            "body-lg": ["Inter"],
                            "body-sm": ["Inter"],
                            "headline-xl": ["Inter"],
                            "headline-md": ["Inter"]
                        }
                    }
                }
            }
        </script>
    </head>
    <body class="bg-background text-on-surface min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen">
            <div class="max-w-4xl mx-auto py-stack-lg px-margin-mobile">
                <div class="mb-stack-lg flex items-center justify-between">
                    <div>
                        <h2 class="font-headline-lg text-headline-lg text-on-surface">Chỉnh sửa tài khoản</h2>
                        <p class="font-body-md text-body-md text-on-surface-variant">Cập nhật thông tin chi tiết tài khoản.</p>
                    </div>
                </div>

                <div class="space-y-stack-md">
                    <section class="bg-surface p-6 rounded-xl shadow-sm border border-outline-variant/30 overflow-hidden relative">
                        <div class="absolute top-0 left-0 w-full h-24 bg-gradient-to-r from-primary-container to-tertiary-container opacity-10"></div>
                        <div class="relative flex flex-col md:flex-row items-center gap-6 mt-4">
                            <div class="relative group">
                                <img alt="Avatar" class="w-32 h-32 rounded-full object-cover border-4 border-surface shadow-xl" id="avatar-preview" src="https://lh3.googleusercontent.com/aida-public/AB6AXuA4DTH6MMxS_QIhohWmuiZBk3n8M9dbnDLfelwov6hNLbi4gdwXVeZyCX3AjHsoba94aY3_JV2nlWikKgxv3yVj9_E41AZ8Zs2e4QenjQ9w9Tr9CqYO52UJTFEMjvc8geyvDyWQzfRt4Sdio6v3yj_ySGSVLxxvqcoElxOHWBQU9hg4hVi0D2O3URPHKZtxeTtHZ0nuraU7LT7--rxoEUlHAEsYy0TNHz_pSPy3AHQj7BFHEfKlBnkpaZ9FPtoCxXxpHMxnp_aKytJQ"/>
                                <label class="absolute inset-0 flex items-center justify-center bg-black/40 rounded-full opacity-0 group-hover:opacity-100 transition-opacity cursor-pointer" for="avatar-upload">
                                    <span class="material-symbols-outlined text-white text-3xl">photo_camera</span>
                                </label>
                                <input accept="image/*" class="hidden" id="avatar-upload" type="file"/>
                            </div>
                            <div class="text-center md:text-left flex-grow">
                                <h3 class="font-headline-md text-headline-md text-on-surface">Nguyễn Văn An</h3>
                                <div class="flex flex-wrap justify-center md:justify-start gap-2 mt-2">
                                    <span class="px-3 py-1 bg-surface-container-highest text-primary font-label-sm rounded-full flex items-center gap-1">
                                        <span class="material-symbols-outlined text-[16px]">verified</span> Quản lý đơn hàng
                                    </span>
                                    <span class="px-3 py-1 bg-green-100 text-success font-label-sm rounded-full flex items-center gap-1">
                                        <span class="w-2 h-2 rounded-full bg-success"></span> Đang hoạt động
                                    </span>
                                </div>
                            </div>
                        </div>
                    </section>

                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-gutter">
                        <section class="bg-surface p-6 rounded-xl shadow-sm border border-outline-variant/30 space-y-4">
                            <div class="flex items-center gap-2 mb-2">
                                <span class="material-symbols-outlined text-primary">person</span>
                                <h4 class="font-headline-sm text-headline-sm">Thông tin cá nhân</h4>
                            </div>
                            <div class="space-y-4">
                                <div>
                                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1.5">Họ và tên</label>
                                    <input class="w-full h-12 bg-surface border border-outline-variant rounded-lg px-4 focus:ring-2 focus:ring-primary-container focus:border-primary outline-none transition-all" type="text" value="Nguyễn Văn An"/>
                                </div>
                                <div>
                                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1.5">Địa chỉ Email</label>
                                    <input class="w-full h-12 bg-surface border border-outline-variant rounded-lg px-4 focus:ring-2 focus:ring-primary-container focus:border-primary outline-none transition-all" type="email" value="an.nguyen@booktown.com"/>
                                </div>
                                <div>
                                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1.5">Số điện thoại</label>
                                    <input class="w-full h-12 bg-surface border border-outline-variant rounded-lg px-4 focus:ring-2 focus:ring-primary-container focus:border-primary outline-none transition-all" type="tel" value="0987 654 321"/>
                                </div>
                                <div>
                                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1.5">Tiểu sử / Ghi chú</label>
                                    <textarea class="w-full bg-surface border border-outline-variant rounded-lg p-4 focus:ring-2 focus:ring-primary-container focus:border-primary outline-none transition-all resize-none" rows="3">Quản trị viên bộ phận Kinh doanh, chịu trách nhiệm chính về mảng sách Văn học nước ngoài.</textarea>
                                </div>
                            </div>
                        </section>

                        <section class="bg-surface p-6 rounded-xl shadow-sm border border-outline-variant/30 space-y-4">
                            <div class="flex items-center gap-2 mb-2">
                                <span class="material-symbols-outlined text-primary">settings_applications</span>
                                <h4 class="font-headline-sm text-headline-sm">Cài đặt tài khoản</h4>
                            </div>
                            <div class="space-y-4">
                                <div>
                                    <label class="block font-label-md text-label-md text-on-surface-variant mb-1.5">Vai trò hệ thống</label>
                                    <select class="w-full h-12 bg-surface border border-outline-variant rounded-lg px-4 focus:ring-2 focus:ring-primary-container focus:border-primary outline-none transition-all appearance-none cursor-pointer">
                                        <option>Admin</option>
                                        <option selected="">Staff</option>
                                        <option>khách hàng</option>
                                    </select>
                                </div>
                            </div>

                            <div class="pt-stack-md border-t border-outline-variant mt-4 space-y-4">
                                <div class="flex items-center justify-between p-3 bg-surface-container-low rounded-lg">
                                    <div>
                                        <p class="font-label-md text-label-md text-on-surface">Trạng thái hoạt động</p>
                                        <p class="font-body-sm text-body-sm text-on-surface-variant">Cho phép tài khoản truy cập hệ thống</p>
                                    </div>
                                    <label class="relative inline-flex items-center cursor-pointer">
                                        <input checked="" class="sr-only peer" type="checkbox"/>
                                        <div class="w-11 h-6 bg-outline-variant peer-focus:outline-none rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-primary"></div>
                                    </label>
                                </div>
                                <div class="flex items-center justify-between gap-4">
                                    <button class="flex-1 flex items-center justify-center gap-2 h-12 border border-error text-error font-label-md rounded-lg hover:bg-error/10 transition-colors">
                                        <span class="material-symbols-outlined">lock</span> Khóa tài khoản
                                    </button>
                                    <button class="flex-1 flex items-center justify-center gap-2 h-12 border border-primary text-primary font-label-md rounded-lg hover:bg-primary/10 transition-colors">
                                        <span class="material-symbols-outlined">key</span> Đặt lại mật khẩu
                                    </button>
                                </div>
                            </div>
                        </section>
                    </div>
                </div>

                <div class="mt-stack-lg pt-6 border-t border-outline-variant flex items-center justify-end gap-4">
                    <button class="px-8 py-3 rounded-lg text-on-surface-variant font-label-md hover:bg-surface-container-low transition-colors">Đặt lại các thay đổi</button>
                    <div class="flex gap-2">
                        <button class="px-8 py-3 rounded-lg border border-primary text-primary font-label-md hover:bg-surface-container transition-colors">Hủy</button>
                        <button class="px-10 py-3 rounded-lg bg-primary text-on-primary font-label-md shadow-lg shadow-primary/20 hover:bg-primary-container hover:shadow-xl transition-all active:scale-95">Lưu thay đổi</button>
                    </div>
                </div>
            </div>
        </main>

        <script>
            // Micro-interaction preview ảnh đại diện
            const avatarUpload = document.getElementById('avatar-upload');
            const avatarPreview = document.getElementById('avatar-preview');

            avatarUpload.addEventListener('change', function (e) {
                const file = e.target.files[0];
                if (file) {
                    const reader = new FileReader();
                    reader.onload = function (e) {
                        avatarPreview.src = e.target.result;
                    }
                    reader.readAsDataURL(file);
                }
            });

            // Hiệu ứng hover cho các nút bấm
            const buttons = document.querySelectorAll('button');
            buttons.forEach(btn => {
                btn.addEventListener('mouseenter', () => {
                    if (!btn.classList.contains('active:scale-95'))
                        return;
                    btn.classList.add('scale-[1.02]');
                });
                btn.addEventListener('mouseleave', () => {
                    btn.classList.remove('scale-[1.02]');
                });
            });
        </script>
    </body>
</html>