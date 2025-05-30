<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân</title>
    <link rel="stylesheet" href="/CSS/header_style.css">
    <link rel="stylesheet" href="/CSS/account.css">
    <link rel="stylesheet" href="/CSS/comment.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function () {
            // Lấy bookId từ URL
            const urlParams = new URLSearchParams(window.location.search);
            const bookId = urlParams.get('bookId');
            
            if (bookId) {

                loadComments(bookId);

                $.ajax({
                    url: "/api/book/" + bookId,
                    type: "GET",
                    dataType: "json",
                    success: function (book) {
                        $("#bookImage").attr("src", book.imageUrl);
                        $("#bookName").text(book.bookName);
                        $("#author").text(book.author);
                        $("#publisher").text(book.publisher);
                        $("#yearOfpublication").text(book.yearOfpublication);
                        $("#availableQuantity").text(book.availableQuantity);
                        $("#describe").text(book.describe);

                        checkFavoriteStatus(bookId);
                    },
                    error: function () {
                        alert("Không tìm thấy sách!");
                        window.location.href = "/list_book";
                    }
                });
            } else {
                alert("Thiếu bookId!");
                window.location.href = "/list_book";
            }
            
            $("#loveBtn").click(function(event) {
                event.preventDefault();

                $.ajax({
                    url: "api/favorite/toggle/" + bookId,
                    type: "POST",
                    contentType: "application/json",
                    success: function (response) {
                        checkFavoriteStatus(bookId);
                        alert("Đã thêm vào danh mục yêu thích!");
                    },
                    error: function (xhr) {
                        alert("Lỗi: Không thể thêm vào danh mục yêu thích.");
                    }
                });
            })

            $("#unLoveBtn").click(function(event) {
                event.preventDefault();

                $.ajax({
                    url: "/api/favorite/toggle/" + bookId,
                    type: "POST",
                    contentType: "application/json",
                    success: function (response) {
                        checkFavoriteStatus(bookId);
                        alert("Đã xóa khỏi danh mục yêu thích!");
                    },
                    error: function (xhr) {
                        alert("Lỗi: Không thể xóa khỏi danh mục yêu thích.");
                    }
                });
            })

            $("#addToCartBtn").click(function() {
                $.ajax({
                    url: "/api/cart/add/" + bookId,
                    type: "POST",
                    contentType: "application/json",
                    success: function (response) {
                        alert(response.message);
                    },
                    error: function (xhr, status, error) {
                        let response = JSON.parse(xhr.responseText);
                        alert(response.message);
                    }
                })
            })

            $("#submitComment").click(function() {
                const content = $("#commentContent").val().trim();
                if (content) {
                    $.ajax({
                        url: "/api/comment/" + bookId,
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ content: content }),
                        success: function() {
                            loadComments(bookId);
                            $("#commentContent").val("");
                        },
                        error: function() {
                            alert("Hãy đăng nhập trước!");
                        }
                    });
                }
            });

            $(document).on("click", ".comment-action", function (event) {
                event.stopPropagation(); // Ngăn chặn sự kiện lan ra ngoài
                let menu = $(this).siblings(".action-menu"); 
                $(".action-menu").not(menu).hide(); // Ẩn các menu khác
                menu.toggle(); // Hiện hoặc ẩn menu của bình luận được nhấn
            });

            // Ẩn menu nếu click ra ngoài
            $(document).on("click", function () {
                $(".action-menu").hide();
            });

            let editingCommentId = null;

            // Mở modal khi nhấn nút "Sửa"
            $(document).on("click", ".edit-comment", function () {
                const commentItem = $(this).closest(".comment-item");
                editingCommentId = commentItem.data("id");
                const content = commentItem.find("p").eq(1).text();

                $("#editCommentContent").val(content);
                $("#editCommentModal").show();
            });

            // Đóng modal
            $(".close").click(function () {
                $("#editCommentModal").hide();
                editingCommentId = null;
            });

            $(window).click(function (event) {
                if (event.target.id === "editCommentModal") {
                    $("#editCommentModal").hide();
                    editingCommentId = null;
                }
            });

            // Lưu chỉnh sửa
            $("#saveEditedComment").click(function () {
                const newContent = $("#editCommentContent").val().trim();
                if (newContent && editingCommentId) {
                    $.ajax({
                        url: "/api/comment/edit",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ id: editingCommentId, content: newContent }),
                        success: function () {
                            $("#editCommentModal").hide();
                            editingCommentId = null;
                            loadComments(bookId); // load lại danh sách
                        },
                        error: function () {
                            alert("Lỗi khi chỉnh sửa bình luận!");
                        }
                    });
                }
            });

            // Xóa bình luận
            $(document).on("click", ".delete-comment", function () {
                const commentItem = $(this).closest(".comment-item");
                const commentId = commentItem.data("id");

                if (confirm("Bạn có chắc chắn muốn xóa bình luận này?")) {
                    $.ajax({
                        url: "/api/comment/delete",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ id: commentId }),
                        success: function () {
                            loadComments(bookId);
                        },
                        error: function () {
                            alert("Lỗi khi xóa bình luận!");
                        }
                    });
                }
            });

        });

        function formatDateTime(isoString) {
            let date = new Date(isoString);
            return date.toLocaleString("vi-VN", {
                hour: '2-digit', minute: '2-digit', 
                day: '2-digit', month: '2-digit', year: 'numeric'
            });
        }

        function loadComments(bookId) {
            $.ajax({
                url: "/api/comment/list/" + bookId,
                type: "GET",
                success: function(commentDTO) {
                    commentDTO.comments.sort((a, b) => new Date(b.time) - new Date(a.time));

                    let html = "";
                    
                    commentDTO.comments.forEach(comment => {
                        let formattedTime = formatDateTime(comment.time);

                        html += 
                        '<div class="comment-item" data-id="' + comment.id + '">' +
                            '<p><strong>' + comment.username + '</strong> - ' + formattedTime + '</p>' +
                            '<p>' + comment.content + '</p>';

                        if (commentDTO.user && commentDTO.user.username === comment.username){
                            html += 
                                '<button class="comment-action">⋮</button>' +
                                '<div class="action-menu">' +
                                    '<button class="edit-comment">Sửa</button>' +
                                    '<button class="delete-comment">Xóa</button>' +
                                '</div>';
                        }
                        html += '</div>';
                    });
                    $("#comments-list").html(html);
                },
                error: function() {
                    console.error("Lỗi khi tải bình luận");
                }
            });
        }

        function checkFavoriteStatus(bookId) {
            $.ajax({
                url: "/api/favorite/check/" + bookId,
                type: "GET",
                success: function (isFavorited) {
                    if (isFavorited) {
                        $("#addToCartBtn").show();
                        $("#unLoveBtn").show();
                        $("#loveBtn").hide();
                    } else {
                        $("#addToCartBtn").show();
                        $("#unLoveBtn").hide();
                        $("#loveBtn").show();
                    }
                },
                error: function () {
                    console.error("Lỗi khi kiểm tra trạng thái yêu thích.");
                }
            });
        }

        function goBack() {
            if (document.referrer) {
                window.location.href = document.referrer;
            } else {
                window.location.href = "home";
            }
        }
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

    <a href="#" class="back-btn" onclick="goBack()">Back</a>
    <!-- Thông tin sách -->
    <div class="profile-container">
        <div class="profile-card">
            <img id="bookImage" src="" alt="Book" class="book">
            <div class="info-container">
                <div class="info">
                    <p><strong>Tên:</strong> <span id="bookName"></span></p>
                    <p><strong>Tác giả:</strong> <span id="author"></span></p>
                    <p><strong>Nhà xuất bản:</strong> <span id="publisher"></span></p>
                    <p><strong>Năm xuất bản:</strong> <span id="yearOfpublication"></span></p>
                    <p><strong>Số lượng:</strong> <span id="availableQuantity"></span></p>
                    <p><strong>Mô tả:</strong> <span id="describe"></span></p>
                </div>
                <div class="button-group">
                    <button class="btn" id="loveBtn" style="display: none;">Yêu thích</button>
                    <button class="btn" id="unLoveBtn" style="display: none;">Bỏ yêu thích</button>
                    <button class="btn" id="addToCartBtn" style="display: none;">Thêm vào giỏ</button>
                </div>
            </div>
        </div>
    </div>

    <div class="comments-container">
        <h3>Bình luận</h3>
        <div class="add-comment">
            <textarea id="commentContent" placeholder="Nhập bình luận..."></textarea>
            <button id="submitComment">Gửi</button>
        </div>
        <div id="comments-list">
            <!-- Bình luận sẽ được load vào đây -->
        </div>
        
        
    </div>
    <div id="editCommentModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h3>Sửa bình luận</h3>
            <textarea id="editCommentContent" placeholder="Nhập nội dung mới..."></textarea>
            <button id="saveEditedComment">Lưu</button>
        </div>
    </div>
</body>
</html>
