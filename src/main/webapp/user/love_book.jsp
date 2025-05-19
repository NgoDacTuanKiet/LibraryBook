<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách yêu thích</title>
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/list_book_style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            let currentPage = 1;

            loadBooks();

            window.goToPage = function(page) {
                currentPage = page;
                loadBooks();
            }

            function loadBooks() {
                $.ajax({
                    url: "/api/favorite/list",
                    type: "GET",
                    data: {
                        pageSize: 10,
                        page: currentPage
                    },
                    dataType: "json",
                    success: function (response) {
                        let books = response.favoriteBooks;
                        let bookList = $(".book-list");
                        bookList.empty();

                        if (books.length === 0) {
                            bookList.append("<p>Không có sách yêu thích nào.</p>");
                        } else {
                            $.each(books, function (index, book) {
                    
                                let bookHtml = 
                                    '<div class="book">' +
                                        '<a href="book_detail?bookId=' + book.id + '">' + 
                                            '<img src="' + book.imageUrl + '" alt="' + book.bookName + '">' +
                                            '<p>' + book.bookName + '</p>' +
                                        '</a>' +
                                    '</div>';
                                bookList.append(bookHtml);
                            });
                        }
                        updatePagination(currentPage, response.totalPages);
                    },
                    error: function () {
                        $(".book-list").html("<p>Không thể tải danh sách yêu thích.</p>");
                    }
                });
            }

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
            <h1>Danh sách yêu thích</h1>
        </div>
        <div class="book-list">
            
        </div>
        <div id="pagination" class="pagination"></div>
    </div>

</body>
</html>