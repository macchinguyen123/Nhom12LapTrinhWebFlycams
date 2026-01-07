<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị - SkyDrone</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.6/css/dataTables.bootstrap5.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/admin/profile-admin.css">
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
        <a href="${pageContext.request.contextPath}/admin/profile" class="text-decoration-none text-while">
            <div class="thong-tin-admin d-flex align-items-center gap-2">
                <i class="bi bi-person-circle fs-4"></i>
                <span class="fw-semibold">${admin.fullName}</span>
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

<!-- ===== LAYOUT ===== -->
<div class="layout">
    <!-- === SIDEBAR === -->
    <aside class="sidebar">
        <div class="user-info">
            <c:choose>
                <c:when test="${not empty admin.avatar}">
                    <img src="${pageContext.request.contextPath}/uploads/avatar/${admin.avatar}" alt="Avatar">
                </c:when>
                <c:otherwise>
                    <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar">
                </c:otherwise>
            </c:choose>

            <h3>${admin.fullName}</h3>
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
                <div class="alert alert-dismissible fade show ${fn:contains(sessionScope.infoMsg, 'thành công') ? 'alert-success' : 'alert-danger'}" role="alert">
                    <i class="bi ${fn:contains(sessionScope.infoMsg, 'thành công') ? 'bi-check-circle' : 'bi-exclamation-circle'} me-2"></i>
                        ${sessionScope.infoMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="infoMsg" scope="session"/>
            </c:if>

            <form id="profileForm" action="${pageContext.request.contextPath}/admin/profile?action=update-info"
                  method="post" enctype="multipart/form-data">

                <!-- Hidden file input for avatar -->
                <input type="file" name="avatar" id="avatarInput" accept="image/*" hidden>

                <label>
                    <i class="bi bi-person me-1"> Họ tên</i>
                    <input name="fullName" value="${admin.fullName}" required placeholder="Nhập họ tên đầy đủ">
                </label>

                <label>
                    <i class="bi bi-envelope me-1"> Email</i>
                    <input type="email" name="email" value="${admin.email}" required placeholder="example@email.com">
                </label>

                <label>
                    <i class="bi bi-telephone me-1"> Số điện thoại</i>
                    <input name="phone" value="${admin.phoneNumber}" pattern="^0\d{9}$"
                           title="Số điện thoại phải là 10 số, bắt đầu bằng 0" required placeholder="0123456789">
                </label>

                <div class="actions">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i> Lưu thay đổi
                    </button>
                </div>
            </form>

            <hr>

            <!-- ========== THÔNG TIN NGÂN HÀNG ========== -->
            <h4><i class="bi bi-bank me-2"></i>Thông tin ngân hàng</h4>

            <!-- Hiển thị thông báo -->
            <c:if test="${not empty sessionScope.bankMsg}">
                <div class="alert alert-dismissible fade show ${fn:contains(sessionScope.bankMsg, 'thành công') ? 'alert-success' : 'alert-danger'}" role="alert">
                    <i class="bi ${fn:contains(sessionScope.bankMsg, 'thành công') ? 'bi-check-circle' : 'bi-exclamation-circle'} me-2"></i>
                        ${sessionScope.bankMsg}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
                <c:remove var="bankMsg" scope="session"/>
            </c:if>

            <!-- Chế độ XEM -->
            <div class="bank-info" id="bankView">
                <c:choose>
                    <c:when test="${not empty bank}">
                        <div class="bank-details" style="flex: 1;">
                            <p>
                                <strong><i class="bi bi-bank2 me-2"></i>Ngân hàng:</strong>
                                <span id="bankNameText">${bank.bankName}</span>
                            </p>

                            <p>
                                <strong><i class="bi bi-credit-card me-2"></i>Số tài khoản:</strong>
                                <span id="acctMasked">
                        **** **** ${fn:substring(bank.accountNumber,
                                        fn:length(bank.accountNumber) - 4,
                                        fn:length(bank.accountNumber))}
                    </span>
                            </p>

                            <p>
                                <strong><i class="bi bi-person-circle me-2"></i>Chủ tài khoản:</strong>
                                <span id="acctNameText">${bank.accountName}</span>
                            </p>
                        </div>

                        <button id="btn-edit-bank" class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-pencil-square"></i>
                        </button>

                        <div class="bank-qr">
                            <p><strong><i class="bi bi-qr-code me-2"></i>Mã QR thanh toán</strong></p>
                            <c:choose>
                                <c:when test="${not empty bank.qrCodeImage}">
                                    <img src="${pageContext.request.contextPath}/uploads/qr/${bank.qrCodeImage}"
                                         alt="QR Code" onerror="this.src='${pageContext.request.contextPath}/image/qr/qr.png'">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/image/qr/qr.png" alt="QR Code">
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="alert alert-warning" style="width: 100%; margin: 0;">
                            <i class="bi bi-info-circle me-2"></i>
                            Chưa có thông tin ngân hàng.
                            <button id="btn-add-bank" class="btn btn-sm btn-primary ms-2">
                                <i class="bi bi-plus-lg"></i> Thêm ngay
                            </button>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Chế độ CHỈNH SỬA/THÊM MỚI -->
            <div class="bank-info-edit p-3 border rounded mb-3 d-none" id="bankEdit">
                <form id="bankForm" action="${pageContext.request.contextPath}/admin/profile?action=update-bank"
                      method="post" enctype="multipart/form-data">

                    <label>
                        <i class="bi bi-bank2 me-1"></i> Ngân hàng <span class="text-danger">*</span>
                        <select name="bankName" class="form-select" required>
                            <option value="">-- Chọn ngân hàng --</option>
                            <option value="Momo" ${bank.bankName == 'Momo' ? 'selected' : ''}>Momo</option>
                            <option value="Vietcombank" ${bank.bankName == 'Vietcombank' ? 'selected' : ''}>Vietcombank</option>
                            <option value="Techcombank" ${bank.bankName == 'Techcombank' ? 'selected' : ''}>Techcombank</option>
                            <option value="BIDV" ${bank.bankName == 'BIDV' ? 'selected' : ''}>BIDV</option>
                            <option value="VietinBank" ${bank.bankName == 'VietinBank' ? 'selected' : ''}>VietinBank</option>
                            <option value="Agribank" ${bank.bankName == 'Agribank' ? 'selected' : ''}>Agribank</option>
                            <option value="ACB" ${bank.bankName == 'ACB' ? 'selected' : ''}>ACB</option>
                            <option value="VPBank" ${bank.bankName == 'VPBank' ? 'selected' : ''}>VPBank</option>
                            <option value="TPBank" ${bank.bankName == 'TPBank' ? 'selected' : ''}>TPBank</option>
                            <option value="MBBank" ${bank.bankName == 'MBBank' ? 'selected' : ''}>MBBank</option>
                            <option value="Sacombank" ${bank.bankName == 'Sacombank' ? 'selected' : ''}>Sacombank</option>
                            <option value="HDBank" ${bank.bankName == 'HDBank' ? 'selected' : ''}>HDBank</option>
                            <option value="OCB" ${bank.bankName == 'OCB' ? 'selected' : ''}>OCB</option>
                            <option value="SHB" ${bank.bankName == 'SHB' ? 'selected' : ''}>SHB</option>
                        </select>
                    </label>

                    <label>
                        <i class="bi bi-credit-card me-1"></i> Số tài khoản <span class="text-danger">*</span>
                        <div class="input-group">
                            <input id="accountNumber" name="accountNumber" class="form-control" type="password"
                                   value="${bank.accountNumber}" pattern="\d{9,20}"
                                   title="Số tài khoản phải là 9-20 chữ số" required placeholder="Nhập số tài khoản">
                            <span class="input-group-text" id="toggleEye" style="cursor:pointer">
                    <i class="bi bi-eye" id="eyeIcon"></i>
                </span>
                        </div>
                        <small class="text-muted">Chỉ nhập số, từ 9-20 chữ số</small>
                    </label>

                    <label>
                        <i class="bi bi-person-circle me-1"></i> Chủ tài khoản <span class="text-danger">*</span>
                        <input name="accountName" class="form-control" value="${bank.accountName}"
                               required placeholder="VD: NGUYEN VAN A" style="text-transform: uppercase;">
                        <small class="text-muted">Nhập đúng tên trên thẻ ngân hàng (viết hoa, không dấu)</small>
                    </label>

                    <label class="mt-3">
                        <i class="bi bi-qr-code me-1"></i> Mã QR thanh toán
                        <c:if test="${empty bank}">
                            <span class="text-danger">*</span>
                        </c:if>
                    </label>

                    <input type="file" id="qrUpload" name="qr" accept="image/*" class="form-control d-none" ${empty bank ? 'required' : ''}>

                    <c:if test="${not empty bank.qrCodeImage}">
                        <div id="currentQR" class="text-center mt-2">
                            <p class="text-muted small mb-1"><i class="bi bi-image me-1"></i>QR hiện tại:</p>
                            <img src="${pageContext.request.contextPath}/uploads/qr/${bank.qrCodeImage}"
                                 width="140" class="border rounded">
                        </div>
                    </c:if>

                    <div class="text-center">
                        <img id="qrPreviewImg" class="border rounded mt-2 d-none" width="140">
                    </div>

                    <div class="text-center">
                        <div id="khungThemQR" class="border rounded p-3 mt-2 bg-light" style="cursor:pointer; display: inline-block;">
                            <i class="bi bi-${not empty bank.qrCodeImage ? 'arrow-repeat' : 'plus-lg'}"></i>
                            ${not empty bank.qrCodeImage ? 'Thay đổi QR' : 'Tải lên QR'}
                        </div>
                    </div>

                    <small class="text-muted d-block text-center mt-2">
                        <i class="bi bi-info-circle"></i>
                        ${empty bank ? 'Bắt buộc phải có ảnh QR code' : 'Để trống nếu không muốn thay đổi'}
                    </small>

                    <div class="mt-3 d-flex gap-2 justify-content-center">
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-${empty bank ? 'plus-lg' : 'check-lg'}"></i>
                            ${empty bank ? 'Thêm mới' : 'Cập nhật'}
                        </button>
                        <button type="button" id="btnCancelBank" class="btn btn-secondary">
                            <i class="bi bi-x-lg"></i> Hủy
                        </button>
                    </div>
                </form>
            </div>

            <hr>
            <hr>

            <!-- ========== ĐỔI MẬT KHẨU ========== -->
            <h4><i class="bi bi-shield-lock me-2"></i>Đổi mật khẩu</h4>

            <!-- Hiển thị thông báo -->
            <c:if test="${not empty sessionScope.passMsg}">
                <div class="alert alert-dismissible fade show ${fn:contains(sessionScope.passMsg, 'thành công') ? 'alert-success' : 'alert-danger'}" role="alert">
                    <i class="bi ${fn:contains(sessionScope.passMsg, 'thành công') ? 'bi-check-circle' : 'bi-exclamation-circle'} me-2"></i>
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
                    Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt (@$!%*?&).
                </small>

                <label>
                    <i class="bi bi-key me-1"></i> Mật khẩu cũ
                    <div class="input-group">
                        <input type="password" name="oldPassword" id="oldPassword" required placeholder="Nhập mật khẩu cũ">
                        <span class="input-group-text toggle-password" data-target="oldPassword" style="cursor:pointer">
                                <i class="bi bi-eye"></i>
                            </span>
                    </div>
                </label>

                <label>
                    <i class="bi bi-key-fill me-1"></i> Mật khẩu mới
                    <div class="input-group">
                        <input type="password" name="newPassword" id="newPassword" required minlength="8"
                               pattern="^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&]).{8,}$"
                               title="Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt"
                               placeholder="Nhập mật khẩu mới">
                        <span class="input-group-text toggle-password" data-target="newPassword" style="cursor:pointer">
                                <i class="bi bi-eye"></i>
                            </span>
                    </div>
                </label>

                <label>
                    <i class="bi bi-shield-check me-1"></i> Xác nhận mật khẩu
                    <div class="input-group">
                        <input type="password" name="confirmPassword" id="confirmPassword" required
                               placeholder="Nhập lại mật khẩu mới">
                        <span class="input-group-text toggle-password" data-target="confirmPassword" style="cursor:pointer">
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
                item.parentElement.classList.toggle('open');
            });
        });

        /* ===== AVATAR UPLOAD & PREVIEW ===== */
        const avatarWrapper = document.querySelector(".avatar-wrapper");
        const avatarInput = document.getElementById("avatarInput");
        const avatarPreview = document.getElementById("avatarPreview");

        if (avatarWrapper && avatarInput) {
            avatarWrapper.addEventListener("click", () => avatarInput.click());

            avatarInput.addEventListener("change", function () {
                const file = this.files[0];
                if (!file) return;

                if (!file.type.startsWith('image/')) {
                    alert('⚠️ Vui lòng chọn file hình ảnh!');
                    this.value = '';
                    return;
                }

                if (file.size > 5 * 1024 * 1024) {
                    alert('⚠️ File không được vượt quá 5MB!');
                    this.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = e => avatarPreview.src = e.target.result;
                reader.readAsDataURL(file);
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
            toggle.addEventListener('click', function() {
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
            changePassForm.addEventListener("submit", function(e) {
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