<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- FOOTER -->
<footer class="bg-primary text-white py-12">
    <div class="max-w-[1400px] mx-auto px-8">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
            <div class="md:col-span-1">
                <img src="${pageContext.request.contextPath}/assets/images/logo/logoBT_1.png"
                     alt="BookTown Logo" class="w-[120px] mb-2.5"/>
                <div class="text-[13px] opacity-75 leading-relaxed">Hệ thống nhà sách trực tuyến uy tín hàng đầu Việt Nam. Cam kết sách chính hãng, giao hàng nhanh, đổi trả dễ dàng.</div>
            </div>
            <div>
                <div class="text-secondary font-bold text-[15px] mb-3.5">Về BookTown</div>
                <ul class="flex flex-col gap-2 text-[13px]">
                    <li><a class="text-white/75 hover:text-secondary" href="#">Giới thiệu</a></li>
                    <li><a class="text-white/75 hover:text-secondary" href="#">Tuyển dụng</a></li>
                    <li><a class="text-white/75 hover:text-secondary" href="#">Hệ thống cửa hàng</a></li>
                    <li><a class="text-white/75 hover:text-secondary" href="#">Chính sách bảo mật</a></li>
                </ul>
            </div>
            <div>
                <div class="text-secondary font-bold text-[15px] mb-3.5">Hỗ trợ</div>
                <ul class="flex flex-col gap-2 text-[13px]">
                    <li><a class="text-white/75 hover:text-secondary" href="#">Hướng dẫn mua hàng</a></li>
                    <li><a class="text-white/75 hover:text-secondary" href="#">Tra cứu đơn hàng</a></li>
                    <li><a class="text-white/75 hover:text-secondary" href="#">Đổi trả – Hoàn tiền</a></li>
                    <li><a class="text-white/75 hover:text-secondary" href="#">Trung tâm trợ giúp</a></li>
                </ul>
            </div>
            <div>
                <div class="text-secondary font-bold text-[15px] mb-3.5">Liên hệ</div>
                <ul class="flex flex-col gap-2 text-[13px]">
                    <li class="flex items-center gap-2"><i data-lucide="phone" class="icon-sm"></i> 19006656</li>
                    <li class="flex items-center gap-2"><i data-lucide="mail" class="icon-sm"></i> support@booktown.vn</li>
                    <li class="flex items-center gap-2"><i data-lucide="map-pin" class="icon-sm"></i> Cần Thơ, Việt Nam</li>
                </ul>
            </div>
        </div>
        <div class="pt-6 border-t border-white/15 text-center text-xs opacity-60">
            © 2026 BookTown. Tất cả quyền được bảo lưu.
        </div>
    </div>
</footer>

<!-- FAB scroll to top -->
<button class="fixed bottom-8 right-8 w-14 h-14 bg-primary text-white rounded-full shadow-lg flex items-center justify-center hover:scale-110 transition-all opacity-0 pointer-events-none z-[100]" id="scrollToTop">
    <i data-lucide="arrow-up" class="icon-lg"></i>
</button>

<!-- Lucide icons -->
<script src="${pageContext.request.contextPath}/assets/js/lucide.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

</body>
</html>
