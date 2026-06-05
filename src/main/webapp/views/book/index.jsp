<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>

<section class="hero-gradient px-8 py-8 flex items-center justify-between min-h-[240px] relative overflow-hidden">
    <div class="absolute right-[280px] top-[-40px] w-[300px] h-[300px] rounded-full border-[60px] border-white/5 pointer-events-none"></div>
    <div class="absolute right-[200px] bottom-[-80px] w-[200px] h-[200px] rounded-full border-[40px] border-white/5 pointer-events-none"></div>

    <div class="relative z-10 max-w-2xl">
        <div class="bg-secondary text-primary font-bold text-xs px-3 py-1 rounded-full inline-block mb-3 tracking-wide uppercase">
            <i data-lucide="sparkles" class="icon-sm inline-block"></i> Kho sách #1 Việt Nam
        </div>
        <h1 class="text-white text-[38px] font-black leading-[1.15] mb-3">
            Khám phá <em class="text-secondary not-italic">thế giới</em><br>qua từng trang sách
        </h1>
        <p class="text-white/80 text-sm mb-5 max-w-[420px]">
            Hơn 50.000 đầu sách chính hãng – Văn học, kinh tế, kỹ năng, thiếu nhi. Giao hàng nhanh toàn quốc.
        </p>
        <div class="flex gap-3">
            <a href="${pageContext.request.contextPath}/products" class="bg-secondary text-primary font-bold text-sm px-6 py-2.5 rounded-full hover:scale-105 transition-transform flex items-center gap-2">
                <i data-lucide="shopping-cart" class="icon-md"></i> Mua ngay
            </a>
            <a href="${pageContext.request.contextPath}/products" class="bg-transparent text-white font-medium text-sm px-6 py-2.5 border-2 border-white/50 rounded-full hover:border-white transition-all flex items-center gap-2">
                Xem danh mục <i data-lucide="arrow-right" class="icon-md"></i>
            </a>
        </div>
    </div>

    <div class="hidden md:flex gap-0 items-end relative z-10 h-[300px]">
        <div class="spine w-12 h-[220px] bg-gradient-to-b from-[#C62828] to-[#B71C1C]"><span class="spine-txt">Đắc Nhân Tâm</span></div>
        <div class="spine w-12 h-[260px] bg-gradient-to-b from-[#F57F17] to-[#E65100]"><span class="spine-txt">Nhà Giả Kim</span></div>
        <div class="spine w-12 h-[300px] bg-gradient-to-b from-[#1B5E20] to-[#388E3C]"><span class="spine-txt">Atomic Habits</span></div>
        <div class="spine w-12 h-[270px] bg-gradient-to-b from-[#4A148C] to-[#7B1FA2]"><span class="spine-txt">Sapiens</span></div>
        <div class="spine w-12 h-[240px] bg-gradient-to-b from-[#01579B] to-[#0288D1]"><span class="spine-txt">Tôi Tài Giỏi</span></div>
    </div>
</section>

<section class="bg-white grid grid-cols-2 md:grid-cols-4 border-b-2 border-gray-200">
    <div class="flex items-center gap-3 px-6 py-4 border-r border-gray-100">
        <i data-lucide="package" class="w-8 h-8 text-primary"></i>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">50.000+</strong>
            <span class="text-xs text-gray-500">Đầu sách có sẵn</span>
        </div>
    </div>
    <div class="flex items-center gap-3 px-6 py-4 border-r border-gray-100">
        <i data-lucide="truck" class="w-8 h-8 text-primary"></i>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">Miễn phí ship</strong>
            <span class="text-xs text-gray-500">Đơn từ 299.000đ</span>
        </div>
    </div>
    <div class="flex items-center gap-3 px-6 py-4 border-r border-gray-100">
        <i data-lucide="shield-check" class="w-8 h-8 text-primary"></i>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">Chính hãng 100%</strong>
            <span class="text-xs text-gray-500">Cam kết từ nhà xuất bản</span>
        </div>
    </div>
    <div class="flex items-center gap-3 px-6 py-4">
        <i data-lucide="refresh-ccw" class="w-8 h-8 text-primary"></i>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">Đổi trả 7 ngày</strong>
            <span class="text-xs text-gray-500">Không cần lý do</span>
        </div>
    </div>
</section>

<main class="max-w-[1400px] mx-auto px-8 py-7">

    <section class="mb-12">
        <div class="flex justify-between items-center mb-5">
            <h2 class="section-title-border text-xl font-bold text-primary pl-3 flex items-center gap-2">
                <i data-lucide="flame" class="icon-md"></i> Sách Bán Chạy
            </h2>
            <a href="${pageContext.request.contextPath}/products?sort=popular" class="text-[13px] text-primary font-medium border border-primary px-3.5 py-1.5 rounded-full cursor-pointer hover:bg-primary hover:text-white transition-colors uppercase tracking-tight">Xem tất cả</a>
        </div>

        <div class="flex flex-wrap gap-2.5 mb-6">
            <div class="bg-primary text-white border border-primary px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer shadow-sm flex items-center gap-1.5">
                <i data-lucide="library-big" class="icon-sm"></i> Tất cả
            </div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all flex items-center gap-1.5">
                <i data-lucide="pen-line" class="icon-sm"></i> Văn học
            </div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all flex items-center gap-1.5">
                <i data-lucide="briefcase" class="icon-sm"></i> Kinh tế
            </div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all flex items-center gap-1.5">
                <i data-lucide="brain" class="icon-sm"></i> Kỹ năng
            </div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all flex items-center gap-1.5">
                <i data-lucide="smile" class="icon-sm"></i> Thiếu nhi
            </div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all flex items-center gap-1.5">
                <i data-lucide="flask-conical" class="icon-sm"></i> Khoa học
            </div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all flex items-center gap-1.5">
                <i data-lucide="globe" class="icon-sm"></i> Lịch sử
            </div>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
            <c:forEach var="book" items="${featuredBooks}">
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <c:choose>
                        <c:when test="${not empty book.thumbnail}">
                            <img alt="${book.title}" class="w-full h-full object-cover" src="${book.thumbnail}">
                        </c:when>
                        <c:otherwise>
                            <i data-lucide="book-open" class="w-16 h-16 text-gray-300"></i>
                        </c:otherwise>
                    </c:choose>
                    <div class="absolute top-2.5 left-2.5 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">
                        <i data-lucide="flame" class="icon-xs"></i> Hot
                    </div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline"
                           href="${pageContext.request.contextPath}/products?id=${book.bookID}">
                            ${book.title}<c:if test="${not empty book.authors}"> – <c:forEach var="a" items="${book.authors}" varStatus="s">${a}<c:if test="${!s.last}">, </c:if></c:forEach></c:if>
                        </a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= book.avgRating}">★</c:when>
                                <c:otherwise><span class="text-gray-300">★</span></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <span class="text-gray-400 text-[11px]">(${book.reviewCount})</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">
                        <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" />đ
                    </div>
                    <a href="${pageContext.request.contextPath}/products?id=${book.bookID}"
                       class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </a>
                </div>
            </div>
            </c:forEach>

            <c:if test="${empty featuredBooks}">
            <div class="col-span-5 py-12 text-center text-gray-400 text-[14px]">Chưa có sách nào.</div>
            </c:if>
        </div>
    </section>

    <section class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-12">
        <a href="${pageContext.request.contextPath}/products" class="rounded-lg h-[120px] flex flex-col items-center justify-center font-bold text-lg text-white p-4 text-center cursor-pointer hover:scale-[1.02] transition-transform bg-gradient-to-br from-primary to-primary-dark">
            <i data-lucide="book-open" class="w-6 h-6 mb-1"></i>
            Sách Kỹ Năng<br><span class="text-[13px] opacity-80 font-normal">Giảm đến 40%</span>
        </a>
        <a href="${pageContext.request.contextPath}/products" class="rounded-lg h-[120px] flex flex-col items-center justify-center font-bold text-lg text-white p-4 text-center cursor-pointer hover:scale-[1.02] transition-transform bg-gradient-to-br from-[#E53935] to-[#B71C1C]">
            <i data-lucide="gift" class="w-6 h-6 mb-1"></i>
            Quà Tặng Ý Nghĩa<br><span class="text-[13px] opacity-80 font-normal">Gói quà miễn phí</span>
        </a>
        <a href="${pageContext.request.contextPath}/products?sort=newest" class="rounded-lg h-[120px] flex flex-col items-center justify-center font-bold text-lg text-white p-4 text-center cursor-pointer hover:scale-[1.02] transition-transform bg-gradient-to-br from-[#F57F17] to-[#E65100]">
            <i data-lucide="rocket" class="w-6 h-6 mb-1"></i>
            Sách Mới Nhất<br><span class="text-[13px] opacity-80 font-normal">Cập nhật mỗi tuần</span>
        </a>
    </section>

    <section class="mb-12">
        <div class="flex justify-between items-center mb-5">
            <h2 class="section-title-border text-xl font-bold text-primary pl-3 flex items-center gap-2">
                <i data-lucide="package-plus" class="icon-md"></i> Sách Mới Về
            </h2>
            <a href="${pageContext.request.contextPath}/products?sort=newest" class="text-[13px] text-primary font-medium border border-primary px-3.5 py-1.5 rounded-full cursor-pointer hover:bg-primary hover:text-white transition-colors uppercase tracking-tight">Xem tất cả</a>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">
            <c:forEach var="book" items="${newBooks}">
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <c:choose>
                        <c:when test="${not empty book.thumbnail}">
                            <img alt="${book.title}" class="w-full h-full object-cover" src="${book.thumbnail}">
                        </c:when>
                        <c:otherwise>
                            <i data-lucide="book-open" class="w-16 h-16 text-gray-300"></i>
                        </c:otherwise>
                    </c:choose>
                    <div class="absolute top-2.5 left-2.5 bg-[#E53935] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">
                        <i data-lucide="sparkles" class="icon-xs"></i> New
                    </div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline"
                           href="${pageContext.request.contextPath}/products?id=${book.bookID}">
                            ${book.title}<c:if test="${not empty book.authors}"> – <c:forEach var="a" items="${book.authors}" varStatus="s">${a}<c:if test="${!s.last}">, </c:if></c:forEach></c:if>
                        </a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        <c:forEach begin="1" end="5" var="i">
                            <c:choose>
                                <c:when test="${i <= book.avgRating}">★</c:when>
                                <c:otherwise><span class="text-gray-300">★</span></c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <span class="text-gray-400 text-[11px]">(${book.reviewCount})</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">
                        <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" />đ
                    </div>
                    <a href="${pageContext.request.contextPath}/products?id=${book.bookID}"
                       class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </a>
                </div>
            </div>
            </c:forEach>

            <c:if test="${empty newBooks}">
            <div class="col-span-5 py-12 text-center text-gray-400 text-[14px]">Chưa có sách nào.</div>
            </c:if>
        </div>
    </section>

</main>

<%@ include file="/views/layout/homepage/footer.jsp" %>