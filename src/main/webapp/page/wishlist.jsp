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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
          rel="stylesheet">
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
                                d-flex align-items-center justify-content-between" data-product-id="${p.id}">

                        <div class="d-flex align-items-center">
                            <input type="checkbox" class="chon_san_pham form-check-input me-3">

                            <a href="${pageContext.request.contextPath}/product-detail?id=${p.id}">
                                <img src="${p.mainImage}" alt="${p.productName}"
                                     class="anh_san_pham me-3" width="120">
                            </a>

                            <div>
                                <h5 class="ten_san_pham mb-2">
                                        ${p.productName}
                                    <span style="color:red"></span>
                                </h5>


                                <div>
                                                        <span class="gia_hien_tai text-danger fw-bold me-2">
                                                            ${formatter.format(p.finalPrice)} ₫
                                                        </span>

                                    <c:if test="${p.finalPrice <= p.price}">
                                                            <span
                                                                    class="gia_goc text-muted text-decoration-line-through">
                                                                ${formatter.format(p.price)} ₫
                                                            </span>
                                    </c:if>

                                </div>
                            </div>
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <!-- Form thêm vào giỏ hàng -->
                            <form action="${pageContext.request.contextPath}/add-cart" method="get"
                                  style="display:inline-block; margin:0;">
                                <input type="hidden" name="productId" value="${p.id}">
                                <input type="hidden" name="quantity" value="1">

                                <button type="submit"
                                        class="btn btn-primary btn-sm nut_them_vao_gio">
                                    <i class="bi bi-cart-plus"></i> Thêm vào giỏ hàng
                                </button>
                            </form>

                            <!-- Nút xóa -->
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
        const contextPath = '${pageContext.request.contextPath}';

        // ============================================
        // XỬ LÝ XÓA SẢN PHẨM
        // ============================================

        // Xử lý nút xóa từng sản phẩm
        document.querySelectorAll('.nut_xoa').forEach(btn => {
            btn.addEventListener('click', e => {
                e.preventDefault();

                const productId = btn.getAttribute("data-product-id");
                if (!productId || productId.trim() === "") {
                    showNotification('Không tìm thấy sản phẩm', 'error');
                    return;
                }

                const params = new URLSearchParams();
                params.append("action", "remove");
                params.append("productId", productId);

                fetch(contextPath + '/wishlist', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
                    body: params.toString()
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            const productBox = btn.closest('.khung_san_pham');
                            productBox.style.transition = 'all 0.3s ease';
                            productBox.style.opacity = '0';
                            productBox.style.transform = 'translateX(100px)';

                            setTimeout(() => {
                                productBox.remove();
                                checkEmptyWishlist();
                            }, 300);

                            showNotification('Đã xóa khỏi danh sách yêu thích', 'success');
                        } else {
                            showNotification('Xóa thất bại', 'error');
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        showNotification('Lỗi kết nối server', 'error');
                    });
            });
        });

        // ============================================
        // XỬ LÝ CHECKBOX
        // ============================================

        // Xử lý checkbox "Chọn tất cả"
        const chonTatCa = document.getElementById('chon_tat_ca');
        const checkboxes = document.querySelectorAll('.chon_san_pham');

        if (chonTatCa) {
            chonTatCa.addEventListener('change', () => {
                checkboxes.forEach(cb => {
                    cb.checked = chonTatCa.checked;
                });
            });
        }

        // ============================================
        // XỬ LÝ XÓA NHIỀU SẢN PHẨM
        // ============================================

        // Xử lý nút "Xóa sản phẩm đã chọn"
        const nutXoaDaChon = document.querySelector('.nut_xoa_da_chon');
        if (nutXoaDaChon) {
            nutXoaDaChon.addEventListener('click', e => {
                e.preventDefault();

                const checkedBoxes = document.querySelectorAll('.chon_san_pham:checked');
                if (checkedBoxes.length === 0) {
                    showNotification('Bạn chưa chọn sản phẩm nào', 'error');
                    return;
                }

                // Xác nhận trước khi xóa
                if (!confirm(`Bạn có chắc muốn xóa ${checkedBoxes.length} sản phẩm đã chọn?`)) {
                    return;
                }

                const productIds = [];
                checkedBoxes.forEach(cb => {
                    const productId = cb.closest('.khung_san_pham').getAttribute('data-product-id');
                    if (productId) productIds.push(productId);
                });

                const params = new URLSearchParams();
                params.append("action", "removeSelected");
                params.append("productIds", productIds.join(","));

                fetch(contextPath + '/wishlist', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
                    body: params.toString()
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            checkedBoxes.forEach((cb, index) => {
                                const productBox = cb.closest('.khung_san_pham');
                                productBox.style.transition = 'all 0.3s ease';
                                productBox.style.transitionDelay = (index * 0.05) + 's';
                                productBox.style.opacity = '0';
                                productBox.style.transform = 'translateX(100px)';
                            });

                            setTimeout(() => {
                                checkedBoxes.forEach(cb => {
                                    cb.closest('.khung_san_pham')?.remove();
                                });
                                checkEmptyWishlist();
                                if (chonTatCa) chonTatCa.checked = false;
                            }, 300 + (checkedBoxes.length * 50));

                            showNotification(`Đã xóa ${checkedBoxes.length} sản phẩm`, 'success');
                        } else {
                            showNotification('Xóa thất bại', 'error');
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        showNotification('Lỗi kết nối server', 'error');
                    });
            });
        }

        // ============================================
        // HIỆU ỨNG THÊM VÀO GIỎ HÀNG
        // ============================================

        // Xử lý form thêm vào giỏ hàng với hiệu ứng bay
        document.querySelectorAll('.nut_them_vao_gio').forEach(btn => {
            btn.addEventListener('click', e => {
                e.preventDefault();

                const form = btn.closest('form');
                const productId = form.querySelector('input[name="productId"]').value;
                const quantity = form.querySelector('input[name="quantity"]').value;

                // Lấy ảnh sản phẩm để tạo hiệu ứng
                const productBox = btn.closest('.khung_san_pham');
                const productImg = productBox.querySelector('.anh_san_pham');

                // Tạo clone của ảnh để bay
                const flyingImg = productImg.cloneNode(true);
                flyingImg.style.position = 'fixed';
                flyingImg.style.zIndex = '9999';
                flyingImg.style.width = '100px';
                flyingImg.style.height = '100px';
                flyingImg.style.objectFit = 'cover';
                flyingImg.style.transition = 'all 1.5s ease-in-out';
                flyingImg.style.pointerEvents = 'none';
                flyingImg.style.borderRadius = '50%'; // Bo tròn hoàn toàn
                flyingImg.style.boxShadow = '0 10px 25px rgba(0,0,0,0.3)';
                flyingImg.style.border = '3px solid white';

                // Vị trí bắt đầu (ảnh sản phẩm)
                const imgRect = productImg.getBoundingClientRect();
                flyingImg.style.left = imgRect.left + 'px';
                flyingImg.style.top = imgRect.top + 'px';

                document.body.appendChild(flyingImg);

                // Tìm vị trí icon giỏ hàng trong header
                const cartIcon = document.getElementById('cartBadge') || document.querySelector('.bi-cart3, [href*="shoppingcart"]');

                setTimeout(() => {
                    if (cartIcon) {
                        const cartRect = cartIcon.getBoundingClientRect();
                        flyingImg.style.left = (cartRect.left - 10) + 'px';
                        flyingImg.style.top = (cartRect.top - 10) + 'px';
                        flyingImg.style.width = '30px';
                        flyingImg.style.height = '30px';
                        flyingImg.style.opacity = '0';
                        flyingImg.style.transform = 'scale(0.2) rotate(360deg)';
                    } else {
                        // Nếu không tìm thấy icon, bay lên góc phải
                        flyingImg.style.left = (window.innerWidth - 100) + 'px';
                        flyingImg.style.top = '20px';
                        flyingImg.style.opacity = '0';
                        flyingImg.style.transform = 'scale(0.2) rotate(360deg)';
                    }
                }, 10);

                // Xóa ảnh bay sau khi animation hoàn thành
                setTimeout(() => {
                    flyingImg.remove();
                }, 1600);

                // Gửi request thêm vào giỏ hàng
                const url = form.action + '?productId=' + productId + '&quantity=' + quantity;

                fetch(url, {
                    method: 'GET',
                    headers: {'X-Requested-With': 'XMLHttpRequest'}
                })
                    .then(response => {
                        if (response.redirected) {
                            if (confirm('Bạn cần đăng nhập để thêm vào giỏ hàng. Chuyển đến trang đăng nhập?')) {
                                window.location.href = response.url;
                            }
                            return;
                        }
                        return response.json();
                    })
                    .then(data => {
                        if (!data) return;
                        if (data.success) {
                            showNotification('Đã thêm vào giỏ hàng!', 'success');

                            // Cập nhật badge giỏ hàng
                            if (data.cartSize) {
                                updateCartBadge(data.cartSize);
                            } else {
                                updateCartBadge();
                            }

                            // updateCartBadge đã xử lý hiệu ứng rung icon toàn cục
                        } else {
                            showNotification('Thêm vào giỏ hàng thất bại', 'error');
                        }
                    })
                    .catch(err => {
                        console.error(err);
                        showNotification('Lỗi kết nối server', 'error');
                    });
            });
        });
        // ============================================
        // HÀM HỖ TRỢ
        // ============================================

        // Hàm hiển thị thông báo
        function showNotification(message, type = 'success') {
            // Xóa notification cũ nếu có
            const oldNotification = document.querySelector('.custom-notification');
            if (oldNotification) {
                oldNotification.remove();
            }

            const notification = document.createElement('div');
            notification.className = 'custom-notification';

            // Chọn icon Bootstrap
            let icon = '';
            if (type === 'success') {
                icon = '<i class="bi bi-check-circle-fill me-2"></i>';
            } else {
                icon = '<i class="bi bi-exclamation-circle-fill me-2"></i>';
            }

            notification.innerHTML = icon + message;
            notification.style.position = 'fixed';
            notification.style.top = '80px';
            notification.style.right = '-300px';
            notification.style.padding = '12px 20px';
            notification.style.borderRadius = '8px';
            notification.style.zIndex = '10000';
            notification.style.fontWeight = '500';
            notification.style.boxShadow = '0 4px 12px rgba(0,0,0,0.2)';
            notification.style.transition = 'right 0.3s ease';
            notification.style.display = 'flex';
            notification.style.alignItems = 'center';
            notification.style.minWidth = '250px';

            if (type === 'success') {
                notification.style.backgroundColor = '#28a745';
                notification.style.color = 'white';
            } else {
                notification.style.backgroundColor = '#dc3545';
                notification.style.color = 'white';
            }

            document.body.appendChild(notification);

            // Animation slide in
            setTimeout(() => {
                notification.style.right = '20px';
            }, 10);

            // Animation slide out
            setTimeout(() => {
                notification.style.right = '-300px';
            }, 2500);

            setTimeout(() => {
                notification.remove();
            }, 3000);
        }


        // Kiểm tra wishlist trống
        function checkEmptyWishlist() {
            const productList = document.getElementById('danh_sach_san_pham');
            const products = productList.querySelectorAll('.khung_san_pham');

            if (products.length === 0) {
                productList.innerHTML = `
                <div class="alert alert-info text-center">
                    <i class="bi bi-heart-break fs-1 d-block mb-3"></i>
                    Danh sách yêu thích của bạn đang trống
                </div>
            `;
            }
        }

    });
</script>


</body>
</html>