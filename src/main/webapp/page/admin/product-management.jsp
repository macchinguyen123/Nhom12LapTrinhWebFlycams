<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <!-- DataTables JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/product-manage.css">

    <!-- CKEditor 5 Premium -->
    <link rel="stylesheet" href="https://cdn.ckeditor.com/ckeditor5/47.2.0/ckeditor5.css" crossorigin>
    <link rel="stylesheet"
          href="https://cdn.ckeditor.com/ckeditor5-premium-features/47.2.0/ckeditor5-premium-features.css"
          crossorigin>

    <style>
        /* CKEditor custom styles */
        .ck-editor__editable {
            min-height: 250px;
        }

        .ck.ck-editor__main > .ck-editor__editable {
            background: #fff;
        }

        /* Fix CKEditor dialogs in Bootstrap modal */
        .ck.ck-balloon-panel {
            z-index: 10055 !important;
        }

        .ck.ck-modal__overlay {
            z-index: 10060 !important;
        }

        .ck-body-wrapper {
            z-index: 10065 !important;
        }

        .modal {
            --bs-modal-zindex: 1055;
        }

        .modal-backdrop {
            z-index: 1054;
        }
    </style>
</head>

<body>

<!-- ===== HEADER ===== -->
<header class="main-header">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
        <h2>SkyDrone Admin</h2>
    </div>
    <div class="header-right">
        <!-- Icon admin + tên -->
        <a href="${pageContext.request.contextPath}/admin/profile"
           class="text-decoration-none text-while">
            <div class="thong-tin-admin d-flex align-items-center gap-2">
                <i class="bi bi-person-circle fs-4"></i>
                <span class="fw-semibold">${sessionScope.user.fullName}</span>
            </div>
        </a>

        <button class="logout-btn" id="logoutBtn" title="Đăng xuất">
            <i class="bi bi-box-arrow-right"></i>
        </button>
    </div>
    <div class="logout-modal" id="logoutModal">
        <div class="logout-modal-content">
            <p>Bạn có chắc muốn đăng xuất không?</p>
            <div class="logout-actions">
                <a href="${pageContext.request.contextPath}/Logout">
                    <button id="confirmLogout" class="confirm">Có</button>
                </a>
                <button id="cancelLogout" class="cancel">Không</button>
            </div>
        </div>
    </div>
</header>

<!-- ===== LAYOUT ===== -->
<div class="layout">
    <!-- === SIDEBAR === -->
    <aside class="sidebar">
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty sessionScope.user.avatar}">
                    <img src="${pageContext.request.contextPath}/uploads/avatar/${sessionScope.user.avatar}?v=${sessionScope.user.updatedAt != null ? sessionScope.user.updatedAt.time : ''}"
                         alt="Avatar"
                         style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar">
                </c:otherwise>
            </c:choose>
            <h3>${sessionScope.user.fullName}</h3>
            <p>Chào mừng bạn trở lại 👋</p>
        </div>

        <ul class="menu">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <li><i class="bi bi-speedometer2"></i> Tổng Quan</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/customer-manage">
                <li><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/product-management">
                <li class="active"><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/category-manage">
                <li><i class="bi bi-tags"></i> Quản Lý Danh Mục</li>
            </a>

            <li class="has-submenu">
                <div class="menu-item">
                    <i class="bi bi-truck"></i>
                    <span>Quản Lý Đơn Hàng</span>
                    <i class="bi bi-chevron-right arrow"></i>
                </div>
                <ul class="submenu">
                    <a href="${pageContext.request.contextPath}/admin/unconfirmed-orders">
                        <li>Chưa Xác Nhận</li>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/order-manage">
                        <li>Đã Xác Nhận</li>
                    </a>
                </ul>
            </li>

            <a href="${pageContext.request.contextPath}/admin/blog-manage">
                <li><i class="bi bi-journal-text"></i> Quản Lý Blog</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/promotion-manage">
                <li><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/statistics">
                <li><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/banner-manage">
                <li><i class="bi bi-images"></i> Quản Lý Banner</li>
            </a>
        </ul>
    </aside>

    <!-- === MAIN CONTENT === -->
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">

            <h4 class="text-primary fw-bold"><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</h4>

            <div class="d-flex align-items-center gap-2">

                <!-- THANH TÌM KIẾM -->
                <form class="d-flex" role="search" style="max-width: 300px;">
                    <div class="input-group">
                                        <span class="input-group-text bg-primary text-white">
                                            <i class="bi bi-search"></i>
                                        </span>
                        <input id="searchInput" type="search" class="form-control"
                               placeholder="Tìm kiếm sản phẩm..." aria-label="Tìm kiếm">
                    </div>
                </form>

                <!-- NÚT THÊM SẢN PHẨM -->
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalSanPham">
                    <i class="bi bi-plus-lg"></i> Thêm Sản Phẩm
                </button>

            </div>
        </div>


        <div class="d-flex justify-content-start align-items-center mb-2">
            <label class="me-2">Hiển thị</label>
            <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                <option value="5">5</option>
                <option value="10" selected>10</option>
                <option value="20">20</option>
            </select>
            <label class="ms-2">sản phẩm</label>
        </div>
        <!-- === BẢNG SẢN PHẨM === -->
        <table id="tableSanPham" class="table table-striped table-bordered">
            <thead class="table-primary">
            <tr>
                <th>Mã SP</th>
                <th>Tên SP</th>
                <th>Danh Mục</th>
                <th>Ảnh</th>
                <th>Giá Gốc</th>
                <th>Giá KM</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="p" items="${products}">
                <tr>
                    <!-- Mã SP -->
                    <td>${p.id}</td>

                    <!-- Tên -->
                    <td>${p.productName}</td>

                    <!-- Danh mục -->
                    <td>${p.categoryName}</td>

                    <!-- Ảnh -->
                    <td>
                        <img src="${p.mainImage}" class="img-thumbnail"
                             style="width:60px;height:60px;object-fit:cover;" alt="${p.productName}">
                    </td>

                    <!-- Giá gốc -->
                    <td>
                        <fmt:formatNumber value="${p.price}" type="number"/>đ
                    </td>

                    <!-- Giá KM -->
                    <td>
                        <fmt:formatNumber value="${p.finalPrice}" type="number"/>đ
                    </td>

                    <!-- Trạng thái -->
                    <td>
                        <c:choose>
                            <c:when test="${p.status == 'active'}">
                                <span class="badge bg-success">Đang KD</span>
                            </c:when>

                            <c:when test="${p.status == 'inactive'}">
                                <span class="badge bg-secondary">Ẩn</span>
                            </c:when>

                            <c:when test="${p.status == 'soldout'}">
                                <span class="badge bg-warning text-dark">Hết hàng</span>
                            </c:when>

                            <c:otherwise>
                                <span class="badge bg-dark">Không xác định</span>
                            </c:otherwise>
                        </c:choose>
                    </td>

                    <!-- Thao tác -->
                    <td style="width:160px; text-align:center;">
                        <button class="btn btn-warning btn-sm btn-edit" data-id="${p.id}">
                            <i class="bi bi-pencil"></i>
                        </button>

                        <button class="btn btn-danger btn-sm btn-delete" data-id="${p.id}">
                            <i class="bi bi-trash"></i>
                        </button>

                        <button class="btn btn-secondary btn-sm btn-toggle" data-id="${p.id}">
                            <i class="bi ${p.status == 'active' ? 'bi-eye-slash' : 'bi-eye'}"></i>
                        </button>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty products}">
                <tr>
                    <td colspan="8" class="text-center text-muted">
                        Chưa có sản phẩm
                    </td>
                </tr>
            </c:if>
            </tbody>
        </table>
        <div class="d-flex justify-content-end align-items-center mt-3">
            <div class="pagination-controls">
                <button id="prevPage" class="btn btn-outline-primary btn-sm">Trước</button>
                <span id="pageInfo" class="mx-2">1 / 1</span>
                <button id="nextPage" class="btn btn-outline-primary btn-sm">Sau</button>
            </div>
        </div>
    </main>
</div>

<!-- === MODAL THÊM / SỬA SẢN PHẨM === -->

<div class="modal fade" id="modalSanPham" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Cập Nhật Thông Tin Sản Phẩm
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <form id="formSanPham" class="row g-3">
                    <input type="hidden" id="productId">
                    <input type="hidden" id="formMode" value="add"> <!-- add | edit -->
                    <!-- Mã sản phẩm (không cho nhập) -->
                    <div class="col-md-6">
                        <label class="form-label">Mã sản phẩm</label>
                        <input type="text" class="form-control" id="maSP" placeholder="Mã tự động"
                               disabled>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Tên sản phẩm</label>
                        <input type="text" class="form-control" id="tenSP"
                               placeholder="Nhập tên sản phẩm">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Danh mục</label>
                        <select class="form-select" id="danhMuc">
                            <option value="1001">Drone quay phim chuyên nghiệp</option>
                            <option value="1006">Drone du lịch / vlog</option>
                            <option value="1003">Drone thể thao tốc độ cao</option>
                            <option value="1002">Drone nông nghiệp</option>
                            <option value="1005">Drone giám sát / an ninh</option>
                            <option value="1004">Drone mini / cỡ nhỏ</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Thương hiệu</label>
                        <input type="text" class="form-control" id="thuongHieu"
                               placeholder="VD: DJI, Autel, Xiaomi...">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" id="trangThai">
                            <option>Đang Kinh Doanh</option>
                            <option>Ẩn</option>
                            <option>Hết Hàng</option>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Giá gốc</label>
                        <input type="number" class="form-control" id="giaGoc"
                               placeholder="Nhập giá gốc">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Giá khuyến mãi</label>
                        <input type="number" class="form-control" id="giaKM"
                               placeholder="Nhập giá khuyến mãi (nếu có)">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Số lượng</label>
                        <input type="number" class="form-control" id="soLuong"
                               placeholder="Nhập số lượng">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Đánh giá trung bình</label>
                        <input type="text" class="form-control" id="danhGia" value="Tự động tính"
                               disabled>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Bảo hành</label>
                        <input type="text" class="form-control" id="baoHanh"
                               placeholder="Nhập thời gian bảo hành, ví dụ: 12 tháng">
                    </div>

                    <!-- Ảnh chính -->
                    <div class="col-12">
                        <label class="form-label fw-semibold">
                            Ảnh chính
                            <small class="text-muted">(URL)</small>
                        </label>

                        <div class="input-group">
                                            <span class="input-group-text">
                                                <i class="bi bi-image"></i>
                                            </span>
                            <input type="url" class="form-control" id="anhChinh"
                                   placeholder="https://example.com/image-main.jpg">
                        </div>
                    </div>

                    <!-- Ảnh phụ -->
                    <div class="col-12">
                        <label class="form-label fw-semibold">
                            Ảnh phụ
                            <small class="text-muted">(có thể thêm nhiều)</small>
                        </label>

                        <div id="imageExtraContainer">
                            <div class="input-group mb-2 image-row">
                                                <span class="input-group-text">
                                                    <i class="bi bi-images"></i>
                                                </span>

                                <input type="url" class="form-control image-extra"
                                       placeholder="https://example.com/image-1.jpg">

                                <button type="button" class="btn btn-outline-success btn-add-image"
                                        title="Thêm ảnh">
                                    <i class="bi bi-plus-lg"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Mô tả chi tiết</label>
                        <textarea class="form-control" id="moTa" rows="3"
                                  placeholder="Giới thiệu, ưu điểm, công nghệ..."></textarea>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Thông số kỹ thuật</label>
                        <textarea class="form-control" id="thongSo" rows="3"
                                  placeholder="Nhập thông số kỹ thuật..."></textarea>
                    </div>
                    <div class="modal-footer col-12">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            Hủy
                        </button>
                        <button type="button" class="btn btn-primary" id="btnSaveProduct">
                            Lưu Thay Đổi
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    var table = $('#tableSanPham').DataTable({
        "paging": true,
        "lengthChange": false,
        "pageLength": 10,
        "ordering": true,
        "searching": true,
        "info": false,
        "dom": 't',
        "columnDefs": [
            {"orderable": false, "targets": [3, 7]}
        ], "language": {
            "zeroRecords": "Không tìm thấy dữ liệu"
        }
    });

    // Tìm kiếm
    $('#searchInput').on('keyup', function () {
        table.search(this.value).draw();
    });

    // Thay đổi số dòng hiển thị
    $('#rowsPerPage').on('change', function () {
        table.page.len(parseInt($(this).val())).draw();
        updatePageInfo();
    });

    // ======= LOGOUT =======
    $("#logoutBtn").on("click", function () {
        $("#logoutModal").css("display", "flex");
    });

    $("#cancelLogout").on("click", function () {
        $("#logoutModal").hide();
    });

    // Nút phân trang trước / sau
    $('#prevPage').on('click', function () {
        table.page('previous').draw('page');
        updatePageInfo();
    });

    $('#nextPage').on('click', function () {
        table.page('next').draw('page');
        updatePageInfo();
    });

    // Cập nhật số trang hiển thị
    function updatePageInfo() {
        var info = table.page.info();
        $('#pageInfo').text((info.page + 1) + ' / ' + info.pages);
    }

    updatePageInfo();

    // --- SỬA SẢN PHẨM ---
    $(document).on('click', '.btn-warning', function () {
        editRow = table.row($(this).closest('tr'));

        let data = editRow.data();

        // Đổ dữ liệu vào form modal
        $('#maSP').val(data[0]);
        $('#tenSP').val(data[1]);
        $('#danhMuc').val(data[2]);
        $('#giaGoc').val(data[4]);
        $('#giaKM').val(data[5]);
        $('#trangThai').val($(data[6]).text().trim() === "Ẩn" ? "Ẩn" : "Đang Kinh Doanh");

        // Đổi tiêu đề
        $('#modalSanPham .modal-title').html('<i class="bi bi-pencil"></i> Chỉnh sửa sản phẩm');

        // Mở modal
        modalSanPham.show();
    });
    //xoa san pham
    $(document).on('click', '.btn-danger', function (e) {
        e.preventDefault();
        let row = $(this).closest('tr');
        let productId = $(this).data('id'); // Lấy id sản phẩm từ button

        Swal.fire({
            title: "Bạn chắc chắn muốn xóa?",
            text: "Hành động này không thể hoàn tác!",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Xóa",
            cancelButtonText: "Hủy",
            confirmButtonColor: "#dc3545",
            cancelButtonColor: "#6c757d"
        }).then((result) => {
            if (result.isConfirmed) {
                // Gọi AJAX/Fetch xóa trên server
                fetch(contextPath + '/admin/product-delete?id=' + productId, {
                    method: 'POST'
                })
                    .then(res => res.json())
                    .then(data => {
                        if (data.success) {
                            table.row(row).remove().draw();
                            updatePageInfo();
                            Swal.fire({
                                title: "Đã xóa!",
                                text: "Sản phẩm đã được xóa.",
                                icon: "success",
                                confirmButtonColor: "#0d6efd"
                            });
                        } else {
                            Swal.fire({
                                title: "Lỗi!",
                                text: data.message,
                                icon: "error",
                                confirmButtonColor: "#0d6efd"
                            });
                        }
                    });
            }
        });
    });

    let editRow = null;

    // Khởi tạo modal Bootstrap 5
    const modalSanPham = new bootstrap.Modal(document.getElementById('modalSanPham'));

    // Khi nhấn Thêm sản phẩm
    $('#modalSanPham').on('show.bs.modal', function () {
        editRow = null;
        $('#formSanPham')[0].reset();
        $('#trangThai').val('Đang Kinh Doanh');
        $('#modalSanPham .modal-title').html('<i class="bi bi-plus-lg"></i> Thêm sản phẩm');
    });

    $(document).on('click', '.btn-edit', function () {
        const productId = $(this).data('id');
        $('#productId').val(productId);
        $('#formMode').val('edit');

        fetch(contextPath + '/admin/product-get?id=' + productId)
            .then(res => res.json())
            .then(product => {
                // Đổ dữ liệu vào form
                $('#tenSP').val(product.productName);
                $('#danhMuc').val(product.categoryId);
                $('#thuongHieu').val(product.brandName);
                $('#giaGoc').val(product.price);
                $('#giaKM').val(product.finalPrice);
                $('#soLuong').val(product.quantity);
                $('#trangThai').val(product.status === 'active' ? 'Đang Kinh Doanh' :
                    product.status === 'inactive' ? 'Ẩn' : 'Hết Hàng');
                $('#baoHanh').val(product.warranty);
                $('#moTa').val(product.description);
                $('#thongSo').val(product.parameter);
                $('#anhChinh').val(product.mainImage);

                $('#imageExtraContainer').empty();

                if (product.images && product.images.length > 0) {
                    product.images.forEach(img => {
                        const $row = $('<div class="input-group mb-2 image-row"></div>');
                        $row.append('<span class="input-group-text"><i class="bi bi-images"></i></span>');

                        const $input = $('<input type="url" class="form-control image-extra" placeholder="URL ảnh phụ">');
                        $input.val(img.imageUrl); // bind giá trị an toàn
                        $row.append($input);

                        const $btnRemove = $(`
            <button type="button" class="btn btn-outline-danger btn-remove-image">
                <i class="bi bi-dash-lg"></i>
            </button>
        `);
                        $row.append($btnRemove);

                        $('#imageExtraContainer').append($row);
                    });
                } else {
                    // Nếu không có ảnh phụ, giữ 1 input trống
                    const $row = $(`
        <div class="input-group mb-2 image-row">
            <span class="input-group-text"><i class="bi bi-images"></i></span>
            <input type="url" class="form-control image-extra" placeholder="URL ảnh phụ">
            <button type="button" class="btn btn-outline-success btn-add-image">
                <i class="bi bi-plus-lg"></i>
            </button>
        </div>
    `);
                    $('#imageExtraContainer').append($row);
                }


                // Set tiêu đề modal
                $('#modalSanPham .modal-title').html('<i class="bi bi-pencil"></i> Chỉnh sửa sản phẩm');

                // FORCE UPDATE CKEDITOR DATA
                if (window.descriptionEditor) {
                    window.descriptionEditor.setData(product.description || '');
                }
                if (window.parameterEditor) {
                    window.parameterEditor.setData(product.parameter || '');
                }

                modalSanPham.show();
            });
    });


    // --- Toggle trạng thái ---
    // --- Toggle trạng thái với AJAX ---
    $(document).on('click', '.btn-secondary', function () {
        const row = $(this).closest('tr');
        const statusCell = row.find('td:eq(6)');
        const productId = $(this).data('id'); // Lấy id sản phẩm từ button
        let newStatus;

        // Xác định trạng thái mới
        if (statusCell.text().trim() === "Đang KD" || statusCell.text().trim() === "Đang Kinh Doanh") {
            newStatus = "inactive"; // chuyển sang ẩn
        } else {
            newStatus = "active";   // chuyển sang đang KD
        }

        // Gửi yêu cầu AJAX cập nhật status
        fetch(contextPath + '/admin/product-toggle-status', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({id: productId, status: newStatus})
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    // Cập nhật giao diện
                    if (newStatus === "inactive") {
                        statusCell.html('<span class="badge bg-secondary">Ẩn</span>');
                        $(this).html('<i class="bi bi-eye"></i>');
                    } else {
                        statusCell.html('<span class="badge bg-success">Đang KD</span>');
                        $(this).html('<i class="bi bi-eye-slash"></i>');
                    }
                } else {
                    Swal.fire({
                        title: "Lỗi!",
                        text: data.message,
                        icon: "error",
                        confirmButtonColor: "#0d6efd"
                    });
                }
            });
    });

</script>
<script>
    const contextPath = '<%= request.getContextPath() %>';
</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        document.addEventListener("click", function (e) {

            if (e.target.closest(".btn-add-image")) {
                const container = document.getElementById("imageExtraContainer");

                const row = document.createElement("div");
                row.className = "input-group mb-2 image-row";

                row.innerHTML = `
                <span class="input-group-text">
                    <i class="bi bi-images"></i>
                </span>
                <input type="url"
                       class="form-control image-extra"
                       placeholder="https://example.com/image-x.jpg">
                <button type="button"
                        class="btn btn-outline-danger btn-remove-image">
                    <i class="bi bi-dash-lg"></i>
                </button>
            `;
                container.appendChild(row);
            }

            if (e.target.closest(".btn-remove-image")) {
                e.target.closest(".image-row").remove();
            }
        });

        const form = document.getElementById("formSanPham");
        if (!form) return;

    });

    // === XỬ LÝ SUBMENU SIDEBAR ===
    document.querySelectorAll('.has-submenu .menu-item').forEach(item => {
        item.addEventListener('click', function (e) {
            e.preventDefault();
            const parent = this.parentElement;
            const submenu = parent.querySelector('.submenu');
            const arrow = this.querySelector('.arrow');

            // Toggle active/open class
            parent.classList.toggle('active');
            parent.classList.toggle('open');

            // Toggle arrow and submenu visibility
            if (parent.classList.contains('active') || parent.classList.contains('open')) {
                arrow.classList.remove('bi-chevron-right');
                arrow.classList.add('bi-chevron-down');
                submenu.style.display = 'block';
            } else {
                arrow.classList.remove('bi-chevron-down');
                arrow.classList.add('bi-chevron-right');
                submenu.style.display = 'none';
            }
        });
    });
</script>
<script src="${pageContext.request.contextPath}/js/admin/product-management.js"></script>

<!-- CKEditor 5 Premium Script -->
<script src="https://cdn.ckeditor.com/ckeditor5/47.2.0/ckeditor5.umd.js" crossorigin></script>
<script
        src="https://cdn.ckeditor.com/ckeditor5-premium-features/47.2.0/ckeditor5-premium-features.umd.js"
        crossorigin></script>
<script>
    const {
        ClassicEditor,
        Essentials,
        Paragraph,
        Alignment,
        AutoImage,
        Autoformat,
        AutoLink,
        ImageBlock,
        BlockQuote,
        Bold,
        Code,
        CodeBlock,
        FontBackgroundColor,
        FontColor,
        FontFamily,
        FontSize,
        Heading,
        Highlight,
        HorizontalLine,
        ImageCaption,
        ImageInsert,
        ImageInsertViaUrl,
        ImageResize,
        ImageStyle,
        ImageTextAlternative,
        ImageToolbar,
        ImageUpload,
        Indent,
        IndentBlock,
        Italic,
        Link,
        LinkImage,
        List,
        ListProperties,
        MediaEmbed,
        RemoveFormat,
        SpecialCharacters,
        SpecialCharactersArrows,
        SpecialCharactersCurrency,
        SpecialCharactersEssentials,
        SpecialCharactersLatin,
        SpecialCharactersMathematical,
        SpecialCharactersText,
        Strikethrough,
        Subscript,
        Superscript,
        Table,
        TableCaption,
        TableCellProperties,
        TableColumnResize,
        TableProperties,
        TableToolbar,
        Underline,
        Base64UploadAdapter
    } = window.CKEDITOR;

    // Valid License Key from blog-manage.jsp
    const LICENSE_KEY = 'eyJhbGciOiJFUzI1NiJ9.eyJleHAiOjE3NzAwNzY3OTksImp0aSI6IjFkYzBmZGQ1LThhMTgtNGFhYy1iOTEwLWRkMTA0MDkxZmNjZCIsInVzYWdlRW5kcG9pbnQiOiJodHRwczovL3Byb3h5LWV2ZW50LmNrZWRpdG9yLmNvbSIsImRpc3RyaWJ1dGlvbkNoYW5uZWwiOlsiY2xvdWQiLCJkcnVwYWwiLCJzaCJdLCJ3aGl0ZUxhYmVsIjp0cnVlLCJsaWNlbnNlVHlwZSI6InRyaWFsIiwiZmVhdHVyZXMiOlsiKiJdLCJ2YyI6ImQwYWQwMTgyIn0.4qtYn6Q_c-EZwACzzNRQTfTLUjqrjRo12fRQXuGhzTmwPnaJOT3Jw6J6NK3u0Jf_skSkzhR36nezFQka3szCuA';

    const editorConfig = {
        licenseKey: LICENSE_KEY,
        toolbar: {
            items: [
                'undo', 'redo',
                '|',
                'heading',
                '|',
                'fontSize', 'fontFamily', 'fontColor', 'fontBackgroundColor',
                '|',
                'bold', 'italic', 'underline', 'strikethrough', 'subscript', 'superscript', 'code', 'removeFormat',
                '|',
                'specialCharacters', 'horizontalLine', 'link', 'insertImage', 'insertImageViaUrl', 'mediaEmbed', 'insertTable',
                'highlight', 'blockQuote', 'codeBlock',
                '|',
                'alignment',
                '|',
                'bulletedList', 'numberedList', 'outdent', 'indent'
            ],
            shouldNotGroupWhenFull: true
        },
        plugins: [
            Alignment,
            Autoformat,
            AutoImage,
            AutoLink,
            Base64UploadAdapter,
            BlockQuote,
            Bold,
            Code,
            CodeBlock,
            Essentials,
            FontBackgroundColor,
            FontColor,
            FontFamily,
            FontSize,
            Heading,
            Highlight,
            HorizontalLine,
            ImageBlock,
            ImageCaption,
            ImageInsert,
            ImageInsertViaUrl,
            ImageResize,
            ImageStyle,
            ImageTextAlternative,
            ImageToolbar,
            ImageUpload,
            Indent,
            IndentBlock,
            Italic,
            Link,
            LinkImage,
            List,
            ListProperties,
            MediaEmbed,
            Paragraph,
            RemoveFormat,
            SpecialCharacters,
            SpecialCharactersArrows,
            SpecialCharactersCurrency,
            SpecialCharactersEssentials,
            SpecialCharactersLatin,
            SpecialCharactersMathematical,
            SpecialCharactersText,
            Strikethrough,
            Subscript,
            Superscript,
            Table,
            TableCaption,
            TableCellProperties,
            TableColumnResize,
            TableProperties,
            TableToolbar,
            Underline
        ],
        fontFamily: {
            options: [
                'default',
                'Arial, Helvetica, sans-serif',
                'Courier New, Courier, monospace',
                'Georgia, serif',
                'Lucida Sans Unicode, Lucida Grande, sans-serif',
                'Tahoma, Geneva, sans-serif',
                'Times New Roman, Times, serif',
                'Trebuchet MS, Helvetica, sans-serif',
                'Verdana, Geneva, sans-serif'
            ],
            supportAllValues: true
        },
        fontSize: {
            options: [10, 12, 14, 'default', 18, 20, 22, 24, 26, 28, 36],
            supportAllValues: true
        },
        heading: {
            options: [
                {model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph'},
                {model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1'},
                {model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2'},
                {model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3'},
                {model: 'heading4', view: 'h4', title: 'Heading 4', class: 'ck-heading_heading4'},
                {model: 'heading5', view: 'h5', title: 'Heading 5', class: 'ck-heading_heading5'},
                {model: 'heading6', view: 'h6', title: 'Heading 6', class: 'ck-heading_heading6'}
            ]
        },
        image: {
            toolbar: [
                'imageTextAlternative', 'imageStyle:inline', 'imageStyle:block', 'imageStyle:side', 'linkImage'
            ]
        },
        link: {
            addTargetToExternalLinks: true,
            defaultProtocol: 'https://'
        },
        list: {
            properties: {
                styles: true,
                startIndex: true,
                reversed: true
            }
        },
        table: {
            contentToolbar: ['tableColumn', 'tableRow', 'mergeTableCells', 'tableProperties', 'tableCellProperties']
        },
        placeholder: 'Nhập nội dung...'
    };

    // Global variables for access in product-management.js
    var descriptionEditor, parameterEditor;

    // Initialize editors
    document.addEventListener("DOMContentLoaded", function () {
        // Fix Bootstrap modal focus trap for CKEditor 5
        document.addEventListener('focusin', function (e) {
            if (e.target.closest('.ck-body-wrapper, .ck-balloon-panel, .ck-link-form, .ck-input')) {
                e.stopImmediatePropagation();
            }
        }, true);

        // Init Description Editor
        if (document.querySelector('#moTa')) {
            ClassicEditor
                .create(document.querySelector('#moTa'), editorConfig)
                .then(editor => {
                    descriptionEditor = editor;
                    const val = document.querySelector('#moTa').value;
                    if (val) editor.setData(val);
                })
                .catch(error => console.error('Error initializing description editor:', error));
        }

        // Init Parameter Editor
        if (document.querySelector('#thongSo')) {
            ClassicEditor
                .create(document.querySelector('#thongSo'), editorConfig)
                .then(editor => {
                    parameterEditor = editor;
                    const val = document.querySelector('#thongSo').value;
                    if (val) editor.setData(val);
                })
                .catch(error => console.error('Error initializing parameter editor:', error));
        }

        // Sync data when opening modal for editing
        $('#modalSanPham').on('shown.bs.modal', function () {
            if (descriptionEditor) {
                const val = $('#moTa').val();
                if (val !== descriptionEditor.getData()) descriptionEditor.setData(val);
            }
            if (parameterEditor) {
                const val = $('#thongSo').val();
                if (val !== parameterEditor.getData()) parameterEditor.setData(val);
            }
        });

        // Clear data when closing modal
        $('#modalSanPham').on('hidden.bs.modal', function () {
            if (descriptionEditor) descriptionEditor.setData('');
            if (parameterEditor) parameterEditor.setData('');
        });
    });
</script>
</body>

</html>