<?php
// pages/products/action.php — lấy danh sách sản phẩm cho giao diện
require_once __DIR__ . '/functions.php';

$title = 'Sản phẩm';
$products = products_get_all();        // mảng các dòng từ bảng products
