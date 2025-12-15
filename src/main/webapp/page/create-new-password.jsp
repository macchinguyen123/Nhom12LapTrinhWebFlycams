<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Trang tạo mật khẩu mới</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/create-new-password.css">

</head>
<body>
<div class="khung">
    <img src="../image/logoo.png" alt="SKYDRONE Logo" class="mascot">

    <h1 id="title">Tạo mật khẩu mới</h1>
    <form action="${pageContext.request.contextPath}/ResetPassword" method="post">
        <label for="password">Mật khẩu mới</label>
        <input type="password" id="password" name="password" required>
        <c:if test="${not empty passwordError}">
            <div class="error">${passwordError}</div>
        </c:if>

        <label for="confirm">Nhập lại mật khẩu</label>
        <input type="password" id="confirm" name="confirm" required>
        <c:if test="${not empty confirmPasswordError}">
            <div class="error">${confirmPasswordError}</div>
        </c:if>

        <button type="submit">Cập nhật mật khẩu</button>
    </form>


</div>


</body>
</html>
