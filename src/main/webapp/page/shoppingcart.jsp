<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:set var="cart" value="${sessionScope.cart}"/>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8"/>
    <title>Giỏ hàng Flycam</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">

    <link rel="stylesheet" href="../stylesheets/shoppingcart.css">
</head>

<body>
<jsp:include page="/page/header.jsp"/>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


<div class="gio-hang">
    <!-- Bao toàn bộ phần giỏ hàng -->
    <div class="gio-hang-noi-dung">
        <div class="container py-4">
            <!-- nội dung giỏ hàng -->

            <!-- Nút quay lại trang chủ -->
            <div class="mb-3">
                <h3 class="text-center mb-4 fw-bold text-primary">Giỏ hàng của bạn</h3>
            </div>


            <!-- Thanh công cụ -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="chon_tat_ca">
                    <label for="chon_tat_ca" class="form-check-label">Chọn tất cả</label>
                </div>
                <button type="button" class="btn btn-outline-danger btn-sm nut_xoa_da_chon">
                    <i class="bi bi-trash"></i> Xóa sản phẩm đã chọn
                </button>
            </div>

            <!-- Danh sách sản phẩm -->
            <div id="danh_sach_san_pham">
                <c:if test="${empty cart or empty cart.items}">
                    <p class="text-center text-muted">Giỏ hàng trống</p>
                </c:if>

                <c:forEach var="item" items="${cart.items}">
                    <div class="khung_san_pham d-flex justify-content-between align-items-center
            border rounded shadow-sm p-3 mb-3 bg-white" data-id="${item.product.id}">

                        <!-- TRÁI: checkbox + ảnh + info -->
                        <div class="d-flex align-items-center gap-3">
                            <input type="checkbox" class="chon_san_pham form-check-input me-3">
                            <a
                                    href="${pageContext.request.contextPath}/product-detail?id=${item.product.id}">
                                <img src="${not empty item.product.images
          ? item.product.images[0].imageUrl
          : pageContext.request.contextPath.concat('/image/no-image.png')}" class="anh_san_pham me-3">
                            </a>
                            <div>
                                <h6 class="ten_san_pham mb-1 fw-semibold text-truncate"
                                    style="max-width: 260px;">
                                        ${item.product.productName}
                                </h6>

                                <span class="gia_hien_tai text-danger fw-bold">
                                                        <fmt:formatNumber value="${item.product.finalPrice}"
                                                                          type="number"/> ₫
                                                    </span>
                            </div>
                        </div>

                        <!-- PHẢI: số lượng -->
                        <div class="d-flex align-items-center gap-2">

                            <button class="btn btn-outline-secondary btn-sm nut_giam">−</button>

                            <input type="text" class="form-control text-center o_so_luong mx-1"
                                   value="${item.quantity}" style="width:50px;" readonly>

                            <button class="btn btn-outline-secondary btn-sm nut_tang">+</button>
                            <!-- ICON XÓA -->
                            <button class="btn btn-outline-danger btn-sm nut_xoa_1"
                                    title="Xóa sản phẩm">
                                <i class="bi bi-trash"></i>
                            </button>

                        </div>
                    </div>

                </c:forEach>
            </div>

            <!-- Tổng tiền -->
            <div class="card p-3 shadow-sm">
                <div class="d-flex justify-content-between">
                    <span class="fw-bold">Tạm tính:</span>
                    <span class="so_tien">0 ₫</span>
                </div>
                <hr>
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="tong_cong text-danger m-0">Tổng cộng: 0 ₫</h5>
                    <button type="button" class="btn btn-primary nut_thanh_toan" id="btnMuaNgay">
                        Mua ngay
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="/page/footer.jsp"/>
<script>


    // ============================================
    // KHỞI TẠO BIẾN
    // ============================================
    const chonTatCa = document.getElementById("chon_tat_ca");
    const nutXoaDaChon = document.querySelector(".nut_xoa_da_chon");
    const danhSach = document.getElementById("danh_sach_san_pham");

    function dinhDangTien(vnd) {
        return vnd.toLocaleString("vi-VN") + " ₫";
    }

    function capNhatTongTien() {
        let tong = 0;
        document.querySelectorAll(".khung_san_pham").forEach(sp => {
            const check = sp.querySelector(".chon_san_pham");
            if (check && check.checked) {
                const giaText = sp.querySelector(".gia_hien_tai")
                    .textContent.replace(/[^\d]/g, "");
                const soLuong = parseInt(sp.querySelector(".o_so_luong").value);
                tong += parseInt(giaText) * soLuong;
            }
        });

        document.querySelector(".so_tien").textContent = dinhDangTien(tong);
        document.querySelector(".tong_cong").textContent =
            "Tổng cộng: " + dinhDangTien(tong);
    }

    // ✅ Chọn tất cả
    chonTatCa.addEventListener("change", () => {
        document.querySelectorAll(".chon_san_pham")
            .forEach(cb => cb.checked = chonTatCa.checked);
        capNhatTongTien();
    });

    // ✅ Tick / tăng giảm số lượng
    danhSach.addEventListener("click", e => {
        const sp = e.target.closest(".khung_san_pham");
        if (!sp) return;

        // tăng / giảm
        if (e.target.classList.contains("nut_tang") ||
            e.target.classList.contains("nut_giam")) {

            const input = sp.querySelector(".o_so_luong");
            let soLuong = parseInt(input.value);

            if (e.target.classList.contains("nut_tang")) soLuong++;
            else if (soLuong > 1) soLuong--;

            const productId = sp.dataset.id;

            // Cập nhật lên server
            fetch("${pageContext.request.contextPath}/UpdateCartQuantity", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: "productId=" + productId + "&quantity=" + soLuong
            }).then(res => {
                if (res.ok) {
                    input.value = soLuong;
                    capNhatTongTien();
                } else {
                    alert("Cập nhật số lượng thất bại!");
                }
            }).catch(err => {
                console.error("Error updating quantity:", err);
                alert("Có lỗi xảy ra khi cập nhật số lượng.");
            });
        }

        // tick checkbox
        if (e.target.classList.contains("chon_san_pham")) {
            const tong = document.querySelectorAll(".chon_san_pham").length;
            const daChon = document.querySelectorAll(".chon_san_pham:checked").length;
            chonTatCa.checked = (tong === daChon);
            capNhatTongTien();
        }
    });

    // ✅ XÓA 1 SẢN PHẨM
    danhSach.addEventListener("click", e => {
        if (e.target.closest(".nut_xoa_1")) {

            const sp = e.target.closest(".khung_san_pham");
            const productId = sp.dataset.id;

            fetch("${pageContext.request.contextPath}/RemoveFromCart", {
                method: "POST",
                headers: {"Content-Type": "application/x-www-form-urlencoded"},
                body: "productId=" + productId
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        sp.remove();
                        capNhatTongTien();
                        if (typeof updateCartBadge === 'function') {
                            updateCartBadge(data.cartSize);
                        }
                        showNotification('Đã xóa sản phẩm', 'success');
                    } else {
                        showNotification('Xóa thất bại', 'error');
                    }
                });
        }
    });

    // ✅ XÓA CÁC SẢN PHẨM ĐÃ CHỌN
    nutXoaDaChon.addEventListener("click", () => {
        const ids = [];

        document.querySelectorAll(".chon_san_pham:checked").forEach(cb => {
            const sp = cb.closest(".khung_san_pham");
            ids.push(sp.dataset.id);
        });

        if (ids.length === 0) {
            showNotification('Bạn chưa chọn sản phẩm nào', 'error');
            return;
        }

        const body = ids.map(id => "productIds[]=" + id).join("&");

        fetch("${pageContext.request.contextPath}/RemoveMultiFromCart", {
            method: "POST",
            headers: {"Content-Type": "application/x-www-form-urlencoded"},
            body: body
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    document.querySelectorAll(".chon_san_pham:checked").forEach(cb => {
                        cb.closest(".khung_san_pham").remove();
                    });
                    capNhatTongTien();
                    if (typeof updateCartBadge === 'function') {
                        updateCartBadge(data.cartSize);
                    }
                    showNotification('Đã xóa sản phẩm đã chọn', 'success');
                } else {
                    showNotification('Xóa thất bại', 'error');
                }
            });
    });

    // gọi khi load trang
    window.addEventListener("load", capNhatTongTien);
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
    document.getElementById("btnMuaNgay").addEventListener("click", () => {

        const checked = document.querySelectorAll(".chon_san_pham:checked");
        if (checked.length === 0) {
            showNotification('Vui lòng chọn ít nhất 1 sản phẩm', 'error');
            return;
        }

        const form = document.createElement("form");
        form.method = "POST";
        form.action = "${pageContext.request.contextPath}/BuyNowFromCart";

        checked.forEach(cb => {
            const sp = cb.closest(".khung_san_pham");

            const pid = document.createElement("input");
            pid.type = "hidden";
            pid.name = "productId";
            pid.value = sp.dataset.id;

            const qty = document.createElement("input");
            qty.type = "hidden";
            qty.name = "quantities";
            qty.value = sp.querySelector(".o_so_luong").value;

            form.appendChild(pid);
            form.appendChild(qty);
        });

        document.body.appendChild(form);
        form.submit();
    });
</script>

</body>

</html>