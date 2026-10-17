<?php
// helpers/common.php — các hàm tiện ích dùng ở nhiều trang

// e(): chống XSS — đổi ký tự đặc biệt (< > " ') thành dạng hiển thị an toàn
// Luôn dùng khi in dữ liệu ra HTML, ví dụ: e($product['product_name'])
function e($value)
{
    return htmlspecialchars((string) $value, ENT_QUOTES, 'UTF-8');
}

// money(15990000) → "15.990.000 đ"
function money($value)
{
    return number_format((float) $value, 0, ',', '.') . ' đ';
}

// redirect(): chuyển trang rồi DỪNG chương trình
function redirect($location)
{
    header('Location: ' . $location);   // báo trình duyệt mở địa chỉ mới
    exit;                               // không chạy tiếp code bên dưới
}

// Giá bán thực tế: có giá khuyến mãi thì dùng, không thì dùng giá gốc
function product_price($product)
{
    if (!empty($product['sale_price'])) {
        return (float) $product['sale_price'];
    }

    return (float) $product['price'];
}

// Đường dẫn ảnh sản phẩm; không có file ảnh thì dùng ảnh mặc định
function product_image($thumbnail)
{
    $placeholder = asset('customer/images/tech/placeholder-tech.jpg');

    if (empty($thumbnail)) {
        return $placeholder;
    }

    $fileName = basename($thumbnail);                                       // chỉ lấy tên file
    $filePath = __DIR__ . '/../assets/customer/images/tech/' . $fileName;   // đường dẫn trên ổ đĩa

    return is_file($filePath) ? asset('customer/images/tech/' . $fileName) : $placeholder;
}
