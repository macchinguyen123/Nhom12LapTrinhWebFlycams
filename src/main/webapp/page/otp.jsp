<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Nhập mã OTP</title>
    <link rel="stylesheet" href="../stylesheets/otp.css">

</head>
<body>

<div class="khung">
    <img src="../image/logoo.png" alt="SKYDRONE Logo" class="mascot">

    <h1>Tạo mật khẩu mới</h1>
    <p class="huong_dan">
        Vui lòng nhập mã OTP vừa được gửi qua email của bạn<br>
    </p>

    <form action="${pageContext.request.contextPath}/verify" method="post" id="otpForm">
        <input type="hidden" name="email" value="${param.email}">

        <div class="otp_khung">
            <input type="text" name="d1" maxlength="1" class="otp-nhap" oninput="move(this,0)">
            <input type="text" name="d2" maxlength="1" class="otp-nhap" oninput="move(this,1)">
            <input type="text" name="d3" maxlength="1" class="otp-nhap" oninput="move(this,2)">
            <input type="text" name="d4" maxlength="1" class="otp-nhap" oninput="move(this,3)">
        </div>

        <input type="hidden" name="otp" id="hiddenOtp">

        <button type="submit" class="nut nut_xac_nhan">Xác nhận</button>
    </form>


    <div class="nut_nhom">
        <a href="forgot-password.jsp" class="nut nut_quay_lai">⬅ Quay lại</a>
        <a href="create-new-password.jsp" class="nut nut_xac_nhan">Xác nhận</a>
    </div>
</div>


</body>
</html>
