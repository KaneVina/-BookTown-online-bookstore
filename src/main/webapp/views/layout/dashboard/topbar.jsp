<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<style>
    .topbar-shadow {
        box-shadow: 0 4px 20px rgba(21, 101, 192, 0.08);
    }

    .topbar-icon-btn {
        padding: 8px;
        border-radius: 9999px;
        transition: all 0.2s ease;
    }

    .topbar-icon-btn:hover {
        background-color: #e6f6ff;
    }

    .topbar-search {
        width: 260px;
        padding: 8px 16px 8px 40px;
        border-radius: 9999px;
        border: none;
        outline: none;
        background: #e6f6ff;
    }

    .topbar-search:focus {
        background: white;
        box-shadow: 0 0 0 2px #004d99;
    }
</style>

<header class="flex justify-between items-center h-16 px-gutter w-full sticky top-0 z-50 bg-surface topbar-shadow">

    <div class="flex items-center gap-4">
        <button class="md:hidden topbar-icon-btn">
            <span class="material-symbols-outlined">menu</span>
        </button>
    </div>

    <div class="flex items-center gap-stack-sm">
        <!-- Search -->
        <div class="relative hidden sm:block">
            <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline-variant">
                search
            </span>
            <input
                type="text"
                placeholder="Tìm kiếm..."
                class="topbar-search">
        </div>
        <!-- Notification -->
        <button class="topbar-icon-btn relative">

            <span class="material-symbols-outlined text-on-surface-variant">
                notifications
            </span>
            <span class="absolute top-2 right-2 w-2 h-2 bg-error rounded-full"></span>
        </button>
        <!-- Help -->
        <button class="topbar-icon-btn">
            <span class="material-symbols-outlined text-on-surface-variant">
                help_outline
            </span>
        </button>
        <!-- Avatar -->
        <div class="relative group">
            <div class="flex items-center gap-3 cursor-pointer">
                <img
                    src="https://ui-avatars.com/api/?name=${sessionScope.account.fullname}"
                    alt="Avatar"
                    class="w-10 h-10 rounded-full border border-outline-variant object-cover">

                <div class="hidden md:flex flex-col">
                    <span class="text-xs text-gray-500">
                        Xin chào,
                    </span>

                    <span class="font-semibold text-sm">
                        ${sessionScope.account.fullname}
                    </span>
                </div>
            </div>
        </div>
    </div>
</header>