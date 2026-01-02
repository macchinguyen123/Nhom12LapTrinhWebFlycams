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
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/stylesheets/admin/profile-admin.css">
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
                                    <li><i class="bi bi-bar-chart"></i> Báo Cáo & Thống Kê</li>
                                </a>
                            </ul>
                        </aside>


                        <div class="profile-page">
                            <!-- LEFT SIDE -->
                            <div class="profile-left">
                                <div class="avatar-box">
                                    <div class="avatar-wrapper">
                                        <img src="${pageContext.request.contextPath}/image/logoTCN.png" alt="Avatar"
                                            class="avatar-img">
                                        <span class="avatar-camera">
                                            <i class="bi bi-camera-fill"></i>
                                        </span>
                                    </div>
                                    <input type="file" id="avatar-upload" accept="image/*" hidden>
                                </div>
                                <h3>Mạc Nguyên</h3>
                            </div>
                        </div>

                        <!-- RIGHT SIDE -->
                        <div class="profile-right">
                            <!-- Thông tin cơ bản -->
                            <h4>Thông tin cơ bản</h4>

                            <form id="profileForm"
                                action="${pageContext.request.contextPath}/admin/profile?action=update-info"
                                method="post" enctype="multipart/form-data">

                                <label>Họ tên
                                    <input name="fullName" value="${admin.fullName}" required>
                                </label>

                                <label>Email
                                    <input type="email" name="email" value="${admin.email}" required>
                                </label>

                                <label>Số điện thoại
                                    <input name="phone" value="${admin.phoneNumber}" required>
                                </label>

                                <div class="actions">
                                    <button type="submit" class="btn btn-primary">
                                        Lưu thay đổi
                                    </button>
                                </div>
                            </form>


                            <hr>

                            <h4 class="fw-bold">Thông tin ngân hàng</h4>

                            <div class="bank-info" id="bankView">
                                <div class="bank-details">
                                    <p>
                                        <strong>Ngân hàng:</strong>
                                        <span id="bankNameText">${bank.bankName}</span>
                                    </p>

                                    <p>
                                        <strong>Số tài khoản:</strong>
                                        <span id="acctMasked">
                                            **** **** ${fn:substring(bank.accountNumber, bank.accountNumber.length()-4,
                                            bank.accountNumber.length())}
                                        </span>
                                    </p>

                                    <p>
                                        <strong>Chủ tài khoản:</strong>
                                        <span id="acctNameText">${bank.accountName}</span>
                                    </p>
                                </div>

                                <button id="btn-edit-bank" class="btn btn-sm btn-outline-primary">
                                    <i class="bi bi-pencil-square"></i>
                                </button>

                                <div class="bank-qr">
                                    <p><strong>Mã QR thanh toán</strong></p>
                                    <img src="${pageContext.request.contextPath}/uploads/qr/${bank.qrCodeImage}"
                                        alt="QR Code"
                                        onerror="this.src='${pageContext.request.contextPath}/image/qr/qr.png'">
                                </div>
                            </div>


                            <!-- Bản chỉnh sửa -->
                            <div class="bank-info-edit p-3 border rounded mb-3 d-none" id="bankEdit">

                                <form id="bankForm"
                                    action="${pageContext.request.contextPath}/admin/profile?action=update-bank"
                                    method="post" enctype="multipart/form-data">

                                    <label>Ngân hàng
                                        <select name="bankName" class="form-select" required>
                                            <option value="">-- Chọn ngân hàng --</option>
                                            <option value="Momo" ${bank.bankName=='Momo' ? 'selected' : '' }>Momo
                                            </option>
                                            <option value="Vietcombank" ${bank.bankName=='Vietcombank' ? 'selected' : ''
                                                }>Vietcombank
                                            </option>
                                            <option value="Techcombank" ${bank.bankName=='Techcombank' ? 'selected' : ''
                                                }>Techcombank
                                            </option>
                                        </select>
                                    </label>

                                    <label>Số tài khoản
                                        <div class="input-group">
                                            <input id="accountNumber" name="accountNumber" class="form-control"
                                                value="${bank.accountNumber}" required>

                                            <span class="input-group-text" id="toggleEye" style="cursor:pointer">
                                                <i class="bi bi-eye"></i>
                                            </span>
                                        </div>
                                    </label>


                                    <label>Chủ tài khoản
                                        <input name="accountName" class="form-control" value="${bank.accountName}"
                                            required>
                                    </label>

                                    <label class="mt-2">Mã QR thanh toán</label>

                                    <input type="file" id="qrUpload" name="qr" accept="image/*"
                                        class="form-control d-none">

                                    <img id="qrPreviewImg" class="border rounded mt-2 d-none" width="140">

                                    <div id="khungThemQR" class="border rounded p-3 mt-2" style="cursor:pointer">
                                        <i class="bi bi-plus-lg"></i> Thêm QR
                                    </div>

                                    <div class="mt-3 d-flex gap-2">
                                        <button type="submit" class="btn btn-primary">Lưu</button>
                                        <button type="button" id="btnCancelBank" class="btn btn-secondary">Hủy</button>
                                    </div>
                                </form>
                            </div>
                            <!-- Đổi mật khẩu -->
                            <h4>Đổi mật khẩu</h4>
                            <form id="changePassForm"
                                action="${pageContext.request.contextPath}/admin/profile?action=change-password"
                                method="post">
                                <small class="password-hint">
                                    Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt.
                                </small>
                                <label>Mật khẩu cũ
                                    <input type="text" name="oldPassword" required>
                                </label>
                                <label>Mật khẩu mới
                                    <input type="text" name="newPassword" required minlength="8">
                                </label>
                                <label>Xác nhận mật khẩu
                                    <input type="text" name="confirmPassword" required>
                                </label>
                                <div class="actions">
                                    <button type="submit" class="btn btn-primary">Đổi mật khẩu</button>
                                </div>
                                <p id="passMsg" class="muted"></p>
                            </form>
                        </div>
                    </div>


                    </div>
                    </div>
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {

                            /* =============================
                               SIDEBAR
                            ==============================*/
                            document.querySelectorAll('.has-submenu .menu-item').forEach(item => {
                                item.addEventListener('click', () => {
                                    item.parentElement.classList.toggle('open');
                                });
                            });

                            /* =============================
                               AVATAR PREVIEW
                            ==============================*/
                            const avatarWrapper = document.querySelector(".avatar-wrapper");
                            const avatarUpload = document.getElementById("avatar-upload");
                            const avatarImg = document.querySelector(".avatar-img");

                            if (avatarWrapper && avatarUpload) {
                                avatarWrapper.addEventListener("click", () => avatarUpload.click());

                                avatarUpload.addEventListener("change", function () {
                                    const file = this.files[0];
                                    if (!file) return;
                                    const reader = new FileReader();
                                    reader.onload = e => avatarImg.src = e.target.result;
                                    reader.readAsDataURL(file);
                                });
                            }

                            /* =============================
                               BANK EDIT TOGGLE (QUAN TRỌNG)
                            ==============================*/
                            const bankView = document.getElementById("bankView");
                            const bankEdit = document.getElementById("bankEdit");
                            const btnEdit = document.getElementById("btn-edit-bank");
                            const btnCancel = document.getElementById("btnCancelBank");

                            if (btnEdit && bankView && bankEdit) {
                                btnEdit.addEventListener("click", () => {
                                    bankView.classList.add("d-none");
                                    bankEdit.classList.remove("d-none");
                                });
                            }

                            if (btnCancel && bankView && bankEdit) {
                                btnCancel.addEventListener("click", () => {
                                    bankEdit.classList.add("d-none");
                                    bankView.classList.remove("d-none");
                                });
                            }

                            /* =============================
                               QR PREVIEW
                            ==============================*/
                            const qrUpload = document.getElementById("qrUpload");
                            const qrPreviewImg = document.getElementById("qrPreviewImg");
                            const khungThemQR = document.getElementById("khungThemQR");

                            if (khungThemQR && qrUpload) {
                                khungThemQR.addEventListener("click", () => qrUpload.click());
                            }

                            if (qrUpload && qrPreviewImg) {
                                qrUpload.addEventListener("change", () => {
                                    const file = qrUpload.files[0];
                                    if (!file) return;
                                    const reader = new FileReader();
                                    reader.onload = e => {
                                        qrPreviewImg.src = e.target.result;
                                        qrPreviewImg.classList.remove("d-none");
                                    };
                                    reader.readAsDataURL(file);
                                });
                            }

                            /* =============================
                               LOGOUT
                            ==============================*/
                            if (window.$) {
                                $("#logoutBtn").on("click", () => $("#logoutModal").css("display", "flex"));
                                $("#cancelLogout").on("click", () => $("#logoutModal").hide());
                            }
                        });
                    </script>


                </body>

                </html>