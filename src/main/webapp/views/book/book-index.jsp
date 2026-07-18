<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<style>
.filter-card { background:#fff; border:1px solid #e5e7eb; border-radius:12px; padding:20px; }
.sort-btn { border:1.5px solid #e5e7eb; border-radius:8px; padding:6px 14px; font-size:13px; font-weight:500; transition:all .18s; cursor:pointer; background:#fff; }
.sort-btn.active, .sort-btn:hover { border-color:#17479D; color:#17479D; background:#EFF6FF; }
.prod-card { border:1px solid #e5e7eb; border-radius:12px; overflow:hidden; background:#fff; display:flex; flex-direction:column; transition:box-shadow .2s, transform .2s; }
.prod-card:hover { box-shadow:0 8px 24px rgba(23,71,157,.13); transform:translateY(-3px); }
.genre-pill { display:inline-block; padding:4px 12px; border-radius:999px; font-size:12px; font-weight:600; cursor:pointer; border:1.5px solid transparent; transition:all .18s; }
.genre-pill.active { background:#17479D; color:#fff; border-color:#17479D; }
.genre-pill:not(.active) { background:#f3f4f6; color:#374151; border-color:#e5e7eb; }
.genre-pill:not(.active):hover { border-color:#17479D; color:#17479D; }
</style>

<section class="hero-gradient px-8 py-7 relative overflow-hidden">
    <div class="absolute right-[200px] bottom-[-60px] w-[200px] h-[200px] rounded-full border-[40px] border-white/5 pointer-events-none"></div>
    <div class="relative z-10">
        <div class="bg-secondary text-primary font-bold text-xs px-3 py-1 rounded-full inline-block mb-2 tracking-wide uppercase">📚 Kho sách BookTown</div>
        <h1 class="text-white text-[28px] font-black leading-tight">
            <c:choose>
                <c:when test="${not empty keyword}">Kết quả tìm kiếm: "<em class="text-secondary not-italic">${keyword}</em>"</c:when>
                <c:when test="${not empty genreID}">Danh mục: <em class="text-secondary not-italic">${genreMap[genreID]}</em></c:when>
                <c:otherwise>Tất cả sách</c:otherwise>
            </c:choose>
        </h1>
        <p class="text-white/70 text-sm mt-1">${totalBooks} đầu sách</p>
    </div>
</section>

<main class="max-w-[1400px] mx-auto px-6 py-7 flex gap-6">

    <%-- SIDEBAR FILTER --%>
    <aside class="hidden lg:block w-[240px] flex-shrink-0 space-y-4">
        <div class="filter-card">
            <h3 class="text-[14px] font-bold text-gray-700 mb-3 uppercase tracking-wide">🗂 Thể loại</h3>
            <div class="flex flex-col gap-1.5">
                <a href="${pageContext.request.contextPath}/products<c:if test="${not empty keyword}">?keyword=${keyword}</c:if>"
                   class="genre-pill <c:if test="${empty genreID}">active</c:if>">Tất cả</a>
                <c:forEach var="entry" items="${genreMap}">
                    <a href="${pageContext.request.contextPath}/products?genre=${entry.key}<c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty sort}">&sort=${sort}</c:if>"
                       class="genre-pill <c:if test="${genreID == entry.key}">active</c:if>">${entry.value}</a>
                </c:forEach>
            </div>
        </div>

        <div class="filter-card">
            <h3 class="text-[14px] font-bold text-gray-700 mb-3 uppercase tracking-wide">💰 Khoảng giá</h3>
            <form method="get" action="${pageContext.request.contextPath}/products" id="priceForm">
                <input type="hidden" name="genre"   value="${genreID}">
                <input type="hidden" name="keyword" value="${keyword}">
                <input type="hidden" name="sort"    value="${sort}">
                <div class="flex flex-col gap-2">
                    <input type="number" name="minPrice" value="${minPrice}" placeholder="Từ (VNĐ)"
                           class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:border-primary outline-none" min="0" step="1000">
                    <input type="number" name="maxPrice" value="${maxPrice}" placeholder="Đến (VNĐ)"
                           class="w-full border border-gray-200 rounded-lg px-3 py-2 text-sm focus:border-primary outline-none" min="0" step="1000">
                    <button type="submit" class="w-full bg-primary text-white text-sm font-bold py-2 rounded-lg hover:bg-primary-dark transition-colors">
                        Lọc giá
                    </button>
                    <c:if test="${not empty minPrice or not empty maxPrice}">
                        <a href="${pageContext.request.contextPath}/products?genre=${genreID}&keyword=${keyword}&sort=${sort}"
                           class="text-center text-xs text-gray-400 hover:text-red-500">✕ Xóa bộ lọc giá</a>
                    </c:if>
                </div>
            </form>
        </div>
    </aside>

    <%-- MAIN CONTENT --%>
    <div class="flex-1 min-w-0">
        <%-- SORT BAR --%>
        <div class="flex flex-wrap items-center gap-2 mb-5 bg-white border border-gray-100 rounded-xl px-4 py-3">
            <span class="text-sm font-semibold text-gray-500 mr-1">Sắp xếp:</span>
            <a href="?<c:if test="${not empty keyword}">keyword=${keyword}&</c:if><c:if test="${not empty genreID}">genre=${genreID}&</c:if>sort=newest"
               class="sort-btn <c:if test="${sort == 'newest' or empty sort}">active</c:if>">🆕 Mới nhất</a>
            <a href="?<c:if test="${not empty keyword}">keyword=${keyword}&</c:if><c:if test="${not empty genreID}">genre=${genreID}&</c:if>sort=popular"
               class="sort-btn <c:if test="${sort == 'popular'}">active</c:if>">🔥 Phổ biến</a>
            <a href="?<c:if test="${not empty keyword}">keyword=${keyword}&</c:if><c:if test="${not empty genreID}">genre=${genreID}&</c:if>sort=price_asc"
               class="sort-btn <c:if test="${sort == 'price_asc'}">active</c:if>">💲 Giá thấp</a>
            <a href="?<c:if test="${not empty keyword}">keyword=${keyword}&</c:if><c:if test="${not empty genreID}">genre=${genreID}&</c:if>sort=price_desc"
               class="sort-btn <c:if test="${sort == 'price_desc'}">active</c:if>">💰 Giá cao</a>
            <a href="?<c:if test="${not empty keyword}">keyword=${keyword}&</c:if><c:if test="${not empty genreID}">genre=${genreID}&</c:if>sort=name"
               class="sort-btn <c:if test="${sort == 'name'}">active</c:if>">🔤 A→Z</a>
            <span class="ml-auto text-sm text-gray-400">${totalBooks} sách</span>
        </div>

        <%-- BOOK GRID --%>
        <c:choose>
            <c:when test="${not empty books}">
                <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 xl:grid-cols-5 gap-4 mb-8" id="book-grid">
                    <c:forEach var="book" items="${books}">
                    <div class="prod-card">
                        <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center overflow-hidden">
                            <c:choose>
                                <c:when test="${not empty book.thumbnailFirst}">
                                    <img alt="${book.title}" class="w-full h-full object-cover hover:scale-105 transition-transform duration-300" src="${book.thumbnailFirst}">
                                </c:when>
                                <c:otherwise>
                                    <i data-lucide="book-open" class="w-14 h-14 text-gray-200"></i>
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${book.featured}">
                                <div class="absolute top-2.5 right-2.5 bg-[#8E24AA] text-white text-[10px] font-bold px-2 py-0.5 rounded-full">🔥 Hot</div>
                            </c:if>
                            <%-- Badge hết hàng --%>
                            <c:if test="${book.status == 'out_of_stock' or book.stockQuantity == 0}">
                                <div class="absolute inset-0 bg-black/40 flex items-center justify-center pointer-events-none">
                                    <span class="bg-white text-red-600 font-bold text-[11px] px-3 py-1 rounded-full">Hết hàng</span>
                                </div>
                            </c:if>
                            <jsp:include page="/views/layout/common/wishlist-heart.jsp">
                                <jsp:param name="wishBookId" value="${book.bookID}" />
                            </jsp:include>
                        </div>
                        <div class="p-3 flex flex-col flex-1">
                            <div class="text-[12px] text-gray-400 mb-1 truncate">
                                <c:if test="${not empty book.genreName}"><span class="text-primary font-medium">${book.genreName}</span></c:if>
                            </div>
                            <div class="text-[13px] font-semibold text-gray-800 mb-1 line-clamp-2 min-h-[36px]">
                                <a href="${pageContext.request.contextPath}/products?id=${book.bookID}" class="hover:text-primary transition-colors">${book.title}</a>
                            </div>
                            <div class="text-[12px] text-gray-400 mb-1 line-clamp-1">
                                <c:if test="${not empty book.authors}">
                                    <c:forEach var="a" items="${book.authors}" varStatus="s">${a}<c:if test="${!s.last}">, </c:if></c:forEach>
                                </c:if>
                            </div>
                            <div class="text-[#FDD835] text-[11px] mb-1.5 flex items-center gap-0.5">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= book.avgRating}">★</c:when>
                                        <c:otherwise><span class="text-gray-200">★</span></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span class="text-gray-400 text-[10px] ml-0.5">(${book.reviewCount})</span>
                            </div>
                            <div class="text-primary text-[16px] font-bold mb-2.5">
                                <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true"/>đ
                            </div>
                            <a href="${pageContext.request.contextPath}/products?id=${book.bookID}"
                               class="mt-auto w-full bg-primary text-white rounded-lg py-2 text-[12px] font-bold flex items-center justify-center gap-1.5 hover:bg-primary-dark transition-colors">
                                <i data-lucide="eye" class="w-3.5 h-3.5"></i> Xem chi tiết
                            </a>
                        </div>
                    </div>
                    </c:forEach>
                </div>

                <%-- PAGINATION --%>
                <c:if test="${totalPages > 1}">
                <nav class="flex justify-center items-center gap-1.5 flex-wrap">
                    <c:if test="${page > 1}">
                        <a href="?page=${page-1}<c:if test="${not empty sort}">&sort=${sort}</c:if><c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty genreID}">&genre=${genreID}</c:if><c:if test="${not empty minPrice}">&minPrice=${minPrice}</c:if><c:if test="${not empty maxPrice}">&maxPrice=${maxPrice}</c:if>"
                           class="w-9 h-9 flex items-center justify-center rounded-lg border border-gray-200 text-gray-600 hover:border-primary hover:text-primary transition-colors">
                            <i data-lucide="chevron-left" class="w-4 h-4"></i>
                        </a>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == page}">
                                <span class="w-9 h-9 flex items-center justify-center rounded-lg bg-primary text-white font-bold text-sm">${i}</span>
                            </c:when>
                            <c:when test="${i <= 2 or i >= totalPages-1 or (i >= page-2 and i <= page+2)}">
                                <a href="?page=${i}<c:if test="${not empty sort}">&sort=${sort}</c:if><c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty genreID}">&genre=${genreID}</c:if><c:if test="${not empty minPrice}">&minPrice=${minPrice}</c:if><c:if test="${not empty maxPrice}">&maxPrice=${maxPrice}</c:if>"
                                   class="w-9 h-9 flex items-center justify-center rounded-lg border border-gray-200 text-gray-600 hover:border-primary hover:text-primary transition-colors text-sm">${i}</a>
                            </c:when>
                            <c:when test="${i == 3 and page > 5}">
                                <span class="w-9 h-9 flex items-center justify-center text-gray-400">…</span>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <c:if test="${page < totalPages}">
                        <a href="?page=${page+1}<c:if test="${not empty sort}">&sort=${sort}</c:if><c:if test="${not empty keyword}">&keyword=${keyword}</c:if><c:if test="${not empty genreID}">&genre=${genreID}</c:if><c:if test="${not empty minPrice}">&minPrice=${minPrice}</c:if><c:if test="${not empty maxPrice}">&maxPrice=${maxPrice}</c:if>"
                           class="w-9 h-9 flex items-center justify-center rounded-lg border border-gray-200 text-gray-600 hover:border-primary hover:text-primary transition-colors">
                            <i data-lucide="chevron-right" class="w-4 h-4"></i>
                        </a>
                    </c:if>
                </nav>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="text-center py-20 text-gray-400">
                    <i data-lucide="search-x" class="w-16 h-16 mx-auto mb-4 opacity-30"></i>
                    <p class="text-lg font-semibold">Không tìm thấy sách nào</p>
                    <p class="text-sm mt-1">Thử thay đổi từ khóa hoặc bộ lọc</p>
                    <a href="${pageContext.request.contextPath}/products" class="mt-4 inline-block bg-primary text-white px-6 py-2.5 rounded-full text-sm font-bold hover:bg-primary-dark transition-colors">Xem tất cả sách</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<%@ include file="/views/layout/common/wishlist-heart.js.jsp" %>
<%@ include file="/views/layout/homepage/footer.jsp" %>
