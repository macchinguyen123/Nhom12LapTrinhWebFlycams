<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>SkyDrone - Trang chủ</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/category-homepage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/homepage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/product-homepage.css">
</head>
<body>

<jsp:include page="/page/header.jsp"/>


<!-- ==== DANH MỤC + SLIDER ==== -->
<div class="container d-flex">
    <!-- MENU TRÁI -->
    <div class="menu-left">
        <ul>
            <c:forEach items="${headerCategories}" var="cat">
                <li>
                    <a href="${pageContext.request.contextPath}/Category?id=${cat.id}">
                        <img src="${pageContext.request.contextPath}/${cat.image}"
                             class="menu-icon">
                            ${cat.categoryName}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </div>


    <!-- SLIDER PHẢI -->
    <div class="banner-right">
        <a href="product-details.jsp">
            <video autoplay loop muted playsinline>
                <source src="https://res.cloudinary.com/dwnbmfhel/video/upload/v1763279095/9run.ca_-_Introducing_DJI_Mavic_4_Pro_1440p_obst67.mp4"
                        type="video/mp4">
            </video>
        </a>
    </div>
</div>


<div class="banner-wrapper">
    <a href="category/monitor-drone.jsp">
        <div class="banner-item">
            <img src="${pageContext.request.contextPath}/image/banner/img_3.png" alt="Ảnh 1">
        </div>
    </a>
    <a href="product-details.jsp">
        <div class="banner-item">
            <img src="${pageContext.request.contextPath}/image/banner/hinh2.png" alt="Ảnh 2">
        </div>
    </a>
    <a href="product-details.jsp">
        <div class="banner-item">
            <img src="https://boba.vn/static/san-pham/may-anh-may-bay-flycam/may-quay-phim-may-quay-hanh-dong/flycam-may-bay-mini-co-camera-the-thao-gia-re-chinh-hang/flycam-dji-mavic-3-classic-dji-rc-n1/01-flycam-dji.jpg"
                 alt="Ảnh 3">
        </div>
    </a>
</div>
<!-- SLIDER PHẢI MỚI (SLIDER 2) -->
<div class="banner-right slider-2">
    <div class="slider slider-2-inner">
        <a href="product-details.jsp">
            <div class="slide">
                <img src="https://m.media-amazon.com/images/S/aplus-media-library-service-media/90a99765-f304-47dd-a286-4d5f794bd5dd.__CR0,0,1464,600_PT0_SX1464_V1___.jpg"
                     alt="Slider 2 - Ảnh 1">
            </div>
        </a>
        <a href="product-details.jsp">
            <div class="slide">
                <img src="https://www.hytobp.net/cdn/shop/files/5-5_1200x.jpg?v=1719805846" alt="Slider 2 - Ảnh 2">
            </div>
        </a>
        <a href="product-details.jsp">
            <div class="slide">
                <img src="https://file.hstatic.net/1000158388/file/m2ed_banner_with_logo__4_.jpg"
                     alt="Slider 2 - Ảnh 3">
            </div>
        </a>
    </div>

    <div class="arrow left slider-2-left">&#10094;</div>
    <div class="arrow right slider-2-right">&#10095;</div>
    <div class="dots slider-2-dots"></div>
</div>

<!-- Sản phẩm nổi bật -->
<section class="phan-san-pham">
    <h2 class="tieu-de-muc">SẢN PHẨM BÁN CHẠY NHẤT</h2>
    <div class="khung-san-pham">
        <c:forEach var="p" items="${bestSellerProducts}">
            <!-- === SẢN PHẨM 1 === -->
            <div class="san-pham">
                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <img src="${empty p.mainImage ? '/assets/no-image.png' : p.mainImage}">

                    <h3 class="ten-san-pham">
                            ${p.productName}
                    </h3>

                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>
                        <c:if test="${p.price >= p.finalPrice}">
                            <span class="gia-goc">
                                ${formatter.format(p.price)} ₫
                            </span>
                        </c:if>
                    </div>
                </a>

                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <div class="hang-danh-gia">
                    <div class="danh-gia-sao">

                        <!-- Sao đầy -->
                        <c:forEach begin="1" end="${fullStars1}">
                            <i class="bi bi-star-fill"></i>
                        </c:forEach>

                        <!-- Nửa sao -->
                        <c:if test="${hasHalfStar1}">
                            <i class="bi bi-star-half"></i>
                        </c:if>

                        <!-- Sao rỗng -->
                        <c:forEach begin="1"
                                   end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
                            <i class="bi bi-star"></i>
                        </c:forEach>

                    </div>

                    <c:choose>
                        <c:when test="${wishlistProductIds != null && wishlistProductIds.contains(p.id)}">
                            <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-heart tim-yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="so-danh-gia">
                    (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                </div>

                <!-- Nút mua ngay (có thể là form/post hoặc link) -->
                <form action="${pageContext.request.contextPath}/BuyNowServlet" method="post">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">

                    <button type="submit" class="nut-mua-ngay">
                        Mua Ngay
                    </button>
                </form>
            </div>
        </c:forEach>
    </div>
</section>

<section class="danh-muc">
    <h2>DANH MỤC NỔI BẬT</h2>

    <div class="danh-muc-list">
        <c:forEach items="${headerCategories}" var="cat">
        <div class="item">
                <a href="${pageContext.request.contextPath}/Category?id=${cat.id}">
                    <img src="${pageContext.request.contextPath}/${cat.image}"
                         alt="${cat.categoryName}">
                    <p>${cat.categoryName}</p>
                </a>
            </div>
        </c:forEach>
    </div>
</section>


<!-- Sản phẩm nổi bật -->
<section class="phan-san-pham-noi-bat">
    <h2>SẢN PHẨM NỔI BẬT</h2>
    <div class="khung-san-pham">
        <c:forEach var="p" items="${topReviewedProducts}">
            <!-- === SẢN PHẨM 1 === -->
            <div class="san-pham">
                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <img src="${empty p.mainImage ? '/assets/no-image.png' : p.mainImage}">

                    <h3 class="ten-san-pham">
                            ${p.productName}
                    </h3>

                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>
                        <c:if test="${p.price >= p.finalPrice}">
                            <span class="gia-goc">
                                ${formatter.format(p.price)} ₫
                            </span>
                        </c:if>
                    </div>
                </a>

                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <div class="hang-danh-gia">
                    <div class="danh-gia-sao">

                        <!-- Sao đầy -->
                        <c:forEach begin="1" end="${fullStars1}">
                            <i class="bi bi-star-fill"></i>
                        </c:forEach>

                        <!-- Nửa sao -->
                        <c:if test="${hasHalfStar1}">
                            <i class="bi bi-star-half"></i>
                        </c:if>

                        <!-- Sao rỗng -->
                        <c:forEach begin="1"
                                   end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
                            <i class="bi bi-star"></i>
                        </c:forEach>

                    </div>

                    <c:choose>
                        <c:when test="${wishlistProductIds != null && wishlistProductIds.contains(p.id)}">
                            <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-heart tim-yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="so-danh-gia">
                    (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                </div>

                <!-- Nút mua ngay (có thể là form/post hoặc link) -->
                <form action="${pageContext.request.contextPath}/BuyNowServlet" method="post">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">

                    <button type="submit" class="nut-mua-ngay">
                        Mua Ngay
                    </button>
                </form>
            </div>
        </c:forEach>
    </div>
</section>

<a href="product-details.jsp">
    <div class="banner">
        <img src="${pageContext.request.contextPath}/image/banner/hinh4.png" alt="Banner ưu đãi">
    </div>
</a>

<section class="phan-san-pham-1">
    <h2>DRONE QUAY PHIM</h2>


    <div class="khung-san-pham-1">
        <a href="product-details.jsp">
            <div class="poster">
                <img src="${pageContext.request.contextPath}/image/banner/img_2.png" alt="Poster 1">
            </div>
        </a>

        <c:forEach var="p" items="${quayPhim}">
            <!-- === SẢN PHẨM 1 === -->
            <div class="san-pham">
                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <img src="${empty p.mainImage ? '/assets/no-image.png' : p.mainImage}">

                    <h3 class="ten-san-pham">
                            ${p.productName}
                    </h3>

                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>
                        <c:if test="${p.price >= p.finalPrice}">
                            <span class="gia-goc">
                                ${formatter.format(p.price)} ₫
                            </span>
                        </c:if>
                    </div>
                </a>

                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <div class="hang-danh-gia">
                    <div class="danh-gia-sao">

                        <!-- Sao đầy -->
                        <c:forEach begin="1" end="${fullStars1}">
                            <i class="bi bi-star-fill"></i>
                        </c:forEach>

                        <!-- Nửa sao -->
                        <c:if test="${hasHalfStar1}">
                            <i class="bi bi-star-half"></i>
                        </c:if>

                        <!-- Sao rỗng -->
                        <c:forEach begin="1"
                                   end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
                            <i class="bi bi-star"></i>
                        </c:forEach>

                    </div>

                    <c:choose>
                        <c:when test="${wishlistProductIds != null && wishlistProductIds.contains(p.id)}">
                            <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-heart tim-yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="so-danh-gia">
                    (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                </div>

                <!-- Nút mua ngay (có thể là form/post hoặc link) -->
                <form action="${pageContext.request.contextPath}/BuyNowServlet" method="post">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">

                    <button type="submit" class="nut-mua-ngay">
                        Mua Ngay
                    </button>
                </form>
            </div>
        </c:forEach>

    </div>
    <a href="${pageContext.request.contextPath}/Category?id=1001">
        <button class="xem">Xem Tất Cả »</button>
    </a>
</section>

<section class="phan-san-pham-1">
    <h2>DRONE MINI</h2>


    <div class="khung-san-pham-1">
        <a href="product-details.jsp">
            <div class="poster">
                <img src="${pageContext.request.contextPath}/image/banner/img.png" alt="Poster 1">
            </div>
        </a>

        <c:forEach var="p" items="${mini}">
            <!-- === SẢN PHẨM 1 === -->
            <div class="san-pham">
                <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <img src="${empty p.mainImage ? '/assets/no-image.png' : p.mainImage}">

                    <h3 class="ten-san-pham">
                            ${p.productName}
                    </h3>

                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>
                        <c:if test="${p.price >= p.finalPrice}">
                            <span class="gia-goc">
                                ${formatter.format(p.price)} ₫
                            </span>
                        </c:if>
                    </div>
                </a>

                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <div class="hang-danh-gia">
                    <div class="danh-gia-sao">

                        <!-- Sao đầy -->
                        <c:forEach begin="1" end="${fullStars1}">
                            <i class="bi bi-star-fill"></i>
                        </c:forEach>

                        <!-- Nửa sao -->
                        <c:if test="${hasHalfStar1}">
                            <i class="bi bi-star-half"></i>
                        </c:if>

                        <!-- Sao rỗng -->
                        <c:forEach begin="1"
                                   end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
                            <i class="bi bi-star"></i>
                        </c:forEach>

                    </div>

                    <c:choose>
                        <c:when test="${wishlistProductIds != null && wishlistProductIds.contains(p.id)}">
                            <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-heart tim-yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="so-danh-gia">
                    (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                </div>

                <!-- Nút mua ngay (có thể là form/post hoặc link) -->
                <form action="${pageContext.request.contextPath}/BuyNowServlet" method="post">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">

                    <button type="submit" class="nut-mua-ngay">
                        Mua Ngay
                    </button>
                </form>
            </div>
        </c:forEach>

    </div>
    <a href="${pageContext.request.contextPath}/Category?id=1004">
        <button class="xem">Xem Tất Cả »</button>
    </a>
</section>


<section class="related-articles">
    <h2>BÀI VIẾT MỚI NHẤT</h2>

    <div class="related-grid">
        <c:forEach var="post" items="${latestPosts}">
            <div class="related-item">

                <<a href="${pageContext.request.contextPath}/article?id=${post.id}">
                    <img src="${empty post.image ? '/assets/no-image.png' : post.image}"
                         alt="${post.title}">
                    <p>${post.title}</p>
                </a>

            </div>
        </c:forEach>
    </div>
</section>

<jsp:include page="/page/footer.jsp"/>

<!-- ==== JAVASCRIPT SLIDER ==== -->
<script>
    const slider2 = document.querySelector('.slider-2-inner');
    const slides2 = document.querySelectorAll('.slider-2-inner .slide');
    const dotsContainer2 = document.querySelector('.slider-2-dots');
    const arrowLeft2 = document.querySelector('.slider-2-left');
    const arrowRight2 = document.querySelector('.slider-2-right');

    let index2 = 0;
    let autoSlide2;

    /* Tạo dots */
    function createDots2() {
        slides2.forEach((_, i) => {
            const dot = document.createElement('span');
            dot.classList.add('dot2');
            if (i === 0) dot.classList.add('active');
            dot.addEventListener('click', () => goToSlide2(i));
            dotsContainer2.appendChild(dot);
        });
    }

    /* Cập nhật dots */
    function updateDots2() {
        document.querySelectorAll('.dot2').forEach((dot, i) => {
            dot.classList.toggle('active', i === index2);
        });
    }

    /* Chuyển slide */
    function goToSlide2(i) {
        index2 = (i + slides2.length) % slides2.length;
        slider2.style.transform = `translateX(-${index2 * 100}%)`;
        updateDots2();
    }

    /* Mũi tên */
    arrowLeft2.addEventListener('click', () => {
        goToSlide2(index2 - 1);
    });

    arrowRight2.addEventListener('click', () => {
        goToSlide2(index2 + 1);
    });

    /* Auto slide */
    function startSlide2() {
        autoSlide2 = setInterval(() => {
            goToSlide2(index2 + 1);
        }, 3000);
    }

    function stopSlide2() {
        clearInterval(autoSlide2);
    }

    document.querySelector('.slider-2').addEventListener('mouseenter', stopSlide2);
    document.querySelector('.slider-2').addEventListener('mouseleave', startSlide2);

    /* Khởi động */
    createDots2();
    startSlide2();
</script>


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
    document.querySelectorAll('.tim-yeu-thich').forEach(tim => {
        tim.addEventListener('click', function (e) {
            e.preventDefault();
            e.stopPropagation();

            const productId = this.getAttribute('data-product-id');
            const isLiked = this.classList.contains('yeu-thich');
            const action = isLiked ? 'remove' : 'add';

            console.log('SEND:', action, productId);

            if (!productId) {
                console.error('productId is null');
                return;
            }

            fetch('${pageContext.request.contextPath}/wishlist', {
                method: 'POST',
                credentials: 'same-origin',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: new URLSearchParams({
                    action: action,
                    productId: productId
                })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        this.classList.toggle('bi-heart');
                        this.classList.toggle('bi-heart-fill');
                        this.classList.toggle('yeu-thich');
                    }
                });
        });
    });
</script>
</body>
</html>
