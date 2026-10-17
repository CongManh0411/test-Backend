<!-- pages/product-detail/index.php — chi tiết sản phẩm -->
<?php if (!$product): ?>
    <!-- Không có sản phẩm: dùng lại giao diện trang 404 -->
    <?php require __DIR__ . '/../404/index.php'; ?>
<?php else: ?>
<main class="container py-4">
    <div class="row g-4">
        <div class="col-md-5">
            <img class="img-fluid rounded border" src="<?= e(product_image($product['thumbnail'])) ?>" alt="<?= e($product['product_name']) ?>">
        </div>

        <div class="col-md-7">
            <h1 class="h2"><?= e($product['product_name']) ?></h1>

            <p class="fs-3 text-primary fw-bold mb-1"><?= money(product_price($product)) ?></p>
            <?php if (!empty($product['sale_price'])): ?>
                <p class="text-muted"><del><?= money($product['price']) ?></del></p>
            <?php endif; ?>

            <!-- Thông tin lấy từ 4 bảng nhờ JOIN -->
            <table class="table">
                <tr><th>SKU</th><td><?= e($product['sku']) ?></td></tr>
                <tr><th>Danh mục</th><td><?= e($product['category_name']) ?></td></tr>
                <tr><th>Thương hiệu</th><td><?= e($product['brand_name']) ?></td></tr>
                <tr><th>Nhà cung cấp</th><td><?= e($product['supplier_name']) ?></td></tr>
            </table>

            <p><?= e($product['short_description']) ?></p>
            <a class="btn btn-outline-primary" href="<?= e(url('products')) ?>">← Danh sách sản phẩm</a>
        </div>
    </div>
</main>
<?php endif; ?>
