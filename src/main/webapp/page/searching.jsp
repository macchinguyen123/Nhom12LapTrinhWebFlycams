<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Tìm kiếm</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS Riêng -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/searching.css">
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>

<jsp:include page="/page/header.jsp"/>

<!-- Sản phẩm nổi bật -->
<section class="phan-san-pham">
    <h2 class="tieu-de-muc">Kết quả tìm kiếm: "${keyword}"</h2>
    <p class="so-luong-tim">
        Đã tìm được ${fn:length(products)} sản phẩm
    </p>

    <c:if test="${empty products}">
        <p>Không tìm thấy sản phẩm nào.</p>
    </c:if>
    <form action="<c:url value='/Searching' />" method="get" id="filterForm">

        <!-- GIỮ LẠI KEYWORD -->
        <input type="hidden" name="keyword" value="${keyword}">

        <div class="bo-loc-va-sap-xep position-relative">

            <!-- Nút Bộ lọc -->
            <button type="button" class="nut-bo-loc btn btn-outline-primary">
                <i class="bi bi-funnel"></i> Bộ lọc
            </button>

            <!-- Cửa sổ xổ xuống -->
            <div class="hop-loc" id="hop-loc">
                <h6><i class="bi bi-funnel"></i> Lọc theo giá</h6>
                <hr class="my-2">

                <!-- Các khoảng giá -->
                <div class="danh-sach-loc">

                    <label>
                        <input type="radio" name="chon-gia" value="tat-ca"
                               <c:if test="${param['chon-gia'] == 'tat-ca'}">checked</c:if>>
                        Tất cả
                    </label>

                    <label>
                        <input type="radio" name="chon-gia" value="duoi-5000000"
                               <c:if test="${param['chon-gia'] == 'duoi-5000000'}">checked</c:if>>
                        Dưới 5.000.000 ₫
                    </label>

                    <label>
                        <input type="radio" name="chon-gia" value="5-10"
                               <c:if test="${param['chon-gia'] == '5-10'}">checked</c:if>>
                        5.000.000 ₫ - 10.000.000 ₫
                    </label>

                    <label>
                        <input type="radio" name="chon-gia" value="10-20"
                               <c:if test="${param['chon-gia'] == '10-20'}">checked</c:if>>
                        10.000.000 ₫ - 20.000.000 ₫
                    </label>

                    <label>
                        <input type="radio" name="chon-gia" value="tren-20"
                               <c:if test="${param['chon-gia'] == 'tren-20'}">checked</c:if>>
                        Trên 20.000.000 ₫
                    </label>

                    <p><b>Nhập vào khoảng giá bạn muốn</b></p>

                    <div class="d-flex align-items-center gap-1">
                        <input type="number" name="gia-tu" id="gia-tu"
                               class="form-control form-control-sm"
                               value="${param['gia-tu']}"
                               placeholder="Từ ₫" style="width: 100px;">

                        <span>-</span>

                        <input type="number" name="gia-den" id="gia-den"
                               class="form-control form-control-sm"
                               value="${param['gia-den']}"
                               placeholder="Đến ₫" style="width: 100px;">
                    </div>

                    <!-- Lọc theo thương hiệu -->
                    <hr class="my-2">
                    <h6><i class="bi bi-box"></i> Lọc theo thương hiệu</h6>
                    <hr class="my-2">

                    <div class="row mt-2">

                        <div class="col-6">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="chon-thuong-hieu" value="DJI"
                                       <c:if test="${fn:contains(paramValues['chon-thuong-hieu'], 'DJI')}">checked</c:if>>
                                <label class="form-check-label">DJI</label>
                            </div>

                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="chon-thuong-hieu" value="Autel Robotics"
                                       <c:if test="${fn:contains(paramValues['chon-thuong-hieu'], 'Autel Robotics')}">checked</c:if>>
                                <label class="form-check-label">Autel Robotics</label>
                            </div>

                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="chon-thuong-hieu" value="Parrot"
                                       <c:if test="${fn:contains(paramValues['chon-thuong-hieu'], 'Parrot')}">checked</c:if>>
                                <label class="form-check-label">Parrot</label>
                            </div>
                        </div>

                        <div class="col-6">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="chon-thuong-hieu" value="Skydio"
                                       <c:if test="${fn:contains(paramValues['chon-thuong-hieu'], 'Skydio')}">checked</c:if>>
                                <label class="form-check-label">Skydio</label>
                            </div>

                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="chon-thuong-hieu" value="Xiaomi"
                                       <c:if test="${fn:contains(paramValues['chon-thuong-hieu'], 'Xiaomi')}">checked</c:if>>
                                <label class="form-check-label">Xiaomi</label>
                            </div>

                            <div class="form-check">
                                <input class="form-check-input" type="checkbox"
                                       name="chon-thuong-hieu" value="Khác"
                                       <c:if test="${fn:contains(paramValues['chon-thuong-hieu'], 'Khác')}">checked</c:if>>
                                <label class="form-check-label">Khác</label>
                            </div>
                        </div>

                    </div>

                    <button type="submit" class="btn btn-sm btn-primary mt-2">Áp dụng</button>
                </div>

            </div>

            <!-- Nhóm sắp xếp -->
            <div class="sap-xep-theo">
                <span class="label">Sắp xếp theo:</span>

                <button type="submit" name="sort" value="default"
                        class="btn-sap-xep ${param.sort == 'default' || param.sort == null ? 'active' : ''}">
                    Nổi bật
                </button>

                <button type="submit" name="sort" value="low-high"
                        class="btn-sap-xep ${param.sort == 'low-high' ? 'active' : ''}">
                    <i class="bi bi-filter"></i> Giá Thấp - Cao
                </button>

                <button type="submit" name="sort" value="high-low"
                        class="btn-sap-xep ${param.sort == 'high-low' ? 'active' : ''}">
                    <i class="bi bi-filter"></i> Giá Cao - Thấp
                </button>
            </div>

        </div>

    </form>


    <div class="khung-san-pham">
        <c:forEach var="p" items="${products}">
            <div class="san-pham">
                <!-- Bọc toàn bộ phần chính bằng link tới chi tiết (nếu có id sản phẩm) -->
                <a href="${pageContext.request.contextPath}/product-details.jsp?id=${p.id}">
                    <!-- Ảnh -->
                    <c:choose>
                        <c:when test="${not empty p.mainImage}">
                            <img src="${p.mainImage}" alt="${p.productName}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/no-image.png" alt="No Image">
                        </c:otherwise>
                    </c:choose>

                    <!-- Tên sản phẩm -->
                    <h3 class="ten-san-pham">${p.productName}</h3>

                    <!-- Giá (luôn hiển thị div.gia giống mẫu) -->
                    <div class="gia">
                        <b>  ${formatter.format(p.finalPrice)} ₫</b>
                        <c:if test="${p.price >= p.finalPrice}">
                            <span class="gia-goc">  ${formatter.format(p.price)} ₫</span>
                        </c:if>
                    </div>
                </a>

                <!-- Đánh giá mẫu -->
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

                <!-- Số đánh giá -->
                <div class="so-danh-gia">(12 đánh giá)</div>

                <!-- Nút mua ngay (có thể là form/post hoặc link) -->
                <button class="nut-mua-ngay">Mua Ngay</button>
            </div>
        </c:forEach>
    </div>
</section>

<jsp:include page="/page/footer.jsp"/>

<!-- JS: tim rỗng -> tim đỏ đầy -->
<script>
    document.querySelectorAll('.tim-yeu-thich').forEach(tim => {
        tim.addEventListener('click', () => {
            if (tim.classList.contains('bi-heart')) {
                // đổi sang tim đầy màu đỏ
                tim.classList.remove('bi-heart');
                tim.classList.add('bi-heart-fill', 'yeu-thich');
            } else {
                // đổi ngược lại tim rỗng
                tim.classList.remove('bi-heart-fill', 'yeu-thich');
                tim.classList.add('bi-heart');
            }
        });
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
<script>
    // === Hiện / Ẩn cửa sổ bộ lọc ===
    const nutBoLoc = document.querySelector('.nut-bo-loc');
    const hopLoc = document.getElementById('hop-loc');

    const radioLocGia = document.getElementsByName('chon-gia');
    const inputTu = document.getElementById('gia-tu');
    const inputDen = document.getElementById('gia-den');
    const btnApDung = document.getElementById('btn-ap-dung-gia');

    // Toggle cửa sổ khi nhấn nút "Bộ lọc"
    nutBoLoc.addEventListener('click', () => {
        hopLoc.classList.toggle('hien');
    });

    // Ẩn khi click ra ngoài
    document.addEventListener('click', (e) => {
        if (!hopLoc.contains(e.target) && !nutBoLoc.contains(e.target)) {
            hopLoc.classList.remove('hien');
        }
    });

    // Nếu người dùng nhập giá bằng tay -> bỏ chọn radio "khoảng giá"
    inputTu.addEventListener('input', () => {
        radioLocGia.forEach(r => r.checked = false);
    });
    inputDen.addEventListener('input', () => {
        radioLocGia.forEach(r => r.checked = false);
    });

    // Khi nhấn Áp dụng -> gửi form
    btnApDung.addEventListener('click', () => {
        document.getElementById('filterForm').submit();
    });
    inputTu.addEventListener('input', () => {
        document.querySelectorAll("input[name='chon-gia']").forEach(r => r.checked = false);
    });
    inputDen.addEventListener('input', () => {
        document.querySelectorAll("input[name='chon-gia']").forEach(r => r.checked = false);
    });

</script>

</body>
</html>
