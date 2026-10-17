<?php
// pages/product-edit/action.php — xử lý form SỬA sản phẩm
require_once __DIR__ . '/../products/functions.php';

$id = (int) get_param('id', '0');              // id sản phẩm cần sửa, lấy từ URL

// TODO Tiết 4: $product = product_get_by_id($id); không có → redirect(url('404'));
$product = product_read_form(array());

$title = 'Sửa sản phẩm';
$errors = array();
$data = $product;                              // GET: form điền sẵn dữ liệu đang có

$categories = categories_get_all();
$brands = brands_get_all();
$suppliers = suppliers_get_all();

// TODO Tiết 4: xử lý POST giống trang Thêm, nhưng gọi product_validate($data, $id)
//              và product_update($id, $data)
