<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8">
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <title>Đăng ký thành viên | BookTown</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "surface-dim": "#c7dde9",
                            "tertiary": "#134aa4",
                            "error": "#D32F2F",
                            "primary-fixed": "#d6e3ff",
                            "secondary": "#705d00",
                            "surface-container-high": "#d5ecf8",
                            "on-primary": "#ffffff",
                            "outline": "#727783",
                            "on-surface-variant": "#424752",
                            "on-error-container": "#93000a",
                            "on-tertiary": "#ffffff",
                            "on-secondary": "#ffffff",
                            "on-primary-container": "#dae5ff",
                            "surface": "#FFFFFF",
                            "surface-container": "#dbf1fe",
                            "on-background": "#071e27",
                            "warning": "#FFA000",
                            "surface-container-low": "#e6f6ff",
                            "surface-bright": "#f3faff",
                            "primary-container": "#1565c0",
                            "primary": "#004d99",
                            "on-surface": "#071e27",
                            "background": "#f3faff",
                            "surface-variant": "#cfe6f2",
                            "secondary-container": "#fdd835",
                            "surface-container-lowest": "#ffffff",
                            "success": "#2E7D32",
                            "outline-variant": "#c2c6d4",
                            "error-container": "#ffdad6"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "stack-sm": "12px",
                            "margin-mobile": "16px",
                            "margin-desktop": "64px",
                            "base": "8px",
                            "stack-md": "24px",
                            "stack-lg": "48px",
                            "gutter": "24px"
                        },
                        "fontFamily": {
                            "headline-xl": ["Inter"],
                            "headline-sm": ["Inter"],
                            "headline-lg": ["Inter"],
                            "body-md": ["Inter"],
                            "body-lg": ["Inter"],
                            "headline-lg-mobile": ["Inter"],
                            "body-sm": ["Inter"],
                            "headline-md": ["Inter"],
                            "label-sm": ["Inter"],
                            "label-md": ["Inter"]
                        },
                        "fontSize": {
                            "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                            "headline-sm": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                            "headline-lg": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}],
                            "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                            "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                            "headline-lg-mobile": ["28px", {"lineHeight": "36px", "fontWeight": "700"}],
                            "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                            "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                            "label-sm": ["12px", {"lineHeight": "16px", "fontWeight": "500"}],
                            "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.01em", "fontWeight": "600"}]
                        }
                    },
                },
            }
        </script>
        <style>
            body {
                font-family: 'Inter', sans-serif;
                background-color: #f3faff;
            }
            .material-symbols-outlined {
                font-variation-settings: 'FILL' 0, 'wght' 400, 'GRAD' 0, 'opsz' 24;
                vertical-align: middle;
            }
            .login-card-shadow {
                box-shadow: 0 10px 25px -5px rgba(21, 101, 192, 0.08), 0 8px 10px -6px rgba(21, 101, 192, 0.08);
            }
        </style>
    </head>
    <body class="min-h-screen flex flex-col">

        <header class="w-full px-4 md:px-margin-desktop h-16 flex items-center justify-between bg-transparent">
            <div class="font-bold text-primary">
                <img src="${pageContext.request.contextPath}/assets/images/logo/logoBT_2.png" alt="BookTown Logo" class="w-[220px] mb-3"/>
            </div>
            <div class="flex items-center gap-2 text-on-surface-variant text-sm">
                <span class="material-symbols-outlined text-primary">help_outline</span>
                <span class="hidden md:inline">Trợ giúp</span>
            </div>
        </header>

        <main class="flex-grow flex items-center justify-center px-4 py-stack-lg">
            <div class="w-full max-w-[1100px] grid md:grid-cols-2 bg-surface rounded-[32px] overflow-hidden login-card-shadow">

                <%-- Form bên trái --%>
                <div class="p-8 md:p-12 flex flex-col justify-center order-2 md:order-1">
                    <div class="mb-6 text-center md:text-left">
                        <h1 class="font-headline-lg-mobile md:font-headline-lg text-headline-lg-mobile md:text-headline-lg text-on-surface mb-2">Tạo tài khoản mới</h1>
                        <p class="font-body-md text-body-md text-on-surface-variant">Vui lòng điền đầy đủ thông tin để tham gia BookTown.</p>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="mb-4 p-4 bg-error-container text-on-error-container border-l-4 border-error font-body-sm text-body-sm rounded-lg flex items-center gap-2">
                            <span class="material-symbols-outlined text-error">error</span>
                            <span>${errorMessage}</span>
                        </div>
                    </c:if>

                    <form id="registerForm" class="space-y-stack-md" action="${pageContext.request.contextPath}/register" method="POST" novalidate>

                        <%-- Họ và tên --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="fullname">Họ và tên</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">person</span>
                                <input class="w-full pl-10 pr-4 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="fullname" name="fullname" placeholder="Nguyễn Văn A" type="text">
                            </div>
                            <p class="text-error font-body-sm text-body-sm hidden input-error-msg" id="err-fullname"></p>
                        </div>

                        <%-- Email --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="email">Email</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">mail</span>
                                <input class="w-full pl-10 pr-4 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="email" name="email" placeholder="ten@email.com" type="email">
                            </div>
                            <p class="text-error font-body-sm text-body-sm hidden input-error-msg" id="err-email"></p>
                        </div>

                        <%-- Số điện thoại --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="phone">Số điện thoại</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">call</span>
                                <input class="w-full pl-10 pr-4 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="phone" name="phone" placeholder="0912345678" type="tel">
                            </div>
                            <p class="text-error font-body-sm text-body-sm hidden input-error-msg" id="err-phone"></p>
                        </div>

                        <%-- Mật khẩu --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="password">Mật khẩu</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">lock</span>
                                <input class="w-full pl-10 pr-12 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="password" name="password" placeholder="••••••••" type="password">
                                <button class="absolute right-3 top-1/2 -translate-y-1/2 text-outline hover:text-primary transition-colors togglePasswordBtn" type="button" data-target="password">
                                    <span class="material-symbols-outlined">visibility</span>
                                </button>
                            </div>
                            <p class="text-error font-body-sm text-body-sm hidden input-error-msg" id="err-password"></p>
                        </div>

                        <%-- Xác nhận mật khẩu --%>
                        <div class="space-y-2">
                            <label class="font-label-md text-label-md text-on-surface" for="confirmPassword">Xác nhận mật khẩu</label>
                            <div class="relative">
                                <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-outline">enhanced_encryption</span>
                                <input class="w-full pl-10 pr-12 py-3 bg-surface border border-outline-variant rounded-lg focus:ring-2 focus:ring-primary focus:border-primary transition-all font-body-md text-body-md outline-none"
                                       id="confirmPassword" name="confirmPassword" placeholder="••••••••" type="password">
                                <button class="absolute right-3 top-1/2 -translate-y-1/2 text-outline hover:text-primary transition-colors togglePasswordBtn" type="button" data-target="confirmPassword">
                                    <span class="material-symbols-outlined">visibility</span>
                                </button>
                            </div>
                            <p class="text-error font-body-sm text-body-sm hidden input-error-msg" id="err-confirm"></p>
                        </div>

                        <button class="w-full py-4 bg-primary text-on-primary font-headline-sm text-headline-sm rounded-lg hover:bg-primary-container active:opacity-80 transition-all shadow-md mt-4" type="submit">
                            Đăng ký ngay
                        </button>
                    </form>

                    <p class="mt-stack-lg text-center font-body-md text-body-md text-on-surface-variant">
                        Đã có tài khoản?
                        <a class="text-primary font-bold hover:underline transition-all" href="${pageContext.request.contextPath}/login">Đăng nhập</a>
                    </p>
                </div>

                <%-- Ảnh bên phải --%>
                <div class="relative hidden md:block overflow-hidden bg-primary-container order-1 md:order-2">
                    <img alt="Thư viện hiện đại" class="absolute inset-0 w-full h-full object-cover mix-blend-overlay opacity-60"
                         src="https://lh3.googleusercontent.com/aida-public/AB6AXuA4wVc1Ts1NhWSFAjgUkkPPMo_QKOzJ9i1P-RJTZFOE8KjmheXWTqDtoNEoySdXCVnzZeasVx_mA7ojf2ItOK7GN4YWadNAbJRtx9LIAn1GkwYKWHVWn9z1hUeeSNnr1I3DBgVIsoG8cXOchKQBXDJJE8btanB4WvyhkKXSU48lCzGxkmKSTtiO4SAV6mLExsHZIZAQ1BhsqqUQ2AUiTsh9q_9QnVAlbHJRUjRlh575NNY1mxOwYWafrW_fKk8jrqJQWMeV6BvD2oPo">
                    <div class="relative z-10 h-full flex flex-col justify-end p-12 text-on-primary">
                        <h2 class="font-headline-lg text-headline-lg mb-4">Khởi đầu hành trình tri thức mới.</h2>
                        <p class="font-body-lg text-body-lg opacity-90 max-w-md">
                            Tạo tài khoản ngay hôm nay để nhận được những gợi ý sách cá nhân hóa, lưu trữ và xây dựng kho sách yêu thích của riêng bạn.
                        </p>
                        <div class="mt-8 flex gap-2">
                            <div class="w-2 h-2 rounded-full bg-white/40"></div>
                            <div class="w-2 h-2 rounded-full bg-white"></div>
                            <div class="w-2 h-2 rounded-full bg-white/40"></div>
                        </div>
                    </div>
                </div>

            </div>
        </main>

        <footer class="flex flex-col md:flex-row justify-between items-center w-full px-4 md:px-margin-desktop py-stack-md gap-4 bg-surface-container-low mt-auto">
            <img src="${pageContext.request.contextPath}/assets/images/logo/logoBT_2.png" alt="BookTown Logo" class="w-[220px] mb-3"/>
            <div class="flex gap-6 text-on-surface-variant">
                <a class="font-body-sm text-body-sm hover:text-primary transition-colors" href="#">Điều khoản sử dụng</a>
                <a class="font-body-sm text-body-sm hover:text-primary transition-colors" href="#">Chính sách bảo mật</a>
                <a class="font-body-sm text-body-sm hover:text-primary transition-colors" href="#">Liên hệ</a>
            </div>
            <div class="font-label-sm text-label-sm text-on-surface-variant">© 2026 BookTown. Tất cả quyền được bảo lưu.</div>
        </footer>

        <script>
            // Bật/tắt hiện mật khẩu
            document.querySelectorAll('.togglePasswordBtn').forEach(button => {
                button.addEventListener('click', function () {
                    const targetInput = document.getElementById(this.getAttribute('data-target'));
                    const icon = this.querySelector('span');
                    if (targetInput.type === 'password') {
                        targetInput.type = 'text';
                        icon.innerText = 'visibility_off';
                    } else {
                        targetInput.type = 'password';
                        icon.innerText = 'visibility';
                    }
                });
            });

            // Validation phía client
            document.getElementById('registerForm').addEventListener('submit', function (e) {
                let isValid = true;

                const fullname        = document.getElementById('fullname');
                const email           = document.getElementById('email');
                const phone           = document.getElementById('phone');
                const password        = document.getElementById('password');
                const confirmPassword = document.getElementById('confirmPassword');

                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                const phoneRegex = /^(0[35789])\d{8}$/;

                // Xóa lỗi cũ
                document.querySelectorAll('.input-error-msg').forEach(el => el.classList.add('hidden'));

                if (!fullname.value.trim()) {
                    showError('err-fullname', "Họ và tên không được để trống.");
                    isValid = false;
                }
                if (!email.value.trim()) {
                    showError('err-email', "Email không được để trống.");
                    isValid = false;
                } else if (!emailRegex.test(email.value.trim())) {
                    showError('err-email', "Định dạng Email không hợp lệ.");
                    isValid = false;
                }
                if (!phone.value.trim()) {
                    showError('err-phone', "Số điện thoại không được để trống.");
                    isValid = false;
                } else if (!phoneRegex.test(phone.value.trim())) {
                    showError('err-phone', "Số điện thoại không đúng định dạng (10 số, bắt đầu 03/05/07/08/09).");
                    isValid = false;
                }
                if (!password.value) {
                    showError('err-password', "Mật khẩu không được để trống.");
                    isValid = false;
                } else if (password.value.length < 6) {
                    showError('err-password', "Mật khẩu phải tối thiểu 6 ký tự.");
                    isValid = false;
                }
                if (!confirmPassword.value) {
                    showError('err-confirm', "Vui lòng nhập lại mật khẩu xác nhận.");
                    isValid = false;
                } else if (password.value !== confirmPassword.value) {
                    showError('err-confirm', "Mật khẩu xác nhận không khớp.");
                    isValid = false;
                }

                if (!isValid) e.preventDefault();
            });

            function showError(id, msg) {
                const el = document.getElementById(id);
                if (el) {
                    el.innerText = msg;
                    el.classList.remove('hidden');
                }
            }
        </script>
    </body>
</html>
