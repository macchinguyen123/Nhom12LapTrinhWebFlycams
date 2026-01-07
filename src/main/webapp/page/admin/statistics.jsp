<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang Thống Kê</title>

    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">

    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/statistics.css?v=1.2">

    <!-- jQuery & JS -->
    <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


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
                <a href="${pageContext.request.contextPath}/Logout">
                    <button id="confirmLogout" class="confirm">Có</button>
                </a>
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
                <li class="active"><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
            </a>
        </ul>
    </aside>

    <!-- Main Content -->
    <main class="main-content p-4 flex-fill">

        <!-- ===== DANH SÁCH ĐƠN TRONG NGÀY ===== -->
        <section class="mb-5">
            <h4 class="mb-3"><i class="bi bi-truck"></i><b> Danh Sách Đơn Hàng Trong Ngày</b></h4>

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
                <table id="tableDonTrongNgay" class="table table-striped table-bordered text-center">
                    <thead class="table-primary">
                    <tr>
                        <th>Mã Đơn</th>
                        <th>Khách Hàng</th>
                        <th>Ngày Đặt</th>
                        <th>Tổng Tiền</th>
                        <th>Trạng Thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="o" items="${todayOrders}">
                        <tr>
                            <td>#DH${o.id}</td>
                            <td>${o.customerName}</td>
                            <td><fmt:formatDate value="${o.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td class="fw-semibold text-danger"><fmt:formatNumber value="${o.totalPrice}" type="number"/> VND</td>
                            <td><span class="badge ${o.statusClass}">${o.statusLabel}</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>

        <!-- ===== THỐNG KÊ TỔNG QUAN ===== -->
        <section>
            <h4 class="mb-3"><i class="bi bi-bar-chart"></i><b> Thống Kê Tổng Quan</b></h4>
            <div class="d-flex flex-wrap gap-3">
                <div class="card flex-fill text-center p-3">
                    <i class="fa fa-chart-bar fs-2 mb-2" style="color:#0d6efd;"></i>
                    <h5>Doanh thu hôm nay</h5>
                    <p><fmt:formatNumber value="${revenueToday}" type="number"/> VND</p>
                </div>
                <div class="card flex-fill text-center p-3">
                    <i class="fa fa-line-chart fs-2 mb-2" style="color:#0d6efd;"></i>
                    <h5>Doanh thu tháng</h5>
                    <p><fmt:formatNumber value="${revenueMonth}" type="number"/> VND</p>
                </div>
                <div class="card flex-fill text-center p-3">
                    <i class="fa fa-shopping-cart fs-2 mb-2" style="color:#0d6efd;"></i>
                    <h5>Đơn hôm nay</h5>
                    <p>${ordersToday} đơn</p>
                </div>
                <div class="card flex-fill text-center p-3">
                    <i class="fa fa-crown fs-2 mb-2" style="color:#0d6efd;"></i>
                    <h5>Sản phẩm bán chạy</h5>
                    <c:choose>
                        <c:when test="${empty bestProduct}">
                            <p>Chưa có dữ liệu</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="p" items="${bestProduct}">
                                <p>${p.key} (SL: ${p.value})</p>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>

        <!-- ===== BIỂU ĐỒ DOANH THU 8 NGÀY ===== -->
        <section class="mt-4">
            <h4 class="mb-3"><i class="bi bi-graph-up-arrow"></i><b> Biểu đồ doanh thu 8 ngày gần nhất</b></h4>
            <div class="card shadow-sm p-3 mb-4">
                <canvas id="chartDoanhThuNgay" height="250"></canvas>
            </div>
            <h4 class="mb-3"><i class="bi bi-graph-up-arrow"></i> <b> Biểu đồ doanh thu theo tháng </b></h4>
            <div class="card shadow-sm p-3">
                <canvas id="chartDoanhThuThang" height="250"></canvas>
            </div>
        </section>

    </main>
</div>

<!-- ===== SCRIPT ===== -->
<script>
    $(document).ready(function () {
        let table = $("#tableDonTrongNgay").DataTable({
            paging: true,
            info: false,
            lengthChange: false,
            searching: true,
            pageLength: 10,
            language: { zeroRecords: "Không tìm thấy dữ liệu", emptyTable: "Không có đơn hàng hôm nay" }
        });

        $(".dataTables_filter, .dataTables_paginate").hide();

        $("#searchBox").on("keyup", function () { table.search(this.value).draw(); });
        $("#rowsPerPage").on("change", function () { table.page.len($(this).val()).draw(); });
    });

    // ===== CHART DOANH THU 8 NGÀY =====
    const revenueDays = [
        <c:forEach var="d" items="${revenueDays}" varStatus="st">
        "${d}"<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    const revenueValues = [
        <c:forEach var="v" items="${revenueValues}" varStatus="st">
        ${v}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    const ctx = document.getElementById('chartDoanhThuNgay').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: revenueDays.map(d => {
                let dt = new Date(d);
                return ("0"+dt.getDate()).slice(-2) + "/" + ("0"+(dt.getMonth()+1)).slice(-2);
            }),
            datasets: [{
                label: 'Doanh thu (VND)',
                data: revenueValues,
                backgroundColor: '#0d6efd',
                borderRadius: 5
            }]
        },
        options: {
            responsive: true,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, ticks: { callback: val => val.toLocaleString("vi-VN") + " ₫" } },
                x: { grid: { display: false } }
            }
        }
    });
    const revenueMonths = [
        <c:forEach var="m" items="${revenueMonths}" varStatus="st">
        "${m}"<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];
    const revenueMonthValues = [
        <c:forEach var="v" items="${revenueMonthValues}" varStatus="st">
        ${v}<c:if test="${!st.last}">,</c:if>
        </c:forEach>
    ];

    const ctxMonth = document.getElementById('chartDoanhThuThang').getContext('2d');
    new Chart(ctxMonth, {
        type: 'bar',
        data: {
            labels: revenueMonths.map(m => "Tháng " + m),
            datasets: [{
                label: 'Doanh thu (VND)',
                data: revenueMonthValues,
                backgroundColor: '#0d6efd',
                borderRadius: 5
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    callbacks: {
                        label: ctx => ctx.formattedValue.replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " ₫"
                    }
                }
            },
            scales: {
                y: { beginAtZero: true, ticks: { callback: val => val.toLocaleString("vi-VN") + " ₫" } },
                x: { grid: { display: false } }
            }
        }
    });
</script>

</body>
</html>
