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
            const customerId = urlParams.get('customerId');

            $.ajax({
                url: "/api/user/" + customerId,
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
                url: "/api/payment/temp/detail/" + customerId,
                type: "GET",
                dataType: "json",
                success: function(data) {
                    let table = $(".table");
                    let totalAmount = 0;
                    data.forEach(item => {
                        totalAmount += item.total;
                        let row = 
                            "<tr>" +
                                "<td>" + item.book.id + "</td>" +
                                "<td>" + item.book.bookName + "</td>" +
                                "<td>" + item.book.author + "</td>" +
                                "<td>" + item.quantity + "</td>" +
                                "<td>" + formatDateTime(item.bookLoanDate) + "</td>" +
                                "<td>" + formatDateTime(item.dueDate) + "</td>" +
                                "<td>" + item.punishCost + "</td>" +
                                "<td>" + item.reason + "</td>" +
                                "<td>" + item.total + "</td>" +
                            "</tr>";

                        table.append(row);
                    });

                    let info = $(".info");
                    info.append(
                        $("<h3>").append("Thành tiền: ").append(totalAmount).append(" vnđ.")
                    )
                    info.append(
                        $("<button>", {
                            class: "btn",
                            style: "background-color: #5a9bd5",
                            id: "pay-btn"
                        }).text("Thanh toán")
                    )
                },
                error: function(xhr) {
                    console.log("Lỗi khi lấy dữ liệu thanh toán tạm:", xhr.responseText);
                }
            });

            $(document).on("click", "#pay-btn", function() {
                let paymentItems = [];
                $(".table tr:not(:first)").each(function() {
                    let cells = $(this).find("td");

                    let item = {
                        book: {
                            id: parseInt(cells.eq(0).text())
                        },
                        bookLoanDate: cells.eq(4).text(),
                        dueDate: cells.eq(5).text(),
                        punishCost: parseInt(cells.eq(6).text()) || 0,
                        reason: cells.eq(7).text(),
                        quantity: parseInt(cells.eq(3).text())
                    };

                    item.bookLoanDate = toISODate(item.bookLoanDate);
                    item.dueDate = toISODate(item.dueDate);

                    paymentItems.push(item);
                });

                $.ajax({
                    url: "/api/payment/add/" + customerId,
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(paymentItems),
                    success: function(response) {
                        alert("Thanh toán thành công!");
                        window.location.href = "/admin/invoice/list";
                    },
                    error: function(xhr) {
                        alert("Đã xảy ra lỗi khi thanh toán: " + xhr.responseText);
                    }
                });
            });
        });

        function goBack() {
            if (document.referrer) {
                window.location.href = document.referrer;
            } else {
                window.location.href = "home";
            }
        }

        function formatDateTime(isoString) {
            let date = new Date(isoString);
            return date.toLocaleString("vi-VN", {
                day: '2-digit', month: '2-digit', year: 'numeric'
            });
        }

        function toISODate(vnDateStr) {
            var parts = vnDateStr.split("/");
            var year = parts[2];
            var month = parts[1];
            var day = parts[0];
            return year + "-" + month + "-" + day + "T00:00:00";
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
                <thead>
                    <th>Mã sách</th>
                    <th>Tên sách</th>
                    <th>Tác giả</th>
                    <th>Số lượng</th>
                    <th>Ngày mượn</th>
                    <th>Hạn</th>
                    <th>Tiền phạt</th>
                    <th>Lý do</th>
                    <th>Thành tiền</th>
                </thead>
            </table>

            <div class="info">

            </div>
        </div>
    </div>
</body>
</html>
