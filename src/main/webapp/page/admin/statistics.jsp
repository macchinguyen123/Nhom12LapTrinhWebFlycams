<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang Thống Kê</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="../../stylesheets/admin/statistics.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

</head>
<body>

<header class="main-header">
    <div class="logo">
        <img src="${pageContext.request.contextPath}/image/logoo2.png" alt="Logo">
        <h2>SkyDrone Admin</h2>
    </div>
    <div class="header-right">
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
                <a href="../login.jsp"><button id="confirmLogout" class="confirm">Có</button></a>
                <button id="cancelLogout" class="cancel">Không</button>
            </div>
        </div>
    </div>
</header>

<div class="layout">

    <aside class="sidebar">
        <div class="user-info">
            <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar">
            <h3>Mạc Nguyên</h3>
            <p>Chào mừng bạn trở lại 👋</p>
        </div>

        <ul class="menu">
            <a href="dashboard.jsp"><li><i class="bi bi-speedometer2"></i> Tổng Quan</li></a>
            <a href="customer-manage.jsp"><li><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li></a>
            <a href="product-management.jsp"><li><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li></a>
            <a href="category-manage.jsp"><li><i class="bi bi-tags"></i> Quản Lý Danh Mục</li></a>

            <li class="has-submenu">
                <div class="menu-item">
                    <i class="bi bi-truck"></i>
                    <span>Quản Lý Đơn Hàng</span>
                    <i class="bi bi-chevron-right arrow"></i>
                </div>
                <ul class="submenu">
                    <a href="uncomfirmed-order-manage.jsp"><li>Chưa Xác Nhận</li></a>
                    <a href="comfirmed-order-manage.jsp"><li>Đã Xác Nhận</li></a>
                </ul>
            </li>

            <a href="blog-manage.jsp"><li><i class="bi bi-journal-text"></i> Quản Lý Blog</li></a>
            <a href="promotion-manage.jsp"><li><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li></a>
            <a href="statistics.html"><li class="active"><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li></a>
        </ul>
    </aside>

    <main class="main-content container-fluid p-4">

        <!-- === DANH SÁCH ĐƠN TRONG NGÀY === -->
        <section class="donTrongNgay mb-5">
            <h4 class="tieude mb-3"><i class="bi bi-truck"></i><b> Danh Sách Đơn Hàng Trong Ngày</b></h4>

            <!-- Thanh tìm kiếm -->
            <div class="d-flex align-items-center mb-3">
                <div class="d-flex align-items-center shadow-sm"
                     style="background:#fff;border-radius:8px;overflow:hidden;border:1px solid #dee2e6;max-width:320px;">
                    <div class="d-flex align-items-center justify-content-center"
                         style="background-color:#0d6efd;color:#fff;width:45px;height:40px;">
                        <i class="bi bi-search"></i>
                    </div>
                    <input id="searchBox" type="text" class="form-control border-0"
                           placeholder="Tìm kiếm đơn hàng..." style="box-shadow:none;height:40px;">
                </div>
            </div>

            <div class="d-flex justify-content-start align-items-center mb-2">
                <label class="me-2">Hiển thị</label>
                <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                    <option value="5">5</option>
                    <option value="10" selected>10</option>
                    <option value="20">20</option>
                </select>
                <label class="ms-2">dòng</label>
            </div>


            <div class="table-responsive">
                <table id="tableDonTrongNgay" class="table table-striped table-bordered align-middle text-center">
                    <thead class="table-primary">
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Khách Hàng</th>
                        <th>Ngày Đặt</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                        <th>Chi Tiết</th>
                    </tr>
                    </thead>

                    <tbody id="donHangBody">
                    <!-- GIỮ NGUYÊN CÁC DÒNG DỮ LIỆU -->
                    <tr><td>DH001</td><td>Nguyễn Văn A</td><td>08/11/2025</td><td>2.350.000 VND</td><td><span class="badge bg-warning text-dark">Chờ xác nhận</span></td><td><button class="btn btn-info btn-sm xemChiTiet"><i class="bi bi-eye"></i></button></td></tr>
                    <tr><td>DH002</td><td>Trần Thị B</td><td>08/11/2025</td><td>4.800.000 VND</td><td><span class="badge bg-success">Đã giao</span></td><td><button class="btn btn-info btn-sm xemChiTiet"><i class="bi bi-eye"></i></button></td></tr>
                    <tr><td>DH003</td><td>Trần Thị C</td><td>08/11/2025</td><td>4.800.000 VND</td><td><span class="badge bg-success">Đã giao</span></td><td><button class="btn btn-info btn-sm xemChiTiet"><i class="bi bi-eye"></i></button></td></tr>
                    <tr><td>DH004</td><td>Nguyễn Anh Minh</td><td>03/11/2025</td><td>10.390.000 VND</td><td><span class="badge bg-success">Đã giao</span></td><td><button class="btn btn-info btn-sm xemChiTiet"><i class="bi bi-eye"></i></button></td></tr>
                    <tr><td>DH005</td><td>Lê Minh</td><td>03/11/2025</td><td>22.300.000 VND</td><td><span class="badge bg-success">Đã giao</span></td><td><button class="btn btn-info btn-sm xemChiTiet"><i class="bi bi-eye"></i></button></td></tr>
                    <tr><td>DH006</td><td>Phạm Đình Khang</td><td>05/11/2025</td><td>12.230.000 VND</td><td><span class="badge bg-success">Đã giao</span></td><td><button class="btn btn-info btn-sm xemChiTiet"><i class="bi bi-eye"></i></button></td></tr>
                    <tr><td>DH007</td><td>Nguyễn Anh Tuấn</td><td>03/11/2025</td><td>19.390.000 VND</td><td><span class="badge bg-success">Đã giao</span></td><td><button class="btn btn-info btn-sm xemChiTiet"><i class="bi bi-eye"></i></button></td></tr>
                    <tr><td>DH008</td><td>Lý Chí Huy</td><td>03/11/2025</td><td>9.090.000 VND</td><td><span class="badge bg-success">Đã giao</span></td><td><button class="btn btn-info btn-sm xemChiTiet"><i class="bi bi-eye"></i></button></td></tr>
                    </tbody>
                </table>
            </div>

            <div class="d-flex justify-content-end align-items-center mt-3">
                <div class="pagination-controls">
                    <button id="prevPage" class="btn btn-outline-primary btn-sm">Trước</button>
                    <span id="pageInfo" class="mx-2">1 / 1</span>
                    <button id="nextPage" class="btn btn-outline-primary btn-sm">Sau</button>
                </div>
            </div>

        </section>
    </main>

</div>

<!-- === SCRIPT === -->

<script>
    $(document).ready(function () {

        // ===== KHỞI TẠO DATATABLE =====
        let table = $("#tableDonTrongNgay").DataTable({
            paging: true,
            info: false,
            lengthChange: false,
            searching: true,
            pageLength: 10,
            language: {
                zeroRecords: "Không tìm thấy dữ liệu"
            }
        });

        // Ẩn search + paginate gốc của DataTables
        $(".dataTables_filter, .dataTables_paginate").hide();

        // --- Search custom ---
        $("#searchBox").on("keyup", function () {
            table.search(this.value).draw();
            updatePageInfo();
        });

        // --- Chọn số dòng 5 / 10 / 20 ---
        $("#rowsPerPage").on("change", function () {
            table.page.len($(this).val()).draw();
            updatePageInfo();
        });

        // --- Nút chuyển trang ---
        $("#nextPage").click(function () {
            table.page('next').draw('page');
            updatePageInfo();
        });

        $("#prevPage").click(function () {
            table.page('previous').draw('page');
            updatePageInfo();
        });

        // ======= LOGOUT =======
        $("#logoutBtn").on("click", function () {
            $("#logoutModal").css("display", "flex");
        });

        $("#cancelLogout").on("click", function () {
            $("#logoutModal").hide();
        });

        // --- Cập nhật thông tin trang ---
        function updatePageInfo() {
            let info = table.page.info();
            $("#pageInfo").text((info.page + 1) + " / " + info.pages);
        }

        updatePageInfo();
    });
</script>



</body>
</html>
