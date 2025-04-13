<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử hóa đơn - Chưa thanh toán</title>
    <link rel="stylesheet" href="/CSS/bill.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/history.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
            function getBillList() {
                $.ajax({
                    url: "/api/borrow/borrowing/list",
                    type: "GET",
                    dataType: "json",
                    success: function(borrowingResponseDTO) {
                        renderBills(borrowingResponseDTO);
                    },
                    error: function(xhr, status, error) {
                        console.error("Lỗi khi tải danh sách hóa đơn:", error);
                    }
                });
            }

            function renderBills(borrowingResponseDTO) {
                let billTableBody = $(".bill-table tbody");
                billTableBody.empty();

                let bills = borrowingResponseDTO.borrowings;
                let user = borrowingResponseDTO.user;

                if (!Array.isArray(bills) || bills.length === 0) {
                    billTableBody.append("<tr><td colspan='3'>Không có hóa đơn nào.</td></tr>");
                    return;
                }

                bills.forEach(function (bill) {
                    let formattedTime = formatDateTime(bill.borrowDate);

                    let row = $("<tr>").addClass("bill-row").click(function () {
                        window.location.href = "/bill_detail?id=" + bill.id;
                    });

                    row.append($("<td>").text(bill.id));
                    row.append($("<td>").text(user.username));
                    row.append($("<td>").text(formattedTime));

                    billTableBody.append(row);
                });
            }

            function formatDateTime(isoString) {
                let date = new Date(isoString);
                return date.toLocaleString("vi-VN", {
                    hour: '2-digit', minute: '2-digit', 
                    day: '2-digit', month: '2-digit', year: 'numeric'
                });
            }
            
            getBillList();
        });
    </script>

</head>
<body>
    <!-- header -->
    <nav class="navbar">
        <ul>
            <li><a href="home">Trang chủ</a></li>
            <li><a href="list_book">Tủ sách</a></li>
            <li><a href="love_book">Yêu thích</a></li>
            <li><a href="bill">Lịch sử mượn sách</a></li>
            <li class="right dropdown">
                <% if (session.getAttribute("user") != null) { %>
                    <a href="#">Tài khoản</a>
                    <ul class="dropdown-menu">
                        <li><a href="account">Thông tin chi tiết</a></li>
                        <li><a href="book_cart">Giỏ hàng</a></li>
                        <li><a href="change_password">Đổi mật khẩu</a></li>
                        <li><a href="/signin">Đăng xuất</a></li>
                    </ul>
                <% } else { %>
                    <a href="/signin">Đăng nhập</a> | <a href="/signup">Đăng ký</a>
                <% } %>
            </li>
        </ul>
    </nav>

    <div class="container">
        <div class="box">
            <div class="status-container">
                <a class="status active" href="bill">Hóa đơn</a>
                <a class="status" href="borrowing">Sách đang mượn</a>
                <a class="status" href="borrowed">Sách đã mượn</a>
            </div>
        </div>  
       
        <!-- Bảng danh sách hóa đơn -->
        <table class="bill-table">
            <thead>
                <tr>
                    <th>Mã hóa đơn</th>
                    <th>Khách hàng</th>
                    <th>Thời gian</th>
                </tr>
            </thead>
            <tbody>
                <!-- Dữ liệu sẽ được thêm vào đây bằng jQuery -->
            </tbody>
        </table>
    </div>
</body>
</html>
