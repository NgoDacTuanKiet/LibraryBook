<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Thể Loại</title>
    <link rel="stylesheet" href="/CSS/manage.css">
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/edit.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
            let currentPage = 1;

            loadCategories();
            checkEditCategory();

            window.goToPage = function(page) {
                currentPage = page;
                loadCategories();
                checkEditCategory();
            }

            $("#saveCategoryBtn").click(function () {
                saveCategory();
            });

            function loadCategories() {
                $.ajax({
                    url: "/api/categories",
                    type: "GET",
                    data: {
                        pageSize: 6,
                        page: currentPage
                    },
                    dataType: "json",
                    success: function (response) {
                        categories = response.categories;
                        let tableBody = $(".category-table tbody");
                        tableBody.empty();

                        categories.forEach(function (category) {
                            let row = $("<tr>");
                            let nameCell = $("<td>").text(category.name);
                            let actionCell = $("<td>");
                            
                            let actionBtn = $("<div>").addClass("actionBtn");

                            let editBtn = $("<button>")
                                .text("Sửa")
                                .addClass("btn btn-primary")
                                .click(function () {
                                    window.location.href = "/admin/category/edit?id=" + category.id;
                                });

                            let deleteBtn = $("<button>")
                                .text("Xóa")
                                .addClass("btn btn-danger")
                                .click(function () {
                                    deleteCategory(category.id);
                                });
                            
                            actionBtn.append(editBtn, deleteBtn)
                            actionCell.append(actionBtn);
                            row.append(nameCell, actionCell);
                            tableBody.append(row);
                        });
                        updatePagination(currentPage, response.totalPages);
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi tải danh sách thể loại:", error);
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

            function saveCategory() {
                let categoryName = $("#category_name").val().trim();
                let categoryId = $("#saveCategoryBtn").attr("data-id") || null;

                if (categoryName === "") {
                    alert("Tên thể loại không được để trống!");
                    return;
                }

                $.ajax({
                    url: "/api/categories/save",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({ id: categoryId, name: categoryName }),
                    success: function () {
                        window.location.href = "/admin/category/edit"; // Reset về trang chính
                    },
                    error: function (xhr, status, error) {
                        alert(xhr.responseJSON.message);
                        console.error("Lỗi khi lưu thể loại:", error);
                    }
                });
            }

            function deleteCategory(id) {
                if (!confirm("Bạn có chắc muốn xóa thể loại này?")) return;

                $.ajax({
                    url: "/api/categories/" + id,
                    type: "DELETE",
                    success: function () {
                        console.log("Đã xóa thể loại ID:", id);
                        loadCategories();
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi xóa thể loại:", error);
                    }
                });
            }

            function checkEditCategory() {
                const urlParams = new URLSearchParams(window.location.search);
                const categoryId = urlParams.get("id");

                if (categoryId) {
                    $.ajax({
                        url: "/api/categories/" + categoryId,
                        type: "GET",
                        success: function (category) {
                            $("#category_name").val(category.name);
                            $("#saveCategoryBtn").attr("data-id", category.id);
                        },
                        error: function (xhr, status, error) {
                            console.error("Lỗi khi lấy thông tin thể loại:", error);
                        }
                    });
                }
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
            <div class="title">Thêm thể loại</div>
            <div class="form-group">
                <label for="category_name">Tên thể loại</label>
                <input type="text" id="category_name">
            </div>
            <div class="btn-group">
                <button class="btn btn-add" id="saveCategoryBtn">Lưu thể loại</button>
                <a class="btn btn-danger" href="edit">Hủy</a>
            </div>
        </div>
        
        <div class="list-box">
            <div class="title">Danh sách thể loại</div>
            <table class="category-table">
                <thead>
                    <tr>
                        <!-- <th>id</th> -->
                        <th>Tên thể loại</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Dữ liệu thể loại sẽ được tải bằng JavaScript -->
                </tbody>
            </table>
            <div id="pagination" class="pagination"></div>
        </div>
    </div>
</body>
</html>
