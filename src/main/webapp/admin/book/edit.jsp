<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm sách</title>
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/edit.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

        <div class="form-box">
            <div class="title">Cập nhật sách</div>
            <form id = "bookForm" action="/api/book/save" method="POST" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="name">Tên sách</label>
                    <input type="text" name="name" required>
                </div>
                <div class="form-group">
                    <label for="author">Tác giả</label>
                    <input type="text" name="author" required>
                </div>
                <div class="form-group">
                    <label for="publisher">Nhà xuất bản</label>
                    <input type="text" name="publisher">
                </div>
                <div class="form-group">
                    <label for="yearOfpublication">Năm xuất bản</label>
                    <input type="text" name="yearOfpublication">
                </div>

                <div class="form-group">
                    <label for="categories">Thể loại</label>
                    <div id="categories-container"></div> <!-- Chứa các checkbox -->
                </div>                

                <div class="form-group">
                    <label for="quantity">Số lượng nhập thêm</label>
                    <input type="number" name="quantity" required>
                </div>

                <div class="form-group">
                    <label for="describe">Mô tả</label>
                    <input type="text" name="describe">
                </div>

                <div class="form-group">
                    <label for="image">Ảnh</label>
                    <img class="image-preview" src="#" alt="Ảnh hiện tại" style="display:none; margin-top:10px; max-width: 200px;"/>
                    <input type="hidden" name="currentImageUrl" value="">
                    <input type="file" name="image">
                </div>

                <div class="btn-group">
                    <button type="button" id="addBookBtn" class="btn btn-add" style="display: none;">Thêm sách</button>
                    <button type="button" id="updateBookBtn" class="btn btn-add" style="display: none;">Cập nhật sách</button>
                    <a class="btn btn-danger" href="/admin/book/list">Hủy</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            const urlParam = new URLSearchParams(window.location.search);
            const bookId = urlParam.get("id");

            $("#addBookBtn").show();
            $("#updateBookBtn").hide();

            if (bookId){
                $("#addBookBtn").hide();
                $("#updateBookBtn").show();

                $.ajax({
                    url: "/api/book/" + bookId,
                    type: "GET",
                    success: function(book) {
                        $("input[name='name']").val(book.bookName);
                        $("input[name='author']").val(book.author);
                        $("input[name='publisher']").val(book.publisher);
                        $("input[name='yearOfpublication']").val(book.yearOfpublication);
                        $("input[name='quantity']").val(0);
                        $("input[name='describe']").val(book.describe);

                        // Hiển thị ảnh nếu có
                        if (book.imageUrl) {
                            $(".image-preview").attr("src", book.imageUrl).show();
                            $("input[name='currentImageUrl']").val(book.imageUrl);
                        }

                        // Chọn thể loại đã có
                        book.categoriesOfBook.forEach(category => {
                            $("#cat-" + category.id).prop("checked", true);
                        });

                        
                    }
                })
            }

            $.ajax({
                url: "/api/categories/getCategories",
                type: "GET",
                success: function(categories) {
                    let categorySelect = $("#categories-container");
                    categorySelect.empty();

                    let row = $('<div class="checkbox-row"></div>');
                    categories.forEach((category, index) => {
                        console.log("Thêm thể loại: " + category.name);
                        let checkbox = 
                            '<div class="checkbox-group">' +
                                '<input type="checkbox" name="categories" value="' + category.id + '" id="cat-' + category.id + '">' +
                                '<label for="cat-' + category.id + '">' + category.name + '</label>' +
                            '</div>';
                        
                        row.append(checkbox);

                        // Mỗi 4 checkbox, tạo một dòng mới
                        if ((index + 1) % 4 === 0) {
                            categorySelect.append(row);
                            row = $('<div class="checkbox-row"></div>');
                        }
                    });

                    // Thêm dòng cuối nếu chưa đủ 4 checkbox
                    if (row.children().length > 0) {
                        categorySelect.append(row);
                    }
                },
                error: function(error) {
                    console.log("Lỗi khi lấy danh sách thể loại:", error);
                }
            });

            $("#addBookBtn").click(function(event) {
                event.preventDefault();

                var formData = new FormData($("#bookForm")[0]);
                $.ajax({
                    url: "/api/book/save",
                    type: "POST",
                    data: formData,
                    contentType: false,
                    processData: false,
                    success: function(response) {
                        alert("Thêm sách thành công!");
                        window.location.href = "/admin/book/list";
                    },
                    error: function(error) {
                        alert("Lỗi khi thêm sách!");
                    }
                });
            });

            $("#updateBookBtn").click(function(event) {
                event.preventDefault();

                var formData = new FormData($("#bookForm")[0]);
                $.ajax({
                    url: "/api/book/update/" + bookId,
                    type: "POST",
                    data: formData,
                    contentType: false,
                    processData: false,
                    success: function(response) {
                        alert("Cập nhật sách thành công!");
                        window.location.href = "/admin/book/list";
                    },
                    error: function(error) {
                        alert("Lỗi khi cập nhật sách!");
                    }
                });
            });
        });
        
    </script>
</body>
</html>
