<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tủ sách</title>
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/list_book_style.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
            loadBooks();

            function renderBooks(books) {
                var bookList = $("#book-list");
                bookList.empty(); // Xóa danh sách cũ

                if (books.length === 0) {
                    bookList.append("<p>Không tìm thấy sách nào!</p>");
                    return;
                }

                books.forEach(function (book) {
                    var bookDiv = $("<div>").addClass("book");
                    var bookLink = $("<a>").attr("href", "book_detail?bookId=" + book.id);
                    var bookImage = $("<img>").attr("src", book.imageUrl).attr("alt", book.bookName);
                    var bookTitle = $("<p>").text(book.bookName);

                    bookLink.append(bookImage);
                    bookDiv.append(bookLink);
                    bookDiv.append(bookTitle);
                    bookList.append(bookDiv);
                });
            }

            function loadBooks() {
                const bookName = $("#bookName").val();
                const author = $("#author").val();
                const publisher = $("#publisher").val();

                let selectedCategories = [];
                $("input[name='categories']:checked").each(function () {
                    selectedCategories.push($(this).val());
                });

                $.ajax({
                    url: "/api/book/search",
                    method: "GET",
                    traditional: true, // quan trọng để gửi list
                    data: {
                        bookName: bookName,
                        author: author,
                        publisher: publisher,
                        categories: selectedCategories
                    },
                    dataType: "json",
                    success: function (books) {
                        renderBooks(books)
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi tải danh sách sách:", error);
                    }
                });
            }

            $("#searchBtn").click(function () {
                loadBooks();
            });

            $.ajax({
                url: "/api/categories",
                type: "GET",
                success: function(categories) {
                    let categorySelect = $("#categories-container");
                    categorySelect.empty();

                    let row = $('<div class="checkbox-row"></div>');
                    categories.forEach((category, index) => {
                        let checkbox = 
                            '<div class="checkbox-group">' +
                                '<input type="checkbox" name="categories" value="' + category.id + '" id="cat-' + category.id + '">' +
                                '<label for="cat-' + category.id + '">' + category.name + '</label>' +
                            '</div>';
                        
                        row.append(checkbox);

                        if ((index + 1) % 7 === 0) {
                            categorySelect.append(row);
                            row = $('<div class="checkbox-row"></div>');
                        }
                    });

                    if (row.children().length > 0) {
                        categorySelect.append(row);
                    }
                },
                error: function(error) {
                    console.log("Lỗi khi lấy danh sách thể loại:", error);
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
            <h1>Tủ sách</h1>
        </div>

        <!-- Phần tìm kiếm -->
        <div class="search-container">
            <h2>Tìm kiếm sách</h2>
            <div class="search-box">
                <div class="input-row">
                    <input type="text" id="bookName" placeholder="Tên sách">
                    <input type="text" id="author" placeholder="Tên tác giả">
                    <input type="text" id="publisher" placeholder="Nhà xuất bản">
                </div>
                <div class="category-row">
                    <label>Thể loại:</label>
                    <div id="categories-container" class="checkbox-container"></div>
                </div>
            </div>
            <button class="btn" id="searchBtn">Tìm kiếm</button>
        </div>

        <!-- Danh sách sách -->
        <div class="book-list" id="book-list">
            <!-- Dữ liệu sách sẽ được thêm vào đây -->
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
