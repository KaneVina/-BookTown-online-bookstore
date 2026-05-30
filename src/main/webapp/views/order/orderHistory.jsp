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
                            "outline-variant": "#c2c6d4",
                            "surface-variant": "#cfe6f2",
                            "surface-container-low": "#e6f6ff",
                            "on-surface-variant": "#424752",
                            "secondary-container": "#fdd835",
                            "on-secondary-container": "#705e00"
                        },
                        fontFamily: {
                            sans: ["Inter", "sans-serif"]
                        }
                    }
                }
            }
        </script>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
            }
            body {
                background-color: #f3faff;
                font-family: 'Inter', sans-serif;
            }
            /* Custom Scrollbar cho phần tab khi thu nhỏ màn hình */
            .no-scrollbar::-webkit-scrollbar {
                display: none;
            }
            .no-scrollbar {
                -ms-overflow-style: none;
                scrollbar-width: none;
            }
        </style>
    </head>
    <body class="text-on-background antialiased">
        <main class="max-w-[1280px] mx-auto px-16 py-12 flex gap-6">

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
                        <h2 class="mt-4 font-semibold text-lg text-on-surface">${not empty user.fullName ? user.fullName : 'Trương Ngọc Trân'}</h2>
                        <div class="mt-1 px-3 py-0.5 bg-secondary-container text-on-secondary-container rounded-full text-xs font-medium flex items-center gap-1">
                            <span class="material-symbols-outlined text-[14px]" style="font-variation-settings: 'FILL' 1;">stars</span>
                            ${not empty user.membership ? user.membership : 'Thành viên Vàng'}
                        </div>
                    </div>

                    <nav class="space-y-1">
                        <a class="nav-item group flex items-center gap-3 px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-low font-medium text-sm transition-all" href="#thong-tin">
                            <span class="material-symbols-outlined text-[20px]">person</span>
                            Thông tin cá nhân
                        </a>
                        <a class="nav-item group flex items-center gap-3 px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-low font-medium text-sm transition-all" href="#doi-mat-khau">
                            <span class="material-symbols-outlined text-[20px]">lock</span>
                            Đổi mật khẩu
                        </a>
                        <a class="group flex items-center gap-3 px-4 py-3 rounded-lg text-on-surface-variant hover:bg-surface-container-low font-medium text-sm transition-all" href="#">
                            <span class="material-symbols-outlined text-[20px]">location_on</span>
                            Sổ địa chỉ
                        </a>

                        <a href="${pageContext.request.contextPath}/order-history" class="group flex items-center gap-3 px-4 py-3 rounded-lg bg-blue-50 text-[#17479D] font-bold text-sm transition-all">
                            <span class="material-symbols-outlined text-[20px]" style="font-variation-settings: 'FILL' 1;">history</span>
                            Lịch sử đơn hàng
                        </a>

                        <hr class="my-4 border-outline-variant opacity-30"/>
                        <a class="group flex items-center gap-3 px-4 py-3 rounded-lg text-red-600 hover:bg-red-50 font-medium text-sm transition-all" href="${pageContext.request.contextPath}/logout">
                            <span class="material-symbols-outlined text-[20px]">logout</span>
                            Đăng xuất
                        </a>
                    </nav>
                </div>
            </aside>

            <section class="flex-1 space-y-6">
                <div class="flex flex-col md:flex-row md:items-center justify-between gap-4">
                    <h1 class="text-2xl font-bold text-[#17479D]">Lịch sử đơn hàng của tôi</h1>
                    <div class="relative w-full md:w-72">
                        <input class="pl-10 pr-4 py-2 bg-surface border border-gray-300 rounded-full text-sm w-full focus:ring-2 focus:ring-primary focus:border-primary outline-none transition-all" placeholder="Tìm kiếm đơn hàng..." type="text"/>
                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-gray-400">search</span>
                    </div>
                </div>

                <div class="flex overflow-x-auto border-b border-gray-200 gap-8 no-scrollbar px-2">
                    <button class="py-3 font-semibold text-sm text-[#17479D] border-b-2 border-[#17479D] whitespace-nowrap">Tất cả</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Chờ xử lý</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Đang giao</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Hoàn thành</button>
                    <button class="py-3 font-medium text-sm text-gray-600 hover:text-[#17479D] whitespace-nowrap transition-colors">Đã hủy</button>
                </div>

                <div class="space-y-4">
                    <div class="bg-surface p-5 rounded-xl border border-gray-100 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-5">
                            <div class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200 shadow-inner">
                                <img class="w-full h-full object-cover" alt="Book Cover 1" src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=150"/>
                            </div>
                            <div class="space-y-1">
                                <p class="text-sm font-semibold text-[#17479D]">#BT-88902</p>
                                <p class="text-xs text-gray-500">Ngày đặt: 24/10/2023</p>
                                <p class="text-base font-bold text-gray-900">450.000đ</p>
                            </div>
                        </div>
                        <div class="flex items-center justify-between sm:justify-end gap-4">
                            <span class="px-3 py-1 bg-blue-50 text-blue-600 rounded-full text-xs font-medium flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px]">local_shipping</span>
                                Đang giao
                            </span>
                            <button class="px-5 py-1.5 border border-[#17479D] text-[#17479D] rounded-lg text-sm font-medium hover:bg-blue-50 transition-colors">
                               <a href="${pageContext.request.contextPath}/order-history-detail" >
                                    Chi tiết
                                </a>
                            </button>
                        </div>
                    </div>

                    <div class="bg-surface p-5 rounded-xl border border-gray-100 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-5">
                            <div class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200 shadow-inner">
                                <img class="w-full h-full object-cover" alt="Book Cover 2" src="https://images.unsplash.com/photo-1532012197267-da84d127e765?w=150"/>
                            </div>
                            <div class="space-y-1">
                                <p class="text-sm font-semibold text-[#17479D]">#BT-88741</p>
                                <p class="text-xs text-gray-500">Ngày đặt: 18/10/2023</p>
                                <p class="text-base font-bold text-gray-900">1.280.000đ</p>
                            </div>
                        </div>
                        <div class="flex items-center justify-between sm:justify-end gap-4">
                            <span class="px-3 py-1 bg-green-50 text-green-700 rounded-full text-xs font-medium flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px]">check_circle</span>
                                Đã hoàn thành
                            </span>
                            <button class="px-5 py-1.5 border border-[#17479D] text-[#17479D] rounded-lg text-sm font-medium hover:bg-blue-50 transition-colors">
                                 <a href="${pageContext.request.contextPath}/order-history-detail" >
                                    Chi tiết
                                </a>
                            </button>
                        </div>
                    </div>

                    <div class="bg-surface p-5 rounded-xl border border-gray-100 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-5">
                            <div class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200 shadow-inner">
                                <img class="w-full h-full object-cover" alt="Book Cover 3" src="https://images.unsplash.com/photo-1541963463532-d68292c34b19?w=150"/>
                            </div>
                            <div class="space-y-1">
                                <p class="text-sm font-semibold text-[#17479D]">#BT-88622</p>
                                <p class="text-xs text-gray-500">Ngày đặt: 10/10/2023</p>
                                <p class="text-base font-bold text-gray-900">325.000đ</p>
                            </div>
                        </div>
                        <div class="flex items-center justify-between sm:justify-end gap-4">
                            <span class="px-3 py-1 bg-red-50 text-red-500 rounded-full text-xs font-medium flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px]">cancel</span>
                                Đã hủy
                            </span>
                            <button class="px-5 py-1.5 border border-[#17479D] text-[#17479D] rounded-lg text-sm font-medium hover:bg-blue-50 transition-colors">
                               <a href="${pageContext.request.contextPath}/order-history-detail" >
                                    Chi tiết
                                </a>
                            </button>
                        </div>
                    </div>

                    <div class="bg-surface p-5 rounded-xl border border-gray-100 shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
                        <div class="flex items-center gap-5">
                            <div class="w-16 h-20 bg-gray-100 rounded overflow-hidden flex-shrink-0 border border-gray-200 shadow-inner">
                                <img class="w-full h-full object-cover" alt="Book Cover 4" src="https://images.unsplash.com/photo-1512820790803-83ca734da794?w=150"/>
                            </div>
                            <div class="space-y-1">
                                <p class="text-sm font-semibold text-[#17479D]">#BT-88590</p>
                                <p class="text-xs text-gray-500">Ngày đặt: 05/10/2023</p>
                                <p class="text-base font-bold text-gray-900">210.000đ</p>
                            </div>
                        </div>
                        <div class="flex items-center justify-between sm:justify-end gap-4">
                            <span class="px-3 py-1 bg-amber-50 text-amber-600 rounded-full text-xs font-medium flex items-center gap-1.5">
                                <span class="material-symbols-outlined text-[16px]">pending</span>
                                Chờ xử lý
                            </span>
                            <button class="px-5 py-1.5 border border-[#17479D] text-[#17479D] rounded-lg text-sm font-medium hover:bg-blue-50 transition-colors">
                                <a href="${pageContext.request.contextPath}/order-history-detail" >
                                    Chi tiết
                                </a>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="flex justify-center items-center gap-1.5 pt-4">
                    <button class="w-9 h-9 rounded-lg border border-gray-300 flex items-center justify-center text-gray-600 hover:bg-gray-50 transition-colors">
                        <span class="material-symbols-outlined text-[20px]">chevron_left</span>
                    </button>
                    <button class="w-9 h-9 rounded-lg bg-[#17479D] text-white font-semibold text-sm">1</button>
                    <button class="w-9 h-9 rounded-lg border border-gray-300 flex items-center justify-center text-sm text-gray-600 hover:bg-gray-50 transition-colors">2</button>
                    <button class="w-9 h-9 rounded-lg border border-gray-300 flex items-center justify-center text-sm text-gray-600 hover:bg-gray-50 transition-colors">3</button>
                    <button class="w-9 h-9 rounded-lg border border-gray-300 flex items-center justify-center text-gray-600 hover:bg-gray-50 transition-colors">
                        <span class="material-symbols-outlined text-[20px]">chevron_right</span>
                    </button>
                </div>
            </section>
        </main>
    </body>
</html>
<%@ include file="/views/layout/homepage/footer.jsp" %>