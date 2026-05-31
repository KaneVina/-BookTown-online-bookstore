<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>

<main class="max-w-[1400px] mx-auto px-8 py-7" style="background: #F4F4F4; min-height: 100vh;">

    <!-- ══════════════════════════════════════════════════════════════ -->
    <!-- 2.3 – SÁCH NỔI BẬT (chỉ hiện trên homepage, ẩn trên /products) -->
    <!-- ══════════════════════════════════════════════════════════════ -->
    <c:if test="${not empty featuredBooks}">
        <section class="mb-12">
            <div class="flex justify-between items-center mb-5">
                <h2 class="section-title-border text-xl font-bold text-primary pl-3">🔥 Sách Bán Chạy</h2>
                <a href="${pageContext.request.contextPath}/products"
                   class="text-[13px] text-primary font-medium border border-primary px-3.5 py-1.5 rounded-full hover:bg-primary hover:text-white transition-colors uppercase tracking-tight">
                    Xem tất cả
                </a>
            </div>

            <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
                <c:forEach var="book" items="${featuredBooks}">
                    <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                        <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                            <c:choose>
                                <c:when test="${not empty book.thumbnail}">
                                    <img alt="${book.title}" class="w-full h-full object-cover"
                                         src="${book.thumbnail}">
                                </c:when>
                                <c:otherwise>
                                    <i data-lucide="book" class="w-16 h-16 text-gray-300"></i>
                                </c:otherwise>
                            </c:choose>
                            <div class="absolute top-2.5 left-2.5 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">🔥 Hot</div>
                        </div>
                        <div class="p-3 flex flex-col flex-1">
                            <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                                <a class="text-primary hover:underline"
                                   href="${pageContext.request.contextPath}/products?id=${book.bookID}">
                                    ${book.title}
                                    <c:if test="${not empty book.authors}"> – ${book.authorsDisplay}</c:if>
                                </a>
                            </div>
                            <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                                <c:set var="rating" value="${book.avgRating}" />
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= rating}">★</c:when>
                                        <c:otherwise>☆</c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span class="text-gray-400 text-[11px]">(${book.reviewCount})</span>
                            </div>
                            <div class="text-primary text-[17px] font-bold mb-2.5">
                                <fmt:formatNumber value="${book.price}" type="number" maxFractionDigits="0"/>đ
                            </div>
                            <a href="${pageContext.request.contextPath}/products?id=${book.bookID}"
                               class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                                <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:if>

    <!-- ══════════════════════════════════════════════════════════════ -->
    <!-- 2.1 – DANH SÁCH SÁCH (phân trang + sắp xếp)                  -->
    <!-- ══════════════════════════════════════════════════════════════ -->
    <section class="mb-8">
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-5">
            <h2 class="section-title-border text-xl font-bold text-primary pl-3">
                📚 Tất Cả Sách
                <span class="text-sm text-gray-400 font-normal ml-2">(${totalBooks} cuốn)</span>
            </h2>

            <!-- Sort -->
            <form method="get" action="${pageContext.request.contextPath}/products" class="flex items-center gap-2">
                <label class="text-[13px] text-gray-500">Sắp xếp:</label>
                <select name="sort" onchange="this.form.submit()"
                        class="text-[13px] border border-gray-300 rounded-full px-3 py-1.5 focus:outline-none focus:border-primary cursor-pointer">
                    <option value=""         ${empty sort ? 'selected' : ''}>Mặc định</option>
                    <option value="newest"   ${sort == 'newest'    ? 'selected' : ''}>Mới nhất</option>
                    <option value="name"     ${sort == 'name'      ? 'selected' : ''}>Tên A–Z</option>
                    <option value="price_asc"  ${sort == 'price_asc'  ? 'selected' : ''}>Giá tăng dần</option>
                    <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Giá giảm dần</option>
                    <option value="popular"  ${sort == 'popular'   ? 'selected' : ''}>Phổ biến nhất</option>
                </select>
                <!-- Giữ page=1 khi đổi sort -->
                <input type="hidden" name="page" value="1">
                <input type="hidden" name="size" value="${pageSize}">
            </form>
        </div>

        <!-- Book Grid -->
        <c:choose>
            <c:when test="${empty books}">
                <div class="text-center py-20 text-gray-400">
                    <i data-lucide="book-x" class="w-16 h-16 mx-auto mb-4 opacity-30"></i>
                    <p class="text-lg">Không có sách nào để hiển thị.</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4 mb-8">
                    <c:forEach var="book" items="${books}">
                        <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                            <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                                <c:choose>
                                    <c:when test="${not empty book.thumbnail}">
                                        <img alt="${book.title}" class="w-full h-full object-cover"
                                             src="${book.thumbnail}">
                                    </c:when>
                                    <c:otherwise>
                                        <i data-lucide="book" class="w-16 h-16 text-gray-300"></i>
                                    </c:otherwise>
                                </c:choose>
                                <c:if test="${book.stockQuantity == 0}">
                                    <div class="absolute top-2.5 left-2.5 bg-gray-400 text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">Hết hàng</div>
                                </c:if>
                            </div>
                            <div class="p-3 flex flex-col flex-1">
                                <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                                    <a class="text-primary hover:underline"
                                       href="${pageContext.request.contextPath}/products?id=${book.bookID}">
                                        ${book.title}
                                    </a>
                                </div>
                                <p class="text-[12px] text-gray-400 mb-1 truncate">${book.authorsDisplay}</p>
                                <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= book.avgRating}">★</c:when>
                                            <c:otherwise>☆</c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <span class="text-gray-400 text-[11px]">(${book.reviewCount})</span>
                                </div>
                                <div class="text-primary text-[17px] font-bold mb-2.5">
                                    <fmt:formatNumber value="${book.price}" type="number" maxFractionDigits="0"/>đ
                                </div>
                                <a href="${pageContext.request.contextPath}/products?id=${book.bookID}"
                                   class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                                    <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- ── PHÂN TRANG ── -->
                <c:if test="${totalPages > 1}">
                    <div class="flex items-center justify-center gap-2 mt-6">

                        <!-- Prev -->
                        <c:choose>
                            <c:when test="${page > 1}">
                                <a href="${pageContext.request.contextPath}/products?page=${page - 1}&size=${pageSize}&sort=${sort}"
                                   class="w-9 h-9 flex items-center justify-center rounded-full border border-gray-300 hover:border-primary hover:text-primary transition-colors text-gray-500">
                                    <i data-lucide="chevron-left" class="icon-sm"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="w-9 h-9 flex items-center justify-center rounded-full border border-gray-200 text-gray-300 cursor-not-allowed">
                                    <i data-lucide="chevron-left" class="icon-sm"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>

                        <!-- Page numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:if test="${i >= page - 2 && i <= page + 2}">
                                <c:choose>
                                    <c:when test="${i == page}">
                                        <span class="w-9 h-9 flex items-center justify-center rounded-full bg-primary text-white text-sm font-bold">
                                            ${i}
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/products?page=${i}&size=${pageSize}&sort=${sort}"
                                           class="w-9 h-9 flex items-center justify-center rounded-full border border-gray-300 text-sm text-gray-600 hover:border-primary hover:text-primary transition-colors">
                                            ${i}
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                        </c:forEach>

                        <!-- Next -->
                        <c:choose>
                            <c:when test="${page < totalPages}">
                                <a href="${pageContext.request.contextPath}/products?page=${page + 1}&size=${pageSize}&sort=${sort}"
                                   class="w-9 h-9 flex items-center justify-center rounded-full border border-gray-300 hover:border-primary hover:text-primary transition-colors text-gray-500">
                                    <i data-lucide="chevron-right" class="icon-sm"></i>
                                </a>
                            </c:when>
                            <c:otherwise>
                                <span class="w-9 h-9 flex items-center justify-center rounded-full border border-gray-200 text-gray-300 cursor-not-allowed">
                                    <i data-lucide="chevron-right" class="icon-sm"></i>
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <p class="text-center text-xs text-gray-400 mt-2">
                        Trang ${page} / ${totalPages}
                    </p>
                </c:if>
            </c:otherwise>
        </c:choose>
    </section>

</main>

<%@ include file="/views/layout/homepage/footer.jsp" %>
