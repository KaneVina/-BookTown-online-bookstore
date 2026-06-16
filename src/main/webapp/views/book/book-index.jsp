<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>

<style>
    .section-title-left {
        border-left: 4px solid #FDD835;
        padding-left: 12px;
    }
    .prod-card-hover {
        border: 1px solid #E0E0E0;
        box-shadow: 0 1px 2px rgba(0,0,0,.05);
        transition: box-shadow .2s, transform .2s;
    }
    .prod-card-hover:hover {
        box-shadow: 0 6px 20px rgba(0,0,0,.1);
        transform: translateY(-2px);
    }
    .active-page {
        background-color: #17479D;
        color: white;
    }
</style>

<main class="max-w-[1400px] mx-auto px-8 py-8 flex flex-col gap-8 min-h-[500px]">
    
    <div class="flex flex-col lg:flex-row gap-8">
        
        <!-- Sidebar: Category Filter -->
        <aside class="w-full lg:w-64 flex-shrink-0">
            <div class="bg-white border border-gray-200 rounded-2xl p-5 shadow-sm">
                <h2 class="text-base font-bold text-gray-800 border-b border-gray-150 pb-3 mb-4 flex items-center gap-2">
                    <i data-lucide="filter" class="w-4 h-4 text-primary"></i> Lọc Theo Thể Loại
                </h2>
                <ul class="flex flex-col gap-1.5">
                    <li>
                        <a href="${pageContext.request.contextPath}/products${not empty sort ? '?sort='.concat(sort) : ''}" 
                           class="flex items-center justify-between px-3 py-2.5 rounded-xl text-sm transition-all ${empty activeGenreID ? 'bg-primary/10 text-primary font-bold' : 'text-gray-600 hover:bg-gray-50'}">
                           <span>Tất cả thể loại</span>
                           <i data-lucide="chevron-right" class="w-3.5 h-3.5 opacity-50"></i>
                        </a>
                    </li>
                    <c:forEach var="g" items="${genres}">
                        <li>
                            <a href="${pageContext.request.contextPath}/products?genreID=${g.genreID}${not empty sort ? '&sort='.concat(sort) : ''}" 
                               class="flex items-center justify-between px-3 py-2.5 rounded-xl text-sm transition-all ${activeGenreID == g.genreID ? 'bg-primary/10 text-primary font-bold' : 'text-gray-600 hover:bg-gray-50'}">
                               <span>${g.genreName}</span>
                               <i data-lucide="chevron-right" class="w-3.5 h-3.5 opacity-50"></i>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </aside>

        <!-- Main Content Area -->
        <div class="flex-1 flex flex-col gap-8">
            
            <!-- Top Bar: Category name + Sort dropdown -->
            <div class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 border-b border-gray-250 pb-5">
                <div>
                    <h1 class="section-title-left text-[26px] font-black text-primary uppercase tracking-wide">
                        <c:choose>
                            <c:when test="${not empty activeGenreID}">
                                <c:forEach var="g" items="${genres}">
                                    <c:if test="${g.genreID == activeGenreID}">${g.genreName}</c:if>
                                </c:forEach>
                            </c:when>
                            <c:when test="${sort == 'popular'}">Sách Nổi Bật</c:when>
                            <c:when test="${sort == 'newest'}">Sách Mới Nhất</c:when>
                            <c:otherwise>Danh Mục Sản Phẩm</c:otherwise>
                        </c:choose>
                    </h1>
                    <p class="text-sm text-gray-500 mt-1">Hiển thị ${totalBooks} kết quả</p>
                </div>
                
                <!-- Sorting -->
                <div class="flex items-center gap-2">
                    <span class="text-sm font-medium text-gray-500">Sắp xếp theo:</span>
                    <select id="sortSelect" onchange="changeSort(this.value)" class="border border-gray-300 rounded-lg px-3 py-1.5 text-sm font-medium focus:ring-primary focus:border-primary outline-none">
                        <option value="" ${empty sort ? 'selected' : ''}>Mặc định</option>
                        <option value="name" ${sort == 'name' ? 'selected' : ''}>Tên (A-Z)</option>
                        <option value="price_asc" ${sort == 'price_asc' ? 'selected' : ''}>Giá (Thấp đến Cao)</option>
                        <option value="price_desc" ${sort == 'price_desc' ? 'selected' : ''}>Giá (Cao đến Thấp)</option>
                        <option value="newest" ${sort == 'newest' ? 'selected' : ''}>Mới nhất</option>
                        <option value="popular" ${sort == 'popular' ? 'selected' : ''}>Phổ biến nhất</option>
                    </select>
                </div>
            </div>

            <!-- Product Grid -->
            <c:choose>
                <c:when test="${not empty books}">
                    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
                        <c:forEach var="book" items="${books}">
                            <div class="prod-card-hover bg-white rounded-xl overflow-hidden flex flex-col relative">
                                <!-- Cover Link -->
                                <a href="${pageContext.request.contextPath}/products?id=${book.bookID}" class="relative block bg-[#f0f4ff] aspect-[3/4] overflow-hidden">
                                    <c:choose>
                                        <c:when test="${not empty book.thumbnail}">
                                            <img src="${book.thumbnail}" alt="${book.title}" class="w-full h-full object-cover hover:scale-105 transition-transform duration-300">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-full h-full flex items-center justify-center">
                                                <i data-lucide="book-open" class="w-12 h-12 text-gray-300"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${book.featured}">
                                        <span class="absolute top-2.5 left-2.5 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">🔥 Hot</span>
                                    </c:if>
                                </a>

                                <!-- Wishlist Toggle Button -->
                                <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="absolute top-2.5 right-2.5 z-10">
                                    <input type="hidden" name="bookID" value="${book.bookID}" />
                                    <c:choose>
                                        <c:when test="${not empty wishlistBookIds && wishlistBookIds.contains(book.bookID)}">
                                            <input type="hidden" name="action" value="remove" />
                                            <button type="submit" class="w-7 h-7 bg-white hover:bg-red-50 text-red-500 rounded-full flex items-center justify-center shadow-md transition-all hover:scale-105" title="Xóa khỏi yêu thích">
                                                <i data-lucide="heart" class="w-4 h-4 fill-red-500 stroke-red-500"></i>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" name="action" value="add" />
                                            <button type="submit" class="w-7 h-7 bg-white/80 hover:bg-white text-gray-500 hover:text-red-500 rounded-full flex items-center justify-center shadow-md transition-all hover:scale-105" title="Thêm vào yêu thích">
                                                <i data-lucide="heart" class="w-4 h-4"></i>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>

                                <!-- Book Info -->
                                <div class="p-4 flex flex-col flex-1 gap-2">
                                    <a href="${pageContext.request.contextPath}/products?id=${book.bookID}" class="text-[14px] font-bold text-[#222222] line-clamp-2 hover:text-primary transition-colors min-h-[40px]">
                                        ${book.title}
                                    </a>
                                    
                                    <c:if test="${not empty book.authors}">
                                        <p class="text-[12px] text-gray-400 line-clamp-1">
                                            <c:forEach var="a" items="${book.authors}" varStatus="s">
                                                ${a}<c:if test="${!s.last}">, </c:if>
                                            </c:forEach>
                                        </p>
                                    </c:if>

                                    <div class="flex items-center gap-1 text-[13px] text-[#FDD835]">
                                        <c:forEach begin="1" end="5" var="i">
                                            <c:choose>
                                                <c:when test="${i <= book.avgRating}">★</c:when>
                                                <c:otherwise><span class="text-gray-300">★</span></c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <span class="text-gray-400 text-[11px]">(${book.reviewCount})</span>
                                    </div>

                                    <p class="text-primary text-[17px] font-bold mt-1">
                                        <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" />đ
                                    </p>

                                    <a href="${pageContext.request.contextPath}/products?id=${book.bookID}" class="mt-auto w-full bg-primary text-white rounded-lg py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors">
                                        <i data-lucide="eye" class="w-4 h-4"></i> XEM CHI TIẾT
                                    </a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <div class="flex justify-center items-center gap-2 mt-10">
                            <c:if test="${page > 1}">
                                <a href="javascript:changePage(${page - 1})" class="w-10 h-10 border border-gray-200 rounded-lg flex items-center justify-center text-gray-600 hover:border-primary hover:text-primary transition-colors">
                                    <i data-lucide="chevron-left" class="w-4 h-4"></i>
                                </a>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <a href="javascript:changePage(${p})" class="w-10 h-10 border border-gray-200 rounded-lg flex items-center justify-center font-bold text-sm transition-colors ${p == page ? 'active-page border-primary' : 'text-gray-600 hover:border-primary hover:text-primary'}">
                                    ${p}
                                </a>
                            </c:forEach>
                            
                            <c:if test="${page < totalPages}">
                                <a href="javascript:changePage(${page + 1})" class="w-10 h-10 border border-gray-200 rounded-lg flex items-center justify-center text-gray-600 hover:border-primary hover:text-primary transition-colors">
                                    <i data-lucide="chevron-right" class="w-4 h-4"></i>
                                </a>
                            </c:if>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="py-20 text-center text-gray-400 text-[14px]">Không tìm thấy sách nào khớp với yêu cầu.</div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<script>
    function changeSort(val) {
        var url = new URL(window.location.href);
        if (val) {
            url.searchParams.set("sort", val);
        } else {
            url.searchParams.delete("sort");
        }
        url.searchParams.set("page", "1"); // Reset to page 1 on sort change
        window.location.href = url.toString();
    }
    
    function changePage(p) {
        var url = new URL(window.location.href);
        url.searchParams.set("page", p);
        window.location.href = url.toString();
    }
</script>

<%@ include file="/views/layout/homepage/footer.jsp" %>
