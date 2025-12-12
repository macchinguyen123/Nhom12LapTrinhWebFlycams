<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
    <p class="so-luong-tim">Đã tìm được 8 sản phẩm</p>

    <c:if test="${empty products}">
        <p>Không tìm thấy sản phẩm nào.</p>
    </c:if>
    <div class="bo-loc-va-sap-xep position-relative">

        <!-- Nút Bộ lọc -->
        <button class="nut-bo-loc btn btn-outline-primary">
            <i class="bi bi-funnel"></i> Bộ lọc
        </button>

        <!-- Cửa sổ xổ xuống -->
        <div class="hop-loc" id="hop-loc">
            <h6><i class="bi bi-funnel"></i> Lọc theo giá</h6>
            <hr class="my-2">

            <!-- Các khoảng giá -->
            <div class="danh-sach-loc">
                <label><input type="radio" name="chon-gia" value="tat-ca" checked> Tất cả</label>
                <label><input type="radio" name="chon-gia" value="duoi-5000000"> Dưới 5.000.000 ₫</label>
                <label><input type="radio" name="chon-gia" value="5-10"> 5.000.000 ₫ - 10.000.000 ₫</label>
                <label><input type="radio" name="chon-gia" value="10-20"> 10.000.000 ₫ - 20.000.000 ₫</label>
                <label><input type="radio" name="chon-gia" value="tren-20"> Trên 20.000.000 ₫</label>
                <p><b>Nhập vào khoảng giá bạn muốn</b></p>
                <div class="d-flex align-items-center gap-1">
                    <input type="number" id="gia-tu" class="form-control form-control-sm" placeholder="Từ ₫"
                           style="width: 100px;">
                    <span>-</span>
                    <input type="number" id="gia-den" class="form-control form-control-sm" placeholder="Đến ₫"
                           style="width: 100px;">
                </div>
                <!-- Lọc theo thương hiệu -->
                <hr class="my-2">
                <h6><i class="bi bi-box"></i> Lọc theo thương hiệu</h6>
                <hr class="my-2">
                <div class="row mt-2">

                    <!-- Cột 1 -->
                    <div class="col-6">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="brandDJI" name="chon-thuong-hieu"
                                   value="DJI">
                            <label class="form-check-label" for="brandDJI">DJI</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="brandAutel" name="chon-thuong-hieu"
                                   value="Autel Robotics">
                            <label class="form-check-label" for="brandAutel">Autel Robotics</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="brandParrot" name="chon-thuong-hieu"
                                   value="Parrot">
                            <label class="form-check-label" for="brandParrot">Parrot</label>
                        </div>
                    </div>

                    <!-- Cột 2 -->
                    <div class="col-6">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="brandSkydio" name="chon-thuong-hieu"
                                   value="Skydio">
                            <label class="form-check-label" for="brandSkydio">Skydio</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="brandXiaomi" name="chon-thuong-hieu"
                                   value="Xiaomi">
                            <label class="form-check-label" for="brandXiaomi">Xiaomi</label>
                        </div>

                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="brandOther" name="chon-thuong-hieu"
                                   value="Khác">
                            <label class="form-check-label" for="brandOther">Khác</label>
                        </div>
                    </div>

                </div>
                <button id="btn-ap-dung-gia" class="btn btn-sm btn-primary mt-2">Áp dụng</button>
            </div>


        </div>


        <!-- Nhóm sắp xếp -->
        <div class="sap-xep-theo">
            <span class="label">Sắp xếp theo:</span>
            <button class="btn-sap-xep active">Nổi bật</button>
            <button class="btn-sap-xep">
                <i class="bi bi-filter"></i> Giá Thấp - Cao
            </button>
            <button class="btn-sap-xep">
                <i class="bi bi-filter"></i> Giá Cao - Thấp
            </button>
        </div>
    </div>


    <div class="khung-san-pham">

        <!-- === SẢN PHẨM 1 === -->
        <div class="san-pham">
            <a href="product-details.jsp">
                <img src="../image/content/Flycam%20DJI%20Air%203.png" alt="FlycamDJlAir3">

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
            <a href="product-details.jsp">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 2 === -->
        <div class="san-pham">
            <a href="product-details.jsp">
                <img src="../image/content/Flycam%20DJl%20Inspire%203.png" alt="FlycamDJlInspire3">
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
            <a href="product-details.jsp">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 3 === -->
        <div class="san-pham">
            <a href="product-details.jsp">
                <img src="../image/content/DJI%20Mavic%203%20Pro%20With%20DJI%20RC%20Remote.png" alt="DJIMavic3ProWithDJIRCRemote">
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
            <a href="product-details.jsp">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 4 === -->
        <div class="san-pham">
            <a href="product-details.jsp">
                <img src="../image/content/Flycam%20DJI%20Mavic%20Mini%20SE%20Combo.png" alt="FlycamDJIMavicMiniSECombo">
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
            <a href="product-details.jsp">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 5 === -->
        <div class="san-pham">
            <a href="product-details.jsp">
                <img src="../image/content/DJI%20Mini%203.png" alt="DJlMini3">

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
            <a href="product-details.jsp">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 6 === -->
        <div class="san-pham">
            <a href="product-details.jsp">
                <img src="../image/content/DJI%20Flip.png" alt="DJlFlip">

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
            <a href="product-details.jsp">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 7 === -->
        <div class="san-pham">
            <a href="product-details.jsp">

                <img src="../image/content/DJI%20Mini%205%20Pro.png" alt="DJlMini5Pro">

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
            <a href="product-details.jsp">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

        <!-- === SẢN PHẨM 8 === -->
        <div class="san-pham">
            <a href="product-details.jsp">
                <img src="../image/content/DJI%20Mini%204K.png" alt="DJlMini4K">

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
            <a href="product-details.jsp">
                <button class="nut-mua-ngay">Mua Ngay</button>
            </a>
        </div>

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
    // === Hiện / Ẩn cửa sổ bộ lọc ===
    const nutBoLoc = document.querySelector('.nut-bo-loc');
    const hopLoc = document.getElementById('hop-loc');
    const radioLocGia = document.getElementsByName('chon-gia');
    const nhapGiaDiv = document.getElementById('nhap-gia-tuy-chinh');
    const btnApDung = document.getElementById('btn-ap-dung-gia');
    const inputTu = document.getElementById('gia-tu');
    const inputDen = document.getElementById('gia-den');

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
