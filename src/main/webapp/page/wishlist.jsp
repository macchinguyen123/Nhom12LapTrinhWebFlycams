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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/common-category.css">
</head>
<body>
<jsp:include page="/page/header.jsp"/>


<div class="gio-hang">
    <div class="gio-hang-noi-dung">
        <div class="container py-4">

            <div class="mb-3">
                <h3 class="text-center mb-4 fw-bold text-primary">
                    Danh Sách Sản Phẩm Đã Thích
                </h3>
            </div>

            <!-- Thanh công cụ -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="chon_tat_ca">
                    <label for="chon_tat_ca" class="form-check-label">Chọn tất cả</label>
                </div>
                <button class="btn btn-outline-danger btn-sm nut_xoa_da_chon">
                    <i class="bi bi-trash"></i> Xóa sản phẩm đã chọn
                </button>
            </div>

            <!-- Danh sách sản phẩm -->
            <div id="danh_sach_san_pham">

                <!-- Nếu wishlist rỗng -->
                <c:if test="${empty products}">
                    <div class="alert alert-info text-center">
                        Danh sách yêu thích của bạn đang trống 💔
                    </div>
                </c:if>

                <!-- Lặp danh sách -->
                <c:forEach var="p" items="${products}">
                    <div class="khung_san_pham p-3 mb-3 bg-white shadow-sm rounded
                                d-flex align-items-center justify-content-between"
                         data-product-id="${p.id}">

                        <div class="d-flex align-items-center">
                            <input type="checkbox"
                                   class="chon_san_pham form-check-input me-3">

                            <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                                <img src="${p.mainImage}"
                                     alt="${p.productName}"
                                     class="anh_san_pham me-3"
                                     width="120">
                            </a>

                            <div>
                                <h5 class="ten_san_pham mb-2">
                                        ${p.productName}
                                    <span style="color:red"></span>
                                </h5>


                                <div>
                                   <span class="gia_hien_tai text-danger fw-bold me-2">
                                        ${formatter.format(p.price)} ₫
                                    </span>

                                    <c:if test="${p.finalPrice <= p.price}">
                                    <span class="gia_goc text-muted text-decoration-line-through">
                                        ${formatter.format(p.finalPrice)} ₫
                                    </span>
                                    </c:if>

                                </div>
                            </div>
                        </div>

                        <div class="d-flex align-items-center gap-2">
                            <a href="${pageContext.request.contextPath}/cart?action=add&productId=${p.id}">
                                <button class="btn btn-primary btn-sm nut_them_vao_gio">
                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ hàng
                                </button>
                            </a>

                            <button class="btn btn-outline-danger btn-sm nut_xoa"
                                    data-product-id="${p.id}">
                                <i class="bi bi-trash"></i>
                            </button>
                        </div>
                    </div>
                </c:forEach>

            </div>
        </div>
    </div>
</div>


<jsp:include page="/page/footer.jsp"/>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        document.querySelectorAll('.nut_xoa').forEach(btn => {
            btn.addEventListener('click', e => {
                e.preventDefault();

                const productId = btn.getAttribute("data-product-id");
                console.log("CLICK XÓA productId =", productId);

                if (!productId || productId.trim() === "") {
                    alert("Không tìm thấy productId để xóa");
                    return;
                }

                // Tạo body chuẩn bằng URLSearchParams
                const params = new URLSearchParams();
                params.append("action", "remove");
                params.append("productId", productId);

                fetch('${pageContext.request.contextPath}/wishlist', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
                    },
                    body: params.toString()
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            btn.closest('.khung_san_pham')?.remove();
                        } else {
                            alert('Xóa thất bại');
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        alert('Lỗi kết nối server');
                    });
            });
        });
    });
</script>



</body>
</html>
