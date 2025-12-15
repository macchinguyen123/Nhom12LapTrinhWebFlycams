<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Nhập mã OTP</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/stylesheets/otp.css">
</head>
<body>

<div class="khung">
    <img src="../image/logoo.png" alt="SKYDRONE Logo" class="mascot">

    <h1>Tạo mật khẩu mới</h1>
    <p class="huong_dan">
        Vui lòng nhập mã OTP vừa được gửi qua email của bạn<br>
    </p>
    <form action="${pageContext.request.contextPath}/VerifyOtp" method="post">
        <label for="otp">Nhập mã OTP</label>
        <input type="text" id="otp" name="otp" maxlength="4" required>
        <button type="submit">Xác nhận</button>
    </form>

</div>


</body>
</html>
