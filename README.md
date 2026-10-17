# MiniShop Basic — mốc b2-start (đầu buổi 2)

Project nhỏ để học PHP từng buổi. Cấu trúc, tên file, tên hàm **giống hệt MiniShop thật**,
nên đến buổi 6 chuyển sang MiniShop thật không phải học lại cách đặt tên.

**Mốc này:** Router và giao diện đã chạy; `classes/Database.php` mới có hàm khởi tạo; các hàm trong `pages/products/functions.php` và phần xử lý POST trong `action.php` để trống, đánh dấu `TODO` — viết dần theo slide buổi 2.

## Chạy project

1. Chép thư mục `minishop-basic` vào `C:\xampp\htdocs\`.
2. Import `database/MiniShop.sql` bằng phpMyAdmin (tạo database `minishop`, 15 bảng).
3. Kiểm tra `config/database.php` (cổng, tài khoản, mật khẩu MySQL).
4. Mở `http://localhost/minishop-basic/`.

## Cấu trúc

```text
minishop-basic/
├── index.php                 Router: $routes → action.php → header → trang → footer
├── config/
│   ├── app.php               base_url (tên thư mục trong htdocs)
│   ├── database.php          thông tin kết nối MySQL
│   └── init.php              nạp class và helpers
├── classes/Database.php      fetchAll · fetchOne · execute · insertId
├── helpers/
│   ├── database.php          db() — một kết nối dùng chung
│   ├── router.php            url() · asset() · get_param()
│   └── common.php            e() · money() · redirect() · product_price() · product_image()
├── layouts/public/           header.php · footer.php · product-card.php
└── pages/<trang>/
    ├── action.php            xử lý: đọc dữ liệu, nhận POST, chuyển trang (chưa in HTML)
    ├── index.php             giao diện: chỉ in HTML
    └── functions.php         các hàm SQL của trang (nếu có)
```

## Các trang

| ?page= | File | Việc |
|---|---|---|
| home | pages/home/ | 8 sản phẩm mới |
| products | pages/products/ | Danh sách sản phẩm đang bán |
| product-detail&id= | pages/product-detail/ | Chi tiết theo id |
| product-manage | pages/product-manage/ | Bảng quản lý: thêm · sửa · ẩn |
| product-create | pages/product-create/ | Form thêm (INSERT) |
| product-edit&id= | pages/product-edit/ | Form sửa (UPDATE) |
| product-hide | pages/product-hide/action.php | Ẩn / hiện (xóa mềm), chỉ nhận POST |

## Các mốc

| Mốc | Nội dung |
|---|---|
| b2-start | Router, layout, Database mới có hàm khởi tạo, các hàm SQL để trống (TODO) |
| b2-end | CRUD sản phẩm hoàn chỉnh |
| b3-end | Đăng ký, đăng nhập, phân quyền, CSRF, quản lý user |
| b4-end | Giỏ hàng trong Session, AJAX |
| b5-end | Tìm kiếm, phân trang, upload ảnh |
| Buổi 6 | Chuyển sang MiniShop thật: checkout, đơn hàng, transaction |

## Basic ↔ MiniShop thật

| Basic | MiniShop thật |
|---|---|
| pages/product-manage/ | admin/pages/products/ |
| pages/product-create/, product-edit/ | admin/pages/product-form/ |
| pages/product-hide/ | nút Ẩn trong admin/pages/products/ |
| Mọi file còn lại | cùng tên, cùng vị trí |

Lưu ý: trang quản lý sản phẩm chưa có đăng nhập và phân quyền — chỉ chạy trên máy cá nhân.
Buổi 3 bổ sung require_role() và CSRF.
