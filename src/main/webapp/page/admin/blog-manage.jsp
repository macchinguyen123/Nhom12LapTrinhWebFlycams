<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>



                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <title>Trang Quản Lý Blog</title>
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <link rel="stylesheet" href="../../stylesheets/admin/blog-manage.css">
                    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
                    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
                    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

                    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/blog-manage.css">

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
                    <c:if test="${param.msg == 'deleted'}">
                        <div class="alert alert-success">Xóa bài viết thành công!</div>
                    </c:if>

                    <c:if test="${param.error == 'delete_failed'}">
                        <div class="alert alert-danger">Xóa bài viết thất bại!</div>
                    </c:if>

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
                                    <li class="active"><i class="bi bi-journal-text"></i> Quản Lý Blog</li>
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
                            <!-- Tiêu đề -->
                            <div class="d-flex justify-content-between align-items-center mb-3">
                                <h4 class="text-primary fw-bold"><i class="bi bi-journal-text"></i> Quản Lý Blog</h4>
                            </div>

                            <div class="d-flex justify-content-between align-items-center mb-3">

                                <!-- Ô TÌM KIẾM -->
                                <form class="d-flex" role="search" style="max-width: 300px;">
                                    <div class="input-group">
                                        <span class="input-group-text bg-primary text-white">
                                            <i class="bi bi-search"></i>
                                        </span>
                                        <input id="searchBlogInput" type="search" class="form-control"
                                            placeholder="Tìm kiếm bài viết...">
                                    </div>
                                </form>

                                <!-- NÚT THÊM BÀI VIẾT -->
                                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#addBlogModal">
                                    <i class="bi bi-plus-lg"></i> Thêm Bài Viết
                                </button>

                            </div>


                            <div class="modal fade" id="addBlogModal" tabindex="-1">
                                <div class="modal-dialog modal-lg">
                                    <div class="modal-content">

                                        <form action="${pageContext.request.contextPath}/admin/blog-manage"
                                            method="post">

                                            <div class="modal-header">
                                                <i class="bi bi-plus-lg"></i> Thêm Bài Viết
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>

                                            <div class="modal-body">

                                                <input type="hidden" name="action" value="add">

                                                <div class="mb-3">
                                                    <label class="form-label">Tiêu đề</label>
                                                    <input type="text" name="title" class="form-control" required>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label">Nội dung</label>
                                                    <textarea name="content" class="form-control" rows="6"
                                                        required></textarea>
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label">Link ảnh</label>
                                                    <input type="text" name="image" class="form-control"
                                                        placeholder="https://...">
                                                </div>

                                                <div class="mb-3">
                                                    <label class="form-label">Mã sản phẩm</label>
                                                    <input type="number" name="productId" class="form-control">
                                                </div>

                                            </div>

                                            <div class="modal-footer">
                                                <button type="submit" class="btn btn-success">
                                                    💾 Lưu
                                                </button>
                                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                                    Hủy
                                                </button>
                                            </div>

                                        </form>

                                    </div>
                                </div>
                            </div>
                            <c:if test="${param.msg == 'added'}">
                                <div id="alertMsg" class="alert alert-success">
                                    ✔️ Thêm bài viết thành công
                                </div>
                            </c:if>

                            <c:if test="${param.msg == 'add_failed'}">
                                <div id="alertMsg" class="alert alert-danger">
                                    ❌ Thêm bài viết thất bại
                                </div>
                            </c:if>




                            <!-- Danh sách blog -->
                            <div id="dsblog" class="users-table mt-4">
                                <section>
                                    <table id="tableBlog"
                                        class="table table-striped table-bordered align-middle text-center">
                                        <thead class="table-dark">
                                            <tr>
                                                <th>ID</th>
                                                <th style="width: 200px;">Tiêu đề</th>
                                                <th>Nội dung</th>
                                                <th>Ảnh</th>
                                                <th>Ngày tạo</th>
                                                <th>Mã sản phẩm</th>
                                                <th>Xem chi tiết</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="p" items="${posts}">
                                                <tr>
                                                    <td>${p.id}</td>
                                                    <td class="text-start">${p.title}</td>
                                                    <td class="text-start">
                                                        <c:set var="words" value="${fn:split(p.content, ' ')}" />
                                                        <c:choose>
                                                            <c:when test="${fn:length(words) > 8}">
                                                                <c:forEach var="w" items="${words}" begin="0" end="7">
                                                                    ${w}
                                                                </c:forEach>...
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${p.content}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${not empty p.image}">
                                                                <img src="${p.image}" class="blog-thumb">
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Không có ảnh</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>


                                                    <td>
                                                        <fmt:formatDate value="${p.createdAt}" pattern="yyyy-MM-dd" />
                                                    </td>
                                                    <td>SP${p.productId}</td>
                                                    <td>
                                                        <button type="button" class="btn btn-warning btn-sm me-1"
                                                            data-id="${p.id}" data-title="${fn:escapeXml(p.title)}"
                                                            data-content="${fn:escapeXml(p.content)}"
                                                            data-image="${p.image}" data-product="${p.productId}"
                                                            onclick="openEditModal(this)">
                                                            <i class="bi bi-pencil"></i>
                                                        </button>

                                                        <form
                                                            action="${pageContext.request.contextPath}/admin/blog-manage"
                                                            method="post" style="display:inline;"
                                                            onsubmit="return confirm('Bạn có chắc muốn xóa bài viết này?');">

                                                            <input type="hidden" name="action" value="delete">
                                                            <input type="hidden" name="id" value="${p.id}">

                                                            <button type="submit" class="btn btn-danger btn-sm">
                                                                <i class="bi bi-trash"></i>
                                                            </button>
                                                        </form>

                                                        <button type="button" class="btn btn-info btn-sm"
                                                            data-id="${p.id}" data-title="${fn:escapeXml(p.title)}"
                                                            data-content="${fn:escapeXml(p.content)}"
                                                            data-image="${p.image}"
                                                            data-date="<fmt:formatDate value='${p.createdAt}' pattern='yyyy-MM-dd'/>"
                                                            data-product="${p.productId}" onclick="openViewModal(this)">
                                                            <i class="bi bi-eye"></i>
                                                        </button>

                                                    </td>

                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>

                                    <!-- Phân trang -->
                                    <div class="d-flex justify-content-end align-items-center mt-3">
                                        <button id="prevPage" class="btn btn-outline-primary btn-sm">Trước</button>
                                        <span id="pageInfo" class="mx-2">1 / 1</span>
                                        <button id="nextPage" class="btn btn-outline-primary btn-sm">Sau</button>
                                    </div>
                                </section>

                                <!-- Chi tiết bài viết -->
                                <section>
                                    <div id="blog-detail" style="display: none;">
                                        <button class="btn btn-secondary mb-3" onclick="showList()">⬅ Quay lại</button>
                                        <table class="table table-bordered">
                                            <tr>
                                                <td>ID bài viết</td>
                                                <td id="post-id"></td>
                                            </tr>
                                            <tr>
                                                <td>Tiêu đề</td>
                                                <td id="post-title"></td>
                                            </tr>
                                            <tr>
                                                <td>Nội dung</td>
                                                <td id="post-content"></td>
                                            </tr>
                                            <tr>
                                                <td>Ảnh</td>
                                                <td><img id="post-image" width="250"></td>
                                            </tr>
                                            <tr>
                                                <td>Ngày tạo</td>
                                                <td id="post-date"></td>
                                            </tr>
                                            <tr>
                                                <td>Mã sản phẩm</td>
                                                <td id="post-product"></td>
                                            </tr>
                                        </table>
                                    </div>
                                </section>

                                <div class="modal fade" id="editBlogModal" tabindex="-1">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">

                                            <form action="${pageContext.request.contextPath}/admin/blog-manage"
                                                method="post">

                                                <div class="modal-header">
                                                    <h5 class="modal-title">✏️ Sửa bài viết</h5>
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"></button>
                                                </div>

                                                <div class="modal-body">

                                                    <input type="hidden" name="action" value="edit">
                                                    <input type="hidden" name="id" id="edit-id">

                                                    <div class="mb-3">
                                                        <label class="form-label">Tiêu đề</label>
                                                        <input type="text" name="title" id="edit-title"
                                                            class="form-control" required>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label">Nội dung</label>
                                                        <textarea name="content" id="edit-content" class="form-control"
                                                            rows="6" required></textarea>
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label">Ảnh</label>
                                                        <input type="text" name="image" id="edit-image"
                                                            class="form-control">
                                                    </div>

                                                    <div class="mb-3">
                                                        <label class="form-label">Mã sản phẩm</label>
                                                        <input type="number" name="productId" id="edit-product"
                                                            class="form-control">
                                                    </div>

                                                </div>

                                                <div class="modal-footer">
                                                    <button type="submit" class="btn btn-success">💾 Lưu</button>
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">Hủy</button>
                                                </div>

                                            </form>

                                        </div>
                                    </div>
                                </div>

                                <div class="modal fade" id="viewBlogModal" tabindex="-1">
                                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                        <div class="modal-content">

                                            <div class="modal-header">
                                                <h5 class="modal-title">👁 Chi tiết bài viết</h5>
                                                <button type="button" class="btn-close"
                                                    data-bs-dismiss="modal"></button>
                                            </div>

                                            <div class="modal-body">

                                                <table class="table table-bordered">
                                                    <tr>
                                                        <th style="width: 150px;">ID</th>
                                                        <td id="view-id"></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Tiêu đề</th>
                                                        <td id="view-title"></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Nội dung</th>
                                                        <td id="view-content" style="white-space: pre-wrap;"></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Ảnh</th>
                                                        <td>
                                                            <img id="view-image"
                                                                style="max-width: 100%; border-radius: 6px;">
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <th>Ngày tạo</th>
                                                        <td id="view-date"></td>
                                                    </tr>
                                                    <tr>
                                                        <th>Mã sản phẩm</th>
                                                        <td id="view-product"></td>
                                                    </tr>
                                                </table>

                                            </div>

                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary"
                                                    data-bs-dismiss="modal">Đóng</button>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                            </div>
                        </main>
                    </div>
                </body>
                <script>
                    const baseUrl = "${pageContext.request.contextPath}";
                    let blogTable;

                    $(document).ready(function () {
                        // Khởi tạo DataTable
                        blogTable = $('#tableBlog').DataTable({
                            pageLength: 5,
                            columnDefs: [{ targets: [2, 3, 6], orderable: false }],
                            language: { zeroRecords: "Không tìm thấy dữ liệu" }
                        });

                        // Tìm kiếm
                        $('#search').on('keyup', function () {
                            blogTable.search(this.value).draw();
                        });

                        // Pagination custom
                        $('#prevPage').click(() => { blogTable.page('previous').draw('page'); updatePageInfo(); });
                        $('#nextPage').click(() => { blogTable.page('next').draw('page'); updatePageInfo(); });
                        blogTable.on('draw', updatePageInfo);
                        updatePageInfo();

                        // Preview ảnh (chỉ hiển thị)
                        $('#blogImage').change(function () {
                            const file = this.files[0];
                            if (file) {
                                const reader = new FileReader();
                                reader.onload = e => $('#previewImage').attr('src', e.target.result).removeClass('d-none');
                                reader.readAsDataURL(file);
                            }
                        });

                    });

                    // Cập nhật số trang
                    function updatePageInfo() {
                        const info = blogTable.page.info();
                        $('#pageInfo').text((info.page + 1) + ' / ' + info.pages);
                    }



                    function showList() {
                        $('#blog-detail').hide();
                        $('.users-table').show();
                    }

                    // Logout popup (giữ nguyên)
                    document.addEventListener("DOMContentLoaded", () => {
                        const logoutBtn = document.getElementById("logoutBtn");
                        const logoutModal = document.getElementById("logoutModal");
                        const cancelLogout = document.getElementById("cancelLogout");

                        if (logoutBtn && logoutModal && cancelLogout) {
                            logoutBtn.addEventListener("click", () => logoutModal.style.display = "flex");
                            cancelLogout.addEventListener("click", () => logoutModal.style.display = "none");
                        }
                    });
                </script>
                <script>
                    function openEditModal(btn) {

                        document.getElementById("edit-id").value = btn.dataset.id;
                        document.getElementById("edit-title").value = btn.dataset.title;
                        document.getElementById("edit-content").value = btn.dataset.content;
                        document.getElementById("edit-image").value = btn.dataset.image;
                        document.getElementById("edit-product").value = btn.dataset.product;

                        let modal = new bootstrap.Modal(
                            document.getElementById("editBlogModal")
                        );
                        modal.show();
                    }

                    function openViewModal(btn) {
                        console.log("VIEW", btn.dataset); // debug

                        document.getElementById("view-id").innerText = btn.dataset.id;
                        document.getElementById("view-title").innerText = btn.dataset.title;
                        document.getElementById("view-content").innerText = btn.dataset.content;
                        document.getElementById("view-date").innerText = btn.dataset.date;
                        document.getElementById("view-product").innerText = "SP" + btn.dataset.product;

                        const img = document.getElementById("view-image");
                        img.src = "${pageContext.request.contextPath}/image/blog/" + btn.dataset.image;

                        let modal = new bootstrap.Modal(
                            document.getElementById("viewBlogModal")
                        );
                        modal.show();
                    }

                </script>
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const menuItems = document.querySelectorAll(".has-submenu .menu-item");

                        menuItems.forEach(item => {
                            item.addEventListener("click", function () {
                                const parent = this.parentElement;
                                parent.classList.toggle("open");
                            });
                        });
                    });
                    setTimeout(() => {
                        const alert = document.getElementById("alertMsg");
                        if (alert) {
                            alert.classList.add("fade");
                            alert.style.opacity = "0";
                            setTimeout(() => alert.remove(), 500);
                        }
                    }, 3000); // 3 giây
                </script>


                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

                </html>