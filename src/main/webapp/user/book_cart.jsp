<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách sách</title>
    <link rel="stylesheet" href="/../CSS/header_style.css">
    <link rel="stylesheet" href="/../CSS/book_cart.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
        function getListBook() {
            $.ajax({
                url: "/api/cart/list",
                type: "GET",
                dataType: "json",
                success: function(cartDetails) {
                    renderBooks(cartDetails);
                },
                error: function (xhr, status, error) {
                    console.error("Lỗi khi tải danh sách sách:", error);
                }
            });
        }

        function renderBooks(cartDetails) {

            let bookList = $(".book-list");
            bookList.empty();

            if (!Array.isArray(cartDetails) || cartDetails.length === 0) {
                bookList.append("<p>Không có sách nào trong giỏ hàng</p>");
                return;
            }
            cartDetails.forEach(function (cartDetail) {

                let bookCard = $("<div>").addClass("book-card");
                let deleteBtn = $("<span>")
                    .text("X")
                    .addClass("close-btn")
                    .click(function () {
                        deleteCartDetail(cartDetail.id);
                    });

                let bookImg = $("<img>")
                    .attr("src", cartDetail.book.imageUrl)
                    .attr("alt",cartDetail.book.bookName);

                let bookInfo = $("<div>").addClass("book-info");
                
                let bookName = $("<p>").html("<strong>Tên : </strong>" + cartDetail.book.bookName);
                let bookAuthor = $("<p>").html("<strong>Tác giả : </strong>" + cartDetail.book.author);
                let bookPublisher = $("<p>").html("<strong>Nhà xuất bản : </strong>" + cartDetail.book.publisher);
                let bookYearOfpublication = $("<p>").html("<strong>Năm xuất bản : </strong>" + cartDetail.book.yearOfpublication);
                let bookAvailableQuantity = $("<p>").html("<strong>Số lượng khả dụng : </strong>" + cartDetail.book.availableQuantity);
            
                let quantityLabel = $("<p>").html("<strong>Số lượng:</strong> ");
                let quantityInput = $("<input>")
                    .attr("type", "number")
                    .addClass("quantity")
                    .val(cartDetail.quantity)
                    .attr("min", 0)
                    .attr("max", cartDetail.book.availableQuantity);
                
                let updateBtn = $("<button>")
                    .text("Cập nhật")
                    .addClass("update-btn")
                    .click(function () {
                        updateQuantity(cartDetail.id, quantityInput.val());
                    });

                quantityLabel.append(quantityInput, updateBtn);
                bookInfo.append(bookName, bookAuthor, bookPublisher, bookAvailableQuantity, quantityLabel);
                bookCard.append(deleteBtn, bookImg, bookInfo);

                bookList.append(bookCard);
            });
        }

        function deleteCartDetail(cartDetailId) {
            $.ajax({
                url: "/api/cart/remove/" + cartDetailId,
                type: "POST",
                success: function (response) {
                    console.log("Xóa thành công:", response);
                    getListBook();
                },
                error: function (xhr, status, error) {
                    console.error("Lỗi khi xóa sách khỏi giỏ hàng:", error);
                    alert("Xóa sách thất bại. Vui lòng thử lại!");
                }
            });
        }
        function updateQuantity(cartDetailId, newQuantity) {
            $.ajax({
                url: "/api/cart/update/" + cartDetailId,
                type: "POST",
                contentType: "application/json",
                data: JSON.stringify({
                    "newQuantity": newQuantity
                }),
                success: function (response) {
                    console.log("Cập nhật thành công:", response);
                    getListBook();
                },
                error: function (xhr, status, error) {
                    getListBook();
                    let response = JSON.parse(xhr.responseText);
                    alert(response.message);
                }
            });
        }
        $(".borrow-btn").click(function () {
            $.ajax({
                url: "/api/borrow/borrowaction",
                type: "POST",
                success: function (response) {
                    alert(response.message);
                    getListBook();
                },
                error: function (xhr, status, error) {
                    let response = JSON.parse(xhr.responseText);
                    alert(response.message);
                }
            });
        });

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

    <div class="cart-container">
        <h2 class="cart-title">Giỏ hàng</h2>
        <div class="book-list">

        </div>
        <button class="borrow-btn">Mượn sách</button>
    </div>
</body>
</html>
