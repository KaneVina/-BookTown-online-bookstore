<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/views/layout/homepage/header.jsp" %>
<body class="text-on-background">
    <main class="max-w-[1280px] mx-auto px-4 md:px-16 py-12 min-h-[716px] text-[#071e27]">
        <nav class="flex items-center gap-2 mb-6 text-[#424752] text-sm">
            <a href="${pageContext.request.contextPath}/" class="hover:text-[#004d99] transition-colors" href="#">Trang chủ</a>
            <span class="material-symbols-outlined text-[16px]">/</span>
            <span class="text-[#004d99] font-bold">Giỏ hàng</span>
        </nav>

        <h1 class="text-3xl font-extrabold mb-12 text-[#071e27]">Giỏ hàng của bạn</h1>

        <div class="grid grid-cols-12 gap-6" id="cart-container">
            <div class="col-span-12 lg:col-span-8 space-y-6">

                <div class="bg-white rounded-xl p-6 flex flex-col md:flex-row items-center gap-6 transition-transform duration-200 ease-out hover:-translate-y-0.5 group" style="box-shadow: 0 4px 20px rgba(21, 101, 192, 0.08);">
                    <div class="w-24 h-36 flex-shrink-0 overflow-hidden rounded-lg bg-[#e6f6ff]">
                        <img class="w-full h-full object-cover" alt="Nghệ thuật Tĩnh lặng" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBBrl04a5RRtctxyHeQHAhwvalr6d9UJR5QPlxBKGhC1siFkQOsuLCz0bMPkTeVjBzR13G6FzmdL7LKH8lwPv-dnMZTFKqG5nP_0TPloLml2g1V4Q04im8nIO9vJ7Ps8lXalgivX6A5HgRIyHPhiekiowjt4V6jnq0qWYEsX9j1xHj75hEL5PHWlekSQW7NFGCBTPcwyro7PCl7zdez38Hcx6bnU_D4c9GMc8ZEL_pyVLEd5fQVvw31GURtt6E9UOI1FiQGnICe7-_i"/>
                    </div>
                    <div class="flex-grow space-y-1">
                        <h3 class="text-xl font-bold text-[#004d99]">Nghệ thuật Tĩnh lặng</h3>
                        <p class="text-sm text-[#424752]">Tác giả: Minh An</p>
                        <p class="text-base text-[#004d99] font-bold mt-2">150.000 đ</p>
                    </div>
                    <div class="flex flex-col items-center md:items-end gap-4">
                        <div class="flex items-center border border-[#c2c6d4] rounded-lg overflow-hidden bg-[#e6f6ff]">
                            <button class="px-3 py-1 hover:bg-[#cfe6f2] transition-colors font-bold">-</button>
                            <span class="px-4 py-1 text-base border-x border-[#c2c6d4]">1</span>
                            <button class="px-3 py-1 hover:bg-[#cfe6f2] transition-colors font-bold">+</button>
                        </div>
                        <div class="text-right">
                            <p class="text-xs text-[#424752]">Tạm tính</p>
                            <p class="text-xl font-bold text-[#004d99]">150.000 đ</p>
                        </div>
                        <button class="text-[#D32F2F] hover:bg-[#ffdad6]/20 p-2 rounded-full transition-all duration-200">
                            <span class="material-symbols-outlined"><i data-lucide="trash-2"></i></span>
                        </button>
                    </div>
                </div>

                <div class="bg-white rounded-xl p-6 flex flex-col md:flex-row items-center gap-6 transition-transform duration-200 ease-out hover:-translate-y-0.5 group" style="box-shadow: 0 4px 20px rgba(21, 101, 192, 0.08);">
                    <div class="w-24 h-36 flex-shrink-0 overflow-hidden rounded-lg bg-[#e6f6ff]">
                        <img class="w-full h-full object-cover" alt="Hành trình Tri thức" src="https://lh3.googleusercontent.com/aida-public/AB6AXuAQF5W3kzD3LsnAWQ1ekSLrQfFT7FeQuxH3uefWAkcfKYaFrW7NvZMp369b_WOeIxL5WWfjDDLoHXuoCEIC4x6ju3OPRM0rbGq1_pZLEzhgXlDqtnd6JVeQAuMIqmKB_ANemvICamSztF-_0xqAqnLchiZn0Jot_hXvd6On0Y3zXrKutvkMwIDxGI3JC_bOWYT1v55hBTrKMpesoGYK1yc6lz_Yv9oqwy7rwCzc9fsn32pGBsv9Css_FryOrToGuMKbVa7cU2suLWyn"/>
                    </div>
                    <div class="flex-grow space-y-1">
                        <h3 class="text-xl font-bold text-[#004d99]">Hành trình Tri thức</h3>
                        <p class="text-sm text-[#424752]">Tác giả: GS. Lê Văn Hùng</p>
                        <p class="text-base text-[#004d99] font-bold mt-2">220.000 đ</p>
                    </div>
                    <div class="flex flex-col items-center md:items-end gap-4">
                        <div class="flex items-center border border-[#c2c6d4] rounded-lg overflow-hidden bg-[#e6f6ff]">
                            <button class="px-3 py-1 hover:bg-[#cfe6f2] transition-colors font-bold">-</button>
                            <span class="px-4 py-1 text-base border-x border-[#c2c6d4]">1</span>
                            <button class="px-3 py-1 hover:bg-[#cfe6f2] transition-colors font-bold">+</button>
                        </div>
                        <div class="text-right">
                            <p class="text-xs text-[#424752]">Tạm tính</p>
                            <p class="text-xl font-bold text-[#004d99]">220.000 đ</p>
                        </div>
                        <button class="text-[#D32F2F] hover:bg-[#ffdad6]/20 p-2 rounded-full transition-all duration-200">
                            <span class="material-symbols-outlined"><i data-lucide="trash-2"></i></span>
                        </button>
                    </div>
                </div>

                <div class="hidden flex-col items-center justify-center py-12 space-y-6" id="empty-cart">
                    <p class="text-2xl text-[#424752]">Giỏ hàng của bạn đang trống</p>
                </div>
            </div>

            <div class="col-span-12 lg:col-span-4">
                <div class="bg-white rounded-xl p-8 sticky top-24 space-y-6" style="box-shadow: 0 4px 20px rgba(21, 101, 192, 0.08);">
                    <h2 class="text-2xl font-bold text-[#071e27] border-b border-[#c2c6d4] pb-4">Tóm tắt đơn hàng</h2>
                    <div class="space-y-4">
                        <div class="flex justify-between items-center text-base">
                            <span class="text-[#424752]">Tạm tính</span>
                            <span class="font-semibold">370.000 đ</span>
                        </div>
                        <div class="flex justify-between items-center text-base">
                            <span class="text-[#424752]">Phí vận chuyển</span>
                            <span class="font-semibold">30.000 đ</span>
                        </div>
                        <div class="flex justify-between items-center text-base text-[#2E7D32]">
                            <span class="font-medium">Giảm giá voucher</span>
                            <span class="font-semibold">- 0 đ</span>
                        </div>
                    </div>
                    <div class="space-y-3">
                        <label class="block text-sm text-[#424752]">Mã giảm giá</label>
                        <div class="flex gap-2">
                            <input class="flex-grow bg-[#f3faff] border border-[#c2c6d4] rounded-lg px-4 py-2 focus:ring-[#004d99] focus:border-[#004d99]" placeholder="Nhập mã voucher" type="text"/>
                            <button class="bg-[#1565c0] text-[#dae5ff] px-4 py-2 rounded-lg font-medium hover:brightness-95 transition-all">Áp dụng</button>
                        </div>
                    </div>
                    <div class="border-t border-[#c2c6d4] pt-6">
                        <div class="flex justify-between items-end mb-8">
                            <span class="text-xl font-bold text-[#071e27]">Tổng cộng</span>
                            <div class="text-right">
                                <p class="text-[#004d99] font-extrabold text-3xl">400.000 đ</p>
                                <p class="text-xs text-[#424752]">(Đã bao gồm VAT)</p>
                            </div>
                        </div>
                        <div>
                            <a href="${pageContext.request.contextPath}/checkout" 
                               <button class="w-full bg-[#fdd835] hover:bg-[#e8c41d] text-[#705e00] py-4 rounded-xl font-bold text-xl shadow-md hover:shadow-lg transition-all duration-200 flex items-center justify-center gap-3 active:scale-95">
                                    Thanh toán ngay
                                    <span class="material-symbols-outlined"><i data-lucide="move-right"></i></span>
                                </button>
                            </a>
                        </div>
                    </div>
                    <div class="pt-4 flex items-center gap-2 justify-center text-[#424752] text-xs opacity-60">
                        <span class="material-symbols-outlined text-[16px]"><i data-lucide="shield-check"></i>  </span>
                        Thanh toán an toàn & bảo mật 100%
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
    </script>
</body>
<%@ include file="/views/layout/homepage/footer.jsp" %>
