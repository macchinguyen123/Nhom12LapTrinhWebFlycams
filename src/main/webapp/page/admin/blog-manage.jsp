<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Lý Blog</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="../../stylesheets/admin/blog-manage.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <script src="https://cdn.datatables.net/1.13.6/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.6/js/dataTables.bootstrap5.min.js"></script>

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
                <li class="active"><i class="bi bi-journal-text"></i> Quản Lý Blog</li>
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
            <!-- Nút mở modal -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="text-primary fw-bold"><i class="bi bi-journal-text"></i> Quản Lý Blog</h4>
                <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#modalBlog">
                    <i class="bi bi-plus-circle"></i> Thêm Bài Viết
                </button>
            </div>

            <!-- Ô tìm kiếm -->
            <div class="input-group custom-search shadow-sm mb-3">
                <span class="input-group-text"><i class="bi bi-search"></i></span>
                <input id="search" type="search" class="form-control" placeholder="Tìm kiếm bài viết...">
            </div>

            <!-- Modal -->
            <div class="modal fade" id="modalBlog" tabindex="-1">
                <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                    <div class="modal-content">
                        <div class="modal-header bg-primary text-white">
                            <h5 class="modal-title">
                                <i class="bi bi-pencil-square"></i> Thêm Bài Viết Mới
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <form id="formBlog" class="row g-3" enctype="multipart/form-data">
                                <div class="col-md-6">
                                    <label class="form-label">Tiêu đề</label>
                                    <input type="text" class="form-control" id="blogTitle" placeholder="Nhập tiêu đề..."
                                           required>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label">Mã sản phẩm</label>
                                    <input type="text" class="form-control" id="blogProduct" placeholder="VD: SP001"
                                           required>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Nội dung</label>
                                    <textarea class="form-control" id="blogContent" rows="3"
                                              placeholder="Nhập nội dung bài viết..." required></textarea>
                                </div>
                                <div class="col-12">
                                    <label class="form-label">Ảnh minh họa</label>
                                    <input type="file" class="form-control" id="blogImage" accept="image/*">
                                    <div class="mt-2 text-center">
                                        <img id="previewImage" src="" alt="" class="img-thumbnail d-none">
                                    </div>
                                </div>
                            </form>
                        </div>

                        <div class="modal-footer">
                            <button class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button class="btn btn-primary" onclick="saveBlog()">Lưu Thay Đổi</button>
                        </div>
                    </div>
                </div>
            </div>


        </div>

        <div id="dsblog" class="users-table mt-4">



            <section>
                <table id="tableBlog" class="table table-striped table-bordered">
                    <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Tiêu đề</th>
                        <th>Nội dung</th>
                        <th>Ảnh</th>
                        <th>Ngày tạo</th>
                        <th>Mã sản phẩm</th>
                        <th>Hành động</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>B001</td>
                        <td>Trải nghiệm cùng SkyMini</td>
                        <td>Chia sẻ hành trình bay cùng drone mini...</td>
                        <td><img src="${pageContext.request.contextPath}/image/blog/hinhAnhBaiViet2.png" width="80" height="80" alt="Hình bài viết"></td>
                        <td>2025-11-10</td>
                        <td>SP001</td>
                        <td>
                            <button class="btn btn-warning btn-sm" onclick="formBlogPost('B001')"><i class="bi bi-pencil"></i></button>
                            <button class="btn btn-danger btn-sm delete-btn"><i class="bi bi-trash"></i></button>
                            <button class="btn btn-info btn-sm" onclick="showPostDetail('B001')"><i class="bi bi-eye"></i></button>
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

        <!-- CHI TIẾT BÀI VIẾT -->
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
    </main>
</div>


<script>
    $(document).ready(function() {
        // Khởi tạo DataTable
        blogTable = $('#tableBlog').DataTable({
            pageLength: 5,
            columnDefs: [
                { targets: [2,3,6], orderable: false }
            ],  "language": {
                "zeroRecords": "Không tìm thấy dữ liệu"
            }
        });



        // Tìm kiếm
        $('#search').on('keyup', function() {
            blogTable.search(this.value).draw();
        });


        // Pagination custom
        $('#prevPage').click(()=>{ blogTable.page('previous').draw('page'); updatePageInfo(); });
        $('#nextPage').click(()=>{ blogTable.page('next').draw('page'); updatePageInfo(); });
        blogTable.on('draw', updatePageInfo);
        updatePageInfo();




        // Preview ảnh
        $('#blogImage').change(function(){
            let file = this.files[0];
            if(file){
                let reader = new FileReader();
                reader.onload = function(e){
                    $('#previewImage').attr('src', e.target.result).removeClass('d-none');
                }
                reader.readAsDataURL(file);
            }
        });

        // xử lý nút xóa (đã include SweetAlert2)
        $(document).on('click', '.delete-btn', function (e) {
            e.preventDefault();
            const $btn = $(this);
            const rowNode = $btn.closest("tr");

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
                    // xóa từ DataTable
                    blogTable.row(rowNode).remove().draw(false);
                    updatePageInfo();

                    Swal.fire({
                        title: "Đã xóa!",
                        text: "Bài viết đã được xóa.",
                        icon: "success",
                        confirmButtonColor: "#0d6efd"
                    });
                }
            });
        });


        $('#tableBlog tbody').on('click', '.btn-warning', function() {
            let row = $(this).closest('tr');
            let data = blogTable.row(row).data();
            $('#editId').val(data[0]);
            $('#blogTitle').val(data[1]);
            $('#blogContent').val(data[2]);
            $('#blogProduct').val(data[5]);
            $('#previewImage').attr('src', $(data[3]).find('img').attr('src')).removeClass('d-none');
            $('#modalBlog .modal-title').html('<i class="bi bi-pencil-square"></i> Chỉnh sửa bài viết');
            new bootstrap.Modal(document.getElementById('modalBlog')).show();
        });

        $('#tableBlog tbody').on('click', '.btn-info', function() {
            let row = $(this).closest('tr');
            let data = blogTable.row(row).data();
            $('#post-id').text(data[0]);
            $('#post-title').text(data[1]);
            $('#post-content').text(data[2]);
            $('#post-image').attr('src', $(data[3]).find('img').attr('src'));
            $('#post-date').text(data[4]);
            $('#post-product').text(data[5]);
            $('#blog-detail').show();
            $('.users-table').hide();
        });



        $('#saveBlog').click(function(){
            let id = $('#editId').val();
            let title = $('#blogTitle').val();
            let content = $('#blogContent').val();
            let product = $('#blogProduct').val();
            let imgSrc = $('#previewImage').attr('src') || '';

            let imgHtml = `<img src="${imgSrc}" width="80" height="80">`;

            if(id){ // chỉnh sửa
                blogTable.rows().every(function(){
                    if(this.data()[0]===id){
                        this.data([id, title, content, imgHtml, this.data()[4], product]);
                    }
                });
            }else{ // thêm mới
                let newId = 'B' + Math.floor(Math.random()*900+100);
                let date = new Date().toISOString().slice(0,10);
                blogTable.row.add([newId, title, content, imgHtml, date, product]);
            }
            blogTable.draw(false);
            resetForm();
            bootstrap.Modal.getInstance(document.getElementById('modalBlog')).hide();
            updatePageInfo();
        });


    });



    // Reset form
    function resetForm(){
        $('#formBlog')[0].reset();
        $('#editId').val('');
        $('#previewImage').addClass('d-none').attr('src','');
        $('#modalBlog .modal-title').html('<i class="bi bi-plus-circle"></i> Thêm bài viết');
    }

    // Cập nhật số trang
    function updatePageInfo(){
        let info = blogTable.page.info();
        $('#pageInfo').text((info.page+1)+' / '+info.pages);
    }

    function showList() {
        $('#blog-detail').hide();
        $('.users-table').show();
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
</script>




</body>
</html>
