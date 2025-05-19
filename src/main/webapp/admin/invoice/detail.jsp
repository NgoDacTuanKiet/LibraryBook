<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Hóa Đơn</title>
    <link rel="stylesheet" href="/CSS/bill_detail.css">
    <link rel="stylesheet" href="/CSS/bill.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/manage.css">
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
            let urlParams = new URLSearchParams(window.location.search);
            let paymentId = urlParams.get("id");

            if (!paymentId) {
                alert("Không tìm thấy mã hóa đơn!");
                window.location.href = "/list";
                return;
            }

            function getBillDetail() {
                $.ajax({
                    url: "/api/payment/detail/" + paymentId,
                    type: "GET",
                    dataType: "json",
                    success: function(data) {
                        renderBillDetail(data);
                    },
                    error: function(xhr, status, error) {
                        console.error("Lỗi khi tải chi tiết hóa đơn:", error);
                        alert("Không thể tải chi tiết hóa đơn!");
                    }
                });
            }

            function renderBillDetail(data) {
                $("#time").text(formatDateTime(data.time));

                $("#customerName").text(data.customer_user.username);
                $("#customerEmail").text(data.customer_user.email);

                $("#employeeName").text(data.employee_user.username);
                $("#employeeEmail").text(data.employee_user.email);

                let bookList = $(".book-list tbody");
                bookList.empty();

                let total = 0;

                if (!Array.isArray(data.paymentDetails) || data.paymentDetails.length === 0) {
                    bookList.append("<tr><td colspan='4'>Không có sách nào.</td></tr>");
                    return;
                }

                data.paymentDetails.forEach(function (detail, index) {
                    let categories = detail.book.categoriesOfBook
                                ? detail.book.categoriesOfBook.map(category => category.name).join(", ")
                                : "Không có thể loại";
                    
                    let row = $("<tr>");
                    row.append($("<td>").text(index + 1));
                    row.append($("<td>").text(detail.book.bookName));
                    row.append($("<td>").text(detail.book.author));
                    row.append($("<td>").text(detail.quantity));
                    row.append($("<td>").text(detail.quantity*10000));
                    row.append($("<td>").text(detail.punishCost));
                    row.append($("<td>").text(detail.reason));

                    let amount = detail.quantity*10000 + detail.punishCost;
                    total += amount;

                    row.append($("<td>").text(amount));
                        
                    bookList.append(row);
                });
                $("#total").text(total);
            }
            

            $("#printBill").click(function () {
                window.print();
            });

            getBillDetail();
        });

        function formatDateTime(isoString) {
            let date = new Date(isoString);
            return date.toLocaleString("vi-VN", {
                hour: '2-digit', minute: '2-digit', 
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
        
        <div class="content" style="margin-left: 25%;">
            <h2>Chi Tiết Hóa Đơn</h2>
        
            <div class="info-box">
                <div class="info-bottom">
                    <p><strong>Thư viện LibraryBook</strong></p>
                    <p><strong>Số điện thoại: 0988265438</strong></p>
                    <p><strong>Email: librarybook@gmail.com</strong></p>
                </div>
                <p><strong>Nhân viên:</strong> <span id="employeeName"></span></p>

                <p><strong>Khách hàng:</strong> <span id="customerName"></span></p>
                <p><strong>Email:</strong> <span id="customerEmail"></span></p>
            </div>
            
        
            <table class="book-list">
                <thead>
                    <tr>
                        <th></th>
                        <th>Tên sách</th>
                        <th>Tác giả</th>
                        <th>Số lượng</th>
                        <th>Tiền mượn</th>
                        <th>Tiền phạt</th>
                        <th>Lý do</th>
                        <th>Tổng</th>
                    </tr>
                </thead>
                <tbody>
                </tbody>
            </table>
        
            <div class="info-bottom">
                <p>Thành tiền: <span id="total"></span> vnđ</p>
                <p>Thời gian: <span id="time"></span></p>
            </div>
        
            <a href="list" class="btn-back">Quay lại danh sách hóa đơn</a>
            <button id="printBill" class="btn-print">In hóa đơn</button>
        </div>        
        
    </div>

    
</body>
</html>
