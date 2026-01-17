<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Thông tin giao hàng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/delivery-info.css">

</head>
<body>

<div class="wrap">
    <!-- TRÁI -->
    <div class="left">
        <!-- Logo + breadcrumb -->
        <div class="text-start mb-4">
            <img src="${pageContext.request.contextPath}/image/dronefooter.png" alt="Logo" height="100">
            <nav class="breadcrumb mt-2">
                <a href="shoppingcart.jsp">Giỏ hàng</a> &nbsp;>&nbsp;
                <span class="current">Thông tin giao hàng</span> &nbsp;>&nbsp;
                <a href="#">Phương thức thanh toán</a>
            </nav>
        </div>

        <h5 class="mb-4 fw-bold">Thông tin giao hàng</h5>

        <!-- Tài khoản -->
        <c:if test="${not empty sessionScope.user}">
            <div class="d-flex align-items-center mb-3">
                <c:choose>
                    <c:when test="${not empty sessionScope.user.avatar}">
                        <!-- Avatar code here -->
                    </c:when>
                    <c:otherwise>
                        <div class="avatar rounded-circle d-flex justify-content-center align-items-center me-3">
                            <i class="bi bi-person fs-3 text-secondary"></i>
                        </div>
                    </c:otherwise>
                </c:choose>

                <div>
                    <p class="mb-0 fw-semibold">${sessionScope.user.fullName}</p>
                    <small>${sessionScope.user.email}</small><br>
                </div>
            </div>
        </c:if>


        <form id="checkoutForm"
              action="${pageContext.request.contextPath}/CheckoutServlet"
              method="post">

            <!-- Địa chỉ đã lưu -->
            <div class="mb-3">
                <select id="savedAddress" name="savedAddress" class="form-select">
                    <option value="">Thêm địa chỉ mới...</option>

                    <c:forEach items="${addresses}" var="a">
                        <option
                                value="${a.id}"
                                data-name="${a.fullName}"
                                data-phone="${a.phoneNumber}"
                                data-address="${a.addressLine}"
                                data-province="${a.province}"
                                data-district="${a.district}"
                            ${a.defaultAddress ? "selected" : ""}
                        >
                                ${a.phoneNumber}, ${a.addressLine}, ${a.district}, ${a.province}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <!-- Container cho các trường nhập liệu -->
            <div id="manualInputFields">
                <!-- Họ tên -->
                <div class="mb-3">
                    <input id="fullName" type="text"
                           name="fullName"
                           class="form-control"
                           placeholder="Họ và tên"
                           required>
                </div>

                <!-- Số điện thoại -->
                <div class="mb-3">
                    <input id="phoneNumber" type="tel"
                           name="phone"
                           class="form-control"
                           placeholder="Số điện thoại"
                           required>
                </div>

                <!-- Địa chỉ cụ thể -->
                <div class="mb-3">
                    <input id="addressLine" type="text"
                           name="address"
                           class="form-control"
                           placeholder="Địa chỉ cụ thể (Số nhà, đường...)"
                           required>
                </div>

                <!-- Tỉnh / xã -->
                <div class="address-select-group">
                    <select name="province" id="province" class="form-select" required>
                        <option value="">-- Chọn Tỉnh/Thành phố --</option>
                    </select>

                    <select name="ward" id="ward" class="form-select" required>
                        <option value="">-- Chọn Phường/Xã --</option>
                    </select>
                </div>
            </div>

            <!-- Ghi chú -->
            <div class="mt-3">
        <textarea name="note"
                  rows="5"
                  class="form-control"
                  placeholder="Nhập ghi chú của bạn..."></textarea>
            </div>

            <!-- Submit -->
            <button type="submit" class="btn btn-primary w-100 mt-3">
                Tiếp tục đến phương thức thanh toán
            </button>

        </form>
    </div>

    <!-- PHẢI -->
    <c:set var="items" value="${sessionScope.BUY_NOW_ITEM}" />
    <div class="right">
        <h5 class="fw-bold mb-4">Đơn hàng của bạn</h5>

        <c:if test="${not empty items}">
            <c:set var="total" value="0" />

            <c:forEach var="item" items="${items}">
                <div class="d-flex align-items-center mb-3">
                    <img src="${item.product.images[0].imageUrl}"
                         width="60" class="me-3 prod-img">

                    <div>
                        <p class="mb-0 fw-semibold">
                                ${item.product.productName}
                        </p>
                        <small class="text-muted">
                            Số lượng: ${item.quantity}
                        </small>
                    </div>

                    <span class="ms-auto fw-semibold">
                    <fmt:formatNumber
                            value="${item.price * item.quantity}"
                            type="number"/> ₫
                </span>
                </div>

                <!-- cộng dồn -->
                <c:set var="total"
                       value="${total + (item.price * item.quantity)}"/>
            </c:forEach>

            <div class="d-flex justify-content-between">
                <span>Tạm tính</span>
                <span>
                <fmt:formatNumber value="${total}" type="number"/> ₫
            </span>
            </div>

            <div class="d-flex justify-content-between mb-2">
                <span>Phí vận chuyển</span>
                <span>—</span>
            </div>

            <hr>

            <div class="d-flex justify-content-between fw-bold total">
                <span>Tổng cộng</span>
                <span>
                <fmt:formatNumber value="${total}" type="number"/> ₫
            </span>
            </div>
        </c:if>
    </div>

</div>

<script>
    const data = {
        "TP. Hồ Chí Minh": {
            "Quận 1": ["Phường Bến Nghé", "Phường Bến Thành", "Phường Nguyễn Thái Bình"],
            "Quận Bình Thạnh": ["Phường 1", "Phường 2", "Phường 3"]
        },
        "Cà Mau": {
            "TP. Cà Mau": ["Phường 1", "Phường 2", "Phường 4"],
            "Huyện Trần Văn Thời": ["Xã Trần Hợi", "Xã Khánh Bình", "Xã Khánh Hải"]
        },
        "Hà Nội": {
            "Quận Ba Đình": ["Phường Điện Biên", "Phường Kim Mã", "Phường Ngọc Hà"],
            "Quận Cầu Giấy": ["Phường Dịch Vọng", "Phường Nghĩa Tân"]
        }
    };

    const province = document.getElementById("province");
    const ward = document.getElementById("ward");
    const savedAddressSelect = document.getElementById("savedAddress");
    const fullNameInput = document.getElementById("fullName");
    const phoneInput = document.getElementById("phoneNumber");
    const addressInput = document.getElementById("addressLine");
    const manualInputFields = document.getElementById("manualInputFields");

    // Nạp danh sách tỉnh
    for (let p in data) {
        const opt = document.createElement("option");
        opt.value = p;
        opt.textContent = p;
        province.appendChild(opt);
    }

    // ========================================
    // HÀM BẬT/TẮT REQUIRED CHO CÁC TRƯỜNG
    // ========================================
    function toggleRequiredFields(isRequired) {
        const fields = manualInputFields.querySelectorAll('input, select');
        fields.forEach(field => {
            if (isRequired) {
                field.setAttribute('required', 'required');
            } else {
                field.removeAttribute('required');
            }
        });
    }

    // ========================================
    // KHI CHỌN ĐỊA CHỈ ĐÃ LƯU
    // ========================================
    savedAddressSelect.addEventListener("change", function () {
        const opt = this.options[this.selectedIndex];

        if (!opt.value) {
            // Chọn "Thêm địa chỉ mới" - BẮT BUỘC NHẬP
            fullNameInput.value = "";
            phoneInput.value = "";
            addressInput.value = "";
            province.value = "";
            ward.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';

            // Bật lại required
            toggleRequiredFields(true);
            manualInputFields.style.opacity = "1";

            return;
        }

        // Có chọn địa chỉ đã lưu - KHÔNG BẮT BUỘC NHẬP
        fullNameInput.value = opt.dataset.name || "";
        phoneInput.value = opt.dataset.phone || "";
        addressInput.value = opt.dataset.address || "";
        province.value = opt.dataset.province || "";

        // Tải phường/xã nếu có
        if (opt.dataset.district && data[opt.dataset.province]) {
            ward.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
            const districts = data[opt.dataset.province][opt.dataset.district];
            if (districts) {
                districts.forEach(w => {
                    const wardOpt = document.createElement("option");
                    wardOpt.value = w;
                    wardOpt.textContent = w;
                    ward.appendChild(wardOpt);
                });
            }
        }

        // Tắt required vì đã có địa chỉ
        toggleRequiredFields(false);

        // Làm mờ các trường (tùy chọn - để người dùng biết không cần điền)
        manualInputFields.style.opacity = "0.6";
    });

    // Khi chọn tỉnh
    province.addEventListener("change", () => {
        ward.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
        ward.disabled = true;

        const p = province.value;
        if (!p) return;

        // Nạp danh sách phường/xã
        const allWards = new Set();
        for (let d in data[p]) {
            data[p][d].forEach(w => allWards.add(w));
        }

        allWards.forEach(w => {
            const opt = document.createElement("option");
            opt.value = w;
            opt.textContent = w;
            ward.appendChild(opt);
        });

        ward.disabled = false;
    });

    // ========================================
    // KIỂM TRA KHI LOAD TRANG
    // ========================================
    window.addEventListener('DOMContentLoaded', function() {
        // Nếu có địa chỉ mặc định được chọn sẵn
        if (savedAddressSelect.value) {
            savedAddressSelect.dispatchEvent(new Event('change'));
        }
    });
</script>
</body>
</html>