<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${post.title}"/> - SkyDrone</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/article.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/footer.css">

</head>
<body>
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

                <a href="personal-page.jsp">
                    <div class="icon-btn" title="Tài khoản">
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
                <button class="nav-item active"><i class="bi bi-journal-text"></i>Bài viết</button>
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

<article class="article-container">
    <header class="article-header">
        <div class="meta-info">
            <span class="post-date">
                <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy" />
            </span>
            <span class="author">by Admin</span>
        </div>

        <h1 class="article-title">${post.title}</h1>
    </header>

    <div class="article-content">

        <!-- ẢNH BÀI VIẾT -->
        <div class="article-image">
            <img src="${post.image}" alt="${post.title}">
        </div>

        <!-- NỘI DUNG -->
        <div class="article-text" style="white-space: pre-line;">
        ${post.content}
    </div>





        <!-- Bài viết liên quan -->
        <section class="related-posts">
            <h3>Xem thêm bài viết khác:</h3>
            <ul>
                <c:forEach var="p" items="${relatedPosts}">
                    <li>
                        <a href="article?id=${p.id}">
                                ${p.title}
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </section>

        <!-- Phần bình luận -->
        <section class="comment-section">
            <h2>1 bình luận trong bài viết này</h2>

            <div class="comment">
                <div class="comment-avatar"></div>
                <div class="comment-content">
                    <div class="comment-author">Nhẫn Hoàng</div>
                    <div class="comment-date">03 Tháng 01 2024 at 11:29pm</div>
                    <div class="comment-text">ok</div>
                </div>
            </div>

            <div class="comment-form">
                <h3>Tham gia vào cuộc trò chuyện</h3>
                <p class="comment-note">
                    Tài khoản email của bạn sẽ không được công bố trong bình luận.
                    Trường yêu cầu sẽ đánh dấu <span class="required">*</span>
                </p>

                <label for="comment">Bình Luận <span class="required">*</span></label>
                <textarea id="comment" name="comment" rows="5" placeholder="Nhập bình luận của bạn..."></textarea>
                <button type="submit" class="comment-submit">Đăng Bình Luận</button>
            </div>
        </section>

    </div>
</article>

<footer class="footer">
    <div class="footer-container">
        <!-- Cột 1 -->
        <div class="footer-column">
            <h6>SKYDRONE VIỆT NAM</h6>
            <img src="../image/dronefooter.png" alt="SKYDRONE Logo" class="mascot">
            <p><strong>Công ty Cổ phần thương mại SKYDrone Việt Nam</strong></p>
            <p>Địa chỉ: Số 1 Đường Số 1, Phường Linh Xuân, TP Hồ Chí Minh, Việt Nam</p>
            <p><strong>Hotline:</strong> 0815.000.060</p>
            <p>ĐKKD số 0108676636 do Sở KH&ĐT TP. Hồ Chí Minh cấp ngày 10/10/2025</p>

            <div class="social-icons">
                <a href="#"><i class="fa-brands fa-facebook"></i></a>
                <a href="#"><i class="fa-brands fa-instagram"></i></a>
                <a href="#"><i class="fa-brands fa-x-twitter"></i></a>
                <a href="#"><i class="fa-solid fa-envelope"></i></a>
            </div>
        </div>

        <!-- Cột 2 -->
        <div class="footer-column">
            <h6>SẢN PHẨM</h6>
            <ul>
                <li><a href="y/film-drone.html">Drone quay phim chuyên nghiệp</a></li>
                <li><a href="y/tourism-drone.html">Drone du lịch / vlog</a></li>
                <li><a href="y/sport-drone.html">Drone thể thao tốc độ cao</a></li>
                <li><a href="y/agriculture-drone.html">Drone nông nghiệp</a></li>
                <li><a href="y/monitor-drone.html">Drone giám sát / an ninh</a></li>
                <li><a href="y/mini-drone.html">Drone mini / cở nhỏ</a></li>
            </ul>

            <h3>TƯ VẤN MUA HÀNG</h3>
            <div class="hotline">
                <i class="fa-solid fa-phone"></i>0813.660.666
            </div>
        </div>

        <!-- Cột 3 -->
        <div class="footer-column">
            <h6>HỆ THỐNG PHÂN PHỐI</h6>
            <ul>
                <li><a href="#">SKYDrone Store</a></li>
                <li><a href="#">Hà Nội</a></li>
                <li><a href="#">TP. Hồ Chí Minh</a></li>
                <li><a href="#">Đà Nẵng</a></li>
                <li><a href="#">Nghệ An</a></li>

            </ul>
            <section class="payment-methods">
                <h6>PHƯƠNG THỨC THANH TOÁN</h6>
                <div class="payment-icons">
                    <img src="https://tse3.mm.bing.net/th/id/OIP.kklIaX3TV97u5KnjU_Kr4wHaHa?rs=1&pid=ImgDetMain&o=7&rm=3"
                         alt="VNPay">
                </div>
            </section>
        </div>
        <!-- Cột 4 -->
        <div class="footer-column">
            <h6>THÔNG TIN VỀ CHÍNH SÁCH</h6>
            <ul>
                <li><a href="#">Mua hàng và thanh toán Online</a></li>
                <li><a href="#">Chính sách giao hàng</a></li>
                <li><a href="#">Chính sách đổi trả</a></li>
                <li><a href="#">Tra thông tin bảo hành</a></li>
                <li><a href="#">Thông tin hoá đơn mua hàng</a></li>
            </ul>

            <section class="social-connect">
                <h6>KẾT NỐI VỚI SKYDRONE</h6>
                <div class="social-icons">
                    <a href="https://www.youtube.com/@F8VNOfficial"
                       class="icon youtube" target="_blank" rel="noopener noreferrer">
                        <img src="https://cdn-icons-png.flaticon.com/512/1384/1384060.png" alt="YouTube">
                    </a>

                    <a href="https://www.facebook.com/dhkcntt.nlu"
                       class="icon facebook" target="_blank" rel="noopener noreferrer">
                        <img src="https://cdn-icons-png.flaticon.com/512/733/733547.png" alt="Facebook">
                    </a>

                    <a href="https://www.instagram.com/truyenthongchinhphu/"
                       class="icon instagram" target="_blank" rel="noopener noreferrer">
                        <img src="https://cdn-icons-png.flaticon.com/512/174/174855.png" alt="Instagram">
                    </a>

                    <a href="https://www.tiktok.com/@nonglam.university"
                       class="icon tiktok" target="_blank" rel="noopener noreferrer">
                        <img src="https://cdn-icons-png.flaticon.com/512/3046/3046121.png" alt="TikTok">
                    </a>

                    <a href="https://zalo.me/0966089465"
                       class="icon zalo" target="_blank" rel="noopener noreferrer">
                        <img src="https://upload.wikimedia.org/wikipedia/commons/9/91/Icon_of_Zalo.svg" alt="Zalo">
                    </a>
                </div>
            </section>

        </div>

    </div>


    <div class="footer-bottom">
        <p>Copyright © 2025 © <strong>SKYDrone Việt Nam</strong></p>
        <p>Các nội dung, tài liệu và hình ảnh thuộc bản quyền của SKYDrone Việt Nam. Mọi hành vi sao chép sẽ bị nghiêm
            cấm.</p>
    </div>
</footer>
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