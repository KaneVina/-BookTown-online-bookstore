<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>
<%@ include file="/views/layout/common/toast.jsp" %>

<c:if test="${param.removed == '1'}">
    <script>window.addEventListener('load', () => showToast('Đã xóa khỏi danh sách yêu thích!'));</script>
</c:if>
<c:if test="${param.movedToCart == '1'}">
    <script>window.addEventListener('load', () => showToast('Đã chuyển sang giỏ hàng!'));</script>
</c:if>
<c:if test="${not empty param.wishError}">
    <script>window.addEventListener('load', () => showToast('<c:out value="${param.wishError}"/>', true));</script>
</c:if>

<style>
    .wish-card {
        background:#fff;
        border:1px solid #e5e7eb;
        border-radius:14px;
        overflow:hidden;
        display:flex;
        align-items:stretch;
        transition:box-shadow .2s;
    }
    .wish-card:hover {
        box-shadow:0 6px 20px rgba(23,71,157,.1);
    }
    .wish-thumb {
        width:100px;
        min-height:120px;
        flex-shrink:0;
        background:#f0f4ff;
        display:flex;
        align-items:center;
        justify-content:center;
        overflow:hidden;
    }
    .wish-thumb img {
        width:100%;
        height:100%;
        object-fit:cover;
    }
    .badge-stock-ok  {
        background:#dcfce7;
        color:#166534;
        font-size:11px;
        font-weight:700;
        padding:2px 8px;
        border-radius:999px;
    }
    .badge-stock-out {
        background:#fee2e2;
        color:#991b1b;
        font-size:11px;
        font-weight:700;
        padding:2px 8px;
        border-radius:999px;
    }
</style>

<section class="hero-gradient px-8 py-7 relative overflow-hidden">
    <div class="relative z-10">
        <div class="bg-secondary text-primary font-bold text-xs px-3 py-1 rounded-full inline-block mb-2 tracking-wide uppercase">❤️ Yêu thích</div>
        <h1 class="text-white text-[28px] font-black">Danh sách yêu thích của tôi</h1>
        <p class="text-white/70 text-sm mt-1">${wishlistCount} sách trong danh sách</p>
    </div>
</section>

<main class="max-w-[900px] mx-auto px-6 py-8">

    <c:choose>
        <c:when test="${not empty wishlistItems}">
            <div class="space-y-4">
                <c:forEach var="item" items="${wishlistItems}">
                    <div class="wish-card">
                        <div class="wish-thumb">
                            <c:choose>
                                <c:when test="${not empty item.thumbnailFirst}">
                                    <img src="${item.thumbnailFirst}" alt="${item.title}">
                                </c:when>
                                <c:otherwise>
                                    <i data-lucide="book-open" class="w-10 h-10 text-gray-200"></i>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="flex-1 px-4 py-3 flex flex-col justify-between">
                            <div>
                                <a href="${pageContext.request.contextPath}/products?id=${item.bookID}"
                                   class="text-[15px] font-bold text-gray-800 hover:text-primary transition-colors line-clamp-2">${item.title}</a>
                                <c:if test="${not empty item.authorsDisplay}">
                                    <p class="text-[13px] text-gray-400 mt-0.5">${item.authorsDisplay}</p>
                                </c:if>

                                <div class="flex items-center gap-3 mt-2 flex-wrap">
                                    <span class="text-primary text-[17px] font-bold">
                                        <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/>đ
                                    </span>
                                    <c:choose>
                                        <c:when test="${item.stockQuantity > 0 and item.status == 'available'}">
                                            <span class="badge-stock-ok">✓ Còn hàng (${item.stockQuantity})</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-stock-out">✕ Hết hàng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="text-[#FDD835] text-[11px] mt-1 flex items-center gap-0.5">
                                    <c:forEach begin="1" end="5" var="i">
                                        <c:choose>
                                            <c:when test="${i <= item.avgRating}">★</c:when>
                                            <c:otherwise><span class="text-gray-200">★</span></c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <span class="text-gray-400 text-[10px] ml-0.5">(${item.reviewCount})</span>
                                </div>
                            </div>

                            <div class="flex items-center gap-2 mt-3 flex-wrap">
                                <%-- Move to cart --%>
                                <c:if test="${item.stockQuantity > 0 and item.status == 'available'}">
                                    <form method="post" action="${pageContext.request.contextPath}/wishlist">
                                        <input type="hidden" name="action"  value="moveToCart">
                                        <input type="hidden" name="bookID"  value="${item.bookID}">
                                        <button type="submit"
                                                class="flex items-center gap-2 bg-primary text-white text-[13px] font-bold px-4 py-2 rounded-lg hover:bg-primary-dark transition-colors">
                                            <i data-lucide="shopping-cart" class="w-3.5 h-3.5"></i>
                                            Chuyển vào giỏ
                                        </button>
                                    </form>
                                </c:if>

                                <a href="${pageContext.request.contextPath}/products?id=${item.bookID}"
                                   class="flex items-center gap-2 border border-primary text-primary text-[13px] font-bold px-4 py-2 rounded-lg hover:bg-blue-50 transition-colors">
                                    <i data-lucide="eye" class="w-3.5 h-3.5"></i>
                                    Xem chi tiết
                                </a>

                                <%-- Remove --%>
                                <form method="post" action="${pageContext.request.contextPath}/wishlist">
                                    <input type="hidden" name="action"  value="remove">
                                    <input type="hidden" name="bookID"  value="${item.bookID}">
                                    <button type="submit"
                                            class="flex items-center gap-1.5 text-[13px] text-gray-400 hover:text-red-500 transition-colors px-2 py-2 rounded-lg hover:bg-red-50"
                                            title="Xóa khỏi yêu thích">
                                        <i data-lucide="trash-2" class="w-3.5 h-3.5"></i>
                                        Xóa
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>

            <div class="mt-8 flex justify-between items-center">
                <a href="${pageContext.request.contextPath}/products"
                   class="flex items-center gap-2 text-primary font-medium hover:underline text-sm">
                    <i data-lucide="arrow-left" class="w-4 h-4"></i> Tiếp tục mua sắm
                </a>
                <a href="${pageContext.request.contextPath}/cart"
                   class="bg-secondary text-primary font-bold px-6 py-2.5 rounded-full text-sm hover:opacity-90 transition-opacity">
                    🛒 Xem giỏ hàng
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="text-center py-24">
                <div class="w-24 h-24 mx-auto mb-6 rounded-full bg-red-50 flex items-center justify-center">
                    <i data-lucide="heart" class="w-10 h-10 text-red-300"></i>
                </div>
                <h2 class="text-xl font-bold text-gray-700 mb-2">Chưa có sách yêu thích</h2>
                <p class="text-gray-400 text-sm mb-6">Hãy khám phá kho sách và thêm những cuốn bạn thích vào đây!</p>
                <a href="${pageContext.request.contextPath}/products"
                   class="inline-flex items-center gap-2 bg-primary text-white font-bold px-8 py-3 rounded-full hover:bg-primary-dark transition-colors">
                    <i data-lucide="search" class="w-4 h-4"></i> Khám phá sách ngay
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<%@ include file="/views/layout/homepage/footer.jsp" %>
