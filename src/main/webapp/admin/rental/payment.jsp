<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment</title>
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/edit.css">
    <link rel="stylesheet" href="/CSS/payment.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            const urlParams = new URLSearchParams(window.location.search);
            const userId = urlParams.get('userId');

            $.ajax({
                url: "/api/user/" + userId,
                type: "GET",
                dataType: "json",
                success: function(data) {
                    $("#fullName").val(data.fullName).prop("readonly", true);
                    $("#phone").val(data.phoneNumber).prop("readonly", true);
                    $("#email").val(data.email).prop("readonly", true);
                    $("#address").val(data.address).prop("readonly", true);
                },
            });

            $.ajax({
                
            })
        });

        function goBack() {
            if (document.referrer) {
                window.location.href = document.referrer;
            } else {
                window.location.href = "home";
            }
        }
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
            <a href="/admin/employee/list">Quản lý nhân viên</a>
            <a href="/admin/book/list">Quản lý sách</a>
            <a href="/admin/category/edit">Quản lý thể loại</a>
            <a href="/admin/rental/list">Quản lý thuê sách</a>
        </div>
        
        <a href="#" class="back-btn" onclick="goBack()">Back</a>
        
        <div class="model">
            <div class="form-box">
                <div class="title">Thông tin khách hàng</div>
                <div class="form-group">
                    <label for="name">Họ và tên</label>
                    <input type="text" id="fullName">
                </div>
                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="text" id="phone">
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="text" id="email">
                </div>
                <div class="form-group">
                    <label for="name">Địa chỉ</label>
                    <input type="text" id="address">
                </div>
            </div>
    
            <table class="table">
                <tr>
                    <th>Mã sách</th>
                    <th>Tên sách</th>
                    <th>Tác giả</th>
                    <th>Nhà xuất bản</th>
                    <th>Thể loại</th>
                    <th>Số lượng</th>
                    <th>Ngày mượn</th>
                    <th>Hạn</th>
                </tr>
            </table>

            <div class="info">
                <h3>Thành tiền: 300.000đ</h3>
                <a href="payment" class="btn" style="background-color: #5a9bd5">Thanh toán</a>
            </div>
        </div>
    </div>
</body>
</html>
