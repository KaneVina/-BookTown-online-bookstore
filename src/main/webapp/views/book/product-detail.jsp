<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

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
    .review-card        {
        border: 1px solid #E0E0E0;
        border-radius: 12px;
        background:#fff;
    }
    .slider-track       {
        display: flex;
        gap: 16px;
        overflow-x: auto;
        scroll-snap-type: x mandatory;
        scrollbar-width: none;
    }
    .slider-track::-webkit-scrollbar {
        display: none;
    }
    .slider-item        {
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
</style>


<main class="max-w-[1400px] mx-auto px-8 py-8 flex flex-col gap-8">
    <section class="flex flex-col lg:flex-row gap-10">
        <div class="flex-shrink-0 w-full lg:w-[499px] flex flex-col gap-4">
            <div class="bg-white border border-gray-200 shadow-sm rounded-xl overflow-hidden aspect-[3/4] flex items-center justify-center relative">
                <c:choose>
                    <c:when test="${not empty book.thumbnail}">
                        <img id="mainImage" src="${book.thumbnail}" alt="${book.title}"
                             class="w-full h-full object-cover">
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
        <div class="flex-1 min-w-0 flex flex-col gap-6">
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
            <h1 class="text-[30px] font-black text-[#222222] leading-tight">${book.title}</h1>
            <c:if test="${not empty book.authors}">
                <p class="text-[18px] italic text-gray-500">
                    Tác giả:
                    <c:forEach var="author" items="${book.authors}" varStatus="s">
                        <span class="text-primary font-semibold not-italic hover:underline cursor-pointer">${author}</span><c:if test="${!s.last}">, </c:if>
                    </c:forEach>
                </p>
            </c:if>
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

            <div class="bg-white border border-gray-200 shadow-sm rounded-xl px-6 pt-10 pb-6 flex flex-col gap-6">
                <div class="flex items-end gap-3">
                    <span class="text-[30px] font-bold text-primary leading-none">
                        <fmt:formatNumber value="${book.price}" type="number" groupingUsed="true" />đ
                    </span>
                </div>
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
                    <div class="flex items-center border-2 border-gray-200 rounded-full overflow-hidden">
                        <button type="button" id="qty-minus" class="px-4 py-2 text-lg font-bold text-gray-500 hover:bg-gray-100 transition-colors">−</button>
                        <input id="qty-input" type="number" value="1" min="1" max="${book.stockQuantity}"
                               class="w-12 text-center text-[15px] font-bold border-none outline-none py-2 bg-transparent" readonly>
                        <button type="button" id="qty-plus" class="px-4 py-2 text-lg font-bold text-gray-500 hover:bg-gray-100 transition-colors">+</button>
                    </div>
                    <c:choose>
                        <c:when test="${book.stockQuantity > 0}">
                            <button type="button" id="btn-add-cart"
                                    class="flex-1 bg-secondary text-primary font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:opacity-90 transition-opacity min-w-[160px]">
                                <i data-lucide="shopping-cart" class="w-5 h-5"></i> Thêm vào giỏ
                            </button>
                            <button type="button" class="flex-1 border-2 border-primary text-primary font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-primary hover:text-white transition-all min-w-[160px]">
                                <i data-lucide="heart" class="w-5 h-5"></i> Thêm vào yêu thích
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button type="button" disabled class="flex-1 bg-gray-200 text-gray-400 font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 cursor-not-allowed min-w-[160px]">
                                <i data-lucide="x-circle" class="w-5 h-5"></i> Hết hàng
                            </button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
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
            <c:if test="${not empty book.description}">
                <div class="flex flex-col gap-3">
                    <h2 class="section-title-left text-[20px] font-bold text-primary">Mô tả</h2>
                    <p class="text-[16px] text-gray-500 leading-relaxed line-clamp-5">${book.description}</p>
                </div>
            </c:if>
        </div>
    </section>
    <section class="pt-2">

        <div class="flex items-center justify-between mb-5">
            <h2 class="section-title-left text-[20px] font-bold text-primary">
                Đánh giá
            </h2>
        </div>
        <c:choose>
            <c:when test="${not empty reviews}">
                <c:forEach items="${reviews}" var="review">
                    <div class="review-card p-4 mb-4">
                        <div class="flex justify-between items-center mb-2">
                            <span class="font-semibold">
                                Customer #${review.customerID}
                            </span>
                            <small class="text-gray-500">
                                ${review.createdAt}
                            </small>
                        </div>
                        <div class="text-yellow-500 mb-2">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= review.rating}">
                                        ★
                                    </c:when>
                                    <c:otherwise>
                                        ☆
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <p class="text-gray-700">
                            ${review.comment}
                        </p>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="bg-gray-50 border rounded-lg p-4">
                    Chưa có đánh giá nào.
                </div>
            </c:otherwise>
        </c:choose>

        <div class="mt-8 bg-white border rounded-xl p-6">
            <h3 class="text-lg font-bold mb-4">
                Viết đánh giá
            </h3>
            <form action="${pageContext.request.contextPath}/review"
                  method="post">

                <input type="hidden"
                       name="bookID"
                       value="${book.bookID}">
                <input type="hidden"
                       name="customerID"
                       value="1">
                <input type="hidden"
                       name="orderDetailID"
                       value="1">

                <div class="mb-4">

                    <label class="font-medium">
                        Đánh giá
                    </label>

                    <select name="rating"
                            class="w-full border rounded p-2 mt-1">

                        <option value="5">★★★★★</option>
                        <option value="4">★★★★☆</option>
                        <option value="3">★★★☆☆</option>
                        <option value="2">★★☆☆☆</option>
                        <option value="1">★☆☆☆☆</option>

                    </select>
                </div>
                <div class="mb-4">
                    <label class="font-medium">
                        Nhận xét
                    </label>
                    <textarea
                        name="comment"
                        rows="4"
                        required
                        class="w-full border rounded p-3 mt-1"
                        placeholder="Nhập đánh giá của bạn..."></textarea>
                </div>
                <button
                    type="submit"
                    class="bg-blue-600 text-white px-5 py-2 rounded-lg hover:bg-blue-700">
                    Gửi đánh giá
                </button>
            </form>
        </div>
    </section>
    <c:if test="${not empty relatedBooks}">
        <section class="pt-2">
            <div class="flex items-center justify-between mb-5">
                <h2 class="section-title-left text-[20px] font-bold text-primary">📚 Bạn cũng có thể thích</h2>
                <div class="flex gap-2">
                    <button id="sliderPrev"
                            class="w-[34px] h-[34px] border border-gray-200 rounded-full flex items-center justify-center hover:border-primary hover:text-primary transition-colors">
                        <i data-lucide="chevron-left" class="w-4 h-4"></i>
                    </button>
                    <button id="sliderNext"
                            class="w-[34px] h-[34px] border border-gray-200 rounded-full flex items-center justify-center hover:border-primary hover:text-primary transition-colors">
                        <i data-lucide="chevron-right" class="w-4 h-4"></i>
                    </button>
                </div>
            </div>

            <div id="relatedSlider" class="slider-track">
                <c:forEach var="rb" items="${relatedBooks}">
                    <div class="slider-item prod-card-hover bg-white rounded-xl overflow-hidden flex flex-col">
                        <a href="${pageContext.request.contextPath}/products?id=${rb.bookID}"
                           class="relative block bg-[#f0f4ff] aspect-[3/4] overflow-hidden">
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
                            <c:if test="${rb.featured}">
                                <span class="absolute top-2.5 left-2.5 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">🔥 Hot</span>
                            </c:if>
                        </a>
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
    var CART_URL = '${pageContext.request.contextPath}/cart';
    var BOOK_ID  = ${book.bookID};

    var qtyInput = document.getElementById('qty-input');

    // Nút tăng/giảm số lượng
    document.getElementById('qty-minus').addEventListener('click', function() {
        var v = parseInt(qtyInput.value) || 1;
        if (v > 1) qtyInput.value = v - 1;
    });
    document.getElementById('qty-plus').addEventListener('click', function() {
        var v = parseInt(qtyInput.value) || 1;
        var max = parseInt(qtyInput.getAttribute('max')) || 999;
        if (v < max) qtyInput.value = v + 1;
    });

    // Nút thêm vào giỏ (AJAX)
    var btnAdd = document.getElementById('btn-add-cart');
    if (btnAdd) {
        btnAdd.addEventListener('click', function() {
            var qty = parseInt(qtyInput.value) || 1;

            fetch(CART_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'action=add&bookID=' + BOOK_ID + '&quantity=' + qty,
                redirect: 'manual'
            })
            .then(function(res) {
                if (res.type === 'opaqueredirect' || res.ok) {
                    // Cập nhật badge giỏ hàng trên header
                    var badge = document.getElementById('cart-count');
                    if (badge) {
                        badge.textContent = parseInt(badge.textContent || '0') + qty;
                    }
                }
            })
            .catch(function() {});
        });
    }

    // Chuyển ảnh thumbnail
    window.switchImg = function(btn, src) {
        var main = document.getElementById('mainImage');
        if (main) main.src = src;
        document.querySelectorAll('[onclick^="switchImg"]').forEach(function(b) {
            b.className = b.className.replace('prod-thumb-active', 'prod-thumb-idle');
        });
        btn.className = btn.className.replace('prod-thumb-idle', 'prod-thumb-active');
    };

    // Slider sản phẩm liên quan
    var slider = document.getElementById('relatedSlider');
    var prev   = document.getElementById('sliderPrev');
    var next   = document.getElementById('sliderNext');
    if (slider && prev && next) {
        prev.addEventListener('click', function() { slider.scrollBy({ left: -280, behavior: 'smooth' }); });
        next.addEventListener('click', function() { slider.scrollBy({ left:  280, behavior: 'smooth' }); });
    }
</script>

<%@ include file="/views/layout/homepage/footer.jsp" %>
