<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Rental Management</title>
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/searchBox.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            loadUsers();

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
                    url: "/api/borrow/borrowing/customer/list",    
                    type: "GET",
                    data: data,
                    dataType: "json",
                    success: function (users) {
                        let tableBody = $(".table tbody");
                        tableBody.empty(); 

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
                                        "<a href='detail?userId=" + user.id + "'><img src='/khac/info.png' alt='Chi tiết'></a>" +
                                    "</td>" +
                                "</tr>";
                            
                            tableBody.append(row);
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi tải danh sách sách:", error);
                    }
                });
            }
        });
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

        <div class="content">
            <h2>Tìm kiếm khách hàng</h2>
            <div class="search-container">
                <div class="search-box">
                    <input type="text" id="searchFullName" placeholder="Họ và tên">
                    <input type="text" id="searchPhone" placeholder="Số điện thoại">
                    <input type="text" id="searchEmail" placeholder="Email">
                </div>
                <button class="btn" id="btnSearch">Tìm kiếm</button>  
            </div>
            <h2>Bảng danh sách khách hàng đang mượn sách</h2>
            <table class="table">
                <thead>
                    <tr>
                        <th>Mã khách hàng</th>
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
</body>
</html>