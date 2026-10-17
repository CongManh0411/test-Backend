<?php
// layouts/public/header.php — phần đầu chung của mọi trang
// $title do action.php của từng trang đặt; trang nào chưa đặt thì dùng 'MiniShop'
$pageTitle = $title ?? 'MiniShop';
$currentPage = get_param('page', 'home');   // tên trang đang mở, để tô đậm menu
?>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= e($pageTitle) ?> | MiniShop Basic</title>
    <link rel="stylesheet" href="<?= e(asset('customer/css/bootstrap.min.css')) ?>">
    <link rel="stylesheet" href="<?= e(asset('customer/css/minishop.css')) ?>">
</head>
<body>
    <header class="site-header">
        <div class="header-main">
            <div class="container d-flex align-items-center justify-content-between py-3">
                <!-- Logo: bấm vào về trang chủ -->
                <a class="brand" href="<?= e(url('home')) ?>">
                    <span class="brand-mark">M</span>
                    <span class="brand-word">Mini<span>Shop</span></span>
                </a>
                <span class="text-muted">Project Basic · Lập trình Web</span>
            </div>
        </div>

        <!-- Menu chính: mỗi link là một ?page=... đã khai báo trong $routes -->
        <nav class="main-nav">
            <div class="container">
                <ul class="nav-list">
                    <li><a class="nav-link <?= $currentPage === 'home' ? 'active' : '' ?>" href="<?= e(url('home')) ?>">Trang chủ</a></li>
                    <li><a class="nav-link <?= $currentPage === 'products' ? 'active' : '' ?>" href="<?= e(url('products')) ?>">Sản phẩm</a></li>
                    <li><a class="nav-link <?= $currentPage === 'product-manage' ? 'active' : '' ?>" href="<?= e(url('product-manage')) ?>">Quản lý sản phẩm</a></li>
                </ul>
            </div>
        </nav>
    </header>
