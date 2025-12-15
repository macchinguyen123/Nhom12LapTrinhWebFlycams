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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
</head>
<body>
<c:set var="currentPage" value="${pageContext.request.requestURI}"/>
<!-- ==== HEADER TRÊN ==== -->
<div class="header-bg">
    <div class="header-wrapper">
        <header class="top-header">
            <!-- LOGO -->
            <a href="homepage.jsp">
                <div class="logo">
                    <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
                    <h2>SkyDrone</h2>
                </div>
            </a>

            <!-- THANH TÌM KIẾM -->
            <form action="${pageContext.request.contextPath}/Searching" method="get"
                  class="search-bar position-relative">
                <i class="bi bi-search" id="searchBtn" style="cursor: pointer;"></i>

                <input id="searchInput"
                       name="keyword"
                       type="text"
                       placeholder="Tìm kiếm drone, flycam..."
                       autocomplete="off"
                       value="${keyword != null ? keyword : ''}">

                <ul id="suggestList"
                    class="list-group position-absolute w-100 shadow-sm"
                    style="top: 100%; left: 0; z-index: 1000; display: none;">
                </ul>
            </form>


            <!-- HÀNH ĐỘNG HEADER -->
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/wishlist">
                    <button class="nav-item ${currentPage.contains('/wishlist') ? 'active' : ''}">
                        <i class="bi bi-heart"></i> Yêu thích
                    </button>
                </a>

                <a href="shoppingcart.jsp">
                    <div class="icon-btn" title="Giỏ hàng">
                        <i class="bi bi-cart3"></i>
                        <span>Giỏ hàng</span>
                    </div>
                </a>

                <a href="${pageContext.request.contextPath}/personal">
                    <div class="icon-btn ${currentPage.endsWith('personal-page.jsp') ? 'active' : ''}"
                         title="Tài khoản">
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
                <button class="nav-item ${currentPage.endsWith('homepage.jsp') ? 'active' : ''}">
                    <i class="bi bi-house-door"></i>Trang chủ
                </button>
            </a>

            <button class="nav-item ${currentPage.contains('/category') ? 'active' : ''}" id="btnDanhMuc">
                <i class="bi bi-grid"></i>Danh mục<i class="bi bi-caret-down-fill ms-1"></i>
            </button>

            <a href="promotion.jsp">
                <button class="nav-item ${currentPage.endsWith('promotion.jsp') ? 'active' : ''}">
                    <i class="bi bi-gift"></i>Khuyến mãi
                </button>
            </a>

            <a href="warranty.jsp">
                <button class="nav-item ${currentPage.endsWith('warranty.jsp') ? 'active' : ''}">
                    <i class="bi bi-tools"></i>Bảo hành
                </button>
            </a>

            <a href="payment-policy.jsp">
                <button class="nav-item ${currentPage.endsWith('payment-policy.jsp') ? 'active' : ''}">
                    <i class="bi bi-credit-card"></i>Thanh toán
                </button>
            </a>

            <a href="support.jsp">
                <button class="nav-item ${currentPage.endsWith('support.jsp') ? 'active' : ''}">
                    <i class="bi bi-headset"></i>Hỗ trợ
                </button>
            </a>

            <a href="${pageContext.request.contextPath}/blog">
                <button class="nav-item ${currentPage.contains('/blog') ? 'active' : ''}">
                    <i class="bi bi-journal-text"></i>Bài viết
                </button>
            </a>

        </nav>

    </div>
    <!-- MENU TRÁI ẨN MẶC ĐỊNH -->
    <div class="menu-left-1" id="menuLeft">
        <ul>
            <li><a href="category/film-drone.jsp">
                <img src="${pageContext.request.contextPath}/image/logoCategory/logoDanhMucQuayPhim.png"
                     class="menu-icon">Drone quay phim chuyên nghiệp
            </a>
            </li>

            <li><a href="category/tourism-drone.jsp">
                <img src="${pageContext.request.contextPath}/image/logoCategory/logoDanhMucDuLich.png"
                     class="menu-icon">Drone du lịch, vlog
            </a>
            </li>
            <li><a href="category/sport-drone.jsp">
                <img src="${pageContext.request.contextPath}/image/logoCategory/logoDanhMucTheThao.png"
                     class="menu-icon">Drone thể thao tốc độ cao
            </a>
            </li>
            <li><a href="category/agriculture-drone.jsp">
                <img src="${pageContext.request.contextPath}/image/logoCategory/logoDanhMucNongNghiep.png"
                     class="menu-icon">Drone nông nghiệp
            </a>
            </li>
            <li><a href="category/monitor-drone.jsp">
                <img src="${pageContext.request.contextPath}/image/logoCategory/logoDanhMucAnNinh.png"
                     class="menu-icon">Drone giám sát, an ninh
            </a>
            </li>
            <li><a href="category/mini-drone.jsp">
                <img src="${pageContext.request.contextPath}/image/logoCategory/logoDanhMucMini.png" class="menu-icon">Drone
                mini, cỡ nhỏ
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
<script>
    document.getElementById("searchBtn").addEventListener("click", () => {
        document.querySelector(".search-bar").submit();
    });
</script>
</body>
</html>
