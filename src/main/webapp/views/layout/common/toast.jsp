<%-- 
    Document   : toast
    Created on : Jun 7, 2026, 12:56:45 PM
    Author     : PHUC KHANG
--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="toast"
     class="fixed bottom-6 right-6 z-[70] flex items-center gap-3 px-4 py-3
            bg-white rounded-xl border shadow-card-hover
            transform translate-y-16 opacity-0 pointer-events-none"
     style="border-color:#c2c6d4; min-width:260px; transition: all 0.3s ease;">
    <span class="material-symbols-outlined" style="color:#2E7D32;" id="toastIcon">check_circle</span>
    <span class="text-sm font-medium" style="color:#071e27;" id="toastMsg">Thao tác thành công!</span>
    <button onclick="hideToast()" class="ml-auto" style="color:#727783;">
        <span class="material-symbols-outlined" style="font-size:18px;">close</span>
    </button>
</div>

<script>
function showToast(msg, isError = false) {
    const toast = document.getElementById('toast');
    const icon  = document.getElementById('toastIcon');
    document.getElementById('toastMsg').textContent = msg;
    icon.textContent  = isError ? 'error' : 'check_circle';
    icon.style.color  = isError ? '#D32F2F' : '#2E7D32';
    toast.classList.remove('translate-y-16', 'opacity-0', 'pointer-events-none');
    toast.classList.add('translate-y-0', 'opacity-100');
    setTimeout(hideToast, 3000);
}
function hideToast() {
    const toast = document.getElementById('toast');
    toast.classList.add('translate-y-16', 'opacity-0', 'pointer-events-none');
    toast.classList.remove('translate-y-0', 'opacity-100');
}

// Flash message từ server
<c:if test="${not empty successMessage}">
    window.addEventListener('load', () => showToast('${successMessage}'));
    <c:remove var="successMessage" scope="session"/>
</c:if>
<c:if test="${not empty errorMessage}">
    window.addEventListener('load', () => showToast('${errorMessage}', true));
    <c:remove var="errorMessage" scope="session"/>
</c:if>
</script>
