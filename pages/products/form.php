<?php
// pages/products/form.php — form sản phẩm dùng CHUNG cho Thêm và Sửa
// Biến cần có trước khi require: $data (giá trị các ô), $errors, $categories, $brands, $suppliers, $buttonText
?>
<!-- Có lỗi thì in danh sách lỗi -->
<?php if ($errors): ?>
    <div class="alert alert-danger">
        <ul class="mb-0">
            <?php foreach ($errors as $error): ?>
                <li><?= e($error) ?></li>
            <?php endforeach; ?>
        </ul>
    </div>
<?php endif; ?>

<!-- method="post": dữ liệu gửi trong thân request, PHP đọc bằng $_POST -->
<!-- Không ghi action → gửi về chính trang đang mở -->
<form method="post" class="row g-3" style="max-width: 900px">
    <div class="col-md-8">
        <label class="form-label">Tên sản phẩm *</label>
        <!-- name="product_name" chính là khóa $_POST['product_name'] -->
        <!-- value: giữ lại chữ đã nhập khi có lỗi -->
        <input class="form-control" name="product_name" value="<?= e($data['product_name']) ?>">
    </div>
    <div class="col-md-4">
        <label class="form-label">SKU *</label>
        <input class="form-control" name="sku" value="<?= e($data['sku']) ?>" placeholder="VD: LOG-M331">
    </div>

    <div class="col-md-4">
        <label class="form-label">Danh mục *</label>
        <select class="form-select" name="category_id">
            <option value="0">-- Chọn --</option>
            <?php foreach ($categories as $category): ?>
                <!-- selected: chọn sẵn mục trùng với giá trị hiện tại -->
                <option value="<?= (int) $category['category_id'] ?>" <?= (int) $category['category_id'] === (int) $data['category_id'] ? 'selected' : '' ?>>
                    <?= e($category['category_name']) ?>
                </option>
            <?php endforeach; ?>
        </select>
    </div>
    <div class="col-md-4">
        <label class="form-label">Thương hiệu *</label>
        <select class="form-select" name="brand_id">
            <option value="0">-- Chọn --</option>
            <?php foreach ($brands as $brand): ?>
                <option value="<?= (int) $brand['brand_id'] ?>" <?= (int) $brand['brand_id'] === (int) $data['brand_id'] ? 'selected' : '' ?>>
                    <?= e($brand['brand_name']) ?>
                </option>
            <?php endforeach; ?>
        </select>
    </div>
    <div class="col-md-4">
        <label class="form-label">Nhà cung cấp *</label>
        <select class="form-select" name="supplier_id">
            <option value="0">-- Chọn --</option>
            <?php foreach ($suppliers as $supplier): ?>
                <option value="<?= (int) $supplier['supplier_id'] ?>" <?= (int) $supplier['supplier_id'] === (int) $data['supplier_id'] ? 'selected' : '' ?>>
                    <?= e($supplier['supplier_name']) ?>
                </option>
            <?php endforeach; ?>
        </select>
    </div>

    <div class="col-md-6">
        <label class="form-label">Giá gốc *</label>
        <input class="form-control" name="price" type="number" min="1" value="<?= e($data['price']) ?>">
    </div>
    <div class="col-md-6">
        <label class="form-label">Giá khuyến mãi (bỏ trống nếu không giảm)</label>
        <input class="form-control" name="sale_price" type="number" min="0" value="<?= e($data['sale_price']) ?>">
    </div>

    <div class="col-12">
        <label class="form-label">Mô tả ngắn</label>
        <textarea class="form-control" name="short_description" rows="3"><?= e($data['short_description']) ?></textarea>
    </div>

    <div class="col-12 d-flex gap-2">
        <button class="btn btn-primary" type="submit"><?= e($buttonText) ?></button>
        <a class="btn btn-outline-secondary" href="<?= e(url('product-manage')) ?>">Hủy</a>
    </div>
</form>
