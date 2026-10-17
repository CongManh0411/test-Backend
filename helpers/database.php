<?php
// helpers/database.php — hàm db(): trả về MỘT đối tượng Database dùng chung
// Gọi bao nhiêu lần trong một request cũng chỉ mở 1 kết nối.
// Cách dùng: db()->fetchAll("SELECT ...", array(...));

function db()
{
    static $database = null;   // static: giữ giá trị giữa các lần gọi hàm

    if ($database === null) {                                  // lần gọi đầu tiên
        $config = require __DIR__ . '/../config/database.php'; // đọc mảng cấu hình
        $database = new Database($config);                     // mở kết nối
    }

    return $database;          // các lần sau: trả lại đúng đối tượng cũ
}
