<!-- pages/home/index.php — giao diện trang chủ: chỉ in HTML -->
<main class="container py-4">
    <div class="section-head">
        <div>
            <div class="section-kicker">MiniShop Basic</div>
            <h2 class="section-title">Sản phẩm mới</h2>
        </div>
        <a class="section-link" href="<?= e(url('products')) ?>">Xem tất cả →</a>
    </div>

    <div class="row g-3">
        <!-- Mỗi vòng lặp: $product là một dòng; product-card.php in một thẻ -->
        <?php foreach ($products as $product): ?>
            <?php require __DIR__ . '/../../layouts/public/product-card.php'; ?>
        <?php endforeach; ?>
    </div>
</main>
