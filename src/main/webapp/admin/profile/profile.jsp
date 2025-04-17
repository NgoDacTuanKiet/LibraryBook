<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile</title>
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/edit.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function() {
            loadInformation();

            function loadInformation(){
                $.ajax({
                    url: "/api/user/information",
                    method: "GET",
                    dataType: "json",
                    xhrFields: { withCredentials: true },
                    success: function(user) {

                        if ($.isEmptyObject(user)) {
                            alert("Bạn chưa đăng nhập!");
                            window.location.href = "/signin"; // Chuyển hướng đến trang đăng nhập
                        } else {
                            $(".avatar").attr("src", user.imageUrl || "/khac/logo.webp");

                            // Gán giá trị vào input sử dụng thuộc tính name
                            $("[name='username']").val(user.username || "");
                            $("[name='fullName']").val(user.fullName || "");
                            $("[name='email']").val(user.email || "");
                            $("[name='phoneNumber']").val(user.phoneNumber || "");
                            $("[name='address']").val(user.address || "");
                        }
                    },
                    error: function() {
                        alert("Lỗi tải thông tin người dùng!");
                    }
                })
            }

            $("#updateUserBtn").click(function (event) {
                event.preventDefault();
                
                let userData = {
                    username: $("input[name='username']").val(),
                    fullName: $("input[name='fullName']").val(),
                    phoneNumber: $("input[name='phoneNumber']").val(),
                    email: $("input[name='email']").val(),
                    address: $("input[name='address']").val()
                }

                $.ajax({
                    url: "/api/user/setprofile",
                    method: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(userData),
                    dataType: "json",
                    success: function (response) {
                        alert("Cập nhật thông tin thành công!");
                        loadInformation();
                        console.log("Server response:", response);
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi cập nhật:", xhr.responseText);
                        
                        let errorMessage = "Cập nhật thất bại! Kiểm tra lại thông tin.";
                        
                        if (xhr.responseText) {
                            errorMessage = xhr.responseText; // Lấy thông báo lỗi từ server
                        }
                        loadInformation();
                        alert(errorMessage);
                    }
                });
            })
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
        
        
        <div class="form-box">
            <div class="title">Thông tin tài khoản</div>
            <div class="form-group">
                <label for="name">Tài khoản</label>
                <input type="text" name = "username" readonly>
            </div>
            <div class="form-group">
                <label for="name">Họ và tên</label>
                <input type="text" name = "fullName">
            </div>
            <div class="form-group">
                <label for="phone">Số điện thoại</label>
                <input type="text" name="phoneNumber">
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="text" name="email">
            </div>
            <div class="form-group">
                <label for="name">Địa chỉ</label>
                <input type="text" name="address">
            </div>
            <div class="button-group">
                <button class="btn btn-add" id="updateUserBtn">Cập nhật thông tin</button>
                <a href="change_password" class="btn btn-add">Đổi mật khẩu</a>
            </div>
        </div>
    </div>
</body>
</html>
