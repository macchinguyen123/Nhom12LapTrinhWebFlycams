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
                <!-- Bootstrap Bundle (gồm cả Popper) -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/stylesheets/admin/uncomfirmed-order-manage.css">
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
                            <a href="${pageContext.request.contextPath}/admin/customer-manage">
                                <li><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/product-management">
                                <li><i class="bi bi-box-seam"></i> Quản Lý Sản Phẩm</li>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/category-manage">
                                <li><i class="bi bi-tags"></i> Quản Lý Danh Mục</li>
                            </a>

                            <li class="has-submenu open">
                                <div class="menu-item">
                                    <i class="bi bi-truck"></i>
                                    <span>Quản Lý Đơn Hàng</span>
                                    <i class="bi bi-chevron-right arrow"></i>
                                </div>
                                <ul class="submenu">
                                    <a href="uncomfirmed-order-manage.html">
                                        <li class="active">Chưa Xác Nhận</li>
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
                            <h4 class="text-primary fw-bold">
                                <i class="bi bi-receipt-cutoff"></i> Quản Lý Đơn Hàng
                            </h4>

                            <!-- THANH TÌM KIẾM -->
                            <form class="d-flex" role="search" style="max-width: 300px;">
                                <div class="input-group">
                                    <span class="input-group-text bg-primary text-white">
                                        <i class="bi bi-search"></i>
                                    </span>
                                    <input id="searchInput" type="search" class="form-control"
                                        placeholder="Tìm kiếm đơn hàng..." aria-label="Tìm kiếm">
                                </div>
                            </form>
                        </div>

                        <div class="d-flex justify-content-start align-items-center mb-2">
                            <label class="me-2">Hiển thị</label>
                            <select id="rowsPerPage" class="form-select d-inline-block" style="width:80px;">
                                <option value="5">5</option>
                                <option value="10" selected>10</option>
                                <option value="20">20</option>
                            </select>
                            <label class="ms-2">đơn hàng</label>
                        </div>
                        <!-- === BẢNG ĐƠN HÀNG === -->
                        <table id="tableDonHang" class="table table-striped table-bordered align-middle">
                            <thead class="table-primary">
                                <tr>
                                    <th>Mã Hoá Đơn</th>
                                    <th>Tên Khách Hàng</th>
                                    <th>Số Điện Thoại</th>
                                    <th>Ngày Lập HĐ</th>
                                    <th>Tổng Tiền</th>
                                    <th>Trạng Thái Thanh Toán</th>
                                    <th>Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${orders}" var="o">
                                    <tr>
                                        <td>${o.id}</td>

                                        <td>${o.customerName}</td>

                                        <td>${o.phoneNumber}</td>

                                        <td>
                                            <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>

                                        <td>
                                            <fmt:formatNumber value="${o.totalPrice}" type="currency" />
                                        </td>

                                        <td>
                                            <span class="badge ${o.statusClass}">
                                                ${o.statusLabel}
                                            </span>
                                        </td>

                                        <td>
                                            <button class="btn btn-info btn-sm" data-id="${o.id}"
                                                onclick="loadOrderDetail(${o.id})">
                                                <i class="bi bi-eye"></i> Xem Chi Tiết
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
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

                <!-- === MODAL CHI TIẾT ĐƠN HÀNG (CỐ ĐỊNH DỮ LIỆU) === -->
                <div class="modal fade" id="modalChiTietDonHang" tabindex="-1">
                    <div class="modal-dialog modal-xl">
                        <div class="modal-content shadow-lg border-0 rounded-4 overflow-hidden">

                            <div class="modal-header bg-gradient bg-primary text-white">
                                <h5 class="modal-title d-flex align-items-center gap-2">
                                    <i class="bi bi-file-earmark-text"></i> Chi Tiết Đơn Hàng
                                </h5>
                                <button type="button" class="btn-close btn-close-white"
                                    data-bs-dismiss="modal"></button>
                            </div>

                            <div class="modal-body p-4">
                                <div class="row g-4">
                                    <!-- CỘT TRÁI -->
                                    <div class="col-md-6">
                                        <div class="card border-0 shadow-sm rounded-4">
                                            <div class="card-body">
                                                <h6 class="fw-bold text-primary mb-2">🧾 Thông tin hóa đơn</h6>
                                                <table class="table table-sm table-borderless mb-3">
                                                    <tbody>
                                                        <tr>
                                                            <th>Mã hóa đơn:</th>
                                                            <td><span id="md_orderCode">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Tên khách hàng:</th>
                                                            <td><span id="md_customerName">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Số điện thoại:</th>
                                                            <td><span id="md_phone">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Email:</th>
                                                            <td><span id="md_email">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Ngày lập đơn:</th>
                                                            <td><span id="md_createdAt">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Tổng tiền:</th>
                                                            <td>
                                                                <span id="md_totalPrice"
                                                                    class="fw-bold text-danger">---</span>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <h6 class="fw-bold text-primary mb-2">🚚 Thông tin giao hàng</h6>
                                                <table class="table table-sm table-borderless">
                                                    <tbody>
                                                        <tr>
                                                            <th>Địa chỉ giao:</th>
                                                            <td><span id="md_address">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Mã vận đơn:</th>
                                                            <td><span id="md_shippingCode">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Ngày giao/nhận:</th>
                                                            <td><span id="md_completedAt">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Phí vận chuyển:</th>
                                                            <td>Miễn phí</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- CỘT PHẢI -->
                                    <div class="col-md-6">
                                        <div class="card border-0 shadow-sm rounded-4">
                                            <div class="card-body">

                                                <h6 class="fw-bold text-primary mb-2">📦 Sản phẩm trong đơn</h6>
                                                <table class="table table-bordered align-middle text-center small">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>Tên sản phẩm</th>
                                                            <th>SL</th>
                                                            <th>Giá</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody id="md_productList">
                                                        <!-- JS render -->
                                                    </tbody>
                                                </table>

                                                <h6 class="fw-bold text-primary mt-3 mb-2">💳 Thanh toán & Trạng thái
                                                </h6>
                                                <table class="table table-sm table-borderless">
                                                    <tbody>
                                                        <tr>
                                                            <th>Hình thức TT:</th>
                                                            <td><span id="md_paymentMethod">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Trạng thái TT:</th>
                                                            <td><span id="md_paymentStatus">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Trạng thái VC:</th>
                                                            <td><span id="md_orderStatus">---</span></td>
                                                        </tr>
                                                        <tr>
                                                            <th>Ghi chú:</th>
                                                            <td><span id="md_note">---</span></td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="modal-footer bg-light d-flex justify-content-between">
                                <div class="text-muted small fst-italic">Kiểm tra kỹ trước khi xác nhận đơn hàng.</div>
                                <div>
                                    <button id="cancelBtn" class="btn btn-outline-danger">
                                        <i class="bi bi-x-circle"></i> Từ Chối
                                    </button>
                                    <button id="confirmBtn" class="btn btn-success">
                                        <i class="bi bi-check-circle"></i> Xác Nhận
                                    </button>
                                </div>
                            </div>

                        </div>
                    </div>
                </div>

                <!-- Thêm CSS & JS DataTables -->
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
                <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


                <script>
                    // Thêm biến toàn cục ở đầu script
                    let currentOrderId = null;

                    function loadOrderDetail(orderId) {
                        // Lưu orderId vào biến toàn cục
                        currentOrderId = orderId;

                        fetch('${pageContext.request.contextPath}/admin/order-detail?id=' + orderId)
                            .then(res => {
                                if (!res.ok) throw new Error("HTTP " + res.status);
                                return res.json();
                            })
                            .then(data => {
                                if (!data || !data.items) {
                                    alert("Không có dữ liệu đơn hàng");
                                    return;
                                }

                                const o = data.order;

                                document.getElementById("md_orderCode").innerText = "HD" + o.id;
                                document.getElementById("md_customerName").innerText = o.customerName;
                                document.getElementById("md_phone").innerText = o.phoneNumber;
                                document.getElementById("md_email").innerText = o.email || "—";
                                document.getElementById("md_createdAt").innerText = formatDate(o.createdAt);
                                document.getElementById("md_totalPrice").innerText =
                                    Number(o.totalPrice).toLocaleString("vi-VN") + "₫";

                                document.getElementById("md_address").innerText = o.address || "—";
                                document.getElementById("md_shippingCode").innerText =
                                    o.shippingCode || "Chưa có";
                                document.getElementById("md_completedAt").innerText =
                                    o.completedAt ? formatDate(o.completedAt) : "Chưa giao";

                                const items = data.items;
                                const tbody = document.getElementById("md_productList");
                                tbody.innerHTML = "";

                                items.forEach(item => {
                                    const tr = document.createElement("tr");

                                    const tdName = document.createElement("td");
                                    tdName.textContent = item.productName || "—";
                                    tr.appendChild(tdName);

                                    const tdQty = document.createElement("td");
                                    tdQty.textContent = item.quantity != null ? item.quantity : "—";
                                    tr.appendChild(tdQty);

                                    const tdPrice = document.createElement("td");
                                    const priceNum = parseFloat(item.price) || 0;
                                    tdPrice.textContent = priceNum.toLocaleString("vi-VN") + "₫";
                                    tr.appendChild(tdPrice);

                                    tbody.appendChild(tr);
                                });

                                document.getElementById("md_paymentMethod").innerText =
                                    o.paymentMethod || "COD";

                                document.getElementById("md_paymentStatus").innerText =
                                    o.paymentMethod ? "Đã chọn" : "Chưa thanh toán";

                                document.getElementById("md_orderStatus").innerText = o.status;
                                document.getElementById("md_note").innerText = o.note || "—";

                                const modal = new bootstrap.Modal(
                                    document.getElementById("modalChiTietDonHang")
                                );
                                modal.show();
                            })
                            .catch(err => {
                                console.error(err);
                                alert("Lỗi tải chi tiết đơn hàng");
                            });
                    }

                    function formatDate(dateStr) {
                        const d = new Date(dateStr);
                        return d.toLocaleDateString("vi-VN");
                    }

                    function handleOrderAction(orderId, action) {
                        const params = new URLSearchParams();
                        params.append('id', orderId);
                        params.append('action', action);

                        console.log("Sending:", orderId, action);

                        // ===== SHOW LOADING =====
                        Swal.fire({
                            title: "Đang xử lý...",
                            text: "Vui lòng chờ trong giây lát",
                            allowOutsideClick: false,
                            didOpen: () => {
                                Swal.showLoading();
                            }
                        });

                        fetch('${pageContext.request.contextPath}/admin/order-action', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            body: params.toString()
                        })
                            .then(res => res.json())
                            .then(data => {
                                Swal.close();

                                if (data.success) {
                                    Swal.fire({
                                        title: "Thành công!",
                                        text: "Trạng thái đơn hàng đã được cập nhật",
                                        icon: "success",
                                        confirmButtonColor: "#0d6efd"
                                    });

                                    // Xóa dòng khỏi DataTable
                                    const table = $('#tableDonHang').DataTable();
                                    table
                                        .row($('#tableDonHang button[data-id="' + orderId + '"]').parents('tr'))
                                        .remove()
                                        .draw();

                                    // Đóng modal chi tiết
                                    const modal = bootstrap.Modal.getInstance(
                                        document.getElementById('modalChiTietDonHang')
                                    );
                                    modal.hide();

                                } else {
                                    Swal.fire({
                                        title: "Thất bại!",
                                        text: "Không thể cập nhật đơn hàng",
                                        icon: "error",
                                        confirmButtonColor: "#dc3545"
                                    });
                                }
                            })
                            .catch(err => {
                                Swal.close();
                                console.error("Error:", err);

                                Swal.fire({
                                    title: "Lỗi kết nối!",
                                    text: "Không thể kết nối đến server",
                                    icon: "error",
                                    confirmButtonColor: "#dc3545"
                                });
                            });
                    }

                    $(document).ready(function () {
                        // --- KHỞI TẠO DATATABLE ---
                        var table = $('#tableDonHang').DataTable({
                            paging: true,
                            info: false,
                            lengthChange: false,
                            searching: true,
                            pageLength: 10,
                            language: {
                                zeroRecords: "Không tìm thấy kết quả",
                                paginate: { previous: "Trước", next: "Sau" }
                            },
                            dom: 't',
                        });

                        // --- CẬP NHẬT THÔNG TIN TRANG ---
                        function updatePageInfo() {
                            var info = table.page.info();
                            $("#pageInfo").text((info.page + 1) + " / " + info.pages);
                        }

                        updatePageInfo();

                        $("#prevPage").click(function () {
                            table.page('previous').draw('page');
                            updatePageInfo();
                        });

                        $("#nextPage").click(function () {
                            table.page('next').draw('page');
                            updatePageInfo();
                        });

                        $("#searchInput").on("keyup", function () {
                            let value = $(this).val();
                            table.search(value).draw();
                            updatePageInfo();
                        });

                        $("#rowsPerPage").change(function () {
                            var value = $(this).val();
                            table.page.len(value).draw();
                            updatePageInfo();
                        });

                        table.on('draw', function () {
                            updatePageInfo();
                        });

                        // ======= XỬ LÝ NÚT XÁC NHẬN - DÙNG BIẾN TOÀN CỤC =======
                        $("#confirmBtn").on("click", function () {

                            if (!currentOrderId) {
                                Swal.fire({
                                    icon: "error",
                                    title: "Lỗi",
                                    text: "Không xác định được đơn hàng",
                                    confirmButtonColor: "#0d6efd"
                                });
                                return;
                            }

                            Swal.fire({
                                title: "Xác nhận đơn hàng?",
                                text: "Bạn có chắc chắn muốn xác nhận đơn hàng này?",
                                icon: "question",
                                showCancelButton: true,
                                confirmButtonText: "Xác nhận",
                                cancelButtonText: "Hủy",
                                confirmButtonColor: "#198754", // xanh giống product
                                cancelButtonColor: "#6c757d"
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    handleOrderAction(currentOrderId, "confirm");
                                }
                            });
                        });


                        // ======= XỬ LÝ NÚT TỪ CHỐI - DÙNG BIẾN TOÀN CỤC =======
                        $("#cancelBtn").on("click", function () {

                            if (!currentOrderId) {
                                Swal.fire({
                                    icon: "error",
                                    title: "Lỗi",
                                    text: "Không xác định được đơn hàng",
                                    confirmButtonColor: "#0d6efd"
                                });
                                return;
                            }

                            Swal.fire({
                                title: "Từ chối đơn hàng?",
                                text: "Đơn hàng sẽ bị hủy và không thể hoàn tác!",
                                icon: "warning",
                                showCancelButton: true,
                                confirmButtonText: "Từ chối",
                                cancelButtonText: "Hủy",
                                confirmButtonColor: "#dc3545", // đỏ giống xóa sản phẩm
                                cancelButtonColor: "#6c757d"
                            }).then((result) => {
                                if (result.isConfirmed) {
                                    handleOrderAction(currentOrderId, "cancel");
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
                    });
                </script>

            </body>

            </html>