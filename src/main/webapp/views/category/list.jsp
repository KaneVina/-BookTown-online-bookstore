<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý thể loại - BookTown</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script>
            tailwind.config = {
                theme: {
                    extend: {
                        colors: {
                            primary: '#004d99', 'on-primary': '#ffffff', background: '#f3faff', surface: '#ffffff',
                            'surface-container': '#dbf1fe', 'surface-container-low': '#e6f6ff', 'surface-variant': '#cfe6f2',
                            'on-surface': '#071e27', 'on-surface-variant': '#424752', outline: '#727783', 'outline-variant': '#c2c6d4',
                            success: '#2E7D32', warning: '#FFA000', error: '#D32F2F', 'error-container': '#ffdad6'
                        },
                        fontFamily: {sans: ['Inter', 'sans-serif']},
                        boxShadow: {card: '0 4px 20px rgba(21,101,192,0.08)'}
                    }
                }
            }
        </script>
        <style>
            body { font-family: 'Inter', sans-serif; }
            .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24; vertical-align: middle; }
        </style>
    </head>
    <body class="bg-background text-on-surface flex min-h-screen">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen">
            <div class="px-6 py-8 max-w-6xl mx-auto space-y-8">
                <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
                    <div>
                        <h1 class="text-3xl font-bold text-on-surface">Quản lý thể loại</h1>
                        <p class="text-sm text-on-surface-variant mt-2">Tạo, cập nhật, xem chi tiết và lọc thể loại sách của BookTown.</p>
                    </div>
                    <c:if test="${canManageCategory}">
                        <a href="${pageContext.request.contextPath}/category?action=create"
                           class="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-5 py-3 text-sm font-bold text-white shadow-card hover:bg-[#003f7d] transition">
                            <span class="material-symbols-outlined text-[20px]">add</span>
                            Thêm thể loại
                        </a>
                    </c:if>
                </div>

                <c:if test="${not empty param.success}">
                    <div class="rounded-xl border border-green-200 bg-green-50 px-4 py-3 text-sm font-semibold text-green-700">
                        ${param.success}
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="rounded-xl border border-red-200 bg-red-50 px-4 py-3 text-sm font-semibold text-red-700">
                        ${param.error}
                    </div>
                </c:if>

                <section class="grid grid-cols-1 md:grid-cols-3 gap-4">
                    <div class="bg-surface rounded-2xl border border-outline-variant p-5 shadow-card">
                        <div class="flex items-center justify-between">
                            <div>
                                <p class="text-sm font-semibold text-primary">Tổng thể loại</p>
                                <p class="text-3xl font-extrabold mt-2">${totalCategories}</p>
                            </div>
                            <div class="w-12 h-12 rounded-xl bg-surface-container-low flex items-center justify-center text-primary">
                                <span class="material-symbols-outlined">category</span>
                            </div>
                        </div>
                    </div>
                    <div class="bg-surface rounded-2xl border border-outline-variant p-5 shadow-card md:col-span-2">
                        <form action="${pageContext.request.contextPath}/category" method="get" class="flex flex-col md:flex-row gap-3">
                            <div class="flex-1 relative">
                                <span class="material-symbols-outlined absolute left-4 top-1/2 -translate-y-1/2 text-on-surface-variant text-[20px]">search</span>
                                <input type="text" name="keyword" value="${keyword}"
                                       placeholder="Tìm kiếm thể loại..."
                                       class="w-full rounded-xl border-outline-variant bg-surface-container-low pl-12 pr-4 py-3 text-sm focus:border-primary focus:ring-primary">
                            </div>
                            <button type="submit" class="inline-flex items-center justify-center gap-2 rounded-xl bg-primary px-6 py-3 text-sm font-bold text-white hover:bg-[#003f7d] transition">
                                <span class="material-symbols-outlined text-[19px]">filter_alt</span>
                                Tìm kiếm
                            </button>
                            <a href="${pageContext.request.contextPath}/category"
                               class="inline-flex items-center justify-center rounded-xl border border-outline-variant bg-white px-5 py-3 text-sm font-semibold text-primary hover:bg-surface-container-low transition">
                                Hủy
                            </a>
                        </form>
                    </div>
                </section>

                <section class="bg-surface rounded-2xl border border-outline-variant shadow-card overflow-hidden">
                    <div class="px-6 py-5 border-b border-outline-variant flex items-center justify-between">
                        <div>
                            <h2 class="text-xl font-bold">Danh sách thể loại</h2>
                            <p class="text-sm text-on-surface-variant mt-1">
                        </div>
                    </div>

                    <div class="overflow-x-auto">
                        <table class="w-full text-left">
                            <thead class="bg-surface-container-low">
                                <tr>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant">Mã thể loại</th>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant">Tên thể loại</th>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant">Số sách</th>
                                    <th class="px-6 py-4 text-xs font-bold uppercase tracking-wide text-on-surface-variant text-right">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-outline-variant">
                                <c:forEach var="genre" items="${genres}">
                                    <tr class="hover:bg-surface-container-low transition">
                                        <td class="px-6 py-4 text-sm font-bold text-primary">#CAT-${genre.genreID}</td>
                                        <td class="px-6 py-4 text-sm font-semibold text-on-surface">${genre.genreName}</td>
                                        <td class="px-6 py-4 text-sm text-on-surface-variant">${genre.bookCount}</td>
                                        <td class="px-6 py-4">
                                            <div class="flex items-center justify-end gap-2">
                                                <a href="${pageContext.request.contextPath}/category?action=detail&id=${genre.genreID}"
                                                   class="w-9 h-9 rounded-lg border border-outline-variant flex items-center justify-center text-primary hover:bg-surface-container-low" title="Xem chi tiết">
                                                    <span class="material-symbols-outlined text-[18px]">visibility</span>
                                                </a>
                                                <c:if test="${canManageCategory}">
                                                    <form action="${pageContext.request.contextPath}/category" method="post" onsubmit="openDeleteCategoryModal(this); return false;">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="id" value="${genre.genreID}">
                                                        <button type="submit" class="w-9 h-9 rounded-lg border border-red-200 flex items-center justify-center text-error hover:bg-red-50" title="Xóa">
                                                            <span class="material-symbols-outlined text-[18px]">delete</span>
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty genres}">
                                    <tr>
                                        <td colspan="4" class="px-6 py-12 text-center text-sm text-on-surface-variant">Không tìm thấy thể loại nào.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>
        </main>

        <div id="deleteCategoryModal" class="fixed inset-0 z-[9999] hidden items-center justify-center bg-slate-900/45 p-5">
            <div class="w-full max-w-sm rounded-xl bg-white p-6 shadow-2xl">
                <div class="flex items-center justify-between gap-4">
                    <h2 class="text-xl font-extrabold">Xóa thể loại</h2>
                    <button type="button" onclick="closeDeleteCategoryModal()" class="text-2xl leading-none text-gray-500">&times;</button>
                </div>
                <p class="mt-5 text-sm text-on-surface-variant">Bạn có chắc muốn xóa thể loại này không?</p>
                <div class="mt-6 grid grid-cols-2 gap-3">
                    <button type="button" onclick="closeDeleteCategoryModal()"
                            class="rounded-lg border border-outline-variant bg-white px-4 py-3 font-bold text-on-surface">Hủy</button>
                    <button type="button" onclick="confirmDeleteCategory()"
                            class="rounded-lg bg-primary px-4 py-3 font-bold text-white">Xác nhận</button>
                </div>
            </div>
        </div>

        <%@ include file="/views/layout/common/toast.jsp" %>
        <script>
            let pendingDeleteCategoryForm = null;

            function openDeleteCategoryModal(form) {
                pendingDeleteCategoryForm = form;
                const modal = document.getElementById('deleteCategoryModal');
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }

            function closeDeleteCategoryModal() {
                const modal = document.getElementById('deleteCategoryModal');
                modal.classList.add('hidden');
                modal.classList.remove('flex');
                pendingDeleteCategoryForm = null;
            }

            function confirmDeleteCategory() {
                if (pendingDeleteCategoryForm) {
                    pendingDeleteCategoryForm.submit();
                }
            }

            document.getElementById('deleteCategoryModal').addEventListener('click', function (event) {
                if (event.target === this) {
                    closeDeleteCategoryModal();
                }
            });
        </script>
    </body>
</html>
