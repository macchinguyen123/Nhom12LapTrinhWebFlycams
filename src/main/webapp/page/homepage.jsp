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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">

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
                        <img src="${pageContext.request.contextPath}/${cat.image}" class="menu-icon">
                            ${cat.categoryName}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </div>


    <%-- <!-- SLIDER PHẢI -->--%>
    <%-- <div class="banner-right">--%>
    <%-- <a href="product-details.jsp">--%>
    <%-- <video autoplay loop muted playsinline>--%>
    <%-- <source
        src="https://res.cloudinary.com/dwnbmfhel/video/upload/v1763279095/9run.ca_-_Introducing_DJI_Mavic_4_Pro_1440p_obst67.mp4"
        --%>
    <%-- type="video/mp4">--%>
    <%-- </video>--%>
    <%-- </a>--%>
    <%-- </div>--%>
    <!-- PHẦN 1: Banner Video/Ảnh Phải (order_index = 1) -->
    <c:if test="${not empty banners && banners.size() > 0}">
        <c:set var="banner" value="${banners[0]}"/>
        <div class="banner-right">
            <c:choose>
                <c:when test="${banner.type == 'video'}">
                    <a
                            href="${not empty banner.link ? banner.link : '#'}">
                        <video autoplay loop muted playsinline>
                            <source src="${banner.videoUrl}"
                                    type="video/mp4">
                        </video>
                    </a>
                </c:when>
                <c:otherwise>
                    <a
                            href="${not empty banner.link ? banner.link : '#'}">
                        <img src="${banner.imageUrl}"
                             alt="Banner ${banner.id}">
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>
</div>


<c:if test="${not empty banners && banners.size() > 1}">
    <div class="banner-wrapper">
        <c:forEach var="banner" items="${banners}" begin="1" end="3">
            <a href="${not empty banner.link ? banner.link : '#'}">
                <div class="banner-item">
                    <c:choose>
                        <c:when test="${banner.type == 'image'}">
                            <img src="${banner.imageUrl}" alt="Banner ${banner.id}">
                        </c:when>
                        <c:otherwise>
                            <video autoplay loop muted playsinline>
                                <source src="${banner.videoUrl}" type="video/mp4">
                            </video>
                        </c:otherwise>
                    </c:choose>
                </div>
            </a>
        </c:forEach>
    </div>
</c:if>

<!-- SLIDER PHẢI MỚI (SLIDER 2) -->
<c:if test="${not empty banners && banners.size() > 4}">
    <div class="banner-right slider-2">
        <div class="slider slider-2-inner">
            <c:forEach var="banner" items="${banners}" begin="4">
                <a href="${not empty banner.link ? banner.link : '#'}" class="slider-2-link">
                    <div class="slide">
                        <c:choose>
                            <c:when test="${banner.type == 'image'}">
                                <img src="${banner.imageUrl}" alt="Banner ${banner.id}"
                                     style="width: 100%; height: 100%; object-fit: cover;">
                            </c:when>

                            <c:otherwise>
                                <video autoplay loop muted playsinline
                                       style="width: 100%; height: 100%; object-fit: cover;">
                                    <source src="${banner.videoUrl}" type="video/mp4">
                                </video>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </a>
            </c:forEach>
        </div>

        <div class="arrow left slider-2-left">&#10094;</div>
        <div class="arrow right slider-2-right">&#10095;</div>
        <div class="dots slider-2-dots"></div>
    </div>
</c:if>

<!-- Sản phẩm nổi bật -->
<section class="phan-san-pham">
    <h2 class="tieu-de-muc">SẢN PHẨM BÁN CHẠY NHẤT</h2>
    <div class="khung-san-pham">
        <c:forEach var="p" items="${bestSellerProducts}">
            <div class="san-pham">
                <!-- Bọc toàn bộ phần chính bằng link tới chi tiết (nếu có id sản phẩm) -->
                <a class="link-chi-tiet"
                   href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <!-- Ảnh -->
                    <div class="khung-anh">
                        <c:choose>
                            <c:when test="${not empty p.mainImage}">
                                <img src="${p.mainImage}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                     alt="No Image">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Tên sản phẩm -->
                    <h3 class="ten-san-pham">${p.productName}</h3>

                    <!-- Giá (luôn hiển thị div.gia giống mẫu) -->
                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)}  ₫</b>

                        <c:if test="${p.price > p.finalPrice}">
                                            <span class="gia-goc">
                                                ${formatter.format(p.price)}  ₫
                                            </span>
                        </c:if>
                    </div>

                </a>

                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <!-- Đánh giá mẫu -->
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
                        <c:forEach begin="1" end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
                            <i class="bi bi-star"></i>
                        </c:forEach>

                    </div>
                    <c:choose>
                        <c:when
                                test="${wishlistProductIds != null && wishlistProductIds.contains(p.id)}">
                            <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-heart tim-yeu-thich" data-product-id="${p.id}"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Số đánh giá -->
                <div class="so-danh-gia">
                    (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                </div>
                <!-- Nút mua ngay (có thể là form/post hoặc link) -->
                <form action="${pageContext.request.contextPath}/add-cart" method="get">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">

                    <button type="submit" class="nut-mua-ngay">
                        <i class="bi bi-cart-plus"></i>
                        Thêm vào giỏ
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
            <div class="san-pham">
                <!-- Bọc toàn bộ phần chính bằng link tới chi tiết (nếu có id sản phẩm) -->
                <a class="link-chi-tiet"
                   href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <!-- Ảnh -->
                    <div class="khung-anh">
                        <c:choose>
                            <c:when test="${not empty p.mainImage}">
                                <img src="${p.mainImage}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                     alt="No Image">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Tên sản phẩm -->
                    <h3 class="ten-san-pham">${p.productName}</h3>

                    <!-- Giá (luôn hiển thị div.gia giống mẫu) -->
                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>

                        <c:if test="${p.price > p.finalPrice}">
                                            <span class="gia-goc">
                                                ${formatter.format(p.price)} ₫
                                            </span>
                        </c:if>
                    </div>

                </a>

                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <!-- Đánh giá mẫu -->
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
                        <c:forEach begin="1" end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
                            <i class="bi bi-star"></i>
                        </c:forEach>

                    </div>
                    <c:choose>
                        <c:when
                                test="${wishlistProductIds != null && wishlistProductIds.contains(p.id)}">
                            <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-heart tim-yeu-thich" data-product-id="${p.id}"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Số đánh giá -->
                <div class="so-danh-gia">
                    (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                </div>
                <!-- Nút mua ngay (có thể là form/post hoặc link) -->
                <form action="${pageContext.request.contextPath}/add-cart" method="get">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">

                    <button type="submit" class="nut-mua-ngay">
                        <i class="bi bi-cart-plus"></i>
                        Thêm vào giỏ
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
            <div class="san-pham">
                <!-- Bọc toàn bộ phần chính bằng link tới chi tiết (nếu có id sản phẩm) -->
                <a class="link-chi-tiet"
                   href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <!-- Ảnh -->
                    <div class="khung-anh">
                        <c:choose>
                            <c:when test="${not empty p.mainImage}">
                                <img src="${p.mainImage}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                     alt="No Image">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Tên sản phẩm -->
                    <h3 class="ten-san-pham">${p.productName}</h3>

                    <!-- Giá (luôn hiển thị div.gia giống mẫu) -->
                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>

                        <c:if test="${p.price > p.finalPrice}">
                                            <span class="gia-goc">
                                                ${formatter.format(p.price)} ₫
                                            </span>
                        </c:if>
                    </div>

                </a>

                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <!-- Đánh giá mẫu -->
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
                        <c:forEach begin="1" end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
                            <i class="bi bi-star"></i>
                        </c:forEach>

                    </div>
                    <c:choose>
                        <c:when
                                test="${wishlistProductIds != null && wishlistProductIds.contains(p.id)}">
                            <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-heart tim-yeu-thich" data-product-id="${p.id}"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Số đánh giá -->
                <div class="so-danh-gia">
                    (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                </div>
                <!-- Nút mua ngay (có thể là form/post hoặc link) -->
                <form action="${pageContext.request.contextPath}/add-cart" method="get">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">

                    <button type="submit" class="nut-mua-ngay">
                        <i class="bi bi-cart-plus"></i>
                        Thêm vào giỏ
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
            <div class="san-pham">
                <!-- Bọc toàn bộ phần chính bằng link tới chi tiết (nếu có id sản phẩm) -->
                <a class="link-chi-tiet"
                   href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                    <!-- Ảnh -->
                    <div class="khung-anh">
                        <c:choose>
                            <c:when test="${not empty p.mainImage}">
                                <img src="${p.mainImage}" alt="${p.productName}">
                            </c:when>
                            <c:otherwise>
                                <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                     alt="No Image">
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- Tên sản phẩm -->
                    <h3 class="ten-san-pham">${p.productName}</h3>

                    <!-- Giá (luôn hiển thị div.gia giống mẫu) -->
                    <div class="gia">
                        <b>${formatter.format(p.finalPrice)} ₫</b>

                        <c:if test="${p.price > p.finalPrice}">
                                            <span class="gia-goc">
                                                ${formatter.format(p.price)} ₫
                                            </span>
                        </c:if>
                    </div>

                </a>

                <c:set var="fullStars1" value="${p.avgRating.intValue()}"/>
                <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}"/>
                <!-- Đánh giá mẫu -->
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
                        <c:forEach begin="1" end="${5 - fullStars1 - (hasHalfStar1 ? 1 : 0)}">
                            <i class="bi bi-star"></i>
                        </c:forEach>

                    </div>
                    <c:choose>
                        <c:when
                                test="${wishlistProductIds != null && wishlistProductIds.contains(p.id)}">
                            <i class="bi bi-heart-fill tim-yeu-thich yeu-thich"
                               data-product-id="${p.id}"></i>
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-heart tim-yeu-thich" data-product-id="${p.id}"></i>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Số đánh giá -->
                <div class="so-danh-gia">
                    (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                </div>
                <!-- Nút mua ngay (có thể là form/post hoặc link) -->
                <form action="${pageContext.request.contextPath}/add-cart" method="get">
                    <input type="hidden" name="productId" value="${p.id}">
                    <input type="hidden" name="quantity" value="1">

                    <button type="submit" class="nut-mua-ngay">
                        <i class="bi bi-cart-plus"></i>
                        Thêm vào giỏ
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

                <a href="${pageContext.request.contextPath}/article?id=${post.id}">
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
    // Đợi DOM load xong
    document.addEventListener('DOMContentLoaded', function () {
        const slider2 = document.querySelector('.slider-2-inner');
        const slides2 = document.querySelectorAll('.slider-2-inner .slide');
        const dotsContainer2 = document.querySelector('.slider-2-dots');
        const arrowLeft2 = document.querySelector('.slider-2-left');
        const arrowRight2 = document.querySelector('.slider-2-right');
        const slider2Container = document.querySelector('.slider-2');

        // Kiểm tra xem slider có tồn tại không
        if (!slider2 || !slides2.length) {
            console.log('Slider 2 không tồn tại hoặc không có slide');
            return;
        }

        // Nếu chỉ có 1 slide, ẩn các nút điều khiển và không chạy slide
        if (slides2.length < 2) {
            if (arrowLeft2) arrowLeft2.style.display = 'none';
            if (arrowRight2) arrowRight2.style.display = 'none';
            if (dotsContainer2) dotsContainer2.style.display = 'none';
            return;
        }

        let index2 = 0;
        let autoSlide2;

        /* Tạo dots */
        function createDots2() {
            if (!dotsContainer2) return;
            dotsContainer2.innerHTML = ''; // Clear trước khi tạo mới
            slides2.forEach((_, i) => {
                const dot = document.createElement('span');
                dot.classList.add('dot2');
                if (i === 0) dot.classList.add('active');
                dot.addEventListener('click', () => {
                    goToSlide2(i);
                    stopSlide2();
                    startSlide2(); // Restart auto slide sau khi click
                });
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

            // Log raw values
            console.log('DEBUG: index2=', index2);

            // Calculate percentage explicitly
            const percentage = index2 * 100;
            console.log('DEBUG: percentage=', percentage);

            // Construct string
            const transformValue = 'translateX(-' + percentage + '%)';
            console.log('DEBUG: transformValue string=', transformValue);

            // Apply style
            if (slider2) {
                slider2.style.transform = transformValue;
                console.log('DEBUG: Element style.transform after set:', slider2.style.transform);
            } else {
                console.error('DEBUG: slider2 element is missing!');
            }

            updateDots2();
        }

        /* Handle resize */
        window.addEventListener('resize', () => {
            goToSlide2(index2);
        });

        /* Mũi tên trái */
        if (arrowLeft2) {
            arrowLeft2.addEventListener('click', () => {
                goToSlide2(index2 - 1);
                stopSlide2();
                startSlide2(); // Restart auto slide
            });
        }

        /* Mũi tên phải */
        if (arrowRight2) {
            arrowRight2.addEventListener('click', () => {
                goToSlide2(index2 + 1);
                stopSlide2();
                startSlide2(); // Restart auto slide
            });
        }

        /* Auto slide */
        function startSlide2() {
            stopSlide2(); // Clear interval cũ trước
            autoSlide2 = setInterval(() => {
                goToSlide2(index2 + 1);
            }, 3000);
        }

        function stopSlide2() {
            if (autoSlide2) {
                clearInterval(autoSlide2);
            }
        }

        /* Hover events */
        if (slider2Container) {
            slider2Container.addEventListener('mouseenter', stopSlide2);
            slider2Container.addEventListener('mouseleave', startSlide2);
        }

        /* Khởi động slider */
        createDots2();
        startSlide2();

        console.log('Slider 2 đã khởi động với ' + slides2.length + ' slides');
    });
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
                    } else if (data.error === 'login_required' || data.message === 'NOT_LOGIN') {
                        // Redirect trực tiếp đến trang đăng nhập
                        window.location.href = '${pageContext.request.contextPath}/page/login.jsp';
                    }
                })
                .catch(err => {
                    console.error('Error:', err);
                });
        });
    });
</script>
<script>
    // ============================================
    // ADD TO CART LOGIC (Uses global handler from header.jsp)
    // ============================================
    document.addEventListener('DOMContentLoaded', () => {
        // Attach event listeners to all add-to-cart buttons
        document.querySelectorAll('.nut-mua-ngay').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();

                const form = btn.closest('form');
                if (!form) return;

                const productIdInput = form.querySelector('input[name="productId"]');
                const quantityInput = form.querySelector('input[name="quantity"]');

                if (!productIdInput) return;

                const productId = productIdInput.value;
                const quantity = quantityInput ? quantityInput.value : 1;

                const productCard = btn.closest('.san-pham');
                const productImg = productCard ? (productCard.querySelector('.khung-anh img') || productCard.querySelector('img')) : null;

                // Call global handler defined in header.jsp
                if (typeof globallyHandleAddToCart === 'function') {
                    globallyHandleAddToCart(productId, quantity, productImg, btn);
                } else {
                    console.error('globallyHandleAddToCart function not found');
                    form.submit();
                }
            });
        });
    });
</script>
</body>

</html>