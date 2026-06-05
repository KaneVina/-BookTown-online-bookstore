<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi"><head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "secondary-fixed-dim": "#e8c41d",
                            "on-surface-variant": "#424752",
                            "on-secondary-fixed-variant": "#544600",
                            "success": "#2E7D32",
                            "on-tertiary": "#ffffff",
                            "on-primary-container": "#dae5ff",
                            "on-secondary": "#ffffff",
                            "outline-variant": "#c2c6d4",
                            "on-primary-fixed": "#001b3d",
                            "surface-tint": "#005db7",
                            "error-container": "#ffdad6",
                            "warning": "#FFA000",
                            "surface": "#FFFFFF",
                            "on-primary": "#ffffff",
                            "on-error": "#ffffff",
                            "on-background": "#071e27",
                            "tertiary-fixed-dim": "#b0c6ff",
                            "surface-dim": "#c7dde9",
                            "on-tertiary-container": "#dde5ff",
                            "on-primary-fixed-variant": "#00468c",
                            "on-error-container": "#93000a",
                            "primary": "#004d99",
                            "surface-container": "#dbf1fe",
                            "surface-container-low": "#e6f6ff",
                            "surface-container-highest": "#cfe6f2",
                            "inverse-surface": "#1e333c",
                            "primary-fixed-dim": "#a9c7ff",
                            "surface-container-lowest": "#ffffff",
                            "on-secondary-container": "#705e00",
                            "background": "#f3faff",
                            "secondary-fixed": "#ffe16e",
                            "on-surface": "#071e27",
                            "surface-variant": "#cfe6f2",
                            "inverse-primary": "#a9c7ff",
                            "error": "#D32F2F",
                            "background-alt": "#F5F7F9",
                            "on-tertiary-fixed": "#001945",
                            "on-tertiary-fixed-variant": "#00429c",
                            "on-secondary-fixed": "#221b00",
                            "secondary-container": "#fdd835",
                            "tertiary": "#134aa4",
                            "secondary": "#705d00",
                            "primary-fixed": "#d6e3ff",
                            "tertiary-fixed": "#d9e2ff",
                            "surface-bright": "#f3faff"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "stack-sm": "12px",
                            "gutter": "24px",
                            "margin-desktop": "64px",
                            "container-max": "1280px",
                            "margin-mobile": "16px",
                            "base": "8px",
                            "stack-lg": "48px",
                            "stack-md": "24px"
                        },
                        "fontFamily": {
                            "headline-lg": ["Inter"],
                            "headline-sm": ["Inter"],
                            "label-md": ["Inter"],
                            "headline-md": ["Inter"],
                            "body-sm": ["Inter"],
                            "body-md": ["Inter"]
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
            ::-webkit-scrollbar {
                width: 6px;
            }
            ::-webkit-scrollbar-track {
                background: transparent;
            }
            ::-webkit-scrollbar-thumb {
                background: #c2c6d4;
                border-radius: 10px;
            }
            ::-webkit-scrollbar-thumb:hover {
                background: #727783;
            }
        </style>
    </head>
    <body class="bg-background text-on-surface min-h-screen">
        <!-- SideNavBar -->
        <aside class="hidden md:flex flex-col h-screen w-64 fixed left-0 top-0 bg-background-alt border-r border-outline-variant py-base gap-stack-sm z-40">
            <div class="px-6 py-4">
                <h1 class="font-headline-sm text-headline-sm font-bold text-primary">BookTown Staff</h1>
                <p class="font-body-sm text-body-sm text-on-surface-variant">Quản trị viên</p>
            </div>
            <nav class="flex-1 space-y-1 mt-4">
                <a class="flex items-center px-4 py-3 mx-2 text-on-surface-variant hover:bg-surface-container rounded-lg transition-all group" href="#">
                    <span class="material-symbols-outlined mr-3">dashboard</span>
                    <span class="font-label-md text-label-md">Bảng điều khiển</span>
                </a>
                <a class="flex items-center px-4 py-3 mx-2 text-primary font-bold bg-surface-container-highest rounded-lg transition-all" href="#">
                    <span class="material-symbols-outlined mr-3">shopping_cart</span>
                    <span class="font-label-md text-label-md">Đơn hàng</span>
                </a>
                <a class="flex items-center px-4 py-3 mx-2 text-on-surface-variant hover:bg-surface-container rounded-lg transition-all" href="#">
                    <span class="material-symbols-outlined mr-3">inventory_2</span>
                    <span class="font-label-md text-label-md">Kho hàng</span>
                </a>
                <a class="flex items-center px-4 py-3 mx-2 text-on-surface-variant hover:bg-surface-container rounded-lg transition-all" href="#">
                    <span class="material-symbols-outlined mr-3">group</span>
                    <span class="font-label-md text-label-md">Khách hàng</span>
                </a>
            </nav>
            <div class="px-4 mb-6">
                <button class="w-full bg-primary text-on-primary py-3 rounded-lg font-label-md text-label-md shadow-sm hover:opacity-90 transition-opacity">
                    + Thêm sách mới
                </button>
            </div>
            <div class="border-t border-outline-variant pt-4 pb-2">
                <a class="flex items-center px-4 py-3 mx-2 text-on-surface-variant hover:bg-surface-container rounded-lg" href="#">
                    <span class="material-symbols-outlined mr-3">settings</span>
                    <span class="font-label-md text-label-md">Cài đặt</span>
                </a>
                <a class="flex items-center px-4 py-3 mx-2 text-error hover:bg-surface-container rounded-lg" href="#">
                    <span class="material-symbols-outlined mr-3">logout</span>
                    <span class="font-label-md text-label-md">Đăng xuất</span>
                </a>
            </div>
        </aside>
        <!-- Main Content Canvas -->
        <main class="md:ml-64 min-h-screen">
            <!-- TopAppBar -->
            <header class="flex justify-between items-center h-16 px-gutter w-full sticky top-0 z-50 bg-surface shadow-[0_4px_20px_rgba(21,101,192,0.08)]">
                <div class="flex items-center gap-4">
                    <button class="md:hidden p-2 hover:bg-surface-container-low rounded-full transition-colors">
                        <span class="material-symbols-outlined">menu</span>
                    </button>
                </div>
                <div class="flex items-center gap-stack-sm">
                    <div class="relative hidden sm:block">
                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">search</span>
                        <input class="pl-10 pr-4 py-2 bg-surface-container-low border-none rounded-full w-64 font-body-sm text-body-sm focus:ring-2 focus:ring-primary focus:bg-surface" placeholder="Tìm kiếm đơn hàng..." type="text">
                    </div>
                    <button class="p-2 hover:bg-surface-container-low rounded-full transition-colors relative">
                        <span class="material-symbols-outlined text-on-surface-variant">notifications</span>
                        <span class="absolute top-2 right-2 w-2 h-2 bg-error rounded-full"></span>
                    </button>
                    <button class="p-2 hover:bg-surface-container-low rounded-full transition-colors">
                        <span class="material-symbols-outlined text-on-surface-variant">help_outline</span>
                    </button>
                    <img alt="Staff avatar" class="w-8 h-8 rounded-full border border-outline-variant object-cover" data-alt="A professional headshot of a friendly library staff member with short dark hair and a warm smile, wearing a professional navy blue shirt. The background is a brightly lit, modern office environment with blurred bookshelves, maintaining a clean corporate aesthetic with soft, natural daylight." src="https://lh3.googleusercontent.com/aida-public/AB6AXuCKQmIL_6asflCh2-C9g5AyP7qbfJOWdexOwKA11t_MyHcwxXpUmXJdwAOaAD6IX2ZyyRu4ioJmfdSS0a-hYqzlRR4w-jUr1it8mtTncDyCXU8Mlk2wwkpEMUqRelCEIWNR_DkZ0oUqXW7-4RI3mbH3xrWs9K3COLRxIdEABPPC2IsRUCyFIw7DR5e_rqGJEygOZ0FaFdMAsRHA9hx0DpJ9CrqQMInj5sJyrjf2pldp4sGCoFdDG9iErF6KfFrZ3ik1I4fcYmy8dlwC">
                </div>
            </header>
            <!-- Page Content -->
            <div class="p-gutter max-w-container-max mx-auto">
                <!-- Header Section -->
                <div class="flex flex-col md:flex-row md:items-end justify-between gap-gutter mb-stack-lg">
                    <div>
                        <h2 class="text-headline-lg font-headline-lg text-primary">Danh sách đơn hàng</h2>
                        <p class="text-body-md text-on-surface-variant mt-1">Quản lý và cập nhật tiến độ xử lý đơn hàng của BookTown.</p>
                    </div>
                    <div class="flex items-center gap-stack-sm overflow-x-auto pb-2 md:pb-0">
                        <button class="flex items-center gap-2 px-4 py-2 bg-primary text-white rounded-lg text-label-md font-bold hover:shadow-lg transition-all active:scale-95">
                            <span class="material-symbols-outlined text-[20px]">file_download</span>
                            Xuất báo cáo
                        </button>
                    </div>
                </div>
                <!-- Stats Overview - Bento Layout -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-gutter mb-stack-lg">
                    <div class="bg-surface p-stack-md rounded-xl shadow-sm border border-outline-variant/10 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-lg bg-primary/10 flex items-center justify-center text-primary">
                            <span class="material-symbols-outlined">pending_actions</span>
                        </div>
                        <div>
                            <p class="text-label-sm text-on-surface-variant">Chờ duyệt</p>
                            <p class="text-headline-sm font-bold">24</p>
                        </div>
                    </div>
                    <div class="bg-surface p-stack-md rounded-xl shadow-sm border border-outline-variant/10 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-lg bg-warning/10 flex items-center justify-center text-warning">
                            <span class="material-symbols-outlined">inventory_2</span>
                        </div>
                        <div>
                            <p class="text-label-sm text-on-surface-variant">Đang đóng gói</p>
                            <p class="text-headline-sm font-bold">12</p>
                        </div>
                    </div>
                    <div class="bg-surface p-stack-md rounded-xl shadow-sm border border-outline-variant/10 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-lg bg-tertiary/10 flex items-center justify-center text-tertiary">
                            <span class="material-symbols-outlined">local_shipping</span>
                        </div>
                        <div>
                            <p class="text-label-sm text-on-surface-variant">Đang giao</p>
                            <p class="text-headline-sm font-bold">45</p>
                        </div>
                    </div>
                    <div class="bg-surface p-stack-md rounded-xl shadow-sm border border-outline-variant/10 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-lg bg-success/10 flex items-center justify-center text-success">
                            <span class="material-symbols-outlined">check_circle</span>
                        </div>
                        <div>
                            <p class="text-label-sm text-on-surface-variant">Hoàn thành (24h)</p>
                            <p class="text-headline-sm font-bold">128</p>
                        </div>
                    </div>
                </div>
                <!-- Filter & Table Section -->
                <div class="bg-surface rounded-xl shadow-sm border border-outline-variant/10 overflow-hidden">
                    <!-- Filters -->
                    <div class="p-gutter border-b border-outline-variant/10 flex flex-wrap items-center justify-between gap-stack-md bg-surface-container-low/30">
                        <div class="flex items-center gap-stack-sm overflow-x-auto">
                            <button class="px-4 py-2 rounded-full bg-primary text-white text-label-md whitespace-nowrap">Tất cả</button>
                            <button class="px-4 py-2 rounded-full bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant text-label-md whitespace-nowrap">Chờ duyệt</button>
                            <button class="px-4 py-2 rounded-full bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant text-label-md whitespace-nowrap">Đang đóng gói</button>
                            <button class="px-4 py-2 rounded-full bg-background-alt hover:bg-surface-container-high transition-colors text-on-surface-variant text-label-md whitespace-nowrap">Đang giao</button>
                        </div>
                        <div class="flex items-center gap-stack-sm">
                            <div class="flex items-center gap-2 text-body-sm text-on-surface-variant">
                                <span class="material-symbols-outlined text-[18px]">calendar_today</span>
                                <span>Hôm nay, 12 Th04</span>
                            </div>
                            <div class="h-4 w-px bg-outline-variant/50"></div>
                            <button class="flex items-center gap-2 text-primary font-bold text-label-md hover:underline decoration-2">
                                <span class="material-symbols-outlined text-[18px]">filter_list</span>
                                Lọc nâng cao
                            </button>
                        </div>
                    </div>
                    <!-- Table -->
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-surface-container-low/50 border-b border-outline-variant/10">
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Mã đơn</th>
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Tên khách hàng</th>
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Ngày đặt</th>
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Tổng tiền</th>
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold">Trạng thái</th>
                                    <th class="px-gutter py-4 text-label-sm text-on-surface-variant uppercase tracking-wider font-bold text-right">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant/5">
                                <!-- Row 1: Pending -->
                                <tr class="hover:bg-background-alt/50 transition-colors group">
                                    <td class="px-gutter py-4">
                                        <span class="font-bold text-primary">#ORD-88291</span>
                                    </td>
                                    <td class="px-gutter py-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-8 h-8 rounded-full bg-primary-container text-white flex items-center justify-center text-label-sm">NH</div>
                                            <span class="text-body-sm font-medium">Nguyễn Văn Hoàng</span>
                                        </div>
                                    </td>
                                    <td class="px-gutter py-4 text-body-sm text-on-surface-variant">12:30 - 12/04/2024</td>
                                    <td class="px-gutter py-4 font-bold text-body-sm">450.000đ</td>
                                    <td class="px-gutter py-4">
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary-container/20 text-primary text-label-sm font-bold">
                                            <span class="w-2 h-2 rounded-full bg-primary animate-pulse"></span>
                                            Chờ duyệt
                                        </span>
                                    </td>
                                    <td class="px-gutter py-4 text-right">
                                        <div class="flex items-center justify-end gap-2">
                                            <button class="p-2 bg-surface border border-outline-variant/30 text-primary rounded-lg hover:bg-surface-container-high transition-all active:scale-90" title="Xem chi tiết">
                                                <span class="material-symbols-outlined text-[18px]">edit</span>
                                            </button>
                                            <button class="p-2 bg-surface border border-outline-variant/30 text-primary rounded-lg hover:bg-surface-container-high transition-all active:scale-90" title="Xem chi tiết">
                                                <a href="${pageContext.request.contextPath}/customer-order-detail">
                                                <span class="material-symbols-outlined text-[18px]">visibility</span>
                                                </a>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Row 2: Packaging -->
                                <tr class="hover:bg-background-alt/50 transition-colors group">
                                    <td class="px-gutter py-4">
                                        <span class="font-bold text-primary">#ORD-88290</span>
                                    </td>
                                    <td class="px-gutter py-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-8 h-8 rounded-full bg-secondary-container text-on-secondary-container flex items-center justify-center text-label-sm">TL</div>
                                            <span class="text-body-sm font-medium">Trần Thị Lan</span>
                                        </div>
                                    </td>
                                    <td class="px-gutter py-4 text-body-sm text-on-surface-variant">11:15 - 12/04/2024</td>
                                    <td class="px-gutter py-4 font-bold text-body-sm">1.280.000đ</td>
                                    <td class="px-gutter py-4">
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-warning/10 text-warning text-label-sm font-bold">
                                            <span class="w-2 h-2 rounded-full bg-warning"></span>
                                            Đang đóng gói
                                        </span>
                                    </td>
                                    <td class="px-gutter py-4 text-right">
                                        <div class="flex items-center justify-end gap-2">
                                            <button class="p-2 bg-surface border border-outline-variant/30 text-primary rounded-lg hover:bg-surface-container-high transition-all active:scale-90" title="Xem chi tiết">
                                                <span class="material-symbols-outlined text-[18px]">edit</span>
                                            </button>
                                            <button class="p-2 bg-surface border border-outline-variant/30 text-primary rounded-lg hover:bg-surface-container-high transition-all active:scale-90" title="Xem chi tiết">
                                               <a href="${pageContext.request.contextPath}/customer-order-detail">
                                                <span class="material-symbols-outlined text-[18px]">visibility</span>
                                                </a>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Row 3: Delivering -->
                                <tr class="hover:bg-background-alt/50 transition-colors group">
                                    <td class="px-gutter py-4">
                                        <span class="font-bold text-primary">#ORD-88289</span>
                                    </td>
                                    <td class="px-gutter py-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-8 h-8 rounded-full bg-tertiary-container text-on-tertiary-container flex items-center justify-center text-label-sm">LQ</div>
                                            <span class="text-body-sm font-medium">Lê Anh Quân</span>
                                        </div>
                                    </td>
                                    <td class="px-gutter py-4 text-body-sm text-on-surface-variant">09:45 - 12/04/2024</td>
                                    <td class="px-gutter py-4 font-bold text-body-sm">320.000đ</td>
                                    <td class="px-gutter py-4">
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-tertiary/10 text-tertiary text-label-sm font-bold">
                                            <span class="w-2 h-2 rounded-full bg-tertiary"></span>
                                            Đang giao
                                        </span>
                                    </td>
                                   <td class="px-gutter py-4 text-right">
                                        <div class="flex items-center justify-end gap-2">
                                            <button class="p-2 bg-surface border border-outline-variant/30 text-primary rounded-lg hover:bg-surface-container-high transition-all active:scale-90" title="Xem chi tiết">
                                                <span class="material-symbols-outlined text-[18px]">edit</span>
                                            </button>
                                            <button class="p-2 bg-surface border border-outline-variant/30 text-primary rounded-lg hover:bg-surface-container-high transition-all active:scale-90" title="Xem chi tiết">
                                                <a href="${pageContext.request.contextPath}/customer-order-detail">
                                                <span class="material-symbols-outlined text-[18px]">visibility</span>
                                                </a>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                <!-- Row 4: Pending -->
                                <tr class="hover:bg-background-alt/50 transition-colors group">
                                    <td class="px-gutter py-4">
                                        <span class="font-bold text-primary">#ORD-88288</span>
                                    </td>
                                    <td class="px-gutter py-4">
                                        <div class="flex items-center gap-3">
                                            <div class="w-8 h-8 rounded-full bg-primary-container text-white flex items-center justify-center text-label-sm">PM</div>
                                            <span class="text-body-sm font-medium">Phạm Minh</span>
                                        </div>
                                    </td>
                                    <td class="px-gutter py-4 text-body-sm text-on-surface-variant">08:00 - 12/04/2024</td>
                                    <td class="px-gutter py-4 font-bold text-body-sm">890.000đ</td>
                                    <td class="px-gutter py-4">
                                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-primary-container/20 text-primary text-label-sm font-bold">
                                            <span class="w-2 h-2 rounded-full bg-primary"></span>
                                            Chờ duyệt
                                        </span>
                                    </td>
                                    <td class="px-gutter py-4 text-right">
                                        <div class="flex items-center justify-end gap-2">
                                            <button class="p-2 bg-surface border border-outline-variant/30 text-primary rounded-lg hover:bg-surface-container-high transition-all active:scale-90" title="Xem chi tiết">
                                                <span class="material-symbols-outlined text-[18px]">edit</span>
                                            </button>
                                            <button class="p-2 bg-surface border border-outline-variant/30 text-primary rounded-lg hover:bg-surface-container-high transition-all active:scale-90" title="Xem chi tiết">
                                               <a href="${pageContext.request.contextPath}/customer-order-detail">
                                                <span class="material-symbols-outlined text-[18px]">visibility</span>
                                                </a>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- Pagination -->
                    <div class="p-gutter border-t border-outline-variant/10 flex items-center justify-between">
                        <p class="text-body-sm text-on-surface-variant">Hiển thị <span class="font-bold text-on-surface">1-4</span> trên <span class="font-bold text-on-surface">81</span> đơn hàng</p>
                        <div class="flex items-center gap-2">
                            <button class="p-2 rounded-lg border border-outline-variant/30 text-on-surface-variant hover:bg-surface-container-high disabled:opacity-30 disabled:cursor-not-allowed" disabled="">
                                <span class="material-symbols-outlined text-[20px]">chevron_left</span>
                            </button>
                            <button class="w-8 h-8 flex items-center justify-center rounded-lg bg-primary text-white text-label-sm font-bold">1</button>
                            <button class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container-high text-on-surface-variant text-label-sm">2</button>
                            <button class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container-high text-on-surface-variant text-label-sm">3</button>
                            <span class="text-on-surface-variant">...</span>
                            <button class="w-8 h-8 flex items-center justify-center rounded-lg hover:bg-surface-container-high text-on-surface-variant text-label-sm">21</button>
                            <button class="p-2 rounded-lg border border-outline-variant/30 text-on-surface-variant hover:bg-surface-container-high active:scale-95 transition-all">
                                <span class="material-symbols-outlined text-[20px]">chevron_right</span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
        <!-- Success Toast - Micro-interaction -->
        <div class="fixed bottom-gutter right-gutter translate-y-20 opacity-0 transition-all duration-300 pointer-events-none" id="toast">
            <div class="bg-inverse-surface text-inverse-on-surface px-6 py-3 rounded-lg shadow-xl flex items-center gap-3">
                <span class="material-symbols-outlined text-success">check_circle</span>
                <span class="text-label-md">Đơn hàng đã được phê duyệt thành công!</span>
            </div>
        </div>
        <script>

        </script>
    </body></html>