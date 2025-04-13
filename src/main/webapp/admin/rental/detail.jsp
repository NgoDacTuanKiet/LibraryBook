<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Book Rental Management</title>
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/searchBox.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            const urlParams = new URLSearchParams(window.location.search);
            const userId = urlParams.get('userId');

            loadBorrowingBooks();
            loadUser();

            let info = $(".info");
            info.append($("<h2>").text("Bảng danh sách sách đang mượn"));
            info.append(
                $("<button>")
                .attr("id", "paymentBtn")
                .addClass("btn")
                .css("background-color", "#5a9bd5")
                .text("Thanh toán")
            );

            $(document).on("click", "#paymentBtn", function (e) {
                e.preventDefault();

                let paymentList = [];

                $('input[name="borrowingBook"]:checked').each(function () {
                    let checkbox = $(this);
                    let row = checkbox.closest('tr');

                    let paymentDTO = {
                        bookId: parseInt(checkbox.data("book-id")),
                        bookLoanDate: checkbox.data("book-loan-date"),
                        dueDate: checkbox.data("due-date"),
                        quantity: parseInt(row.find(".return-quantity").val()) || 0,
                        punishCost: parseInt(row.find(".punish-cost").val()) || 0,
                        reason: row.find(".reason").val() || ""
                    };

                    paymentList.push(paymentDTO);
                });

                if (paymentList.length === 0) {
                    alert("Vui lòng chọn ít nhất một sách để thanh toán.");
                    return;
                }

                $.ajax({
                    url: "/api/payment/new/detail/" + userId,
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(paymentList),
                    success: function (response) {
                        window.location.href = "payment?userId=" + userId;
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi gửi dữ liệu thanh toán:", error);
                    }
                });
            });
            
            function loadBorrowingBooks() {
                $.ajax({
                    url: "/api/borrow/borrowing/book/list/" + userId,
                    type: "GET",
                    dataType: "json",
                    success: function (borrowingBooks) {
                        let tableBody = $(".table tbody");
                        tableBody.empty(); 

                        $.each(borrowingBooks, function (index, borrowingBook) {
                            let categories = borrowingBook.book.categoriesOfBook
                                ? borrowingBook.book.categoriesOfBook.map(category => category.name).join(", ")
                                : "Không có thể loại";
                            
                                let row = 
                                    '<tr>' +
                                        '<td>' +
                                            '<input type="checkbox" name="borrowingBook" id="bor-' + borrowingBook.id + '" value="' + borrowingBook.id + '" ' +
                                            'data-book-id="' + borrowingBook.book.id + '" ' +
                                            'data-book-loan-date="' + borrowingBook.bookLoanDate + '" ' +
                                            'data-due-date="' + borrowingBook.dueDate + '" ' +
                                            'data-quantity="' + borrowingBook.quantity + '">' +
                                        '</td>' +
                                        '<td>' + borrowingBook.book.id + '</td>' +
                                        '<td>' + borrowingBook.book.bookName + '</td>' +
                                        '<td>' + borrowingBook.book.author + '</td>' +
                                        '<td>' + borrowingBook.quantity + '</td>' +
                                        '<td>' + formatDateTime(borrowingBook.bookLoanDate) + '</td>' +
                                        '<td>' + formatDateTime(borrowingBook.dueDate) + '</td>' +

                                        '<td><input type="number" class="return-quantity" min="0" max="' + borrowingBook.quantity + '" value="' + borrowingBook.quantity + '"></td>' +
                                        '<td><input type="number" class="punish-cost" min="0" value="0"></td>' +
                                        '<td><input type="text" class="reason" placeholder="Lý do nếu có"></td>' +
                                    '</tr>';
                            
                            tableBody.append(row);
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi tải danh sách sách:", error);
                    }
                });
            }

            function loadUser() {
                $.ajax({
                    url: "/api/user/" + userId,
                    type: "GET",
                    dataType: "json",
                    success: function(data){
                        $("#fullName").val(data.fullName).prop("readonly", true);
                        $("#phone").val(data.phoneNumber).prop("readonly", true);
                        $("#email").val(data.email).prop("readonly", true);
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi tải user:", error);
                    }
                });
            }

            function formatDateTime(isoString) {
                let date = new Date(isoString);
                return date.toLocaleString("vi-VN", {
                    day: '2-digit', month: '2-digit', year: 'numeric'
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
            <a href="list" class="back-btn">Back</a>
            
            <h2>Thông tin khách hàng</h2>
            <div class="search-container">
                <div class="search-box">
                    <input type="text" id="fullName" placeholder="Họ và tên">
                    <input type="text" id="phone" placeholder="Số điện thoại">
                    <input type="text" id="email" placeholder="Email">
                </div>               
            </div>
            <div class="info">

            </div>
            <table class="table">
                <thead>
                    <th></th>
                    <th>Mã sách</th>
                    <th>Tên sách</th>
                    <th>Tác giả</th>
                    <th>Số lượng</th>
                    <th>Ngày mượn</th>
                    <th>Hạn</th>
                    <th>Số lượng trả</th>
                    <th>Tiền phạt</th>
                    <th>Lý do</th>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
