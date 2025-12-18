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
                    <a href="shoppingcart.jsp">
                        <button class="btn-add-cart">
                            <i class="bi bi-cart-fill"></i> Thêm Vào Giỏ Hàng
                        </button>
                    </a>
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
                  <i class="bi bi-star-fill"></i> ${avgRating}
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
<div class="khung-san-pham-wrapper">
    <button class="nut-chuyen prev"><i class="bi bi-chevron-left"></i></button>
    <div class="khung-san-pham">

        <!-- === SẢN PHẨM 1 === -->
        <div class="san-pham">
            <a href="product-details.html"><img src="../image/content/Flycam%20DJI%20Air%203.png" alt="FlycamDJlAir3">

                <h3 class="ten-san-pham">Flycam DJI Air 3</h3>
                <div class="gia"><b>25.000.000 ₫</b>
                    <span class="gia-goc">29.990.000 ₫</span>
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

            <div class="so-danh-gia">(120 đánh giá)</div>

            <a href="product-details.html">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 2 === -->
        <div class="san-pham">
            <a href="product-details.html"><img src="../image/content/Flycam%20DJl%20Inspire%203.png"
                                                alt="FlycamDJlInspire3">
                <h3 class="ten-san-pham">Flycam DJl Inspire 3</h3>
                <div class="gia"><b>9.990.000 ₫</b>
                    <span class="gia-goc">12.500.000 ₫</span>
                </div>
            </a>

            <div class="hang-danh-gia">
                <div class="danh-gia-sao">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star"></i>
                </div>
                <i class="bi bi-heart tim-yeu-thich"></i>
            </div>

            <div class="so-danh-gia">(98 đánh giá)</div>

            <a href="product-details.html">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 3 === -->
        <div class="san-pham">
            <a href="product-details.html"><img
                    src="../image/content/DJI%20Mavic%203%20Pro%20With%20DJI%20RC%20Remote.png"
                    alt="DJIMavic3ProWithDJIRCRemote">
                <h3 class="ten-san-pham">DJI Mavic 3 Pro With DJI RC Remote</h3>
                <div class="gia"><b>49.990.000 ₫</b>
                    <span class="gia-goc">55.000.000 ₫</span>
                </div>
            </a>

            <div class="hang-danh-gia">
                <div class="danh-gia-sao">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star"></i>
                </div>
                <i class="bi bi-heart tim-yeu-thich"></i>
            </div>

            <div class="so-danh-gia">(80 đánh giá)</div>

            <a href="product-details.html">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 4 === -->
        <div class="san-pham">
            <a href="product-details.html"><img src="../image/content/Flycam%20DJI%20Mavic%20Mini%20SE%20Combo.png"
                                                alt="FlycamDJIMavicMiniSECombo">
                <h3 class="ten-san-pham">Flycam DJI Mavic Mini SE Combo</h3>
                <div class="gia"><b>29.290.000 ₫</b>
                    <span class="gia-goc">31.000.000 ₫</span>
                </div>
            </a>

            <div class="hang-danh-gia">
                <div class="danh-gia-sao">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star"></i>
                </div>
                <i class="bi bi-heart tim-yeu-thich"></i>
            </div>

            <div class="so-danh-gia">(65 đánh giá)</div>

            <a href="product-details.html">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 5 === -->
        <div class="san-pham">
            <a href="product-details.html"><img src="../image/content/DJI%20Mini%203.png" alt="DJlMini3">

                <h3 class="ten-san-pham">DJl Mini 3</h3>
                <div class="gia"><b>8.990.000 ₫</b>
                    <span class="gia-goc">10.900.000 ₫</span>
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

            <div class="so-danh-gia">(79 đánh giá)</div>

            <a href="product-details.html">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 6 === -->
        <div class="san-pham">
            <a href="product-details.html"><img src="../image/content/DJI%20Flip.png" alt="DJlFlip">

                <h3 class="ten-san-pham">DJl Flip</h3>
                <div class="gia"><b>10.490.000 ₫</b>
                    <span class="gia-goc">11.000.000 ₫</span>
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

            <div class="so-danh-gia">(53 đánh giá)</div>

            <a href="product-details.html">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 7 === -->
        <div class="san-pham">
            <a href="product-details.html"><img src="../image/content/DJI%20Mini%205%20Pro.png" alt="DJlMini5Pro">

                <h3 class="ten-san-pham">DJl Mini 5 Pro</h3>
                <div class="gia"><b>18.590.000 ₫</b>
                    <span class="gia-goc">19.590.000 ₫</span>
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

            <div class="so-danh-gia">(39 đánh giá)</div>

            <a href="product-details.html">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 8 === -->
        <div class="san-pham">
            <a href="product-details.html"><img src="../image/content/DJI%20Mini%204K.png" alt="DJlMini4K">

                <h3 class="ten-san-pham">DJI Mini 4K</h3>
                <div class="gia"><b>9.607.000 ₫</b>
                    <span class="gia-goc">7.990.000 ₫</span>
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

            <div class="so-danh-gia">(39 đánh giá)</div>

            <a href="product-details.html">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 9 === -->
        <div class="san-pham">
            <a href="product-details.html"><img
                    src="../image/filmProduct/Flycam%20DJI%20Mini%203%20With%20DJI%20RC%20Remote%20Controller.png"
                    alt="FlycamDJIMini3WithDJIRCRemoteController">

                <h3 class="ten-san-pham">Flycam DJI Mini 3 With DJI RC Remote Controller</h3>
                <div class="gia"><b>14.290.000 ₫</b>
                    <span class="gia-goc">15.990.000 ₫</span>
                </div>
            </a>

            <div class="hang-danh-gia">
                <div class="danh-gia-sao">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star"></i>
                </div>
                <i class="bi bi-heart tim-yeu-thich"></i>
            </div>

            <div class="so-danh-gia">(87 đánh giá)</div>

            <a href="product-details.html">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>


        <!-- === SẢN PHẨM 10 === -->
        <div class="san-pham">
            <a href="product-details.html"><img src="../image/filmProduct/Flycam%20DJI%20O4%20Air%20Unit.png"
                                                alt="FlycamDJIO4AirUnit">

                <h3 class="ten-san-pham">Flycam DJI O4 Air Unit</h3>
                <div class="gia"><b>2.505.000 ₫</b>
                    <span class="gia-goc">3.600.000 ₫</span>
                </div>
            </a>

            <div class="hang-danh-gia">
                <div class="danh-gia-sao">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star"></i>
                </div>
                <i class="bi bi-heart tim-yeu-thich"></i>
            </div>

            <div class="so-danh-gia">(71 đánh giá)</div>

            <a href="product-details.html">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

    </div>
    <button class="nut-chuyen next"><i class="bi bi-chevron-right"></i></button>
</div>
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

    // Tăng giảm số lượng
    const minusBtn = document.getElementById('minus');
    const plusBtn = document.getElementById('plus');
    const qty = document.getElementById('qty');

    minusBtn.addEventListener('click', () => {
        let val = parseInt(qty.value);
        if (val > 1) qty.value = val - 1;
    });

    plusBtn.addEventListener('click', () => {
        let val = parseInt(qty.value);
        qty.value = val + 1;
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
</body>
</html>
