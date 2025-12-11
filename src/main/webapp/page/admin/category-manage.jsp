<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Lý Danh Mục - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="../../stylesheets/admin/category-manage.css">

    <style>
        .dataTables_paginate,
        .dataTables_filter,
        .dataTables_length,
        .dataTables_info {
            display: none !important;
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
            <li>
                <a href="dashboard.jsp"><i class="bi bi-speedometer2"></i> Tổng Quan</a>
            </li>
            <li>
                <a href="customer-manage.jsp"><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</a>
            </li>
            <li>
                <a href="product-management.jsp"><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</a>
            </li>
            <li class="active">
                <a href="category-manage.jsp"><i class="bi bi-tags"></i> Quản Lý Danh Mục</a>
            </li>

            <li class="has-submenu">
                <div class="menu-item">
                    <i class="bi bi-truck"></i>
                    <span>Quản Lý Đơn Hàng</span>
                    <i class="bi bi-chevron-right arrow"></i>
                </div>
                <ul class="submenu">
                    <li><a href="uncomfirmed-order-manage.jsp">Chưa Xác Nhận</a></li>
                    <li><a href="comfirmed-order-manage.jsp">Đã Xác Nhận</a></li>
                </ul>
            </li>

            <li>
                <a href="blog-manage.jsp"><i class="bi bi-journal-text"></i> Quản Lý Blog</a>
            </li>
            <li>
                <a href="promotion-manage.jsp"><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</a>
            </li>
            <li>
                <a href="statistics.jsp"><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</a>
            </li>
        </ul>
    </aside>


    <!-- === MAIN CONTENT === -->

    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-primary fw-bold"><i class="bi bi-tags"></i> Quản Lý Danh Mục</h4>
            <div class="d-flex align-items-center gap-2">

                <!-- THANH TÌM KIẾM -->
                <form class="d-flex" role="search" style="max-width: 300px;">
                    <div class="input-group">
                <span class="input-group-text bg-primary text-white">
                    <i class="bi bi-search"></i>
                </span>
                        <input id="searchInput" type="search" class="form-control"
                               placeholder="Tìm kiếm danh mục..." aria-label="Tìm kiếm">
                    </div>
                </form>

                <!-- NÚT THÊM SẢN PHẨM -->
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalDanhMuc">
                    <i class="bi bi-plus-lg"></i> Thêm Danh Mục
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
            <label class="ms-2">danh mục</label>
        </div>

        <!-- === BẢNG DANH MỤC === -->
        <table id="tableDanhMuc" class="table table-striped table-bordered">
            <thead class="table-primary">
            <tr>
                <th>Mã DM</th>
                <th>Tên Danh Mục</th>
                <th>Ảnh Đại Diện</th>
                <th>Trạng Thái</th>
                <th>Số Sản Phẩm</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>DM001</td>
                <td>Drone quay phim chuyên nghiệp</td>

                <td>
                    <img src="${pageContext.request.contextPath}/image/danhmucquayphim.png"
                         alt="Ảnh danh mục"
                         class="img-thumbnail"
                         style="width: 60px; height: 60px; object-fit: cover;">
                </td>

                <td><span class="badge bg-success">Hiện</span></td>
                <td>12</td>
                <td>
                    <button class="btn btn-warning btn-sm btn-sua"><i class="bi bi-pencil"></i></button>
                    <button class="btn btn-danger btn-sm btn-xoa"><i class="bi bi-trash"></i></button>
                </td>
            </tr>


            <tr>
                <td>DM002</td>
                <td>Drone du lịch / vlog</td>

                <td>
                    <img src="${pageContext.request.contextPath}/image/dulich.png"
                         alt="Ảnh danh mục"
                         class="img-thumbnail"
                         style="width: 60px; height: 60px; object-fit: cover;">
                </td>

                <td><span class="badge bg-success">Hiện</span></td>
                <td>8</td>
                <td>
                    <button class="btn btn-warning btn-sm btn-sua"><i class="bi bi-pencil"></i></button>
                    <button class="btn btn-danger btn-sm btn-xoa"><i class="bi bi-trash"></i></button>
                </td>
            </tr>

            <tr>
                <td>DM003</td>
                <td>Drone thể thao tốc độ cao</td>

                <td>
                    <img src="${pageContext.request.contextPath}/image/thethao.png"
                         alt="Ảnh danh mục"
                         class="img-thumbnail"
                         style="width: 60px; height: 60px; object-fit: cover;">
                </td>

                <td><span class="badge bg-success">Hiện</span></td>
                <td>5</td>
                <td>
                    <button class="btn btn-warning btn-sm btn-sua"><i class="bi bi-pencil"></i></button>
                    <button class="btn btn-danger btn-sm btn-xoa"><i class="bi bi-trash"></i></button>
                </td>
            </tr>

            <tr>
                <td>DM004</td>
                <td>Drone nông nghiệp</td>

                <td>
                    <img src="${pageContext.request.contextPath}/image/nongnghiep.png"
                         alt="Ảnh danh mục"
                         class="img-thumbnail"
                         style="width: 60px; height: 60px; object-fit: cover;">
                </td>

                <td><span class="badge bg-secondary">Ẩn</span></td>
                <td>6</td>
                <td>
                    <button class="btn btn-warning btn-sm btn-sua"><i class="bi bi-pencil"></i></button>
                    <button class="btn btn-danger btn-sm btn-xoa"><i class="bi bi-trash"></i></button>
                </td>
            </tr>

            <tr>
                <td>DM005</td>
                <td>Drone giám sát / an ninh</td>

                <td>
                    <img src="${pageContext.request.contextPath}/image/giamsat.png"
                         alt="Ảnh danh mục"
                         class="img-thumbnail"
                         style="width: 60px; height: 60px; object-fit: cover;">
                </td>

                <td><span class="badge bg-success">Hiện</span></td>
                <td>4</td>
                <td>
                    <button class="btn btn-warning btn-sm btn-sua"><i class="bi bi-pencil"></i></button>
                    <button class="btn btn-danger btn-sm btn-xoa"><i class="bi bi-trash"></i></button>
                </td>
            </tr>

            <tr>
                <td>DM006</td>
                <td>Drone mini / cỡ nhỏ</td>

                <td>
                    <img src="${pageContext.request.contextPath}/image/mini.png"
                         alt="Ảnh danh mục"
                         class="img-thumbnail"
                         style="width: 60px; height: 60px; object-fit: cover;">
                </td>

                <td><span class="badge bg-success">Hiện</span></td>
                <td>10</td>
                <td>
                    <button class="btn btn-warning btn-sm btn-sua"><i class="bi bi-pencil"></i></button>
                    <button class="btn btn-danger btn-sm btn-xoa"><i class="bi bi-trash"></i></button>
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

<!-- === MODAL THÊM / SỬA DANH MỤC === -->
<div class="modal fade" id="modalDanhMuc" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Cập Nhật Danh Mục</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <form id="formDanhMuc" class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Mã danh mục</label>
                        <input type="text" class="form-control" id="maDM" placeholder="Nhập mã danh mục">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Tên danh mục</label>
                        <input type="text" class="form-control" id="tenDM" placeholder="Nhập tên danh mục">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Ảnh đại diện</label>
                        <input type="file" class="form-control" id="anhDM">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Trạng thái</label>
                        <select class="form-select" id="trangThaiDM">
                            <option>Hiện</option>
                            <option>Ẩn</option>
                        </select>
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
<!-- === SCRIPT === -->
<script>
    $(document).ready(function () {

        // === KHỞI TẠO DATATABLE ===
        var table = $('#tableDanhMuc').DataTable({
            paging: true,
            info: false,
            lengthChange: false,
            searching: true,     // Ẩn thanh search mặc định
            pageLength: 10,
            language: {
                zeroRecords: "Không tìm thấy kết quả"
            }
        });

        // === CẬP NHẬT HIỂN THỊ TRANG ===
        function updatePageInfo() {
            var info = table.page.info();
            $("#pageInfo").text((info.page + 1) + " / " + info.pages);
        }
        updatePageInfo();


        // === NÚT TRƯỚC ===
        $("#prevPage").click(function () {
            table.page('previous').draw('page');
            updatePageInfo();
        });

        // === NÚT SAU ===
        $("#nextPage").click(function () {
            table.page('next').draw('page');
            updatePageInfo();
        });


        $("#searchInput").on("keyup", function () {
            let value = $(this).val();
            table.search(value).draw(); // search value
            updatePageInfo();
        });

        // ======= LOGOUT =======
        $("#logoutBtn").on("click", function () {
            $("#logoutModal").css("display", "flex");
        });

        $("#cancelLogout").on("click", function () {
            $("#logoutModal").hide();
        });


        // === COMBO "HIỂN THỊ 5 / 10 / 20 DANH MỤC" ===
        $("#rowsPerPage").change(function () {
            var value = $(this).val();
            table.page.len(value).draw();
            updatePageInfo();
        });


        // === NÚT DELETE ===
        $(document).on('click', '.btn-xoa', function (e) {
            e.preventDefault();

            let row = $(this).closest("tr"); // lưu hàng cần xóa

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

                    // Xóa hàng trong DataTable
                    table.row(row).remove().draw();
                    updatePageInfo();

                    Swal.fire({
                        title: "Đã xóa!",
                        text: "Danh mục đã được xóa.",
                        icon: "success",
                        confirmButtonColor: "#0d6efd"
                    });
                }
            });
        });



    });

    // ====== XỬ LÝ NÚT CHỈNH SỬA ======
    $(document).on("click", ".btn-sua", function () {

        // Lấy hàng chứa nút đang bấm
        let row = $(this).closest("tr");

        // Lấy dữ liệu từ bảng
        let maDM = row.find("td:eq(0)").text().trim();
        let tenDM = row.find("td:eq(1)").text().trim();
        let trangThai = row.find("td:eq(3)").text().trim();

        // Gán dữ liệu vào modal
        $("#maDM").val(maDM);
        $("#tenDM").val(tenDM);
        $("#trangThaiDM").val(trangThai);

        // Mở modal chỉnh sửa
        $("#modalDanhMuc").modal("show");
    });
</script>


</body>
</html>
