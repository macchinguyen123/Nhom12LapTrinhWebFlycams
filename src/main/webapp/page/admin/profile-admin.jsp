<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/stylesheets/admin/profile-admin.css">
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
</head>

<body>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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

<!-- Notification banner for avatar processing -->
<div id="avatar-processing-notification" class="alert alert-info"
     style="display: none; position: fixed; top: 80px; left: 50%; transform: translateX(-50%); z-index: 9998; min-width: 450px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);">
    <div class="d-flex align-items-center">
        <div class="spinner-border spinner-border-sm me-3" role="status">
            <span class="visually-hidden">Loading...</span>
        </div>
        <span><strong>Đang xử lý và lưu ảnh đại diện...</strong> Vui lòng chờ trong giây lát.</span>
    </div>
</div>

<!-- ===== LAYOUT ===== -->
<div class="layout">
    <!-- === SIDEBAR === -->
    <aside class="sidebar">
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty sessionScope.user.avatar}">
                    <img src="${pageContext.request.contextPath}/uploads/avatar/${sessionScope.user.avatar}?v=${sessionScope.user.updatedAt != null ? sessionScope.user.updatedAt.time : ''}"
                         alt="Avatar" id="sidebarAvatar"
                         style="width: 80px; height: 80px; border-radius: 50%; object-fit: cover;">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar"
                         id="sidebarAvatar">
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
            <a href="${pageContext.request.contextPath}/admin/banner-manage">
                <li><i class="bi bi-images"></i> Quản Lý Banner</li>
            </a>
        </ul>
    </aside>

    <!-- === MAIN CONTENT === -->
    <div class="profile-page">
        <!-- LEFT SIDE -->
        <div class="profile-left">
            <div class="avatar-box">
                <div class="avatar-wrapper">
                    <c:choose>
                        <c:when test="${not empty admin.avatar}">
                            <img src="${pageContext.request.contextPath}/uploads/avatar/${admin.avatar}"
                                 alt="Avatar" class="avatar-img" id="avatarPreview">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/image/logoTCN.png"
                                 alt="Avatar" class="avatar-img" id="avatarPreview">
                        </c:otherwise>
                    </c:choose>
                    <span class="avatar-camera">
                                            <i class="bi bi-camera-fill"></i>
                                        </span>
                </div>
            </div>
            <h3>${admin.fullName}</h3>
            <p class="text-muted small">${admin.email}</p>
        </div>

        <!-- RIGHT SIDE -->
        <div class="profile-right">

            <!-- ========== THÔNG TIN CƠ BẢN ========== -->
            <h4><i class="bi bi-person-badge me-2"></i>Thông tin cơ bản</h4>

            <!-- Hiển thị thông báo -->
            <c:if test="${not empty sessionScope.infoMsg}">
                <div class="alert alert-dismissible fade show ${fn:contains(sessionScope.infoMsg, 'thành công') ? 'alert-success' : 'alert-danger'}"
                     role="alert">
                    <i
                            class="bi ${fn:contains(sessionScope.infoMsg, 'thành công') ? 'bi-check-circle' : 'bi-exclamation-circle'} me-2"></i>
                        ${sessionScope.infoMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="infoMsg" scope="session"/>
            </c:if>

            <form id="profileForm"
                  action="${pageContext.request.contextPath}/admin/profile?action=update-info"
                  method="post" enctype="multipart/form-data">

                <!-- Hidden file input for avatar -->
                <input type="file" name="avatar" id="avatarInput" accept="image/*" hidden>

                <label>
                    <i class="bi bi-person me-1"> Họ tên</i>
                    <input name="fullName" value="${admin.fullName}" required
                           placeholder="Nhập họ tên đầy đủ">
                </label>

                <label>
                    <i class="bi bi-envelope me-1"> Email</i>
                    <input type="email" name="email" value="${admin.email}" required
                           placeholder="example@email.com">
                </label>

                <label>
                    <i class="bi bi-telephone me-1"> Số điện thoại</i>
                    <input name="phone" value="${admin.phoneNumber}" pattern="^0\d{9}$"
                           title="Số điện thoại phải là 10 số, bắt đầu bằng 0" required
                           placeholder="0123456789">
                </label>

                <div class="actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i> Lưu thay đổi
                    </button>
                </div>
            </form>

            <hr>


            <!-- ========== ĐỔI MẬT KHẨU ========== -->
            <h4><i class="bi bi-shield-lock me-2"></i>Đổi mật khẩu</h4>

            <!-- Hiển thị thông báo -->
            <c:if test="${not empty sessionScope.passMsg}">
                <div class="alert alert-dismissible fade show ${fn:contains(sessionScope.passMsg, 'thành công') ? 'alert-success' : 'alert-danger'}"
                     role="alert">
                    <i
                            class="bi ${fn:contains(sessionScope.passMsg, 'thành công') ? 'bi-check-circle' : 'bi-exclamation-circle'} me-2"></i>
                        ${sessionScope.passMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="passMsg" scope="session"/>
            </c:if>

            <form id="changePassForm"
                  action="${pageContext.request.contextPath}/admin/profile?action=change-password"
                  method="post">

                <small class="password-hint">
                    <i class="bi bi-info-circle me-1"></i>
                    Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc
                    biệt (@$!%*?&).
                </small>

                <label>
                    <i class="bi bi-key me-1"></i> Mật khẩu cũ
                    <div class="input-group">
                        <input type="password" name="oldPassword" id="oldPassword" required
                               placeholder="Nhập mật khẩu cũ">
                        <span class="input-group-text toggle-password" data-target="oldPassword"
                              style="cursor:pointer">
                                                <i class="bi bi-eye"></i>
                                            </span>
                    </div>
                </label>

                <label>
                    <i class="bi bi-key-fill me-1"></i> Mật khẩu mới
                    <div class="input-group">
                        <input type="password" name="newPassword" id="newPassword" required
                               minlength="8"
                               pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$"
                               title="Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt"
                               placeholder="Nhập mật khẩu mới">
                        <span class="input-group-text toggle-password" data-target="newPassword"
                              style="cursor:pointer">
                                                <i class="bi bi-eye"></i>
                                            </span>
                    </div>
                </label>

                <label>
                    <i class="bi bi-shield-check me-1"></i> Xác nhận mật khẩu
                    <div class="input-group">
                        <input type="password" name="confirmPassword" id="confirmPassword" required
                               placeholder="Nhập lại mật khẩu mới">
                        <span class="input-group-text toggle-password" data-target="confirmPassword"
                              style="cursor:pointer">
                                                <i class="bi bi-eye"></i>
                                            </span>
                    </div>
                </label>

                <div class="actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-shield-lock me-1"></i> Đổi mật khẩu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function () {

        /* ===== SIDEBAR SUBMENU ===== */
        document.querySelectorAll('.has-submenu .menu-item').forEach(item => {
            item.addEventListener('click', () => {
                const parent = item.parentElement;
                const arrow = item.querySelector('.arrow');
                const submenu = parent.querySelector('.submenu');

                parent.classList.toggle('open');
                parent.classList.toggle('active');

                if (parent.classList.contains('open')) {
                    if (arrow) {
                        arrow.classList.remove('bi-chevron-right');
                        arrow.classList.add('bi-chevron-down');
                    }
                    if (submenu) submenu.style.display = 'block';
                } else {
                    if (arrow) {
                        arrow.classList.remove('bi-chevron-down');
                        arrow.classList.add('bi-chevron-right');
                    }
                    if (submenu) submenu.style.display = 'none';
                }
            });
        });

        /* ===== AVATAR UPLOAD & PREVIEW ===== */
        const avatarWrapper = document.querySelector(".avatar-wrapper");
        const avatarInput = document.getElementById("avatarInput");
        const avatarPreview = document.getElementById("avatarPreview");
        const processingNotification = document.getElementById("avatar-processing-notification");

        if (avatarWrapper && avatarInput) {
            avatarWrapper.addEventListener("click", () => avatarInput.click());

            avatarInput.addEventListener("change", function () {
                const file = this.files[0];
                if (!file) return;

                if (!file.type.startsWith('image/')) {
                    Swal.fire({icon: 'error', title: 'Lỗi', text: '⚠️ Vui lòng chọn file hình ảnh!'});
                    this.value = '';
                    return;
                }

                if (file.size > 5 * 1024 * 1024) {
                    Swal.fire({icon: 'error', title: 'Lỗi', text: '⚠️ File không được vượt quá 5MB!'});
                    this.value = '';
                    return;
                }

                // Hiển thị preview
                const reader = new FileReader();
                reader.onload = e => {
                    avatarPreview.src = e.target.result;
                    const sidebarAvatar = document.getElementById("sidebarAvatar");
                    if (sidebarAvatar) sidebarAvatar.src = e.target.result;

                    // HIỂN THỊ THÔNG BÁO ĐANG XỬ LÝ VÀ UPLOAD NGAY
                    if (processingNotification) {
                        processingNotification.style.display = "block";
                        uploadAvatar(file);
                    }
                };
                reader.readAsDataURL(file);
            });
        }

        // Hàm upload avatar
        function uploadAvatar(file) {
            const formData = new FormData();
            formData.append("avatar", file);
            formData.append("fullName", document.querySelector('input[name="fullName"]').value);
            formData.append("email", document.querySelector('input[name="email"]').value);
            formData.append("phone", document.querySelector('input[name="phone"]').value);

            fetch('${pageContext.request.contextPath}/admin/profile?action=update-info', {
                method: 'POST',
                body: formData
            }).then(response => {
                if (response.ok) {
                    // Ẩn thông báo
                    if (processingNotification) processingNotification.style.display = "none";

                    // Hiển thị SweetAlert thành công
                    Swal.fire({
                        icon: 'success',
                        title: 'Thành công',
                        text: 'Đã cập nhật ảnh đại diện!',
                        timer: 2000,
                        showConfirmButton: false
                    }).then(() => {
                        location.reload();
                    });
                } else {
                    throw new Error('Lỗi khi lưu ảnh');
                }
            }).catch(error => {
                console.error('Error:', error);
                if (processingNotification) processingNotification.style.display = "none";
                Swal.fire({
                    icon: 'error',
                    title: 'Thất bại!',
                    text: '❌ Có lỗi xảy ra khi lưu ảnh!',
                    confirmButtonText: 'Thử lại'
                });
            });
        }

        /* ===== BANK EDIT / ADD / CANCEL ===== */
        const bankView = document.getElementById("bankView");
        const bankEdit = document.getElementById("bankEdit");
        const btnEdit = document.getElementById("btn-edit-bank");
        const btnAdd = document.getElementById("btn-add-bank");
        const btnCancel = document.getElementById("btnCancelBank");
        const bankForm = document.getElementById("bankForm");
        const qrUpload = document.getElementById("qrUpload");
        const qrPreviewImg = document.getElementById("qrPreviewImg");
        const currentQR = document.getElementById("currentQR");
        const khungThemQR = document.getElementById("khungThemQR");

        if (btnEdit) {
            btnEdit.addEventListener("click", () => {
                bankView.classList.add("d-none");
                bankEdit.classList.remove("d-none");
                if (qrUpload) qrUpload.required = false;
            });
        }

        if (btnAdd) {
            btnAdd.addEventListener("click", () => {
                bankView.classList.add("d-none");
                bankEdit.classList.remove("d-none");
                if (qrUpload) qrUpload.required = true;
            });
        }

        if (btnCancel) {
            btnCancel.addEventListener("click", () => {
                bankEdit.classList.add("d-none");
                bankView.classList.remove("d-none");
                if (bankForm) bankForm.reset();
                if (qrPreviewImg) {
                    qrPreviewImg.classList.add("d-none");
                    qrPreviewImg.src = "";
                }
                if (currentQR) currentQR.classList.remove("d-none");
            });
        }

        /* ===== QR UPLOAD & PREVIEW ===== */
        if (khungThemQR && qrUpload && qrPreviewImg) {
            khungThemQR.addEventListener("click", () => qrUpload.click());

            qrUpload.addEventListener("change", () => {
                const file = qrUpload.files[0];
                if (!file) return;

                if (!file.type.startsWith('image/')) {
                    alert('⚠️ Vui lòng chọn file hình ảnh!');
                    qrUpload.value = '';
                    return;
                }

                if (file.size > 5 * 1024 * 1024) {
                    alert('⚠️ File không được vượt quá 5MB!');
                    qrUpload.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = e => {
                    qrPreviewImg.src = e.target.result;
                    qrPreviewImg.classList.remove("d-none");
                    if (currentQR) currentQR.classList.add("d-none");
                };
                reader.readAsDataURL(file);
            });
        }

        /* ===== TOGGLE ACCOUNT NUMBER VISIBILITY ===== */
        const toggleEye = document.getElementById("toggleEye");
        const accountNumber = document.getElementById("accountNumber");
        const eyeIcon = document.getElementById("eyeIcon");

        if (toggleEye && accountNumber) {
            toggleEye.addEventListener("click", () => {
                if (accountNumber.type === "password") {
                    accountNumber.type = "text";
                    eyeIcon.classList.replace("bi-eye", "bi-eye-slash");
                } else {
                    accountNumber.type = "password";
                    eyeIcon.classList.replace("bi-eye-slash", "bi-eye");
                }
            });
        }

        /* ===== TOGGLE PASSWORD VISIBILITY ===== */
        document.querySelectorAll('.toggle-password').forEach(toggle => {
            toggle.addEventListener('click', function () {
                const targetId = this.getAttribute('data-target');
                const input = document.getElementById(targetId);
                const icon = this.querySelector('i');

                if (input.type === 'password') {
                    input.type = 'text';
                    icon.classList.replace('bi-eye', 'bi-eye-slash');
                } else {
                    input.type = 'password';
                    icon.classList.replace('bi-eye-slash', 'bi-eye');
                }
            });
        });

        /* ===== PASSWORD VALIDATION ===== */
        const changePassForm = document.getElementById("changePassForm");
        if (changePassForm) {
            changePassForm.addEventListener("submit", function (e) {
                const newPassword = document.getElementById("newPassword").value;
                const confirmPassword = document.getElementById("confirmPassword").value;

                if (newPassword !== confirmPassword) {
                    e.preventDefault();
                    alert("❌ Mật khẩu xác nhận không khớp!");
                    return false;
                }

                const strongPasswordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$/;
                if (!strongPasswordRegex.test(newPassword)) {
                    e.preventDefault();
                    alert("❌ Mật khẩu chưa đủ mạnh!\n\n✅ Phải có ít nhất 8 ký tự\n✅ Bao gồm chữ hoa (A-Z)\n✅ Bao gồm chữ thường (a-z)\n✅ Bao gồm số (0-9)\n✅ Bao gồm ký tự đặc biệt (@$!%*?&)");
                    return false;
                }
            });
        }

        /* ===== LOGOUT MODAL ===== */
        if (window.$) {
            $("#logoutBtn").on("click", () => $("#logoutModal").css("display", "flex"));
            $("#cancelLogout").on("click", () => $("#logoutModal").hide());
        }

        /* ===== AUTO HIDE ALERTS AFTER 5 SECONDS ===== */
        setTimeout(() => {
            document.querySelectorAll('.alert').forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);

    });
</script>

</body>

</html>