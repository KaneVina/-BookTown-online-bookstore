<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html class="light" lang="vi">
    <head>
        <meta charset="utf-8"/>
        <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
        <title>Luminous Library - Quản lý Đánh giá</title>
        <script src="https://cdn.tailwindcss.com?plugins=forms,container-queries"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
        <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet"/>
        <script id="tailwind-config">
            tailwind.config = {
                darkMode: "class",
                theme: {
                    extend: {
                        "colors": {
                            "inverse-primary": "#a9c7ff",
                            "surface-bright": "#f3faff",
                            "on-error": "#ffffff",
                            "tertiary-fixed": "#d9e2ff",
                            "on-tertiary-fixed": "#001945",
                            "tertiary": "#134aa4",
                            "error": "#D32F2F",
                            "secondary": "#705d00",
                            "surface-container-highest": "#cfe6f2",
                            "inverse-on-surface": "#dff4ff",
                            "secondary-fixed": "#ffe16e",
                            "surface": "#FFFFFF",
                            "on-tertiary-container": "#dde5ff",
                            "background": "#f3faff",
                            "secondary-fixed-dim": "#e8c41d",
                            "primary-container": "#1565c0",
                            "on-secondary": "#ffffff",
                            "on-secondary-fixed": "#221b00",
                            "tertiary-fixed-dim": "#b0c6ff",
                            "primary-fixed": "#d6e3ff",
                            "on-background": "#071e27",
                            "surface-container-low": "#e6f6ff",
                            "primary": "#004d99",
                            "inverse-surface": "#1e333c",
                            "surface-container-high": "#d5ecf8",
                            "secondary-container": "#fdd835",
                            "tertiary-container": "#3563be",
                            "on-surface-variant": "#424752",
                            "surface-variant": "#cfe6f2",
                            "warning": "#FFA000",
                            "on-tertiary-fixed-variant": "#00429c",
                            "on-error-container": "#93000a",
                            "on-tertiary": "#ffffff",
                            "primary-fixed-dim": "#a9c7ff",
                            "surface-dim": "#c7dde9",
                            "outline": "#727783",
                            "on-primary": "#ffffff",
                            "surface-container-lowest": "#ffffff",
                            "surface-container": "#dbf1fe",
                            "surface-tint": "#005db7",
                            "on-primary-fixed-variant": "#00468c",
                            "success": "#2E7D32",
                            "on-secondary-container": "#705e00",
                            "outline-variant": "#c2c6d4",
                            "on-surface": "#071e27",
                            "error-container": "#ffdad6",
                            "on-primary-container": "#dae5ff",
                            "on-secondary-fixed-variant": "#544600",
                            "background-alt": "#F5F7F9",
                            "on-primary-fixed": "#001b3d"
                        },
                        "borderRadius": {
                            "DEFAULT": "0.25rem",
                            "lg": "0.5rem",
                            "xl": "0.75rem",
                            "full": "9999px"
                        },
                        "spacing": {
                            "stack-lg": "48px",
                            "base": "8px",
                            "stack-sm": "12px",
                            "margin-mobile": "16px",
                            "container-max": "1280px",
                            "stack-md": "24px",
                            "margin-desktop": "64px",
                            "gutter": "24px"
                        },
                        "fontFamily": {
                            "label-md": ["Inter"],
                            "headline-md": ["Inter"],
                            "headline-xl": ["Inter"],
                            "label-sm": ["Inter"],
                            "body-sm": ["Inter"],
                            "body-md": ["Inter"],
                            "body-lg": ["Inter"],
                            "headline-lg-mobile": ["Inter"],
                            "headline-sm": ["Inter"],
                            "headline-lg": ["Inter"]
                        },
                        "fontSize": {
                            "label-md": ["14px", {"lineHeight": "16px", "letterSpacing": "0.01em", "fontWeight": "600"}],
                            "headline-md": ["24px", {"lineHeight": "32px", "fontWeight": "600"}],
                            "headline-xl": ["48px", {"lineHeight": "56px", "letterSpacing": "-0.02em", "fontWeight": "700"}],
                            "label-sm": ["12px", {"lineHeight": "16px", "fontWeight": "500"}],
                            "body-sm": ["14px", {"lineHeight": "20px", "fontWeight": "400"}],
                            "body-md": ["16px", {"lineHeight": "24px", "fontWeight": "400"}],
                            "body-lg": ["18px", {"lineHeight": "28px", "fontWeight": "400"}],
                            "headline-lg-mobile": ["28px", {"lineHeight": "36px", "fontWeight": "700"}],
                            "headline-sm": ["20px", {"lineHeight": "28px", "fontWeight": "600"}],
                            "headline-lg": ["32px", {"lineHeight": "40px", "letterSpacing": "-0.01em", "fontWeight": "700"}]
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
            }
            .stars-fill {
                font-variation-settings: 'FILL' 1;
            }
            .custom-scrollbar::-webkit-scrollbar {
                width: 6px;
            }
            .custom-scrollbar::-webkit-scrollbar-track {
                background: transparent;
            }
            .custom-scrollbar::-webkit-scrollbar-thumb {
                background: #cfe6f2;
                border-radius: 10px;
            }
            .shadow-tonal {
                box-shadow: 0 4px 20px -2px rgba(21, 101, 192, 0.08);
            }
        </style>
    </head>
    <body class="text-on-surface">
        <%@ include file="/views/layout/dashboard/sidebar.jsp" %>

        <main class="flex-1 md:ml-64 min-h-screen p-6 bg-background">            <section class="mb-stack-lg flex justify-between items-end">
                <div>
                    <h2 class="font-headline-lg text-headline-lg text-on-surface">Quản lý Đánh giá</h2>
                    <p class="font-body-md text-body-md text-on-surface-variant">Theo dõi và phản hồi các nhận xét từ khách hàng trên hệ thống.</p>
                </div>
            </section>

            <section class="grid grid-cols-1 md:grid-cols-3 gap-gutter mb-stack-lg">
                <div class="bg-surface p-6 rounded-xl shadow-tonal border border-outline-variant/30 flex items-center justify-between">
                    <div>
                        <p class="font-label-sm text-label-sm text-on-surface-variant mb-1 uppercase tracking-wider">Đánh giá trung bình</p>
                        <div class="flex items-baseline gap-2">
                            <span class="font-headline-md text-headline-md">4.7</span>
                            <span class="text-on-surface-variant font-body-sm text-body-sm">/ 5</span>
                        </div>
                        <div class="flex gap-0.5 mt-2 text-secondary">
                            <span class="material-symbols-outlined text-[18px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                            <span class="material-symbols-outlined text-[18px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                            <span class="material-symbols-outlined text-[18px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                            <span class="material-symbols-outlined text-[18px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                            <span class="material-symbols-outlined text-[18px]" data-icon="star_half" style="font-variation-settings: 'FILL' 1;">star_half</span>
                        </div>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-secondary-container/20 flex items-center justify-center text-secondary">
                        <span class="material-symbols-outlined text-[32px]" data-icon="trending_up">trending_up</span>
                    </div>
                </div>
                <div class="bg-surface p-6 rounded-xl shadow-tonal border border-outline-variant/30 flex items-center justify-between">
                    <div>
                        <p class="font-label-sm text-label-sm text-on-surface-variant mb-1 uppercase tracking-wider">Tổng đánh giá</p>
                        <span class="font-headline-md text-headline-md">1,240</span>
                        <p class="font-label-sm text-label-sm text-success flex items-center gap-1 mt-2">
                            <span class="material-symbols-outlined text-[14px]" data-icon="arrow_upward">arrow_upward</span>
                            12% so với tháng trước
                        </p>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-primary-container/10 flex items-center justify-center text-primary">
                        <span class="material-symbols-outlined text-[32px]" data-icon="forum">forum</span>
                    </div>
                </div>
                <div class="bg-surface p-6 rounded-xl shadow-tonal border border-outline-variant/30 flex items-center justify-between">
                    <div>
                        <p class="font-label-sm text-label-sm text-on-surface-variant mb-1 uppercase tracking-wider">Chờ phê duyệt</p>
                        <span class="font-headline-md text-headline-md text-warning">15</span>
                        <p class="font-label-sm text-label-sm text-on-surface-variant mt-2 italic">Cần xử lý ngay</p>
                    </div>
                    <div class="w-12 h-12 rounded-full bg-warning/10 flex items-center justify-center text-warning">
                        <span class="material-symbols-outlined text-[32px]" data-icon="pending_actions">pending_actions</span>
                    </div>
                </div>
            </section>

            <section class="bg-surface p-stack-sm rounded-xl shadow-sm border border-outline-variant/50 mb-stack-md flex flex-wrap gap-4 items-center">
                <div class="flex flex-1 gap-2 min-w-[300px]">
                    <div class="relative flex-1">
                        <span class="material-symbols-outlined absolute left-3 top-1/2 -translate-y-1/2 text-on-surface-variant text-[20px]" data-icon="search">search</span>
                        <input class="w-full pl-10 pr-4 py-2 border border-outline-variant rounded-lg focus:ring-1 focus:ring-primary focus:outline-none font-body-sm text-body-sm" placeholder="Tìm theo tên khách hàng hoặc tên sách..." type="text"/>
                    </div>
                </div>
                <div class="flex items-center gap-3">
                    <span class="font-label-sm text-label-sm text-on-surface-variant">Xếp hạng:</span>
                    <select class="border border-outline-variant rounded-lg py-2 pl-3 pr-8 font-body-sm text-body-sm focus:ring-1 focus:ring-primary focus:outline-none appearance-none bg-no-repeat bg-[right_8px_center]">
                        <option>Tất cả sao</option>
                        <option>5 sao</option>
                        <option>4 sao</option>
                        <option>3 sao</option>
                        <option>2 sao</option>
                        <option>1 sao</option>
                    </select>
                </div>
                <div class="flex items-center gap-3">
                    <span class="font-label-sm text-label-sm text-on-surface-variant">Trạng thái:</span>
                    <div class="flex bg-background-alt p-1 rounded-lg border border-outline-variant">
                        <button class="px-4 py-1.5 rounded-md font-label-sm text-label-sm bg-surface shadow-sm text-primary">Tất cả</button>
                        <button class="px-4 py-1.5 rounded-md font-label-sm text-label-sm text-on-surface-variant hover:text-on-surface transition-all">Chờ</button>
                        <button class="px-4 py-1.5 rounded-md font-label-sm text-label-sm text-on-surface-variant hover:text-on-surface transition-all">Đã duyệt</button>
                        <button class="px-4 py-1.5 rounded-md font-label-sm text-label-sm text-on-surface-variant hover:text-on-surface transition-all">Báo cáo</button>
                    </div>
                </div>
            </section>

            <section class="bg-surface rounded-2xl shadow-tonal border border-outline-variant/30 overflow-hidden">
                <div class="overflow-x-auto custom-scrollbar">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-surface-container-low border-b border-outline-variant">
                                <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Khách hàng</th>
                                <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Sách</th>
                                <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Đánh giá</th>
                                <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Nội dung</th>
                                <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Ngày</th>
                                <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider">Trạng thái</th>
                                <th class="px-6 py-4 font-label-md text-label-md text-on-surface-variant uppercase tracking-wider text-right">Hành động</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-outline-variant/30">

                            <c:choose>
                                <c:when test="${not empty reviews}">
                                    <c:forEach items="${reviews}" var="review">
                                        <tr class="hover:bg-surface-container-lowest transition-colors group">
                                            <td class="px-6 py-5">
                                                <div class="flex items-center gap-3">
                                                    <span class="font-label-md text-label-md text-on-surface">${review.customerName}</span>
                                                </div>
                                            </td>
                                            <td class="px-6 py-5">
                                                <div class="flex items-center gap-3">
                                                    <img alt="Book Cover" class="w-10 h-14 object-cover rounded shadow-sm" src="${review.bookCover}"/>
                                                    <span class="font-body-sm text-body-sm text-on-surface max-w-[120px] line-clamp-2">${review.bookTitle}</span>
                                                </div>
                                            </td>
                                            <td class="px-6 py-5">
                                                <div class="flex gap-0.5 text-secondary">
                                                    <c:forEach begin="1" end="5" var="i">
                                                        <span class="material-symbols-outlined text-[16px] ${i <= review.rating ? 'stars-fill' : ''}" data-icon="star" style="font-variation-settings: 'FILL' ${i <= review.rating ? '1' : '0'};">star</span>
                                                    </c:forEach>
                                                </div>
                                            </td>
                                            <td class="px-6 py-5">
                                                <p class="font-body-sm text-body-sm text-on-surface-variant max-w-[200px] line-clamp-2">${review.content}</p>
                                            </td>
                                            <td class="px-6 py-5">
                                                <span class="font-body-sm text-body-sm text-on-surface-variant">${review.date}</span>
                                            </td>
                                            <td class="px-6 py-5">
                                                <c:choose>
                                                    <c:when test="${review.status == 'Đã duyệt'}">
                                                        <span class="px-3 py-1 bg-success/10 text-success rounded-full font-label-sm text-label-sm inline-block">Đã duyệt</span>
                                                    </c:when>
                                                    <c:when test="${review.status == 'Chờ duyệt'}">
                                                        <span class="px-3 py-1 bg-warning/10 text-warning rounded-full font-label-sm text-label-sm inline-block">Chờ duyệt</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="px-3 py-1 bg-error/10 text-error rounded-full font-label-sm text-label-sm inline-block">${review.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="px-6 py-5 text-right">
                                                <div class="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                                    <button class="p-2 hover:bg-surface-container-low rounded-lg text-primary transition-all border border-transparent hover:border-primary/20" title="Phản hồi">
                                                        <span class="material-symbols-outlined text-[20px]" data-icon="reply">reply</span>
                                                    </button>
                                                    <button class="p-2 hover:bg-error/10 rounded-lg text-error transition-all border border-transparent hover:border-error/20" title="Xóa">
                                                        <span class="material-symbols-outlined text-[20px]" data-icon="delete">delete</span>
                                                    </button>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr class="hover:bg-surface-container-lowest transition-colors group">
                                        <td class="px-6 py-5">
                                            <div class="flex items-center gap-3">
                                                <span class="font-label-md text-label-md text-on-surface">Nguyễn Thu Hà</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-5">
                                            <div class="flex items-center gap-3">
                                                <img alt="Book Cover" class="w-10 h-14 object-cover rounded shadow-sm" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDRCGYWY4CqMre7spwl_p93R2pG4GuyEBcXGVaQhg6WZgdYdzZvaOzym6CndtT0qKLOPKnl-EET1vfSg2TpvH8PeCy1djHL_l1y5wH3kj8isLooaZzdWgyCg0qqIytnJxGajsw0ls3wUCCMqZozRviFKGzJtxCI4iN_nXB3Melv_8DpFR3CTgPhvuunH409M_59GK_UyX1-b7U9fABaj7JIQed1uLwZEP7aWsnmM7NnRLu8r_bH-xUyLOZthwyoG-eAmWLTn_2_uTep"/>
                                                <span class="font-body-sm text-body-sm text-on-surface max-w-[120px] line-clamp-2">Nhà Giả Kim</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-5">
                                            <div class="flex gap-0.5 text-secondary">
                                                <span class="material-symbols-outlined text-[16px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                                                <span class="material-symbols-outlined text-[16px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                                                <span class="material-symbols-outlined text-[16px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                                                <span class="material-symbols-outlined text-[16px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                                                <span class="material-symbols-outlined text-[16px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-5">
                                            <p class="font-body-sm text-body-sm text-on-surface-variant max-w-[200px] line-clamp-2">Sách rất hay và ý nghĩa. Giao hàng nhanh, đóng gói cẩn thận. Rất hài lòng!</p>
                                        </td>
                                        <td class="px-6 py-5">
                                            <span class="font-body-sm text-body-sm text-on-surface-variant">12/05/2024</span>
                                        </td>
                                        <td class="px-6 py-5">
                                            <span class="px-3 py-1 bg-success/10 text-success rounded-full font-label-sm text-label-sm inline-block">Đã duyệt</span>
                                        </td>
                                        <td class="px-6 py-5 text-right">
                                            <div class="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                                <button class="p-2 hover:bg-surface-container-low rounded-lg text-primary transition-all border border-transparent hover:border-primary/20" title="Phản hồi">
                                                    <span class="material-symbols-outlined text-[20px]" data-icon="reply">reply</span>
                                                </button>
                                                <button class="p-2 hover:bg-error/10 rounded-lg text-error transition-all border border-transparent hover:border-error/20" title="Xóa">
                                                    <span class="material-symbols-outlined text-[20px]" data-icon="delete">delete</span>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr class="hover:bg-surface-container-lowest transition-colors group">
                                        <td class="px-6 py-5">
                                            <div class="flex items-center gap-3">
                                                <span class="font-label-md text-label-md text-on-surface">Lê Văn Nam</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-5">
                                            <div class="flex items-center gap-3">
                                                <img alt="Book Cover" class="w-10 h-14 object-cover rounded shadow-sm" src="https://lh3.googleusercontent.com/aida-public/AB6AXuBMwxurFE_C1jer894aHZSD1CsWPYvPeGurhSmb9qMcpy-ldjNEuxEGfp_gRQw8T4xQZITo-_mdz0Os_xBpFodeKfsD92yWvK3GIDuMdTTY562m8u2rbekhLmtH0g4IFJvgoukc44-d8xChysjObFL_77C9cZ9ip1YU1QX19W4iSEKOSrpYATBRU-hVY4lRcascQ7UHjrC7uFTLZjXRCcXfAoXjylpOeUGR0Ueq7aKgPz7OroO-3stpTyCN-FNDrpIOzB6Az42jg6dd"/>
                                                <span class="font-body-sm text-body-sm text-on-surface max-w-[120px] line-clamp-2">Tư Duy Nhanh Và Chậm</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-5">
                                            <div class="flex gap-0.5 text-secondary">
                                                <span class="material-symbols-outlined text-[16px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                                                <span class="material-symbols-outlined text-[16px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                                                <span class="material-symbols-outlined text-[16px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                                                <span class="material-symbols-outlined text-[16px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                                                <span class="material-symbols-outlined text-[16px]" data-icon="star">star</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-5">
                                            <p class="font-body-sm text-body-sm text-on-surface-variant max-w-[200px] line-clamp-2">Sách có vài trang bị nhăn mép, nhưng nội dung thì tuyệt vời.</p>
                                        </td>
                                        <td class="px-6 py-5">
                                            <span class="font-body-sm text-body-sm text-on-surface-variant">11/05/2024</span>
                                        </td>
                                        <td class="px-6 py-5">
                                            <span class="px-3 py-1 bg-warning/10 text-warning rounded-full font-label-sm text-label-sm inline-block">Chờ duyệt</span>
                                        </td>
                                        <td class="px-6 py-5 text-right">
                                            <div class="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                                <button class="p-2 hover:bg-surface-container-low rounded-lg text-primary transition-all border border-transparent hover:border-primary/20" title="Phản hồi">
                                                    <span class="material-symbols-outlined text-[20px]" data-icon="reply">reply</span>
                                                </button>
                                                <button class="p-2 hover:bg-error/10 rounded-lg text-error transition-all border border-transparent hover:border-error/20" title="Xóa">
                                                    <span class="material-symbols-outlined text-[20px]" data-icon="delete">delete</span>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr class="hover:bg-surface-container-lowest transition-colors group">
                                        <td class="px-6 py-5">
                                            <div class="flex items-center gap-3">
                                                <span class="font-label-md text-label-md text-on-surface">Trần Minh Anh</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-5">
                                            <div class="flex items-center gap-3">
                                                <img alt="Book Cover" class="w-10 h-14 object-cover rounded shadow-sm" src="https://lh3.googleusercontent.com/aida-public/AB6AXuDo9tggSChWwbmV9ipNNA8ldv8Gj2FEMMj3osQvdt0XZAOGF6lF-FrIugDhdxfG2lw-1gse8KAFRGCJReL0hGs2fur6vDTTo3LqBKroGHGJoJfIrv5Psgy4_4gaPCeVZs6AEhNoZciNMwUgK7MchgBDMSHwufesQjNPR_HefdveUe6sZpH_Yt7X1Hzdk3EEvXNxxF-HhVOuTTo9xbi8pDeASttY2jtsRXEfYnPm-8lAzLa7ZatZz0v3I9O4ZXKw8u3JMQdgp7eA2Pht"/>
                                                <span class="font-body-sm text-body-sm text-on-surface max-w-[120px] line-clamp-2">Sống Tối Giản</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-5">
                                            <div class="flex gap-0.5 text-secondary">
                                                <span class="material-symbols-outlined text-[16px] stars-fill" data-icon="star" style="font-variation-settings: 'FILL' 1;">star</span>
                                                <span class="material-symbols-outlined text-[16px]" data-icon="star">star</span>
                                                <span class="material-symbols-outlined text-[16px]" data-icon="star">star</span>
                                                <span class="material-symbols-outlined text-[16px]" data-icon="star">star</span>
                                                <span class="material-symbols-outlined text-[16px]" data-icon="star">star</span>
                                            </div>
                                        </td>
                                        <td class="px-6 py-5">
                                            <p class="font-body-sm text-body-sm text-on-surface-variant max-w-[200px] line-clamp-2">Giao nhầm sách. Tôi đặt Sống Tối Giản nhưng nhận được cuốn khác.</p>
                                        </td>
                                        <td class="px-6 py-5">
                                            <span class="font-body-sm text-body-sm text-on-surface-variant">10/05/2024</span>
                                        </td>
                                        <td class="px-6 py-5">
                                            <span class="px-3 py-1 bg-error/10 text-error rounded-full font-label-sm text-label-sm inline-block">Báo cáo</span>
                                        </td>
                                        <td class="px-6 py-5 text-right">
                                            <div class="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                                <button class="p-2 hover:bg-surface-container-low rounded-lg text-primary transition-all border border-transparent hover:border-primary/20" title="Phản hồi">
                                                    <span class="material-symbols-outlined text-[20px]" data-icon="reply">reply</span>
                                                </button>
                                                <button class="p-2 hover:bg-error/10 rounded-lg text-error transition-all border border-transparent hover:border-error/20" title="Xóa">
                                                    <span class="material-symbols-outlined text-[20px]" data-icon="delete">delete</span>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="px-6 py-4 flex items-center justify-between border-t border-outline-variant bg-surface-container-lowest">
                    <span class="font-body-sm text-body-sm text-on-surface-variant">Hiển thị 1 - 3 trong số 1,240 đánh giá</span>
                    <div class="flex gap-2">
                        <button class="p-2 rounded-lg border border-outline-variant hover:bg-surface-container-low disabled:opacity-50 disabled:cursor-not-allowed transition-all" disabled="">
                            <span class="material-symbols-outlined" data-icon="chevron_left">chevron_left</span>
                        </button>
                        <button class="w-10 h-10 rounded-lg bg-primary text-on-primary font-label-md text-label-md">1</button>
                        <button class="w-10 h-10 rounded-lg border border-outline-variant hover:bg-surface-container-low font-label-md text-label-md">2</button>
                        <button class="w-10 h-10 rounded-lg border border-outline-variant hover:bg-surface-container-low font-label-md text-label-md">3</button>
                        <button class="p-2 rounded-lg border border-outline-variant hover:bg-surface-container-low transition-all">
                            <span class="material-symbols-outlined" data-icon="chevron_right">chevron_right</span>
                        </button>
                    </div>
                </div>
            </section>
        </main>

        <script>
            // Các hiệu ứng tương tác nhỏ (Micro-interactions)
            document.querySelectorAll('tr').forEach(row => {
                row.addEventListener('mouseenter', () => {
                    row.style.transform = 'translateY(-2px)';
                    row.style.boxShadow = '0 10px 15px -3px rgba(0, 0, 0, 0.05)';
                });
                row.addEventListener('mouseleave', () => {
                    row.style.transform = 'translateY(0)';
                    row.style.boxShadow = 'none';
                });
            });

            // Hiệu ứng focus thanh tìm kiếm chính
            const mainSearch = document.querySelector('header input');
            mainSearch.addEventListener('focus', () => {
                mainSearch.parentElement.classList.add('ring-2', 'ring-primary/20');
            });
            mainSearch.addEventListener('blur', () => {
                mainSearch.parentElement.classList.remove('ring-2', 'ring-primary/20');
            });
        </script>
    </body>
</html>