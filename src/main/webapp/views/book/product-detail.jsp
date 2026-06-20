<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="/views/layout/homepage/header.jsp" %>

<style>
    .section-title-left {
        border-left: 4px solid #FDD835;
        padding-left: 12px;
    }
    .prod-thumb-active  {
        border: 2px solid #1565C0;
    }
    .prod-thumb-idle    {
        border: 1px solid #E0E0E0;
    }
    .prod-card-hover    {
        border: 1px solid #E0E0E0;
        box-shadow: 0 1px 2px rgba(0,0,0,.05);
        transition: box-shadow .2s, transform .2s;
    }
    .prod-card-hover:hover {
        box-shadow: 0 6px 20px rgba(0,0,0,.1);
        transform: translateY(-2px);
    }
    .review-card {
        border: 1px solid #E0E0E0;
        border-radius: 12px;
        background: #fff;
    }
    .slider-track {
        display: flex;
        gap: 16px;
        overflow-x: auto;
        scroll-snap-type: x mandatory;
        scrollbar-width: none;
    }
    .slider-track::-webkit-scrollbar {
        display: none;
    }
    .slider-item {
        flex: 0 0 calc(25% - 12px);
        scroll-snap-align: start;
    }
    @media (max-width: 1024px) {
        .slider-item {
            flex: 0 0 calc(33% - 12px);
        }
    }
    @media (max-width: 768px)  {
        .slider-item {
            flex: 0 0 calc(50% - 8px);
        }
    }

    /* ── Tabs (NEW from code 2) ── */
    .tab-nav { border-bottom: 1px solid #E0E0E0; display: flex; gap: 0; }
    .tab-btn {
        padding: 14px 24px;
        font-size: 15px;
        font-weight: 600;
        color: #666;
        cursor: pointer;
        border: none;
        background: none;
        border-bottom: 3px solid transparent;
        margin-bottom: -1px;
        transition: color .2s, border-color .2s;
    }
    .tab-btn:hover { color: #17479D; }
    .tab-btn.active { color: #17479D; border-bottom-color: #17479D; }
    .tab-panel { display: none; padding-top: 24px; }
    .tab-panel.active { display: block; }

    /* ── Review cards (NEW from code 2) ── */
    .badge-purchased {
        display: inline-flex; align-items: center; gap: 4px;
        background: #e8f5e9; color: #2e7d32;
        font-size: 11px; font-weight: 700;
        padding: 2px 8px; border-radius: 20px;
    }
    .badge-admin {
        display: inline-block;
        background: #1565C0; color: #fff;
        font-size: 10px; font-weight: 700;
        padding: 1px 7px; border-radius: 4px;
        margin-left: 6px; vertical-align: middle;
    }
    .admin-reply {
        background: #e3f0fb;
        border-radius: 10px;
        padding: 14px 16px;
        margin-top: 14px;
    }

    /* ── Write review form (NEW from code 2) ── */
    .btn-write-review {
        display: inline-flex; align-items: center; gap: 8px;
        background: #17479D; color: #fff;
        font-size: 14px; font-weight: 700;
        padding: 12px 24px; border-radius: 8px;
        border: none; cursor: pointer;
        text-transform: uppercase; letter-spacing: .5px;
        transition: background .2s;
    }
    .btn-write-review:hover { background: #0D47A1; }
    .write-review-form {
        background: #fff;
        border: 1px solid #E0E0E0;
        border-radius: 12px;
        padding: 28px;
        margin-top: 24px;
        display: none;
    }
    .write-review-form.open { display: block; }
</style>

<main class="max-w-[1400px] mx-auto px-8 py-8 flex flex-col gap-8">

    <!-- ══ PRODUCT HERO ══════════════════════════════════════════════════ -->
    <section class="flex flex-col lg:flex-row gap-10">

        <!-- LEFT: Image Gallery -->
        <div class="flex-shrink-0 w-full lg:w-[499px] flex flex-col gap-4">
            <div class="bg-white border border-gray-200 shadow-sm rounded-xl overflow-hidden aspect-[3/4] flex items-center justify-center relative">
                <c:choose>
                    <c:when test="${not empty book.thumbnail}">
                        <img id="mainImage" src="${book.thumbnail}" alt="${book.title}" class="w-full h-full object-cover">
                    </c:when>
                    <c:otherwise>
                        <i data-lucide="book-open" class="w-24 h-24 text-gray-300"></i>
                    </c:otherwise>
                </c:choose>
                <c:if test="${book.featured}">
                    <div class="absolute top-3 left-3 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">🔥 Nổi bật</div>
                </c:if>
                <c:if test="${book.stockQuantity == 0}">
                    <div class="absolute inset-0 bg-black/50 flex items-center justify-center">
                        <span class="bg-white text-red-600 font-bold text-sm px-4 py-2 rounded-full">Hết hàng</span>
                    </div>
                </c:if>
            </div>

            <c:if test="${not empty book.thumbnail}">
                <div class="grid grid-cols-4 gap-3">
                    <button onclick="switchImg(this, '${book.thumbnail}')"
                            class="prod-thumb-active rounded-lg overflow-hidden aspect-square bg-gray-50">
                        <img src="${book.thumbnail}" class="w-full h-full object-cover" alt="">
                    </button>
                    <button class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50 flex items-center justify-center">
                        <i data-lucide="image" class="w-6 h-6 text-gray-300"></i>
                    </button>
                    <button class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50 flex items-center justify-center">
                        <i data-lucide="image" class="w-6 h-6 text-gray-300"></i>
                    </button>
                    <button class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50 flex items-center justify-center">
                        <i data-lucide="image" class="w-6 h-6 text-gray-300"></i>
                    </button>
                </div>
            </c:if>
        </div>

        <!-- RIGHT: Product Info -->
        <div class="flex-1 min-w-0 flex flex-col gap-6">

            <!-- Tags -->
            <div class="flex flex-wrap gap-2">
                <c:if test="${not empty book.genreName}">
                    <span class="bg-primary/10 text-primary text-[12px] font-bold px-3 py-1 rounded-full uppercase tracking-wide">${book.genreName}</span>
                </c:if>
                <c:if test="${book.featured}">
                    <span class="bg-secondary/20 text-primary text-[12px] font-bold px-3 py-1 rounded-full uppercase tracking-wide">🔥 Bán chạy</span>
                </c:if>
                <c:if test="${not empty book.originName}">
                    <span class="bg-gray-100 text-gray-600 text-[12px] font-medium px-3 py-1 rounded-full">🌏 ${book.originName}</span>
                </c:if>
            </div>

            <!-- Title -->
            <h1 class="text-[30px] font-black text-[#222222] leading-tight">${book.title}</h1>

            <!-- Author -->
            <c:if test="${not empty book.authors}">
                <p class="text-[18px] italic text-gray-500">
                    Tác giả:
                    <c:forEach var="author" items="${book.authors}" varStatus="s">
                        <span class="text-primary font-semibold not-italic hover:underline cursor-pointer">${author}</span><c:if test="${!s.last}">, </c:if>
                    </c:forEach>
                </p>
            </c:if>

            <!-- Rating -->
            <div class="flex items-center gap-4">
                <div class="flex items-center gap-0.5 text-[#FDD835] text-[14px]">
                    <c:set var="rating" value="${book.avgRating}" />
                    <c:forEach begin="1" end="5" var="i">
                        <c:choose>
                            <c:when test="${i <= rating}">★</c:when>
                            <c:otherwise><span class="text-gray-300">★</span></c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <span class="text-[14px] font-medium text-gray-500">
                    <fmt:formatNumber value="${book.avgRating}" maxFractionDigits="1" /> (${book.reviewCount} đánh giá)
                </span>
            </div>

            <!-- Price card -->
            <div class="bg-white border border-gray-200 shadow-sm rounded-xl px-6 pt-10 pb-6 flex flex-col gap-6">

                <!-- Price -->
                <div class="flex items-end gap-3">
                    <span class="text-[30px] font-bold text-primary leading-none">
                        <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" />đ
                    </span>
                </div>

                <!-- Stock status -->
                <div class="flex items-center gap-2 text-[14px] font-medium">
                    <c:choose>
                        <c:when test="${book.stockQuantity > 0}">
                            <div class="w-5 h-5 bg-green-700 rounded-full flex items-center justify-center">
                                <i data-lucide="check" class="w-3 h-3 text-white"></i>
                            </div>
                            <span class="text-[#222222]">Còn hàng (${book.stockQuantity} cuốn)</span>
                        </c:when>
                        <c:otherwise>
                            <div class="w-5 h-5 bg-red-500 rounded-full flex items-center justify-center">
                                <i data-lucide="x" class="w-3 h-3 text-white"></i>
                            </div>
                            <span class="text-red-500">Hết hàng</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="flex items-center gap-4 flex-wrap">
                    <form id="add-to-cart-form" action="${pageContext.request.contextPath}/cart" method="POST" class="flex items-center gap-4 flex-wrap flex-1">
                        <input type="hidden" name="action"   value="add" />
                        <input type="hidden" name="bookID"   value="${book.bookID}" />
                        <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/products?id=${book.bookID}" />

                        <c:if test="${book.stockQuantity > 0}">
                            <div class="flex items-center border-2 border-gray-200 rounded-full overflow-hidden">
                                <button type="button" id="qty-minus" class="px-4 py-2 text-lg font-bold text-gray-500 hover:bg-gray-100 transition-colors">−</button>
                                <input id="form-qty" name="quantity" type="number" value="1" min="1" max="${book.stockQuantity}"
                                       class="w-12 text-center text-[15px] font-bold border-none outline-none py-2 bg-transparent" readonly>
                                <button type="button" id="qty-plus" class="px-4 py-2 text-lg font-bold text-gray-500 hover:bg-gray-100 transition-colors">+</button>
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${book.stockQuantity > 0}">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.account and sessionScope.account.role == 'customer'}">
                                        <button type="button" id="btn-add-to-cart"
                                                class="flex-1 bg-secondary text-primary font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:opacity-90 transition-opacity min-w-[160px]">
                                            <i data-lucide="shopping-cart" class="w-5 h-5"></i> Thêm vào giỏ
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login"
                                           class="flex-1 bg-secondary text-primary font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:opacity-90 transition-opacity min-w-[160px]">
                                            <i data-lucide="shopping-cart" class="w-5 h-5"></i> Thêm vào giỏ
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                <button type="button" disabled class="flex-1 bg-gray-200 text-gray-400 font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 cursor-not-allowed min-w-[160px]">
                                    <i data-lucide="x-circle" class="w-5 h-5"></i> Hết hàng
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </form>

                    <!-- Wishlist (UPDATED: AJAX từ code 2, giữ biến isInWishlist của code 1) -->
                    <c:choose>
                        <c:when test="${isInWishlist}">
                            <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="flex-1 min-w-[160px]" id="wishlist-detail-form">
                                <input type="hidden" name="action"  value="remove" />
                                <input type="hidden" name="bookID"  value="${book.bookID}" />
                                <button type="submit" class="w-full bg-red-50 border-2 border-red-500 text-red-500 font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-red-500 hover:text-white transition-all">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="#ef4444" stroke="#ef4444" stroke-width="2" class="w-5 h-5"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                    <span class="wishlist-text">Đã thích</span>
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="flex-1 min-w-[160px]" id="wishlist-detail-form">
                                <input type="hidden" name="action"  value="add" />
                                <input type="hidden" name="bookID"  value="${book.bookID}" />
                                <button type="submit" class="w-full border-2 border-primary text-primary font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-primary hover:text-white transition-all">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-5 h-5"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                    <span class="wishlist-text">Yêu thích</span>
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Specs grid -->
            <div class="border-y border-gray-200 grid grid-cols-2 md:grid-cols-4 divide-x divide-gray-200 py-6">
                <div class="flex flex-col gap-1 px-4 first:pl-0">
                    <span class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Nhà xuất bản</span>
                    <span class="text-[16px] font-medium text-[#222222]">—</span>
                </div>
                <div class="flex flex-col gap-1 px-4">
                    <span class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Số trang</span>
                    <span class="text-[16px] font-medium text-[#222222]">
                        <c:choose>
                            <c:when test="${book.totalPages > 0}">${book.totalPages} trang</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="flex flex-col gap-1 px-4">
                    <span class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Hình thức</span>
                    <span class="text-[16px] font-medium text-[#222222]">
                        <c:choose>
                            <c:when test="${not empty book.contentName}">${book.contentName}</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="flex flex-col gap-1 px-4">
                    <span class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Mã SKU</span>
                    <span class="text-[16px] font-medium text-[#222222]">BT-${book.bookID}</span>
                </div>
            </div>

            <!-- Description -->
            <c:if test="${not empty book.description}">
                <div class="flex flex-col gap-3">
                    <h2 class="section-title-left text-[20px] font-bold text-primary">Mô tả</h2>
                    <p class="text-[16px] text-gray-500 leading-relaxed line-clamp-5">${book.description}</p>
                </div>
            </c:if>
        </div>
    </section>

    <!-- ══ REVIEWS (UPDATED: tab layout từ code 2) ════════════════════════════════════════════════════════ -->
    <section class="pt-2">
        <!-- Tab Navigation -->
        <div class="tab-nav">
            <button class="tab-btn" onclick="switchTab('tab-desc', this)">Mô tả</button>
            <button class="tab-btn" onclick="switchTab('tab-info', this)">Thông tin bổ sung</button>
            <button class="tab-btn active" onclick="switchTab('tab-reviews', this)">
                Đánh giá (${book.reviewCount})
            </button>
        </div>

        <!-- Tab: Mô tả -->
        <div id="tab-desc" class="tab-panel">
            <c:choose>
                <c:when test="${not empty book.description}">
                    <p class="text-[16px] text-gray-600 leading-relaxed">${book.description}</p>
                </c:when>
                <c:otherwise>
                    <p class="text-gray-400 italic">Chưa có mô tả.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Tab: Thông tin bổ sung -->
        <div id="tab-info" class="tab-panel">
            <table class="w-full text-[15px]">
                <tbody>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500 w-[200px]">Nhà xuất bản</td>
                        <td class="py-3 text-gray-800">—</td>
                    </tr>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500">Số trang</td>
                        <td class="py-3 text-gray-800">
                            <c:choose>
                                <c:when test="${book.totalPages > 0}">${book.totalPages} trang</c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500">Hình thức</td>
                        <td class="py-3 text-gray-800">
                            <c:choose>
                                <c:when test="${not empty book.contentName}">${book.contentName}</c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500">Mã SKU</td>
                        <td class="py-3 text-gray-800">BT-${book.bookID}</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Tab: Đánh giá -->
        <div id="tab-reviews" class="tab-panel active">
            <c:choose>
                <c:when test="${not empty reviews}">
                    <c:forEach items="${reviews}" var="review">
                        <div class="review-card p-5 mb-4">
                            <div class="flex items-start justify-between mb-3">
                                <div class="flex items-center gap-3">
                                    <div class="w-10 h-10 rounded-full bg-primary flex items-center justify-center text-white font-bold text-[15px]">
                                        K
                                    </div>
                                    <div>
                                        <div class="flex items-center gap-2">
                                            <span class="font-bold text-[15px] text-gray-800">Khách hàng #${review.customerID}</span>
                                            <span class="badge-purchased">
                                                <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3"><polyline points="20 6 9 17 4 12"/></svg>
                                                ĐÃ MUA HÀNG
                                            </span>
                                        </div>
                                        <div class="flex items-center gap-0.5 text-[#FDD835] text-[14px] mt-1">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= review.rating}">★</c:when>
                                                    <c:otherwise><span class="text-gray-300">★</span></c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                    </div>
                                </div>
                                <span class="text-[13px] text-gray-400 whitespace-nowrap">${review.createdAt}</span>
                            </div>
                            <p class="text-[15px] text-gray-700 leading-relaxed">${review.comment}</p>
                            <!-- Admin reply -->
                            <div class="admin-reply">
                                <div class="flex items-center gap-2 mb-2">
                                    <span class="font-bold text-[14px] text-gray-800">Admin BookTown</span>
                                    <span class="badge-admin">ADMIN</span>
                                </div>
                                <p class="text-[14px] text-gray-600 leading-relaxed">
                                    Cảm ơn bạn đã tin tưởng và ủng hộ BookTown! Rất vui vì bạn hài lòng với chất lượng dịch vụ của shop. Hy vọng sẽ được phục vụ bạn trong những lần tới.
                                </p>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-12 text-gray-400">
                        <i data-lucide="message-square" class="w-12 h-12 mx-auto mb-3 opacity-30"></i>
                        <p class="text-[16px] font-medium">Chưa có đánh giá nào.</p>
                        <p class="text-[14px] mt-1">Hãy là người đầu tiên đánh giá sản phẩm này!</p>
                    </div>
                </c:otherwise>
            </c:choose>

            <!-- Toggle button -->
            <div class="mt-6">
                <button class="btn-write-review" onclick="document.getElementById('write-review-form').classList.toggle('open')">
                    <i data-lucide="pen-line" class="w-4 h-4"></i>
                    VIẾT ĐÁNH GIÁ CỦA BẠN
                </button>
            </div>

            <!-- Write review form (toggle, hidden by default) -->
            <div id="write-review-form" class="write-review-form">
                <h3 class="text-[18px] font-bold text-gray-800 mb-6">Viết đánh giá của bạn</h3>
                <form action="${pageContext.request.contextPath}/review" method="post">
                    <input type="hidden" name="bookID"        value="${book.bookID}">
                    <input type="hidden" name="customerID"    value="1">
                    <input type="hidden" name="orderDetailID" value="1">
                    <div class="mb-5">
                        <label class="block font-semibold text-gray-700 mb-2">Đánh giá sao</label>
                        <input type="hidden" name="rating" id="ratingValue" value="5">
                        <div id="ratingStars" class="flex items-center gap-2 text-4xl cursor-pointer">
                            <span class="star" data-value="1">☆</span>
                            <span class="star" data-value="2">☆</span>
                            <span class="star" data-value="3">☆</span>
                            <span class="star" data-value="4">☆</span>
                            <span class="star" data-value="5">☆</span>
                        </div>
                        <div class="mt-1 text-sm text-gray-400">Bạn chọn: <span id="ratingText" class="font-bold text-primary">5</span>/5 sao</div>
                    </div>
                    <div class="mb-5">
                        <label class="block font-semibold text-gray-700 mb-2">Nhận xét của bạn</label>
                        <textarea name="comment" rows="4" required
                                  class="w-full border border-gray-200 rounded-xl p-4 text-[15px] focus:outline-none focus:border-primary resize-none"
                                  placeholder="Chia sẻ cảm nhận của bạn về sản phẩm..."></textarea>
                    </div>
                    <div class="flex gap-3">
                        <button type="submit" class="btn-write-review">
                            <i data-lucide="send" class="w-4 h-4"></i> Gửi đánh giá
                        </button>
                        <button type="button" onclick="document.getElementById('write-review-form').classList.remove('open')"
                                class="px-6 py-3 border border-gray-300 text-gray-600 rounded-lg font-semibold hover:bg-gray-50 transition-colors">
                            Hủy
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </section>

    <!-- ══ RELATED BOOKS ══════════════════════════════════════════════════ -->
    <c:if test="${not empty relatedBooks}">
        <section class="pt-2">
            <div class="flex items-center justify-between mb-5">
                <h2 class="section-title-left text-[20px] font-bold text-primary">📚 Bạn cũng có thể thích</h2>
                <div class="flex gap-2">
                    <button id="sliderPrev" class="w-[34px] h-[34px] border border-gray-200 rounded-full flex items-center justify-center hover:border-primary hover:text-primary transition-colors">
                        <i data-lucide="chevron-left" class="w-4 h-4"></i>
                    </button>
                    <button id="sliderNext" class="w-[34px] h-[34px] border border-gray-200 rounded-full flex items-center justify-center hover:border-primary hover:text-primary transition-colors">
                        <i data-lucide="chevron-right" class="w-4 h-4"></i>
                    </button>
                </div>
            </div>

            <div id="relatedSlider" class="slider-track">
                <c:forEach var="rb" items="${relatedBooks}">
                    <div class="slider-item prod-card-hover bg-white rounded-xl overflow-hidden flex flex-col">
                        <!-- UPDATED: thêm wishlist overlay heart icon từ code 2 -->
                        <div class="relative block bg-[#f0f4ff] aspect-[3/4] overflow-hidden">
                            <a href="${pageContext.request.contextPath}/products?id=${rb.bookID}">
                                <c:choose>
                                    <c:when test="${not empty rb.thumbnail}">
                                        <img src="${rb.thumbnail}" alt="${rb.title}" class="w-full h-full object-cover hover:scale-105 transition-transform duration-300">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-full h-full flex items-center justify-center">
                                            <i data-lucide="book-open" class="w-12 h-12 text-gray-300"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <c:if test="${rb.featured}">
                                <span class="absolute top-2.5 left-2.5 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">🔥 Hot</span>
                            </c:if>
                            <!-- Wishlist heart overlay (NEW from code 2) -->
                            <c:if test="${empty sessionScope.account or sessionScope.account.role == 'customer'}">
                                <form method="post" action="${pageContext.request.contextPath}/wishlist" class="wishlist-form absolute top-2.5 right-2.5 z-20">
                                    <input type="hidden" name="bookID" value="${rb.bookID}">
                                    <c:choose>
                                        <c:when test="${not empty wishlistBookIds and wishlistBookIds.contains(rb.bookID)}">
                                            <input type="hidden" name="action" value="remove">
                                            <button type="submit" class="wish-btn active" title="Xóa khỏi yêu thích">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="#ef4444" stroke="#ef4444" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="hidden" name="action" value="add">
                                            <button type="submit" class="wish-btn" title="Thêm vào yêu thích">
                                                <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#374151" stroke-width="2"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                </form>
                            </c:if>
                        </div>
                        <div class="p-3 flex flex-col flex-1 gap-1.5">
                            <a href="${pageContext.request.contextPath}/products?id=${rb.bookID}"
                               class="text-[13px] font-bold text-[#222222] line-clamp-2 hover:text-primary transition-colors min-h-[36px]">
                                ${rb.title}
                            </a>
                            <c:if test="${not empty rb.authors}">
                                <p class="text-[12px] text-gray-400 line-clamp-1">
                                    <c:forEach var="a" items="${rb.authors}" varStatus="s">
                                        ${a}<c:if test="${!s.last}">, </c:if>
                                    </c:forEach>
                                </p>
                            </c:if>
                            <div class="flex items-center gap-1 text-[12px] text-[#FDD835]">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= rb.avgRating}">★</c:when>
                                        <c:otherwise><span class="text-gray-300">★</span></c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                <span class="text-gray-400 text-[11px]">(${rb.reviewCount})</span>
                            </div>
                            <p class="text-primary text-[17px] font-bold">
                                <fmt:formatNumber value="${rb.price}" type="number" groupingUsed="true" />đ
                            </p>
                            <a href="${pageContext.request.contextPath}/products?id=${rb.bookID}"
                               class="mt-auto w-full bg-primary text-white rounded-lg py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors">
                                <i data-lucide="eye" class="w-4 h-4"></i> XEM NHANH
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>
    </c:if>

</main>

<script>
    // ── Tab switching (NEW from code 2) ──────────────────────────────────
    function switchTab(panelId, btn) {
        document.querySelectorAll('.tab-panel').forEach(function(p) { p.classList.remove('active'); });
        document.querySelectorAll('.tab-btn').forEach(function(b) { b.classList.remove('active'); });
        document.getElementById(panelId).classList.add('active');
        btn.classList.add('active');
    }

    // ── Qty +/- ──────────────────────────────────────────────────────────
    (function () {
        var input = document.getElementById('form-qty');
        if (!input) return;
        var max = parseInt(input.getAttribute('max')) || 1;

        document.getElementById('qty-minus').addEventListener('click', function () {
            var v = parseInt(input.value) || 1;
            if (v > 1) input.value = v - 1;
        });
        document.getElementById('qty-plus').addEventListener('click', function () {
            var v = parseInt(input.value) || 1;
            if (v < max) input.value = v + 1;
        });
    })();

    // ── Thumbnail switcher ───────────────────────────────────────────────
    window.switchImg = function (btn, src) {
        var main = document.getElementById('mainImage');
        if (main) main.src = src;
        document.querySelectorAll('[onclick^="switchImg"]').forEach(function (b) {
            b.className = b.className.replace('prod-thumb-active', 'prod-thumb-idle');
        });
        btn.className = btn.className.replace('prod-thumb-idle', 'prod-thumb-active');
    };

    // ── Add to cart (AJAX) ───────────────────────────────────────────────
    var btnAdd = document.getElementById('btn-add-to-cart');
    if (btnAdd) {
        btnAdd.addEventListener('click', function () {
            var bookID = document.querySelector('#add-to-cart-form input[name="bookID"]').value;
            var quantity = document.getElementById('form-qty').value;

            var params = new URLSearchParams();
            params.append('action', 'add');
            params.append('bookID', bookID);
            params.append('quantity', quantity);

            fetch('${pageContext.request.contextPath}/cart', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: params.toString()
            })
            .then(function (res) { return res.json(); })
            .then(function (data) {
                if (data.ok) {
                    var badge = document.getElementById('cart-count');
                    if (badge) badge.textContent = data.cartCount;
                    showToast('Thêm vào giỏ hàng thành công!');
                } else {
                    showToast(data.message || 'Thêm vào giỏ hàng thất bại!', true);
                }
            })
            .catch(function () {
                showToast('Lỗi kết nối, vui lòng thử lại!', true);
            });
        });
    }

    // ── Related slider ───────────────────────────────────────────────────
    var slider = document.getElementById('relatedSlider');
    var prev   = document.getElementById('sliderPrev');
    var next   = document.getElementById('sliderNext');
    if (slider && prev && next) {
        var scrollAmt = 280;
        prev.addEventListener('click', function () { slider.scrollBy({left: -scrollAmt, behavior: 'smooth'}); });
        next.addEventListener('click', function () { slider.scrollBy({left:  scrollAmt, behavior: 'smooth'}); });
    }

    // ── Star rating ──────────────────────────────────────────────────────
    var stars       = document.querySelectorAll('.star');
    var ratingInput = document.getElementById('ratingValue');
    var ratingText  = document.getElementById('ratingText');
    var currentRating = 5;

    function updateStars(rating) {
        stars.forEach(function (star) {
            if (star.dataset.value <= rating) {
                star.textContent = '★';
                star.classList.add('text-yellow-400');
            } else {
                star.textContent = '☆';
                star.classList.remove('text-yellow-400');
            }
        });
    }

    updateStars(currentRating);

    stars.forEach(function (star) {
        star.addEventListener('mouseover', function () { updateStars(star.dataset.value); });
        star.addEventListener('click', function () {
            currentRating = star.dataset.value;
            ratingInput.value = currentRating;
            ratingText.textContent = currentRating;
            updateStars(currentRating);
        });
    });

    document.getElementById('ratingStars').addEventListener('mouseleave', function () {
        updateStars(currentRating);
    });

    // ── AJAX Wishlist (NEW from code 2) ──────────────────────────────────
    document.addEventListener("DOMContentLoaded", function() {

        // 1. Wishlist detail form (main product)
        var detailForm = document.getElementById("wishlist-detail-form");
        if (detailForm) {
            detailForm.addEventListener("submit", async function(e) {
                e.preventDefault();

                var form        = e.currentTarget;
                var btn         = form.querySelector("button[type='submit']");
                var svg         = btn.querySelector("svg");
                var textSpan    = form.querySelector(".wishlist-text");
                var actionInput = form.querySelector("input[name='action']");
                var bookID      = form.querySelector("input[name='bookID']").value;
                var action      = actionInput.value;
                var formUrl     = form.getAttribute("action");

                var params = new URLSearchParams();
                params.append("action", action);
                params.append("bookID", bookID);
                params.append("ajax", "true");

                try {
                    var response = await fetch(formUrl, {
                        method: "POST",
                        headers: {
                            "X-Requested-With": "XMLHttpRequest",
                            "Content-Type": "application/x-www-form-urlencoded"
                        },
                        body: params.toString()
                    });

                    if (response.status === 401) {
                        var data = await response.json();
                        if (data.redirect) window.location.href = data.redirect;
                        return;
                    }

                    if (response.ok) {
                        var data = await response.json();
                        if (data.success) {
                            if (data.action === "added") {
                                btn.className = "w-full bg-red-50 border-2 border-red-500 text-red-500 font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-red-500 hover:text-white transition-all";
                                svg.setAttribute("fill", "#ef4444");
                                svg.setAttribute("stroke", "#ef4444");
                                textSpan.textContent = "Đã thích";
                                actionInput.value = "remove";
                                showToast("Đã thêm vào yêu thích!");
                            } else {
                                btn.className = "w-full border-2 border-primary text-primary font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-primary hover:text-white transition-all";
                                svg.setAttribute("fill", "none");
                                svg.setAttribute("stroke", "currentColor");
                                textSpan.textContent = "Yêu thích";
                                actionInput.value = "add";
                                showToast("Đã xóa khỏi yêu thích!");
                            }

                            var badge = document.querySelector(".wishlist-badge");
                            if (badge) {
                                badge.textContent = data.wishlistCount;
                                if (data.wishlistCount > 0) badge.classList.remove("hidden");
                                else badge.classList.add("hidden");
                            }
                        } else {
                            showToast("Có lỗi xảy ra, vui lòng thử lại.", true);
                        }
                    } else {
                        showToast("Không thể thực hiện yêu cầu.", true);
                    }
                } catch (err) {
                    console.error(err);
                    showToast("Lỗi kết nối mạng.", true);
                }
            });
        }

        // 2. Wishlist forms in related slider
        document.querySelectorAll(".wishlist-form").forEach(function(form) {
            form.addEventListener("submit", async function(e) {
                e.preventDefault();

                var f           = e.currentTarget;
                var btn         = f.querySelector(".wish-btn");
                var svg         = btn.querySelector("svg");
                var actionInput = f.querySelector("input[name='action']");
                var bookID      = f.querySelector("input[name='bookID']").value;
                var action      = actionInput.value;
                var formUrl     = f.getAttribute("action");

                var params = new URLSearchParams();
                params.append("action", action);
                params.append("bookID", bookID);
                params.append("ajax", "true");

                try {
                    var response = await fetch(formUrl, {
                        method: "POST",
                        headers: {
                            "X-Requested-With": "XMLHttpRequest",
                            "Content-Type": "application/x-www-form-urlencoded"
                        },
                        body: params.toString()
                    });

                    if (response.status === 401) {
                        var data = await response.json();
                        if (data.redirect) window.location.href = data.redirect;
                        return;
                    }

                    if (response.ok) {
                        var data = await response.json();
                        if (data.success) {
                            if (data.action === "added") {
                                btn.classList.add("active");
                                svg.setAttribute("fill", "#ef4444");
                                svg.setAttribute("stroke", "#ef4444");
                                actionInput.value = "remove";
                                btn.setAttribute("title", "Xóa khỏi yêu thích");
                                showToast("Đã thêm vào yêu thích!");
                            } else if (data.action === "removed") {
                                btn.classList.remove("active");
                                svg.setAttribute("fill", "none");
                                svg.setAttribute("stroke", "#374151");
                                actionInput.value = "add";
                                btn.setAttribute("title", "Thêm vào yêu thích");
                                showToast("Đã xóa khỏi yêu thích!");
                            }

                            var badge = document.querySelector(".wishlist-badge");
                            if (badge) {
                                badge.textContent = data.wishlistCount;
                                if (data.wishlistCount > 0) badge.classList.remove("hidden");
                                else badge.classList.add("hidden");
                            }
                        } else {
                            showToast("Có lỗi xảy ra, vui lòng thử lại.", true);
                        }
                    } else {
                        showToast("Không thể thực hiện yêu cầu.", true);
                    }
                } catch (err) {
                    console.error(err);
                    showToast("Lỗi kết nối mạng.", true);
                }
            });
        });
    });
</script>

<%@ include file="/views/layout/common/toast.jsp" %>
<%@ include file="/views/layout/homepage/footer.jsp" %>
