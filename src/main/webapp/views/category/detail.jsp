<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết thể loại - BookTown</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script>
            tailwind.config = {theme: {extend: {colors: {primary: '#004d99', background: '#f3faff', surface: '#ffffff', 'surface-container-low': '#e6f6ff', 'on-surface': '#071e27', 'on-surface-variant': '#424752', 'outline-variant': '#c2c6d4'}, fontFamily: {sans: ['Inter', 'sans-serif']}, boxShadow: {card: '0 4px 20px rgba(21,101,192,0.08)'}}}}
        </script>
        <style>body{font-family:'Inter',sans-serif}.material-symbols-outlined{vertical-align:middle}</style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>
        <main class="flex-1 md:ml-64 min-h-screen">
            <div class="px-6 py-8 max-w-3xl mx-auto space-y-6">
                <a href="${pageContext.request.contextPath}/category" class="inline-flex items-center gap-2 text-sm font-semibold text-primary hover:underline">
                    <span class="material-symbols-outlined text-[18px]">arrow_back</span>
                    Quay lại danh sách
                </a>

                <section class="bg-surface rounded-2xl border border-outline-variant shadow-card overflow-hidden">
                    <div class="px-6 py-5 border-b border-outline-variant flex items-center justify-between">
                        <div>
                            <h1 class="text-2xl font-bold">Chi tiết thể loại</h1>
                            <p class="text-sm text-on-surface-variant mt-1">Thông tin chi tiết của thể loại sách.</p>
                        </div>
                        <c:if test="${canManageCategory}">
                            <a href="${pageContext.request.contextPath}/category?action=edit&id=${genre.genreID}"
                               class="inline-flex items-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-white hover:bg-[#003f7d] transition">
                                <span class="material-symbols-outlined text-[18px]">edit</span>
                                Cập nhật
                            </a>
                        </c:if>
                    </div>

                    <div class="p-6 grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="rounded-xl bg-surface-container-low p-5">
                            <p class="text-sm font-semibold text-on-surface-variant">Mã thể loại</p>
                            <p class="text-2xl font-extrabold text-primary mt-2">#CAT-${genre.genreID}</p>
                        </div>
                        <div class="rounded-xl bg-surface-container-low p-5 md:col-span-2">
                            <p class="text-sm font-semibold text-on-surface-variant">Tên thể loại</p>
                            <p class="text-2xl font-extrabold mt-2">${genre.genreName}</p>
                        </div>
                        <div class="rounded-xl bg-surface-container-low p-5 md:col-span-3">
                            <p class="text-sm font-semibold text-on-surface-variant">Số sách đang thuộc thể loại này</p>
                            <p class="text-2xl font-extrabold mt-2">${genre.bookCount}</p>
                        </div>
                    </div>
                </section>
            </div>
        </main>
    </body>
</html>
