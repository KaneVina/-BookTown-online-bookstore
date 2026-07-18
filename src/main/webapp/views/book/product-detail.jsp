<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ include file="/views/layout/homepage/header.jsp" %>

<style>
    /* [FIX] Input số lượng type=number: ẩn mũi tên tăng/giảm mặc định của
       trình duyệt (Chrome/Safari/Edge), vì nó chiếm không gian bên phải làm
       số 2 chữ số (10, 11, 12...) bị bó hẹp/che mất, nhìn như chỉ hiện "1". */
    .no-spinner::-webkit-outer-spin-button,
    .no-spinner::-webkit-inner-spin-button {
        -webkit-appearance: none;
        margin: 0;
    }
    .no-spinner {
        -moz-appearance: textfield;
        appearance: textfield;
    }
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

    /* ── Tabs ── */
    .tab-nav {
        border-bottom: 1px solid #E0E0E0;
        display: flex;
        gap: 0;
    }
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
    .tab-btn:hover {
        color: #17479D;
    }
    .tab-btn.active {
        color: #17479D;
        border-bottom-color: #17479D;
    }
    .tab-panel {
        display: none;
        padding-top: 24px;
    }
    .tab-panel.active {
        display: block;
    }

    /* ── Review cards ── */
    .badge-purchased {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        background: #e8f5e9;
        color: #2e7d32;
        font-size: 11px;
        font-weight: 700;
        padding: 2px 8px;
        border-radius: 20px;
    }
    .badge-admin {
        display: inline-block;
        background: #1565C0;
        color: #fff;
        font-size: 10px;
        font-weight: 700;
        padding: 1px 7px;
        border-radius: 4px;
        margin-left: 6px;
        vertical-align: middle;
    }
    .admin-reply {
        background: #e3f0fb;
        border-radius: 10px;
        padding: 14px 16px;
        margin-top: 14px;
    }

    /* ── Write review form ── */
    .btn-write-review {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background: #17479D;
        color: #fff;
        font-size: 14px;
        font-weight: 700;
        padding: 12px 24px;
        border-radius: 8px;
        border: none;
        cursor: pointer;
        text-transform: uppercase;
        letter-spacing: .5px;
        transition: background .2s;
    }
    .btn-write-review:hover {
        background: #0D47A1;
    }
    .write-review-form {
        background: #fff;
        border: 1px solid #E0E0E0;
        border-radius: 12px;
        padding: 28px;
        margin-top: 24px;
        display: none;
    }
    .write-review-form.open {
        display: block;
    }

    .review-summary {
        background: linear-gradient(135deg,#f8fafc,#ffffff);
        border: 1px solid #e5e7eb;
        border-radius: 16px;
    }

    .review-item {
        border: 1px solid #e5e7eb;
        border-radius: 14px;
        background: white;
        transition: all .25s ease;
    }

    .review-item:hover {
        box-shadow: 0 8px 24px rgba(0,0,0,.08);
    }

    .star-filled {
        color: #facc15;
    }
    .star-empty  {
        color: #d1d5db;
    }

    .review-avatar {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background: #4f46e5;
        color: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: bold;
    }

    .btn-disabled {
        opacity: 0.5;
        cursor: not-allowed;
        pointer-events: none;
    }
</style>

<main class="max-w-[1400px] mx-auto px-8 py-8 flex flex-col gap-8">

    <!-- ══ PRODUCT HERO ══════════════════════════════════════════════════ -->
    <section class="flex flex-col lg:flex-row gap-10">

        <!-- LEFT: Image Gallery -->
        <div class="flex-shrink-0 w-full lg:w-[499px] flex flex-col gap-4">

            <%-- [FIX] book.thumbnail lưu dạng "url1|url2|url3|url4" nhưng JSP gốc
                 dùng thẳng ${img1}..${img4} mà không hề tách chuỗi -> ảnh luôn trống.
                 Bổ sung đoạn tách chuỗi này (lấy từ code 2) để gallery hoạt động đúng. --%>
            <%
                String rawThumb = (request.getAttribute("book") != null)
                        ? ((model.Book) request.getAttribute("book")).getThumbnail() : "";
                if (rawThumb == null) rawThumb = "";
                String[] imgArr = rawThumb.split("\\|", -1);
                String img1 = imgArr.length > 0 ? imgArr[0].trim() : "";
                String img2 = imgArr.length > 1 ? imgArr[1].trim() : "";
                String img3 = imgArr.length > 2 ? imgArr[2].trim() : "";
                String img4 = imgArr.length > 3 ? imgArr[3].trim() : "";
                pageContext.setAttribute("img1", img1);
                pageContext.setAttribute("img2", img2);
                pageContext.setAttribute("img3", img3);
                pageContext.setAttribute("img4", img4);
            %>

            <div class="bg-white border border-gray-200 shadow-sm rounded-xl overflow-hidden aspect-[3/4] flex items-center justify-center relative">
                <c:choose>
                    <c:when test="${not empty img1}">
                        <img id="mainImage" src="${img1}" alt="${book.title}" class="w-full h-full object-cover">
                    </c:when>
                    <c:otherwise>
                        <i data-lucide="book-open" class="w-24 h-24 text-gray-300"></i>
                    </c:otherwise>
                </c:choose>

                <c:if test="${book.featured}">
                    <div class="absolute top-3 left-3 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">🔥 Nổi bật</div>
                </c:if>

                <%-- [FIX] Hợp nhất 2 overlay "Hết hàng" bị lặp ở bản gốc thành 1,
                     kiểm tra cả status và stockQuantity cho đồng bộ với phần bên dưới --%>
                <c:if test="${book.status != 'available' or book.stockQuantity == 0}">
                    <div class="absolute inset-0 bg-black/50 flex items-center justify-center">
                        <span class="bg-white text-red-600 font-bold text-sm px-4 py-2 rounded-full">Hết hàng</span>
                    </div>
                </c:if>
            </div>

            <%-- [FIX] Bỏ khối thumbnail-strip thứ 2 (dùng nhầm chuỗi thô book.thumbnail
                 làm src ảnh) — chỉ giữ lại 1 thumbnail-strip dùng img1..img4 đã tách đúng --%>
            <c:if test="${not empty img1}">
                <div class="grid grid-cols-4 gap-3">
                    <%-- Ảnh 1: bìa chính --%>
                    <button onclick="switchImg(this, '${img1}')"
                            class="prod-thumb-active rounded-lg overflow-hidden aspect-square bg-gray-50">
                        <img src="${img1}" class="w-full h-full object-cover" alt="">
                    </button>
                    <%-- Ảnh 2 --%>
                    <c:choose>
                        <c:when test="${not empty img2}">
                            <button onclick="switchImg(this, '${img2}')"
                                    class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50">
                                <img src="${img2}" class="w-full h-full object-cover" alt="">
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50 flex items-center justify-center opacity-40 cursor-not-allowed">
                                <i data-lucide="image" class="w-6 h-6 text-gray-300"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
                    <%-- Ảnh 3 --%>
                    <c:choose>
                        <c:when test="${not empty img3}">
                            <button onclick="switchImg(this, '${img3}')"
                                    class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50">
                                <img src="${img3}" class="w-full h-full object-cover" alt="">
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50 flex items-center justify-center opacity-40 cursor-not-allowed">
                                <i data-lucide="image" class="w-6 h-6 text-gray-300"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
                    <%-- Ảnh 4 --%>
                    <c:choose>
                        <c:when test="${not empty img4}">
                            <button onclick="switchImg(this, '${img4}')"
                                    class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50">
                                <img src="${img4}" class="w-full h-full object-cover" alt="">
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="prod-thumb-idle rounded-lg overflow-hidden aspect-square bg-gray-50 flex items-center justify-center opacity-40 cursor-not-allowed">
                                <i data-lucide="image" class="w-6 h-6 text-gray-300"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
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
                <%-- [FIX] kiểm tra thêm book.status để đồng bộ với overlay "Hết hàng" ở ảnh
                     (trước đây chỉ check stockQuantity > 0, không khớp với overlay) --%>
                <div class="flex items-center gap-2 text-[14px] font-medium">
                    <c:choose>
                        <c:when test="${book.status == 'available' and book.stockQuantity > 0}">
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

                        <c:if test="${book.status == 'available' and book.stockQuantity > 0}">
                            <div class="flex items-center border-2 border-gray-200 rounded-full overflow-hidden">
                                <button type="button" id="qty-minus" class="px-4 py-2 text-lg font-bold text-gray-500 hover:bg-gray-100 transition-colors">−</button>
                                <input id="form-qty" name="quantity" type="number" value="1" min="1" max="${book.stockQuantity}"
                                       class="w-14 text-center text-[15px] font-bold border-none outline-none py-2 bg-transparent no-spinner" readonly>
                                <button type="button" id="qty-plus" class="px-4 py-2 text-lg font-bold text-gray-500 hover:bg-gray-100 transition-colors">+</button>
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${book.status == 'available' and book.stockQuantity > 0}">
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

                    <!-- Wishlist -->
                    <c:if test="${empty sessionScope.account or sessionScope.account.role == 'customer'}">
                    <c:choose>
                        <c:when test="${inWishlist}">
                            <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="flex-1 min-w-[160px]" id="wishlist-detail-form" data-book-id="${book.bookID}">
                                <input type="hidden" name="wishAction" value="remove" />
                                <input type="hidden" name="wishBookId" value="${book.bookID}" />
                                <button type="submit" class="w-full bg-red-50 border-2 border-red-500 text-red-500 font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-red-500 hover:text-white transition-all">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="#ef4444" stroke="#ef4444" stroke-width="2" class="w-5 h-5"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                    <span class="wishlist-text">Đã thích</span>
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="flex-1 min-w-[160px]" id="wishlist-detail-form" data-book-id="${book.bookID}">
                                <input type="hidden" name="wishAction" value="add" />
                                <input type="hidden" name="wishBookId" value="${book.bookID}" />
                                <button type="submit" class="w-full border-2 border-primary text-primary font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-primary hover:text-white transition-all">
                                    <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-5 h-5"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg>
                                    <span class="wishlist-text">Yêu thích</span>
                                </button>
                            </form>
                        </c:otherwise>
                    </c:choose>
                    </c:if>
                </div>
            </div>

            <!-- Specs grid -->
            <div class="border-y border-gray-200 grid grid-cols-2 md:grid-cols-4 divide-x divide-gray-200 py-6">
                <div class="flex flex-col gap-1 px-4 first:pl-0">
                    <span class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Hình thức</span>
                    <span class="text-[16px] font-medium text-[#222222]">
                        <c:choose>
                            <c:when test="${not empty book.contentName}">${book.contentName}</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="flex flex-col gap-1 px-4">
                    <span class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Xuất xứ</span>
                    <span class="text-[16px] font-medium text-[#222222]">
                        <c:choose>
                            <c:when test="${not empty book.originName}">${book.originName}</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="flex flex-col gap-1 px-4">
                    <span class="text-[12px] font-bold text-gray-500 uppercase tracking-wide">Bộ sách</span>
                    <span class="text-[16px] font-medium text-[#222222]">
                        <c:choose>
                            <c:when test="${not empty book.seriesName}">${book.seriesName}</c:when>
                            <c:otherwise>—</c:otherwise>
                        </c:choose>
                    </span>
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
            </div>
        </div>
    </section>
    <%-- [FIX] Bản gốc có 1 thẻ </section> dư ở đây (đóng nhầm 2 lần) khiến phần
         Tabs/Modal/Related books bị lồng sai cấp. Đã bỏ thẻ dư và để các section
         dưới đây làm anh em (sibling) trực tiếp của <main>, giống cấu trúc sạch của code 2. --%>

    <!-- ══ TABS: Mô tả / Thông tin / Đánh giá ══════════════════════════ -->
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
                        <td class="py-3 font-semibold text-gray-500 w-[200px]">Số trang</td>
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
                        <td class="py-3 font-semibold text-gray-500">Xuất xứ</td>
                        <td class="py-3 text-gray-800">
                            <c:choose>
                                <c:when test="${not empty book.originName}">${book.originName}</c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500">Bộ sách</td>
                        <td class="py-3 text-gray-800">
                            <c:choose>
                                <c:when test="${not empty book.seriesName}">${book.seriesName}</c:when>
                                <c:otherwise>—</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                    <tr class="border-b border-gray-100">
                        <td class="py-3 font-semibold text-gray-500">Mã SKU</td>
                        <td class="py-3 text-gray-800">BT-${book.bookID}</td>
                    </tr>
                    <%-- [NEW] Bổ sung Kích thước / Trọng lượng từ code 2 (chỉ hiện khi có dữ liệu) --%>
                    <c:if test="${not empty book.dimensions}">
                        <tr class="border-b border-gray-100">
                            <td class="py-3 font-semibold text-gray-500">Kích thước</td>
                            <td class="py-3 text-gray-800">${book.dimensions}</td>
                        </tr>
                    </c:if>
                    <c:if test="${not empty book.weight}">
                        <tr>
                            <td class="py-3 font-semibold text-gray-500">Trọng lượng</td>
                            <td class="py-3 text-gray-800">${book.weight} kg</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Tab: Đánh giá -->
        <div id="tab-reviews" class="tab-panel active">

            <!-- Header + nút viết đánh giá -->
            <div class="flex items-center justify-between mb-6">
                <h2 class="section-title-left text-[22px] font-bold text-primary">
                    Đánh giá sản phẩm (${reviews.size()})
                </h2>
                <button
                    id="openReviewModal"
                    data-can-review="${canReview}"
                    type="button"
                    class="flex items-center gap-2 bg-primary hover:opacity-90 text-white font-bold px-5 py-2.5 rounded-lg transition"
                    title="${canReview ? 'Viết đánh giá' : 'Bạn cần mua và nhận sách trước khi đánh giá'}">
                    <span class="material-symbols-outlined">edit</span>
                    Viết đánh giá
                </button>
            </div>

            <!-- Danh sách reviews -->
            <c:choose>
                <c:when test="${not empty reviews}">
                    <div class="flex flex-col gap-6">
                        <c:forEach items="${reviews}" var="review">
                            <div class="bg-white p-6 rounded-xl shadow-sm border border-outline-variant hover:shadow-md transition-shadow">
                                <div class="flex justify-between items-start mb-4">
                                    <div>
                                        <div class="flex items-center gap-2">
                                            <strong>${review.customerName}</strong>
                                            <span class="text-[10px] bg-green-100 text-green-700 px-2 py-1 rounded font-bold uppercase">
                                                Đã mua hàng
                                            </span>
                                        </div>
                                        <div class="flex gap-1 mt-1 text-yellow-400">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:choose>
                                                    <c:when test="${i <= review.rating}"><span>★</span></c:when>
                                                    <c:otherwise><span class="text-gray-300">★</span></c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="flex flex-col items-end gap-2">
                                        <span class="text-xs text-gray-400 italic">
                                            <fmt:formatDate value="${review.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </span>
                                        <c:if test="${sessionScope.account != null && sessionScope.account.id == review.customerID}">
                                            <c:choose>
                                                <c:when test="${empty review.adminReply}">
                                                    <button type="button"
                                                            class="edit-review-btn flex items-center gap-1 text-xs font-semibold text-primary hover:underline"
                                                            data-review-id="${review.reviewID}"
                                                            data-rating="${review.rating}"
                                                            data-comment="${fn:escapeXml(review.comment)}">
                                                        <span class="material-symbols-outlined text-base">edit</span>
                                                        Sửa
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" disabled
                                                            title="Không thể sửa vì BookTown đã phản hồi đánh giá này"
                                                            class="flex items-center gap-1 text-xs font-semibold text-gray-400 cursor-not-allowed">
                                                        <span class="material-symbols-outlined text-base">edit_off</span>
                                                        Sửa
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:if>
                                    </div>
                                </div>
                                <p class="text-gray-700 leading-relaxed text-sm">${review.comment}</p>
                                <c:if test="${not empty review.adminReply}">
                                    <div class="mt-5 ml-6 p-4 bg-blue-50 rounded-lg border-l-4 border-primary">
                                        <div class="flex items-center gap-2 mb-2">
                                            <span class="font-bold text-primary">BookTown</span>
                                        </div>
                                        <p class="text-gray-700 text-sm leading-relaxed">${review.adminReply}</p>
                                        <c:if test="${review.adminReplyDate != null}">
                                            <div class="text-xs text-gray-400 mt-2">
                                                <fmt:formatDate value="${review.adminReplyDate}" pattern="dd/MM/yyyy HH:mm"/>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="bg-white border border-dashed border-gray-300 rounded-xl p-10 text-center">
                        <div class="text-5xl mb-3">⭐</div>
                        <div class="font-semibold text-gray-600">Chưa có đánh giá nào</div>
                        <div class="text-gray-400 mt-2">Hãy là người đầu tiên trải nghiệm và đánh giá cuốn sách này</div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </section>

    <!-- ══ REVIEW MODAL ══════════════════════════════════════════════════ -->
    <div id="reviewModal" class="fixed inset-0 bg-black/50 hidden items-center justify-center z-50">
        <div class="bg-white w-[600px] rounded-xl p-6 relative">
            <button id="closeReviewModal" class="absolute top-3 right-4 text-2xl">×</button>
            <h3 id="reviewModalTitle" class="text-xl font-bold mb-6">Viết đánh giá</h3>
            <form id="reviewForm" action="${pageContext.request.contextPath}/review" method="post">
                <input type="hidden" id="formAction"    name="action"   value="add">
                <input type="hidden" id="reviewIDInput" name="reviewID" value="">
                <input type="hidden" name="bookID" value="${book.bookID}">
                <input type="hidden" id="ratingValue"   name="rating"   value="5">
                <div class="mb-4">
                    <label class="font-semibold block mb-2">Đánh giá của bạn</label>
                    <div id="ratingStars" class="flex gap-2 text-3xl cursor-pointer">
                        <span class="star text-yellow-400" data-value="1">★</span>
                        <span class="star text-yellow-400" data-value="2">★</span>
                        <span class="star text-yellow-400" data-value="3">★</span>
                        <span class="star text-yellow-400" data-value="4">★</span>
                        <span class="star text-yellow-400" data-value="5">★</span>
                    </div>
                    <p class="text-sm text-gray-500 mt-2">Bạn đang chọn: <span id="ratingText">5</span> sao</p>
                </div>
                <textarea id="commentInput" name="comment" rows="5" required
                          placeholder="Chia sẻ cảm nhận của bạn..."
                          class="w-full border rounded-lg p-4"></textarea>
                <button id="reviewSubmitBtn" type="submit"
                        class="mt-4 bg-primary text-white px-6 py-3 rounded-lg">
                    Gửi đánh giá
                </button>
            </form>
        </div>
    </div>

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
                        <div class="relative block bg-[#f0f4ff] aspect-[3/4] overflow-hidden">
                            <a href="${pageContext.request.contextPath}/products?id=${rb.bookID}">
                                <%-- [FIX] check đúng field đang được hiển thị (rb.thumbnailFirst)
                                     thay vì check rb.thumbnail (chuỗi thô, có thể khác trạng thái rỗng) --%>
                                <c:choose>
                                    <c:when test="${not empty rb.thumbnailFirst}">
                                        <img src="${rb.thumbnailFirst}" alt="${rb.title}" class="w-full h-full object-cover hover:scale-105 transition-transform duration-300">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="w-full h-full flex items-center justify-center">
                                            <i data-lucide="book-open" class="w-12 h-12 text-gray-300"></i>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <c:if test="${rb.featured}">
                                <span class="absolute top-2.5 right-2.5 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">🔥 Hot</span>
                            </c:if>
                            <jsp:include page="/views/layout/common/wishlist-heart.jsp">
                                <jsp:param name="wishBookId" value="${rb.bookID}" />
                            </jsp:include>
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
    // ── Tab switching ────────────────────────────────────────────────────
    function switchTab(panelId, btn) {
        document.querySelectorAll('.tab-panel').forEach(function (p) {
            p.classList.remove('active');
        });
        document.querySelectorAll('.tab-btn').forEach(function (b) {
            b.classList.remove('active');
        });
        document.getElementById(panelId).classList.add('active');
        btn.classList.add('active');
    }

    // ── Qty +/- ──────────────────────────────────────────────────────────
    (function () {
        var input = document.getElementById('form-qty');
        if (!input)
            return;
        // [FIX] Lấy max trực tiếp từ server-side (JSTL) thành số nguyên JS,
        // không đọc lại từ DOM attribute để tránh sai lệch do trình duyệt
        // xử lý input[type=number][readonly] không đồng nhất (scroll/phím
        // mũi tên trên input readonly có thể vẫn đổi giá trị ở 1 số browser
        // và không được validate lại bằng max attribute).
        var max = ${book.stockQuantity > 0 ? book.stockQuantity : 1};
        var minus = document.getElementById('qty-minus');
        var plus  = document.getElementById('qty-plus');

        function clamp(v) {
            if (isNaN(v) || v < 1) v = 1;
            if (v > max) v = max;
            return v;
        }

        function render() {
            var v = clamp(parseInt(input.value, 10));
            input.value = v;
            minus.disabled = (v <= 1);
            plus.disabled  = (v >= max);
            minus.classList.toggle('opacity-40', v <= 1);
            plus.classList.toggle('opacity-40', v >= max);
        }

        minus.addEventListener('click', function () {
            input.value = clamp(parseInt(input.value, 10) - 1);
            render();
        });
        plus.addEventListener('click', function () {
            input.value = clamp(parseInt(input.value, 10) + 1);
            render();
        });
        // Chặn mọi thay đổi giá trị ngoài ý muốn (scroll wheel, phím mũi tên,
        // paste...) đều bị clamp lại đúng giới hạn kho.
        input.addEventListener('input', render);
        input.addEventListener('change', render);

        render();
    })();

    // ── Thumbnail switcher ───────────────────────────────────────────────
    // [FIX] Bản gốc khai báo switchImg 2 lần (1 lần gán window.switchImg dùng
    // className.replace, 1 lần function switchImg dùng classList) khiến bản
    // gán sau cùng đè bản kia một cách khó kiểm soát. Giờ chỉ giữ 1 bản dùng
    // classList (an toàn hơn vì không phụ thuộc thứ tự class trong className).
    window.switchImg = function (btn, src) {
        var main = document.getElementById('mainImage');
        if (main && src)
            main.src = src;
        document.querySelectorAll('.prod-thumb-active, .prod-thumb-idle').forEach(function (el) {
            el.classList.remove('prod-thumb-active');
            el.classList.add('prod-thumb-idle');
        });
        if (btn) {
            btn.classList.remove('prod-thumb-idle');
            btn.classList.add('prod-thumb-active');
        }
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
                    .then(function (res) {
                        return res.json();
                    })
                    .then(function (data) {
                        if (data.ok) {
                            var badge = document.getElementById('cart-count');
                            if (badge)
                                badge.textContent = data.cartCount;
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
    var prev = document.getElementById('sliderPrev');
    var next = document.getElementById('sliderNext');
    if (slider && prev && next) {
        var scrollAmt = 280;
        prev.addEventListener('click', function () {
            slider.scrollBy({left: -scrollAmt, behavior: 'smooth'});
        });
        next.addEventListener('click', function () {
            slider.scrollBy({left: scrollAmt, behavior: 'smooth'});
        });
    }

    // ── Star rating ──────────────────────────────────────────────────────
    var stars = document.querySelectorAll('.star');
    var ratingInput = document.getElementById('ratingValue');
    var ratingText = document.getElementById('ratingText');
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
        star.addEventListener('mouseover', function () {
            updateStars(star.dataset.value);
        });
        star.addEventListener('click', function () {
            currentRating = star.dataset.value;
            ratingInput.value = currentRating;
            ratingText.textContent = currentRating;
            updateStars(currentRating);
        });
    });
    var ratingStars = document.getElementById('ratingStars');
    if (ratingStars) {
        ratingStars.addEventListener('mouseleave', function () {
            updateStars(currentRating);
        });
    }

    // ── Review modal ─────────────────────────────────────────────────────
    var reviewModal = document.getElementById('reviewModal');
    var openReviewBtn = document.getElementById('openReviewModal');
    var closeReviewBtn = document.getElementById('closeReviewModal');
    var formActionInput = document.getElementById('formAction');
    var reviewIDInput = document.getElementById('reviewIDInput');
    var reviewModalTitle = document.getElementById('reviewModalTitle');
    var reviewSubmitBtn = document.getElementById('reviewSubmitBtn');
    var commentInput = document.getElementById('commentInput');

    function setRating(value) {
        currentRating = value;
        ratingInput.value = value;
        ratingText.textContent = value;
        updateStars(value);
    }

    function openModalForCreate() {
        formActionInput.value = 'add';
        reviewIDInput.value = '';
        commentInput.value = '';
        reviewModalTitle.textContent = 'Viết đánh giá';
        reviewSubmitBtn.textContent = 'Gửi đánh giá';
        setRating(5);
        reviewModal.classList.remove('hidden');
        reviewModal.classList.add('flex');
    }

    function openModalForEdit(btn) {
        formActionInput.value = 'edit';
        reviewIDInput.value = btn.dataset.reviewId;
        commentInput.value = btn.dataset.comment;
        reviewModalTitle.textContent = 'Sửa đánh giá';
        reviewSubmitBtn.textContent = 'Lưu thay đổi';
        setRating(parseInt(btn.dataset.rating, 10) || 5);
        reviewModal.classList.remove('hidden');
        reviewModal.classList.add('flex');
    }

    if (reviewModal && openReviewBtn) {
        openReviewBtn.addEventListener('click', function () {
            var canReview = this.dataset.canReview === 'true';
            if (!canReview) {
                showToast('Bạn cần mua và nhận sách trước khi đánh giá.', true);
                return;
            }
            openModalForCreate();
        });
        var canReview = openReviewBtn.dataset.canReview === 'true';
        if (!canReview) {
            openReviewBtn.classList.add('btn-disabled', 'opacity-50', 'cursor-not-allowed');
            openReviewBtn.disabled = true;
        }
    }

    if (closeReviewBtn && reviewModal) {
        closeReviewBtn.addEventListener('click', function () {
            reviewModal.classList.add('hidden');
            reviewModal.classList.remove('flex');
        });
    }

    document.querySelectorAll('.edit-review-btn').forEach(function (btn) {
        btn.addEventListener('click', function () {
            openModalForEdit(btn);
        });
    });

    // ── Review form AJAX submit ──────────────────────────────────────────
    var reviewForm = document.getElementById('reviewForm');
    if (reviewForm) {
        reviewForm.addEventListener('submit', function (e) {
            e.preventDefault();
            var formData = new URLSearchParams(new FormData(reviewForm));
            fetch('${pageContext.request.contextPath}/review', {
                method: 'POST',
                headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                body: formData.toString()
            })
                    .then(function (res) {
                        if (!res.ok)
                            throw new Error();
                        return res.json();
                    })
                    .then(function (data) {
                        if (data.success) {
                            showToast(data.message);
                            reviewModal.classList.add('hidden');
                            reviewModal.classList.remove('flex');
                            setTimeout(function () {
                                location.reload();
                            }, 1000);
                        } else {
                            showToast(data.message, true);
                        }
                    })
                    .catch(function () {
                        showToast('Có lỗi xảy ra', true);
                    });
        });
    }

</script>

<%@ include file="/views/layout/common/toast.jsp" %>
<%@ include file="/views/layout/common/wishlist-heart.js.jsp" %>
<%@ include file="/views/layout/homepage/footer.jsp" %>
