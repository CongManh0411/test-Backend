<!-- pages/product-edit/index.php — giao diện trang Sửa sản phẩm -->
<main class="container py-4">
    <h1 class="page-title mb-4">Sửa sản phẩm #<?= (int) $id ?></h1>
    <?php $buttonText = 'Lưu thay đổi'; ?>
    <?php require __DIR__ . '/../products/form.php'; ?>
</main>
