<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin cá nhân</title>
    <link rel="stylesheet" href="/../CSS/header_style.css">
    <link rel="stylesheet" href="/../CSS/account.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script>
        $(document).ready(function() {
            const avatar = document.getElementById('avatar');
            const imageInput = document.getElementById('imageInput');

            avatar.addEventListener('click', () => {
                imageInput.click();
            });

            imageInput.addEventListener('change', (event) => {
                const file = event.target.files[0];
                if (file) {
                    const imageURL = URL.createObjectURL(file);
                    avatar.src = imageURL;
                }
            });

            loadInformation();

            function loadInformation(){
                $.ajax({
                    url: "/api/user/information",
                    method: "GET",
                    dataType: "json",
                    xhrFields: { withCredentials: true },
                    success: function(user) {

                        if ($.isEmptyObject(user)) {
                            alert("Bạn chưa đăng nhập!");
                            window.location.href = "/signin"; // Chuyển hướng đến trang đăng nhập
                        } else {
                            $(".avatar").attr("src", user.imageUrl || "/khac/avatar.jpg");

                            // Gán giá trị vào input sử dụng thuộc tính name
                            $("[name='username']").val(user.username || "");
                            $("[name='fullName']").val(user.fullName || "");
                            $("[name='email']").val(user.email || "");
                            $("[name='phoneNumber']").val(user.phoneNumber || "");
                            $("[name='address']").val(user.address || "");
                        }
                    },
                    error: function() {
                        alert("Lỗi tải thông tin người dùng!");
                    }
                })
            }

            $("#updateUserBtn").click(function (event) {
                event.preventDefault();
                
                let userData = {
                    username: $("input[name='username']").val(),
                    fullName: $("input[name='fullName']").val(),
                    phoneNumber: $("input[name='phoneNumber']").val(),
                    email: $("input[name='email']").val(),
                    address: $("input[name='address']").val()
                }

                $.ajax({
                    url: "/api/user/setprofile",
                    method: "POST",
                    contentType: "application/json",
                    data: JSON.stringify(userData),
                    dataType: "json",
                    success: function (response) {
                        alert("Cập nhật thông tin thành công!");
                        loadInformation();
                        console.log("Server response:", response);
                    },
                    error: function (xhr, status, error) {
                        console.error("Lỗi cập nhật:", xhr.responseText);
                        
                        let errorMessage = "Cập nhật thất bại! Kiểm tra lại thông tin.";
                        
                        if (xhr.responseText) {
                            errorMessage = xhr.responseText; // Lấy thông báo lỗi từ server
                        }
                        loadInformation();
                        alert(errorMessage);
                    }
                });
            });

            $("#updateAvatarBtn").click(function (e) {
                e.preventDefault();
                
                const formData = new FormData($("#avatarForm")[0]);

                $.ajax({
                    url: "/api/user/update-avatar",  // URL xử lý riêng ảnh
                    type: "POST",
                    data: formData,
                    contentType: false,
                    processData: false,
                    success: function (response) {
                        if (response.imageUrl) {
                            $(".avatar").attr("src", response.imageUrl);
                        }
                        loadInformation();
                        alert("Cập nhật ảnh thành công!");
                        
                    },
                    error: function () {
                        alert("Lỗi khi cập nhật ảnh!");
                    }
                });
            });
        })
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

    <!-- Thông tin cá nhân -->
    <div class="profile-container">
        <div class="profile-card">
            <!-- <img alt="Avatar" class="avatar"> -->
            <form id="avatarForm" enctype="multipart/form-data">
                <div class="form-group">
                    <img class="avatar" id="avatar" alt="Avatar"/>
                    <input type="file" name="image" id="imageInput" accept="image/*" required style="display: none;">
                </div>
                <button type="button" id="updateAvatarBtn" class="btn btn-add">Cập nhật ảnh</button>
            </form>

            <div class="info-container">
                <div class="info">
                    <p><strong>Tài khoản: </strong> <input type="text" name = "username" readonly></p>
                    <p><strong>Họ và tên: </strong> <input type="text" name="fullName"></p>
                    <p><strong>Email: </strong> <input type="text" name="email"></p> 
                    <p><strong>Số điện thoại: </strong> <input type="text" name="phoneNumber"></p>
                    <p><strong>Địa chỉ: </strong> <input type="text" name="address"></p>
                </div>
                <div class="button-group">
                    <button class="btn" id="updateUserBtn">Cập nhật thông tin</button>
                    <a href="change_password" class="btn">Đổi mật khẩu</a>
                </div>
            </div>
        </div>
    </div>

</body>
</html>
