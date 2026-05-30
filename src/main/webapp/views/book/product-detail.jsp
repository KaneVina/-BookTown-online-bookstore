<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="/views/layout/homepage/header.jsp" %>

<main class="max-w-[1280px] mx-auto px-8 py-6" style="background: linear-gradient(0deg, #F4F4F4, #F4F4F4), #FFFFFF; min-height: 100vh;">

    <!-- BREADCRUMB -->
    <nav class="text-sm text-gray-500 mb-6 flex items-center gap-1.5">
        <a href="${pageContext.request.contextPath}/" class="hover:text-primary transition-colors">Trang chủ</a>
        <span class="text-gray-300">/</span>
        <a href="${pageContext.request.contextPath}/products?category=van-hoc" class="hover:text-primary transition-colors">Thư viện</a>
        <span class="text-gray-300">/</span>
        <span class="text-primary font-medium">Sách Văn học</span>
    </nav>

    <!-- PRODUCT DETAIL SECTION -->
    <section class="bg-white rounded-xl shadow-sm p-8 mb-8">
        <div class="flex flex-col lg:flex-row gap-10">

            <!-- LEFT: Image Gallery -->
            <div class="flex flex-col gap-4 lg:w-[340px] flex-shrink-0">
                <!-- Main Image -->
                <div class="relative rounded-xl overflow-hidden bg-[#f5f5f0] aspect-[3/4] flex items-center justify-center">
                    <img
                        id="mainImage"
                        src="https://lh3.googleusercontent.com/aida-public/AB6AXuBYZn0G898rGsRNjqKMDfcw2DeIUbBzWKEfBC17FtB9kLNhkHqBn6SxObR1s-D01LiltlZlXo_lLdZ081Evb0G1RnCa0rmXHkBfGBmm_MBhiRZzHFcKBv1b1xAcoBcGyPje2eDaaKUE6FmZZLNL0JR_6eHdVcui4k0QQQxXMg31q4CcubkL4dnr5CpCG3lrPpzjNoWa4V0mt42PhymHEqLox60kxz9Ubnnr6O_ivf1I_GFTDhihusQEHqGrf-EfJuWOw9esdjhdMqCI"
                        alt="The Whispering Library - Bìa sách"
                        class="w-full h-full object-cover transition-opacity duration-300"
                    >
                    <!-- Badge -->
                    <div class="absolute top-3 left-3 bg-[#E53935] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full">
                        Tiết kiệm 17%
                    </div>
                </div>

                <!-- Thumbnails -->
                <div class="flex gap-2.5">
                    <div class="thumbnail-item w-[72px] h-[72px] rounded-lg overflow-hidden border-2 border-primary cursor-pointer flex-shrink-0">
                        <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuBYZn0G898rGsRNjqKMDfcw2DeIUbBzWKEfBC17FtB9kLNhkHqBn6SxObR1s-D01LiltlZlXo_lLdZ081Evb0G1RnCa0rmXHkBfGBmm_MBhiRZzHFcKBv1b1xAcoBcGyPje2eDaaKUE6FmZZLNL0JR_6eHdVcui4k0QQQxXMg31q4CcubkL4dnr5CpCG3lrPpzjNoWa4V0mt42PhymHEqLox60kxz9Ubnnr6O_ivf1I_GFTDhihusQEHqGrf-EfJuWOw9esdjhdMqCI" alt="Ảnh 1" class="w-full h-full object-cover">
                    </div>
                    <div class="thumbnail-item w-[72px] h-[72px] rounded-lg overflow-hidden border-2 border-gray-200 cursor-pointer flex-shrink-0 hover:border-primary transition-colors">
                        <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuDLpeq1y2nUHWByaMqR26eH_13lnomIO3s0dboXH0TyxELa-FcZkCX9iWcWpInVR4ZY-zLKr1n_o8WOhxPHVTv-UZMp053czMx0t6dDkDXXs46Jpd0S7YpDQghqN7DXtIHPIFocxFbWcheIw0Rmw4VsobV41bCy_ts3A5Z4l7B-HqAVaXAfWLABA6zmAjRCfACWXSNApQocvcsQjxvfY-wH4hRSSeP_kWWaG-F0YJA3ztw6Iajg514_y4KLD-Hzu6TB2w4ekxkkf9ZV" alt="Ảnh 2" class="w-full h-full object-cover">
                    </div>
                    <div class="thumbnail-item w-[72px] h-[72px] rounded-lg overflow-hidden border-2 border-gray-200 cursor-pointer flex-shrink-0 hover:border-primary transition-colors">
                        <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuAq8GZju_7_XRWTEIgtQItR-uKfARYvGRemwW5KN9bJ9acvJbY_vVSL7rN8kWfJzytI-t0698Cvz7U3iBax1985HnikptWOed9wjG1JVPLWtwaQOtnSa3GjZfRZldv8EmWFb9m2JWFeINbpwY6MculeuviR6eIHxXcwDUUu2V9fAxu9lIu9Ywb63v-v_FXFnOh4Sh23MnFwwoGEi72nAB9eoj1U2xl5cKQfeneO2UKC_fe0G7VBfTkF8Y1YLHZv22FdZ4F1HxhXL7m6" alt="Ảnh 3" class="w-full h-full object-cover">
                    </div>
                    <div class="thumbnail-item w-[72px] h-[72px] rounded-lg overflow-hidden border-2 border-gray-200 cursor-pointer flex-shrink-0 hover:border-primary transition-colors bg-[#f5f0e8] flex items-center justify-center">
                        <i data-lucide="book-open" class="w-8 h-8 text-gray-400"></i>
                    </div>
                </div>
            </div>

            <!-- RIGHT: Product Info -->
            <div class="flex-1 flex flex-col gap-5">

                <!-- Category badges -->
                <div class="flex gap-2">
                    <span class="bg-primary/10 text-primary text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wide">Văn Học</span>
                    <span class="bg-secondary/20 text-yellow-700 text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wide">Bán Chạy</span>
                </div>

                <!-- Title & Author -->
                <div>
                    <h1 class="text-3xl font-black text-primary leading-tight mb-1">The Whispering Library</h1>
                    <p class="text-gray-500 text-[15px]">Tác giả: <span class="text-on-surface font-semibold hover:text-primary cursor-pointer transition-colors">Eleanor Vance</span></p>
                </div>

                <!-- Rating -->
                <div class="flex items-center gap-2.5">
                    <div class="text-[#FDD835] text-base flex items-center gap-0.5">★★★★★</div>
                    <span class="text-sm font-semibold text-gray-700">4.8</span>
                    <span class="text-sm text-gray-400">(1.240 đánh giá)</span>
                </div>

                <!-- Price -->
                <div class="flex items-center gap-3">
                    <span class="text-[32px] font-black text-primary leading-none">166.000 đ</span>
                    <span class="text-lg text-gray-400 line-through font-normal">200.000 đ</span>
                    <span class="bg-[#E53935] text-white text-xs font-bold px-2.5 py-1 rounded-full">Tiết kiệm 17%</span>
                </div>

                <!-- Stock -->
                <div class="flex items-center gap-2 text-[13px]">
                    <div class="w-2 h-2 rounded-full bg-green-500"></div>
                    <span class="text-gray-600">Còn hàng <span class="font-semibold text-green-600">(131 cuốn / 12 xuất)</span></span>
                </div>

                <!-- Action Buttons -->
                <div class="flex gap-3 flex-wrap">
                    <button class="flex-1 min-w-[180px] bg-secondary text-primary font-bold text-[15px] px-6 py-3.5 rounded-full hover:scale-[1.02] transition-transform flex items-center justify-center gap-2 shadow-md">
                        <i data-lucide="shopping-cart" class="icon-md"></i> Thêm vào giỏ hàng
                    </button>
                    <button class="flex-1 min-w-[180px] bg-white text-primary font-bold text-[15px] px-6 py-3.5 rounded-full border-2 border-primary hover:bg-primary hover:text-white transition-all flex items-center justify-center gap-2">
                        <i data-lucide="heart" class="icon-md"></i> Thêm vào yêu thích
                    </button>
                </div>

                <!-- Meta Info -->
                <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 pt-4 border-t border-gray-100">
                    <div class="flex flex-col gap-0.5">
                        <span class="text-[11px] text-gray-400 uppercase tracking-wider font-medium">Nhà xuất bản</span>
                        <span class="text-[13px] font-semibold text-on-surface">Grand Central</span>
                    </div>
                    <div class="flex flex-col gap-0.5">
                        <span class="text-[11px] text-gray-400 uppercase tracking-wider font-medium">Số trang</span>
                        <span class="text-[13px] font-semibold text-on-surface">412 trang</span>
                    </div>
                    <div class="flex flex-col gap-0.5">
                        <span class="text-[11px] text-gray-400 uppercase tracking-wider font-medium">Hình thức</span>
                        <span class="text-[13px] font-semibold text-on-surface">Bìa cứng</span>
                    </div>
                    <div class="flex flex-col gap-0.5">
                        <span class="text-[11px] text-gray-400 uppercase tracking-wider font-medium">Mã sách</span>
                        <span class="text-[13px] font-semibold text-on-surface">BT-99221</span>
                    </div>
                </div>

                <!-- Description -->
                <div class="pt-4 border-t border-gray-100">
                    <h3 class="text-[15px] font-bold text-primary mb-3">Mô tả</h3>
                    <p class="text-[14px] text-gray-600 leading-relaxed">
                        "Thư Viện Thì Thầm" là câu chuyện phép thuật bí ẩn về một nữ lưu trữ viên tìm thấy khu vực ẩn giấu trong thư viện cổ nhất thế giới. 
                        Những cuốn sách ở đây không chỉ kể chuyện mà còn đang thực sự sống. Khi ranh giới giữa hiện thực và hư cấu dần lu mờ, cô phải quyết
                        định liệu bí mật của quá khứ có đáng để đánh đổi bằng tương lai. Một tuyệt tác kể chuyện hiện đại hòa quyện giữa chất văn nên thơ và 
                        cốt truyện kịch tính.
                    </p>
                </div>

            </div>
        </div>
    </section>

    <!-- REVIEWS SECTION -->
    <section class="bg-white rounded-xl shadow-sm p-8 mb-8">
        <div class="flex justify-between items-center mb-6">
            <h2 class="section-title-border text-xl font-bold text-primary pl-3">Đánh giá</h2>
            <a href="#" class="text-[13px] text-primary font-medium border border-primary px-3.5 py-1.5 rounded-full hover:bg-primary hover:text-white transition-colors uppercase tracking-tight">Viết nhận xét ✏️</a>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">

            <!-- Review 1 -->
            <div class="bg-[#F9F9F9] rounded-xl p-5 flex flex-col gap-3">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-[14px] font-bold text-on-surface">Marcus Thorne</p>
                        <p class="text-[11px] text-gray-400">93 đánh giá trước</p>
                    </div>
                    <div class="text-[#FDD835] text-sm">★★★★★</div>
                </div>
                <div>
                    <p class="text-[13px] font-semibold text-primary mb-1">Không thể rời mắt!</p>
                    <p class="text-[13px] text-gray-600 leading-relaxed">
                        Không thể bỏ đọc từ những dòng đầu tiên, truyện gì mà đỉnh quá vậy. Ai là fan của thể loại Fantasy nên thử nha.
                    </p>
                </div>
            </div>

            <!-- Review 2 -->
            <div class="bg-[#F9F9F9] rounded-xl p-5 flex flex-col gap-3">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-[14px] font-bold text-on-surface">Sarah J.</p>
                        <p class="text-[11px] text-gray-400">44 đánh giá trước</p>
                    </div>
                    <div class="text-[#FDD835] text-sm">★★★★★</div>
                </div>
                <div>
                    <p class="text-[13px] font-semibold text-primary mb-1">Rất thú vị và xúc động</p>
                    <p class="text-[13px] text-gray-600 leading-relaxed">
                        Rất cảm động, tuy về giữa nhịp truyện có chậm đi nhưng phần kết đã làm rất tốt, rất trọn vẹn.
                    </p>
                </div>
            </div>

            <!-- Review 3 -->
            <div class="bg-[#F9F9F9] rounded-xl p-5 flex flex-col gap-3">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-[14px] font-bold text-on-surface">David Wilson</p>
                        <p class="text-[11px] text-gray-400">201 đánh giá trước</p>
                    </div>
                    <div class="text-[#FDD835] text-sm">★★★★★</div>
                </div>
                <div>
                    <p class="text-[13px] font-semibold text-primary mb-1">Ấn bản rất đẹp</p>
                    <p class="text-[13px] text-gray-600 leading-relaxed">
                        Chất lượng oke quá nè. Sách cầm nặng đã tay ghê, bìa làm cũng đẹp luôn 10 điểm.
                    </p>
                </div>
            </div>

        </div>
    </section>

    <!-- RELATED PRODUCTS -->
    <section class="mb-8">
        <div class="flex justify-between items-center mb-5">
            <h2 class="section-title-border text-xl font-bold text-primary pl-3">Bạn cũng có thể thích</h2>
            <div class="flex gap-2">
                <button id="relatedPrev" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:border-primary hover:text-primary transition-colors cursor-pointer">
                    <i data-lucide="chevron-left" class="icon-sm"></i>
                </button>
                <button id="relatedNext" class="w-8 h-8 rounded-full border border-gray-300 flex items-center justify-center hover:border-primary hover:text-primary transition-colors cursor-pointer">
                    <i data-lucide="chevron-right" class="icon-sm"></i>
                </button>
            </div>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">

            <!-- Related Card 1 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#0d1117] flex items-center justify-center overflow-hidden">
                    <img alt="The Silent Echo" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuD2B7XLtdS0wy7BAE332DkzQUbRUjCucjPE7TUDXTblI-0H9EYtkFVhDetEo41CpskjUGCM0wjW1joZwk6ob3qdina-PJglBbLAyi_AwUpv_g8DPLkt5TSAM-4Ml6b_hBJRVuX7S3ORg60TB69xXxqm7imepXAAmliixlQJdvQndz7N3cJRFB0cdLomr42PqV2er0FhnSNg1q4g94PTFO00fC0zxPAmBV92WYRiyAHF4M3tigIo4-zfcIEiRH6sNAavENUGTVkE88B_">
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=11">The Silent Echo</a>
                    </div>
                    <p class="text-[12px] text-gray-400 mb-2">Julian Reed</p>
                    <div class="text-primary text-[16px] font-bold mt-auto">134.000 đ</div>
                </div>
            </div>

            <!-- Related Card 2 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-gradient-to-br from-[#1a1a2e] to-[#16213e] flex items-center justify-center overflow-hidden">
                    <img alt="Paper Shadows" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuBwLsWcjspRrX6xou1YHJNPsQZax8Ow9uMwo7cE7lQUeiCjtxIt7dR-E6mXUrhy7L5hAfWsskuKKuKWR3ajaGzJI6DY6zw1tDIiIXwF1Z6cRvjnJOTJqigQCkOJ3kHOd8NZt3fJ-_wDOX6FEohrmlQeKpce0KKB3g3zJg_sCX9Acqa3gM9IgfQRCm7jSFOkD0wMsSWdpZuqn5Ly5Wbrw_qAtZD_RaPSVDGyRRU4awDqlGgbPLsLGiCUkp-9uXQbG9eq4WN6TAgEyyac">
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=12">Paper Shadows</a>
                    </div>
                    <p class="text-[12px] text-gray-400 mb-2">Clara Montiel</p>
                    <div class="text-primary text-[16px] font-bold mt-auto">200.000 đ</div>
                </div>
            </div>

            <!-- Related Card 3 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0ebe3] flex items-center justify-center overflow-hidden">
                    <img alt="Midnight Garden" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuAG9j4kQQX3LwAqtjK2ecdJoOseBednAJ8JYFJrrDlaSomp3q5vNexOdPpQdhDiatHWHxpBejRVT5kfasO1oenX_CEcg1dx39FzZg0uHKTnuhcOgyWTeZpmVLxUzE95U7QeXmvteoLViggPE7wBbB4M3XopQGJ1PZagoyUf8nQUDewDwuxP7KDNhZpU3x68IOHrprjmCsiU5RndnD4UNirRw2xowDAQ8Dd5r6MbmhUdPENpPdG0_F-uHL3TP0fufXPqrtC-HT3ofbwK">
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=13">Midnight Garden</a>
                    </div>
                    <p class="text-[12px] text-gray-400 mb-2">Thomas Vane</p>
                    <div class="text-primary text-[16px] font-bold mt-auto">250.000 đ</div>
                </div>
            </div>

            <!-- Related Card 4 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center overflow-hidden">
                    <img alt="Atomic Habits" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuBCQKV1PyUpBNd4gQFmCxXpHplPY2JjHD_OfFMuzmgTMRM1jWI9VC8GjToIujpOtPw8_NXMyY6XPmZrGTsSGJ-na0YCUY2hKGCygjGZkOiqJ_jccfzi5t0f91JHMFH0idrn6G92wSfGkikWHmEvhYjzczmQg-t2gN9bJ2bYCGuVQqKrwQFUnhi5BFCzaL9nRt4XFqkGNFVJV6d4raD1w0fWc_lKS2qKzE9ZaZ6sbgofCFkuSJ00PBJw1KVoX28on8P5BGoFLAotiiVx">
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=14">Kinh Tế Học Hài Hước</a>
                    </div>
                    <p class="text-[12px] text-gray-400 mb-2">Steven D. Levitt</p>
                    <div class="text-primary text-[16px] font-bold mt-auto">225.000 đ</div>
                </div>
            </div>

        </div>
    </section>

</main>

<script>
    // Thumbnail switcher
    document.querySelectorAll('.thumbnail-item').forEach(function(thumb) {
        thumb.addEventListener('click', function() {
            var img = this.querySelector('img');
            if (img) {
                document.getElementById('mainImage').src = img.src;
            }
            document.querySelectorAll('.thumbnail-item').forEach(function(t) {
                t.classList.remove('border-primary');
                t.classList.add('border-gray-200');
            });
            this.classList.remove('border-gray-200');
            this.classList.add('border-primary');
        });
    });
</script>

<%@ include file="/views/layout/homepage/footer.jsp" %>
