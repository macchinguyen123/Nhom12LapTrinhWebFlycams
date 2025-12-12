<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Giỏ hàng Flycam</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/wishlist.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/footer.css">


    <link rel="stylesheet" href="../stylesheets/wishlist.css">
    <link rel="stylesheet" href="../stylesheets/header.css">
    <link rel="stylesheet" href="../stylesheets/footer.css">
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
                <a href="wishlist.html">
                    <div class="icon-btn active" title="Yêu thích">
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

<div class="khung-san-pham">
    <c:if test="${empty products}">
        <p>Không có sản phẩm yêu thích nào.</p>
    </c:if>
    <c:forEach var="p" items="${products}">
        <div class="san-pham">
            <a href="${pageContext.request.contextPath}/product-details.jsp?id=${p.id}">
                <c:choose>
                    <c:when test="${not empty p.images}">
                        <img src="${p.images[0].imageUrl}" alt="${p.productName}">
                    </c:when>
                    <c:otherwise>
                        <img src="${pageContext.request.contextPath}/assets/no-image.png" alt="No Image">
                    </c:otherwise>
                </c:choose>

                <h3 class="ten-san-pham">${p.productName}</h3>

                <div class="gia">
                    <b>${p.finalPrice} ₫</b>
                    <c:if test="${p.price >= p.finalPrice}">
                        <span class="gia-goc">${p.price} ₫</span>
                    </c:if>
                </div>
            </a>

            <div class="hang-danh-gia">
                <div class="danh-gia-sao">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                </div>
                <i class="bi bi-heart tim-yeu-thich"></i>
            </div>

            <div class="so-danh-gia">(12 đánh giá)</div>
            <button class="nut-mua-ngay">Mua Ngay</button>
        </div>
    </c:forEach>
</div>


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
                <li><a href="#">Drone quay phim chuyên nghiệp</a></li>
                <li><a href="#">Drone du lịch / vlog</a></li>
                <li><a href="#">Drone thể thao tốc độ cao</a></li>
                <li><a href="#">Drone nông nghiệp</a></li>
                <li><a href="#">Drone giám sát / an ninh</a></li>
                <li><a href="#">Drone mini / cở nhỏ</a></li>
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
<script>
    const chonTatCa = document.getElementById("chon_tat_ca");
    const nutXoaDaChon = document.querySelector(".nut_xoa_da_chon");
    const danhSach = document.getElementById("danh_sach_san_pham");

    // Chọn tất cả
    chonTatCa.addEventListener("change", () => {
        document.querySelectorAll(".chon_san_pham").forEach(cb => cb.checked = chonTatCa.checked);
        capNhatTongTien();
    });

    // Xử lý click trong danh sách
    danhSach.addEventListener("click", e => {
        const sp = e.target.closest(".khung_san_pham");
        if (!sp) return;

        // Xóa sản phẩm
        if (e.target.classList.contains("nut_xoa") || e.target.closest(".nut_xoa")) {
            sp.remove();
            capNhatTongTien();
        }

        // Tick chọn sản phẩm
        if (e.target.classList.contains("chon_san_pham")) {
            const tatCa = document.querySelectorAll(".chon_san_pham").length;
            const daChon = document.querySelectorAll(".chon_san_pham:checked").length;
            chonTatCa.checked = (tatCa === daChon);
            capNhatTongTien();
        }
    });

    nutXoaDaChon.addEventListener("click", () => {
        document.querySelectorAll(".chon_san_pham:checked").forEach(cb => cb.closest(".khung_san_pham").remove());
        capNhatTongTien();
    });
</script>
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
