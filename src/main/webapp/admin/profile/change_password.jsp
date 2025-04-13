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
            <div class="title">Đổi mật khẩu</div>
            <div class="form-group">
                <label for="name">Tài khoản</label>
                <input type="text">
            </div>
            <div class="form-group">
                <label for="name">Mật khẩu</label>
                <input type="text">
            </div>
            <div class="form-group">
                <label for="phone">Nhập lại mật khẩu</label>
                <input type="text">
            </div>
            <div class="btn-group">
                <button class="btn btn-add">Cập nhật</button>
            </div>
        </div>
    </div>
</body>
</html>
