<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>LIST EMPLOYEE ACCOUNT</title>
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/searchBox.css">
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
        
        <div class="content">
            <h2>Tìm kiếm nhân viên</h2>
            <div class="search-container">
                <div class="search-box">
                    <input type="text" id="searchFullName" placeholder="Họ và tên">
                    <input type="text" id="searchPhone" placeholder="Số điện thoại">
                    <input type="text" id="searchEmail" placeholder="Email">
                </div>
                <button class="btn" id="btnSearch">Tìm kiếm</button>  
            </div>
            <div class="info">
                <h2>Bảng danh sách tài khoản</h2>
                <a href="edit" class="btn">Thêm nhân viên</a>
            </div>
            <table class="table">
                <thead>
                    <tr>
                        <th>Mã nhân viên</th>
                        <th>Tài khoản</th>
                        <th>Mật khẩu</th>
                        <th>Tên khách hàng</th>
                        <th>Số điện thoại</th>
                        <th>Email</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            loadUsers(); // Gọi hàm tải sách khi trang vừa load

            $("#btnSearch").click(function() {
                loadUsers();
            });
            
            function loadUsers() {
                const fullName = $("#searchFullName").val();
                const phoneNumber = $("#searchPhone").val();
                const email = $("#searchEmail").val();

                let data = {};
                if (fullName) data.fullName = fullName;
                if (phoneNumber) data.phoneNumber = phoneNumber;
                if (email) data.email = email;

                $.ajax({
                    url: "/api/user/search?role=EMPLOYEE",    
                    method: "GET",
                    data: data,
                    dataType: "json",
                    success: function (users) {
                        let tableBody = $(".table tbody");
                        tableBody.empty(); // Xóa dữ liệu cũ trước khi cập nhật mới

                        if(users.length === 0){
                            tableBody.append("<p>").append("Không có tài khoản nào được tìm thấy!");
                        };
                        
                        $.each(users, function (index, user) {

                            let row = 
                                "<tr>" +
                                    "<td>" + user.id + "</td>" +
                                    "<td>" + user.username + "</td>" +
                                    "<td>" + user.password + "</td>" +
                                    "<td>" + user.fullName + "</td>" +
                                    "<td>" + user.phoneNumber + "</td>" +
                                    "<td>" + user.email + "</td>" +
                                    "<td class='actions'>" +
                                        "<a href='edit?userId=" + user.id + "'><img src='/khac/pencil-icon.png' alt='Sửa'></a>" +
                                        "<img src='/khac/delete.png' alt='Xóa' onclick='deleteUser(" + user.id + ")'>" +
                                    "</td>" +
                                "</tr>";
                            
                            tableBody.append(row);
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi tải danh sách sách:", error);
                    }
                });
            };

            window.deleteUser = function (id) {
                if (!confirm("Bạn có chắc muốn xóa tài khoản này?")) return;

                $.ajax({
                    url: "/api/user/delete/" + id,
                    method: "POST",
                    success: function () {
                        loadUsers();
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi xóa tài khoản:", error);
                    }
                });
            };
        });
    </script>
</body>
</html>
