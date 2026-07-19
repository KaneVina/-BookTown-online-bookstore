<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<script>
    (function () {
        if (window.__wishlistHeartBound) {
            return;
        }
        window.__wishlistHeartBound = true;

        function notify(msg, isError) {
            if (typeof showToast === "function") {
                showToast(msg, !!isError);
            } else {
                alert(msg);
            }
        }

        function getFormPostUrl(form) {
            return form.getAttribute("action") || "${pageContext.request.contextPath}/wishlist";
        }

        function getWishActionInput(form) {
            return form.querySelector("input[name='wishAction']")
                    || form.querySelector("input[name='action']");
        }

        function getBookId(form) {
            var input = form.querySelector("input[name='wishBookId']")
                    || form.querySelector("input[name='bookID']");
            var fromInput = input ? String(input.value || "").trim() : "";
            if (fromInput) {
                return fromInput;
            }
            return String(form.getAttribute("data-book-id") || "").trim();
        }

        function isValidBookId(bookID) {
            return /^[1-9]\d*$/.test(String(bookID || ""));
        }

        async function readJsonResponse(response) {
            var text = await response.text();
            if (!text) {
                return null;
            }
            try {
                return JSON.parse(text);
            } catch (err) {
                return null;
            }
        }

        function updateWishlistBadge(count) {
            var badge = document.querySelector(".wishlist-badge");
            if (!badge || typeof count === "undefined") {
                return;
            }
            badge.textContent = count;
            badge.classList.toggle("hidden", count <= 0);
        }

        function syncCardHearts(bookID, favorited) {
            document.querySelectorAll(".wishlist-form").forEach(function (form) {
                if (getBookId(form) !== String(bookID)) {
                    return;
                }

                var btn = form.querySelector(".wish-btn");
                var svg = btn ? btn.querySelector("svg") : null;
                var actionInput = getWishActionInput(form);
                if (!btn || !svg || !actionInput) {
                    return;
                }

                if (favorited) {
                    btn.classList.add("active");
                    svg.setAttribute("fill", "#ef4444");
                    svg.setAttribute("stroke", "#ef4444");
                    actionInput.value = "remove";
                    btn.title = "Xóa khỏi yêu thích";
                    btn.setAttribute("aria-label", "Xóa khỏi yêu thích");
                } else {
                    btn.classList.remove("active");
                    svg.setAttribute("fill", "none");
                    svg.setAttribute("stroke", "#374151");
                    actionInput.value = "add";
                    btn.title = "Thêm vào yêu thích";
                    btn.setAttribute("aria-label", "Thêm vào yêu thích");
                }
            });
        }

        function syncDetailWishlistButton(bookID, favorited) {
            var form = document.getElementById("wishlist-detail-form");
            if (!form || getBookId(form) !== String(bookID)) {
                return;
            }

            var btn = form.querySelector("button[type='submit']");
            var svg = btn ? btn.querySelector("svg") : null;
            var textSpan = form.querySelector(".wishlist-text");
            var actionInput = getWishActionInput(form);
            if (!btn || !svg || !actionInput) {
                return;
            }

            if (favorited) {
                btn.className = "w-full bg-red-50 border-2 border-red-500 text-red-500 font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-red-500 hover:text-white transition-all";
                svg.setAttribute("fill", "#ef4444");
                svg.setAttribute("stroke", "#ef4444");
                if (textSpan) {
                    textSpan.textContent = "Đã thích";
                }
                actionInput.value = "remove";
            } else {
                btn.className = "w-full border-2 border-primary text-primary font-bold text-[16px] py-4 rounded-full flex items-center justify-center gap-2 hover:bg-primary hover:text-white transition-all";
                svg.setAttribute("fill", "none");
                svg.setAttribute("stroke", "currentColor");
                if (textSpan) {
                    textSpan.textContent = "Yêu thích";
                }
                actionInput.value = "add";
            }
        }

        function syncAllWishlistUi(bookID, favorited) {
            syncCardHearts(bookID, favorited);
            syncDetailWishlistButton(bookID, favorited);
        }

        async function submitWishlistForm(form) {
            var actionInput = getWishActionInput(form);
            var bookID = getBookId(form);
            var submitBtn = form.querySelector(".wish-btn, button[type='submit']");

            if (!actionInput || !isValidBookId(bookID) || !submitBtn || submitBtn.disabled) {
                if (!isValidBookId(bookID)) {
                    notify("Mã sách không hợp lệ trên thẻ sách.", true);
                }
                return;
            }

            submitBtn.disabled = true;

            var body = new URLSearchParams();
            body.append("action", actionInput.value);
            body.append("bookID", bookID);
            body.append("ajax", "true");

            try {
                var response = await fetch(getFormPostUrl(form), {
                    method: "POST",
                    headers: {
                        "X-Requested-With": "XMLHttpRequest",
                        "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                    },
                    body: body.toString()
                });

                var data = await readJsonResponse(response);

                if (response.status === 401 || response.status === 403) {
                    if (data && data.redirect) {
                        window.location.href = data.redirect;
                    } else {
                        notify((data && data.message) || "Vui lòng đăng nhập để dùng yêu thích", true);
                    }
                    return;
                }

                if (!data) {
                    notify("Không thể xử lý phản hồi từ server.", true);
                    return;
                }

                if (!response.ok || !data.success) {
                    notify(data.message || "Không thể thực hiện yêu cầu.", true);
                    return;
                }

                if (data.action === "added") {
                    syncAllWishlistUi(bookID, true);
                    notify(data.message || "Đã thêm vào yêu thích!");
                } else if (data.action === "removed") {
                    syncAllWishlistUi(bookID, false);
                    notify(data.message || "Đã xóa khỏi yêu thích!");
                } else {
                    notify(data.message || "Đã cập nhật yêu thích!");
                }

                updateWishlistBadge(data.wishlistCount);
            } catch (err) {
                console.error(err);
                notify("Lỗi kết nối mạng.", true);
            } finally {
                submitBtn.disabled = false;
            }
        }

        function bindWishlistForm(form) {
            if (!form || form.dataset.wishlistBound === "true") {
                return;
            }
            form.dataset.wishlistBound = "true";

            form.addEventListener("submit", function (e) {
                e.preventDefault();
                e.stopPropagation();
                submitWishlistForm(form);
            });

            form.addEventListener("click", function (e) {
                e.stopPropagation();
            });
        }

        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll(".wishlist-form, #wishlist-detail-form").forEach(bindWishlistForm);
        });
    })();
</script>
