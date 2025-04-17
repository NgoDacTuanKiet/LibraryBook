<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password</title>
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/edit.css">
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
                        window.location.href = "/admin/account/list";
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
            <li><a href="#">Trang quản trị</a></li>
            <li class="right dropdown">
                <a href="#">Tài khoản</a>
                <ul class="dropdown-menu">
                    <li><a href="/admin/profile/profile">Thông tin chi tiết</a></li>
                    <li><a href="/admin/profile/change_password">Đổi mật khẩu</a></li>
                    <li><a href="/signin">Đăng xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="container">
        <div class="sidebar">
            <a href="/admin/account/list">Quản lý khách hàng</a>
            
            <% if ("ADMIN".equals(session.getAttribute("role"))) { %>
                <a href="/admin/employee/list">Quản lý nhân viên</a>
                <a href="/admin/category/edit">Quản lý thể loại</a>
            <% }else { %>
            <% } %>
            
            <a href="/admin/book/list">Quản lý sách</a>
            <a href="/admin/rental/list">Quản lý thuê sách</a>
            <a href="/admin/invoice/list">Hóa đơn</a>
        </div>
        
        
        <form class="form-box" id="change-password-form">
            <div class="title">Đổi mật khẩu</div>
            <input type="hidden" id="user-password">
            <div class="form-group">
                <label for="current-password">Mật khẩu hiện tại</label>
                <input type="password" id="current-password" name="current-password" required>
            </div>
            <div class="form-group">
                <label for="current-password">Mật khẩu mới</label>
                <input type="password" id="new-password" name="new-password" required>
            </div>
            <div class="form-group">
                <label for="confirm-password">Xác nhận mật khẩu mới</label>
                <input type="password" id="confirm-password" name="confirm-password" required>
            </form>
            
            <p id="error-message" style="color: red;"></p>

            <div class="btn-group">
                <button type="submit" class="btn btn-add">Xác nhận</button>
            </div>
        </div>
    </div>
</body>
</html>
