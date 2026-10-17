<?php
// pages/product-hide/action.php — ẩn / hiện sản phẩm (xóa mềm)
// Trang này KHÔNG có giao diện: xử lý xong là chuyển trang.
require_once __DIR__ . '/../products/functions.php';

// TODO Tiết 4: chỉ khi POST — đọc $_POST['id'], $_POST['status'];
//              status '1' → product_show($id), ngược lại → product_hide($id)

redirect(url('product-manage'));   // luôn quay về bảng quản lý
