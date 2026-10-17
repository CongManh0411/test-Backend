<?php
// =============================================================
// index.php — ROUTER: cửa vào duy nhất của website
// Mọi trang đều mở qua: index.php?page=<tên trang>
// =============================================================

// Nạp cấu hình, class Database và các hàm dùng chung (một lần cho mọi trang)
require_once __DIR__ . '/config/init.php';

// 1. Danh sách trang được phép mở (danh sách trắng)
//    khóa  = tên trên URL (?page=...)
//    giá trị = file trong thư mục pages/
$routes = array(
    'home'           => 'home/index.php',            // trang chủ
    'products'       => 'products/index.php',        // danh sách sản phẩm
    'product-detail' => 'product-detail/index.php',  // chi tiết một sản phẩm
    'product-manage' => 'product-manage/index.php',  // bảng quản lý sản phẩm
    'product-create' => 'product-create/index.php',  // form thêm sản phẩm
    'product-edit'   => 'product-edit/index.php',    // form sửa sản phẩm
    'product-hide'   => 'product-hide/action.php',   // chỉ xử lý (ẩn), không có giao diện
    'cart'           => 'cart/index.php',            // buổi 4 mới tạo file → hiện tại vào bước 5 (404)
);

// 2. Lấy tên trang từ URL; không có thì dùng 'home'
$page = $_GET['page'] ?? 'home';

// 3. Tên trang không phải chuỗi hoặc không có trong danh sách → trang 404
if (!is_string($page) || !isset($routes[$page])) {
    http_response_code(404);                         // báo mã lỗi 404 cho trình duyệt
    $file = __DIR__ . '/pages/404/index.php';
} else {
    // 4. Ghép đường dẫn file từ GIÁ TRỊ trong danh sách (không lấy từ URL)
    $file = __DIR__ . '/pages/' . $routes[$page];
}

// 5. Đã khai báo nhưng chưa tạo file → cũng là 404
if (!is_file($file)) {
    http_response_code(404);
    $file = __DIR__ . '/pages/404/index.php';
}

// 6. Nếu trang có action.php thì chạy TRƯỚC khi in HTML
//    (nhận form POST, chuyển trang, chuẩn bị biến cho giao diện)
$action = dirname($file) . '/action.php';            // dirname = thư mục chứa file trang

if (is_file($action)) {
    require $action;
}

// 7. In giao diện: phần đầu chung → nội dung trang → phần cuối chung
require __DIR__ . '/layouts/public/header.php';
require $file;
require __DIR__ . '/layouts/public/footer.php';
