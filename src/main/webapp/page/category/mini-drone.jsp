<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--<jsp:useBean id="category" scope="request" type="vn.edu.hcmuaf.fit.nhom12laptrinhwebflycams.model.Categories"/>--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Danh Mục</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS riêng -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/common-category.css">
</head>
<body>
<jsp:include page="/page/header.jsp"/>

<section class="phan-san-pham">
    <h2 class="tieu-de-muc">${category.categoryName}</h2>

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


    <!-- Lưới sản phẩm -->
    <div class="khung-san-pham">
        <c:forEach var="p" items="${products}">
            <div class="san-pham">
                <!-- Bọc toàn bộ phần chính bằng link tới chi tiết (nếu có id sản phẩm) -->
                <a href="${pageContext.request.contextPath}/product-details.jsp?id=${p.id}">
                    <!-- Ảnh -->
                    <c:choose>
                        <c:when test="${not empty p.images}">
                            <img src="${p.images[0].imageUrl}" alt="${p.productName}">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/assets/no-image.png" alt="No Image">
                        </c:otherwise>
                    </c:choose>

                    <!-- Tên sản phẩm -->
                    <h3 class="ten-san-pham">${p.productName}</h3>

                    <!-- Giá (luôn hiển thị div.gia giống mẫu) -->
                    <div class="gia">
                        <b>${p.finalPrice} ₫</b>
                        <c:if test="${p.price >= p.finalPrice}">
                        <span class="gia-goc">${p.price} ₫</span>
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
    <!-- PHÂN TRANG -->
    <div class="phan-trang text-center mt-4">
        <button class="btn btn-outline-primary nut-truoc">« Trang trước</button>
        <span class="so-trang-hien-tai mx-3">Trang <span id="trang-hien-tai">1</span> / <span
                id="tong-trang"></span></span>
        <button class="btn btn-outline-primary nut-sau">Trang sau »</button>
    </div>


</section>
<jsp:include page="/page/footer.jsp"/>
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

    // === Nút yêu thích (giữ nguyên) ===
    document.querySelectorAll('.tim-yeu-thich').forEach(tim => {
        tim.addEventListener('click', () => {
            tim.classList.toggle('bi-heart');
            tim.classList.toggle('bi-heart-fill');
            tim.classList.toggle('yeu-thich');
        });
    });
    // === Chọn nút sắp xếp ===
    const nutSapXep = document.querySelectorAll('.btn-sap-xep');
    nutSapXep.forEach(btn => {
        btn.addEventListener('click', () => {
            nutSapXep.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            console.log("🔹 Đã chọn:", btn.textContent.trim());
        });
    });
    const sanPhams = document.querySelectorAll('.san-pham');
    const spMoiTrang = 20; // số sản phẩm mỗi trang
    let trangHienTai = 1;
    const tongTrang = Math.ceil(sanPhams.length / spMoiTrang);

    const spanTrang = document.getElementById('trang-hien-tai');
    const spanTongTrang = document.getElementById('tong-trang');
    spanTongTrang.textContent = tongTrang;

    function hienThiTrang(trang) {
        sanPhams.forEach((sp, index) => {
            if (index >= (trang - 1) * spMoiTrang && index < trang * spMoiTrang) {
                sp.style.display = ''; // giữ nguyên layout gốc (grid/flex)
                sp.style.visibility = 'visible';
            } else {
                sp.style.display = 'none'; // ẩn hẳn phần tử ngoài trang hiện tại
            }

        });
        spanTrang.textContent = trang;
    }

    document.querySelector('.nut-truoc').addEventListener('click', () => {
        if (trangHienTai > 1) {
            trangHienTai--;
            hienThiTrang(trangHienTai);
        }
    });

    document.querySelector('.nut-sau').addEventListener('click', () => {
        if (trangHienTai < tongTrang) {
            trangHienTai++;
            hienThiTrang(trangHienTai);
        }
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
    // Hiển thị trang đầu tiên khi tải trang
    hienThiTrang(trangHienTai);


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
