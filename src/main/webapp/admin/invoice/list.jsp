<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Account Management</title>
    <link rel="stylesheet" href="/CSS/bill.css">
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/searchBox.css">
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            loadPayments();
            
            function loadPayments(){
                $.ajax({
                    url: "/api/payment/list",
                    type: "GET",
                    success: function (invoiceResponseDTOs) {
                        let billTableBody = $(".bill-table tbody");
                        billTableBody.empty();

                        if (!Array.isArray(invoiceResponseDTOs) || invoiceResponseDTOs.length === 0) {
                            billTableBody.append("<tr><td colspan='4'>Không có hóa đơn nào.</td></tr>");
                            return;
                        }

                        invoiceResponseDTOs.forEach(function (invoiceResponseDTO) {
                            let formattedTime = formatDateTime(invoiceResponseDTO.time);

                            let row = $("<tr>").addClass("bill-row").click(function () {
                                window.location.href = "/admin/invoice/detail?id=" + invoiceResponseDTO.paymentId;
                            });

                            row.append($("<td>").text(invoiceResponseDTO.paymentId));
                            row.append($("<td>").text(invoiceResponseDTO.customer_user.fullName));
                            row.append($("<td>").text(invoiceResponseDTO.employee_user.fullName));
                            row.append($("<td>").text(formattedTime));

                            billTableBody.append(row);
                        });
                    },
                    error: function () {
                        alert("Lỗi khi tải danh sách hóa đơn.");
                    }
                });
            };
        });

        function formatDateTime(isoString) {
            let date = new Date(isoString);
            return date.toLocaleString("vi-VN", { 
                day: '2-digit', month: '2-digit', year: 'numeric'
            });
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
            <table class="bill-table">
                <thead>
                    <tr>
                        <th>Mã hóa đơn</th>
                        <th>Khách hàng</th>
                        <th>Nhân viên</th>
                        <th>Thời gian</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Dữ liệu sẽ được thêm vào đây bằng JS -->
                </tbody>
            </table>            
        </div>
    </div>

    
</body>
</html>
