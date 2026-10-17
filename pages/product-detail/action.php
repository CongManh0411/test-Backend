<?php
// pages/product-detail/action.php — lấy một sản phẩm theo id trên URL
require_once __DIR__ . '/../products/functions.php';

$id = (int) get_param('id', '0');          // ?id=3 → 3; id sai (abc, thiếu) → 0
$product = product_get_by_id($id);         // không có → null

// Không có sản phẩm, hoặc sản phẩm đang ẩn → báo 404
if (!$product || (int) $product['status'] !== 1) {
    http_response_code(404);
    $title = 'Không tìm thấy sản phẩm';
    $product = null;
    return;                                // dừng action.php; Router vẫn in giao diện
}

$title = $product['product_name'];
