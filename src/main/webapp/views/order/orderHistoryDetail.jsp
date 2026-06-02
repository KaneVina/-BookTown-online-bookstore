<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<!DOCTYPE html>
<html lang="vi" class="light">
    <head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>

        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        colors: {
                            "primary-fixed": "#d6e3ff",
                            "inverse-surface": "#1e333c",
                            "tertiary-fixed": "#d9e2ff",
                            "surface-bright": "#f3faff",
                            "inverse-primary": "#a9c7ff",
                            "outline": "#727783",
                            "secondary-container": "#fdd835",
                            "surface-dim": "#c7dde9",
                            "surface-container": "#dbf1fe",
                            "on-primary": "#ffffff",
                            "surface-tint": "#005db7",
                            "primary-fixed-dim": "#a9c7ff",
                            "on-secondary-container": "#705e00",
                            "surface-variant": "#cfe6f2",
                            "surface-container-high": "#d5ecf8",
                            "secondary-fixed-dim": "#e8c41d",
                            "background": "#f3faff",
                            "on-secondary": "#ffffff",
                            "on-secondary-fixed-variant": "#544600",
                            "error": "#D32F2F",
                            "primary": "#004d99",
                            "on-primary-container": "#dae5ff",
                            "success": "#2E7D32",
                            "outline-variant": "#c2c6d4",
                            "on-surface": "#071e27",
                            "on-secondary-fixed": "#221b00",
                            "tertiary-fixed-dim": "#b0c6ff",
                            "surface-container-lowest": "#ffffff",
                            "surface": "#FFFFFF",
                            "on-tertiary-fixed": "#001945",
                            "surface-container-low": "#e6f6ff",
                            "tertiary-container": "#3563be",
                            "on-tertiary": "#ffffff",
                            "surface-container-highest": "#cfe6f2",
                            "on-primary-fixed-variant": "#00468c",
                            "on-primary-fixed": "#001b3d",
                            "tertiary": "#134aa4",
                            "inverse-on-surface": "#dff4ff",
                            "primary-container": "#1565c0",
                            "on-tertiary-fixed-variant": "#00429c",
                            "on-error-container": "#93000a",
                            "on-tertiary-container": "#dde5ff",
                            "on-background": "#071e27",
                            "on-error": "#ffffff",
                            "error-container": "#ffdad6",
                            "warning": "#FFA000",
                            "secondary-fixed": "#ffe16e",
                            "on-surface-variant": "#424752",
                            "background-alt": "#F5F7F9"
                        },
                        spacing: {
                            "margin-desktop": "64px",
                            "stack-lg": "48px",
                            "stack-md": "24px",
                            "container-max": "1280px",
                            "gutter": "24px",
                            "stack-sm": "12px",
                            "base": "8px",
                            "margin-mobile": "16px"
                        },
                        fontFamily: {
                            sans: ["Inter", "sans-serif"]
                        }
                    },
                },
            }
        </script>
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                display: inline-block;
                vertical-align: middle;
            }
            body {
                background-color: #f3faff;
            }
        </style>
    </head>
    <body class="text-on-background antialiased bg-background">
        <main class="max-w-container-max mx-auto px-margin-mobile md:px-margin-desktop py-stack-lg">

            <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
                <div>
                    <nav class="flex items-center gap-2 mb-2">
                        <a class="text-xs font-medium text-on-surface-variant hover:text-primary transition-colors" href="${pageContext.request.contextPath}/profile/order-history">Đơn hàng của tôi</a>
                        <span class="material-symbols-outlined text-xs text-outline">chevron_right</span>
                        <span class="text-xs text-primary font-bold">Chi tiết đơn hàng</span>
                    </nav>
                    <div class="flex flex-wrap items-center gap-3">
                        <h1 class="text-2xl font-bold text-on-surface">Đơn hàng #BT-88590</h1>
                        <span class="px-3 py-1 bg-amber-100 text-amber-700 font-bold text-xs rounded-full flex items-center gap-1">
                            <span class="w-1.5 h-1.5 bg-amber-500 rounded-full"></span>
                            Chờ xử lý
                        </span>
                    </div>
                    <p class="text-xs text-on-surface-variant mt-1.5">Ngày đặt: 24/05/2024 • 14:30</p>
                </div>
                <div class="flex gap-3 w-full md:w-auto">
                    <button class="flex-1 md:flex-none px-5 py-2 bg-surface border border-error text-error font-semibold text-sm rounded-lg hover:bg-red-50 transition-colors">
                        Hủy đơn hàng
                    </button>
                </div>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-12 gap-gutter">

                <div class="lg:col-span-8 space-y-6">

                    <section class="bg-surface p-6 rounded-xl border border-outline-variant/30 shadow-sm">
                        <h2 class="text-lg font-bold text-on-surface mb-6">Trạng thái vận chuyển</h2>
                        <div class="relative flex justify-between items-start">

                            <div class="absolute top-5 left-0 w-full h-1 bg-gray-200 z-0 rounded-full">
                                <div class="h-full bg-primary rounded-full transition-all" style="width: 15%;"></div>
                            </div>

                            <div class="relative z-10 flex flex-col items-center text-center">
                                <div class="w-10 h-10 rounded-full bg-primary text-on-primary flex items-center justify-center mb-2 shadow-sm">
                                    <span class="material-symbols-outlined text-[22px]" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                                </div>
                                <span class="text-xs font-bold text-primary">Đã đặt hàng</span>
                                <span class="text-[11px] text-on-surface-variant mt-0.5">24/05/2024</span>
                            </div>

                            <div class="relative z-10 flex flex-col items-center text-center">
                                <div class="w-10 h-10 rounded-full bg-surface-container-low text-primary flex items-center justify-center mb-2 border-2 border-primary shadow-sm">
                                    <span class="material-symbols-outlined text-[22px]">pending</span>
                                </div>
                                <span class="text-xs font-bold text-on-surface">Chờ xử lý</span>
                                <span class="text-[11px] text-on-surface-variant mt-0.5">Dự kiến 25/05</span>
                            </div>

                            <div class="relative z-10 flex flex-col items-center text-center opacity-40">
                                <div class="w-10 h-10 rounded-full bg-gray-100 text-gray-500 flex items-center justify-center mb-2 border border-gray-200">
                                    <span class="material-symbols-outlined text-[22px]">local_shipping</span>
                                </div>
                                <span class="text-xs font-semibold text-on-surface">Đang giao</span>
                            </div>

                            <div class="relative z-10 flex flex-col items-center text-center opacity-40">
                                <div class="w-10 h-10 rounded-full bg-gray-100 text-gray-500 flex items-center justify-center mb-2 border border-gray-200">
                                    <span class="material-symbols-outlined text-[22px]">package_2</span>
                                </div>
                                <span class="text-xs font-semibold text-on-surface">Đã nhận</span>
                            </div>
                        </div>
                    </section>

                    <section class="bg-surface rounded-xl border border-outline-variant/30 shadow-sm overflow-hidden">
                        <div class="p-5 border-b border-outline-variant/30 bg-gray-50/50">
                            <h2 class="text-base font-bold text-on-surface">Sản phẩm trong đơn hàng (2)</h2>
                        </div>
                        <div class="divide-y divide-outline-variant/30">

                            <div class="p-5 flex gap-5 hover:bg-gray-50/50 transition-colors group">
                                <div class="w-20 h-28 bg-gray-100 rounded-lg overflow-hidden border border-gray-200 shadow-sm flex-shrink-0">
                                    <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" alt="Chiến Tranh và Hòa Bình" src="https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=150"/>
                                </div>
                                <div class="flex-1 flex flex-col justify-between">
                                    <div class="flex justify-between items-start gap-4">
                                        <div>
                                            <h3 class="font-bold text-on-surface text-base group-hover:text-primary transition-colors">Chiến Tranh và Hòa Bình</h3>
                                            <p class="text-xs text-on-surface-variant mt-0.5">Tác giả: Leo Tolstoy</p>
                                            <p class="text-xs font-medium text-gray-500 mt-2">Số lượng: 1</p>
                                        </div>
                                        <p class="font-bold text-primary text-base">350.000₫</p>
                                    </div>
                                    <div class="mt-3 flex items-center gap-3 text-xs">
                                        <button class="text-primary font-semibold hover:underline">Xem chi tiết</button>
                                        <span class="text-gray-300">|</span>
                                        <button class="text-primary font-semibold hover:underline">Thêm vào yêu thích</button>
                                    </div>
                                </div>
                            </div>

                            <div class="p-5 flex gap-5 hover:bg-gray-50/50 transition-colors group">
                                <div class="w-20 h-28 bg-gray-100 rounded-lg overflow-hidden border border-gray-200 shadow-sm flex-shrink-0">
                                    <img class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" alt="Kỷ nguyên của những điều vô lý" src="https://images.unsplash.com/photo-1532012197267-da84d127e765?w=150"/>
                                </div>
                                <div class="flex-1 flex flex-col justify-between">
                                    <div class="flex justify-between items-start gap-4">
                                        <div>
                                            <h3 class="font-bold text-on-surface text-base group-hover:text-primary transition-colors">Kỷ nguyên của những điều vô lý</h3>
                                            <p class="text-xs text-on-surface-variant mt-0.5">Tác giả: Eric Hobsbawm</p>
                                            <p class="text-xs font-medium text-gray-500 mt-2">Số lượng: 1</p>
                                        </div>
                                        <p class="font-bold text-primary text-base">215.000₫</p>
                                    </div>
                                    <div class="mt-3 flex items-center gap-3 text-xs">
                                        <button class="text-primary font-semibold hover:underline">Xem chi tiết</button>
                                        <span class="text-gray-300">|</span>
                                        <button class="text-primary font-semibold hover:underline">Thêm vào yêu thích</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>
                </div>

                <div class="lg:col-span-4 space-y-6">

                    <section class="bg-surface p-5 rounded-xl border border-outline-variant/30 shadow-sm">
                        <div class="flex justify-between items-center mb-4">
                            <h2 class="text-xs font-bold uppercase tracking-wider text-on-surface-variant">Địa chỉ nhận hàng</h2>
                            <span class="material-symbols-outlined text-primary text-[20px]">location_on</span>
                        </div>
                        <div class="space-y-1 text-sm">
                            <p class="font-bold text-on-surface">Nguyễn Văn A</p>
                            <p class="text-xs text-on-surface-variant">090 123 4567</p>
                            <p class="text-xs text-on-surface-variant leading-relaxed">Số 123, Đường Lê Lợi, Phường Bến Thành, Quận 1, TP. Hồ Chí Minh</p>
                        </div>
                    </section>

                    <section class="bg-surface p-5 rounded-xl border border-outline-variant/30 shadow-sm">
                        <div class="flex justify-between items-center mb-4">
                            <h2 class="text-xs font-bold uppercase tracking-wider text-on-surface-variant">Thanh toán</h2>
                            <span class="material-symbols-outlined text-primary text-[20px]">payments</span>
                        </div>
                        <div class="flex items-center gap-3 mb-5 p-3 bg-surface-container-low rounded-lg border border-outline-variant/20">
                            <div class="bg-surface px-1.5 py-0.5 rounded border border-gray-200 shadow-sm flex items-center justify-center">
                                <span class="font-bold text-[11px] tracking-wider text-blue-800">VISA</span>
                            </div>
                            <div>
                                <p class="text-xs font-bold text-on-surface">Visa kết thúc bằng •••• 4242</p>
                                <p class="text-[11px] text-on-surface-variant mt-0.5">Đã thanh toán qua Cổng VNPay</p>
                            </div>
                        </div>
                        <div class="space-y-2.5 text-xs">
                            <div class="flex justify-between text-on-surface-variant">
                                <span>Tạm tính (2 sản phẩm)</span>
                                <span class="font-medium text-on-surface">565.000₫</span>
                            </div>
                            <div class="flex justify-between text-on-surface-variant">
                                <span>Phí vận chuyển</span>
                                <span class="font-medium text-on-surface">30.000₫</span>
                            </div>
                            <div class="flex justify-between text-success font-medium">
                                <span>Giảm giá vận chuyển</span>
                                <span>-30.000₫</span>
                            </div>
                            <div class="pt-3 border-t border-outline-variant/40 flex justify-between items-baseline">
                                <span class="text-sm font-bold text-on-surface">Tổng thanh toán</span>
                                <span class="text-lg font-bold text-primary">565.000₫</span>
                            </div>
                        </div>
                    </section>
                    </div>
                </div>
            </div>
        </main>
        <script>

        </script>
    </body>
</html>
<%@ include file="/views/layout/homepage/footer.jsp" %>