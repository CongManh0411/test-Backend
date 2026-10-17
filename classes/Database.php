<?php
// classes/Database.php — class làm việc với MySQL bằng MySQLi
// BẢN KHỞI ĐẦU BUỔI 2: mới có hàm khởi tạo.
// Trong buổi học các em viết thêm 4 phương thức theo slide (TODO bên dưới).

class Database
{
    // Thuộc tính giữ kết nối; private = chỉ dùng bên trong class
    private $connection;

    // Hàm khởi tạo: tự chạy khi viết new Database($config)
    public function __construct($config)
    {
        // Mở kết nối tới MySQL (lỗi sẽ ném exception, PHP 8.1+)
        $this->connection = new mysqli(
            $config['host'],
            $config['username'],
            $config['password'],
            $config['database'],
            $config['port']
        );

        // Đặt bảng mã để đọc/ghi tiếng Việt đúng
        $this->connection->set_charset($config['charset']);
    }

    // TODO Tiết 2: run($sql, $params) — prepare() rồi execute($params), trả về statement
    // TODO Tiết 2: fetchAll($sql, $params = array()) — nhiều dòng → mảng hai chiều
    // TODO Tiết 2: fetchOne($sql, $params = array()) — một dòng → mảng, không có → null
    // TODO Tiết 3: execute($sql, $params = array()) — INSERT/UPDATE → số dòng thay đổi
    // TODO Tiết 3: insertId() — id tự tăng vừa tạo
}
