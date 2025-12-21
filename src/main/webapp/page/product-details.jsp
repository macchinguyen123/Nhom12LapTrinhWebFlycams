<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết sản phẩm</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Thêm link Bootstrap Icons (nếu chưa có trong <head>) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- CSS riêng -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/product-details.css">
</head>
<body>

<jsp:include page="/page/header.jsp"/>

<!-- Khung chính -->
<div class="main-wrapper">
    <div class="container bg-white mt-4 p-4 rounded shadow-sm">
        <div class="row">

            <!-- Hình ảnh sản phẩm -->
            <div class="col-md-6 text-center product-image-col">
                <div class="main-image-wrapper">
                    <div id="mainImage" class="border rounded mb-3">
                        <c:if test="${not empty product.images}">
                            <img id="displayImg"
                                 src="${product.images[0].imageUrl}">
                        </c:if>

                        <button class="nav-btn prev-btn"><i class="bi bi-chevron-left"></i></button>
                        <button class="nav-btn next-btn"><i class="bi bi-chevron-right"></i></button>
                    </div>
                </div>

                <div class="fixed-bottom-block">
                    <div class="d-flex justify-content-center gap-2">
                        <c:forEach var="img" items="${product.images}">
                            <img src="${img.imageUrl}"
                                 class="img-thumbnail thumb"
                                 width="80"
                                 onclick="changeImage('${img.imageUrl}')">
                        </c:forEach>
                    </div>

                    <div class="share-icons mt-3">
                        <span>Chia sẻ:</span>
                        <i class="bi bi-messenger"></i>
                        <i class="bi bi-facebook"></i>
                        <i class="bi bi-pinterest"></i>
                        <i class="bi bi-twitter-x"></i>
                        <span class="ms-2 heart-btn">
                            <i class="bi bi-heart tim-yeu-thich"></i> Yêu thích
                        </span>
                    </div>
                </div>
            </div>

            <!-- Thông tin sản phẩm -->
            <div class="col-md-6">
                <h5 class="fw-bold mb-2">${product.productName}</h5>

                <div class="rating mb-3">

                    <c:forEach begin="1" end="${fullStars}">
                        <i class="bi bi-star-fill"></i>
                    </c:forEach>

                    <c:if test="${hasHalfStar}">
                        <i class="bi bi-star-half"></i>
                    </c:if>

                    <c:forEach begin="1"
                               end="${5 - fullStars - (hasHalfStar ? 1 : 0)}">
                        <i class="bi bi-star"></i>
                    </c:forEach>

                    <span class="ms-2">
                        <u><fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/></u> |
                        <u class="text-muted">${reviewCount} Đánh Giá</u>
                    </span>
                </div>
                <div class="product-info text-muted mb-2">

                    <p class="mb-1 d-flex flex-wrap gap-3">
                        <span>
                            <span class="fw-semibold">Thương hiệu:</span>
                            <span class="text-primary">${product.brandName}</span>
                        </span>
                        <span>
                            <span class="fw-semibold">Mã sản phẩm:</span>
                            <span class="text-secondary">${product.id}</span>
                        </span>
                    </p>

                    <p class="mb-1">
                        <span class="fw-semibold">Danh mục:</span>
                        <a href="${pageContext.request.contextPath}/Category?id=${product.categoryId}">
                            <span class="text-primary">${categoryName}</span>
                        </a>
                    </p>

                </div>

                <div class="price my-3">
                    <span class="fs-1 fw-bold text-danger">
                        ${formatter.format(product.finalPrice)} ₫
                    </span>

                    <c:if test="${product.price >= product.finalPrice}">
                        <span class="text-muted text-decoration-line-through ms-2">
                            ${formatter.format(product.price)} ₫
                        </span>
                    </c:if>

                    <div class="discount-badge">-11%</div>
                </div>

                <div class="quantity mb-3 d-flex align-items-center">
                    <span class="me-3 fw-semibold">Số lượng</span>
                    <div class="quantity-box">
                        <button id="minus">-</button>
                        <input type="text" id="qty" value="1" readonly>
                        <button id="plus">+</button>
                    </div>
                </div>

                <div class="buy-buttons">
                    <form action="${pageContext.request.contextPath}/add-cart"
                          method="get"
                          style="display:inline-block;">

                        <input type="hidden" name="productId" value="${product.id}">
                        <input type="hidden" name="quantity" id="quantityHidden" value="1">

                        <button type="submit" class="btn-add-cart">
                            <i class="bi bi-cart-fill"></i> Thêm Vào Giỏ Hàng
                        </button>
                    </form>


                    <a href="delivery-info.jsp">
                        <button class="btn-buy-now">Mua Ngay</button>
                    </a>
                </div>


                <div class="policy p-3 rounded">
                    <h6 class="fw-bold mb-2">Chính sách của sản phẩm:</h6>

                    <c:forEach var="item" items="${fn:split(product.warranty, '.')}">
                        <c:if test="${not empty fn:trim(item)}">
                            <p>
                                <i class="bi bi-check-circle-fill text-success me-2"></i>
                                    ${fn:trim(item)}.
                            </p>
                        </c:if>
                    </c:forEach>
                </div>

            </div>
        </div>
    </div>

    <!-- Tabs thông tin -->
    <div class="container mt-5">
        <div class="tab-buttons d-flex justify-content-center mb-3">
            <button class="tab-btn active" id="infoBtn">Thông tin sản phẩm</button>
            <button class="tab-btn" id="specBtn">Thông số kỹ thuật</button>
        </div>

        <!-- Tab: Thông tin sản phẩm -->
        <!-- Tab: Thông tin sản phẩm -->
        <div class="tab-content p-4 bg-white rounded shadow-sm" id="infoTab">
            <c:out value="${product.description}" escapeXml="false"/>
        </div>

        <!-- Tab: Thông số kỹ thuật -->
        <div class="tab-content p-4 bg-white rounded shadow-sm d-none" id="specTab">
            <h5 class="fw-bold mb-3">Thông số kỹ thuật</h5>
            <c:out value="${product.parameter}" escapeXml="false"/>
        </div>
    </div>

    <!-- ========== ĐÁNH GIÁ SẢN PHẨM ========== -->
    <section class="review-section">
        <h4 class="review-title">ĐÁNH GIÁ SẢN PHẨM</h4>

        <div class="rating-overview">
            <div class="rating-score">
            <span class="score">
                  <i class="bi bi-star-fill"></i>
                  <fmt:formatNumber value="${avgRating}" maxFractionDigits="1"/>
            </span><small>/5</small>

                <p>${reviewCount} đánh giá</p>
            </div>

            <div class="rating-filters">
                <button class="filter-btn active" data-star="all">
                    Tất Cả (${reviewCount})
                </button>

                <button class="filter-btn" data-star="5">
                    5 Sao (${star5})
                </button>

                <button class="filter-btn" data-star="4">
                    4 Sao (${star4})
                </button>

                <button class="filter-btn" data-star="3">
                    3 Sao (${star3})
                </button>

                <button class="filter-btn" data-star="2">
                    2 Sao (${star2})
                </button>

                <button class="filter-btn" data-star="1">
                    1 Sao (${star1})
                </button>

                <button class="filter-btn" data-filter="comment">
                    Có Bình Luận (${commentCount})
                </button>
            </div>

        </div>

        <div id="review-list">
            <c:forEach var="r" items="${reviews}">
                <div class="review"
                     data-star="${r.rating}"
                     data-comment="${not empty r.content}">
                    <div class="review-avatar">
                        <img src="${r.avatar}" alt="${r.username}">
                    </div>

                    <div class="review-content">
                        <div class="review-header">
                            <span class="review-name">${r.username}</span>

                            <div class="review-stars">
                                <c:forEach begin="1" end="5" var="i">
                                    <c:choose>
                                        <c:when test="${i <= r.rating}">
                                            <i class="bi bi-star-fill"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-star"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                            </div>
                        </div>

                        <div class="review-date">
                            <fmt:formatDate value="${r.createdAt}"
                                            pattern="dd/MM/yyyy HH:mm"/>
                        </div>

                        <p class="review-text">
                                ${r.content}
                        </p>
                    </div>
                </div>
            </c:forEach>
        </div>


        <div class="pagination">

            <c:if test="${currentPage > 1}">
                <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}&page=${currentPage - 1}">
                    <button>&laquo;</button>
                </a>
            </c:if>

            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}&page=${i}">
                    <button class="${i == currentPage ? 'active' : ''}">
                            ${i}
                    </button>
                </a>
            </c:forEach>

            <c:if test="${currentPage < totalPages}">
                <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}&page=${currentPage + 1}">
                    <button>&raquo;</button>
                </a>
            </c:if>

        </div>

        <button class="write-review-btn"
                data-product-id="${product.id}">
            Viết đánh giá
        </button>
    </section>
</div>
<c:if test="${not empty relatedProducts}">
    <div class="khung-san-pham-wrapper">
        <button class="nut-chuyen prev">
            <i class="bi bi-chevron-left"></i>
        </button>
        <h2 class="section-title">Sản Phẩm Liên Quan</h2>

        <div class="khung-san-pham">

            <c:forEach items="${relatedProducts}" var="p">
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

                    <c:set var="fullStars1" value="${p.avgRating.intValue()}" />
                    <c:set var="hasHalfStar1" value="${p.avgRating - fullStars1 >= 0.5}" />
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

                        <i class="bi bi-heart tim-yeu-thich"></i>
                    </div>

                    <div class="so-danh-gia">
                        (${empty p.reviewCount ? 0 : p.reviewCount} đánh giá)
                    </div>

                    <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                        <button class="nut-mua-ngay">Mua Ngay</button>
                    </a>

                </div>
            </c:forEach>

        </div>

        <button class="nut-chuyen next">
            <i class="bi bi-chevron-right"></i>
        </button>
    </div>
</c:if>
<!-- POPUP REVIEW -->
<div class="review-popup" id="reviewPopup">
    <div class="popup-content">
        <span class="close-btn">&times;</span>
        <h2>Thêm một đánh giá</h2>
        <p class="note">
            Tài khoản email của bạn sẽ được công bố.
            Trường bắt buộc được đánh dấu <span>*</span>
        </p>

        <form class="review-form"
              id="reviewForm"
              action="${pageContext.request.contextPath}/ReviewServlet"
              method="post">
            <input type="hidden" name="product_id" value="${product.id}">
            <div class="rating-group">
                <label>
                    <input type="radio" name="rating" value="1">
                    <div class="stars">
                        <i class="bi bi-star-fill"></i>
                    </div>
                    <div>(1)</div>
                </label>
                <label>
                    <input type="radio" name="rating" value="2">
                    <div class="stars">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                    </div>
                    <div>(2)</div>
                </label>
                <label>
                    <input type="radio" name="rating" value="3" checked>
                    <div class="stars">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                    </div>
                    <div>(3)</div>
                </label>
                <label>
                    <input type="radio" name="rating" value="4">
                    <div class="stars">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
                            class="bi bi-star-fill"></i>
                    </div>
                    <div>(4)</div>
                </label>
                <label>
                    <input type="radio" name="rating" value="5">
                    <div class="stars">
                        <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i
                            class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                    </div>
                    <div>(5)</div>
                </label>
            </div>

            <div class="comment-group">
                <label for="comment-popup">Nhận xét của bạn <span>*</span></label>
                <textarea id="comment-popup"
                          name="content"
                          placeholder="Viết nhận xét tại đây..."
                          required></textarea>
            </div>

            <button type="submit" class="submit-btn">Xác Nhận</button>
        </form>
    </div>
</div>
<jsp:include page="/page/footer.jsp"/>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Chuyển ảnh chính
    const thumbs = document.querySelectorAll('.thumb');
    const displayImg = document.getElementById('displayImg');
    let currentIndex = 0;

    function updateMainImage(index) {
        thumbs.forEach(t => t.classList.remove('active'));
        thumbs[index].classList.add('active');
        displayImg.src = thumbs[index].src;
    }

    thumbs.forEach((thumb, idx) => {
        thumb.addEventListener('click', () => {
            currentIndex = idx;
            updateMainImage(currentIndex);
        });
    });

    document.querySelector('.prev-btn').addEventListener('click', () => {
        currentIndex = (currentIndex - 1 + thumbs.length) % thumbs.length;
        updateMainImage(currentIndex);
    });

    document.querySelector('.next-btn').addEventListener('click', () => {
        currentIndex = (currentIndex + 1) % thumbs.length;
        updateMainImage(currentIndex);
    });


    document.querySelectorAll('.tim-yeu-thich').forEach(btn => {
        btn.addEventListener('click', () => {
            btn.classList.toggle('liked');

            // chỉ đổi icon, không ảnh hưởng layout
            if (btn.classList.contains('bi-heart')) {
                btn.classList.replace('bi-heart', 'bi-heart-fill');
            } else {
                btn.classList.replace('bi-heart-fill', 'bi-heart');
            }
        });
    });

    // Tabs
    const infoBtn = document.getElementById("infoBtn");
    const specBtn = document.getElementById("specBtn");
    const infoTab = document.getElementById("infoTab");
    const specTab = document.getElementById("specTab");

    infoBtn.addEventListener("click", () => {
        infoBtn.classList.add("active");
        specBtn.classList.remove("active");
        infoTab.classList.remove("d-none");
        specTab.classList.add("d-none");
    });

    specBtn.addEventListener("click", () => {
        specBtn.classList.add("active");
        infoBtn.classList.remove("active");
        specTab.classList.remove("d-none");
        infoTab.classList.add("d-none");
    });
</script>
<script>
    // ====== JS lọc đánh giá theo số sao ======
    const filterButtons = document.querySelectorAll('.filter-btn');
    const reviews = document.querySelectorAll('.review');

    filterButtons.forEach(button => {
        button.addEventListener('click', () => {
            filterButtons.forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');

            const star = button.getAttribute('data-star');
            reviews.forEach(review => {
                if (star === 'all' || review.getAttribute('data-star') === star) {
                    review.style.display = 'flex';
                } else {
                    review.style.display = 'none';
                }
            });
        });
    });
</script>
<script>
    const khung = document.querySelector('.khung-san-pham');
    const prevBtn = document.querySelector('.nut-chuyen.prev');
    const nextBtn = document.querySelector('.nut-chuyen.next');

    nextBtn.addEventListener('click', () => {
        khung.scrollBy({left: 300, behavior: 'smooth'});
    });

    prevBtn.addEventListener('click', () => {
        khung.scrollBy({left: -300, behavior: 'smooth'});
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
<script src="${pageContext.request.contextPath}/js/review.js"></script>
<script>
    const minusBtn = document.getElementById('minus');
    const plusBtn = document.getElementById('plus');
    const qtyInput = document.getElementById('qty');
    const quantityHidden = document.getElementById('quantityHidden');

    minusBtn.addEventListener('click', () => {
        let val = parseInt(qtyInput.value);
        if (val > 1) {
            qtyInput.value = val - 1;
            quantityHidden.value = qtyInput.value;
        }
    });

    plusBtn.addEventListener('click', () => {
        let val = parseInt(qtyInput.value);
        qtyInput.value = val + 1;
        quantityHidden.value = qtyInput.value;
    });
</script>


</body>
</html>
