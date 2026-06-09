<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <title>BookTown Admin - Thêm nhân viên mới</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "on-tertiary-fixed-variant": "#00429c",
                            "background-alt": "#F5F7F9",
                            "on-secondary-container": "#705e00",
                            "tertiary": "#134aa4",
                            "tertiary-fixed-dim": "#b0c6ff",
                            "primary-fixed-dim": "#a9c7ff",
                            "surface-tint": "#005db7",
                            "tertiary-fixed": "#d9e2ff",
                            "inverse-primary": "#a9c7ff",
                            "secondary": "#705d00",
                            "surface-container": "#dbf1fe",
                            "inverse-on-surface": "#dff4ff",
                            "on-secondary": "#ffffff",
                            "on-primary-container": "#dae5ff",
                            "error": "#D32F2F",
                            "surface-variant": "#cfe6f2",
                            "on-error": "#ffffff",
                            "on-background": "#071e27",
                            "surface-container-low": "#e6f6ff",
                            "on-tertiary": "#ffffff",
                            "primary": "#004d99",
                            "tertiary-container": "#3563be",
                            "error-container": "#ffdad6",
                            "surface-container-lowest": "#ffffff",
                            "on-surface": "#071e27",
                            "surface-container-highest": "#cfe6f2",
                            "on-tertiary-fixed": "#001945",
                            "outline": "#727783",
                            "surface-dim": "#c7dde9",
                            "inverse-surface": "#1e333c",
                            "secondary-fixed-dim": "#e8c41d",
                            "on-primary": "#ffffff",
                            "surface-container-high": "#d5ecf8",
                            "secondary-container": "#fdd835",
                            "surface-bright": "#f3faff",
                            "on-surface-variant": "#424752",
                            "on-secondary-fixed-variant": "#544600",
                            "on-primary-fixed": "#001b3d",
                            "warning": "#FFA000",
                            "primary-fixed": "#d6e3ff",
                            "background": "#f3faff",
                            "on-error-container": "#93000a",
                            "on-primary-fixed-variant": "#00468c",
                            "primary-container": "#1565c0",
                            "on-secondary-fixed": "#221b00",
                            "outline-variant": "#c2c6d4",
                            "on-tertiary-container": "#dde5ff",
                            "surface": "#FFFFFF",
                            "success": "#2E7D32",
                            "secondary-fixed": "#ffe16e"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "stack-lg": "48px",
                            "container-max": "1280px",
                            "margin-mobile": "16px",
                            "margin-desktop": "64px",
                            "gutter": "24px",
                            "stack-md": "24px",
                            "stack-sm": "12px",
                            "base": "8px"
                        },
                        "fontFamily": {
                            "label-md": ["Inter"],
                            "body-md": ["Inter"],
                            "headline-lg-mobile": ["Inter"],
                            "headline-md": ["Inter"],
                            "headline-lg": ["Inter"],
                            "headline-xl": ["Inter"],
                            "label-sm": ["Inter"],
                            "headline-sm": ["Inter"],
                            "body-sm": ["Inter"],
                            "body-lg": ["Inter"]
                        },
                        "fontSize": {
                            "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.01em", "fontWeight": "600"}],
                            "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                            "headline-lg-mobile": ["28px", {"lineHeight": "36px", "fontWeight": "700"}],
                            "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                            "headline-lg": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                            "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                            "label-sm": ["12px", {"lineHeight": "16px", "fontWeight": "500"}],
                            "headline-sm": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                            "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                            "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}]
                        }
                    }
                }
            }
        </script>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                display: inline-block;
                vertical-align: middle;
            }
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f3faff;
            }
            .glass-panel {
                background: rgba(255, 255, 255, 0.9);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }
            input:focus, select:focus, textarea:focus {
                outline: none;
                border-color: #1565c0 !important;
                box-shadow: 0 0 0 2px rgba(21, 101, 192, 0.1);
            }
        </style>
    </head>
    <body class="text-on-surface">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="bg-ambient-glow min-h-screen ml-64">
            <div class="max-w-container-max mx-auto px-margin-desktop py-stack-lg">
                <div class="mb-stack-lg">
                    <h1 class="font-headline-lg text-headline-lg text-on-surface mb-2">Thêm tài khoản nhân viên</h1>
                    <p class="font-body-md text-body-md text-on-surface-variant">Nhập thông tin để tạo tài khoản mới cho đội ngũ nhân viên BookTown.</p>
                </div>

                <section class="glass-panel rounded-xl shadow-sm p-base sm:p-stack-md">
                    <form class="space-y-stack-md">
                        <div class="grid grid-cols-1 lg:grid-cols-2 gap-stack-lg">
                            <div class="space-y-stack-md">
                                <h3 class="font-headline-sm text-headline-sm text-on-surface flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary">person</span>
                                    Thông tin cá nhân
                                </h3>
                                <div class="flex flex-col items-center sm:flex-row sm:items-center gap-gutter p-4 bg-background-alt rounded-lg">
                                    <div class="relative w-24 h-24 rounded-full bg-surface-container-highest border-2 border-dashed border-outline-variant flex items-center justify-center overflow-hidden">
                                        <span class="material-symbols-outlined text-on-surface-variant text-4xl">account_circle</span>
                                        <img alt="Preview" class="absolute inset-0 w-full h-full object-cover hidden" id="avatar-preview" src=""/>
                                    </div>
                                    <div class="flex flex-col gap-2">
                                        <button class="px-4 py-2 bg-white border border-primary text-primary rounded-lg font-label-md hover:bg-primary-container hover:text-white transition-all flex items-center gap-2" type="button">
                                            <span class="material-symbols-outlined text-[18px]">upload</span>
                                            Tải ảnh lên
                                        </button>
                                        <p class="text-label-sm text-on-surface-variant">Định dạng JPG, PNG. Tối đa 2MB.</p>
                                    </div>
                                </div>
                                <div class="space-y-4">
                                    <div class="flex flex-col gap-2">
                                        <label class="font-label-md text-label-md text-on-surface">Họ và tên</label>
                                        <input class="w-full h-12 px-4 rounded-lg border border-outline-variant bg-white font-body-md text-body-md" placeholder="Nguyễn Văn A" type="text"/>
                                    </div>
                                    <div class="flex flex-col gap-2">
                                        <label class="font-label-md text-label-md text-on-surface">Địa chỉ Email</label>
                                        <input class="w-full h-12 px-4 rounded-lg border border-outline-variant bg-white font-body-md text-body-md" placeholder="example@booktown.vn" type="email"/>
                                    </div>
                                    <div class="flex flex-col gap-2">
                                        <label class="font-label-md text-label-md text-on-surface">Số điện thoại</label>
                                        <input class="w-full h-12 px-4 rounded-lg border border-outline-variant bg-white font-body-md text-body-md" placeholder="090 000 0000" type="tel"/>
                                    </div>
                                </div>
                            </div>
                            <div class="space-y-stack-md">
                                <h3 class="font-headline-sm text-headline-sm text-on-surface flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary">badge</span>
                                    Thiết lập tài khoản
                                </h3>
                                <div class="space-y-4">
                                    <div class="flex flex-col gap-2">
                                        <label class="font-label-md text-label-md text-on-surface">Vai trò</label>
                                        <select class="w-full h-12 px-4 rounded-lg border border-outline-variant bg-white font-body-md text-body-md appearance-none">
                                            <option value="">Chọn vai trò</option>
                                            <option>Staff</option>
                                            <option>khách hàng</option>
                                        </select>
                                    </div>
                                    <div class="flex flex-col gap-2">
                                        <label class="font-label-md text-label-md text-on-surface">Mật khẩu tạm thời</label>
                                        <div class="flex gap-2">
                                            <div class="relative flex-grow">
                                                <input class="w-full h-12 px-4 pr-10 rounded-lg border border-outline-variant bg-white font-body-md text-body-md" id="temp-password" placeholder="••••••••" type="password"/>
                                                <button class="absolute right-3 top-3 text-on-surface-variant material-symbols-outlined" type="button">visibility</button>
                                            </div>
                                            <button class="px-4 h-12 bg-surface-container-low border border-outline-variant text-on-surface rounded-lg font-label-md hover:bg-surface-container transition-all flex items-center gap-2 shrink-0" onclick="generatePassword(event)" type="button">
                                                <span class="material-symbols-outlined text-[18px]">key</span>
                                                Tạo mã
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="pt-stack-md border-t border-outline-variant space-y-stack-md">
                            <div class="flex flex-col gap-2">
                                <label class="font-label-md text-label-md text-on-surface">Ghi chú nội bộ</label>
                                <textarea class="w-full p-4 rounded-lg border border-outline-variant bg-white font-body-md text-body-md resize-none" placeholder="Nhập ghi chú hoặc thông tin bổ sung về nhân viên này..." rows="4"></textarea>
                            </div>
                            <label class="flex items-center gap-3 cursor-pointer group">
                                <div class="relative flex items-center">
                                    <input class="w-5 h-5 rounded border-outline-variant text-primary focus:ring-primary" type="checkbox"/>
                                </div>
                                <span class="font-body-md text-body-md text-on-surface group-hover:text-primary transition-colors">Yêu cầu đổi mật khẩu trong lần đăng nhập đầu tiên</span>
                            </label>
                        </div>

                        <div class="flex flex-col sm:flex-row justify-end gap-4 pt-stack-md">
                            <button class="px-stack-md py-3 border border-outline-variant text-on-surface-variant rounded-lg font-label-md hover:bg-background-alt transition-colors" type="button">
                                Hủy
                            </button>
                            <button class="px-stack-lg py-3 bg-primary text-white rounded-lg font-label-md shadow-md hover:bg-surface-tint active:scale-95 transition-all flex items-center justify-center gap-2" type="submit">
                                <span class="material-symbols-outlined text-[20px]">person_add</span>
                                Tạo tài khoản
                            </button>
                        </div>
                    </form>
                </section>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-gutter mt-stack-lg">
                    <div class="p-6 rounded-xl bg-surface-container-low border border-outline-variant">
                        <span class="material-symbols-outlined text-primary mb-3 text-3xl">security</span>
                        <h4 class="font-headline-sm text-headline-sm mb-2 text-on-surface">Bảo mật tối đa</h4>
                        <p class="font-body-sm text-body-sm text-on-surface-variant">Tất cả tài khoản mới đều được yêu cầu xác thực 2 lớp và quản lý theo phân quyền chặt chẽ.</p>
                    </div>
                    <div class="p-6 rounded-xl bg-surface-container-low border border-outline-variant">
                        <span class="material-symbols-outlined text-primary mb-3 text-3xl">mail</span>
                        <h4 class="font-headline-sm text-headline-sm mb-2 text-on-surface">Thông báo tự động</h4>
                        <p class="font-body-sm text-body-sm text-on-surface-variant">Nhân viên sẽ nhận được email hướng dẫn kích hoạt tài khoản ngay sau khi bạn nhấn tạo.</p>
                    </div>
                    <div class="p-6 rounded-xl bg-surface-container-low border border-outline-variant">
                        <span class="material-symbols-outlined text-primary mb-3 text-3xl">analytics</span>
                        <h4 class="font-headline-sm text-headline-sm mb-2 text-on-surface">Theo dõi hoạt động</h4>
                        <p class="font-body-sm text-body-sm text-on-surface-variant">Mọi thao tác của nhân viên trên hệ thống đều được ghi lại trong nhật ký hoạt động.</p>
                    </div>
                </div>
            </div>
        </main>

        <script>
            function generatePassword(event) {
                const chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()";
                const length = 12;
                let password = "";
                for (let i = 0; i < length; i++) {
                    password += chars.charAt(Math.floor(Math.random() * chars.length));
                }
                document.getElementById('temp-password').value = password;

                // Sửa lỗi event bằng cách truyền trực tiếp từ onClick
                const btn = event.currentTarget;
                btn.classList.add('bg-success', 'text-white');
                setTimeout(() => {
                    btn.classList.remove('bg-success', 'text-white');
                }, 1000);
            }

            // Xử lý sự kiện gửi form mẫu
            document.querySelector('form').addEventListener('submit', (e) => {
                e.preventDefault();
                alert('Đang tạo tài khoản nhân viên mới...');
            });
        </script>
    </body>
</html>