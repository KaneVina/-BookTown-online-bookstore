<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>

<style>
    .section-title-left {
        border-left: 4px solid #FDD835;
        padding-left: 12px;
    }
</style>

<main class="max-w-[1400px] mx-auto px-8 py-8 flex flex-col gap-6 min-h-[500px]">
    
    <!-- Breadcrumbs -->
    <nav class="text-[13px] text-gray-500">
        <a href="${pageContext.request.contextPath}/home" class="hover:text-primary transition-colors">Trang chủ</a>
        <span class="mx-1.5">&gt;</span>
        <span class="text-gray-400 font-medium">Danh sách yêu thích</span>
    </nav>

    <!-- Title and Subtitle Row -->
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div>
            <h1 class="section-title-left text-[24px] font-black text-primary uppercase tracking-wide">Danh sách yêu thích</h1>
            <p class="text-gray-400 text-[14px] mt-1.5">Lưu lại những cuốn sách bạn yêu thích để dễ dàng mua sắm sau này.</p>
        </div>
        <c:if test="${not empty wishlistBooks}">
            <div class="self-start sm:self-auto">
                <span class="bg-[#E3F2FD] text-primary text-[12px] font-bold px-4 py-2 rounded-md uppercase tracking-wider">
                    ${wishlistBooks.size()} cuốn sách
                </span>
            </div>
        </c:if>
    </div>

    <!-- Alert Notifications -->
    <c:if test="${param.success == 'moveToCart'}">
        <div class="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded-xl flex items-center gap-3 shadow-sm">
            <div class="w-7 h-7 bg-green-500/10 rounded-full flex items-center justify-center text-green-600">
                <i data-lucide="check-circle" class="w-4 h-4"></i>
            </div>
            <span class="text-[13px] font-semibold">Đã chuyển sản phẩm vào giỏ hàng thành công!</span>
        </div>
    </c:if>
    <c:if test="${param.error == 'moveToCart'}">
        <div class="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl flex items-center gap-3 shadow-sm">
            <div class="w-7 h-7 bg-red-500/10 rounded-full flex items-center justify-center text-red-600">
                <i data-lucide="alert-circle" class="w-4 h-4"></i>
            </div>
            <span class="text-[13px] font-semibold">Đã xảy ra lỗi khi chuyển sản phẩm vào giỏ hàng. Vui lòng thử lại.</span>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty wishlistBooks}">
            <!-- Wishlist Table Card -->
            <div class="bg-white border border-gray-200 rounded-xl overflow-hidden shadow-sm">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="border-b border-gray-200 bg-gray-50/50">
                                <th class="px-6 py-4 text-[12px] font-bold text-gray-400 uppercase tracking-wider w-[45%]">Sản phẩm</th>
                                <th class="px-6 py-4 text-[12px] font-bold text-gray-400 uppercase tracking-wider">Giá</th>
                                <th class="px-6 py-4 text-[12px] font-bold text-gray-400 uppercase tracking-wider">Tình trạng kho</th>
                                <th class="px-6 py-4 text-[12px] font-bold text-gray-400 uppercase tracking-wider text-right w-[25%]">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-150">
                            <c:forEach var="book" items="${wishlistBooks}">
                                <tr>
                                    <!-- Product Column -->
                                    <td class="px-6 py-5">
                                        <div class="flex items-center gap-4">
                                            <!-- Cover Image Container -->
                                            <div class="relative w-16 h-22 bg-[#f0f4ff] rounded overflow-visible flex-shrink-0 flex items-center justify-center border border-gray-100">
                                                <c:choose>
                                                    <c:when test="${not empty book.thumbnail}">
                                                        <img src="${book.thumbnail}" alt="${book.title}" class="w-full h-full object-cover rounded">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i data-lucide="book-open" class="w-8 h-8 text-gray-300"></i>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <!-- Remove Button Overlay -->
                                                <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="absolute -top-1.5 -right-1.5 z-10">
                                                    <input type="hidden" name="action" value="remove" />
                                                    <input type="hidden" name="bookID" value="${book.bookID}" />
                                                    <button type="submit" class="w-4 h-4 bg-red-100 hover:bg-red-200 text-red-600 rounded-full flex items-center justify-center shadow-sm border border-red-200 transition-colors" title="Xóa khỏi yêu thích">
                                                        <span class="text-[10px] font-black leading-none">&times;</span>
                                                    </button>
                                                </form>
                                            </div>
                                            <!-- Book Title -->
                                            <div class="min-w-0">
                                                <a href="${pageContext.request.contextPath}/products?id=${book.bookID}" class="font-bold text-gray-800 hover:text-primary transition-colors text-[15px] line-clamp-2">
                                                    ${book.title}
                                                </a>
                                            </div>
                                        </div>
                                    </td>
                                    
                                    <!-- Price Column -->
                                    <td class="px-6 py-5 align-middle">
                                        <span class="text-primary font-bold text-[15px]">
                                            <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" />đ
                                        </span>
                                    </td>
                                    
                                    <!-- Stock Status Column -->
                                    <td class="px-6 py-5 align-middle">
                                        <c:choose>
                                            <c:when test="${book.stockQuantity > 0}">
                                                <span class="text-green-600 font-bold text-[12px] uppercase">Còn hàng</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-red-500 font-bold text-[12px] uppercase">Hết hàng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    
                                    <!-- Actions Column -->
                                    <td class="px-6 py-5 align-middle text-right">
                                        <div class="flex items-center justify-end gap-3">
                                            <!-- Quick View Button -->
                                            <a href="${pageContext.request.contextPath}/products?id=${book.bookID}" class="px-3.5 py-1.5 border border-gray-300 text-gray-500 hover:bg-gray-50 hover:text-gray-700 rounded text-[11px] font-bold transition-all uppercase tracking-wide">
                                                Xem nhanh
                                            </a>
                                            <!-- Add to Cart Button -->
                                            <c:choose>
                                                <c:when test="${book.stockQuantity > 0}">
                                                    <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="inline">
                                                        <input type="hidden" name="action" value="moveToCart" />
                                                        <input type="hidden" name="bookID" value="${book.bookID}" />
                                                        <button type="submit" class="px-4 py-2 bg-primary hover:bg-primary-dark text-white rounded text-[11px] font-bold transition-all uppercase tracking-wide shadow-sm">
                                                            Thêm vào giỏ
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" disabled class="px-4 py-2 bg-gray-100 text-gray-400 border border-gray-200 rounded text-[11px] font-bold cursor-not-allowed uppercase tracking-wide">
                                                        Thêm vào giỏ
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="flex flex-col items-center justify-center py-20 bg-white border border-gray-150 rounded-2xl shadow-sm px-6">
                <div class="w-20 h-20 bg-red-50 text-red-500 rounded-full flex items-center justify-center mb-4">
                    <i data-lucide="heart" class="w-10 h-10" style="stroke-width:1.5"></i>
                </div>
                <h3 class="text-xl font-bold text-gray-800">Danh sách yêu thích trống</h3>
                <p class="text-gray-500 mt-2 text-center max-w-md">Bạn chưa lưu bất kỳ sản phẩm nào. Hãy khám phá và thêm những cuốn sách bạn yêu thích vào danh sách này nhé!</p>
                <a href="${pageContext.request.contextPath}/home" class="mt-6 bg-secondary text-primary font-bold px-6 py-3 rounded-full hover:opacity-90 transition-opacity">
                    QUAY LẠI TRANG CHỦ
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<%@ include file="/views/layout/homepage/footer.jsp" %>
