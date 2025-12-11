<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SkyDrone Header</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="../stylesheets/header.css">
</head>
<body>

<!-- ==== HEADER TRÊN ==== -->
<div class="header-bg">
    <div class="header-wrapper">
        <header class="top-header">
            <!-- LOGO -->
            <a href="homepage.jsp">
                <div class="logo">
                    <img src="../image/logoo2.png" alt="Logo">
                    <h2>SkyDrone</h2>
                </div>
            </a>

            <!-- THANH TÌM KIẾM -->
            <a href="searching.jsp">
                <div class="search-bar position-relative">
                    <i class="bi bi-search"></i>
                    <input id="searchInput" type="text" placeholder="Tìm kiếm drone, flycam..."
                           autocomplete="off">

                    <!-- Danh sách gợi ý xổ xuống -->
                    <ul id="suggestList" class="list-group position-absolute w-100 shadow-sm"
                        style="top: 100%; left: 0; z-index: 1000; display: none;">
                    </ul>
                </div>
            </a>


            <!-- HÀNH ĐỘNG HEADER -->
            <div class="header-actions">
                <a href="wishlist.jsp">
                    <div class="icon-btn" title="Yêu thích">
                        <i class="bi bi-heart"></i>
                        <span>Yêu thích</span>
                    </div>
                </a>

                <a href="shoppingcart.jsp">
                    <div class="icon-btn" title="Giỏ hàng">
                        <i class="bi bi-cart3"></i>
                        <span>Giỏ hàng</span>
                    </div>
                </a>

                <a href="personal-page.html">
                    <div class="icon-btn active" title="Tài khoản">
                        <i class="bi bi-person-circle"></i>
                        <span>Tài khoản</span>
                    </div>
                </a>
            </div>
        </header>
    </div>
</div>

<!-- ==== MENU DƯỚI ==== -->
<div class="menu-bg">
    <div class="header-wrapper">
        <nav class="main-nav">
            <a href="homepage.jsp">
                <button class="nav-item"><i class="bi bi-house-door"></i>Trang chủ</button>
            </a>
            <button class="nav-item" id="btnDanhMuc">
                <i class="bi bi-grid"></i>Danh mục<i class="bi bi-caret-down-fill ms-1"></i>
            </button>
            <a href="promotion.jsp">
                <button class="nav-item"><i class="bi bi-gift"></i>Khuyến mãi</button>
            </a>
            <a href="warranty.jsp">
                <button class="nav-item"><i class="bi bi-tools"></i>Bảo hành</button>
            </a>
            <a href="payment-policy.jsp">
                <button class="nav-item"><i class="bi bi-credit-card"></i>Thanh toán</button>
            </a>
            <a href="support.jsp">
                <button class="nav-item"><i class="bi bi-headset"></i>Hỗ trợ</button>
            </a>
            <a href="blog.jsp">
                <button class="nav-item"><i class="bi bi-journal-text"></i>Bài viết</button>
            </a>
        </nav>
    </div>
    <!-- MENU TRÁI ẨN MẶC ĐỊNH -->
    <div class="menu-left-1" id="menuLeft">
        <ul>
            <li><a href="category/film-drone.jsp">
                <img src="../image/logoCategory/logoDanhMucQuayPhim.png" class="menu-icon">Drone quay phim chuyên nghiệp
            </a>
            </li>

            <li><a href="category/tourism-drone.jsp">
                <img src="../image/logoCategory/logoDanhMucDuLich.png" class="menu-icon">Drone du lịch, vlog
            </a>
            </li>
            <li><a href="category/sport-drone.jsp">
                <img src="../image/logoCategory/logoDanhMucTheThao.png" class="menu-icon">Drone thể thao tốc độ cao
            </a>
            </li>
            <li><a href="category/agriculture-drone.jsp">
                <img src="../image/logoCategory/logoDanhMucNongNghiep.png" class="menu-icon">Drone nông nghiệp
            </a>
            </li>
            <li><a href="category/monitor-drone.jsp">
                <img src="../image/logoCategory/logoDanhMucAnNinh.png" class="menu-icon">Drone giám sát, an ninh
            </a>
            </li>
            <li><a href="category/mini-drone.jsp">
                <img src="../image/logoCategory/logoDanhMucMini.png" class="menu-icon">Drone mini, cỡ nhỏ
            </a>
            </li>
        </ul>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const btnDanhMuc = document.getElementById('btnDanhMuc');
    const menuLeft = document.getElementById('menuLeft');

    btnDanhMuc.addEventListener('click', () => {
        menuLeft.classList.toggle('show');
    });

    // Ẩn menu khi click ra ngoài
    document.addEventListener('click', (e) => {
        if (!menuLeft.contains(e.target) && !btnDanhMuc.contains(e.target)) {
            menuLeft.classList.remove('show');
        }
    });
</script>
</body>
</html>
