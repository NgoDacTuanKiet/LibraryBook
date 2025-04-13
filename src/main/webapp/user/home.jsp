<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thư viện sách</title>
    <link rel="stylesheet" href="/../CSS/header_style.css">
    <link rel="stylesheet" href="/../CSS/home_style.css">
    <link rel="stylesheet" href="/../CSS/footer_style.css">
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
        <div class="content-box">
            <h2>Đọc được nhiều sách hơn và đọc tốt hơn với Thư viện sách</h2>
            <p>
                Bạn thích đọc sách giấy nhưng vẫn còn gặp phải nhiều khó khăn: không biết nên chọn tựa sách nào, mua ở đâu, 
                sách có phải sách thật hay không, giá cả thế nào, bảo quản ra sao hoặc nếu không có nhu cầu đọc nữa thì bán lại cho ai? 
            </p>
            <p>
                <strong>Thư viện sách</strong> giúp bạn dễ dàng tiếp cận với kho sách khổng lồ mà không cần phải lo lắng về chi phí mua sách. 
                Bạn có thể thuê sách, đọc thử trước khi mua hoặc chia sẻ sách với cộng đồng.
            </p>
            <p>
                Chúng tôi mang đến một trải nghiệm đọc sách tiện lợi, tiết kiệm và thân thiện với môi trường. 
                Cùng khám phá hàng ngàn cuốn sách và tận hưởng niềm vui đọc mỗi ngày! 📚✨
            </p>
        </div>
    </div>

    <!-- logo -->
    <img src="/khac/logo.webp" alt="LibraryBook Logo" class="logo">

    <!-- slogan -->
    <div class="feature">
        <div class="feature-item">
            <img src="/khac/doc_sach_khong_gioi_han.webp" alt="Đọc sách không giới hạn">
            <div class="feature-text">
                <h2>Đọc sách không giới hạn</h2>
                <p>Thoải mái đọc như sách của bạn: Không giới hạn số ngày giữ sách, không phí phạt chậm trả.</p>
            </div>
        </div>
    
        <div class="feature-item">
            <div class="feature-text">
                <h2>Đọc sách không nhìn giá</h2>
                <p>Không phải canh sales, tính giá bán hay giá thuê: phí thành viên tại Thư viện sách là cố định và cực kì hợp lý.</p>
            </div>
            <img src="/khac/đọc sách không nhìn giá.webp" alt="Đọc sách không nhìn giá">
            
        </div>
    
        <div class="feature-item">
            <img src="/khac/doc_sach_chat_luong.webp" alt="Đọc sách chất lượng">
            <div class="feature-text">
                <h2>Đọc sách chất lượng</h2>
                <p>Tủ sách hàng tuyển: Libri chọn lựa rất kỹ tựa sách khi nhập về, bạn hoàn toàn có thể tin tưởng vào chất lượng kiến thức nạp vào.</p>
            </div>
        </div>
    
        <div class="feature-item">
            <div class="feature-text">
                <h2>Trải nghiệm miễn phí</h2>
                <p>Bạn sẽ có 2 tháng để làm quen: không tính phí thành viên, đọc rồi trả lại không tham gia cũng không sao.</p>
            </div>
            <img src="/khac/trải nghiệm miễn phí.webp" alt="Trải nghiệm miễn phí">
            
        </div>
    </div>
    
    <!-- footer -->
    <footer class="footer">
        <div class="footer-container">
            <div class="text-box">
                <p><strong>Cơ sở:</strong></p>
                <p>79 Phan Chu Trinh, Yết Kiêu, Hà Đông, Hà Nội</p>
            </div>
            <div class="text-box">
                <p><strong>Liên hệ Thư Viện sách:</strong></p>
                <p><strong>Số điện thoại:</strong> <a href="tel:0988265438">0988265438</a></p>
                <p><strong>Email:</strong> <a href="mailto:librarybook@gmail.com">librarybook@gmail.com</a></p>
            </div>
        </div>
    </footer>
</body>
</html>
