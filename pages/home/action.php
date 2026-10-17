<?php
// pages/home/action.php — chuẩn bị dữ liệu cho trang chủ (chưa in HTML)
require_once __DIR__ . '/../products/functions.php';   // dùng lại hàm của module sản phẩm

$title = 'Trang chủ';
$products = array_slice(products_get_all(), 0, 8);       // lấy 8 sản phẩm mới nhất
// Đầu buổi products_get_all() còn trả mảng rỗng → trang chủ chưa có sản phẩm
