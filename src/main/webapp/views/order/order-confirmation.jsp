<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&amp;display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&amp;display=swap" rel="stylesheet">
        <style>
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 48;
            }
            .success-checkmark-animation {
                animation: scaleIn 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275) both;
            }
            @keyframes scaleIn {
                from {
                    transform: scale(0);
                    opacity: 0;
                }
                to {
                    transform: scale(1);
                    opacity: 1;
                }
            }
        </style>
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "on-tertiary": "#ffffff",
                            "on-secondary-container": "#705e00",
                            "primary-container": "#1565c0",
                            "on-error": "#ffffff",
                            "secondary-fixed-dim": "#e8c41d",
                            "on-primary-fixed-variant": "#00468c",
                            "primary-fixed": "#d6e3ff",
                            "surface-container-high": "#d5ecf8",
                            "on-tertiary-fixed-variant": "#00429c",
                            "warning": "#FFA000",
                            "on-error-container": "#93000a",
                            "surface-container": "#dbf1fe",
                            "inverse-primary": "#a9c7ff",
                            "surface-variant": "#cfe6f2",
                            "secondary-fixed": "#ffe16e",
                            "primary": "#004d99",
                            "on-surface": "#071e27",
                            "secondary-container": "#fdd835",
                            "error-container": "#ffdad6",
                            "tertiary": "#134aa4",
                            "secondary": "#705d00",
                            "primary-fixed-dim": "#a9c7ff",
                            "tertiary-container": "#3563be",
                            "background-alt": "#F5F7F9",
                            "on-secondary": "#ffffff",
                            "on-secondary-fixed": "#221b00",
                            "on-primary-fixed": "#001b3d",
                            "outline": "#727783",
                            "error": "#D32F2F",
                            "on-tertiary-fixed": "#001945",
                            "inverse-surface": "#1e333c",
                            "on-tertiary-container": "#dde5ff",
                            "on-secondary-fixed-variant": "#544600",
                            "surface-container-lowest": "#ffffff",
                            "surface-tint": "#005db7",
                            "tertiary-fixed-dim": "#b0c6ff",
                            "surface-bright": "#f3faff",
                            "surface-container-low": "#e6f6ff",
                            "on-primary": "#ffffff",
                            "on-primary-container": "#dae5ff",
                            "surface": "#FFFFFF",
                            "tertiary-fixed": "#d9e2ff",
                            "surface-dim": "#c7dde9",
                            "outline-variant": "#c2c6d4",
                            "surface-container-highest": "#cfe6f2",
                            "success": "#2E7D32",
                            "on-surface-variant": "#424752",
                            "on-background": "#071e27",
                            "background": "#f3faff",
                            "inverse-on-surface": "#dff4ff"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "margin-desktop": "64px",
                            "gutter": "24px",
                            "stack-md": "24px",
                            "stack-lg": "48px",
                            "margin-mobile": "16px",
                            "container-max": "1280px",
                            "stack-sm": "12px",
                            "base": "8px"
                        },
                        "fontFamily": {
                            "headline-md": ["Inter"],
                            "headline-lg": ["Inter"],
                            "body-lg": ["Inter"],
                            "label-sm": ["Inter"],
                            "headline-sm": ["Inter"],
                            "label-md": ["Inter"],
                            "body-sm": ["Inter"],
                            "headline-xl": ["Inter"],
                            "headline-lg-mobile": ["Inter"],
                            "body-md": ["Inter"]
                        },
                        "fontSize": {
                            "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                            "headline-lg": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                            "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                            "label-sm": ["12px", {"lineHeight": "16px", "fontWeight": "500"}],
                            "headline-sm": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                            "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.01em", "fontWeight": "600"}],
                            "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                            "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                            "headline-lg-mobile": ["28px", {"lineHeight": "36px", "fontWeight": "700"}],
                            "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}]
                        }
                    },
                },
            }
        </script>
    </head>
    <body class="bg-background text-on-background min-h-screen flex flex-col font-body-md">
       <%@ include file="/views/layout/homepage/header.jsp" %>
        <%@ include file="/views/layout/common/toast.jsp" %>
        <main class="flex-grow pt-32 pb-stack-lg px-margin-mobile md:px-margin-desktop max-w-container-max mx-auto w-full">
            <div class="max-w-3xl mx-auto flex flex-col items-center text-center">
                <div class="success-checkmark-animation bg-success/10 rounded-full p-8 mb-stack-md">
                    <span class="material-symbols-outlined text-[80px] text-success leading-none" data-icon="check_circle" data-weight="fill" style="font-variation-settings: 'FILL' 1;">check_circle</span>
                </div>
                <h1 class="font-headline-xl text-headline-xl text-primary mb-4 md:text-headline-xl text-headline-lg-mobile">
                    Đặt hàng thành công!
                </h1>
                <p class="font-body-lg text-body-lg text-on-surface-variant max-w-xl mb-stack-lg">
                    Cảm ơn bạn đã mua sắm tại BookTown. Mã đơn hàng của bạn là <span class="font-bold text-on-surface">#BT-${order.orderID}</span>. Chúng tôi sẽ sớm liên hệ để xác nhận đơn hàng.
                </p>
                <div class="w-full bg-surface border border-outline-variant rounded-xl p-6 mb-stack-lg shadow-sm text-left">
                    <h3 class="font-headline-sm text-headline-sm text-on-surface mb-4 border-b border-outline-variant pb-2">Tóm tắt đơn hàng</h3>
                    <div class="space-y-3">
                        <div class="flex justify-between items-center">
                            <span class="text-on-surface-variant font-body-md text-body-md">Mã đơn hàng</span>
                            <span class="text-on-surface font-label-md text-label-md">#BT-${order.orderID}</span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-on-surface-variant font-body-md text-body-md">Phương thức thanh toán</span>
                            <span class="text-on-surface font-label-md text-label-md">
                                <c:choose>
                                    <c:when test="${order.paymentMethod == 'cod'}">Thanh toán khi nhận hàng (COD)</c:when>
                                    <c:otherwise>${order.paymentMethod}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="flex justify-between items-center">
                            <span class="text-on-surface-variant font-body-md text-body-md">Trạng thái</span>
                            <span class="text-on-surface font-label-md text-label-md">Chờ xác nhận</span>
                        </div>
                        <div class="flex justify-between items-center pt-2 border-t border-outline-variant/50">
                            <span class="text-on-surface font-headline-sm text-headline-sm">Tổng thanh toán</span>
                            <span class="text-primary font-headline-sm text-headline-sm">
                                <fmt:formatNumber value="${order.totalPrice}" type="number" groupingUsed="true"/>đ
                            </span>
                        </div>
                    </div>
                </div>
                <div class="flex flex-col md:flex-row gap-4 w-full md:w-auto">
                    <a href="${pageContext.request.contextPath}/profile/order-history" class="px-8 py-3 rounded-full font-label-md text-label-md bg-secondary-container text-on-secondary-container hover:shadow-lg transition-all active:scale-95 flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined" data-icon="history">history</span>
                        Xem lịch sử đơn hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="px-8 py-3 rounded-full font-label-md text-label-md border-2 border-primary text-primary bg-transparent hover:bg-primary-fixed-dim transition-all active:scale-95 flex items-center justify-center gap-2">
                        <span class="material-symbols-outlined" data-icon="shopping_bag">shopping_bag</span>
                        Tiếp tục mua sắm
                    </a>
                </div>
                <div class="mt-stack-lg grid grid-cols-2 md:grid-cols-4 gap-gutter opacity-40">
                    <div class="h-1 bg-primary/20 rounded-full"></div>
                    <div class="h-1 bg-secondary/20 rounded-full"></div>
                    <div class="h-1 bg-tertiary/20 rounded-full"></div>
                    <div class="h-1 bg-success/20 rounded-full"></div>
                </div>
            </div>
        </main>
    </body>
</html>
<%@ include file="/views/layout/homepage/footer.jsp" %>