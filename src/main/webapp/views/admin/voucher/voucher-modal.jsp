<%-- 
    Document   : voucher-modal
    Created on : Jun 7, 2026, 12:40:09 PM
    Author     : PHUC KHANG
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<div class="fixed inset-0 z-50 hidden modal-backdrop" id="voucherModal" style="background:rgba(30,51,60,0.5);">
    <div class="absolute inset-0" onclick="closeModal()"></div>
    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white rounded-2xl shadow-card-hover w-full max-w-3xl max-h-[90vh] overflow-hidden flex flex-col">

        <div class="px-6 py-4 border-b flex justify-between items-center" style="border-color:#c2c6d4; background:#F5F7F9;">
            <h3 class="text-lg font-semibold" style="color:#071e27;" id="modalTitle">Thêm Voucher Mới</h3>
            <button onclick="closeModal()" class="p-1 rounded-full hover:bg-error-container transition-colors" style="color:#424752;">
                <span class="material-symbols-outlined">close</span>
            </button>
        </div>

        <div class="flex-1 overflow-y-auto p-6 flex flex-col lg:flex-row gap-6">
            <form method="post" action="${pageContext.request.contextPath}/dashboard/voucher-management"
                  class="flex-1 space-y-4" id="voucherForm">
                <input type="hidden" name="action" id="formAction" value="add"/>
                <input type="hidden" name="voucherID" id="formVoucherID" value=""/>

                <%-- Mã code --%>
                <div>
                    <label class="block text-sm font-semibold mb-1.5" style="color:#071e27;">
                        Mã Code <span style="color:#D32F2F;">*</span>
                    </label>
                    <div class="flex">
                        <input id="inputCode" name="code" type="text" required
                               class="flex-1 border rounded-l-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white uppercase"
                               style="border-color:#c2c6d4;"
                               placeholder="VD: SALE2024"
                               oninput="updatePreview()"/>
                        <button type="button" onclick="randomCode()"
                                class="border border-l-0 rounded-r-lg px-4 text-sm font-medium transition-colors"
                                style="border-color:#c2c6d4; background:#dbf1fe; color:#004d99;"
                                title="Tạo mã ngẫu nhiên">
                            <span class="material-symbols-outlined" style="font-size:18px;">autorenew</span>
                        </button>
                    </div>
                </div>

                <%-- Giảm giá + Số lượng --%>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#071e27;">
                            Giảm giá (%) <span style="color:#D32F2F;">*</span>
                        </label>
                        <input id="inputDiscount" name="discountPercent" type="number" min="1" max="100" required
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#c2c6d4;"
                               placeholder="10"
                               oninput="updatePreview()"/>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#071e27;">
                            Số lượng
                            <span class="text-xs font-normal" style="color:#424752;"></span>
                        </label>
                        <input id="inputQuantity" name="quantity" type="number" min="1"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#c2c6d4;"
                               placeholder="100"/>
                    </div>
                </div>

                <%-- Đơn hàng tối thiểu + Giảm tối đa --%>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#071e27;">
                            Đơn hàng tối thiểu (₫)
                            <span class="text-xs font-normal" style="color:#424752;"></span>
                        </label>
                        <input id="inputMinOrder" name="minOrderValue" type="number" min="0" step="any"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#c2c6d4;"
                               placeholder="100000"
                               oninput="updatePreview()"/>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#071e27;">
                            Giảm tối đa (₫)
                            <span class="text-xs font-normal" style="color:#424752;"></span>
                        </label>
                        <input id="inputMaxDiscount" name="maxDiscountValue" type="number" min="0" step="any"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#c2c6d4;"
                               placeholder="50000"
                               oninput="updatePreview()"/>
                    </div>
                </div>

                <%-- Ngày bắt đầu + Ngày kết thúc --%>
                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#071e27;">Ngày bắt đầu</label>
                        <input id="inputStartDate" name="startDate" type="date"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#c2c6d4;"
                               oninput="updatePreview()"/>
                        <%-- min sẽ được set bằng JS khi mở modal tạo mới --%>
                    </div>
                    <div>
                        <label class="block text-sm font-semibold mb-1.5" style="color:#071e27;">Ngày kết thúc</label>
                        <input id="inputEndDate" name="endDate" type="date"
                               class="w-full border rounded-lg px-4 py-2 text-sm focus:outline-none focus:ring-2 bg-white"
                               style="border-color:#c2c6d4;"
                               oninput="updatePreview()"/>
                    </div>
                </div>

                <%-- Toggle trạng thái — chỉ hiện khi EDIT --%>
                <div id="statusSection" class="hidden">
                    <label class="block text-sm font-semibold mb-1.5" style="color:#071e27;">Trạng thái</label>
                    <label class="inline-flex items-center cursor-pointer gap-3">
                        <input id="inputStatus" name="statusToggle" type="checkbox" class="sr-only peer"/>
                        <div class="relative w-11 h-6 rounded-full peer peer-checked:after:translate-x-full after:content-[''] after:absolute after:top-[2px] after:start-[2px] after:bg-white after:rounded-full after:h-5 after:w-5 after:transition-all"
                             style="background:#c2c6d4;" id="toggleBg"></div>
                        <span class="text-sm" style="color:#071e27;" id="statusLabel">Vô hiệu hóa</span>
                    </label>
                </div>

                <div class="hidden">
                    <button type="submit" id="submitBtn">Submit</button>
                </div>
            </form>

            <%-- Preview --%>
            <div class="w-full lg:w-72 flex-shrink-0">
                <p class="text-xs font-semibold text-center mb-3" style="color:#727783;">XEM TRƯỚC</p>
                <div class="border-2 border-dashed rounded-xl p-6 text-center relative overflow-hidden"
                     style="border-color:#004d99; background:#f3faff;">
                    <div class="absolute -left-3 top-1/2 -translate-y-1/2 w-6 h-6 rounded-full"
                         style="background:white; border-right: 2px dashed #004d99;"></div>
                    <div class="absolute -right-3 top-1/2 -translate-y-1/2 w-6 h-6 rounded-full"
                         style="background:white; border-left: 2px dashed #004d99;"></div>
                    <span class="material-symbols-outlined icon-fill text-4xl mb-2 block" style="color:#004d99;">loyalty</span>
                    <h4 class="text-xl font-bold mb-1" style="color:#004d99;" id="previewDiscount">Giảm ?%</h4>
                    <div class="inline-block px-3 py-1 rounded my-2 font-mono font-bold tracking-widest text-sm"
                         style="background:#d6e3ff; color:#004d99; border:1px solid #a9c7ff;" id="previewCode">
                        CODE
                    </div>
                    <p class="text-xs mt-1" style="color:#424752;" id="previewDate">HSD: --/--/----</p>
                    <p class="text-xs mt-1" style="color:#424752;" id="previewMinOrder"></p>
                    <p class="text-xs mt-1" style="color:#424752;" id="previewMaxDiscount"></p>
                </div>
                <p class="text-xs text-center mt-3" style="color:#424752;">
                    Đây là cách voucher hiển thị với khách hàng.
                </p>
            </div>
        </div>

        <div class="px-6 py-4 border-t flex justify-end gap-3" style="border-color:#c2c6d4;">
            <button type="button" onclick="closeModal()"
                    class="px-5 py-2.5 rounded-lg border text-sm font-semibold transition-colors"
                    style="border-color:#004d99; color:#004d99;">
                Hủy
            </button>
            <button type="button" onclick="document.getElementById('submitBtn').click()"
                    class="px-5 py-2.5 rounded-lg text-white text-sm font-semibold transition-colors active:scale-95"
                    style="background:#004d99;">
                Lưu Voucher
            </button>
        </div>
    </div>
</div>

<%-- ===== DELETE CONFIRM ===== --%>
<div class="fixed inset-0 z-[60] hidden" id="deleteDialog" style="background:rgba(30,51,60,0.6);">
    <div class="absolute inset-0" onclick="closeDeleteDialog()"></div>
    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 bg-white rounded-xl shadow-card-hover w-full max-w-sm p-6 text-center">
        <div class="w-14 h-14 rounded-full flex items-center justify-center mx-auto mb-4"
             style="background:#ffdad6; color:#D32F2F;">
            <span class="material-symbols-outlined text-3xl">warning</span>
        </div>
        <h3 class="text-lg font-semibold mb-2" style="color:#071e27;">Xóa Voucher?</h3>
        <p class="text-sm mb-5" style="color:#424752;">
            Bạn có chắc muốn xóa voucher
            <strong class="font-mono" style="color:#004d99;" id="deleteCodeLabel"></strong>?
            Hành động này không thể hoàn tác.
        </p>
        <form method="post" action="${pageContext.request.contextPath}/dashboard/voucher-management" id="deleteForm">
            <input type="hidden" name="action" value="delete"/>
            <input type="hidden" name="voucherID" id="deleteVoucherID"/>
            <div class="flex justify-center gap-3">
                <button type="button" onclick="closeDeleteDialog()"
                        class="px-4 py-2 rounded-lg border text-sm font-medium"
                        style="border-color:#c2c6d4; color:#424752;">
                    Hủy
                </button>
                <button type="submit"
                        class="px-4 py-2 rounded-lg text-white text-sm font-medium"
                        style="background:#D32F2F;">
                    Xóa ngay
                </button>
            </div>
        </form>
    </div>
</div>

