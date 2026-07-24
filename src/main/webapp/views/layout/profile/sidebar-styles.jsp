<%--
    CSS dùng chung cho sidebar và khung "profile-card" ở các trang
    thuộc khu vực "Tài khoản của tôi". Include file này 1 lần ở đầu
    trang, TRƯỚC file sidebar.jsp.
--%>
<style>
    body {
        background: #f3faff;
    }
    .profile-card {
        background: #fff;
        border-radius: 16px;
        border: 1px solid #dbeafe;
        box-shadow: 0 2px 10px rgba(0, 0, 0, .05);
    }
    .menu-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 16px;
        border-radius: 12px;
        transition: .2s;
        text-decoration: none;
    }
    .menu-item:hover {
        background: #eff6ff;
    }
    .menu-active {
        background: #dbeafe;
        color: #2563eb;
        font-weight: 600;
    }
</style>
<link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:wght,FILL@100..700,0..1&display=swap" rel="stylesheet">
