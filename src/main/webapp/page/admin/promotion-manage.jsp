<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <jsp:useBean id="now" class="java.util.Date" />


            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Trang Quản Lý Khuyến Mãi - SkyDrone</title>
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                    rel="stylesheet">
                <!-- Bootstrap Bundle (gồm cả Popper) -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
                <link rel="stylesheet" href="../../stylesheets/admin/promotion-manage.css">
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">


                <script src="https://code.jquery.com/jquery-3.7.0.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
                <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/promotion-manage.css">

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
                                <a href="${pageContext.request.contextPath}/Logout">
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
                                <li class="active"><i class="bi bi-megaphone"></i> Quản Lý Khuyến Mãi</li>
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/statistics">
                                <li><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
                            </a>
                        </ul>
                    </aside>


                    <!-- === NỘI DUNG CHÍNH === -->
                    <main class="main-content container-fluid p-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h4 class="text-primary fw-bold"><i class="bi bi-tags"></i> Quản Lý Khuyến Mãi</h4>
                            <!-- THANH TÌM KIẾM -->
                        </div>
                        <div class="toolbar-blog mb-3">

                            <!-- BÊN TRÁI: TÌM KIẾM -->
                            <form class="search-box" role="search">
                                <div class="input-group">
                                    <span class="input-group-text bg-primary text-white">
                                        <i class="bi bi-search"></i>
                                    </span>
                                    <input id="searchBlogInput" type="search" class="form-control"
                                        placeholder="Tìm kiếm bài viết...">
                                </div>
                            </form>

                            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalAddPromotion">
                                <i class="bi bi-plus-lg"></i> Thêm Khuyến Mãi
                            </button>


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
                                <c:forEach var="p" items="${promotions}">
                                    <tr>
                                        <td>${p.id}</td>

                                        <td>${p.name}</td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${p.discountType eq '%'}">
                                                    ${p.discountValue}%
                                                </c:when>

                                                <c:when test="${p.discountType eq 'fixed'}">
                                                    <fmt:formatNumber value="${p.discountValue}" type="number" /> đ
                                                </c:when>

                                                <c:otherwise>
                                                    Không xác định
                                                </c:otherwise>
                                            </c:choose>
                                        </td>



                                        <td>
                                            <fmt:formatDate value="${p.startDate}" pattern="yyyy-MM-dd" />
                                            -
                                            <fmt:formatDate value="${p.endDate}" pattern="yyyy-MM-dd" />
                                        </td>

                                        <td>
                                            ${scopeMap[p.id]}
                                        </td>

                                        <td>
                                            <button class="btn btn-warning btn-sm btn-edit" data-id="${p.id}"
                                                data-name="<c:out value='${p.name}'/>"
                                                data-discount="${p.discountValue}" data-type="${p.discountType}"
                                                data-start="<fmt:formatDate value='${p.startDate}' pattern='yyyy-MM-dd'/>"
                                                data-end="<fmt:formatDate value='${p.endDate}' pattern='yyyy-MM-dd'/>"
                                                data-scope="${scopeMap[p.id]}">
                                                <i class="bi bi-pencil"></i>
                                            </button>

                                            <form action="${pageContext.request.contextPath}/admin/promotion-manage"
                                                method="post" style="display:inline"
                                                onsubmit="return confirm('Bạn chắc chắn muốn xóa khuyến mãi này?');">

                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="${p.id}">

                                                <button class="btn btn-danger btn-sm">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </form>

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

                <div class="modal fade" id="modalAddPromotion" tabindex="-1">
                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                        <div class="modal-content">

                            <form action="${pageContext.request.contextPath}/admin/promotion-manage" method="post">

                                <div class="modal-header bg-primary text-white">
                                    <h5 class="modal-title">
                                        <i class="bi bi-plus-circle"></i> Thêm Khuyến Mãi
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>

                                <div class="modal-body row g-3">

                                    <input type="hidden" name="action" value="add">

                                    <div class="col-md-6">
                                        <label class="form-label">Tên chương trình</label>
                                        <input type="text" name="name" class="form-control" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Mức giảm</label>
                                        <input type="number" name="discountValue" class="form-control" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Loại giảm</label>
                                        <select name="discountType" class="form-select">
                                            <option value="%">%</option>
                                            <option value="fixed">VNĐ</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Áp dụng</label>
                                        <select name="scope" id="add-scope" class="form-select">
                                            <option value="ALL">Tất cả</option>
                                            <option value="PRODUCT">Sản phẩm</option>
                                            <option value="CATEGORY">Danh mục</option>
                                        </select>
                                    </div>

                                    <!-- Áp cho sản phẩm -->
                                    <div class="col-md-6 d-none" id="add-product-box">
                                        <label class="form-label">Mã sản phẩm</label>
                                        <input type="text" name="productIds" class="form-control"
                                               placeholder="VD: 1,2,3 hoặc SP001,SP002">
                                    </div>


                                    <!-- Áp cho danh mục -->
                                    <div class="col-md-6 d-none" id="add-category-box">
                                        <label class="form-label">Mã danh mục</label>
                                        <input type="text" name="categoryId" class="form-control"
                                               placeholder="VD: DM001">
                                    </div>


                                    <div class="col-md-6">
                                        <label class="form-label">Ngày bắt đầu</label>
                                        <input type="date" name="startDate" class="form-control" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Ngày kết thúc</label>
                                        <input type="date" name="endDate" class="form-control" required>
                                    </div>

                                </div>

                                <div class="modal-footer">
                                    <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button class="btn btn-primary">
                                        Lưu
                                    </button>
                                </div>

                            </form>

                        </div>
                    </div>
                </div>
                <div class="modal fade" id="modalEditPromotion" tabindex="-1">
                    <div class="modal-dialog modal-lg modal-dialog-scrollable">
                        <div class="modal-content">

                            <form action="${pageContext.request.contextPath}/admin/promotion-manage" method="post">

                                <input type="hidden" name="action" value="edit">
                                <input type="hidden" name="id" id="edit-id">

                                <div class="modal-header bg-warning">
                                    <h5 class="modal-title">
                                        <i class="bi bi-pencil"></i> Sửa Khuyến Mãi
                                    </h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                                </div>

                                <div class="modal-body row g-3">

                                    <div class="col-md-6">
                                        <label class="form-label">Tên chương trình</label>
                                        <input type="text" name="name" id="edit-name" class="form-control" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Mức giảm</label>
                                        <input type="number" name="discountValue" id="edit-discount"
                                            class="form-control" required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Loại giảm</label>
                                        <select name="discountType" id="edit-type" class="form-select">
                                            <option value="%">%</option>
                                            <option value="VND">VNĐ</option>
                                        </select>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Phạm vi áp dụng</label>
                                        <select name="scope" id="edit-scope" class="form-select">
                                            <option value="ALL">Tất cả</option>
                                            <option value="PRODUCT">Sản phẩm</option>
                                            <option value="CATEGORY">Danh mục</option>
                                        </select>
                                    </div>


                                    <div class="col-md-6 d-none" id="edit-product-box">
                                        <label class="form-label">Mã sản phẩm</label>
                                        <input type="text" name="productId" id="edit-product" class="form-control"
                                               placeholder="VD: 1,2,3">
                                    </div>

                                    <div class="col-md-6 d-none" id="edit-category-box">
                                        <label class="form-label">Mã danh mục</label>
                                        <input type="text" name="categoryId" id="edit-category" class="form-control">
                                    </div>


                                    <div class="col-md-6">
                                        <label class="form-label">Ngày bắt đầu</label>
                                        <input type="date" name="startDate" id="edit-start" class="form-control"
                                            required>
                                    </div>

                                    <div class="col-md-6">
                                        <label class="form-label">Ngày kết thúc</label>
                                        <input type="date" name="endDate" id="edit-end" class="form-control" required>
                                    </div>

                                </div>

                                <div class="modal-footer">
                                    <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                    <button class="btn btn-warning">Lưu thay đổi</button>
                                </div>

                            </form>

                        </div>
                    </div>
                </div>





                <script>
                    $(document).ready(function () {
                        $('#bangKhuyenMai').DataTable({
                            language: {
                                search: "Tìm kiếm:",
                                lengthMenu: "Hiển thị _MENU_ dòng",
                                info: "Trang _PAGE_ / _PAGES_",
                                paginate: {
                                    previous: "Trước",
                                    next: "Sau"
                                }
                            }
                        });
                    });
                </script>
                <script>
                    function toggleEditScope(scope) {
                        document.getElementById("edit-product-box").classList.add("d-none");
                        document.getElementById("edit-category-box").classList.add("d-none");

                        if (scope === "PRODUCT") {
                            document.getElementById("edit-product-box").classList.remove("d-none");
                        }

                        if (scope === "CATEGORY") {
                            document.getElementById("edit-category-box").classList.remove("d-none");
                        }
                    }

                    document.querySelectorAll('.btn-edit').forEach(btn => {
                        btn.addEventListener('click', () => {

                            document.getElementById('edit-id').value = btn.dataset.id;
                            document.getElementById('edit-name').value = btn.dataset.name;
                            document.getElementById('edit-discount').value = btn.dataset.discount;
                            document.getElementById('edit-type').value = btn.dataset.type;
                            document.getElementById('edit-start').value = btn.dataset.start;
                            document.getElementById('edit-end').value = btn.dataset.end;

                            let scope = "ALL";
                            const text = btn.dataset.scope.toLowerCase();
                            if (text.includes("sản phẩm")) scope = "PRODUCT";
                            if (text.includes("danh mục")) scope = "CATEGORY";

                            document.getElementById("edit-scope").value = scope;
                            toggleEditScope(scope);

                            new bootstrap.Modal(
                                document.getElementById('modalEditPromotion')
                            ).show();
                        });
                    });

                    document.getElementById("edit-scope").addEventListener("change", function () {
                        toggleEditScope(this.value);
                    });
                </script>

                <script>
                    document.getElementById("add-scope").addEventListener("change", function () {
                        const scope = this.value;

                        document.getElementById("add-product-box").classList.add("d-none");
                        document.getElementById("add-category-box").classList.add("d-none");

                        if (scope === "PRODUCT") {
                            document.getElementById("add-product-box").classList.remove("d-none");
                        }

                        if (scope === "CATEGORY") {
                            document.getElementById("add-category-box").classList.remove("d-none");
                        }
                    });
                </script>


            </body>

            </html>