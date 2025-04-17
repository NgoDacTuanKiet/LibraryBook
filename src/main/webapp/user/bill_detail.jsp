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
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
            let urlParams = new URLSearchParams(window.location.search);
            let borrowingId = urlParams.get("id");

            if (!borrowingId) {
                alert("Không tìm thấy mã hóa đơn!");
                window.location.href = "/bill";
                return;
            }

            function getBillDetail() {
                $.ajax({
                    url: "/api/borrow/borrowing/detail/" + borrowingId,
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

                $("#customerName").text(data.user.username);
                $("#customerEmail").text(data.user.email);

                let bookList = $(".book-list tbody");
                bookList.empty();

                if (!Array.isArray(data.borrowDetails) || data.borrowDetails.length === 0) {
                    bookList.append("<tr><td colspan='4'>Không có sách nào.</td></tr>");
                    return;
                }

                data.borrowDetails.forEach(function (detail, index) {
                    let categories = detail.book.categoriesOfBook
                                ? detail.book.categoriesOfBook.map(category => category.name).join(", ")
                                : "Không có thể loại";
                    
                    let row = $("<tr>");
                    row.append($("<td>").text(index + 1))
                    row.append($("<td>").text(detail.book.bookName));
                    row.append($("<td>").text(detail.book.author));
                    row.append($("<td>").text(detail.book.publisher));
                    row.append($("<td>").text(detail.book.yearOfpublication));
                    row.append($("<td>").text(categories));
                    row.append($("<td>").text(detail.quantity));
                    bookList.append(row);
                });
            }
            $("#printBill").click(function () {
                window.print();
            });

            getBillDetail();
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

    <div class="content">
        <h2>Chi Tiết Hóa Đơn</h2>

        <div class="customer-info">
            <p><strong>Khách hàng:</strong> <span id="customerName"></span></p>
            <p><strong>Email:</strong> <span id="customerEmail"></span></p>
        </div>

        <table class="book-list">
            <thead>
                <tr>
                    <th></th>
                    <th>Tên sách</th>
                    <th>Tác giả</th>
                    <th>Nhà xuất bản</th>
                    <th>Năm xuất bản</th>
                    <th>Thể loại</th>
                    <th>Số lượng</th>
                </tr>
            </thead>
            <tbody>

            </tbody>
        </table>

        <a href="bill" class="btn-back">Quay lại danh sách hóa đơn</a>
        <button id="printBill" class="btn-print">In hóa đơn</button>
    </div>
</body>
</html>
