<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>BookTown - Thiên Đường Sách Trực Tuyến</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "primary": "#17479D",
                            "primary-dark": "#0D47A1",
                            "primary-light": "#1976D2",
                            "secondary": "#FDD835",
                            "background": "#f4f4f4",
                            "surface": "#FFFFFF",
                            "on-surface": "#222222",
                            "on-primary": "#FFFFFF",
                            "on-secondary": "#1565C0"
                        },
                        "fontFamily": {
                            "sans": ["Roboto", "sans-serif"]
                        }
                    }
                }
            }
        </script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/main.css">
    </head>
    <body class="text-on-surface">

        <!-- PROMO BAR -->
        <div class="promo-bar text-center py-2.5 px-4 font-bold text-[22px] flex items-center justify-center gap-4 tracking-wider">
            <span class="bg-primary text-secondary text-[28px] font-black px-3.5 py-1 rounded-lg">2026</span>
            🎉 THÁNG MAY – THI HAY – THƯỞNG NGAY !!!
            <span class="bg-primary text-secondary text-[13px] px-3.5 py-1.5 rounded-full ml-2">BOOKTOWN</span>
        </div>

        <!-- NAVBAR -->
        <header class="bg-primary h-[70px] px-8 flex items-center gap-4 sticky top-0 z-50 shadow-md">
            <img src="${pageContext.request.contextPath}/assets/images/logo/logoBT_1.png"
                 alt="BookTown Logo" class="w-[220px] mb-3"/>

            <div class="flex-1 flex max-w-[600px] mx-4">
                <input class="flex-1 border-none px-4 py-2.5 text-[15px] rounded-l focus:ring-0 outline-none"
                       placeholder="Tìm kiếm sách, tác giả..." type="text">
                <button class="bg-secondary px-4 rounded-r flex items-center justify-center w-[54px] hover:opacity-90">
                    <i data-lucide="search" class="icon-lg text-primary" style="color:#1565C0;stroke-width:2.5"></i>
                </button>
            </div>

            <div class="flex items-center gap-6 ml-auto">
                <div class="hidden lg:block text-right text-white cursor-pointer">
                    <strong class="block text-lg font-bold leading-tight">19006656</strong>
                    <span class="text-[11px] opacity-80 uppercase">Hỗ trợ khách hàng</span>
                </div>

                <div class="flex items-center gap-3 text-white cursor-pointer">
                    <div class="flex items-center justify-center w-11 h-11 bg-white rounded-full text-blue-600">
                        <i data-lucide="user" class="w-6 h-6"></i> 
                    </div>
                    <div class="flex flex-col justify-center text-left">
                        <a href="${pageContext.request.contextPath}/login" class="text-xl font-bold leading-tight hover:underline">Đăng nhập</a>
                        <a href="${pageContext.request.contextPath}/register" class="text-sm opacity-90 hover:underline">Đăng ký</a>
                    </div>
                </div>

                <div class="relative flex flex-col items-center text-white text-xs cursor-pointer gap-0.5">
                    <i data-lucide="shopping-cart" class="icon-lg"></i>
                    <span>Giỏ hàng</span>
                    <span class="absolute -top-1.5 -right-2 bg-secondary text-primary text-[10px] font-bold rounded-full w-[18px] h-[18px] flex items-center justify-center">0</span>
                </div>
            </div>
        </header>

        <!-- CATEGORY NAV -->
        <nav class="bg-primary-light flex overflow-x-auto">
            <div class="cat-nav-item flex items-center gap-1.5 px-5 py-3 text-white text-sm font-medium cursor-pointer transition-colors whitespace-nowrap">
                <span>🇻🇳</span> Sách Việt Nam <i data-lucide="chevron-down" class="icon-sm opacity-70 ml-0.5"></i>
            </div>
            <div class="cat-nav-item flex items-center gap-1.5 px-5 py-3 text-white text-sm font-medium cursor-pointer transition-colors whitespace-nowrap">
                <span>🌐</span> Foreign Books <i data-lucide="chevron-down" class="icon-sm opacity-70 ml-0.5"></i>
            </div>
            <div class="cat-nav-item flex items-center gap-1.5 px-5 py-3 text-white text-sm font-medium cursor-pointer transition-colors whitespace-nowrap">
                <span>✏️</span> Văn Phòng Phẩm <i data-lucide="chevron-down" class="icon-sm opacity-70 ml-0.5"></i>
            </div>
            <div class="cat-nav-item flex items-center gap-1.5 px-5 py-3 text-white text-sm font-medium cursor-pointer transition-colors whitespace-nowrap">
                <span>🎮</span> Đồ Chơi <i data-lucide="chevron-down" class="icon-sm opacity-70 ml-0.5"></i>
            </div>
            <div class="cat-nav-item flex items-center gap-1.5 px-5 py-3 text-white text-sm font-medium cursor-pointer transition-colors whitespace-nowrap">
                <span>🎁</span> Quà Tặng – Lưu Niệm <i data-lucide="chevron-down" class="icon-sm opacity-70 ml-0.5"></i>
            </div>
            <div class="cat-nav-item flex items-center gap-1.5 px-5 py-3 text-white text-sm font-medium cursor-pointer transition-colors whitespace-nowrap">
                <span>🔖</span> Danh Mục Khác <i data-lucide="chevron-down" class="icon-sm opacity-70 ml-0.5"></i>
            </div>
        </nav>
