<!-- pages/product-manage/index.php — bảng quản lý: thêm, sửa, ẩn -->
<main class="container py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h1 class="page-title mb-0">Quản lý sản phẩm</h1>
        <a class="btn btn-primary" href="<?= e(url('product-create')) ?>">+ Thêm sản phẩm</a>
    </div>

    <table class="table table-striped align-middle">
        <thead>
            <tr>
                <th>ID</th><th>Tên sản phẩm</th><th>SKU</th><th>Danh mục</th><th>Giá bán</th><th>Trạng thái</th><th>Thao tác</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach ($products as $product): ?>
                <tr>
                    <td><?= (int) $product['product_id'] ?></td>
                    <td><?= e($product['product_name']) ?></td>
                    <td><?= e($product['sku']) ?></td>
                    <td><?= e($product['category_name']) ?></td>
                    <td><?= money(product_price($product)) ?></td>
                    <td><?= (int) $product['status'] === 1 ? 'Đang bán' : 'Đã ẩn' ?></td>
                    <td class="d-flex gap-2">
                        <!-- Sửa: link GET mang theo id -->
                        <a class="btn btn-sm btn-outline-primary" href="<?= e(url('product-edit', array('id' => $product['product_id']))) ?>">Sửa</a>

                        <!-- Ẩn / Hiện: làm thay đổi dữ liệu nên dùng form POST, không dùng link -->
                        <form method="post" action="<?= e(url('product-hide')) ?>" class="m-0">
                            <input type="hidden" name="id" value="<?= (int) $product['product_id'] ?>">
                            <?php if ((int) $product['status'] === 1): ?>
                                <input type="hidden" name="status" value="0">
                                <button class="btn btn-sm btn-outline-danger" type="submit" onclick="return confirm('Ẩn sản phẩm này?')">Ẩn</button>
                            <?php else: ?>
                                <input type="hidden" name="status" value="1">
                                <button class="btn btn-sm btn-outline-success" type="submit">Hiện</button>
                            <?php endif; ?>
                        </form>
                    </td>
                </tr>
            <?php endforeach; ?>
        </tbody>
    </table>
</main>
