<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
            <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
                <!DOCTYPE html>
                <html lang="en">

                <head>
                    <meta charset="UTF-8">
                    <title>Thông tin giao hàng</title>

                    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
                        rel="stylesheet">
                    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
                        rel="stylesheet">
                    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/delivery-info.css">

                </head>

                <body>

                    <div class="wrap">
                        <!-- TRÁI -->
                        <div class="left">
                            <!-- Logo + breadcrumb -->
                            <div class="text-start mb-4">
                                <img src="${pageContext.request.contextPath}/image/dronefooter.png" alt="Logo"
                                    height="100">
                                <nav class="breadcrumb mt-2">
                                    <a href="http://localhost:8080/Nhom12LapTrinhWebFlycams/page/shoppingcart.jsp">Giỏ
                                        hàng</a> &nbsp;>&nbsp;
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
                                            <div class="avatar rounded-circle me-3">
                                                <img src="${pageContext.request.contextPath}/image/avatar/${sessionScope.user.avatar}"
                                                    alt="Avatar">
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div
                                                class="avatar rounded-circle d-flex justify-content-center align-items-center me-3">
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


                            <form id="checkoutForm" action="${pageContext.request.contextPath}/CheckoutServlet"
                                method="post">

                                <!-- Địa chỉ đã lưu -->
                                <div class="mb-3">
                                    <select id="savedAddress" name="savedAddress" class="form-select">
                                        <option value="">Thêm địa chỉ mới...</option>

                                        <c:forEach items="${addresses}" var="a">
                                            <option value="${a.id}" data-name="${a.fullName}"
                                                data-phone="${a.phoneNumber}" data-address="${a.addressLine}"
                                                data-province="${a.province}" data-district="${a.district}"
                                                ${a.defaultAddress ? "selected" : "" }>
                                                ${a.phoneNumber}, ${a.addressLine}, ${a.province}, ${a.district}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Container cho các trường nhập liệu -->
                                <div id="manualInputFields">
                                    <!-- Họ tên -->
                                    <div class="mb-3">
                                        <input id="fullName" type="text" name="fullName" class="form-control"
                                            placeholder="Họ và tên" required>
                                    </div>

                                    <!-- Số điện thoại -->
                                    <div class="mb-3">
                                        <input id="phoneNumber" type="tel" name="phone" class="form-control"
                                            placeholder="Số điện thoại" required>
                                    </div>

                                    <!-- Địa chỉ cụ thể -->
                                    <div class="mb-3">
                                        <input id="addressLine" type="text" name="address" class="form-control"
                                            placeholder="Địa chỉ cụ thể (Số nhà, đường...)" required>
                                    </div>

                                    <!-- Tỉnh / xã -->
                                    <!-- Tỉnh / Quận / Phường -->
                                    <div class="address-select-group">
                                        <select name="province" id="province" class="form-select mb-2" required>
                                            <option value="">-- Chọn Tỉnh/Thành phố --</option>
                                        </select>

                                        <select name="district" id="district" class="form-select mb-2" required
                                            disabled>
                                            <option value="">-- Chọn Quận/Huyện --</option>
                                        </select>

                                        <select name="ward" id="ward" class="form-select mb-2" required disabled>
                                            <option value="">-- Chọn Phường/Xã --</option>
                                        </select>
                                    </div>

                                    <!-- Hidden inputs để lưu id/code gửi về server -->
                                    <input type="hidden" name="districtId" id="districtIdInput">
                                    <input type="hidden" name="wardCode" id="wardCodeInput">
                                </div>

                                <!-- Ghi chú -->
                                <div class="mt-3">
                                    <textarea name="note" rows="5" class="form-control"
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
                                        <img src="${item.product.images[0].imageUrl}" width="60" class="me-3 prod-img">

                                        <div>
                                            <p class="mb-0 fw-semibold">
                                                ${item.product.productName}
                                            </p>
                                            <small class="text-muted">
                                                Số lượng: ${item.quantity}
                                            </small>
                                        </div>

                                        <span class="ms-auto fw-semibold">
                                            <fmt:formatNumber value="${item.price * item.quantity}" type="number" /> ₫
                                        </span>
                                    </div>

                                    <!-- cộng dồn -->
                                    <c:set var="total" value="${total + (item.price * item.quantity)}" />
                                </c:forEach>

                                <div class="d-flex justify-content-between">
                                    <span>Tạm tính</span>
                                    <span>
                                        <fmt:formatNumber value="${total}" type="number" /> ₫
                                    </span>
                                </div>

                                <div class="d-flex justify-content-between mb-2">
                                    <span>Phí vận chuyển</span>
                                    <span id="shippingFeeText">—</span>
                                </div>

                                <hr>

                                <div class="d-flex justify-content-between fw-bold total">
                                    <span>Tổng cộng</span>
                                    <span id="finalTotalText">
                                        <fmt:formatNumber value="${total}" type="number" /> ₫
                                    </span>
                                </div>
                            </c:if>
                        </div>

                    </div>

                    <script>
                        // ================ GHN API ================
                        const API_PROVINCE = "${pageContext.request.contextPath}/api/ghn/province";
                        const API_DISTRICT = "${pageContext.request.contextPath}/api/ghn/district";
                        const API_WARD = "${pageContext.request.contextPath}/api/ghn/ward";
                        const API_FEE = "${pageContext.request.contextPath}/api/ghn/fee";

                        const provinceSelect = document.getElementById("province");
                        const districtSelect = document.getElementById("district");
                        const wardSelect = document.getElementById("ward");

                        const savedAddressSelect = document.getElementById("savedAddress");
                        const fullNameInput = document.getElementById("fullName");
                        const phoneInput = document.getElementById("phoneNumber");
                        const addressInput = document.getElementById("addressLine");
                        const manualInputFields = document.getElementById("manualInputFields");

                        const districtIdInput = document.getElementById("districtIdInput");
                        const wardCodeInput = document.getElementById("wardCodeInput");

                        const shippingFeeText = document.getElementById("shippingFeeText");
                        const finalTotalText = document.getElementById("finalTotalText");

                        let baseTotal = Number("${empty total ? 0 : total}");

                        let provincesLoaded = false;

                        // Load Provinces
                        fetch(API_PROVINCE)
                            .then(res => res.json())
                            .then(data => {
                                if (data.code === 200) {
                                    data.data.forEach(p => {
                                        const opt = document.createElement("option");
                                        opt.value = p.ProvinceName;
                                        opt.textContent = p.ProvinceName;
                                        opt.dataset.id = p.ProvinceID;
                                        provinceSelect.appendChild(opt);
                                    });
                                    provincesLoaded = true;

                                    if (savedAddressSelect.value) {
                                        savedAddressSelect.dispatchEvent(new Event('change'));
                                    }
                                }
                            }).catch(err => console.error(err));

                        // Change Province -> Load Districts
                        provinceSelect.addEventListener("change", function () {
                            const selectedOption = this.options[this.selectedIndex];
                            const provId = selectedOption.dataset.id;

                            districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
                            districtSelect.disabled = true;
                            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                            wardSelect.disabled = true;

                            districtIdInput.value = '';
                            wardCodeInput.value = '';
                            updateShippingFee(0);

                            if (!provId) return;

                            fetch(API_DISTRICT + "?province_id=" + provId)
                                .then(res => res.json())
                                .then(data => {
                                    if (data.code === 200) {
                                        data.data.forEach(d => {
                                            const opt = document.createElement("option");
                                            opt.value = d.DistrictName;
                                            opt.textContent = d.DistrictName;
                                            opt.dataset.id = d.DistrictID;
                                            districtSelect.appendChild(opt);
                                        });
                                        districtSelect.disabled = false;
                                    }
                                }).catch(err => console.error(err));
                        });

                        // Change District -> Load Wards
                        districtSelect.addEventListener("change", function () {
                            const selectedOption = this.options[this.selectedIndex];
                            const distId = selectedOption.dataset.id;
                            districtIdInput.value = distId || '';

                            wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                            wardSelect.disabled = true;
                            wardCodeInput.value = '';
                            updateShippingFee(0);

                            if (!distId) return;

                            fetch(API_WARD + "?district_id=" + distId)
                                .then(res => res.json())
                                .then(data => {
                                    if (data.code === 200 && data.data) {
                                        data.data.forEach(w => {
                                            const opt = document.createElement("option");
                                            opt.value = w.WardName;
                                            opt.textContent = w.WardName;
                                            opt.dataset.code = w.WardCode;
                                            wardSelect.appendChild(opt);
                                        });
                                        wardSelect.disabled = false;
                                    }
                                }).catch(err => console.error(err));
                        });

                        // Change Ward -> Calculate Fee
                        wardSelect.addEventListener("change", function () {
                            const selectedOption = this.options[this.selectedIndex];
                            wardCodeInput.value = selectedOption.dataset.code || '';
                            calculateFee();
                        });

                        function calculateFee() {
                            const distId = districtIdInput.value;
                            const wardCode = wardCodeInput.value;
                            if (distId && wardCode) {
                                shippingFeeText.innerText = 'Đang tính...';

                                fetch(API_FEE, {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/json' },
                                    body: JSON.stringify({
                                        service_type_id: 2,
                                        to_district_id: parseInt(distId),
                                        to_ward_code: wardCode,
                                        weight: 1000,
                                        length: 10, width: 10, height: 10
                                    })
                                }).then(res => res.json()).then(data => {
                                    if (data.code === 200 && data.data && data.data.total) {
                                        updateShippingFee(data.data.total);
                                    } else {
                                        updateShippingFee(30000); // fallback
                                    }
                                }).catch(() => updateShippingFee(30000));
                            } else {
                                updateShippingFee(0);
                            }
                        }

                        function updateShippingFee(fee) {
                            if (fee > 0) {
                                shippingFeeText.innerText = Number(fee).toLocaleString('vi-VN') + ' ₫';
                                finalTotalText.innerText = Number(baseTotal + fee).toLocaleString('vi-VN') + ' ₫';
                            } else {
                                shippingFeeText.innerText = '—';
                                finalTotalText.innerText = Number(baseTotal).toLocaleString('vi-VN') + ' ₫';
                            }
                        }

                        function toggleRequiredFields(isRequired) {
                            const fields = manualInputFields.querySelectorAll('input:not([type="hidden"]), select');
                            fields.forEach(field => isRequired ? field.setAttribute('required', 'required') : field.removeAttribute('required'));
                        }

                        // Saved address change logic (simplified for GHN)
                        savedAddressSelect.addEventListener("change", function () {
                            const opt = this.options[this.selectedIndex];

                            if (!opt.value) {
                                fullNameInput.value = "";
                                phoneInput.value = "";
                                addressInput.value = "";
                                provinceSelect.value = "";
                                districtSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
                                districtSelect.disabled = true;
                                wardSelect.innerHTML = '<option value="">-- Chọn Phường/Xã --</option>';
                                wardSelect.disabled = true;
                                districtIdInput.value = '';
                                wardCodeInput.value = '';
                                toggleRequiredFields(true);
                                updateShippingFee(0);
                                return;
                            }

                            fullNameInput.value = opt.dataset.name || "";
                            phoneInput.value = opt.dataset.phone || "";
                            addressInput.value = opt.dataset.address || "";

                            const provinceName = opt.dataset.province || "";
                            const savedDistrict = opt.dataset.district || ""; // "Quận 1, Phường Bến Nghé"

                            // This is a naive split based on the new logic where district format might be "District, Ward"
                            let destDistrict = savedDistrict;
                            let destWard = "";
                            if (savedDistrict.includes(", ")) {
                                let parts = savedDistrict.split(", ");
                                destDistrict = parts[0];
                                destWard = parts[1] || "";
                            }

                            if (provinceName && provincesLoaded) {
                                // Find province
                                let foundProv = false;
                                for (let i = 0; i < provinceSelect.options.length; i++) {
                                    if (provinceSelect.options[i].value.includes(provinceName) || provinceName.includes(provinceSelect.options[i].value)) {
                                        provinceSelect.selectedIndex = i;
                                        foundProv = true;
                                        break;
                                    }
                                }

                                if (foundProv) {
                                    // To keep it simple, we just pretend the user didn't select for old addresses and let them re-select if we can't match accurately.
                                    // An ideal script would fetch districts, find district, select it, fetch wards, find ward, select it...
                                    // But old addresses lack IDs.
                                    provinceSelect.dispatchEvent(new Event("change"));
                                }
                            }

                            toggleRequiredFields(false);
                        });

                        window.addEventListener('DOMContentLoaded', function () {
                            console.log("🚀 GHN Checkout Page loaded");
                        });
                    </script>
                </body>

                </html>