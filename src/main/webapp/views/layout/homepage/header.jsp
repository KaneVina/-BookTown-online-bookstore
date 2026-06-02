<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8">
        <title>BookTown - Thiên Đường Sách Trực Tuyến</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/assets/images/logo/logoBT_3.png">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&display=swap" rel="stylesheet">
        <style>
            /* Hỗ trợ đổi màu icon khi hover cho class group */
            .group:hover .lucide {
                stroke: currentColor;
            }
        </style>
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

        <div class="promo-bar text-center py-2.5 px-4 font-bold text-[22px] flex items-center justify-center gap-4 tracking-wider">
            <span class="bg-primary text-secondary text-[28px] font-black px-3.5 py-1 rounded-lg">2026</span>
            🎉 THÁNG MAY – THI HAY – THƯỞNG NGAY !!!
            <span class="bg-primary text-secondary text-[13px] px-3.5 py-1.5 rounded-full ml-2">BOOKTOWN</span>
        </div>

        <header class="bg-primary h-[70px] px-8 flex items-center gap-4 sticky top-0 z-50 shadow-md">
            <a href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/assets/images/logo/logoBT_1.png"
                     alt="BookTown Logo" class="w-[220px] mb-3"/>
            </a>

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

                <div class="flex items-center gap-3 text-white cursor-pointer relative" id="user-menu-wrapper">
                    <div class="flex items-center justify-center w-11 h-11 bg-white rounded-full text-blue-600">
                        <i data-lucide="user" class="w-6 h-6"></i>
                    </div>
                    <c:choose>
                        <c:when test="${not empty sessionScope.account}">
                            <div class="flex flex-col justify-center text-left select-none">
                                <span class="text-sm opacity-80">Xin chào,</span>
                                <span class="text-xl font-bold leading-tight flex items-center gap-1">
                                    ${sessionScope.account.fullname}
                                    <i data-lucide="chevron-down" class="w-4 h-4 transition-transform duration-200" id="chevron-icon"></i>
                                </span>
                            </div>

                            <div id="user-dropdown"
                                 class="absolute top-[calc(100%+0.5rem)] right-0 w-48 bg-white rounded-xl shadow-[0_8px_30px_rgb(0,0,0,0.12)] border border-gray-100 overflow-hidden z-50 opacity-0 invisible translate-y-[-8px] transition-all duration-200">
                                <div class="py-1.5">
                                    <a href="${pageContext.request.contextPath}/profile"
                                       class="flex items-center gap-3 px-4 py-2.5 text-gray-700 hover:bg-blue-50 hover:text-primary transition-all duration-200 text-sm font-medium group">
                                        <i data-lucide="user-circle" class="w-[18px] h-[18px] text-gray-400 group-hover:text-primary transition-colors"></i>
                                        Quản lý tài khoản
                                    </a>

                                    <div class="border-t border-gray-100 my-1"></div>

                                    <a href="${pageContext.request.contextPath}/logout"
                                       class="flex items-center gap-3 px-4 py-2.5 text-gray-700 hover:bg-red-50 hover:text-red-600 transition-all duration-200 text-sm font-medium group">
                                        <i data-lucide="log-out" class="w-[18px] h-[18px] text-gray-400 group-hover:text-red-600 transition-colors"></i>
                                        Đăng xuất
                                    </a>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="flex flex-col justify-center text-left">
                                <a href="${pageContext.request.contextPath}/login" class="text-xl font-bold leading-tight hover:underline">Đăng nhập</a>
                                <a href="${pageContext.request.contextPath}/register" class="text-sm opacity-90 hover:underline">Đăng ký</a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <a href="${pageContext.request.contextPath}/cart" class="relative flex flex-col items-center text-white text-xs cursor-pointer gap-0.5">
                    <i data-lucide="shopping-cart" class="icon-lg"></i>
                    <span>Giỏ hàng</span>
                    <span class="absolute -top-1.5 -right-2 bg-secondary text-primary text-[10px] font-bold rounded-full w-[18px] h-[18px] flex items-center justify-center">
                        ${empty sessionScope.cartCount ? 0 : sessionScope.cartCount}
                    </span>
                </a>
            </div>
        </header>

        <script>
            (function () {
                const wrapper = document.getElementById('user-menu-wrapper');
                const dropdown = document.getElementById('user-dropdown');
                const chevron = document.getElementById('chevron-icon');
                if (!wrapper || !dropdown)
                    return;

                let open = false;

                function showMenu() {
                    open = true;
                    dropdown.classList.remove('opacity-0', 'invisible', 'translate-y-[-8px]');
                    dropdown.classList.add('opacity-100', 'visible', 'translate-y-0');
                    if (chevron)
                        chevron.classList.add('rotate-180');
                }

                function hideMenu() {
                    open = false;
                    dropdown.classList.add('opacity-0', 'invisible', 'translate-y-[-8px]');
                    dropdown.classList.remove('opacity-100', 'visible', 'translate-y-0');
                    if (chevron)
                        chevron.classList.remove('rotate-180');
                }

                wrapper.addEventListener('click', function (e) {
                    open ? hideMenu() : showMenu();
                    e.stopPropagation();
                });

                document.addEventListener('click', function () {
                    if (open)
                        hideMenu();
                });

                dropdown.addEventListener('click', function (e) {
                    e.stopPropagation();
                });
            })();
        </script>

        <%@ include file="navbar.jsp" %>
    </body>
</html>