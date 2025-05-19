<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Management</title>
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/manage.css">
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
            
            <% if ("ADMIN".equals(session.getAttribute("role"))) { %>
                <a href="/admin/employee/list">Quản lý nhân viên</a>
                <a href="/admin/category/edit">Quản lý thể loại</a>
            <% }else { %>
            <% } %>
            
            <a href="/admin/book/list">Quản lý sách</a>
            <a href="/admin/rental/list">Quản lý thuê sách</a>
            <a href="/admin/invoice/list">Hóa đơn</a>
        </div>
        
        <div class="content">
            <h2>Tìm kiếm khách hàng</h2>
            <div class="search-container">
                <div class="search-box">
                    <input type="text" id="searchFullName" placeholder="Họ và tên">
                    <input type="text" id="searchPhone" placeholder="Số điện thoại">
                    <input type="text" id="searchEmail" placeholder="Email">
                </div>
                <div class="pagination-control">
                    <label for="pageSize">Kích thước trang:</label>
                    <select id="pageSize">
                        <option value="10" selected>10</option>
                        <option value="20">20</option>
                        <option value="50">50</option>
                    </select>
                </div>       
                <button class="btn" id="btnSearch">Tìm kiếm</button> 
                              
            </div>
            <div class="info">
                <h2>Bảng danh sách tài khoản</h2>
                <a href="edit" class="btn">Thêm khách hàng</a>
            </div>
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
            <div id="pagination" class="pagination"></div>
        </div>
    </div>

    <script>
        $(document).ready(function () {
            let currentPage = 1;

            loadUsers();

            window.goToPage = function(page) {
                currentPage = page;
                loadUsers();
            }

            $("#btnSearch").click(function () {
                currentPage = 1;
                loadUsers();
            });

            function loadUsers() {
                const fullName = $("#searchFullName").val();
                const phoneNumber = $("#searchPhone").val();
                const email = $("#searchEmail").val();
                const pageSize = $("#pageSize").val();

                let data = {};
                if (fullName) data.fullName = fullName;
                if (phoneNumber) data.phoneNumber = phoneNumber;
                if (email) data.email = email;
                data.pageSize = pageSize;
                data.page = currentPage;

                $.ajax({
                    url: "/api/user/search?role=CUSTOMER",    
                    method: "GET",
                    data: data,
                    dataType: "json",
                    success: function (response) {
                        let users = response.users;
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
                        updatePagination(currentPage, response.totalPages);
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi tải danh sách sách:", error);
                    }
                });
            };

            function updatePagination(currentPage, totalPages) {
                const pagination = $("#pagination");
                pagination.empty();

                const prevDisabled = currentPage <= 1 ? "disabled" : "";
                pagination.append(
                    "<button " + prevDisabled + " onclick=\"goToPage(" + (currentPage - 1) + ")\">&laquo;</button>"
                );

                let startPage = Math.max(1, currentPage - 2);
                let endPage = Math.min(totalPages, currentPage + 2);

                if (currentPage <= 3) {
                    endPage = Math.min(5, totalPages);
                }
                if (currentPage >= totalPages - 2) {
                    startPage = Math.max(1, totalPages - 4);
                }

                for (let i = startPage; i <= endPage; i++) {
                    const active = i === currentPage ? "active" : "";
                    pagination.append(
                        "<button class=\"" + active + "\" onclick=\"goToPage(" + i + ")\">" + i + "</button>"
                    );
                }

                const nextDisabled = currentPage >= totalPages ? "disabled" : "";
                pagination.append(
                    "<button " + nextDisabled + " onclick=\"goToPage(" + (currentPage + 1) + ")\">&raquo;</button>"
                );
            }

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
