<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sách</title>
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/book_cart.css">
    <link rel="stylesheet" href="/CSS/bill.css">
    <link rel="stylesheet" href="/CSS/history.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
        function getListBook() {
            $.ajax({
                url: "/api/borrow/borrowing/book/list",
                type: "GET",
                dataType: "json",
                success: function(bookBorrowings) {
                    renderBooks(bookBorrowings);
                },
                error: function (xhr, status, error) {
                    console.error("Lỗi khi tải danh sách sách:", error);
                }
            });
        }

        function renderBooks(bookBorrowings) {

            let bookList = $(".book-list");
            bookList.empty();

            if (!Array.isArray(bookBorrowings) || bookBorrowings.length === 0) {
                bookList.append("<p>Không có sách nào đang mượn.</p>");
                return;
            }
            bookBorrowings.forEach(function (bookBorrowing) {
                let book = bookBorrowing.book;

                let bookCard = $("<div>").addClass("book-card");
                let formattedTime = formatDateTime(bookBorrowing.dueDate);
                let bookImg = $("<img>")
                    .attr("src", book.imageUrl)
                    .attr("alt", book.bookName);

                let bookInfo = $("<div>").addClass("book-info");
                
                let bookName = $("<p>").html("<strong>Tên : </strong>" + book.bookName);
                let bookAuthor = $("<p>").html("<strong>Tác giả : </strong>" + book.author);
                let bookPublisher = $("<p>").html("<strong>Nhà xuất bản : </strong>" + book.publisher);
                let bookYearOfpublication = $("<p>").html("<strong>Năm xuất bản : </strong>" + book.yearOfpublication);
                let bookBorrowingQuantity = $("<p>").html("<strong>Số lượng : </strong>" + bookBorrowing.quantity);
                let bookBorrowingDueDate = $("<p>").html("<strong>Hạn : </strong>" + formattedTime);

                bookInfo.append(bookName, bookAuthor, bookPublisher, bookBorrowingQuantity, bookBorrowingDueDate);
                bookCard.append(bookImg, bookInfo);

                bookList.append(bookCard);
            });
        }

        function formatDateTime(isoString) {
            let date = new Date(isoString);
            return date.toLocaleString("vi-VN", { 
                day: '2-digit', month: '2-digit', year: 'numeric'
            });
        }

        getListBook();
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
                <a href="#">Tài khoản</a>
                <ul class="dropdown-menu">
                    <li><a href="account">Thông tin chi tiết</a></li>
                    <li><a href="book_cart">Giỏ hàng</a></li>
                    <li><a href="change_password">Đổi mật khẩu</a></li>
                    <li><a href="/signin">Đăng xuất</a></li>
                </ul>
            </li>
        </ul>
    </nav>

    <div class="container">
        <div class="box">
            <div class="status-container">
                <a class="status" href="bill">Hóa đơn</a>
                <a class="status active status" href="borrowing">Sách đang mượn</a>
                <a class="status" href="borrowed">Sách đã mượn</a>
            </div>
        </div>
        <div class="cart-container">
            <h2 class="cart-title">Danh sách sách đang mượn</h2>
            <div class="book-list">
                
            </div>
        </div>
    </div>
</body>
</html>
