<!-- pages/products/index.php — danh sách sản phẩm -->
<main class="container py-4">
    <!-- count(): số phần tử của mảng = số dòng lấy được -->
    <h1 class="page-title mb-4">Sản phẩm (<?= count($products) ?>)</h1>

    <div class="row g-3">
        <?php foreach ($products as $product): ?>
            <?php require __DIR__ . '/../../layouts/public/product-card.php'; ?>
        <?php endforeach; ?>
    </div>

    <!-- Mảng rỗng → chưa có sản phẩm nào đang bán -->
    <?php if (!$products): ?>
        <div class="alert alert-info">Chưa có sản phẩm.</div>
    <?php endif; ?>
</main>
