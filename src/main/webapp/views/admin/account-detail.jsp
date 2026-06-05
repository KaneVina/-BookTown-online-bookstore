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
            <div class="p-stack-lg max-w-[1400px] mx-auto">
                <div class="flex justify-between items-end mb-stack-md">
                    <div>
                        <div class="flex items-center gap-3 mb-1">
                            <h3 class="font-headline-lg text-headline-lg text-on-surface">Nguyễn Văn An</h3>
                            <span class="px-3 py-1 bg-tertiary-fixed text-on-tertiary-fixed font-label-md text-label-md rounded-full">Staff</span>
                        </div>
                        <div class="flex items-center gap-2 text-success">
                            <span class="w-2 h-2 rounded-full bg-success"></span>
                            <span class="font-label-md text-label-md">Hoạt động</span>
                        </div>
                    </div>
                    <div class="flex gap-3">
                        <button class="px-5 py-2.5 bg-primary text-on-primary font-label-md text-label-md rounded-xl shadow-sm hover:opacity-90 transition-all flex items-center gap-2">
                            <span class="material-symbols-outlined text-[20px]">edit</span> Edit Account
                        </button>
                        <button class="px-5 py-2.5 border border-primary text-primary font-label-md text-label-md rounded-xl hover:bg-surface-container-high transition-all flex items-center gap-2">
                            <span class="material-symbols-outlined text-[20px]">lock_open</span> Lock Account
                        </button>
                        <button class="px-5 py-2.5 bg-error-container text-on-error-container font-label-md text-label-md rounded-xl hover:opacity-80 transition-all flex items-center gap-2">
                            <span class="material-symbols-outlined text-[20px]">delete</span> Delete
                        </button>
                    </div>
                </div>

                <div class="grid grid-cols-12 gap-gutter">
                    <div class="col-span-12 lg:col-span-4 flex flex-col gap-gutter">
                        <div class="bg-surface rounded-2xl p-stack-md card-shadow flex flex-col items-center text-center">
                            <div class="relative mb-6">
                                <img alt="Nguyễn Văn An" class="w-32 h-32 rounded-3xl object-cover border-4 border-white shadow-md" src="https://lh3.googleusercontent.com/aida-public/AB6AXuCGxvnL9TeAzIcC3REYs29in0j1uCBP3Yp8DVEXe9veythOH6wm-el6RQsMpJ02UBNu5UHTeQTHm4zkqQO5m-tSHPE1x89qQGb2tjhIKaQgKNDrNUgnCsjdSXZxdabzdU0_cvp4Z0NlJDD9UFUnUZ1KGl-AVHOlz8R-Jt5sUTkPE2M05WL8al3E5pvvA4ofVVbbHunfbA3ZTnqjkE1DALZEFAC3JJT75-zlLI1l2_WIDbpRD-ySMiOpc1fyz3fd3SXS4PMEBQ6rPSFU"/>
                                <div class="absolute -bottom-2 -right-2 w-8 h-8 bg-success rounded-full border-4 border-surface flex items-center justify-center">
                                    <span class="material-symbols-outlined text-[14px] text-white" style="font-variation-settings: 'FILL' 1;">check</span>
                                </div>
                            </div>
                            <h4 class="font-headline-sm text-headline-sm text-on-surface mb-1">Nguyễn Văn An</h4>
                            <p class="text-primary font-label-md text-label-md mb-6">an.nguyen@booktown.vn</p>
                            <div class="w-full space-y-4 text-left pt-6 border-t border-outline-variant">
                                <div class="flex items-center gap-3">
                                    <span class="material-symbols-outlined text-on-surface-variant">phone</span>
                                    <div>
                                        <p class="text-label-sm font-label-sm text-on-surface-variant">Phone Number</p>
                                        <p class="text-body-md font-body-md text-on-surface">+84 901 234 567</p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3">
                                    <span class="material-symbols-outlined text-on-surface-variant">calendar_today</span>
                                    <div>
                                        <p class="text-label-sm font-label-sm text-on-surface-variant">Join Date</p>
                                        <p class="text-body-md font-body-md text-on-surface">15 Tháng 01, 2023</p>
                                    </div>
                                </div>
                                <div class="flex items-center gap-3">
                                    <span class="material-symbols-outlined text-on-surface-variant">verified_user</span>
                                    <div>
                                        <p class="text-label-sm font-label-sm text-on-surface-variant">Security Status</p>
                                        <p class="text-body-md font-body-md text-success font-medium">Verified Account</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="bg-surface rounded-2xl p-stack-md card-shadow">
                            <h4 class="font-label-md text-label-md text-on-surface-variant uppercase tracking-wider mb-stack-sm">Hiệu suất nhân viên</h4>
                            <div class="grid grid-cols-2 gap-4">
                                <div class="bg-surface-container rounded-xl p-4">
                                    <p class="text-label-sm font-label-sm text-on-surface-variant">Orders Processed</p>
                                    <p class="text-headline-md font-headline-md text-primary mt-1">1,248</p>
                                </div>
                                <div class="bg-surface-container rounded-xl p-4">
                                    <p class="text-label-sm font-label-sm text-on-surface-variant">Resolved Tickets</p>
                                    <p class="text-headline-md font-headline-md text-primary mt-1">312</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-span-12 lg:col-span-8 flex flex-col gap-gutter">
                        <div class="bg-surface rounded-2xl p-stack-md card-shadow">
                            <div class="flex items-center gap-2 mb-stack-md">
                                <span class="material-symbols-outlined text-primary">badge</span>
                                <h4 class="font-headline-sm text-headline-sm text-on-surface">Thông tin tài khoản</h4>
                            </div>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-y-6 gap-x-12">
                                <div class="space-y-1">
                                    <p class="text-label-sm font-label-sm text-on-surface-variant">Username</p>
                                    <p class="text-body-md font-body-md text-on-surface font-medium">an.nguyen_staff</p>
                                </div>
                                <div class="space-y-1">
                                    <p class="text-label-sm font-label-sm text-on-surface-variant">Department/Group</p>
                                    <p class="text-body-md font-body-md text-on-surface">Quản trị hệ thống (Operations)</p>
                                </div>
                                <div class="space-y-1 col-span-full">
                                    <p class="text-label-sm font-label-sm text-on-surface-variant">Ghi chú quản trị</p>
                                    <p class="text-body-md font-body-md text-on-surface italic">Nhân viên kỳ cựu với quyền truy cập đặc biệt vào cơ sở dữ liệu kho bãi.</p>
                                </div>
                            </div>
                        </div>

                        <div class="bg-surface rounded-2xl p-stack-md card-shadow">
                            <div class="flex justify-between items-center mb-stack-md">
                                <div class="flex items-center gap-2">
                                    <span class="material-symbols-outlined text-primary">history</span>
                                    <h4 class="font-headline-sm text-headline-sm text-on-surface">Hoạt động gần đây</h4>
                                </div>
                                <button class="text-primary font-label-md text-label-md hover:underline">Xem tất cả</button>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full text-left">
                                    <thead>
                                        <tr class="border-b border-outline-variant">
                                            <th class="pb-3 font-label-md text-label-md text-on-surface-variant">Hành động</th>
                                            <th class="pb-3 font-label-md text-label-md text-on-surface-variant">Chi tiết</th>
                                            <th class="pb-3 font-label-md text-label-md text-on-surface-variant">Thời gian</th>
                                            <th class="pb-3 font-label-md text-label-md text-on-surface-variant text-right">Trạng thái</th>
                                        </tr>
                                <tbody class="divide-y divide-surface-container-highest">
                                    <tr class="hover:bg-background-alt transition-colors group">
                                        <td class="py-4 font-body-md text-body-md text-on-surface flex items-center gap-3">
                                            <span class="w-8 h-8 rounded-full bg-primary-container/10 flex items-center justify-center text-primary">
                                                <span class="material-symbols-outlined text-[18px]">key</span>
                                            </span>
                                            Updated Password
                                        </td>
                                        <td class="py-4 font-body-md text-body-md text-on-surface-variant">Manual Reset by User</td>
                                        <td class="py-4 font-body-md text-body-md text-on-surface-variant">10 phút trước</td>
                                        <td class="py-4 text-right">
                                            <span class="text-success font-label-sm text-label-sm">Thành công</span>
                                        </td>
                                    </tr>
                                    <tr class="hover:bg-background-alt transition-colors group">
                                        <td class="py-4 font-body-md text-body-md text-on-surface flex items-center gap-3">
                                            <span class="w-8 h-8 rounded-full bg-primary-container/10 flex items-center justify-center text-primary">
                                                <span class="material-symbols-outlined text-[18px]">login</span>
                                            </span>
                                            Logged In
                                        </td>
                                        <td class="py-4 font-body-md text-body-md text-on-surface-variant">Chrome v118 (Hà Nội, VN)</td>
                                        <td class="py-4 font-body-md text-body-md text-on-surface-variant">2 giờ trước</td>
                                        <td class="py-4 text-right">
                                            <span class="text-success font-label-sm text-label-sm">Thành công</span>
                                        </td>
                                    </tr>
                                    <tr class="hover:bg-background-alt transition-colors group">
                                        <td class="py-4 font-body-md text-body-md text-on-surface flex items-center gap-3">
                                            <span class="w-8 h-8 rounded-full bg-primary-container/10 flex items-center justify-center text-primary">
                                                <span class="material-symbols-outlined text-[18px]">assignment_turned_in</span>
                                            </span>
                                            Orders Processed
                                        </td>
                                        <td class="py-4 font-body-md text-body-md text-on-surface-variant">#BK-99281, #BK-99282</td>
                                        <td class="py-4 font-body-md text-body-md text-on-surface-variant">Hôm qua, 14:30</td>
                                        <td class="py-4 text-right">
                                            <span class="text-success font-label-sm text-label-sm">Thành công</span>
                                        </td>
                                    </tr>
                                    <tr class="hover:bg-background-alt transition-colors group">
                                        <td class="py-4 font-body-md text-body-md text-on-surface flex items-center gap-3">
                                            <span class="w-8 h-8 rounded-full bg-primary-container/10 flex items-center justify-center text-primary">
                                                <span class="material-symbols-outlined text-[18px]">edit_note</span>
                                            </span>
                                            Updated Profile
                                        </td>
                                        <td class="py-4 font-body-md text-body-md text-on-surface-variant">Changed Phone Number</td>
                                        <td class="py-4 font-body-md text-body-md text-on-surface-variant">3 ngày trước</td>
                                        <td class="py-4 text-right">
                                            <span class="text-success font-label-sm text-label-sm">Thành công</span>
                                        </td>
                                    </tr>
                                    <tr class="hover:bg-background-alt transition-colors group">
                                        <td class="py-4 font-body-md text-body-md text-on-surface flex items-center gap-3">
                                            <span class="w-8 h-8 rounded-full bg-primary-container/10 flex items-center justify-center text-primary">
                                                <span class="material-symbols-outlined text-[18px]">support_agent</span>
                                            </span>
                                            Resolved Ticket
                                        </td>
                                        <td class="py-4 font-body-md text-body-md text-on-surface-variant">TICKET #8831 - Refund issue</td>
                                        <td class="py-4 font-body-md text-body-md text-on-surface-variant">5 ngày trước</td>
                                        <td class="py-4 text-right">
                                            <span class="text-success font-label-sm text-label-sm">Thành công</span>
                                        </td>
                                    </tr>
                                </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="fixed bottom-10 right-10 bg-inverse-surface text-inverse-on-surface px-6 py-4 rounded-xl shadow-2xl translate-y-20 opacity-0 transition-all duration-300 flex items-center gap-3 pointer-events-none" id="toast">
                <span class="material-symbols-outlined text-success">check_circle</span>
                <span class="font-label-md text-label-md">Thay đổi đã được lưu thành công.</span>
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