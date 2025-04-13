<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập</title>
    <link rel="stylesheet" href="CSS/signin_signup.css">
</head>
<body>
    <div class="login-container">
        <h2>Đăng nhập</h2>
        <form id="signin-form">
            <label for="username">Tài khoản</label>
            <input type="text" id="username" name="username" required>
            
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password" required>
            
            <p id="error-message" style="color: red;"></p>

            <button type="submit">Đăng nhập</button>
        </form>
        <p>Bạn chưa có tài khoản? <a href="signup">Đăng ký ngay</a></p>
    </div>

    <script>
        document.getElementById("signin-form").addEventListener("submit", async function(event) {
            event.preventDefault(); // Chặn form gửi đi mặc định

            let username = document.getElementById("username").value;
            let password = document.getElementById("password").value;
            let errorMessage = document.getElementById("error-message");

            // Gửi request đến API
            let response = await fetch("http://localhost:8080/api/user/login", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify({
                    username: username,
                    password: password
                })
            });

            let result = await response.json();

            if (response.ok) {
                // alert(result.message);
                
                if(result.role == "CUSTOMER"){
                    window.location.href = "home";
                } else{
                    window.location.href = "admin/account/list";
                }
            } else {
                errorMessage.textContent = result.message; // Hiển thị lỗi từ API
            }
        });
    </script>
</body>
</html>
