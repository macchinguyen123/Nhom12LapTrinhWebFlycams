<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Trang Quản Lý Khách Hàng</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/customer-manage.css">
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
                <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
                <style>
                    /* CSS cho form chỉnh sửa */
                    .edit-form-container {
                        background: white;
                        padding: 30px;
                        border-radius: 10px;
                        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                        margin-top: 20px;
                    }

                    .form-section {
                        margin-bottom: 25px;
                        padding-bottom: 20px;
                        border-bottom: 1px solid #e0e0e0;
                    }

                    .form-section:last-child {
                        border-bottom: none;
                    }

                    .section-title {
                        color: #2c3e50;
                        font-weight: 600;
                        margin-bottom: 15px;
                        display: flex;
                        align-items: center;
                        gap: 8px;
                    }

                    .btn-save-custom {
                        background: #28a745;
                        color: white;
                        padding: 10px 30px;
                        border: none;
                        border-radius: 5px;
                        font-weight: 600;
                    }

                    .btn-save-custom:hover {
                        background: #218838;
                        color: white;
                    }

                    .status-toggle {
                        display: flex;
                        align-items: center;
                        gap: 15px;
                    }

                    #successAlert {
                        display: none;
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
                            <a href="${pageContext.request.contextPath}/admin/dashboard">
                                <li><i class="bi bi-speedometer2"></i> Tổng Quan</li>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/customer-manage">
                                <li class="active"><i class="bi bi-person-lines-fill"></i> Quản Lý Tài Khoản</li>
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
                                <li><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
                            </a>
                        </ul>
                    </aside>
                    <main class="main-content container-fluid p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="text-primary fw-bold"><i class="bi bi-person-lines-fill"></i> Quản Lý Khách Hàng
                            </h4>
                            <div class="d-flex align-items-center gap-2">
                                <!-- THANH TÌM KIẾM -->
                                <form class="d-flex" role="search" style="max-width: 300px;">
                                    <div class="input-group">
                                        <span class="input-group-text bg-primary text-white">
                                            <i class="bi bi-search"></i>
                                        </span>
                                        <input id="search" type="search" class="form-control"
                                            placeholder="Tìm kiếm khách hàng..." aria-label="Tìm kiếm">
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- ✅ HIỂN THỊ BẢNG DANH SÁCH KHI showDetail = false -->
                        <c:if test="${empty showDetail or showDetail == false}">
                            <div class="users-table mt-4">
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
                                        <c:forEach items="${users}" var="u">
                                            <tr>
                                                <td>${u.id}</td>
                                                <td>${u.fullName}</td>
                                                <td>${u.username}</td>
                                                <td>${u.email}</td>
                                                <td>${u.phoneNumber}</td>
                                                <td>${u.address}</td>
                                                <td class="text-center">
                                                    <button
                                                        class="btn btn-sm ${u.status ? 'btn-success' : 'btn-danger'}"
                                                        onclick="toggleLock(this, ${u.id})">
                                                        <i
                                                            class="bi ${u.status ? 'bi-unlock-fill' : 'bi-lock-fill'}"></i>
                                                    </button>
                                                </td>
                                                <td class="text-center">
                                                    <a href="${pageContext.request.contextPath}/admin/customer-detail?id=${u.id}"
                                                        class="btn btn-warning btn-sm">
                                                        <i class="bi bi-pencil-square"></i> Sửa
                                                    </a>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <div class="d-flex justify-content-end align-items-center mt-3">
                                    <button id="prevPage" class="btn btn-outline-primary btn-sm">Trước</button>
                                    <span id="pageInfo" class="mx-2">1 / 1</span>
                                    <button id="nextPage" class="btn btn-outline-primary btn-sm">Sau</button>
                                </div>
                            </div>
                        </c:if>
                        <!-- ✅ HIỂN THỊ CHI TIẾT KHI showDetail = true -->
                        <c:if test="${showDetail}">
                            <div class="order-card mt-4">
                                <a href="${pageContext.request.contextPath}/admin/customer-manage"
                                    class="btn btn-secondary mb-3">⬅ Quay lại</a>
                                <!-- ✨ THÊM MỚI: Form chỉnh sửa thông tin -->
                                <div class="edit-form-container">
                                    <h5 class="mb-4"><i class="bi bi-pencil-square"></i> Chỉnh Sửa Thông Tin</h5>
                                    <form id="editCustomerForm" method="POST"
                                        action="${pageContext.request.contextPath}/admin/update-customer">
                                        <input type="hidden" name="id" value="${detailUser.id}">
                                        <!-- Thông tin cơ bản -->
                                        <div class="form-section">
                                            <div class="section-title">
                                                <i class="bi bi-person-badge"></i>
                                                Thông Tin Cơ Bản
                                            </div>
                                            <div class="row">
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label fw-semibold">Họ và Tên <span
                                                            class="text-danger">*</span></label>
                                                    <input type="text" class="form-control" name="fullName"
                                                        value="${detailUser.fullName}" required>
                                                </div>
                                                <div class="col-md-6 mb-3">
                                                    <label class="form-label fw-semibold">Quyền Hạn (Role) <span
                                                            class="text-danger">*</span></label>
                                                    <select class="form-select" name="roleId" required>
                                                        <option value="1" <c:if test="${detailUser.roleId == 1}">
                                                            selected
                        </c:if>>1 - Admin (Quản trị viên)</option>
                        <option value="2" <c:if test="${detailUser.roleId == 2}">selected</c:if>>2 - User (Người dùng)
                        </option>
                        </select>
                </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Tên đăng nhập <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="username" value="${detailUser.username}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label fw-semibold">Mật khẩu</label>
                        <input type="text" class="form-control" name="password" value="${detailUser.password}">
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12 mb-3">
                        <label class="form-label fw-semibold">Avatar URL</label>
                        <input type="text" class="form-control" name="avatar" value="${detailUser.avatar}">
                    </div>
                </div>
                </div>
                <!-- Thông tin liên hệ -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="bi bi-envelope"></i>
                        Thông Tin Liên Hệ
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Email <span class="text-danger">*</span></label>
                            <input type="email" class="form-control" name="email" value="${detailUser.email}" required>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Số Điện Thoại <span
                                    class="text-danger">*</span></label>
                            <input type="tel" class="form-control" name="phoneNumber" value="${detailUser.phoneNumber}"
                                required pattern="[0-9]{10,11}">
                        </div>
                        <div class="col-md-12 mb-3">
                            <label class="form-label fw-semibold">Địa chỉ</label>
                            <input type="text" class="form-control" name="address" value="${detailUser.address}">
                        </div>
                    </div>
                </div>
                <!-- Thông tin cá nhân -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="bi bi-calendar-heart"></i>
                        Thông Tin Cá Nhân
                    </div>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Ngày Sinh</label>
                            <fmt:formatDate value="${detailUser.birthDate}" pattern="yyyy-MM-dd"
                                var="birthDateFormatted" />
                            <input type="date" class="form-control" name="birthDate"
                                value="${birthDateFormatted != null ? birthDateFormatted : ''}">
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label fw-semibold">Giới Tính</label>
                            <select class="form-select" name="gender">
                                <option value="">-- Chưa chọn --</option>
                                <option value="Nam" <c:if test="${detailUser.gender eq 'Nam'}">
                                    selected
                                    </c:if>>Nam</option>
                                <option value="Nữ" <c:if test="${detailUser.gender eq 'Nữ'}">selected</c:if>>Nữ</option>
                                <option value="Khác" <c:if test="${detailUser.gender eq 'Khác'}">selected</c:if>>Khác
                                </option>
                            </select>
                        </div>
                    </div>
                </div>
                <!-- Trạng thái tài khoản -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="bi bi-shield-check"></i>
                        Trạng Thái Tài Khoản
                    </div>
                    <div class="row">
                        <div class="col-md-12 mb-3">
                            <label class="form-label fw-semibold">Trạng Thái</label>
                            <div class="status-toggle">
                                <div class="form-check form-switch">
                                    <input class="form-check-input" type="checkbox" id="statusSwitch" name="status"
                                        value="true" ${detailUser.status ? 'checked' : '' }>
                                    <label class="form-check-label" for="statusSwitch">
                                        <span id="statusText"
                                            class="badge ${detailUser.status ? 'bg-success' : 'bg-danger'}">
                                            ${detailUser.status ? 'Hoạt động' : 'Bị khóa'}
                                        </span>
                                    </label>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- Nút hành động -->
                <div class="d-flex justify-content-end gap-2 mt-4">
                    <a href="${pageContext.request.contextPath}/admin/customer-manage" class="btn btn-secondary">
                        <i class="bi bi-x-circle"></i> Hủy
                    </a>
                    <button type="submit" class="btn btn-save-custom">
                        <i class="bi bi-check-circle"></i> Lưu Thay Đổi
                    </button>
                </div>
                </form>
                </div>
                </div>
                </c:if>
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
                    function toggleLock(btn, userId) {
                        const icon = btn.querySelector("i");
                        const isLocked = btn.classList.contains("btn-danger");
                        const newStatus = isLocked ? 1 : 0;
                        fetch("toggle-user-status", {
                            method: "POST",
                            headers: { "Content-Type": "application/x-www-form-urlencoded" },
                            body: "id=" + userId + "&status=" + newStatus
                        });
                        if (isLocked) {
                            btn.classList.remove("btn-danger");
                            btn.classList.add("btn-success");
                            icon.classList.remove("bi-lock-fill");
                            icon.classList.add("bi-unlock-fill");
                        } else {
                            btn.classList.remove("btn-success");
                            btn.classList.add("btn-danger");
                            icon.classList.remove("bi-unlock-fill");
                            icon.classList.add("bi-lock-fill");
                        }
                    }
                    // Logout modal
                    document.addEventListener("DOMContentLoaded", function () {
                        const logoutBtn = document.getElementById("logoutBtn");
                        const logoutModal = document.getElementById("logoutModal");
                        const cancelLogout = document.getElementById("cancelLogout");
                        logoutBtn.addEventListener("click", function () {
                            logoutModal.style.display = "flex";
                        });
                        cancelLogout.addEventListener("click", function () {
                            logoutModal.style.display = "none";
                        });
                    });
    // DataTable - chỉ chạy khi KHÔNG ở chế độ chi tiết
    <c:if test="${empty showDetail or showDetail == false}">
    $(document).ready(function () {
        var table = $('#tableKhachHang').DataTable({
            "paging": true,
            "lengthChange": false,
            "pageLength": 5,
            "searching": true,
            "ordering": true,
            "info": false,
            "dom": 't',
            "columnDefs": [
                { orderable: false, targets: [6, 7] }
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
        $("#search").on("keyup search", function () {
            table.search(this.value).draw();
            updatePageInfo();
        });
        $("#rowsPerPage").on("change", function () {
            table.page.len($(this).val()).draw();
            updatePageInfo();
        });
        $("#prevPage").click(function () {
            table.page('previous').draw('page');
            updatePageInfo();
        });
        $("#nextPage").click(function () {
            table.page('next').draw('page');
            updatePageInfo();
        });
        function updatePageInfo() {
            var info = table.page.info();
            $('#pageInfo').text((info.page + 1) + " / " + info.pages);
        }
        table.on('draw', updatePageInfo);
        updatePageInfo();
    });
    </c:if>
    // ✨ THÊM MỚI: JavaScript cho form chỉnh sửa
    // ✨ THÊM MỚI: JavaScript cho form chỉnh sửa
    <c:if test="${showDetail}">
    // Toggle status text
    document.getElementById('statusSwitch').addEventListener('change', function() {
        const statusText = document.getElementById('statusText');
        if (this.checked) {
            statusText.textContent = 'Hoạt động';
            statusText.className = 'badge bg-success';
        } else {
            statusText.textContent = 'Bị khóa';
            statusText.className = 'badge bg-danger';
        }
    });
    // Toast Notification logic
    function showToast(message, type) {
        // Remove existing toasts
        const existingToasts = document.querySelectorAll('.custom-toast-container');
        existingToasts.forEach(t => t.remove());
        // Create new toast container
        const toastContainer = document.createElement('div');
        toastContainer.className = 'custom-toast-container position-fixed top-50 start-50 translate-middle p-3';
        toastContainer.style.zIndex = '1055';
        const toastHtml = `
            <div id="liveToast" class="toast align-items-center text-white bg-` + (type === 'success' ? 'success' : 'danger') + ` border-0" role="alert" aria-live="assertive" aria-atomic="true">
                <div class="d-flex">
                    <div class="toast-body">
                        <i class="bi ` + (type === 'success' ? 'bi-check-circle-fill' : 'bi-exclamation-triangle-fill') + ` me-2"></i>
                        ` + message + `
                    </div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                </div>
            </div>
        `;
        toastContainer.innerHTML = toastHtml;
        document.body.appendChild(toastContainer);
        const toastElement = document.getElementById('liveToast');
        const toast = new bootstrap.Toast(toastElement, { delay: 3000 });
        toast.show();
    }
    // Xử lý submit form
    document.addEventListener("DOMContentLoaded", function () {
        const form = document.getElementById('editCustomerForm');
        if(form) {
            form.addEventListener('submit', function(e) {
                e.preventDefault(); // ngăn reload trang
                const formData = new FormData(this);
                fetch(this.action, {
                    method: 'POST',
                    body: formData
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            showToast('Thông tin đã được cập nhật thành công!', 'success');
                            // Không cần scroll lên đầu nữa vì dùng Toast
                        } else {
                            showToast(data.msg || 'Cập nhật thất bại', 'error');
                        }
                    })
                    .catch(err => {
                        showToast('Có lỗi xảy ra khi cập nhật.', 'error');
                        console.error(err);
                    });
            });
        }
    });
    </c:if>
                </script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>