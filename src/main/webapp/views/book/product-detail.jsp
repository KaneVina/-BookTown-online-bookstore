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

                <!-- ✅ FIX: Form có id="add-to-cart-form" và input qty có id="form-qty" -->
                <div class="flex items-center gap-4 flex-wrap">
                    <form id="add-to-cart-form" action="${pageContext.request.contextPath}/cart" method="POST" class="flex items-center gap-4 flex-wrap flex-1">
                        <input type="hidden" name="action"   value="add" />
                        <input type="hidden" name="bookID"   value="${book.bookID}" />
                        <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/products?id=${book.bookID}" />

                        <c:if test="${book.stockQuantity > 0}">
                            <div class="flex items-center border-2 border-gray-200 rounded-full overflow-hidden">
                                <button type="button" id="qty-minus" class="px-4 py-2 text-lg font-bold text-gray-500 hover:bg-gray-100 transition-colors">−</button>
                                <!-- ✅ FIX: thêm id="form-qty" để JS tìm được -->
                                <input id="form-qty" name="quantity" type="number" value="1" min="1" max="${book.stockQuantity}"
                                       class="w-12 text-center text-[15px] font-bold border-none outline-none py-2 bg-transparent" readonly>
                                <button type="button" id="qty-plus" class="px-4 py-2 text-lg font-bold text-gray-500 hover:bg-gray-100 transition-colors">+</button>
                            </div>
                        </c:if>

                        <c:choose>
                            <c:when test="${book.stockQuantity > 0}">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.account and sessionScope.account.role == 'customer'}">
                                        <!-- ✅ FIX: dùng id="btn-add-to-cart" để JS gắn event được -->
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

                    <!-- Wishlist (giữ nguyên từ code 1) -->
                    <c:choose>
                        <c:when test="${isInWishlist}">
                            <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="flex-1 min-w-[160px]">
                                <input type="hidden" name="action"  value="remove" />
                                <input type="hidden" name="bookID"  value="${book.bookID}" />
                                <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/products?id=${book.bookID}" />
                                <button type="submit" class="w-full bg-red-50 border-2 border-red-500 text-red-500 font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-red-500 hover:text-white transition-all">
                                    <i data-lucide="heart" class="w-5 h-5 fill-current"></i> Đã thích
                                </button>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <form action="${pageContext.request.contextPath}/wishlist" method="POST" class="flex-1 min-w-[160px]">
                                <input type="hidden" name="action"  value="add" />
                                <input type="hidden" name="bookID"  value="${book.bookID}" />
                                <input type="hidden" name="redirect" value="${pageContext.request.contextPath}/products?id=${book.bookID}" />
                                <button type="submit" class="w-full border-2 border-primary text-primary font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-primary hover:text-white transition-all">
                                    <i data-lucide="heart" class="w-5 h-5"></i> Yêu thích
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

    <!-- ══ REVIEWS ════════════════════════════════════════════════════════ -->
    <section class="pt-2">
        <div class="flex items-center justify-between mb-5">
            <h2 class="section-title-left text-[20px] font-bold text-primary">Đánh giá</h2>
        </div>

        <c:choose>
            <c:when test="${not empty reviews}">
                <c:forEach items="${reviews}" var="review">
                    <div class="review-card p-4 mb-4">
                        <div class="flex justify-between items-center mb-2">
                            <span class="font-semibold">Customer #${review.customerID}</span>
                            <small class="text-gray-500">${review.createdAt}</small>
                        </div>
                        <div class="text-yellow-500 mb-2">
                            <c:forEach begin="1" end="5" var="i">
                                <c:choose>
                                    <c:when test="${i <= review.rating}">★</c:when>
                                    <c:otherwise>☆</c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                        <p class="text-gray-700">${review.comment}</p>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="bg-white border border-gray-100 rounded-xl p-10 text-center text-gray-400 text-[14px]">
                    Chưa có đánh giá nào. Hãy là người đầu tiên nhận xét!
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Write review form -->
        <div class="mt-8 bg-white border rounded-xl p-6">
            <h3 class="text-lg font-bold mb-4">Viết đánh giá</h3>
            <form action="${pageContext.request.contextPath}/review" method="post">
                <input type="hidden" name="bookID"        value="${book.bookID}">
                <input type="hidden" name="customerID"    value="1">
                <input type="hidden" name="orderDetailID" value="1">

                <div class="mb-4">
                    <label class="font-medium block mb-2">Đánh giá</label>
                    <input type="hidden" name="rating" id="ratingValue" value="5">
                    <div id="ratingStars" class="flex items-center gap-1 text-4xl cursor-pointer">
                        <span class="star" data-value="1">☆</span>
                        <span class="star" data-value="2">☆</span>
                        <span class="star" data-value="3">☆</span>
                        <span class="star" data-value="4">☆</span>
                        <span class="star" data-value="5">☆</span>
                    </div>
                    <div class="mt-2 text-sm text-gray-500">
                        Đánh giá: <span id="ratingText">5</span>/5
                    </div>
                </div>
                <div class="mb-4">
                    <label class="font-medium">Nhận xét</label>
                    <textarea name="comment" rows="4" required
                              class="w-full border rounded p-3 mt-1"
                              placeholder="Nhập đánh giá của bạn..."></textarea>
                </div>
                <button type="submit" class="bg-blue-600 text-white px-5 py-2 rounded-lg hover:bg-blue-700">
                    Gửi đánh giá
                </button>
            </form>
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

<!-- ✅ FIX: Script được viết lại đúng cấu trúc, không bị lồng nhau -->
<script>
    // ── Qty +/- ──────────────────────────────────────────────────────────
    (function () {
        var input = document.getElementById('form-qty');
        if (!input)
            return;
        var max = parseInt(input.getAttribute('max')) || 1;

        document.getElementById('qty-minus').addEventListener('click', function () {
            var v = parseInt(input.value) || 1;
            if (v > 1)
                input.value = v - 1;
        });
        document.getElementById('qty-plus').addEventListener('click', function () {
            var v = parseInt(input.value) || 1;
            if (v < max)
                input.value = v + 1;
        });
    })();

    // ── Thumbnail switcher ───────────────────────────────────────────────
    window.switchImg = function (btn, src) {
        var main = document.getElementById('mainImage');
        if (main)
            main.src = src;
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

    updateStars(currentRating); // hiển thị mặc định 5 sao

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

    document.getElementById('ratingStars').addEventListener('mouseleave', function () {
        updateStars(currentRating);
    });
</script>

<%@ include file="/views/layout/common/toast.jsp" %>
<%@ include file="/views/layout/homepage/footer.jsp" %>
