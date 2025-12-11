<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Lý Khuyến Mãi - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Bootstrap Bundle (gồm cả Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="../../stylesheets/admin/promotion-manage.css">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

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

<!-- ===== BỐ CỤC CHÍNH ===== -->
<div class="bo-cuc">
    <!-- === SIDEBAR === -->
    <aside class="sidebar">
        <div class="user-info">
            <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar">

            <h3>Mạc Nguyên</h3>
            <p>Chào mừng bạn trở lại 👋</p>
        </div>

        <ul class="menu">
            <a href="dashboard.jsp">
                <li><i class="bi bi-speedometer2"></i> Tổng Quan</li>
            </a>
            <a href="customer-manage.jsp">
                <li><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
            </a>
            <a href="product-management.jsp">
                <li><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li>
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
            <a href="promotion-manage.html">
                <li class="active"><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li>
            </a>
            <a href="statistics.jsp">
                <li><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
            </a>
        </ul>
    </aside>


    <!-- === NỘI DUNG CHÍNH === -->
    <main class="main-content container-fluid p-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-primary fw-bold"><i class="bi bi-tags"></i> Quản Lý Khuyến Mãi</h4>
            <!-- THANH TÌM KIẾM -->
            <form class="d-flex" role="search" style="max-width: 300px;">
                <div class="input-group">
                <span class="input-group-text bg-primary text-white">
                    <i class="bi bi-search"></i>
                </span>
                    <input id="searchInput" type="search" class="form-control"
                           placeholder="Tìm kiếm khuyến mãi..." aria-label="Tìm kiếm">
                </div>
            </form>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#hopThoaiKhuyenMai">
                <i class="bi bi-plus-lg"></i> Thêm Khuyến Mãi
            </button>
        </div>

        <div class="d-flex justify-content-start align-items-center mb-2">
            <label class="me-2">Hiển thị</label>
            <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                <option value="5">5</option>
                <option value="10" selected>10</option>
                <option value="20">20</option>
            </select>
            <label class="ms-2">khuyến mãi</label>
        </div>


        <!-- === BẢNG DANH SÁCH KHUYẾN MÃI === -->
        <table id="bangKhuyenMai" class="table table-striped table-bordered">
            <thead class="table-primary">
            <tr>
                <th>Mã KM</th>
                <th>Tên Chương Trình</th>
                <th>Mức Giảm</th>
                <th>Thời Gian Áp Dụng</th>
                <th>Phạm Vi Áp Dụng</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td>KM001</td>
                <td>Giảm 20% toàn bộ Drone</td>
                <td>20%</td>
                <td>2025-11-01 - 2025-11-15</td>
                <td>Toàn bộ sản phẩm</td>
                <td>
                    <button class="btn btn-warning btn-sm nut-sua"><i class="bi bi-pencil"></i></button>
                    <button class="btn btn-danger btn-sm nut-xoa"><i class="bi bi-trash"></i></button>
                </td>
            </tr>
            <tr>
                <td>KM002</td>
                <td>Giảm 500k cho Drone quay phim</td>
                <td>500.000đ</td>
                <td>2025-11-05 - 2025-11-20</td>
                <td>Danh mục Drone quay phim</td>
                <td>
                    <button class="btn btn-warning btn-sm nut-sua"><i class="bi bi-pencil"></i></button>
                    <button class="btn btn-danger btn-sm nut-xoa"><i class="bi bi-trash"></i></button>
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

<!-- === HỘP THOẠI THÊM / SỬA === -->
<div class="modal fade" id="hopThoaiKhuyenMai" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header bg-primary text-white">
                <h5 class="modal-title"><i class="bi bi-pencil-square"></i> Cập Nhật Khuyến Mãi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <form id="bieuMauKhuyenMai" class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Mã khuyến mãi</label>
                        <input type="text" class="form-control" id="maKhuyenMai" placeholder="Nhập mã khuyến mãi">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Tên chương trình</label>
                        <input type="text" class="form-control" id="tenChuongTrinh" placeholder="Nhập tên chương trình">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Mức giảm</label>
                        <input type="text" class="form-control" id="mucGiam" placeholder="VD: 20% hoặc 200000đ">
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-bold">Phạm vi áp dụng</label>
                        <div id="dsDanhMuc" class="border rounded p-3 bg-light">
                            <div><input type="checkbox" value="Áp Dụng Tất Cả"> Áp Dụng Tất Cả</div>
                            <div><input type="checkbox" value="Áp Dụng Danh Mục"> Áp Dụng Danh Mục</div>
                            <div><input type="checkbox" value="Áp Dụng Sản Phẩm"> Áp Dụng Sản Phẩm</div>

                        </div>
                    </div>

                    <!-- Ô nhập riêng mã sản phẩm -->
                    <div class="col-12">
                        <label class="form-label fw-bold mt-2">Mã sản phẩm áp dụng riêng (nếu có)</label>
                        <input type="text" id="maSanPhamRieng" class="form-control" placeholder="VD: SP001, SP002">
                    </div>

                    <div class="col-12">
                        <label class="form-label fw-bold mt-2">Mã danh mục áp dụng riêng (nếu có)</label>
                        <input type="text" id="maDanhMucRieng" class="form-control" placeholder="VD: DM001, DM002">
                    </div>


                    <div class="col-md-6">
                        <label class="form-label">Ngày bắt đầu</label>
                        <input type="date" class="form-control" id="ngayBatDau">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Ngày kết thúc</label>
                        <input type="date" class="form-control" id="ngayKetThuc">
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

<script>
    $(document).ready(function () {

        // ===== KHỞI TẠO DATATABLE =====
        let table = $("#bangKhuyenMai").DataTable({
            paging: true,
            info: false,
            lengthChange: false,
            searching: true,     // Ẩn thanh search mặc định
            pageLength: 10,
            language: {
                zeroRecords: "Không tìm thấy kết quả"
            }
        });

        // Ẩn UI gốc của DataTables (nếu chưa có CSS trong file)
        $(".dataTables_filter, .dataTables_paginate").hide();

        // --- Thanh tìm kiếm custom ---
        $("#searchInput").on("keyup", function () {
            table.search(this.value).draw();
            updatePageInfo();
        });

        // --- Nút chuyển trang custom ---
        $("#nextPage").click(function () {
            table.page("next").draw("page");
            updatePageInfo();
        });

        $("#prevPage").click(function () {
            table.page("previous").draw("page");
            updatePageInfo();
        });

        // Cập nhật thông tin trang
        function updatePageInfo() {
            let info = table.page.info();
            $("#pageInfo").text((info.page + 1) + " / " + info.pages);
        }

        updatePageInfo();


        // === NÚT DELETE ===
        $(document).on('click', '.nut-xoa', function (e) {
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

        // ======= LOGOUT =======
        $("#logoutBtn").on("click", function () {
            $("#logoutModal").css("display", "flex");
        });

        $("#cancelLogout").on("click", function () {
            $("#logoutModal").hide();
        });
        // ===== NÚT LƯU =====
        $(".btn.btn-primary").click(function () {
            const maKM = $("#maKhuyenMai").val().trim();
            const tenCT = $("#tenChuongTrinh").val().trim();
            const mucGiam = $("#mucGiam").val().trim();
            const ngayBD = $("#ngayBatDau").val();
            const ngayKT = $("#ngayKetThuc").val();

            if (!maKM || !tenCT || !ngayBD || !ngayKT) {
                alert("⚠️ Vui lòng nhập đầy đủ thông tin!");
                return;
            }

            let danhMuc = [];
            $("#dsDanhMuc input[type=checkbox]:checked").each(function () {
                danhMuc.push($(this).val());
            });

            const phamVi = danhMuc.join(", ") || "Không có danh mục";

            const maSP = $("#maSanPhamRieng").val().trim();
            const phamViCuoi = maSP ? `${phamVi} (SP: ${maSP})` : phamVi;

            let daCo = false;

            table.rows().every(function () {
                let d = this.data();
                if (d[0] === maKM) {
                    d[1] = tenCT;
                    d[2] = mucGiam;
                    d[3] = `${ngayBD} - ${ngayKT}`;
                    d[4] = phamViCuoi;
                    this.data(d);
                    daCo = true;
                }
            });

            if (!daCo) {
                table.row.add([
                    maKM,
                    tenCT,
                    mucGiam,
                    `${ngayBD} - ${ngayKT}`,
                    phamViCuoi,
                    `<button class="btn btn-warning btn-sm nut-sua"><i class="bi bi-pencil"></i></button>
                 <button class="btn btn-danger btn-sm nut-xoa"><i class="bi bi-trash"></i></button>`
                ]).draw();
            }

            $("#bieuMauKhuyenMai")[0].reset();
            $("#dsDanhMuc input[type=checkbox]").prop("checked", false);

            bootstrap.Modal.getInstance(document.querySelector("#hopThoaiKhuyenMai")).hide();
        });

        // ===== NÚT SỬA =====
        $("#bangKhuyenMai tbody").on("click", ".nut-sua", function () {
            const row = table.row($(this).closest("tr"));
            const d = row.data();

            $("#maKhuyenMai").val(d[0]);
            $("#tenChuongTrinh").val(d[1]);
            $("#mucGiam").val(d[2]);

            const tg = d[3].split(" - ");
            $("#ngayBatDau").val(tg[0]);
            $("#ngayKetThuc").val(tg[1]);

            let text = d[4];
            let maSP = "";

            const match = text.match(/\(SP: (.+)\)/);
            if (match) {
                maSP = match[1];
                text = text.replace(/\(SP: .+\)/, "").trim();
            }

            $("#maSanPhamRieng").val(maSP);

            const arr = text.split(",").map(s => s.trim());
            $("#dsDanhMuc input[type=checkbox]").each(function () {
                $(this).prop("checked", arr.includes($(this).val()));
            });

            new bootstrap.Modal("#hopThoaiKhuyenMai").show();
        });


    });
</script>

</body>
</html>
