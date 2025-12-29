<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Trang Thống Kê</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/statistics.css?v=1.1">
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

                <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
                        <a href="${pageContext.request.contextPath}/admin/profile"
                            class="text-decoration-none text-while">
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
                                <a href="${pageContext.request.contextPath}/Login"><button id="confirmLogout"
                                        class="confirm">Có</button></a>
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
                                <li class="active"><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
                            </a>
                        </ul>
                    </aside>

                    <main class="main-content container-fluid p-4">

                        <!-- === DANH SÁCH ĐƠN TRONG NGÀY === -->
                        <section class="donTrongNgay mb-5">
                            <h4 class="tieude mb-3"><i class="bi bi-truck"></i><b> Danh Sách Đơn Hàng Trong Ngày</b>
                            </h4>

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
                                <table id="tableDonTrongNgay"
                                    class="table table-striped table-bordered align-middle text-center">
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
                                        <c:choose>
                                            <c:when test="${empty todayOrders}">
                                                <tr>
                                                    <td colspan="6" class="text-center">Không có đơn hàng nào trong ngày
                                                        hôm nay</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach items="${todayOrders}" var="order">
                                                    <tr>
                                                        <td>${order.id}</td>
                                                        <td>${order.customerName}</td>
                                                        <td>
                                                            <fmt:formatDate value="${order.createdAt}"
                                                                pattern="dd/MM/yyyy HH:mm" />
                                                        </td>
                                                        <td>
                                                            <fmt:formatNumber value="${order.totalPrice}"
                                                                type="currency" currencySymbol="" /> VND
                                                        </td>
                                                        <td><span
                                                                class="badge ${order.statusClass}">${order.statusLabel}</span>
                                                        </td>
                                                        <td><button class="btn btn-info btn-sm"
                                                                onclick="loadOrderDetail('${order.id}')"><i
                                                                    class="bi bi-eye"></i></button></td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
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

                <!-- === MODAL CHI TIẾT ĐƠN HÀNG === -->
                <style>
                    #modalChiTietDonHang .card {
                        width: 100% !important;
                        height: auto !important;
                        border: none !important;
                        padding: 0 !important;
                        margin: 0 !important;
                        text-align: left !important;
                        display: block !important;
                    }

                    #modalChiTietDonHang .card-body {
                        padding: 1.25rem !important;
                    }

                    #modalChiTietDonHang .table {
                        width: 100% !important;
                        margin-bottom: 1rem !important;
                    }

                    #modalChiTietDonHang .modal-header {
                        background: linear-gradient(180deg, #0051c6, #0073ff) !important;
                    }

                    #modalChiTietDonHang .fw-bold {
                        font-weight: 700 !important;
                    }
                </style>
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
                                                            <td><span id="md_totalPrice"
                                                                    class="fw-bold text-danger">---</span></td>
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
                                                    <tbody id="md_productList"></tbody>
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
                            <div class="modal-footer bg-light">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            </div>
                        </div>
                    </div>
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

                    function loadOrderDetail(orderId) {
                        fetch('${pageContext.request.contextPath}/admin/order-detail?id=' + orderId)
                            .then(res => res.json())
                            .then(data => {
                                if (!data || !data.items) {
                                    alert("Không có dữ liệu đơn hàng");
                                    return;
                                }
                                const o = data.order;
                                document.getElementById("md_orderCode").innerText = o.id;
                                document.getElementById("md_customerName").innerText = o.customerName;
                                document.getElementById("md_phone").innerText = o.phoneNumber;
                                document.getElementById("md_email").innerText = o.email || "—";
                                document.getElementById("md_createdAt").innerText = formatDate(o.createdAt);
                                document.getElementById("md_totalPrice").innerText = Number(o.totalPrice).toLocaleString("vi-VN") + "₫";
                                document.getElementById("md_address").innerText = o.address || "—";
                                document.getElementById("md_shippingCode").innerText = o.shippingCode || "Chưa có";
                                document.getElementById("md_completedAt").innerText = o.completedAt ? formatDate(o.completedAt) : "Chưa giao";

                                const tbody = document.getElementById("md_productList");
                                tbody.innerHTML = "";
                                data.items.forEach(item => {
                                    const tr = document.createElement("tr");
                                    tr.innerHTML = `<td>\${item.productName || '—'}</td><td>\${item.quantity || 0}</td><td>\${Number(item.price).toLocaleString('vi-VN')}₫</td>`;
                                    tbody.appendChild(tr);
                                });

                                document.getElementById("md_paymentMethod").innerText = o.paymentMethod || "COD";
                                document.getElementById("md_paymentStatus").innerText = o.paymentMethod ? "Đã chọn" : "Chưa thanh toán";
                                document.getElementById("md_orderStatus").innerText = o.status;
                                document.getElementById("md_note").innerText = o.note || "—";

                                const modal = new bootstrap.Modal(document.getElementById("modalChiTietDonHang"));
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
                </script>



            </body>

            </html>