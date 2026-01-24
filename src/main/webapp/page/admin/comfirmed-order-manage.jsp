<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Quản Trị - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/stylesheets/admin/comfirmed-order-manage.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>


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
<!-- LAYOUT -->
<div class="layout">
    <!-- SIDEBAR -->
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
                        <li class="active">Đã Xác Nhận</li>
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

    <!-- MAIN -->
    <main class="main-content container-fluid p-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
            <h4 class="text-primary fw-bold mb-0"><i class="bi bi-truck"></i> Danh Sách Giao Hàng</h4>

            <div class="d-flex flex-wrap justify-content-between align-items-center gap-3 w-100">

                <!-- Lọc bên trái -->
                <div class="btn-group shadow-sm" role="group">
                    <button class="btn btn-outline-secondary active filter" data-status="all">
                        <i class="bi bi-list-ul"></i> Tất cả
                    </button>

                    <button class="btn btn-outline-warning filter" data-status="Đang xử lý">
                        <i class="bi bi-hourglass-split"></i> Chờ xử lý
                    </button>

                    <button class="btn btn-outline-primary filter" data-status="Đang giao hàng">
                        <i class="bi bi-truck"></i> Đang giao
                    </button>

                    <button class="btn btn-outline-success filter" data-status="Giao thành công">
                        <i class="bi bi-check-circle"></i> Thành công
                    </button>

                    <button class="btn btn-outline-danger filter" data-status="Giao thất bại">
                        <i class="bi bi-x-circle"></i> Thất bại
                    </button>
                </div>

                <!-- Tìm kiếm bên phải -->
                <div class="input-group shadow-sm" style="max-width: 300px;">
                                    <span class="input-group-text bg-primary text-white"><i
                                            class="bi bi-search"></i></span>
                    <input id="search" type="search" class="form-control"
                           placeholder="Tìm kiếm đơn hàng...">
                </div>

            </div>
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
        <!-- TABLE -->
        <table id="tblDonHang" class="table table-striped table-bordered align-middle">
            <thead class="table-primary text-center">
            <tr>
                <th>Mã VC</th>
                <th>Mã ĐH</th>
                <th>Mã KH</th>
                <th>Địa Chỉ</th>
                <th>Ngày Nhận</th>
                <th>Trạng Thái</th>
                <th>Thao Tác</th>
            </tr>
            </thead>
            <tbody class="text-center" id="orderTableBody">
            <c:forEach var="o" items="${orders}">
                <tr>
                    <!-- Mã VC -->
                    <td>${o.shippingCode}</td>

                    <!-- Mã ĐH -->
                    <td>${o.id}</td>

                    <!-- Mã KH -->
                    <td>${o.userId}</td>

                    <!-- Địa chỉ -->
                    <td>${o.fullAddress}</td>

                    <!-- Ngày nhận -->
                    <td>
                        <fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy"/>
                    </td>

                    <!-- Trạng thái -->
                    <td>
                                            <span class="badge ${o.statusClass}">
                                                    ${o.statusLabel}
                                            </span>
                    </td>

                    <!-- Thao tác -->
                    <td>
                        <button class="btn btn-primary btn-sm view" data-id="${o.id}"
                                onclick="loadOrderDetail(${o.id}) ">
                            <i class="bi bi-eye"></i> Xem / Cập Nhật
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

<!-- MODAL -->
<div class="modal fade" id="modalDonHang" tabindex="-1">
    <div class="modal-dialog modal-xl">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-clipboard-check"></i> Chi Tiết & Cập Nhật Đơn
                    Hàng</h5>
                <button type="button" class="btn-close btn-close-white"
                        data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body">
                <form id="formDonHang">
                    <div class="row g-3">

                        <!-- CỘT TRÁI -->
                        <div class="col-lg-6">

                            <!-- Thông tin hóa đơn -->
                            <div class="info-card">
                                <h6>🧾 Thông Tin Hóa Đơn</h6>

                                <div class="info-row">
                                    <div class="info-label">Mã Hóa Đơn:</div>
                                    <div class="info-value" id="dh-mahd">001</div>
                                </div>

                                <div class="info-row">
                                    <div class="info-label">Mã Khách Hàng:</div>
                                    <div class="info-value" id="dh-makh">001</div>
                                </div>

                                <div class="info-row">
                                    <div class="info-label">Tên Khách Hàng:</div>
                                    <div class="info-value">
                                        <input type="text" id="dh-tenkh"
                                               class="form-control form-control-sm" value="Nguyễn Văn A">
                                    </div>
                                </div>

                                <div class="info-row">
                                    <div class="info-label">Số Điện Thoại:</div>
                                    <div class="info-value">
                                        <input type="text" id="dh-sdt"
                                               class="form-control form-control-sm" value="0905123123">
                                    </div>
                                </div>

                                <div class="info-row">
                                    <div class="info-label">Email:</div>
                                    <div class="info-value">
                                        <input type="email" id="dh-email"
                                               class="form-control form-control-sm"
                                               value="nguyenvana@gmail.com">
                                    </div>
                                </div>

                                <div class="info-row">
                                    <div class="info-label">Ngày Lập:</div>
                                    <div class="info-value" id="dh-ngaylap">2025-02-14</div>
                                </div>
                            </div>

                            <!-- Thông tin giao hàng -->
                            <div class="info-card">
                                <h6>🚚 Thông Tin Giao Hàng</h6>

                                <div class="mb-3">
                                    <label class="form-label">Địa Chỉ Giao Hàng</label>
                                    <input type="text" class="form-control" id="dh-diachi"
                                           value="123 Nguyễn Trãi, Quận 1, TP.HCM">
                                </div>

                                <div class="info-row">
                                    <div class="info-label">Mã Vận Chuyển:</div>
                                    <div class="info-value" id="dh-mavc">GHN123</div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Ngày Hoàn Thành</label>
                                    <input type="date" class="form-control" id="dh-ngaynhan" value="">
                                </div>

                                <div class="info-row">
                                    <div class="info-label">Phí Vận Chuyển:</div>
                                    <div class="info-value" id="dh-phivc">35,000₫</div>
                                </div>
                            </div>
                        </div>

                        <!-- CỘT PHẢI -->
                        <div class="col-lg-6">

                            <!-- Danh sách sản phẩm -->
                            <div class="info-card">
                                <h6>📦 Danh Sách Sản Phẩm</h6>

                                <table class="product-table table-sm">
                                    <thead>
                                    <tr>
                                        <th style="width: 50%">Tên Sản Phẩm</th>
                                        <th style="width: 15%">SL</th>
                                        <th style="width: 35%">Đơn Giá</th>
                                    </tr>
                                    </thead>

                                    <tbody id="dh-sanpham">
                                    <tr>
                                        <td>Flycam Mini 4K</td>
                                        <td>1</td>
                                        <td>2,500,000₫</td>
                                    </tr>
                                    <tr>
                                        <td>Pin Dự Phòng Drone</td>
                                        <td>2</td>
                                        <td>450,000₫</td>
                                    </tr>
                                    </tbody>
                                </table>

                                <div class="total-row">
                                    Tổng Tiền: <span id="dh-tong">3,400,000₫</span>
                                </div>
                            </div>

                            <!-- Thông tin thanh toán -->
                            <div class="info-card">
                                <h6>💳 Thông Tin Thanh Toán & Vận Chuyển</h6>

                                <div class="mb-3">
                                    <label class="form-label">Hình Thức Thanh Toán</label>
                                    <input type="text" class="form-control" id="dh-httt"
                                           value="Thanh toán khi nhận hàng" readonly>
                                </div>

                                <div class="info-row">
                                    <div class="info-label">Trạng Thái Thanh Toán:</div>
                                    <div class="info-value" id="dh-tttt">Chưa thanh toán</div>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Trạng Thái Vận Chuyển</label>
                                    <select class="form-select" id="dh-ttvc">
                                        <option value="Đang xử lý">Đang xử lý</option>
                                        <option value="Đang giao">Đang giao hàng</option>
                                        <option value="Hoàn thành">Giao thành công</option>
                                        <option value="Hủy">Giao thất bại</option>
                                    </select>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Ghi Chú</label>
                                    <textarea class="form-control" id="dh-note"
                                              rows="3">Khách cần gọi trước khi giao.</textarea>
                                </div>

                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="bi bi-x-circle"></i> Đóng
                </button>

                <button type="submit" form="formDonHang" class="btn btn-success">
                    <i class="bi bi-check-circle"></i> Lưu Thay Đổi
                </button>
            </div>
        </div>
    </div>
</div>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    let currentOrderId = null;
    let currentUserId = null;

    function loadOrderDetail(orderId) {
        currentOrderId = orderId;

        fetch('${pageContext.request.contextPath}/admin/order-detail?id=' + orderId)
            .then(res => {
                if (!res.ok) throw new Error("HTTP " + res.status);
                return res.json();
            })
            .then(data => {
                if (!data || !data.order) {
                    alert("Không có dữ liệu đơn hàng");
                    return;
                }

                const o = data.order;

                // ===== THÔNG TIN HÓA ĐƠN =====
                document.getElementById("dh-mahd").innerText = o.id;
                currentUserId = o.user_id;
                document.getElementById("dh-makh").innerText = o.user_id;

                document.getElementById("dh-tenkh").value = o.customerName || "";
                document.getElementById("dh-sdt").value = o.phoneNumber || "";
                document.getElementById("dh-email").value = o.email || "";

                document.getElementById("dh-ngaylap").innerText =
                    formatDate(o.createdAt);

                // ===== THÔNG TIN GIAO HÀNG =====
                document.getElementById("dh-diachi").value =
                    o.fullAddress || "";

                document.getElementById("dh-mavc").innerText =
                    o.shippingCode || "Chưa có";

                // if (o.expectedDeliveryDate) {
                //     document.getElementById("dh-ngaynhan").value =
                //         o.expectedDeliveryDate.substring(0, 10);
                // } else {
                //     document.getElementById("dh-ngaynhan").value = "";
                // }
                document.getElementById("dh-ngaynhan").value =
                    o.completedAt ? o.completedAt.substring(0, 10) : "";

                document.getElementById("dh-phivc").innerText =
                    o.shippingFee
                        ? Number(o.shippingFee).toLocaleString("vi-VN") + "₫"
                        : "0₫";

                const items = data.items;
                const tbody = document.getElementById("dh-sanpham");
                tbody.innerHTML = "";

                let total = 0;

                items.forEach(item => {
                    const tr = document.createElement("tr");

                    const tdName = document.createElement("td");
                    tdName.textContent = item.productName || "—";
                    tr.appendChild(tdName);

                    const tdQty = document.createElement("td");
                    tdQty.textContent = item.quantity ?? "—";
                    tr.appendChild(tdQty);

                    const tdPrice = document.createElement("td");
                    const priceNum = Number(item.price) || 0;
                    tdPrice.textContent = priceNum.toLocaleString("vi-VN") + "₫";
                    tr.appendChild(tdPrice);

                    total += priceNum * (item.quantity || 1);

                    tbody.appendChild(tr);
                });

                document.getElementById("dh-tong").innerText =
                    total.toLocaleString("vi-VN") + "₫";

                //thông tin thanh toán
                document.getElementById("dh-httt").value =
                    o.paymentMethod || "COD";

                document.getElementById("dh-tttt").innerText =
                    o.paymentMethod ? "Đã chọn" : "Chưa thanh toán";

                //Trạng thái van chuyen
                document.getElementById("dh-ttvc").value = o.status;

                // ===== HIỆN MODAL =====
                const modal = new bootstrap.Modal(
                    document.getElementById("modalDonHang")
                );
                modal.show();
            })
            .catch(err => {
                console.error(err);
                alert("Lỗi tải chi tiết đơn hàng");
            });
    }

    function formatDate(dateStr) {
        if (!dateStr) return "—";
        const d = new Date(dateStr);
        return d.toLocaleDateString("vi-VN");
    }

    $(document).ready(function () {
        var table = $('#tblDonHang').DataTable({
            "paging": true,
            "lengthChange": false,
            "pageLength": 10,
            "searching": true,
            "ordering": true,
            "info": true,
            order: [[1, "desc"]],

            // ẨN THANH SEARCH MẶC ĐỊNH
            dom: "tr", // t = table, r = info (ẩn search & paginate mặc định)

            "language": {
                "paginate": {"previous": "Trước", "next": "Sau"},
                "info": "Trang _PAGE_ / _PAGES_",
                "zeroRecords": "Không tìm thấy dữ liệu"
            }
        });


        // ======= SEARCH MÀU XANH =======
        $("#search").on("keyup", function () {
            table.search(this.value).draw();
        });

        // ======= ROW PER PAGE =======
        $("#rowsPerPage").on("change", function () {
            table.page.len($(this).val()).draw();
        });

        // ======= FILTER TRẠNG THÁI =======
        $(".filter").on("click", function () {
            $(".filter").removeClass("active");
            $(this).addClass("active");

            const status = $(this).data("status");
            if (status === "all") table.column(5).search("").draw();
            else table.column(5).search(status).draw();

            updatePagination();
        });

        // ======= PAGINATION CUSTOM =======
        function updateCustomPagination() {
            var info = table.page.info();
            $("#pageInfo").text((info.page + 1) + " / " + info.pages);

            // Ẩn nút Trước khi đang ở trang đầu
            $("#prevPage").prop("disabled", info.page === 0);

            // Ẩn nút Sau khi đang ở trang cuối
            $("#nextPage").prop("disabled", info.page >= info.pages - 1);
        }

        // Nút SAU
        $("#nextPage").on("click", function () {
            table.page("next").draw("page");
            updateCustomPagination();
        });

        // Nút TRƯỚC
        $("#prevPage").on("click", function () {
            table.page("previous").draw("page");
            updateCustomPagination();
        });

        // Cập nhật khi load
        table.on("draw", updateCustomPagination);
        updateCustomPagination();

        // // ======= MODAL =======
        // $(".view").on("click", function () {
        //     new bootstrap.Modal(document.getElementById("modalDonHang")).show();
        // });
        //
        // $("#formDonHang").on("submit", function (e) {
        //     e.preventDefault();
        //     alert("Lưu thành công (demo)!");
        //     bootstrap.Modal.getInstance(document.getElementById("modalDonHang")).hide();
        // });

        // ======= LOGOUT =======
        $("#logoutBtn").on("click", function () {
            $("#logoutModal").css("display", "flex");
        });

        $("#cancelLogout").on("click", function () {
            $("#logoutModal").hide();
        });
    });


</script>
<script>
    document.getElementById("formDonHang").addEventListener("submit", function (e) {
        e.preventDefault();

        if (!currentOrderId) {
            alert("Không xác định đơn hàng");
            return;
        }

        const payload = {
            orderId: currentOrderId,
            userId: document.getElementById("dh-makh").innerText.replace("KH", ""),
            fullName: document.getElementById("dh-tenkh").value,
            email: document.getElementById("dh-email").value,
            phoneNumber: document.getElementById("dh-sdt").value,
            fullAddress: document.getElementById("dh-diachi").value,
            paymentMethod: document.getElementById("dh-httt").value,
            status: document.getElementById("dh-ttvc").value,
            note: document.getElementById("dh-note").value
        };

        fetch("${pageContext.request.contextPath}/admin/update-order", {
            method: "POST",
            headers: {"Content-Type": "application/json"},
            body: JSON.stringify(payload)
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    Swal.fire({
                        icon: "success",
                        title: "Cập nhật thành công",
                        timer: 1500,
                        showConfirmButton: false
                    });

                    bootstrap.Modal.getInstance(
                        document.getElementById("modalDonHang")
                    ).hide();

                    setTimeout(() => location.reload(), 800);
                } else {
                    Swal.fire("Lỗi", "Không cập nhật được đơn hàng", "error");
                }
            })
            .catch(err => {
                console.error(err);
                Swal.fire("Lỗi", "Lỗi hệ thống", "error");
            });
    });
</script>

</body>

</html>