<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Đăng nhập SKYDRONE</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/login.css">
</head>

<body>

<div class="page-container">
    <div class="login-wrapper">

        <div class="logo-section">
            <img src="${pageContext.request.contextPath}/image/logooo.png" alt="SKYDRONE Logo"
                 class="mascot">
        </div>

        <div class="login-container">
            <h2>Đăng nhập SKYDRONE</h2>

            <!-- FORM -->
            <form action="${pageContext.request.contextPath}/Login" method="post">

                <div class="mb-3 text-start">
                    <label class="form-label">Số điện thoại / Email</label>
                    <input type="text" class="form-control" name="loginInput"
                           placeholder="Nhập số điện thoại hoặc email" required>
                </div>

                <div class="mb-3 text-start">
                    <label class="form-label">Mật khẩu</label>
                    <input type="password" class="form-control" name="password" placeholder="Nhập mật khẩu"
                           required>
                </div>

                <button type="submit" class="btn btn-login w-100 mb-3">
                    Đăng nhập
                </button>

                <div class="text-end">
                    <a href="${pageContext.request.contextPath}/page/forgot-password.jsp"
                       class="forgot-pass">
                        Quên mật khẩu?
                    </a>
                </div>

                <div class="divider text-center my-3">Hoặc đăng nhập bằng</div>

                <div class="d-flex justify-content-center">
                    <a href="${pageContext.request.contextPath}/google-login"
                       class="btn btn-outline-secondary d-flex align-items-center justify-content-center">
                        <img src="https://www.svgrepo.com/show/355037/google.svg" width="20" class="me-2">
                        Google
                    </a>

                </div>

                <p class="text-center mt-3">
                    Bạn chưa có tài khoản?
                    <a href="${pageContext.request.contextPath}/Register">Đăng ký ngay</a>
                </p>
            </form>

        </div>

    </div>
</div>

<!-- SweetAlert2 -->
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<c:if test="${not empty error}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const Toast = Swal.mixin({
                toast: true,
                position: "top-end",
                showConfirmButton: false,
                timer: 4000,
                timerProgressBar: true,
                background: "#fff6f6",
                color: "#d00000",
                customClass: {popup: 'custom-toast'}
            });

            Toast.fire({
                icon: "error",
                html: `${error}`
            });
        });
    </script>
</c:if>

<c:if test="${param.resetSuccess eq '1'}">
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const Toast = Swal.mixin({
                toast: true,
                position: "top-end",
                showConfirmButton: false,
                timer: 4000,
                timerProgressBar: true,
                background: "#f0fdf4",
                color: "#15803d",
                customClass: {popup: 'custom-toast'}
            });

            Toast.fire({
                icon: "success",
                title: "Tạo mật khẩu mới thành công!",
                text: "Vui lòng đăng nhập lại."
            });
        });
    </script>
</c:if>


</body>

</html>