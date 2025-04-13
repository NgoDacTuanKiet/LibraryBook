<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử mượn sách - Đã trả</title>
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/history.css">
    <link rel="stylesheet" href="/CSS/list_book_style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function() {
            $.ajax({
                url: "/api/borrow/borrowed/book/list",
                type: "GET",
                success: function(response) {
                    var books = response; 
                    var bookListHtml = '';
                    
                    books.forEach(function(book) {
                        var bookLink = $("<a>").attr("href", "book_detail?bookId=" + book.id);

                        var bookDiv = $("<div>").addClass("book");
                        var bookImg = $("<img>").attr("src", book.imageUrl).attr("alt", book.bookName);
                        var bookName = $("<p>").text(book.bookName);

                        bookDiv.append(bookImg, bookName);
                        bookLink.append(bookDiv);

                        // Thêm liên kết vào danh sách sách
                        $('.book-list').append(bookLink);
                    });
                },
                error: function() {
                    alert('Không thể tải dữ liệu sách');
                }
            });
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
                <a class="status" href="bill">Hóa đơn</a>
                <a class="status" href="borrowing">Sách đang mượn</a>
                <a class="status active status" href="borrowed">Sách đã mượn</a>
            </div>
        </div>
        <div class="book-list">
            
        </div>
        <div class="pages">
            <a href="#">1</a>
            <a href="#">2</a>
            <a href="#">3</a>
            <a href="#">4</a>
            <a href="#">5</a>
        </div>
    </div>

</body>
</html>