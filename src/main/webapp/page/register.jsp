<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Đăng ký trở thành SMEMBER</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/register.css">
    <style>
        .error {
            color: red;
        }
    </style>

</head>

<body>

<div class="container">
    <h1 class="title">Đăng ký trở thành <span>SKYDroneMember</span></h1>

    <img src="${pageContext.request.contextPath}/image/logoo.png" alt="Logo" class="mascot">


    <p class="subtitle">Đăng ký bằng tài khoản mạng xã hội</p>
    <div class="social-buttons">
        <div class="d-flex justify-content-center social-login">
            <a href="${pageContext.request.contextPath}/google-register"
               class="social-btn d-flex align-items-center justify-content-center">
                <img src="https://www.svgrepo.com/show/355037/google.svg" width="20" class="me-2">
                Đăng ký bằng Google
            </a>
        </div>
    </div>

    <p class="or">Hoặc điền thông tin sau</p>

    <form class="register-form" method="POST" action="${pageContext.request.contextPath}/Register">

        <!-- Tên đăng nhập -->
        <div class="field">
            <h2>Tên đăng nhập</h2>
            <input type="text" id="local" name="username" placeholder="Nhập tên đăng nhập"
                   value="${username}" required>
            <c:if test="${not empty usernameError}">
                <p class="error">⚠ ${usernameError}</p>
            </c:if>

        </div>

        <h2>Thông tin cá nhân</h2>
        <div class="grid">
            <div class="field">
                <label for="fullname">Họ và tên</label>
                <input type="text" id="fullname" name="fullName" placeholder="Nhập họ và tên"
                       value="${fullName}" required>
                <c:if test="${not empty fullNameError}">
                    <p class="error">⚠ ${fullNameError}</p>
                </c:if>

            </div>

            <div class="field">
                <label for="birthday">Ngày sinh</label>
                <input type="date" id="birthday" name="birthday" value="${birthday}" required>
                <c:if test="${not empty birthdayError}">
                    <p class="error">⚠ ${birthdayError}</p>
                </c:if>

            </div>

            <div class="field">
                <label for="phone">Số điện thoại</label>
                <input type="tel" id="phone" name="phoneNumber" placeholder="Nhập số điện thoại"
                       value="${phoneNumber}" required>
                <c:if test="${not empty phoneError}">
                    <p class="error">⚠ ${phoneError}</p>
                </c:if>

            </div>

            <div class="field">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="Nhập email" value="${email}">
                <p class="hint">✔ Hóa đơn VAT sẽ gửi qua email này</p>

                <c:if test="${not empty emailError}">
                    <p class="error">⚠ ${emailError}</p>
                </c:if>

            </div>
        </div>

        <h2>Tạo mật khẩu</h2>
        <div class="grid">
            <div class="field">
                <label for="password">Mật khẩu</label>
                <input type="password" id="password" name="password" placeholder="Nhập mật khẩu" required>
                <p class="hint">Mật khẩu tối thiểu 6 ký tự, có ít nhất 1 chữ số và 1 chữ cái</p>

                <c:if test="${not empty passwordError}">
                    <p class="error">⚠ ${passwordError}</p>
                </c:if>

            </div>

            <div class="field">
                <label for="confirm">Nhập lại mật khẩu</label>
                <input type="password" id="confirm" name="confirm" placeholder="Nhập lại mật khẩu" required>
                <c:if test="${not empty confirmPasswordError}">
                    <p class="error">⚠ ${confirmPasswordError}</p>
                </c:if>

            </div>
        </div>

        <div class="checkbox">
            <input type="checkbox" id="promo" name="promo" required>
            <label for="promo">Tôi đồng ý với điều khoản và chính sách của SKYDRONE</label>
        </div>

        <p class="terms">
            Bằng việc Đăng ký, bạn đã đồng ý với
            <a href="${pageContext.request.contextPath}/page/terms-of-use.jsp">Điều khoản sử dụng</a> và
            <a href="${pageContext.request.contextPath}/page/privacy-policy.jsp">Chính sách bảo mật</a>.
        </p>

        <div class="actions">
            <a href="${pageContext.request.contextPath}/Login" class="btn secondary">⟵ Quay lại đăng
                nhập</a>
            <button type="submit" class="btn primary">Hoàn tất đăng ký</button>
        </div>
    </form>
</div>

</body>

</html>