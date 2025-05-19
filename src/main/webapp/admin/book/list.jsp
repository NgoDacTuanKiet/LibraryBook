<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Management</title>
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/searchBox.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            let currentPage = 1;

            loadBooks();

            window.goToPage = function(page) {
                currentPage = page;
                loadBooks();
            }

            $("#searchBtn").click(function() {
                currentPage = 1;
                loadBooks();
            });

            function loadBooks() {
                const bookName = $("#bookName").val();
                const author = $("#author").val();
                const publisher = $("#publisher").val();
                const pageSize = $("#pageSize").val();

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
                        categories: selectedCategories,
                        pageSize: pageSize,
                        page: currentPage
                    },
                    dataType: "json",
                    success: function (response) {
                        let books = response.books;
                        let tableBody = $(".table tbody");
                        tableBody.empty();
                        
                        if(books.length === 0) {
                            tableBody.append("<p>").append("Không có sách nào!");
                                return;
                        }

                        $.each(books, function (index, book) {
                            let categories = book.categoriesOfBook
                                ? book.categoriesOfBook.map(category => category.name).join(", ")
                                : "Không có thể loại";

                            let row = 
                                "<tr>" +
                                    "<td>" + book.id + "</td>" +
                                    "<td>" + book.bookName + "</td>" +
                                    "<td>" + book.author + "</td>" +
                                    "<td>" + book.publisher + "</td>" +
                                    "<td>" + book.yearOfpublication + "</td>" +
                                    "<td>" + categories + "</td>" +
                                    "<td>" + book.quantity + "</td>" +
                                    "<td>" + book.availableQuantity + "</td>" +
                                    "<td class='actions'>" +
                                        "<a href='edit?id=" + book.id + "'><img src='/khac/pencil-icon.png' alt='Sửa'></a>" +
                                        "<img src='/khac/delete.png' alt='Xóa' onclick='deleteBook(" + book.id + ")'>" +
                                    "</td>" +
                                "</tr>";
                            
                            tableBody.append(row);
                        });
                        updatePagination(currentPage, response.totalPages);
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi tải danh sách sách:", error);
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

            window.deleteBook = function (id) {
                if (!confirm("Bạn có chắc muốn xóa sách này?")) return;

                $.ajax({
                    url: "/api/book/delete/" + id,
                    method: "POST",
                    success: function () {
                        loadBooks();
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi xóa sách:", error);
                    }
                });
            };

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

                        // Mỗi 3 checkbox, tạo một dòng mới
                        if ((index + 1) % 3 === 0) {
                            categorySelect.append(row);
                            row = $('<div class="checkbox-row"></div>');
                        }
                    });

                    // Thêm dòng cuối nếu chưa đủ 3 checkbox
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
            <h2>Tìm kiếm sách</h2>
            <div class="search-container">
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
                <div class="pagination-control">
                    <label for="pageSize">Kích thước trang:</label>
                    <select id="pageSize">
                        <option value="10" selected>10</option>
                        <option value="20">20</option>
                        <option value="50">50</option>
                    </select>
                </div>  
                <button class="btn" id="searchBtn">Tìm kiếm</button>
            </div>
            <div class="info">
                <h2>Bảng danh sách sách</h2>
                <a href="edit" class="btn">Thêm sách</a>
            </div>
            <table class="table">
                <thead>
                    <tr>
                        <th>Mã sách</th>
                        <th>Tên sách</th>
                        <th>Tác giả</th>
                        <th>Nhà xuất bản</th>
                        <th>Năm xuất bản</th>
                        <th>Thể loại</th>
                        <th>Số lượng</th>
                        <th>Có sẵn</th>
                        <th style="min-width: 120px;">Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Dữ liệu sẽ được tải bằng JavaScript -->
                </tbody>
            </table>
            <div id="pagination" class="pagination"></div>
        </div>
    </div>
</body>
</html>
