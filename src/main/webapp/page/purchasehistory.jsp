<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Lịch sử mua hàng</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">

    <!-- CSS riêng -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/purchasehistory.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/common-category.css">
</head>
<body>

<!-- Include header -->
<jsp:include page="/page/header.jsp"/>

<div id="lich-su-mua-hang">
    <h2>Đơn hàng đã mua gần đây</h2>

    <table>
        <thead>
        <tr>
            <th>Mã đơn hàng</th>
            <th>Sản phẩm</th>
            <th>Giá</th>
            <th>Ngày đặt mua</th>
            <th>Trạng thái</th>
            <th>Thao tác</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="order" items="${orders}">
            <tr>
                <!-- Mã đơn -->
                <td>
                    <a href="#" class="ma-don">#${order.id}</a>
                </td>

                <!-- Sản phẩm -->
                <td>
                    <c:if test="${not empty order.items}">
                        <c:forEach var="item" items="${order.items}">
                            <div style="display:inline-block; margin:4px;">
                                <c:choose>
                                    <c:when test="${not empty item.product.mainImage}">
                                        <img src="${item.product.mainImage}"
                                             alt="${item.product.productName}"
                                             class="anh-san-pham"
                                             width="80"
                                             style="border-radius: 6px;">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/no-image.png"
                                             alt="No Image"
                                             class="anh-san-pham"
                                             width="80"
                                             style="border-radius: 6px;">
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:forEach>
                    </c:if>
                </td>



                <td class="gia">
                    <fmt:formatNumber value="${order.totalPrice}"
                                      type="currency"
                                      currencySymbol="₫"/>
                </td>

                <!-- Ngày đặt -->
                <td>
                    <fmt:formatDate value="${order.createdAt}"
                                    pattern="dd/MM/yyyy"/>
                </td>

                <td class="trang-thai">
                    <span class="status ${order.statusClass}">
                            ${order.statusLabel}
                    </span>
                </td>

                <td>
                    <a href="${pageContext.request.contextPath}/rebuy?orderId=${order.id}">
                        <button type="button" class="nut-mua-lai">
                            Mua lại
                        </button>
                    </a>
                </td>


            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>


</body>
<script>
    const btnDanhMuc = document.getElementById('btnDanhMuc');
    const menuLeft = document.getElementById('menuLeft');

    btnDanhMuc.addEventListener('click', () => {
        menuLeft.classList.toggle('show');
    });

    // Ẩn menu khi click ra ngoài
    document.addEventListener('click', (e) => {
        if (!menuLeft.contains(e.target) && !btnDanhMuc.contains(e.target)) {
            menuLeft.classList.remove('show');
        }
    });
</script>
</html>
