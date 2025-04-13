<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu</title>
    <link rel="stylesheet" href="/../CSS/header_style.css">
    <link rel="stylesheet" href="/../CSS/change-password_style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            getUser();

            $("#change-password-form").submit(function (event) {
                event.preventDefault();

                let userPassword = $("#user-password").val();
                let password = $("#current-password").val();
                let newPassword = $("#new-password").val();
                let confirmPassword = $("#confirm-password").val();
                let errorMessage = $("#error-message");

                if (userPassword != password) {
                    errorMessage.text("Mật khẩu không chính xác!");
                    return;
                } else if (newPassword != confirmPassword) {
                    errorMessage.text("Mật khẩu xác nhận không khớp!");
                    return;
                } else {
                    errorMessage.text("");
                }

                $.ajax({
                    url: "/api/user/changepassword",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        password: newPassword
                    }),
                    success: function(response) {
                        alert("Đổi mật khẩu thành công!");
                        window.location.href = "/home";
                    },
                    error: function(xhr) {
                        errorMessage.text("Lỗi");
                    }
                })
            })

            function getUser () {
                $.ajax({
                    url: "/api/user/information",
                    method: "GET",
                    dataType: "json",
                    success: function(user) {

                        if ($.isEmptyObject(user)) {
                            alert("Vui lòng đăng nhập!");
                            window.location.href = "/signin";
                        } else {
                            $("#user-password").val(user.password);
                        }
                    }
                })
            }
        })
    </script>
</head>
<body>
    <!-- header -->
    <nav class="navbar">
        <ul>
            <li><a href="home">Trang chủ</a></li>
            <li><a href="list_book">Tủ sách</a></li>
            <li><a href="love_book">Yêu thích</a></li>
            <li><a href="bill">Lịch sử mượn sách</a></li>
            <li class="right dropdown">
                <a href="#">Tài khoản</a>
                <ul class="dropdown-menu">
                    <li><a href="account">Thông tin chi tiết</a></li>
                    <li><a href="book_cart">Giỏ hàng</a></li>
                    <li><a href="change_password">Đổi mật khẩu</a></li>
                    <li><a href="/signin">Đăng xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>
    
    <div class = "box">
        <div class="login-container">
            <h2>Đổi mật khẩu</h2>
            <form id="change-password-form">
                <input type="hidden" id="user-password">

                <label for="current-password">Mật khẩu hiện tại</label>
                <input type="password" id="current-password" name="current-password" required>
    
                <label for="new-password">Mật khẩu mới</label>
                <input type="password" id="new-password" name="new-password" required>
    
                <label for="confirm-password">Xác nhận mật khẩu mới</label>
                <input type="password" id="confirm-password" name="confirm-password" required>

                <p id="error-message" style="color: red;"></p>

                <button type="submit">Xác nhận</button>
            </form>
        </div>
    </div>
</body>
</html>
