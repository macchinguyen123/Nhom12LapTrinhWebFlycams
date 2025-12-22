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
    <link rel="stylesheet" href="../stylesheets/delivery-info.css">

</head>
<body>

<div class="wrap">
    <!-- TRÁI -->
    <div class="left">
        <!-- Logo + breadcrumb -->
        <div class="text-start mb-4">
            <img src="../image/dronefooter.png" alt="Logo" height="100">
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
            <div class="avatar rounded-circle d-flex justify-content-center align-items-center me-3">
                <i class="bi bi-person fs-3 text-secondary"></i>
            </div>
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
                <select id="savedAddress" class="form-select">
                    <option value="">Thêm địa chỉ mới...</option>
                    <option>0948088315, 70000, Việt Nam</option>
                    <option>0948088315, Xã Trần Hợi, Huyện Trần Văn Thời, Cà Mau</option>
                </select>
            </div>

            <!-- Họ tên -->
            <div class="mb-3">
                <input type="text"
                       name="fullName"
                       class="form-control"
                       placeholder="Họ và tên"
                       required>
            </div>

            <!-- Số điện thoại -->
            <div class="mb-3">
                <input type="tel"
                       name="phone"
                       class="form-control"
                       placeholder="Số điện thoại"
                       required>
            </div>

            <!-- Địa chỉ cụ thể -->
            <div class="mb-3">
                <input type="text"
                       name="address"
                       class="form-control"
                       placeholder="Địa chỉ cụ thể (Số nhà, đường...)"
                       required>
            </div>

            <!-- Tỉnh / xã -->
            <div class="address-select-group">
                <select name="province" id="province" class="form-select">
                    <option value="">-- Chọn Tỉnh/Thành phố --</option>
                </select>

                <select name="ward" id="ward" class="form-select">
                    <option value="">-- Chọn Phường/Xã --</option>
                </select>
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
    const district = document.getElementById("district");
    const ward = document.getElementById("ward");

    // Nạp danh sách tỉnh
    for (let p in data) {
        const opt = document.createElement("option");
        opt.value = p;
        opt.textContent = p;
        province.appendChild(opt);
    }

    // Khi chọn tỉnh
    province.addEventListener("change", () => {
        district.innerHTML = '<option value="">Chọn quận / huyện</option>';
        ward.innerHTML = '<option value="">Chọn phường / xã</option>';
        district.disabled = true;
        ward.disabled = true;

        const p = province.value;
        if (!p) return;

        for (let d in data[p]) {
            const opt = document.createElement("option");
            opt.value = d;
            opt.textContent = d;
            district.appendChild(opt);
        }
        district.disabled = false;
    });

    // Khi chọn huyện
    district.addEventListener("change", () => {
        ward.innerHTML = '<option value="">Chọn phường / xã</option>';
        ward.disabled = true;

        const p = province.value;
        const d = district.value;
        if (!d) return;

        data[p][d].forEach(w => {
            const opt = document.createElement("option");
            opt.value = w;
            opt.textContent = w;
            ward.appendChild(opt);
        });
        ward.disabled = false;
    });

    // 🟢 DỮ LIỆU ĐỊA CHỈ LƯU TRỮ
    const savedAddresses = {
        "0948088315, 70000, Việt Nam": {
            name: "Mạc Chí Nguyên",
            phone: "0948088315",
            address: "70000",
            province: "TP. Hồ Chí Minh",
            district: "Quận 1",
            ward: "Phường Bến Nghé"
        },
        "0948088315, Xã Trần Hợi, Huyện Trần Văn Thời, Cà Mau": {
            name: "Mạc Chí Nguyên",
            phone: "0948088315",
            address: "Xã Trần Hợi",
            province: "Cà Mau",
            district: "Huyện Trần Văn Thời",
            ward: "Xã Trần Hợi"
        }
    };

    // 🟡 Khi chọn "địa chỉ đã lưu"
    const savedAddressSelect = document.getElementById("savedAddress");
    const nameInput = document.querySelector('input[placeholder="Họ và tên"]');
    const phoneInput = document.querySelector('input[placeholder="Số điện thoại"]');
    const addressInput = document.querySelector('input[placeholder="Địa chỉ cụ thể (Số nhà, đường...)"]');

    savedAddressSelect.addEventListener("change", () => {
        const selected = savedAddressSelect.value;
        if (!selected || !savedAddresses[selected]) {
            nameInput.value = "";
            phoneInput.value = "";
            addressInput.value = "";
            province.value = "";
            district.innerHTML = '<option value="">Chọn quận / huyện</option>';
            ward.innerHTML = '<option value="">Chọn phường / xã</option>';
            district.disabled = true;
            ward.disabled = true;
            return;
        }

        const info = savedAddresses[selected];
        nameInput.value = info.name;
        phoneInput.value = info.phone;
        addressInput.value = info.address;
        province.value = info.province;

        // Tải lại huyện
        district.innerHTML = '<option value="">Chọn quận / huyện</option>';
        for (let d in data[info.province]) {
            const opt = document.createElement("option");
            opt.value = d;
            opt.textContent = d;
            district.appendChild(opt);
        }
        district.disabled = false;
        district.value = info.district;

        // Tải lại xã
        ward.innerHTML = '<option value="">Chọn phường / xã</option>';
        data[info.province][info.district].forEach(w => {
            const opt = document.createElement("option");
            opt.value = w;
            opt.textContent = w;
            ward.appendChild(opt);
        });
        ward.disabled = false;
        ward.value = info.ward;
    });
</script>

</body>
</html>
