<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="vi"><head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
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
            }
            .order-stepper-line::before {
                content: '';
                position: absolute;
                left: 15px;
                top: 24px;
                bottom: 0;
                width: 2px;
                background-color: #c2c6d4;
            }
            .order-stepper-line:last-child::before {
                display: none;
            }
        </style>
    </head>
    <body class="bg-background text-on-surface min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <main class="md:ml-64 min-h-screen">
            <div class="p-gutter max-w-container-max mx-auto space-y-stack-md">
                <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                    <div>
                        <div class="flex items-center gap-3">
                            <h3 class="font-headline-lg text-headline-lg text-on-surface">Đơn hàng #BT-99210</h3>
                            <span class="px-3 py-1 bg-surface-container-highest text-primary rounded-full font-label-md text-label-md">Đang xử lý</span>
                        </div>
                    </div>
                    <div class="flex gap-3">
                        <button class="flex items-center gap-2 px-4 py-2 bg-primary text-on-primary rounded-lg font-label-md text-label-md hover:opacity-90 shadow-sm transition-all">
                            <span class="material-symbols-outlined text-[20px]">check_circle</span>
                            Hoàn tất đơn
                        </button>
                    </div>
                </div>
                <div class="grid grid-cols-1 lg:grid-cols-3 gap-gutter">
                    <div class="lg:col-span-2 space-y-gutter">
                        <div class="bg-surface rounded-xl shadow-[0_4px_20px_rgba(21,101,192,0.08)] overflow-hidden">
                            <div class="p-6 border-b border-outline-variant bg-surface-bright flex justify-between items-center">
                                <h4 class="font-headline-sm text-headline-sm text-on-surface">Danh sách sản phẩm</h4>
                                <span class="text-on-surface-variant font-body-sm text-body-sm">3 sản phẩm</span>
                            </div>
                            <div class="overflow-x-auto">
                                <table class="w-full text-left">
                                    <thead class="bg-background-alt">
                                        <tr>
                                            <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant">Sản phẩm</th>
                                            <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant">Giá</th>
                                            <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant">Số lượng</th>
                                            <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant text-right">Tổng</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-outline-variant">
                                        <tr class="hover:bg-surface-container-low transition-colors">
                                            <td class="px-6 py-4">
                                                <div class="flex items-center gap-4">
                                                    <img alt="Book cover" class="w-12 h-16 object-cover rounded-md shadow-sm" data-alt="A premium hardback book cover titled 'The Art of Modern Design' featuring elegant abstract minimalist patterns in gold and royal blue. The book is presented in a studio lighting setup with soft shadows against a neutral grey background, emphasizing high-end editorial quality and scholarly sophistication." src="https://lh3.googleusercontent.com/aida-public/AB6AXuAUM3_r7UT94wuZTnq03rMZLFc4f750sooKDwBFeN2Rhsy1RVd-S-l526yHtKym0hEOM6EPwxgum69FZwEUmlgccRL5dgDR-4dEjGlMJm9gUp7AF2h2Mng-Md0xzqFtusqiBaVKuF2FOh-HuK-SZcgT6kQbT2gKI27yGEFSytR6_Sasm-ez5kw_o8_4O6za-hq995GXETL96FrSjMFk2YSUOqkU-77crrHEUxBNjvBpq0TbKInB-aRKL-MEMWCkuIT6OeCWK4BU1MXL">
                                                    <div>
                                                        <p class="font-label-md text-label-md text-primary">Nghệ Thuật Thiết Kế Hiện Đại</p>
                                                        <p class="font-body-sm text-body-sm text-on-surface-variant">Tác giả: Nguyễn Văn A</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 font-body-md text-body-md">250,000₫</td>
                                            <td class="px-6 py-4 font-body-md text-body-md">1</td>
                                            <td class="px-6 py-4 font-body-md text-body-md text-right font-bold">250,000₫</td>
                                        </tr>
                                        <tr class="hover:bg-surface-container-low transition-colors">
                                            <td class="px-6 py-4">
                                                <div class="flex items-center gap-4">
                                                    <img alt="Book cover" class="w-12 h-16 object-cover rounded-md shadow-sm" data-alt="A clean, minimalist book cover for a classic literature novel. The design features a single delicate line-art illustration of a fountain pen on a cream-colored textured paper background. The title is in a sophisticated serif font, reflecting a professional and intellectually stimulating brand personality." src="https://lh3.googleusercontent.com/aida-public/AB6AXuC_8YMUeUddYn4eOsoQjuJ1jb7rMbekad-2oOqJga94gZ7n4nnTzA3H1-um9Skpmp9bRuPwWDT1vBI7E7gBnQyhYCc5_38KhLxgMnTa8xhDQsEoyGW-QbxR0hDHelhGUwH4b8seVPjM_orufQTs4VMU88zMhn-a4XZAdtPQf1EAH2g_sTWUyRhETOj1C804pjI6QeO3Z4XJvdm9eCZl_tpja0OQ7Vpa3RrdXlQ7XND4VnzZ05Jhrvt5JXljKrCvh1GpkCvSt-a5mgSc">
                                                    <div>
                                                        <p class="font-label-md text-label-md text-primary">Kỹ Năng Viết Lách Chuyên Nghiệp</p>
                                                        <p class="font-body-sm text-body-sm text-on-surface-variant">Tác giả: Trần Thị B</p>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 font-body-md text-body-md">180,000₫</td>
                                            <td class="px-6 py-4 font-body-md text-body-md">2</td>
                                            <td class="px-6 py-4 font-body-md text-body-md text-right font-bold">360,000₫</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <div class="p-6 bg-surface-bright border-t border-outline-variant">
                                <div class="flex flex-col items-end gap-2">
                                    <div class="flex justify-between w-64 text-on-surface-variant">
                                        <span class="font-body-md text-body-md">Tạm tính:</span>
                                        <span class="font-body-md text-body-md">610,000₫</span>
                                    </div>
                                    <div class="flex justify-between w-64 text-on-surface-variant">
                                        <span class="font-body-md text-body-md">Phí vận chuyển:</span>
                                        <span class="font-body-md text-body-md">30,000₫</span>
                                    </div>
                                    <div class="flex justify-between w-64 pt-2 border-t border-outline-variant">
                                        <span class="font-headline-sm text-headline-sm text-on-surface font-bold">Tổng cộng:</span>
                                        <span class="font-headline-sm text-headline-sm text-primary font-bold">640,000₫</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-gutter">
                            <div class="bg-surface p-6 rounded-xl shadow-[0_4px_20px_rgba(21,101,192,0.08)]">
                                <div class="flex items-center gap-2 mb-4">
                                    <span class="material-symbols-outlined text-primary">payments</span>
                                    <h4 class="font-label-md text-label-md text-on-surface uppercase tracking-wider">Trạng thái thanh toán</h4>
                                </div>
                                <div class="space-y-3">
                                    <div class="flex justify-between items-center">
                                        <span class="text-on-surface-variant font-body-sm text-body-sm">Phương thức:</span>
                                        <span class="font-label-md text-label-md text-on-surface">Chuyển khoản Ngân hàng</span>
                                    </div>
                                    <div class="flex justify-between items-center">
                                        <span class="text-on-surface-variant font-body-sm text-body-sm">Trạng thái:</span>
                                        <span class="px-3 py-1 bg-success/10 text-success rounded-full font-label-sm text-label-sm flex items-center gap-1">
                                            <span class="material-symbols-outlined text-[16px]" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                            Đã thanh toán
                                        </span>
                                    </div>
                                    <div class="flex justify-between items-center">
                                        <span class="text-on-surface-variant font-body-sm text-body-sm">Ngày thanh toán:</span>
                                        <span class="font-body-sm text-body-sm text-on-surface">14:20, 24/10/2023</span>
                                    </div>
                                </div>
                            </div>
                            <div class="bg-surface p-6 rounded-xl shadow-[0_4px_20px_rgba(21,101,192,0.08)]">
                                <div class="flex items-center gap-2 mb-4">
                                    <span class="material-symbols-outlined text-primary">local_shipping</span>
                                    <h4 class="font-label-md text-label-md text-on-surface uppercase tracking-wider">Vận chuyển</h4>
                                </div>
                                <div class="space-y-3">
                                    <div class="flex justify-between items-center">
                                        <span class="text-on-surface-variant font-body-sm text-body-sm">Đối tác:</span>
                                        <span class="font-label-md text-label-md text-on-surface">Giao Hàng Nhanh (GHN)</span>
                                    </div>
                                    <div class="flex justify-between items-center">
                                        <span class="text-on-surface-variant font-body-sm text-body-sm">Mã vận đơn:</span>
                                        <span class="font-label-md text-label-md text-primary cursor-pointer hover:underline">GHN-23940129</span>
                                    </div>
                                    <div class="flex justify-between items-center">
                                        <span class="text-on-surface-variant font-body-sm text-body-sm">Dự kiến giao:</span>
                                        <span class="font-body-sm text-body-sm text-on-surface">26/10/2023</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="space-y-gutter">
                        <!-- Customer Information -->
                        <div class="bg-surface p-6 rounded-xl shadow-[0_4px_20px_rgba(21,101,192,0.08)]">
                            <div class="flex items-center justify-between mb-6">
                                <h4 class="font-headline-sm text-headline-sm text-on-surface">Khách hàng</h4>
                            </div>
                            <div class="flex items-center gap-4 mb-6">
                                <div>
                                    <p class="font-label-md text-label-md text-on-surface">Nguyễn Thành Long</p>
                                    <p class="font-body-sm text-body-sm text-on-surface-variant">Customer</p>
                                </div>
                            </div>
                            <div class="space-y-4">
                                <div class="flex items-start gap-3">
                                    <span class="material-symbols-outlined text-outline text-[20px]">mail</span>
                                    <div>
                                        <p class="font-label-sm text-label-sm text-on-surface-variant">Email</p>
                                        <p class="font-body-sm text-body-sm text-primary">long.nguyen@example.com</p>
                                    </div>
                                </div>
                                <div class="flex items-start gap-3">
                                    <span class="material-symbols-outlined text-outline text-[20px]">phone</span>
                                    <div>
                                        <p class="font-label-sm text-label-sm text-on-surface-variant">Số điện thoại</p>
                                        <p class="font-body-sm text-body-sm text-on-surface">090 123 4567</p>
                                    </div>
                                </div>
                                <div class="flex items-start gap-3">
                                    <span class="material-symbols-outlined text-outline text-[20px]">location_on</span>
                                    <div>
                                        <p class="font-label-sm text-label-sm text-on-surface-variant">Địa chỉ giao hàng</p>
                                        <p class="font-body-sm text-body-sm text-on-surface leading-relaxed">
                                            123 Đường Lê Lợi, Phường Bến Thành,<br>Quận 1, TP. Hồ Chí Minh
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="bg-surface p-6 rounded-xl shadow-[0_4px_20px_rgba(21,101,192,0.08)]">
                            <h4 class="font-headline-sm text-headline-sm text-on-surface mb-6">Lịch sử đơn hàng</h4>
                            <div class="space-y-6">
                                <div class="relative pl-8 order-stepper-line">
                                    <div class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                        <div class="w-3 h-3 bg-primary rounded-full ring-4 ring-primary-container"></div>
                                    </div>
                                    <p class="font-label-md text-label-md text-on-surface">Đang đóng gói sản phẩm</p>
                                    <p class="font-body-sm text-body-sm text-on-surface-variant mb-1">10:45 - 25/10/2023</p>
                                    <p class="font-body-sm text-body-sm text-on-surface-variant italic">Nhân viên: Trần Văn Khoa</p>
                                </div>
                                <div class="relative pl-8 order-stepper-line">
                                    <div class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                        <div class="w-3 h-3 bg-outline rounded-full"></div>
                                    </div>
                                    <p class="font-label-md text-label-md text-on-surface">Xác nhận thanh toán</p>
                                    <p class="font-body-sm text-body-sm text-on-surface-variant">14:20 - 24/10/2023</p>
                                </div>
                                <div class="relative pl-8 order-stepper-line">
                                    <div class="absolute left-0 top-0 w-8 h-8 flex items-center justify-center z-10">
                                        <div class="w-3 h-3 bg-outline rounded-full"></div>
                                    </div>
                                    <p class="font-label-md text-label-md text-on-surface">Đơn hàng được tạo</p>
                                    <p class="font-body-sm text-body-sm text-on-surface-variant">14:15 - 24/10/2023</p>
                                </div>
                            </div>
                            <button class="w-full mt-6 py-2 border border-outline-variant text-on-surface-variant rounded-lg font-label-md text-label-md hover:bg-surface-container-low transition-colors">
                                Xem tất cả hoạt động
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </body>
</html>