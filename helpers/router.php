<?php
// helpers/router.php — các hàm tạo đường dẫn và đọc tham số URL

// Đọc config/app.php một lần rồi giữ lại
function app_config()
{
    static $config = null;

    if ($config === null) {
        $config = require __DIR__ . '/../config/app.php';
    }

    return $config;
}

// base_url('index.php') → /minishop-basic/index.php
function base_url($path = '')
{
    $base = rtrim(app_config()['base_url'], '/');   // bỏ dấu / thừa ở cuối

    return $base . '/' . ltrim($path, '/');         // bỏ dấu / thừa ở đầu rồi ghép
}

// url('product-detail', ['id' => 3]) → /minishop-basic/index.php?page=product-detail&id=3
function url($page = 'home', $params = array())
{
    $params = array_merge(array('page' => $page), $params);   // page luôn đứng đầu

    return base_url('index.php?' . http_build_query($params)); // ghép thành chuỗi query
}

// asset('customer/css/minishop.css') → /minishop-basic/assets/customer/css/minishop.css
function asset($path)
{
    return base_url('assets/' . ltrim($path, '/'));
}

// Đọc một tham số GET dạng chuỗi; thiếu hoặc là mảng → giá trị mặc định
function get_param($name, $default = '')
{
    if (!isset($_GET[$name]) || !is_string($_GET[$name])) {
        return $default;
    }

    return trim($_GET[$name]);   // bỏ khoảng trắng hai đầu
}
