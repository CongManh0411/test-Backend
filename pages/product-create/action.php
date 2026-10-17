<?php
// pages/product-create/action.php — xử lý form THÊM sản phẩm
// Chạy TRƯỚC khi Router in header, nên redirect() hoạt động được.
require_once __DIR__ . '/../products/functions.php';

$title = 'Thêm sản phẩm';
$errors = array();                             // danh sách lỗi, rỗng = chưa có lỗi
$data = product_read_form(array());            // form trống khi mở trang lần đầu

// Dữ liệu cho các ô chọn
$categories = categories_get_all();
$brands = brands_get_all();
$suppliers = suppliers_get_all();

// TODO Tiết 3: khi người dùng bấm nút gửi (REQUEST_METHOD === 'POST')
//   1. $data = product_read_form($_POST);
//   2. $errors = product_validate($data);
//   3. không có lỗi → product_create($data); redirect(url('product-manage'));
