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
            <img src="${pageContext.request.contextPath}/image/logooo.png"
                 alt="SKYDRONE Logo" class="mascot">
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
                    <input type="password" class="form-control" name="password"
                           placeholder="Nhập mật khẩu" required>
                </div>

                <button type="submit" class="btn btn-login w-100 mb-3">
                    Đăng nhập
                </button>

                <div class="text-end">
                    <a href="forgot-password.jsp" class="forgot-pass">Quên mật khẩu?</a>
                </div>

                <div class="divider text-center my-3">Hoặc đăng nhập bằng</div>

                <div class="d-flex justify-content-center">
                    <button type="button" class="btn btn-outline-secondary">
                        <img src="https://www.svgrepo.com/show/355037/google.svg" width="20" class="me-2">
                        Google
                    </button>
                </div>

                <p class="text-center mt-3">
                    Bạn chưa có tài khoản?
                    <a href="register.jsp">Đăng ký ngay</a>
                </p>
            </form>

            <!-- Hiển thị lỗi bằng JSTL -->
            <c:if test="${not empty error}">
                <div class="alert alert-danger mt-3 text-center">
                        ${error}
                </div>
            </c:if>

        </div>

    </div>
</div>

</body>

<%--<script>--%>
<%--    // ==============================--%>
<%--    // TÀI KHOẢN MẪU DEMO--%>
<%--    // ==============================--%>
<%--    const accounts = [--%>
<%--        {role: "admin", email: "admin@example.com", phone: "0987654321", password: "123"},--%>
<%--        {role: "user", email: "user@example.com", phone: "1234567890", password: "123"}--%>
<%--    ];--%>

<%--    // ==============================--%>
<%--    // XỬ LÝ ĐĂNG NHẬP--%>
<%--    // ==============================--%>
<%--    document.getElementById("loginForm").addEventListener("submit", function (e) {--%>
<%--        e.preventDefault();--%>

<%--        const input = document.getElementById("loginInput").value.trim();--%>
<%--        const password = document.getElementById("password").value;--%>

<%--        const found = accounts.find(acc =>--%>
<%--            (acc.email === input || acc.phone === input) && acc.password === password--%>
<%--        );--%>

<%--        if (!found) {--%>
<%--            alert("Sai thông tin đăng nhập!");--%>
<%--            return;--%>
<%--        }--%>

<%--        if (found.role === "admin") {--%>
<%--            // đường dẫn tương đối so với login.jsp--%>
<%--            window.location.href = "admin/dashboard.jsp";--%>
<%--        } else {--%>
<%--            window.location.href = "homepage.html";--%>
<%--        }--%>
<%--    });--%>
<%--</script>--%>
</html>
