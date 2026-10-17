<?php
// layouts/public/product-card.php — thẻ hiển thị MỘT sản phẩm
// Dùng trong vòng foreach: biến $product là một dòng lấy từ bảng products
?>
<div class="col-6 col-md-4 col-xl-3">
    <article class="product-card h-100">
        <div class="product-media">
            <a href="<?= e(url('product-detail', array('id' => $product['product_id']))) ?>">
                <img src="<?= e(product_image($product['thumbnail'])) ?>" alt="<?= e($product['product_name']) ?>" loading="lazy">
            </a>
        </div>

        <div class="product-body">
            <!-- Tên thương hiệu · tên danh mục (lấy bằng JOIN) -->
            <div class="product-meta">
                <?= e($product['brand_name']) ?> · <?= e($product['category_name']) ?>
            </div>

            <!-- Tên sản phẩm: link sang trang chi tiết theo product_id -->
            <a class="product-title" href="<?= e(url('product-detail', array('id' => $product['product_id']))) ?>">
                <?= e($product['product_name']) ?>
            </a>

            <!-- Giá bán; nếu có giá khuyến mãi thì gạch giá gốc -->
            <div class="product-price-row">
                <span class="price"><?= money(product_price($product)) ?></span>
                <?php if (!empty($product['sale_price'])): ?>
                    <span class="old-price"><?= money($product['price']) ?></span>
                <?php endif; ?>
            </div>
        </div>
    </article>
</div>
