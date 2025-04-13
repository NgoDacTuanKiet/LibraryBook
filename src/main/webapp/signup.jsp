<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký</title>
    <link rel="stylesheet" href="CSS/signin_signup.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
    <div class="login-container">
        <h2>Đăng ký</h2>
        <form id="signup-form">
            <label for="username">Tài khoản</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password" required>

            <label for="confirm-password">Xác nhận mật khẩu</label>
            <input type="password" id="confirm-password" name="confirm-password" required>

            <p id="error-message" style="color: red;"></p>

            <button type="submit">Đăng ký</button>
        </form>
        <p>Đã có tài khoản? <a href="signin">Đăng nhập ngay</a></p>
    </div>

    <script>
        $(document).ready(function () {
            $("#signup-form").submit(function (event) {
                event.preventDefault(); // Chặn form gửi đi mặc định
    
                let username = $("#username").val();
                let password = $("#password").val();
                let confirmPassword = $("#confirm-password").val();
                let errorMessage = $("#error-message");
    
                // Kiểm tra mật khẩu nhập lại có khớp không
                if (password !== confirmPassword) {
                    errorMessage.text("Mật khẩu xác nhận không khớp!");
                    return; // Dừng lại, không gửi request
                } else {
                    errorMessage.text(""); // Xóa lỗi nếu nhập đúng
                }
    
                // Gửi request đến API bằng jQuery AJAX
                $.ajax({
                    url: "/api/user/add",
                    type: "POST",
                    contentType: "application/json",
                    data: JSON.stringify({
                        username: username,
                        password: password,
                        role: "CUSTOMER"
                    }),
                    success: function (response) {
                        alert("Đăng ký thành công!");
                        window.location.href = "signin"; // Chuyển hướng sau khi đăng ký thành công
                    },
                    error: function (xhr) {
                        let result = xhr.responseJSON ? xhr.responseJSON.message : "Lỗi không xác định!";
                        errorMessage.text(result); // Hiển thị lỗi từ API
                    }
                });
            });
        });
    </script>
</body>
</html>
