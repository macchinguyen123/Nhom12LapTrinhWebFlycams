<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Lý Khách Hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="../../stylesheets/admin/customer-manage.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>




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

<div class="layout">
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
                <li class="active"><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
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
            <a href="promotion-manage.jsp">
                <li><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li>
            </a>
            <a href="statistics.jsp">
                <li><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
            </a>
        </ul>
    </aside>

    <main class="main-content container-fluid p-4">
        <div>
            <h4 class="tieude"><i class="bi bi-person-lines-fill"></i><b> Quản Lý Khách Hàng</b></h4>

            <div id="dskh" class="users-table mt-4">

                <!-- Ô tìm kiếm -->
                <div class="input-group custom-search shadow-sm mb-3">
                    <span class="input-group-text">
                        <i class="bi bi-search"></i>
                    </span>
                    <input id="search" type="search" class="form-control" placeholder="Tìm kiếm khách hàng...">
                </div>

                <section>
                    <div class="d-flex justify-content-start align-items-center mb-2">
                        <label class="me-2">Hiển thị</label>
                        <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                            <option value="5" selected>5</option>
                            <option value="10">10</option>
                            <option value="20">20</option>
                        </select>
                        <label class="ms-2">khách hàng</label>
                    </div>
                    <table id="tableKhachHang" class="table table-striped table-bordered">
                        <thead class="table-dark">
                        <tr>
                            <th>Mã KH</th>
                            <th>Họ tên</th>
                            <th>Tên đăng nhập</th>
                            <th>Email</th>
                            <th>Số điện thoại</th>
                            <th>Địa chỉ</th>
                            <th>Khóa tài khoản</th>
                            <th>Chi tiết</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>KH01</td>
                            <td>Mạc Chí Nguyên</td>
                            <td>chinguyen123</td>
                            <td>chinguyenmac2@gmail.com</td>
                            <td>0956392931</td>
                            <td>Toà B, Ký túc xá khu B, Đại Học Quốc Gia TP.HCM</td>
                            <td>
                                <button class="btn btn-lock locked btn-sm" onclick="toggleLock(this)"><i
                                        class="bi bi-lock-fill"></i></button>
                            </td>
                            <td>
                                <button class="btn btn-info btn-sm" onclick="showUserPro('KH01')"><i
                                        class="bi bi-eye"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>KH02</td>
                            <td>Trần Minh Huy</td>
                            <td>huytran99</td>
                            <td>huytran99@gmail.com</td>
                            <td>0987654321</td>
                            <td>123 Nguyễn Trãi, Quận 1, TP.HCM</td>
                            <td>
                                <button class="btn btn-lock unlocked btn-sm" onclick="toggleLock(this)"><i
                                        class="bi bi-unlock-fill"></i></button>
                            </td>
                            <td>
                                <button class="btn btn-info btn-sm" onclick="showUserPro('KH02')"><i
                                        class="bi bi-eye"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>KH03</td>
                            <td>Đặng Ngọc Quyên</td>
                            <td>cdangngocquyen123</td>
                            <td>ngocquin@gmail.com</td>
                            <td>0956391234</td>
                            <td>Toà E, Ký túc xá khu B, Đại Học Quốc Gia TP.HCM</td>
                            <td>
                                <button class="btn btn-lock locked btn-sm" onclick="toggleLock(this)"><i
                                        class="bi bi-lock-fill"></i></button>
                            </td>
                            <td>
                                <button class="btn btn-info btn-sm" onclick="showUserPro('KH01')"><i
                                        class="bi bi-eye"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>KH04</td>
                            <td>Lê Hữu Phước</td>
                            <td>hphuoc23</td>
                            <td>phuocle@gmail.com</td>
                            <td>0924348431</td>
                            <td>Nội Hóa 2, Đông Hòa, TP.HCM</td>
                            <td>
                                <button class="btn btn-lock locked btn-sm" onclick="toggleLock(this)"><i
                                        class="bi bi-lock-fill"></i></button>
                            </td>
                            <td>
                                <button class="btn btn-info btn-sm" onclick="showUserPro('KH01')"><i
                                        class="bi bi-eye"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>KH05</td>
                            <td>Mạc Chí Nguyên</td>
                            <td>chinguyen123</td>
                            <td>chinguyenmac2@gmail.com</td>
                            <td>0956392931</td>
                            <td>Toà B, Ký túc xá khu B, Đại Học Quốc Gia TP.HCM</td>
                            <td>
                                <button class="btn btn-lock locked btn-sm" onclick="toggleLock(this)"><i
                                        class="bi bi-lock-fill"></i></button>
                            </td>
                            <td>
                                <button class="btn btn-info btn-sm" onclick="showUserPro('KH01')"><i
                                        class="bi bi-eye"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>KH06</td>
                            <td>Mạc Chí Nguyên</td>
                            <td>chinguyen123</td>
                            <td>chinguyenmac2@gmail.com</td>
                            <td>0956392931</td>
                            <td>Toà B, Ký túc xá khu B, Đại Học Quốc Gia TP.HCM</td>
                            <td>
                                <button class="btn btn-lock locked btn-sm" onclick="toggleLock(this)"><i
                                        class="bi bi-lock-fill"></i></button>
                            </td>
                            <td>
                                <button class="btn btn-info btn-sm" onclick="showUserPro('KH01')"><i
                                        class="bi bi-eye"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>KH07</td>
                            <td>Mạc Chí Nguyên</td>
                            <td>chinguyen123</td>
                            <td>chinguyenmac2@gmail.com</td>
                            <td>0956392931</td>
                            <td>Toà B, Ký túc xá khu B, Đại Học Quốc Gia TP.HCM</td>
                            <td>
                                <button class="btn btn-lock locked btn-sm" onclick="toggleLock(this)"><i
                                        class="bi bi-lock-fill"></i></button>
                            </td>
                            <td>
                                <button class="btn btn-info btn-sm" onclick="showUserPro('KH01')"><i
                                        class="bi bi-eye"></i></button>
                            </td>
                        </tr>

                        </tbody>
                    </table>


                    <div class="d-flex justify-content-end align-items-center mt-3">
                        <button id="prevPage" class="btn btn-outline-primary btn-sm">Trước</button>
                        <span id="pageInfo" class="mx-2">1 / 1</span>
                        <button id="nextPage" class="btn btn-outline-primary btn-sm">Sau</button>
                    </div>

                </section>
            </div>

            <!-- CHI TIẾT KHÁCH HÀNG -->
            <section>
                <div id="order-detail" class="order-card" style="display: none;">
                    <button class="btn btn-secondary mb-3" onclick="showUsers()">⬅ Quay lại</button>
                    <div>
                        <table class="table table-bordered user-table">
                            <tr>
                                <td>Mã khách hàng</td>
                                <td id="makh">KH001</td>
                            </tr>
                            <tr>
                                <td>Tên đăng nhập</td>
                                <td id="tendn">nguyenvana</td>
                            </tr>
                            <tr>
                                <td>Email</td>
                                <td id="email">vana.nguyen@example.com</td>
                            </tr>
                            <tr>
                                <td>Số điện thoại</td>
                                <td id="sdt">0912345678</td>
                            </tr>
                            <tr>
                                <td>Ngày sinh</td>
                                <td id="ngaysinh">12/08/2000</td>
                            </tr>
                            <tr>
                                <td>Giới tính</td>
                                <td id="gioitinh">Nam</td>
                            </tr>
                            <tr>
                                <td>Địa chỉ</td>
                                <td id="diachi">123 Nguyễn Trãi, Quận 1, TP.HCM</td>
                            </tr>
                            <tr>
                                <td>Ngày đăng ký</td>
                                <td id="ngaydangky">05/02/2022</td>
                            </tr>
                            <tr>
                                <td>Tổng số đơn hàng</td>
                                <td id="tongdon">15</td>
                            </tr>
                            <tr>
                                <td>Tổng tiền đã mua</td>
                                <td id="tongtien">45.560.000₫</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </section>
        </div>
    </main>
</div>



<script>
    // Toggle submenu
    document.querySelectorAll('.has-submenu .menu-item').forEach(item => {
        item.addEventListener('click', () => {
            item.parentElement.classList.toggle('open');
        });
    });

    // Toggle khóa / mở khóa
    function toggleLock(btn) {
        const icon = btn.querySelector('i');

        if (btn.classList.contains('locked')) {
            // Mở khóa
            btn.classList.remove('locked');
            btn.classList.add('unlocked');
            icon.classList.remove('bi-lock-fill');
            icon.classList.add('bi-unlock-fill');
        } else {
            // Khóa lại
            btn.classList.remove('unlocked');
            btn.classList.add('locked');
            icon.classList.remove('bi-unlock-fill');
            icon.classList.add('bi-lock-fill');
        }
    }

    // Hiển thị chi tiết khách hàng
    function showUserPro(id) {
        document.getElementById("dskh").style.display = "none";
        document.getElementById("order-detail").style.display = "block";
    }

    function showUsers() {
        document.getElementById("dskh").style.display = "block";
        document.getElementById("order-detail").style.display = "none";
    }

</script>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const logoutBtn = document.getElementById("logoutBtn");
        const logoutModal = document.getElementById("logoutModal");
        const cancelLogout = document.getElementById("cancelLogout");

        // Mở popup
        logoutBtn.addEventListener("click", function () {
            logoutModal.style.display = "flex";
        });

        // Đóng popup
        cancelLogout.addEventListener("click", function () {
            logoutModal.style.display = "none";
        });
    });

    $(document).ready(function () {
        // Khởi tạo DataTable
        var table = $('#tableKhachHang').DataTable({
            "paging": true,
            "lengthChange": false, // dùng custom select
            "pageLength": 5,
            "searching": true,     // vẫn dùng search riêng
            "ordering": true,
            "info": false,         // ẩn info mặc định
            "dom": 't',            // chỉ hiển thị table, ẩn search + pagination mặc định
            "columnDefs": [
                { orderable: false, targets: [6, 7] } // cột khóa & chi tiết không sắp xếp
            ],
            "language": {
                "emptyTable": "Không có dữ liệu",
                "zeroRecords": "Không tìm thấy dữ liệu phù hợp",
                "searchPlaceholder": "Tìm kiếm...",
                "paginate": {
                    "first": "Đầu",
                    "last": "Cuối",
                    "next": "Sau",
                    "previous": "Trước"
                }
            }

        });

        // ===== CUSTOM SEARCH =====
        $("#search").on("keyup", function () {
            table.search(this.value).draw();
            updatePageInfo();
        });

        // ===== CUSTOM ROWS PER PAGE =====
        $("#rowsPerPage").on("change", function () {
            table.page.len($(this).val()).draw();
            updatePageInfo();
        });

        // ===== CUSTOM PAGINATION BUTTONS =====
        $("#prevPage").click(function () {
            table.page('previous').draw('page');
            updatePageInfo();
        });

        $("#nextPage").click(function () {
            table.page('next').draw('page');
            updatePageInfo();
        });

        // ======= LOGOUT =======
        $("#logoutBtn").on("click", function () {
            $("#logoutModal").css("display", "flex");
        });

        $("#cancelLogout").on("click", function () {
            $("#logoutModal").hide();
        });


        // ===== UPDATE PAGE INFO =====
        function updatePageInfo() {
            var info = table.page.info();
            $('#pageInfo').text((info.page + 1) + " / " + info.pages);
        }

        table.on('draw', updatePageInfo);
        updatePageInfo();
    });


</script>
</body>
</html>
