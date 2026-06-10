<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet"/>
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "outline-variant": "#c2c6d4",
                            "on-error": "#ffffff",
                            "secondary": "#705d00",
                            "on-primary-fixed": "#001b3d",
                            "success": "#2E7D32",
                            "on-primary-container": "#dae5ff",
                            "tertiary": "#134aa4",
                            "tertiary-fixed-dim": "#b0c6ff",
                            "primary-fixed-dim": "#a9c7ff",
                            "surface-container-low": "#e6f6ff",
                            "surface-dim": "#c7dde9",
                            "warning": "#FFA000",
                            "surface-container-lowest": "#ffffff",
                            "on-secondary-fixed-variant": "#544600",
                            "primary-container": "#1565c0",
                            "on-tertiary-container": "#dde5ff",
                            "inverse-on-surface": "#dff4ff",
                            "primary": "#004d99",
                            "on-surface-variant": "#424752",
                            "on-tertiary": "#ffffff",
                            "secondary-fixed": "#ffe16e",
                            "on-tertiary-fixed": "#001945",
                            "error": "#D32F2F",
                            "on-secondary-container": "#705e00",
                            "surface-container-highest": "#cfe6f2",
                            "surface-variant": "#cfe6f2",
                            "on-secondary": "#ffffff",
                            "inverse-primary": "#a9c7ff",
                            "on-tertiary-fixed-variant": "#00429c",
                            "on-surface": "#071e27",
                            "on-error-container": "#93000a",
                            "tertiary-container": "#3563be",
                            "background": "#f3faff",
                            "secondary-fixed-dim": "#e8c41d",
                            "on-primary": "#ffffff",
                            "surface-bright": "#f3faff",
                            "error-container": "#ffdad6",
                            "on-background": "#071e27",
                            "tertiary-fixed": "#d9e2ff",
                            "surface-container-high": "#d5ecf8",
                            "on-primary-fixed-variant": "#00468c",
                            "surface-tint": "#005db7",
                            "surface": "#FFFFFF",
                            "background-alt": "#F5F7F9",
                            "inverse-surface": "#1e333c",
                            "surface-container": "#dbf1fe",
                            "on-secondary-fixed": "#221b00",
                            "primary-fixed": "#d6e3ff",
                            "secondary-container": "#fdd835",
                            "outline": "#727783"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "gutter": "24px",
                            "margin-desktop": "64px",
                            "container-max": "1280px",
                            "base": "8px",
                            "stack-sm": "12px",
                            "margin-mobile": "16px",
                            "stack-lg": "48px",
                            "stack-md": "24px"
                        },
                        "fontFamily": {
                            "label-sm": ["Inter"],
                            "headline-lg": ["Inter"],
                            "headline-sm": ["Inter"],
                            "body-lg": ["Inter"],
                            "body-sm": ["Inter"],
                            "label-md": ["Inter"],
                            "body-md": ["Inter"],
                            "headline-xl": ["Inter"],
                            "headline-md": ["Inter"]
                        },
                        "fontSize": {
                            "label-sm": ["12px", {"lineHeight": "16px", "fontWeight": "500"}],
                            "headline-lg": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                            "headline-sm": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                            "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                            "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                            "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.01em", "fontWeight": "600"}],
                            "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                            "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                            "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}]
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
            .bg-ambient-glow {
                background: radial-gradient(circle at 50% 50%, rgba(21, 101, 192, 0.03) 0%, rgba(243, 250, 255, 0) 70%);
            }
            .card-shadow {
                box-shadow: 0 4px 20px rgba(21, 101, 192, 0.08);
            }
        </style>
    </head>
    <body class="bg-background text-on-background min-h-screen">

        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>


        <main class="bg-ambient-glow min-h-screen ml-64">
            <div class="p-stack-lg max-w-[1200px] mx-auto space-y-8">

                <!-- Refined Header Section -->
                <section class="flex flex-col lg:flex-row justify-between items-start lg:items-end gap-6 bg-white p-8 rounded-2xl border border-surface-container card-shadow">

                    <div class="space-y-4">
                        <div class="flex items-center gap-4">
                            <div class="w-16 h-16 rounded-2xl bg-primary flex items-center justify-center text-on-primary shadow-inner">
                                <span class="material-symbols-outlined text-[36px]">person</span>
                            </div>

                            <div>
                                <h3 class="font-headline-lg text-headline-lg text-on-surface">
                                    Nguyễn Văn An
                                </h3>

                                <div class="flex items-center gap-2 mt-1">
                                    <span class="px-3 py-1 bg-primary/10 text-primary font-label-sm text-label-sm rounded-full font-semibold border border-primary/20">
                                        Quản trị viên (Admin)
                                    </span>

                                    <span class="px-3 py-1 bg-success/10 text-success font-label-sm text-label-sm rounded-full font-semibold border border-success/20 flex items-center gap-1.5">
                                        <span class="w-1.5 h-1.5 rounded-full bg-success animate-pulse"></span>
                                        Hoạt động
                                    </span>
                                </div>
                            </div>
                        </div>

                        <div class="flex flex-wrap gap-x-8 gap-y-2">
                            <div class="flex items-center gap-2 text-on-surface-variant font-body-sm">
                                <span class="material-symbols-outlined text-[20px] text-primary">mail</span>
                                <span>an.nguyen@booktown.vn</span>
                            </div>

                            <div class="flex items-center gap-2 text-on-surface-variant font-body-sm">
                                <span class="material-symbols-outlined text-[20px] text-primary">phone</span>
                                <span>+84 901 234 567</span>
                            </div>
                        </div>
                    </div>

                    <div class="flex gap-3 w-full lg:w-auto">
                        <button
                            class="flex-1 lg:flex-none px-6 py-3 bg-primary text-on-primary font-label-md text-label-md rounded-xl shadow-md hover:shadow-lg hover:brightness-110 transition-all flex items-center justify-center gap-2">
                            <span class="material-symbols-outlined text-[20px]">edit</span>
                            Cập nhật
                        </button>

                        <button
                            class="flex-1 lg:flex-none px-6 py-3 border border-outline text-on-surface font-label-md text-label-md rounded-xl hover:bg-surface-container-low transition-all flex items-center justify-center gap-2">
                            <span class="material-symbols-outlined text-[20px]">lock</span>
                            Khóa tài khoản
                        </button>

                        <button
                            class="px-4 py-3 bg-error/5 text-error border border-error/20 font-label-md text-label-md rounded-xl hover:bg-error hover:text-white transition-all flex items-center justify-center">
                            <span class="material-symbols-outlined text-[20px]">delete</span>
                        </button>
                    </div>

                </section>

                <section class="grid grid-cols-1 md:grid-cols-2 gap-gutter">
                    <div class="bg-surface rounded-2xl p-6 card-shadow border border-surface-container group hover:border-primary/30 transition-colors bg-primary/5">
                        <div class="flex justify-between items-start">
                            <div>
                                <p class="text-label-sm font-bold text-on-surface-variant uppercase tracking-wider mb-1">Tổng chi tiêu</p>
                                <p class="text-headline-lg font-headline-lg text-primary">12.450.000đ</p>
                            </div>
                            <div class="w-12 h-12 rounded-xl bg-primary/5 flex items-center justify-center text-primary group-hover:bg-primary group-hover:text-on-primary transition-all">
                                <span class="material-symbols-outlined">payments</span>
                            </div>
                        </div>
                        <div class="mt-4 pt-4 border-t border-outline-variant/30 flex items-center gap-2 text-label-sm text-success font-medium">
                            <span class="material-symbols-outlined text-[16px]">trending_up</span>
                            <span class="">+12% so với tháng trước</span>
                        </div>
                    </div>
                    <div class="bg-surface rounded-2xl p-6 card-shadow border border-surface-container group hover:border-secondary/30 transition-colors bg-secondary/5">
                        <div class="flex justify-between items-start">
                            <div>
                                <p class="text-label-sm font-bold text-on-surface-variant uppercase tracking-wider mb-1">Tổng số đơn hàng</p>
                                <p class="text-headline-lg font-headline-lg text-secondary">24 đơn hàng</p>
                            </div>
                            <div class="w-12 h-12 rounded-xl bg-secondary/5 flex items-center justify-center text-secondary group-hover:bg-secondary group-hover:text-on-secondary transition-all">
                                <span class="material-symbols-outlined">shopping_bag</span>
                            </div>
                        </div>
                        <div class="mt-4 pt-4 border-t border-outline-variant/30 flex items-center gap-2 text-label-sm text-on-surface-variant">
                            <span class="material-symbols-outlined text-[16px]">history</span>
                            <span class="">Đơn hàng gần nhất: 12/05/2024</span>
                        </div>
                    </div>
                </section>

                <section class="bg-surface rounded-2xl overflow-hidden card-shadow border border-surface-container">
                    <div class="bg-surface-container-low px-8 py-4 border-b border-outline-variant/30 flex items-center justify-between">
                        <div class="flex items-center gap-3">
                            <span class="material-symbols-outlined text-primary">contact_page</span>
                            <h4 class="font-headline-sm text-headline-sm text-on-surface">Thông tin tài khoản</h4>
                        </div>
                        <span class="text-label-sm text-on-surface-variant">Dữ liệu được cập nhật theo thời gian thực</span>
                    </div>
                    <div class="p-8 space-y-6">
                        <div class="">
                            <div class="flex items-center gap-2 mb-4">
                                <span class="material-symbols-outlined text-primary text-[20px]">history</span>
                                <h5 class="text-label-md font-bold text-on-surface">Lịch sử &amp; Hệ thống</h5>
                            </div>
                            <div class="flex flex-wrap items-center gap-x-12 gap-y-4">
                                <div class="flex items-center gap-3">
                                    <p class="text-label-sm font-semibold text-on-surface-variant/80 uppercase tracking-tight">Gia nhập:</p>
                                    <p class="text-body-md text-on-surface">15/01/2023</p>
                                </div>
                                <div class="w-[1px] h-4 bg-outline-variant/30 hidden md:block"></div>
                                <div class="flex items-center gap-3">
                                    <p class="text-label-sm font-semibold text-on-surface-variant/80 uppercase tracking-tight">Cập nhật:</p>
                                    <div class="flex items-center gap-2">
                                        <p class="text-body-md text-on-surface">12/05/2024</p>
                                        <span class="text-label-sm text-on-surface-variant opacity-70">14:30</span>
                                    </div>
                                </div>
                                <div class="w-[1px] h-4 bg-outline-variant/30 hidden md:block"></div>
                                <div class="flex items-center gap-3">

                                    <div class="flex items-center gap-2">


                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Toast -->
                        <div id="toast"
                             class="fixed bottom-10 right-10 bg-inverse-surface text-inverse-on-surface px-6 py-4 rounded-xl shadow-2xl translate-y-20 opacity-0 transition-all duration-300 flex items-center gap-3 pointer-events-none z-50 border border-white/10">

                            <div class="w-8 h-8 rounded-full bg-success/20 flex items-center justify-center">
                                <span class="material-symbols-outlined text-success">check_circle</span>
                            </div>

                            <div class="flex flex-col">
                                <span class="font-label-md text-label-md font-bold">Thành công</span>
                                <span class="text-label-sm opacity-80">
                                    Thay đổi đã được lưu hệ thống.
                                </span>
                            </div>

                        </div>
                        </main>

                        <script>
                            // Micro-interaction for primary action
                            document.querySelector('button.bg-primary').addEventListener('click', () => {
                                const toast = document.getElementById('toast');
                                toast.classList.remove('translate-y-20', 'opacity-0');
                                toast.classList.add('translate-y-0', 'opacity-100');

                                setTimeout(() => {
                                    toast.classList.add('translate-y-20', 'opacity-0');
                                    toast.classList.remove('translate-y-0', 'opacity-100');
                                }, 3000);
                            });

                            // Simple hover effect for table rows
                            const rows = document.querySelectorAll('tbody tr');
                            rows.forEach(row => {
                                row.addEventListener('mouseenter', () => {
                                    row.style.transform = 'translateX(4px)';
                                    row.style.transition = 'all 0.2s ease';
                                });
                                row.addEventListener('mouseleave', () => {
                                    row.style.transform = 'translateX(0)';
                                });
                            });
                        </script>
                        </body>
                        </html>