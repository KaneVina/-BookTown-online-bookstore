<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%@ include file="/views/layout/homepage/header.jsp" %>

<!-- HERO -->
<section class="hero-gradient px-8 py-8 flex items-center justify-between min-h-[240px] relative overflow-hidden">
    <div class="absolute right-[280px] top-[-40px] w-[300px] h-[300px] rounded-full border-[60px] border-white/5 pointer-events-none"></div>
    <div class="absolute right-[200px] bottom-[-80px] w-[200px] h-[200px] rounded-full border-[40px] border-white/5 pointer-events-none"></div>

    <div class="relative z-10 max-w-2xl">
        <div class="bg-secondary text-primary font-bold text-xs px-3 py-1 rounded-full inline-block mb-3 tracking-wide uppercase">✨ Kho sách #1 Việt Nam</div>
        <h1 class="text-white text-[38px] font-black leading-[1.15] mb-3">
            Khám phá <em class="text-secondary not-italic">thế giới</em><br>qua từng trang sách
        </h1>
        <p class="text-white/80 text-sm mb-5 max-w-[420px]">
            Hơn 50.000 đầu sách chính hãng – Văn học, kinh tế, kỹ năng, thiếu nhi. Giao hàng nhanh toàn quốc.
        </p>
        <div class="flex gap-3">
            <button class="bg-secondary text-primary font-bold text-sm px-6 py-2.5 rounded-full hover:scale-105 transition-transform flex items-center gap-2">
                <i data-lucide="shopping-cart" class="icon-md"></i> Mua ngay
            </button>
            <button class="bg-transparent text-white font-medium text-sm px-6 py-2.5 border-2 border-white/50 rounded-full hover:border-white transition-all flex items-center gap-2">
                Xem danh mục <i data-lucide="arrow-right" class="icon-md"></i>
            </button>
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

<!-- STATS BAR -->
<section class="bg-white grid grid-cols-2 md:grid-cols-4 border-b-2 border-gray-200">
    <div class="flex items-center gap-3 px-6 py-4 border-r border-gray-100">
        <span class="text-3xl">📦</span>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">50.000+</strong>
            <span class="text-xs text-gray-500">Đầu sách có sẵn</span>
        </div>
    </div>
    <div class="flex items-center gap-3 px-6 py-4 border-r border-gray-100">
        <span class="text-3xl">🚚</span>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">Miễn phí ship</strong>
            <span class="text-xs text-gray-500">Đơn từ 299.000đ</span>
        </div>
    </div>
    <div class="flex items-center gap-3 px-6 py-4 border-r border-gray-100">
        <span class="text-3xl">✅</span>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">Chính hãng 100%</strong>
            <span class="text-xs text-gray-500">Cam kết từ nhà xuất bản</span>
        </div>
    </div>
    <div class="flex items-center gap-3 px-6 py-4">
        <span class="text-3xl">🔁</span>
        <div class="flex flex-col">
            <strong class="text-[15px] font-bold text-primary leading-tight">Đổi trả 7 ngày</strong>
            <span class="text-xs text-gray-500">Không cần lý do</span>
        </div>
    </div>
</section>

<main class="max-w-[1400px] mx-auto px-8 py-7">

    <!-- BESTSELLERS -->
    <section class="mb-12">
        <div class="flex justify-between items-center mb-5">
            <h2 class="section-title-border text-xl font-bold text-primary pl-3">🔥 Sách Bán Chạy</h2>
            <span class="text-[13px] text-primary font-medium border border-primary px-3.5 py-1.5 rounded-full cursor-pointer hover:bg-primary hover:text-white transition-colors uppercase tracking-tight">Xem tất cả</span>
        </div>

        <div class="flex flex-wrap gap-2.5 mb-6">
            <div class="bg-primary text-white border border-primary px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer shadow-sm">📚 Tất cả</div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all">✍️ Văn học</div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all">💼 Kinh tế</div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all">🧠 Kỹ năng</div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all">🧒 Thiếu nhi</div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all">🔬 Khoa học</div>
            <div class="bg-white text-on-surface border border-gray-300 px-4 py-1.5 rounded-full text-[13px] font-medium cursor-pointer hover:bg-primary hover:text-white hover:border-primary transition-all">🌏 Lịch sử</div>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">

            <!-- Card 1 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <img alt="Book cover" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuDL5DNrhpxC3JYzAsW2vU0LqbHPMKfXPDTo3fZabcjsD-rEiAPPWHd58yhwx4U1kao71thxMgXkTTOH4WSJVhpYYhFIl_wewZWt7FNJSFcbib4hyW50DQecRHOV-1DoMMPtvtU2ztEJ_bJJhWcqqRnIMuYlBwqgIwZhT6mdG7aZ6tPXEfDROSLA97_xBrDEa-W20d1F8G8QaH9TKNsqWQ7BrUl9UrZDHRNqB-qRg1OwDTJQ7zEoUKdWLQI-1quNYmUOgn9zdaUt_ouA">
                    <div class="absolute top-2.5 left-2.5 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">🔥 Hot</div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=1">Lược Sử Loài Người - Yuval Noah Harari</a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        ★★★★★ <span class="text-gray-400 text-[11px]">(1.240)</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">
                        156.000đ <span class="text-gray-400 text-xs font-normal line-through ml-1.5">195.000đ</span>
                    </div>
                    <button class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </button>
                </div>
            </div>

            <!-- Card 2 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <img alt="Book cover" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuA1ZQXa2zKsAKBIygOkn7Re38a9RzeX3GWtOkjniy_b625r6eFLLHCCHqwRKf_uxN7km3eTGjrEG6Vrb0tv1mSMdHJlsrVfl8xEW6O_8r7SjSVVaBUgZzOeh04Lrlwom5VcezUGcqE8pdoNuseDxHvL_JMqPAO9CZjIML2AUl8mm62ImYnhTSI8Ztf1p-UndinbhWT_Ik9xPq5QUYr3PGfV3-vVKdx-VwayBNcZb_BJFx0XLwY2QtKHqrefpARqzplvsa3xn_U29OvN">
                    <div class="absolute top-2.5 left-2.5 bg-[#E53935] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">👍 New</div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=2">Nhà Giả Kim - Paulo Coelho</a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        ★★★★★ <span class="text-gray-400 text-[11px]">(980)</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">89.000đ</div>
                    <button class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </button>
                </div>
            </div>

            <!-- Card 3 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <img alt="Book cover" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuBCQKV1PyUpBNd4gQFmCxXpHplPY2JjHD_OfFMuzmgTMRM1jWI9VC8GjToIujpOtPw8_NXMyY6XPmZrGTsSGJ-na0YCUY2hKGCygjGZkOiqJ_jccfzi5t0f91JHMFH0idrn6G92wSfGkikWHmEvhYjzczmQg-t2gN9bJ2bYCGuVQqKrwQFUnhi5BFCzaL9nRt4XFqkGNFVJV6d4raD1w0fWc_lKS2qKzE9ZaZ6sbgofCFkuSJ00PBJw1KVoX28on8P5BGoFLAotiiVx">
                    <div class="absolute top-2.5 left-2.5 bg-[#FB8C00] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">🏷️ -20%</div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=3">Kinh Tế Học Hài Hước - Steven D. Levitt</a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        ★★★★★ <span class="text-gray-400 text-[11px]">(2.100)</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">225.000đ</div>
                    <button class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </button>
                </div>
            </div>

            <!-- Card 4 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <img alt="Book cover" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuD2B7XLtdS0wy7BAE332DkzQUbRUjCucjPE7TUDXTblI-0H9EYtkFVhDetEo41CpskjUGCM0wjW1joZwk6ob3qdina-PJglBbLAyi_AwUpv_g8DPLkt5TSAM-4Ml6b_hBJRVuX7S3ORg60TB69xXxqm7imepXAAmliixlQJdvQndz7N3cJRFB0cdLomr42PqV2er0FhnSNg1q4g94PTFO00fC0zxPAmBV92WYRiyAHF4M3tigIo4-zfcIEiRH6sNAavENUGTVkE88B_">
                    <div class="absolute top-2.5 left-2.5 bg-[#8E24AA] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">🔥 Hot</div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=4">Muôn Kiếp Nhân Sinh - Nguyên Phong</a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        ★★★★★ <span class="text-gray-400 text-[11px]">(875)</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">188.000đ</div>
                    <button class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </button>
                </div>
            </div>

            <!-- Card 5 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <img alt="Book cover" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuBwLsWcjspRrX6xou1YHJNPsQZax8Ow9uMwo7cE7lQUeiCjtxIt7dR-E6mXUrhy7L5hAfWsskuKKuKWR3ajaGzJI6DY6zw1tDIiIXwF1Z6cRvjnJOTJqigQCkOJ3kHOd8NZt3fJ-_wDOX6FEohrmlQeKpce0KKB3g3zJg_sCX9Acqa3gM9IgfQRCm7jSFOkD0wMsSWdpZuqn5Ly5Wbrw_qAtZD_RaPSVDGyRRU4awDqlGgbPLsLGiCUkp-9uXQbG9eq4WN6TAgEyyac">
                    <div class="absolute top-2.5 left-2.5 bg-[#FB8C00] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">🏷️ -15%</div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=5">One Piece - Tập 101 - Eiichiro Oda</a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        ★★★★★ <span class="text-gray-400 text-[11px]">(1.560)</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">
                        21.000đ <span class="text-gray-400 text-xs font-normal line-through ml-1.5">25.000đ</span>
                    </div>
                    <button class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </button>
                </div>
            </div>

        </div>
    </section>

    <!-- PROMO BANNERS -->
    <section class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-12">
        <div class="rounded-lg h-[120px] flex flex-col items-center justify-center font-bold text-lg text-white p-4 text-center cursor-pointer hover:scale-[1.02] transition-transform bg-gradient-to-br from-primary to-primary-dark">
            📚 Sách Kỹ Năng<br><span class="text-[13px] opacity-80 font-normal">Giảm đến 40%</span>
        </div>
        <div class="rounded-lg h-[120px] flex flex-col items-center justify-center font-bold text-lg text-white p-4 text-center cursor-pointer hover:scale-[1.02] transition-transform bg-gradient-to-br from-[#E53935] to-[#B71C1C]">
            🎁 Quà Tặng Ý Nghĩa<br><span class="text-[13px] opacity-80 font-normal">Gói quà miễn phí</span>
        </div>
        <div class="rounded-lg h-[120px] flex flex-col items-center justify-center font-bold text-lg text-white p-4 text-center cursor-pointer hover:scale-[1.02] transition-transform bg-gradient-to-br from-[#F57F17] to-[#E65100]">
            🚀 Sách Mới Nhất<br><span class="text-[13px] opacity-80 font-normal">Cập nhật mỗi tuần</span>
        </div>
    </section>

    <!-- NEW ARRIVALS -->
    <section class="mb-12">
        <div class="flex justify-between items-center mb-5">
            <h2 class="section-title-border text-xl font-bold text-primary pl-3">🆕 Sách Mới Về</h2>
            <span class="text-[13px] text-primary font-medium border border-primary px-3.5 py-1.5 rounded-full cursor-pointer hover:bg-primary hover:text-white transition-colors uppercase tracking-tight">Xem tất cả</span>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4">

            <!-- Arrival 1 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <img alt="Book cover" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuBYZn0G898rGsRNjqKMDfcw2DeIUbBzWKEfBC17FtB9kLNhkHqBn6SxObR1s-D01LiltlZlXo_lLdZ081Evb0G1RnCa0rmXHkBfGBmm_MBhiRZzHFcKBv1b1xAcoBcGyPje2eDaaKUE6FmZZLNL0JR_6eHdVcui4k0QQQxXMg31q4CcubkL4dnr5CpCG3lrPpzjNoWa4V0mt42PhymHEqLox60kxz9Ubnnr6O_ivf1I_GFTDhihusQEHqGrf-EfJuWOw9esdjhdMqCI">
                    <div class="absolute top-2.5 left-2.5 bg-[#E53935] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">👍 New</div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=6">Tâm Lý Học Về Tiền - Morgan Housel</a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        ★★★★★ <span class="text-gray-400 text-[11px]">(0)</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">145.000đ</div>
                    <button class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </button>
                </div>
            </div>

            <!-- Arrival 2 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <img alt="Book cover" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuDLpeq1y2nUHWByaMqR26eH_13lnomIO3s0dboXH0TyxELa-FcZkCX9iWcWpInVR4ZY-zLKr1n_o8WOhxPHVTv-UZMp053czMx0t6dDkDXXs46Jpd0S7YpDQghqN7DXtIHPIFocxFbWcheIw0Rmw4VsobV41bCy_ts3A5Z4l7B-HqAVaXAfWLABA6zmAjRCfACWXSNApQocvcsQjxvfY-wH4hRSSeP_kWWaG-F0YJA3ztw6Iajg514_y4KLD-Hzu6TB2w4ekxkkf9ZV">
                    <div class="absolute top-2.5 left-2.5 bg-[#E53935] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">👍 New</div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=7">Phía Sau Nghi Can X - Higashino Keigo</a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        ★★★★★ <span class="text-gray-400 text-[11px]">(12)</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">112.000đ</div>
                    <button class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </button>
                </div>
            </div>

            <!-- Arrival 3 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <img alt="Book cover" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuAq8GZju_7_XRWTEIgtQItR-uKfARYvGRemwW5KN9bJ9acvJbY_vVSL7rN8kWfJzytI-t0698Cvz7U3iBax1985HnikptWOed9wjG1JVPLWtwaQOtnSa3GjZfRZldv8EmWFb9m2JWFeINbpwY6MculeuviR6eIHxXcwDUUu2V9fAxu9lIu9Ywb63v-v_FXFnOh4Sh23MnFwwoGEi72nAB9eoj1U2xl5cKQfeneO2UKC_fe0G7VBfTkF8Y1YLHZv22FdZ4F1HxhXL7m6">
                    <div class="absolute top-2.5 left-2.5 bg-[#E53935] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">👍 New</div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=8">Hành Trình Về Phương Đông - Baird T. Spalding</a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        ★★★★★ <span class="text-gray-400 text-[11px]">(8)</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">95.000đ</div>
                    <button class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </button>
                </div>
            </div>

            <!-- Arrival 4 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <img alt="Book cover" class="w-full h-full object-cover"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuAG9j4kQQX3LwAqtjK2ecdJoOseBednAJ8JYFJrrDlaSomp3q5vNexOdPpQdhDiatHWHxpBejRVT5kfasO1oenX_CEcg1dx39FzZg0uHKTnuhcOgyWTeZpmVLxUzE95U7QeXmvteoLViggPE7wBbB4M3XopQGJ1PZagoyUf8nQUDewDwuxP7KDNhZpU3x68IOHrprjmCsiU5RndnD4UNirRw2xowDAQ8Dd5r6MbmhUdPENpPdG0_F-uHL3TP0fufXPqrtC-HT3ofbwK">
                    <div class="absolute top-2.5 left-2.5 bg-[#E53935] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">👍 New</div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=9">Vũ Trụ - Carl Sagan</a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        ★★★★★ <span class="text-gray-400 text-[11px]">(5)</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">245.000đ</div>
                    <button class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </button>
                </div>
            </div>

            <!-- Arrival 5 -->
            <div class="prod-card-hover bg-white rounded-lg overflow-hidden cursor-pointer flex flex-col">
                <div class="relative aspect-[3/4] bg-[#f0f4ff] flex items-center justify-center">
                    <i data-lucide="notebook" class="w-16 h-16 text-gray-300"></i>
                    <div class="absolute top-2.5 left-2.5 bg-[#E53935] text-white text-[11px] font-bold px-2.5 py-0.5 rounded-full flex items-center gap-1">👍 New</div>
                </div>
                <div class="p-3 flex flex-col flex-1">
                    <div class="text-[13px] font-medium text-on-surface mb-1.5 line-clamp-2 min-h-[36px]">
                        <a class="text-primary hover:underline" href="${pageContext.request.contextPath}/products?id=10">Đắc Nhân Tâm – Bìa Cứng Đặc Biệt</a>
                    </div>
                    <div class="text-[#FDD835] text-[12px] mb-1.5 flex items-center gap-1">
                        ★★★★★ <span class="text-gray-400 text-[11px]">(3)</span>
                    </div>
                    <div class="text-primary text-[17px] font-bold mb-2.5">58.000đ</div>
                    <button class="mt-auto w-full bg-primary text-white rounded-md py-2.5 text-[13px] font-bold flex items-center justify-center gap-2 hover:bg-primary-dark transition-colors tracking-wide">
                        <i data-lucide="eye" class="icon-sm"></i> XEM NHANH
                    </button>
                </div>
            </div>

        </div>
    </section>

</main>

<%@ include file="/views/layout/homepage/footer.jsp" %>
