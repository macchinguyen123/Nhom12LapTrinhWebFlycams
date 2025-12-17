<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Nhập mã OTP</title>

    <style>
        .btn-xac-nhan {
            display: block;
            margin: 20px auto 0;
            padding: 12px 40px;
            border-radius: 12px;
            border: none;
            background: #0051c6;
            color: white;
            font-size: 16px;
            font-weight: 500;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-xac-nhan:hover {
            background: #3b5be0;
        }

        .btn-xac-nhan:active {
            transform: scale(0.97);
        }
    </style>

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
        <button type="submit" class="btn-xac-nhan">Xác nhận</button>

    </form>

</div>


</body>
</html>
