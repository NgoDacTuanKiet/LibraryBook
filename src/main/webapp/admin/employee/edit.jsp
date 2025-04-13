<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit EMPLOYEE Account</title>
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/edit.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
            <a href="/admin/employee/list">Quản lý nhân viên</a>
            <a href="/admin/book/list">Quản lý sách</a>
            <a href="/admin/category/edit">Quản lý thể loại</a>
            <a href="/admin/rental/list">Quản lý thuê sách</a>
        </div>
        
        <div class="form-box">
            <div class="title">Cập nhật nhân viên</div>
            <form>
                <div class="form-group">
                    <label for="username">Tài khoản</label>
                    <input type="text" name = "username">
                </div>
                <div class="form-group">
                    <input type="hidden" name = "password" value = "123456">
                </div>
                <div class="form-group">
                    <input type="hidden" name = "role" value = "EMPLOYEE">
                </div>
                <div class="form-group">
                    <label for="fullName">Họ và tên</label>
                    <input type="text" name = "fullName">
                </div>
                <div class="form-group">
                    <label for="phoneNumber">Số điện thoại</label>
                    <input type="text" name = "phoneNumber">
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="text" name= "email">
                </div>
                <div class="form-group">
                    <label for="address">Địa chỉ</label>
                    <input type="text" name = "address">
                </div>
                <div class="btn-group">
                    <button type="button" id="updateCustomerBtn" class="btn btn-add" style="display: none;">Cập nhật nhân viên</button>
                    <button type="button" id="addCustomerBtn" class="btn btn-add" style="display: none;">Thêm nhân viên</button>
                    <a class="btn btn-danger" href="list">Hủy</a>
                </div>
            </form>
        </div>
    </div>

    <Script>
        $(document).ready(function () {
            const urlParams = new URLSearchParams(window.location.search);
            const userId = urlParams.get('userId');
            
            $("#addCustomerBtn").show();
            $("#updateCustomerBtn").hide();
            
            if (userId) {
                $("#addCustomerBtn").hide();
                $("#updateCustomerBtn").show();
                $("input[name='username']").prop("readonly", true);

                $.ajax({
                    url: "/api/user/" + userId,
                    type: 'GET',
                    success: function (data) {
                        $("input[name='username']").val(data.username);
                        $("input[name='fullName']").val(data.fullName);
                        $("input[name='phoneNumber']").val(data.phoneNumber);
                        $("input[name='email']").val(data.email);
                        $("input[name='address']").val(data.address);
                    },
                    error: function (xhr) {
                        alert("Không tìm thấy người dùng!");
                    }
                });
            }

            $("#addCustomerBtn").click(function (event) {
                event.preventDefault();

                let userData = {
                    username: $("input[name='username']").val(),
                    password: $("input[name='password']").val(),
                    role: "EMPLOYEE",
                    fullName: $("input[name='fullName']").val(),
                    phoneNumber: $("input[name='phoneNumber']").val(),
                    email: $("input[name='email']").val(),
                    address: $("input[name='address']").val()
                };

                $.ajax({
                    url: "/api/user/add",
                    type: "POST",
                    contentType: "application/json", 
                    data: JSON.stringify(userData),
                    success: function (response) {
                        alert("Cập nhật thành công!");
                        window.location.href = "/admin/employee/list";
                    },
                    error: function (xhr) {
                        alert("Lỗi: " + xhr.responseText);
                    }
                });
            });

            $("#updateCustomerBtn").click(function (event) {
                event.preventDefault();

                let userData = {
                    username: $("input[name='username']").val(),
                    role: "EMPLOYEE",
                    fullName: $("input[name='fullName']").val(),
                    phoneNumber: $("input[name='phoneNumber']").val(),
                    email: $("input[name='email']").val(),
                    address: $("input[name='address']").val()
                };

                $.ajax({
                    url: "/api/user/update",
                    type: "POST",
                    contentType: "application/json", 
                    data: JSON.stringify(userData),
                    success: function (response) {
                        alert("Cập nhật thành công!");
                        window.location.href = "/admin/employee/list";
                    },
                    error: function (xhr) {
                        alert("Lỗi: " + xhr.responseText);
                    }
                });
            });
        });
    </Script>
</body>
</html>
