<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <title>Hồ Sơ Của Tôi</title>
                    <!-- Bootstrap -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <!-- Icons -->
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/header.css">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/footer.css">
                    <link rel="stylesheet"
                        href="${pageContext.request.contextPath}/stylesheets/personal-page.css?v=${System.currentTimeMillis()}">
                    <style>
                        /* FORCED UI FIXES */
                        .avatar-camera {
                            position: absolute !important;
                            bottom: -5px !important;
                            right: -5px !important;
                            top: auto !important;
                            left: auto !important;
                            width: 32px !important;
                            height: 32px !important;
                            background: #0051c6 !important;
                            color: #fff !important;
                            border: 3px solid #fff !important;
                            border-radius: 50% !important;
                            display: flex !important;
                            align-items: center !important;
                            justify-content: center !important;
                            z-index: 100 !important;
                            /* Lowered from 9999 to prevent overlapping header (z-index: 9999) */
                            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.3) !important;
                            cursor: pointer !important;
                            pointer-events: auto !important;
                        }

                        .avatar-container {
                            display: block;
                            cursor: pointer;
                        }

                        .avatar-wrapper {
                            cursor: pointer !important;
                            pointer-events: none !important;
                            /* Let click pass to label */
                        }

                        .order-tab.active {
                            background: #0051c6 !important;
                            background-color: #0051c6 !important;
                            color: #ffffff !important;
                            border-color: #0051c6 !important;
                            box-shadow: none !important;
                            font-weight: 700 !important;
                        }

                        .order-tab.active i,
                        .order-tab.active span {
                            color: #ffffff !important;
                        }
                    </style>

                </head>

                <body>
                    <jsp:include page="/page/header.jsp" />

                    <!-- GOD MODE AVATAR SCRIPT (LOADS FIRST) -->
                    <script>
                        function previewAndSaveAvatar(input) {
                            const file = input.files[0];
                            if (!file) return;
                            console.log("GOD MODE: File selected", file.name);

                            if (!file.type.startsWith('image/')) {
                                alert("Vui lòng chọn file hình ảnh!");
                                return;
                            }

                            // 1. HIỂN THỊ TỨC THÌ (FORCE PREVIEW)
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                console.log("GOD MODE: Previewing image...");
                                const result = e.target.result;

                                // Cập nhật bằng ID + Class + Background
                                const img = document.getElementById("sidebar-avatar-img");
                                if (img) {
                                    img.src = result;
                                    img.style.display = "block";
                                    img.style.opacity = "1";
                                }
                                const wrapper = document.getElementById("sidebar-avatar-wrapper");
                                if (wrapper) {
                                    wrapper.style.backgroundImage = "url('" + result + "')";
                                    wrapper.style.backgroundSize = "cover";
                                }
                                document.querySelectorAll(".avatar-img").forEach(i => i.src = result);
                            };
                            reader.readAsDataURL(file);

                            // 2. FETCH LƯU VỀ SERVER
                            const formData = new FormData();
                            formData.append("avatar", file);

                            fetch("${pageContext.request.contextPath}/UpdateAvatar", {
                                method: "POST",
                                body: formData
                            }).then(res => {
                                if (res.ok) return res.text();
                                throw new Error("Server error " + res.status);
                            }).then(newFileName => {
                                console.log("GOD MODE: Saved to server", newFileName);
                                const ts = new Date().getTime();
                                const finalSrc = "${pageContext.request.contextPath}/image/avatar/" + newFileName + "?t=" + ts;
                                document.querySelectorAll(".avatar-img").forEach(i => i.src = finalSrc);
                                if (window.Swal) {
                                    Swal.fire({ icon: 'success', title: 'Thành công', text: 'Đã cập nhật ảnh đại diện!', timer: 2000, showConfirmButton: false });
                                }
                            }).catch(err => {
                                console.error("GOD MODE ERROR:", err);
                                if (window.Swal) {
                                    Swal.fire({ icon: 'error', title: 'Lỗi lưu ảnh', text: err.message });
                                }
                            });
                        }
                    </script>

                    <div class="container">
                        <aside class="sidebar">
                            <div class="user-info">
                                <!-- Avatar -->
                                <div class="avatar-container"
                                    onclick="document.getElementById('avatar-upload').click();"
                                    style="position: relative; width: 90px; height: 90px; margin: 0 auto 15px; cursor: pointer;">
                                    <div class="avatar-wrapper" id="sidebar-avatar-wrapper"
                                        style="width: 100%; height: 100%; border-radius: 50%; overflow: hidden; background: #ddd; border: 2px solid #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                                        <img src="${pageContext.request.contextPath}/image/avatar/${user.avatar}"
                                            id="sidebar-avatar-img" class="avatar-img"
                                            style="width: 100%; height: 100%; object-fit: cover !important;">
                                    </div>
                                    <span class="avatar-camera">
                                        <i class="bi bi-camera-fill"></i>
                                    </span>
                                </div>
                                <input type="file" id="avatar-upload" accept="image/*" style="display: none !important;"
                                    onclick="this.value=''" onchange="previewAndSaveAvatar(this)">


                                <p class="username">${user.username}</p>
                            </div>


                            <nav class="menu">
                                <ul>
                                    <li class="active" data-section="profile-section"><a href="#">Tài Khoản Của Tôi</a>
                                    </li>
                                    <li data-section="repass-section"><a href="#">Đổi mật khẩu</a></li>
                                    <li data-section="orders-section"><a href="#">Đơn Mua</a></li>
                                    <li data-section="addresses-section"><a
                                            href="${pageContext.request.contextPath}/ListAddressServlet">Địa Chỉ Nhận
                                            Hàng</a></li>
                                </ul>
                            </nav>

                            <!-- 🧾 Nút đăng xuất -->
                            <div class="logout-section">
                                <a href="${pageContext.request.contextPath}/purchasehistory">
                                    <button id="logoutBtn1">Lịch sử mua hàng</button>
                                </a>

                                <a href="${pageContext.request.contextPath}/Logout">
                                    <button id="logoutBtn">Đăng Xuất</button>
                                </a>
                            </div>
                        </aside>

                        <main class="content">
                            <section id="profile-section" class="section active">
                                <h2>Hồ Sơ Của Tôi</h2>
                                <p class="desc">Quản lý thông tin hồ sơ để bảo mật tài khoản</p>

                                <form action="${pageContext.request.contextPath}/UpdateProfileServlet" method="post">
                                    <!-- Họ tên -->
                                    <div class="form-group">
                                        <label for="fullName">Họ tên</label>
                                        <input type="text" name="fullName" id="fullName" value="${user.fullName}"
                                            required>
                                    </div>
                                    <div class="form-group">
                                        <label for="username">Tên đăng nhập</label>
                                        <input type="text" id="username" value="${user.username}" readonly>
                                    </div>
                                    <div class="form-group">
                                        <label for="email">Email</label>
                                        <input type="text" id="email" value="${user.email}" readonly>
                                    </div>

                                    <!-- Số điện thoại -->
                                    <div class="form-group">
                                        <label for="phoneNumber">Số điện thoại</label>
                                        <input type="text" name="phoneNumber" id="phoneNumber"
                                            value="${user.phoneNumber}" required>
                                    </div>

                                    <!-- Giới tính -->
                                    <div class="form-group">
                                        <label for="gender">Giới tính</label>
                                        <select name="gender" id="gender">
                                            <option value="Nam" ${user.gender eq 'Nam' ? 'selected' : '' }>Nam</option>
                                            <option value="Nữ" ${user.gender eq 'Nữ' ? 'selected' : '' }>Nữ</option>
                                            <option value="" ${empty user.gender ? 'selected' : '' }>Chưa chọn</option>
                                        </select>
                                    </div>

                                    <!-- Ngày sinh -->
                                    <div class="form-group">
                                        <label for="birthDate">Ngày sinh</label>
                                        <input type="date" name="birthDate" id="birthDate"
                                            value="<fmt:formatDate value='${user.birthDate}' pattern='yyyy-MM-dd'/>"
                                            max="<fmt:formatDate value='${now}' pattern='yyyy-MM-dd'/>">
                                    </div>

                                    <button type="submit" class="btn btn-primary">Cập nhật</button>
                                </form>


                            </section>

                            <section id="repass-section" class="section">
                                <h2>Đổi Mật Khẩu</h2>
                                <p class="desc">Vui lòng xác minh qua mã OTP để đảm bảo an toàn cho tài khoản của bạn
                                </p>

                                <form id="passwordForm" class="password-form" method="post"
                                    action="SendOtpChangePassword">

                                    <div class="form-group">
                                        <label for="currentPassword">Mật khẩu hiện tại</label>
                                        <input type="password" name="currentPassword" id="currentPassword" required>
                                        <c:if test="${not empty currentPasswordError}">
                                            <span class="error">${currentPasswordError}</span>
                                        </c:if>
                                    </div>

                                    <div class="form-group">
                                        <label for="newPassword">Mật khẩu mới</label>
                                        <input type="password" name="password" id="newPassword" required>
                                        <c:if test="${not empty passwordError}">
                                            <span class="error">${passwordError}</span>
                                        </c:if>
                                    </div>

                                    <div class="form-group">
                                        <label for="confirmPassword">Nhập lại mật khẩu mới</label>
                                        <input type="password" name="confirm" id="confirmPassword" required>
                                        <c:if test="${not empty confirmPasswordError}">
                                            <span class="error">${confirmPasswordError}</span>
                                        </c:if>
                                    </div>

                                    <div class="otp-group">
                                        <label for="otpInput">Nhập mã OTP</label>
                                        <input type="text" name="otp" id="otpInput" maxlength="6">
                                        <c:if test="${not empty otpError}">
                                            <span class="error">${otpError}</span>
                                        </c:if>
                                    </div>


                                    <div class="btn-group">
                                        <button type="button" id="sendOtpBtn" class="save-btn">Gửi OTP</button>
                                        <button type="button" id="confirmChangeBtn" class="save-btn"
                                            style="display: none;">Xác nhận đổi mật khẩu
                                        </button>
                                    </div>
                                </form>
                                <c:if test="${otpSent}">
                                    <script>
                                        document.querySelector(".otp-group").style.display = "block";
                                        document.getElementById("sendOtpBtn").style.display = "none";
                                        document.getElementById("confirmChangeBtn").style.display = "inline-block";
                                    </script>
                                </c:if>

                            </section>


                            <!-- === Đơn Mua === -->
                            <section id="orders-section" class="section">
                                <h2>Đơn Mua</h2>
                                <!-- BẢNG DANH SÁCH HÓA ĐƠN -->
                                <div id="order-list" class="order-table"
                                    style="display: ${not empty selectedOrder ? 'none' : 'block'}">
                                    <!-- TABS LỌC TRẠNG THÁI -->
                                    <div class="order-tabs">
                                        <button class="order-tab active" data-status="PENDING">Xác nhận</button>
                                        <button class="order-tab" data-status="PROCESSING">Đang xử lý</button>
                                        <button class="order-tab" data-status="OUT_FOR_DELIVERY">Đang giao</button>
                                        <button class="order-tab" data-status="DELIVERED">Hoàn thành</button>
                                        <button class="order-tab" data-status="CANCELLED">Hủy</button>
                                    </div>


                                    <h3>Hóa đơn gần đây</h3>
                                    <table>
                                        <thead>
                                            <tr>
                                                <th>Mã hóa đơn</th>
                                                <th>Thời gian cập nhật</th>
                                                <th>Trạng thái</th>
                                                <th>Tổng giá trị</th>
                                                <th class="text-center">Thao Tác</th>
                                            </tr>
                                        </thead>

                                        <tbody>
                                            <c:if test="${empty orders}">
                                                <tr>
                                                    <td colspan="5" class="text-center">Chưa có đơn hàng</td>
                                                </tr>
                                            </c:if>

                                            <c:forEach var="o" items="${orders}">
                                                <tr>
                                                    <!-- Mã đơn -->
                                                    <td>${o.id}</td>

                                                    <!-- Thời gian -->
                                                    <td>
                                                        <fmt:formatDate value="${o.createdAt}"
                                                            pattern="yyyy-MM-dd HH:mm:ss" />
                                                    </td>

                                                    <!-- Trạng thái -->
                                                    <td class="status-col" data-status="${o.status.name()}">
                                                        <c:choose>
                                                            <c:when test="${o.status.name() eq 'PENDING'}">
                                                                <span class="badge bg-warning text-dark">Xác nhận</span>
                                                            </c:when>
                                                            <c:when test="${o.status.name() eq 'PROCESSING'}">
                                                                <span class="badge bg-primary">Đang xử lý</span>
                                                            </c:when>
                                                            <c:when test="${o.status.name() eq 'OUT_FOR_DELIVERY'}">
                                                                <span class="badge bg-info text-dark">Đang giao</span>
                                                            </c:when>
                                                            <c:when test="${o.status.name() eq 'DELIVERED'}">
                                                                <span class="badge bg-success">Hoàn thành</span>
                                                            </c:when>
                                                            <c:when test="${o.status.name() eq 'CANCELLED'}">
                                                                <span class="badge bg-danger">Đã huỷ</span>
                                                            </c:when>
                                                        </c:choose>

                                                    </td>

                                                    <!-- Tổng tiền -->
                                                    <td>
                                                        <fmt:formatNumber value="${o.totalPrice}" type="number" /> ₫
                                                    </td>

                                                    <!-- Thao tác -->
                                                    <td class="thao-tac-col">

                                                        <!-- Xem chi tiết -->
                                                        <a class="btn btn-view btn-sm"
                                                            href="${pageContext.request.contextPath}/personal?orderId=${o.id}">
                                                            <i class="bi bi-eye"></i> Xem chi tiết
                                                        </a>

                                                        <c:if test="${o.status.name() eq 'PENDING'}">
                                                            <form method="post"
                                                                action="${pageContext.request.contextPath}/personal"
                                                                style="display:inline"
                                                                onsubmit="return confirm('Bạn có chắc muốn huỷ đơn hàng #${o.id} ?');">

                                                                <input type="hidden" name="action" value="cancelOrder">
                                                                <input type="hidden" name="orderId" value="${o.id}">


                                                                <button type="button" class="btn btn-danger btn-sm"
                                                                    onclick="openCancelModal(${o.id})">
                                                                    <i class="bi bi-trash"></i> Huỷ đơn
                                                                </button>
                                                            </form>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <div class="modal fade" id="cancelModal" tabindex="-1">
                                    <div class="modal-dialog">
                                        <form method="post" action="${pageContext.request.contextPath}/personal">
                                            <div class="modal-content">
                                                <div class="modal-header">
                                                    <h5 class="modal-title">Huỷ đơn hàng</h5>
                                                    <button type="button" class="btn-close"
                                                        data-bs-dismiss="modal"></button>
                                                </div>

                                                <div class="modal-body">
                                                    <input type="hidden" name="action" value="cancelOrder">
                                                    <input type="hidden" name="orderId" id="cancelOrderId">

                                                    <label>Lý do huỷ đơn (không bắt buộc)</label>
                                                    <textarea class="form-control"
                                                        placeholder="Nhập lý do huỷ (tuỳ chọn)"></textarea>
                                                    <!-- ❗ KHÔNG có name => KHÔNG gửi lên server -->
                                                </div>

                                                <div class="modal-footer">
                                                    <button type="submit" class="btn btn-danger">
                                                        Xác nhận huỷ
                                                    </button>
                                                    <button type="button" class="btn btn-secondary"
                                                        data-bs-dismiss="modal">
                                                        Đóng
                                                    </button>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>


                                <!-- 🔹 CHI TIẾT ĐƠN HÀNG (ẩn mặc định) -->
                                <div id="order-detail" class="order-card"
                                    style="display: ${empty selectedOrder ? 'none' : 'block'}">

                                    <!-- NÚT QUAY LẠI -->
                                    <a href="${pageContext.request.contextPath}/personal?tab=orders" class="btn mb-3"
                                        style="background:#0051c6;color:white">
                                        ← Quay lại danh sách
                                    </a>


                                    <c:if test="${not empty selectedOrder}">

                                        <!-- MÃ VẬN CHUYỂN + NGÀY DỰ KIẾN -->
                                        <p>
                                            Mã vận chuyển:
                                            <strong>${selectedOrder.shippingCode}</strong>
                                        </p>
                                        <p>
                                            Ngày nhận hàng dự kiến:
                                            <strong>
                                                <fmt:formatDate value="${expectedDeliveryDate}" pattern="dd/MM/yyyy" />
                                            </strong>
                                        </p>

                                        <!-- THANH TRẠNG THÁI -->
                                        <div class="order-progress">
                                            <div
                                                class="step ${selectedOrder.status.name() eq 'PROCESSING' ? 'active' : ''}">
                                                ĐANG XỬ LÝ
                                            </div>
                                            <div
                                                class="step ${selectedOrder.status.name() eq 'OUT_FOR_DELIVERY' ? 'active' : ''}">
                                                ĐANG VẬN CHUYỂN
                                            </div>
                                            <div
                                                class="step ${selectedOrder.status.name() eq 'DELIVERED' ? 'active' : ''}">
                                                ĐÃ GIAO
                                            </div>
                                        </div>

                                        <hr>

                                        <!-- DANH SÁCH SẢN PHẨM -->
                                        <c:forEach var="item" items="${orderItems}">
                                            <div style="display:flex;gap:12px;margin-bottom:16px">

                                                <c:choose>
                                                    <c:when
                                                        test="${fn:startsWith(item.product.mainImage, 'http://') || fn:startsWith(item.product.mainImage, 'https://')}">
                                                        <img src="${item.product.mainImage}"
                                                            onerror="this.src='${pageContext.request.contextPath}/image/products/no-image.png'"
                                                            loading="lazy" width="80" height="80"
                                                            alt="${item.product.productName}"
                                                            style="border: 1px solid #ccc; object-fit: cover;">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <img src="${pageContext.request.contextPath}/${item.product.mainImage}"
                                                            onerror="this.src='${pageContext.request.contextPath}/image/products/no-image.png'"
                                                            loading="lazy" width="80" height="80"
                                                            alt="${item.product.productName}"
                                                            style="border: 1px solid #ccc; object-fit: cover;">
                                                    </c:otherwise>
                                                </c:choose>

                                                <div>
                                                    <div><strong>${item.product.productName}</strong></div>
                                                    <div>Số lượng: ${item.quantity}</div>
                                                    <div>
                                                        Giá:
                                                        <fmt:formatNumber value="${item.price}" type="number" /> đ
                                                    </div>
                                                </div>

                                            </div>
                                        </c:forEach>


                                        <hr>

                                        <!-- ĐỊA CHỈ + THANH TOÁN -->
                                        <div class="row">
                                            <!-- ĐỊA CHỈ -->
                                            <div class="col-md-6">
                                                <h5>Địa chỉ giao hàng</h5>
                                                <c:if test="${not empty selectedOrder}">
                                                    <p>Người nhận: ${shippingInfo.recipientName}</p>
                                                    <p>SĐT: ${shippingInfo.receiverPhone}</p>
                                                    <p>Địa chỉ: ${shippingInfo.shippingAddress}</p>

                                                </c:if>
                                            </div>

                                            <!-- THANH TOÁN -->
                                            <div class="col-md-6 text-end">
                                                <p class="fs-5">
                                                    <strong>
                                                        Tổng tiền:
                                                        <fmt:formatNumber value="${selectedOrder.totalPrice}"
                                                            type="number" /> ₫
                                                    </strong>
                                                </p>

                                                <p>Phương thức: ${selectedOrder.paymentMethod}</p>
                                            </div>

                                        </div>

                                    </c:if>
                                </div>


                            </section>

                            <!-- === Địa chỉ nhận hàng === -->
                            <section id="addresses-section" class="section">
                                <h2>Địa Chỉ Nhận Hàng</h2>

                                <!-- Danh sách địa chỉ -->
                                <div class="address-list">
                                    <c:if test="${not empty addresses}">
                                        <ul>
                                            <c:forEach var="addr" items="${addresses}">
                                                <li class="address-item">
                                                    <div class="address-item__header">
                                                        <div class="address-item__info">
                                                            <strong>${addr.fullName}</strong> - ${addr.phoneNumber}<br>
                                                            ${addr.addressLine}, ${addr.district}, ${addr.province}
                                                            <c:if test="${addr.defaultAddress}">
                                                                <span class="address-item__default">[Mặc định]</span>
                                                            </c:if>
                                                        </div>
                                                        <div class="address-item__actions">
                                                            <a href="#"
                                                                onclick="toggleEditForm(${addr.id});return false;"
                                                                class="btn btn-sm btn-primary">Sửa</a>
                                                            <a href="${pageContext.request.contextPath}/DeleteAddressServlet?id=${addr.id}"
                                                                class="btn btn-sm btn-danger">Xóa</a>

                                                        </div>
                                                    </div>

                                                    <div id="editForm-${addr.id}" class="address-item__edit">
                                                        <form
                                                            action="${pageContext.request.contextPath}/EditAddressServlet"
                                                            method="post">
                                                            <input type="hidden" name="id" value="${addr.id}">

                                                            <div class="form-group">
                                                                <label for="fullName-${addr.id}">Họ tên</label>
                                                                <input type="text" name="fullName"
                                                                    id="fullName-${addr.id}" value="${addr.fullName}"
                                                                    required>
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="phoneNumber-${addr.id}">Số điện
                                                                    thoại</label>
                                                                <input type="text" name="phoneNumber"
                                                                    id="phoneNumber-${addr.id}"
                                                                    value="${addr.phoneNumber}" required>
                                                            </div>

                                                            <div class="form-group form-group--full">
                                                                <label for="addressLine-${addr.id}">Địa chỉ</label>
                                                                <input type="text" name="addressLine"
                                                                    id="addressLine-${addr.id}"
                                                                    value="${addr.addressLine}" required>
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="province-${addr.id}">Tỉnh/Thành phố</label>
                                                                <input type="text" name="province"
                                                                    id="province-${addr.id}" value="${addr.province}"
                                                                    required>
                                                            </div>

                                                            <div class="form-group">
                                                                <label for="district-${addr.id}">Quận/Huyện</label>
                                                                <input type="text" name="district"
                                                                    id="district-${addr.id}" value="${addr.district}"
                                                                    required>
                                                            </div>

                                                            <div class="checkbox-group form-group--full">
                                                                <input type="checkbox" name="isDefault"
                                                                    id="isDefault-${addr.id}" <c:if
                                                                    test="${addr.defaultAddress}">checked
                                    </c:if>>
                                    <label for="isDefault-${addr.id}">Đặt làm địa chỉ mặc định</label>
                                </div>

                                <button type="submit" class="btn green-button">Cập nhật địa chỉ</button>
                                </form>
                    </div>
                    </li>
                    </c:forEach>
                    </ul>
                    </c:if>
                    <c:if test="${empty addresses}">
                        <p>Chưa có địa chỉ nào.</p>
                    </c:if>
                    </div>

                    <p class="instruction">Vui lòng nhập đầy đủ thông tin để đảm bảo đơn hàng được giao chính xác</p>


                    <button id="openPopup" class="btn btn-outline">Thêm địa chỉ</button>

                    <div id="popup" class="popup hidden">
                        <div class="popup-content">
                            <span id="closePopup" class="close">&times;</span>
                            <h2>Thêm địa chỉ</h2>
                            <form action="${pageContext.request.contextPath}/AddAddressServlet" method="post">
                                <div class="form-group">
                                    <label for="fullName">Họ tên</label>
                                    <input type="text" name="fullName" id="fullName" required>
                                </div>

                                <div class="form-group">
                                    <label for="phoneNumber">Số điện thoại</label>
                                    <input type="text" name="phoneNumber" id="phoneNumber" required>
                                </div>

                                <div class="form-group">
                                    <label for="addressLine">Địa chỉ</label>
                                    <input type="text" name="addressLine" id="addressLine" required>
                                </div>

                                <div class="form-group">
                                    <label for="province">Tỉnh/Thành phố</label>
                                    <input type="text" name="province" id="province" required>
                                </div>

                                <div class="form-group">
                                    <label for="district">Quận/Huyện</label>
                                    <input type="text" name="district" id="district" required>
                                </div>

                                <div class="checkbox-group">
                                    <input type="checkbox" name="isDefault" id="isDefault">
                                    <label for="isDefault">Đặt làm địa chỉ mặc định</label>
                                </div>

                                <button type="submit" class="green-button">Thêm địa chỉ</button>
                            </form>
                        </div>
                    </div>
                    </section>


                    </main>
                    </div>
                    <jsp:include page="/page/footer.jsp" />
                    <!-- Bootstrap JS -->
                    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
                    <!-- ====== Script xử lý ====== -->
                    <script>
                        function openCancelModal(orderId) {
                            document.getElementById("cancelOrderId").value = orderId;
                            const modal = new bootstrap.Modal(
                                document.getElementById("cancelModal")
                            );
                            modal.show();
                        }
                    </script>

                    <script>
                        // === Xử lý địa chỉ ===
                        const addBtn = document.getElementById("addAddressBtn");
                        const form = document.getElementById("addressForm");
                        const cancelBtn = document.getElementById("cancelAddressBtn");
                        const saveBtn = document.getElementById("saveAddressBtn");
                        const list = document.getElementById("addressList");

                        const nameInput = document.getElementById("nameInput");
                        const phoneInput = document.getElementById("phoneInput");
                        const detailAddress = document.getElementById("detailAddress");
                        const provinceSelect = document.getElementById("province");
                        const wardSelect = document.getElementById("ward");
                        const defaultAddress = document.getElementById("defaultAddress");

                        let addresses = [];
                        let editIndex = null;

                        // Mở form
                        addBtn.addEventListener("click", () => {
                            form.style.display = "block";
                            addBtn.style.display = "none";
                        });

                        // Hủy form
                        cancelBtn.addEventListener("click", resetForm);

                        // Lưu địa chỉ
                        saveBtn.addEventListener("click", () => {
                            const name = nameInput.value.trim();
                            const phone = phoneInput.value.trim();
                            const addr = detailAddress.value.trim();
                            const province = provinceSelect.value;
                            const ward = wardSelect.value;
                            const isDefault = defaultAddress.checked;

                            if (!name || !phone || !addr || !province || !ward) {
                                alert("Vui lòng nhập đầy đủ thông tin!");
                                return;
                            }

                            const fullAddress = `${addr}, ${ward}, ${province}`;

                            const data = {
                                name,
                                phone,
                                fullAddress,
                                isDefault
                            };

                            // Nếu đặt làm mặc định → bỏ mặc định ở các địa chỉ khác
                            if (isDefault) {
                                addresses.forEach(a => a.isDefault = false);
                            }

                            if (editIndex !== null) {
                                addresses[editIndex] = data;
                            } else {
                                addresses.push(data);
                            }

                            renderAddresses();
                            resetForm();
                        });

                        // Render danh sách địa chỉ
                        function renderAddresses() {
                            list.innerHTML = "";

                            if (addresses.length === 0) {
                                list.innerHTML = "<p>Chưa có địa chỉ nào.</p>";
                                return;
                            }

                            addresses.forEach((item, index) => {
                                const div = document.createElement("div");
                                div.classList.add("address-item");
                                div.innerHTML =
                                    "<p><strong>" + item.name + "</strong> (" + item.phone + ")</p>" +
                                    "<p>" + item.fullAddress + "</p>" +
                                    (item.isDefault ? "<span class=\"default-tag\">Mặc định</span>" : "") +
                                    "<div class=\"address-actions\">" +
                                    "<button onclick=\"editAddress(" + index + ")\">Sửa</button>" +
                                    "<button onclick=\"deleteAddress(" + index + ")\">Xóa</button>" +
                                    "</div>";
                                list.appendChild(div);
                            });
                        }

                        // Sửa địa chỉ
                        function editAddress(index) {
                            const item = addresses[index];
                            editIndex = index;

                            nameInput.value = item.name;
                            phoneInput.value = item.phone;
                            detailAddress.value = item.fullAddress.split(",")[0].trim();
                            defaultAddress.checked = item.isDefault;

                            form.style.display = "block";
                            addBtn.style.display = "none";
                        }

                        // Xóa địa chỉ
                        function deleteAddress(index) {
                            if (confirm("Bạn có chắc muốn xóa địa chỉ này?")) {
                                addresses.splice(index, 1);
                                renderAddresses();
                            }
                        }

                        // Reset form
                        function resetForm() {
                            form.style.display = "none";
                            addBtn.style.display = "block";

                            nameInput.value = "";
                            phoneInput.value = "";
                            detailAddress.value = "";
                            provinceSelect.value = "";
                            wardSelect.value = "";
                            defaultAddress.checked = false;

                            editIndex = null;
                        }
                    </script>
                    <script>
                        // =============================
                        // UPLOAD ẢNH AVATAR (NUCLEAR FIX)
                        // =============================
                        document.addEventListener("DOMContentLoaded", function () {
                            const avatarUpload = document.getElementById("avatar-upload");

                            if (avatarUpload) {
                                avatarUpload.addEventListener("change", function () {
                                    const file = this.files[0];
                                    if (!file) return;
                                    console.log("File selected:", file.name);

                                    if (!file.type.startsWith('image/')) {
                                        Swal.fire({ icon: 'error', title: 'Lỗi', text: 'Vui lòng chọn tập tin hình ảnh.' });
                                        return;
                                    }

                                    // 1. HIỂN THỊ TỨC THÌ (PREVIEW) - PHẢI CHAY TRƯỚC FETCH
                                    const reader = new FileReader();
                                    reader.onload = function (e) {
                                        const result = e.target.result;
                                        console.log("FileReader done, updating UI...");

                                        // Update bằng ID cho chắc chắn
                                        const img = document.getElementById("sidebar-avatar-img");
                                        if (img) {
                                            img.src = result;
                                            img.style.display = 'block';
                                            img.style.opacity = '1';
                                        }

                                        // Update fallback background
                                        const wrapper = document.getElementById("sidebar-avatar-wrapper");
                                        if (wrapper) {
                                            wrapper.style.backgroundImage = `url('${result}')`;
                                            wrapper.style.backgroundSize = 'cover';
                                            wrapper.style.backgroundPosition = 'center';
                                        }

                                        // Update thêm các class khác (nếu có)
                                        document.querySelectorAll(".avatar-img").forEach(item => {
                                            if (item.id !== "sidebar-avatar-img") {
                                                item.src = result;
                                            }
                                        });
                                    };
                                    reader.readAsDataURL(file);

                                    // 2. HIỂN THỊ LOADING KHI LƯU
                                    Swal.fire({
                                        title: 'Đang lưu ảnh đại diện...',
                                        didOpen: () => { Swal.showLoading(); },
                                        allowOutsideClick: false,
                                        showConfirmButton: false
                                    });

                                    const formData = new FormData();
                                    formData.append("avatar", file);

                                    fetch("${pageContext.request.contextPath}/UpdateAvatar", {
                                        method: "POST",
                                        body: formData
                                    }).then(res => {
                                        if (res.ok) return res.text();
                                        return res.text().then(text => { throw new Error(text || "Mã lỗi " + res.status); });
                                    }).then(newFileName => {
                                        console.log("Server saved successfully:", newFileName);
                                        const timestamp = new Date().getTime();
                                        const finalSrc = "${pageContext.request.contextPath}/image/avatar/" + newFileName + "?t=" + timestamp;

                                        // Cập nhật lại với link thật từ server
                                        document.querySelectorAll(".avatar-img").forEach(img => {
                                            img.src = finalSrc;
                                        });

                                        Swal.fire({
                                            icon: "success",
                                            title: "Đã lưu thành công!",
                                            text: "Ảnh đại diện đã được cập nhật vĩnh viễn.",
                                            timer: 2000,
                                            showConfirmButton: false
                                        });
                                    }).catch(err => {
                                        console.error("Lỗi upload avatar:", err);
                                        Swal.fire({
                                            icon: "error",
                                            title: "Lỗi lưu ảnh!",
                                            text: err.message,
                                            confirmButtonText: 'Đóng'
                                        });
                                    });
                                });
                            }
                        });


                    </script>
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const hasOrderDetail = ${ selectedOrder != null
                        };

                        const activeTab = "${activeTab}";

                        // ✅ LẤY PARAM tab TỪ URL
                        const urlParams = new URLSearchParams(window.location.search);
                        const tabParam = urlParams.get('tab');

                        // ✅ NẾU CÓ orderId HOẶC tab=orders → ACTIVE TAB ĐƠN MUA
                        if (hasOrderDetail || activeTab === "orders" || tabParam === "orders") {
                            document.querySelectorAll(".menu li").forEach(li => li.classList.remove("active"));
                            const ordersMenuItem = document.querySelector('[data-section="orders-section"]');
                            if (ordersMenuItem) {
                                ordersMenuItem.classList.add("active");
                            }

                            document.querySelectorAll(".section").forEach(sec => sec.classList.remove("active"));
                            const ordersSection = document.getElementById("orders-section");
                            if (ordersSection) {
                                ordersSection.classList.add("active");
                            }

                            // ✅ ẨN CHI TIẾT ĐƠN HÀNG, HIỆN DANH SÁCH
                            if (tabParam === "orders" && !hasOrderDetail) {
                                const orderList = document.getElementById("order-list");
                                const orderDetail = document.getElementById("order-detail");
                                if (orderList) orderList.style.display = "block";
                                if (orderDetail) orderDetail.style.display = "none";
                            }
                        }
    });
                    </script>

                    <script>
                        document.querySelectorAll(".order-tab").forEach(tab => {
                            tab.addEventListener("click", function () {
                                // Reset active class
                                document.querySelectorAll(".order-tab").forEach(t => t.classList.remove("active"));

                                // Set active class
                                this.classList.add("active");

                                const status = this.dataset.status;
                                const rows = document.querySelectorAll("#order-list tbody tr");
                                if (rows.length === 0) return;

                                rows.forEach(row => {
                                    const rowStatus = row.querySelector(".status-col")?.dataset.status;
                                    row.style.display = (rowStatus === status) ? "" : "none";
                                });
                            });
                        });

                        // click tab đầu tiên khi load
                        document.addEventListener("DOMContentLoaded", () => {
                            document.querySelector(".order-tab")?.click();
                        });
                    </script>


                    <script>
                        const menuItems = document.querySelectorAll(".menu li");
                        const sections = document.querySelectorAll(".section");

                        menuItems.forEach(item => {
                            item.addEventListener("click", function (e) {

                                const target = this.getAttribute("data-section");
                                if (!target) return;

                                e.preventDefault();

                                menuItems.forEach(i => i.classList.remove("active"));
                                this.classList.add("active");

                                sections.forEach(sec => sec.classList.remove("active"));
                                document.getElementById(target).classList.add("active");
                            });
                        });

                    </script>
                    <script>
                        // Gửi OTP bằng AJAX + Validate mật khẩu (Detailed)
                        document.getElementById("sendOtpBtn").addEventListener("click", function () {
                            const currentPass = document.getElementById("currentPassword").value;
                            const newPass = document.getElementById("newPassword").value;
                            const confirmPass = document.getElementById("confirmPassword").value;

                            let errors = [];

                            if (!currentPass || !newPass || !confirmPass) {
                                Swal.fire({ icon: 'warning', title: 'Thiếu thông tin', text: 'Vui lòng nhập đầy đủ các trường mật khẩu.' });
                                return;
                            }

                            // Chi tiết lỗi độ mạnh mật khẩu
                            if (newPass.length < 8) {
                                errors.push("Mật khẩu phải có ít nhất 8 ký tự.");
                            }
                            if (!/[A-Z]/.test(newPass)) {
                                errors.push("Mật khẩu phải chứa ít nhất 1 chữ hoa.");
                            }
                            if (!/[a-z]/.test(newPass)) {
                                errors.push("Mật khẩu phải chứa ít nhất 1 chữ thường.");
                            }
                            if (!/\d/.test(newPass)) {
                                errors.push("Mật khẩu phải chứa ít nhất 1 con số.");
                            }
                            if (!/[\W_]/.test(newPass)) {
                                errors.push("Mật khẩu phải chứa ít nhất 1 ký tự đặc biệt.");
                            }

                            if (newPass !== confirmPass) {
                                errors.push("Mật khẩu nhập lại không khớp.");
                            }

                            if (errors.length > 0) {
                                Swal.fire({
                                    icon: 'error',
                                    title: 'Lỗi xác thực',
                                    html: '<div style="text-align: left;">' + errors.map(err => '<p style="margin-bottom: 5px;">• ' + err + '</p>').join('') + '</div>',
                                    confirmButtonText: 'Đã hiểu'
                                });
                                return;
                            }

                            // Nếu OK -> Gửi OTP
                            fetch("SendOtpChangePassword", { method: "POST" })
                                .then(() => {
                                    // Hiển thị khung nhập OTP và đổi nút (Luồng cũ của người dùng)
                                    document.querySelector(".otp-group").style.display = "block";
                                    document.getElementById("sendOtpBtn").style.display = "none";
                                    document.getElementById("confirmChangeBtn").style.display = "inline-block";

                                    // Thông báo nhẹ nhàng không chặn luồng
                                    const Toast = Swal.mixin({
                                        toast: true,
                                        position: 'top-end',
                                        showConfirmButton: false,
                                        timer: 3000,
                                        timerProgressBar: true
                                    });
                                    Toast.fire({
                                        icon: 'success',
                                        title: 'Mã OTP đã được gửi đến email của bạn'
                                    });
                                })
                                .catch(error => {
                                    console.error("Lỗi gửi OTP:", error);
                                    Swal.fire({ icon: 'error', title: 'Lỗi', text: 'Không thể gửi mã OTP. Vui lòng thử lại sau.' });
                                });
                        });

                        // Xác nhận đổi mật khẩu
                        document.getElementById("confirmChangeBtn").addEventListener("click", function () {
                            const form = document.getElementById("passwordForm");
                            form.action = "ChangePassword";
                            form.submit();
                        });
                    </script>
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const btn = document.getElementById("toggleAddressFormBtn");
                            const formBox = document.getElementById("addAddressForm");

                            btn.addEventListener("click", function () {
                                const willShow = formBox.classList.contains("hidden");
                                formBox.classList.toggle("hidden");

                                // Đổi text nút cho rõ trạng thái
                                btn.textContent = willShow ? "Đóng" : "Thêm địa chỉ";

                                // Scroll nhẹ tới form khi mở
                                if (willShow) {
                                    formBox.scrollIntoView({ behavior: "smooth", block: "start" });
                                }
                            });

                            // Nếu vừa redirect về #addresses-section sau khi thêm, có thể mở form tự động khi có lỗi validate
                            const hasError =
                                document.querySelector(".error") &&
                                Array.from(document.querySelectorAll(".error")).some(e => e.textContent && e.textContent.trim() !== "");
                            if (hasError) {
                                formBox.classList.remove("hidden");
                                btn.textContent = "Đóng";
                            }
                        });
                    </script>
                    <script>
                        function toggleEditForm(id) {
                            const form = document.getElementById("editForm-" + id);
                            if (form.style.display === "none" || form.style.display === "") {
                                form.style.display = "block";
                            } else {
                                form.style.display = "none";
                            }
                        }
                    </script>


                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

                    <c:if test="${not empty error}">
                        <script>
                            document.addEventListener("DOMContentLoaded", function () {
                                Swal.fire({
                                    icon: "error",
                                    title: "Lỗi",
                                    text: "${error}",
                                    timer: 4000,
                                    showConfirmButton: false
                                });
                            });
                        </script>
                    </c:if>

                    <c:if test="${not empty success}">
                        <script>
                            document.addEventListener("DOMContentLoaded", function () {
                                Swal.fire({
                                    icon: "success",
                                    title: "Thành công",
                                    text: "${success}",
                                    timer: 4000,
                                    showConfirmButton: false
                                });
                            });
                        </script>
                    </c:if>

                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            const popup = document.getElementById("popup");
                            const openBtn = document.getElementById("openPopup");
                            const closeBtn = document.getElementById("closePopup");


                            openBtn.addEventListener("click", () => {
                                popup.classList.remove("hidden");
                            });

                            closeBtn.addEventListener("click", () => {
                                popup.classList.add("hidden");
                            });

                            popup.addEventListener("click", (e) => {
                                if (e.target === popup) {
                                    popup.classList.add("hidden");
                                }
                            });
                        });

                    </script>
                </body>

                </html>