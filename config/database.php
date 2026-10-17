<?php
// config/database.php — thông tin kết nối MySQL
// File trả về một mảng; helpers/database.php đọc mảng này để kết nối.
return array(
    'host'     => '127.0.0.1',   // máy chạy MySQL (chính máy mình)
    'port'     => 3306,          // cổng MySQL; máy nào đổi cổng (vd 3308) thì sửa ở đây
    'database' => 'minishop',    // tên database đã import từ database/MiniShop.sql
    'username' => 'root',        // tài khoản MySQL (XAMPP mặc định: root)
    'password' => '',            // mật khẩu (XAMPP mặc định: rỗng)
    'charset'  => 'utf8mb4',     // bảng mã để lưu đúng tiếng Việt
);
