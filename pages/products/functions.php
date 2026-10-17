<?php
// pages/products/functions.php — các hàm làm việc với sản phẩm
// BẢN KHỞI ĐẦU BUỔI 2: các hàm đang trả về dữ liệu rỗng để trang vẫn chạy.
// Viết lại từng hàm theo slide; mỗi hàm chỉ cần một câu SQL + một lần gọi db().

/* ---------------- Tiết 2: ĐỌC DỮ LIỆU (SELECT) ---------------- */

// TODO: SELECT sản phẩm đang bán (status = 1), JOIN categories, brands, mới nhất trước
function products_get_all()
{
    return array();   // tạm thời: mảng rỗng
}

// TODO: giống products_get_all() nhưng lấy cả sản phẩm đã ẩn (dùng cho trang quản lý)
function products_get_for_manage()
{
    return array();
}

// TODO: SELECT một sản phẩm WHERE product_id = ? → db()->fetchOne($sql, array($id))
function product_get_by_id($id)
{
    return null;      // tạm thời: không tìm thấy
}

// TODO: danh sách cho ô chọn trong form
function categories_get_all()
{
    return array();
}

function brands_get_all()
{
    return array();
}

function suppliers_get_all()
{
    return array();
}

/* ---------------- Tiết 3: KIỂM TRA DỮ LIỆU FORM ---------------- */

// Đã viết sẵn: đọc dữ liệu form từ $_POST, bỏ khoảng trắng thừa
function product_read_form($post)
{
    return array(
        'product_name' => trim($post['product_name'] ?? ''),
        'sku'          => trim($post['sku'] ?? ''),
        'category_id'  => (int) ($post['category_id'] ?? 0),   // (int): ép về số nguyên
        'brand_id'     => (int) ($post['brand_id'] ?? 0),
        'supplier_id'  => (int) ($post['supplier_id'] ?? 0),
        'price'        => trim($post['price'] ?? ''),
        'sale_price'   => trim($post['sale_price'] ?? ''),
        'short_description' => trim($post['short_description'] ?? ''),
    );
}

// TODO: trả về mảng lỗi; mảng rỗng = hợp lệ
// (tên bắt buộc · SKU đúng mẫu, không trùng · giá > 0 · giá KM < giá gốc · danh mục, thương hiệu, NCC có thật)
function product_validate($data, $exceptId = 0)
{
    $errors = array();

    return $errors;
}

// Đã viết sẵn: slug tạo từ SKU, "LOG-M331" → "log-m331"
function product_make_slug($sku)
{
    return strtolower($sku);
}

/* ---------------- Tiết 3–4: GHI DỮ LIỆU ---------------- */

// TODO Tiết 3: INSERT INTO products (...) VALUES (?, ?, ...) → return db()->insertId()
function product_create($data)
{
    return 0;
}

// TODO Tiết 4: UPDATE products SET ... WHERE product_id = ?
function product_update($id, $data)
{
    return 0;
}

// TODO Tiết 4: xóa mềm — UPDATE products SET status = 0 WHERE product_id = ?
function product_hide($id)
{
    return 0;
}

// TODO Tiết 4: hiện lại — status = 1
function product_show($id)
{
    return 0;
}
