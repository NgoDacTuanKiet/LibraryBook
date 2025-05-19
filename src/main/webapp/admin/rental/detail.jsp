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
            const customerId = urlParams.get('customerId');

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
                    
                    let book = JSON.parse(checkbox.attr("data-book"));
                    let quantity = parseInt(row.find(".return-quantity").val()) || 0;
                    let punishCost = parseInt(row.find(".punish-cost").val()) || 0;
                    let max = parseInt(checkbox.data("quantity"));

                    if (quantity > max) {
                        alert("Số lượng trả sách " + book.bookName +  " không được vượt quá " + max);
                        quantityInput.focus();
                        isValid = false;
                        return false;
                    }

                    let paymentDTO = {
                        book: book,
                        bookLoanDate: checkbox.data("book-loan-date"),
                        dueDate: checkbox.data("due-date"),
                        quantity: quantity,
                        punishCost: punishCost,
                        reason: row.find(".reason").val() || "Không có",
                        total: punishCost + quantity*10000
                    };

                    paymentList.push(paymentDTO);
                });

                if (paymentList.length === 0) {
                    alert("Vui lòng chọn ít nhất một sách để thanh toán.");
                    return;
                }

                $.ajax({
                    url: "/api/payment/new/detail/" + customerId,
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(paymentList),
                    success: function (response) {
                        window.location.href = "payment?customerId=" + customerId;
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi khi gửi dữ liệu thanh toán:", error);
                    }
                });
            });
            
            function loadBorrowingBooks() {
                $.ajax({
                    url: "/api/borrow/borrowing/book/list/" + customerId,
                    type: "GET",
                    dataType: "json",
                    success: function (borrowingBooks) {
                        let tableBody = $(".table tbody");
                        tableBody.empty(); 

                        $.each(borrowingBooks, function (index, borrowingBook) {
                            let categories = borrowingBook.book.categoriesOfBook
                                ? borrowingBook.book.categoriesOfBook.map(category => category.name).join(", ")
                                : "Không có thể loại";
                            
                                let row = $("<tr>");

                                let checkbox = $("<input>", {
                                    type: "checkbox",
                                    name: "borrowingBook",
                                    id: "bor-" + borrowingBook.id,
                                    value: borrowingBook.id,
                                    "data-book": JSON.stringify(borrowingBook.book),
                                    "data-book-loan-date": borrowingBook.bookLoanDate,
                                    "data-due-date": borrowingBook.dueDate,
                                    "data-quantity": borrowingBook.quantity
                                });

                                row.append($("<td>").append(checkbox));
                                row.append($("<td>").text(borrowingBook.book.id));
                                row.append($("<td>").text(borrowingBook.book.bookName));
                                row.append($("<td>").text(borrowingBook.book.author));
                                row.append($("<td>").text(borrowingBook.quantity));
                                row.append($("<td>").text(formatDateTime(borrowingBook.bookLoanDate)));
                                row.append($("<td>").text(formatDateTime(borrowingBook.dueDate)));

                                row.append($("<td>").append(
                                    $("<input>", {
                                        type: "number",
                                        class: "return-quantity",
                                        min: 0,
                                        max: borrowingBook.quantity,
                                        value: 0
                                    })
                                ));

                                row.append($("<td>").append(
                                    $("<input>", {
                                        type: "number",
                                        class: "punish-cost",
                                        min: 0,
                                        value: 0
                                    })
                                ));

                                row.append($("<td>").append(
                                    $("<input>", {
                                        type: "text",
                                        class: "reason",
                                        placeholder: "Lý do nếu có"
                                    })
                                ));

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
                    url: "/api/user/" + customerId,
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
