<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- DataTables CSS -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <!-- DataTables JS -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>


    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/product-manage.css">
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
        <a href="profile-admin.jsp" class="text-decoration-none text-while">
            <div class="thong-tin-admin d-flex align-items-center gap-2">
                <i class="bi bi-person-circle fs-4"></i>
                <span class="fw-semibold">Admin</span>
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
                <a href="../login.jsp">
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
            <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar">

            <h3>Mạc Nguyên</h3>
            <p>Chào mừng bạn trở lại 👋</p>
        </div>

        <ul class="menu">
            <a href="${pageContext.request.contextPath}/admin/dashboard">
                <li><i class="bi bi-speedometer2"></i> Tổng Quan</li>
            </a>
            <a href="customer-manage.jsp">
                <li><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
            </a>
            <a href="${pageContext.request.contextPath}/admin/product-management">
                <li class="active"><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li>
            </a>
            <a href="category-manage.jsp">
                <li><i class="bi bi-tags"></i> Quản Lý Danh Mục</li>
            </a>

            <li class="has-submenu">
                <div class="menu-item">
                    <i class="bi bi-truck"></i>
                    <span>Quản Lý Đơn Hàng</span>
                    <i class="bi bi-chevron-right arrow"></i>
                </div>
                <ul class="submenu">
                    <a href="uncomfirmed-order-manage.jsp">
                        <li>Chưa Xác Nhận</li>
                    </a>
                    <a href="comfirmed-order-manage.jsp">
                        <li>Đã Xác Nhận</li>
                    </a>
                </ul>
            </li>

            <a href="blog-manage.jsp">
                <li><i class="bi bi-journal-text"></i> Quản Lý Blog</li>
            </a>
            <a href="promotion-manage.jsp">
                <li><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li>
            </a>
            <a href="statistics.jsp">
                <li><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
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
            <tr>
                <td>SP001</td>
                <td>FlyCam SkyMini</td>
                <td>Drone Mini</td>
                <td>
                    <img src="${pageContext.request.contextPath}/image/superviseProduct/Flycam SkyView 4K Security.png"
                         alt="Ảnh sản phẩm"
                         class="img-thumbnail"
                         style="width:60px; height:60px; object-fit:cover;">
                </td>


                <td>2.000.000đ</td>
                <td>1.800.000đ</td>
                <td><span class="badge bg-success">Đang KD</span></td>
                <td>
                    <button class="btn btn-warning btn-sm"><i class="bi bi-pencil"></i></button>
                    <button class="btn btn-danger btn-sm"><i class="bi bi-trash"></i></button>
                    <button class="btn btn-secondary btn-sm"><i class="bi bi-eye-slash"></i></button>
                </td>
            </tr>
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
                <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Cập Nhật Thông Tin Sản Phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <form id="formSanPham" class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Mã sản phẩm</label>
                        <input type="text" class="form-control" id="maSP" placeholder="Nhập mã sản phẩm">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Tên sản phẩm</label>
                        <input type="text" class="form-control" id="tenSP" placeholder="Nhập tên sản phẩm">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Danh mục</label>
                        <select class="form-select" id="danhMuc">
                            <option>Drone quay phim chuyên nghiệp</option>
                            <option>Drone du lịch / vlog</option>
                            <option> Drone thể thao tốc độ cao</option>
                            <option> Drone nông nghiệp</option>
                            <option> Drone giám sát / an ninh</option>
                            <option>Drone mini / cỡ nhỏ</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Thương hiệu</label>
                        <input type="text" class="form-control" id="thuongHieu" placeholder="VD: DJI, Autel, Xiaomi...">
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
                        <input type="number" class="form-control" id="giaGoc" placeholder="Nhập giá gốc">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Giá khuyến mãi</label>
                        <input type="number" class="form-control" id="giaKM" placeholder="Nhập giá khuyến mãi (nếu có)">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Số lượng</label>
                        <input type="number" class="form-control" id="soLuong" placeholder="Nhập số lượng">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Đánh giá trung bình</label>
                        <input type="text" class="form-control" id="danhGia" value="Tự động tính" disabled>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Ảnh chính</label>
                        <input type="file" class="form-control" id="anhChinh">
                    </div>

                    <div class="col-12">
                        <label class="form-label">Ảnh phụ (nhiều hình)</label>
                        <input type="file" class="form-control" id="anhPhu" multiple>
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
                </form>
            </div>

            <div class="modal-footer">
                <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                <button class="btn btn-primary">Lưu Thay Đổi</button>
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
    // --- Xóa sản phẩm ---
    $(document).on('click', '.btn-danger', function (e) {
        e.preventDefault();
        let row = $(this).closest('tr');
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
                table.row(row).remove().draw();
                updatePageInfo();
                Swal.fire({
                    title: "Đã xóa!",
                    text: "Sản phẩm đã được xóa.",
                    icon: "success",
                    confirmButtonColor: "#0d6efd"
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

    // Khi nhấn Lưu Thay Đổi
    $('#modalSanPham .btn-primary').on('click', function () {

        const maSP = $('#maSP').val().trim();
        const tenSP = $('#tenSP').val().trim();
        const danhMuc = $('#danhMuc').val();
        const giaGoc = $('#giaGoc').val().trim();
        const giaKM = $('#giaKM').val().trim() || '';
        const trangThaiVal = $('#trangThai').val();
        const trangThai = (trangThaiVal === "Ẩn") ? "Ẩn" : "Đang KD";

        if (!maSP || !tenSP || !giaGoc) {
            Swal.fire({
                icon: 'warning',
                title: 'Thiếu thông tin',
                text: 'Vui lòng nhập Mã SP, Tên SP và Giá gốc.'
            });
            return;
        }

        let imgHTML = '<img src="https://via.placeholder.com/60" class="img-thumbnail" style="width:60px;height:60px;object-fit:cover;">';

        const data = [
            maSP,
            tenSP,
            danhMuc,
            imgHTML,
            giaGoc,
            giaKM,
            `<span class="badge ${trangThai == "Đang KD" ? "bg-success" : "bg-secondary"}">${trangThai}</span>`,
            '<button class="btn btn-warning btn-sm"><i class="bi bi-pencil"></i></button> ' +
            '<button class="btn btn-danger btn-sm"><i class="bi bi-trash"></i></button> ' +
            `<button class="btn btn-secondary btn-sm">${trangThai == "Đang KD" ? '<i class="bi bi-eye-slash"></i>' : '<i class="bi bi-eye"></i>'}</button>`
        ];

        if (editRow) {
            editRow.data(data).draw();
            editRow = null;
        } else {
            table.row.add(data).draw();
        }

        updatePageInfo();
        modalSanPham.hide();
    });

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

    // --- Toggle trạng thái ---
    $(document).on('click', '.btn-secondary', function () {
        const row = $(this).closest('tr');
        const statusCell = row.find('td:eq(6)');
        if (statusCell.text().trim() === "Đang KD" || statusCell.text().trim() === "Đang Kinh Doanh") {
            statusCell.html('<span class="badge bg-secondary">Ẩn</span>');
            $(this).html('<i class="bi bi-eye"></i>');
        } else {
            statusCell.html('<span class="badge bg-success">Đang KD</span>');
            $(this).html('<i class="bi bi-eye-slash"></i>');
        }
    });
</script>

</body>
</html>
