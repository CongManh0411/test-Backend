<?php
// pages/product-manage/action.php — dữ liệu cho bảng quản lý sản phẩm
require_once __DIR__ . '/../products/functions.php';

$title = 'Quản lý sản phẩm';
$products = products_get_for_manage();    // gồm cả sản phẩm đã ẩn
