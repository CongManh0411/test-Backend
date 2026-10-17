
-- ============================================================
-- MiniShop sample database for PHP/MySQL teaching
-- MySQL 8.0+ / MariaDB 10.5+
-- Character set: utf8mb4
-- Demo password for ALL seeded users: 123456
-- Passwords are stored with a PHP-compatible bcrypt hash.
-- ============================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP DATABASE IF EXISTS `minishop`;
CREATE DATABASE `minishop` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `minishop`;

CREATE TABLE `users` (
  `user_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `username` VARCHAR(100) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `full_name` VARCHAR(150) NOT NULL,
  `email` VARCHAR(150) NULL UNIQUE,
  `phone` VARCHAR(20) NULL,
  `address` VARCHAR(255) NULL,
  `avatar` VARCHAR(255) NULL,
  `role` ENUM('admin','staff','customer') NOT NULL DEFAULT 'customer',
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_users_role` (`role`),
  INDEX `idx_users_status` (`status`)
) ENGINE=InnoDB;

CREATE TABLE `categories` (
  `category_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `parent_id` INT UNSIGNED NULL,
  `category_name` VARCHAR(150) NOT NULL,
  `slug` VARCHAR(150) NOT NULL UNIQUE,
  `description` TEXT NULL,
  `image` VARCHAR(255) NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_categories_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories`(`category_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  INDEX `idx_categories_parent` (`parent_id`),
  INDEX `idx_categories_status` (`status`)
) ENGINE=InnoDB;

CREATE TABLE `brands` (
  `brand_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `brand_name` VARCHAR(100) NOT NULL,
  `slug` VARCHAR(150) NOT NULL UNIQUE,
  `logo` VARCHAR(255) NULL,
  `description` TEXT NULL,
  `website` VARCHAR(255) NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_brands_status` (`status`)
) ENGINE=InnoDB;

CREATE TABLE `suppliers` (
  `supplier_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `supplier_name` VARCHAR(150) NOT NULL,
  `contact_name` VARCHAR(100) NULL,
  `phone` VARCHAR(20) NULL,
  `email` VARCHAR(150) NULL,
  `address` VARCHAR(255) NULL,
  `tax_code` VARCHAR(50) NULL,
  `website` VARCHAR(255) NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  INDEX `idx_suppliers_status` (`status`)
) ENGINE=InnoDB;

CREATE TABLE `products` (
  `product_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `category_id` INT UNSIGNED NOT NULL,
  `brand_id` INT UNSIGNED NOT NULL,
  `supplier_id` INT UNSIGNED NOT NULL,
  `product_name` VARCHAR(255) NOT NULL,
  `slug` VARCHAR(255) NOT NULL UNIQUE,
  `sku` VARCHAR(50) NOT NULL UNIQUE,
  `price` DECIMAL(15,2) UNSIGNED NOT NULL,
  `sale_price` DECIMAL(15,2) UNSIGNED NULL,
  `short_description` VARCHAR(500) NULL,
  `description` TEXT NULL,
  `thumbnail` VARCHAR(255) NULL,
  `featured` TINYINT(1) NOT NULL DEFAULT 0,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories`(`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_products_brand` FOREIGN KEY (`brand_id`) REFERENCES `brands`(`brand_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_products_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `suppliers`(`supplier_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_product_price` CHECK (`price` > 0),
  CONSTRAINT `chk_product_sale_price` CHECK (`sale_price` IS NULL OR `sale_price` >= 0),
  INDEX `idx_products_category` (`category_id`),
  INDEX `idx_products_brand` (`brand_id`),
  INDEX `idx_products_supplier` (`supplier_id`),
  INDEX `idx_products_status_featured` (`status`,`featured`)
) ENGINE=InnoDB;

CREATE TABLE `product_images` (
  `image_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT UNSIGNED NOT NULL,
  `image_url` VARCHAR(255) NOT NULL,
  `is_primary` TINYINT(1) NOT NULL DEFAULT 0,
  `sort_order` INT UNSIGNED NOT NULL DEFAULT 0,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_product_images_product` FOREIGN KEY (`product_id`) REFERENCES `products`(`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX `idx_product_images_product` (`product_id`)
) ENGINE=InnoDB;

CREATE TABLE `product_specifications` (
  `spec_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT UNSIGNED NOT NULL,
  `spec_name` VARCHAR(100) NOT NULL,
  `spec_value` VARCHAR(255) NOT NULL,
  `sort_order` INT UNSIGNED NOT NULL DEFAULT 0,
  CONSTRAINT `fk_product_specs_product` FOREIGN KEY (`product_id`) REFERENCES `products`(`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX `idx_product_specs_product` (`product_id`)
) ENGINE=InnoDB;

CREATE TABLE `inventory` (
  `inventory_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT UNSIGNED NOT NULL UNIQUE,
  `quantity` INT UNSIGNED NOT NULL DEFAULT 0,
  `reserved_quantity` INT UNSIGNED NOT NULL DEFAULT 0,
  `min_quantity` INT UNSIGNED NOT NULL DEFAULT 0,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_inventory_product` FOREIGN KEY (`product_id`) REFERENCES `products`(`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_inventory_reserved` CHECK (`reserved_quantity` <= `quantity`)
) ENGINE=InnoDB;

CREATE TABLE `coupons` (
  `coupon_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `code` VARCHAR(50) NOT NULL UNIQUE,
  `coupon_name` VARCHAR(150) NOT NULL,
  `discount_type` ENUM('percent','fixed') NOT NULL,
  `discount_value` DECIMAL(15,2) UNSIGNED NOT NULL,
  `min_order_value` DECIMAL(15,2) UNSIGNED NOT NULL DEFAULT 0,
  `max_discount` DECIMAL(15,2) UNSIGNED NULL,
  `usage_limit` INT UNSIGNED NULL,
  `used_count` INT UNSIGNED NOT NULL DEFAULT 0,
  `start_date` DATETIME NOT NULL,
  `end_date` DATETIME NOT NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `chk_coupon_dates` CHECK (`end_date` >= `start_date`),
  CONSTRAINT `chk_coupon_percent` CHECK (`discount_type` <> 'percent' OR `discount_value` <= 100),
  INDEX `idx_coupons_status_dates` (`status`,`start_date`,`end_date`)
) ENGINE=InnoDB;

CREATE TABLE `carts` (
  `cart_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `status` ENUM('active','converted','abandoned') NOT NULL DEFAULT 'active',
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_carts_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX `idx_carts_user_status` (`user_id`,`status`)
) ENGINE=InnoDB;

CREATE TABLE `cart_items` (
  `cart_item_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `cart_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `quantity` INT UNSIGNED NOT NULL DEFAULT 1,
  `unit_price` DECIMAL(15,2) UNSIGNED NOT NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_cart_items_cart` FOREIGN KEY (`cart_id`) REFERENCES `carts`(`cart_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cart_items_product` FOREIGN KEY (`product_id`) REFERENCES `products`(`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_cart_items_quantity` CHECK (`quantity` > 0),
  UNIQUE KEY `uq_cart_product` (`cart_id`,`product_id`),
  INDEX `idx_cart_items_product` (`product_id`)
) ENGINE=InnoDB;

CREATE TABLE `orders` (
  `order_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `coupon_id` INT UNSIGNED NULL,
  `order_code` VARCHAR(30) NOT NULL UNIQUE,
  `receiver_name` VARCHAR(150) NOT NULL,
  `receiver_phone` VARCHAR(20) NOT NULL,
  `shipping_address` VARCHAR(255) NOT NULL,
  `subtotal` DECIMAL(15,2) UNSIGNED NOT NULL DEFAULT 0,
  `discount_amount` DECIMAL(15,2) UNSIGNED NOT NULL DEFAULT 0,
  `shipping_fee` DECIMAL(15,2) UNSIGNED NOT NULL DEFAULT 0,
  `total_amount` DECIMAL(15,2) UNSIGNED NOT NULL DEFAULT 0,
  `payment_method` ENUM('COD','Bank Transfer','VNPay','Momo') NOT NULL,
  `shipping_method` ENUM('standard','express') NOT NULL DEFAULT 'standard',
  `status` ENUM('pending','confirmed','processing','shipping','completed','cancelled') NOT NULL DEFAULT 'pending',
  `note` TEXT NULL,
  `order_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_orders_coupon` FOREIGN KEY (`coupon_id`) REFERENCES `coupons`(`coupon_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_order_total` CHECK (`total_amount` = `subtotal` - `discount_amount` + `shipping_fee`),
  INDEX `idx_orders_user` (`user_id`),
  INDEX `idx_orders_status_date` (`status`,`order_date`)
) ENGINE=InnoDB;

CREATE TABLE `order_items` (
  `order_item_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `product_id` INT UNSIGNED NOT NULL,
  `product_name` VARCHAR(255) NOT NULL,
  `quantity` INT UNSIGNED NOT NULL,
  `unit_price` DECIMAL(15,2) UNSIGNED NOT NULL,
  `subtotal` DECIMAL(15,2) UNSIGNED NOT NULL,
  CONSTRAINT `fk_order_items_order` FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_order_items_product` FOREIGN KEY (`product_id`) REFERENCES `products`(`product_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_order_items_quantity` CHECK (`quantity` > 0),
  CONSTRAINT `chk_order_items_subtotal` CHECK (`subtotal` = `quantity` * `unit_price`),
  INDEX `idx_order_items_order` (`order_id`),
  INDEX `idx_order_items_product` (`product_id`)
) ENGINE=InnoDB;

CREATE TABLE `payments` (
  `payment_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `order_id` INT UNSIGNED NOT NULL,
  `payment_method` ENUM('COD','Bank Transfer','VNPay','Momo') NOT NULL,
  `amount` DECIMAL(15,2) UNSIGNED NOT NULL,
  `transaction_code` VARCHAR(100) NULL,
  `payment_status` ENUM('pending','paid','failed','refunded') NOT NULL DEFAULT 'pending',
  `paid_at` DATETIME NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_payments_order` FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX `idx_payments_order` (`order_id`),
  INDEX `idx_payments_status` (`payment_status`)
) ENGINE=InnoDB;

CREATE TABLE `reviews` (
  `review_id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  `product_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `rating` TINYINT UNSIGNED NOT NULL,
  `title` VARCHAR(150) NULL,
  `comment` TEXT NOT NULL,
  `is_verified_purchase` TINYINT(1) NOT NULL DEFAULT 0,
  `admin_reply` TEXT NULL,
  `replied_by` INT UNSIGNED NULL,
  `replied_at` DATETIME NULL,
  `status` TINYINT(1) NOT NULL DEFAULT 1,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT `fk_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `products`(`product_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviews_replied_by` FOREIGN KEY (`replied_by`) REFERENCES `users`(`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `chk_reviews_rating` CHECK (`rating` BETWEEN 1 AND 5),
  INDEX `idx_reviews_product_status` (`product_id`,`status`),
  INDEX `idx_reviews_user` (`user_id`)
) ENGINE=InnoDB;
-- Seed data
INSERT INTO `users` (`user_id`, `username`, `password`, `full_name`, `email`, `phone`, `address`, `role`, `status`) VALUES
(1, 'admin', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Quản trị hệ thống', 'admin@minishop.local', '0901000001', '01 Nguyễn Huệ, Quận 1, TP.HCM', 'admin', 1),
(2, 'staff01', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Trần Minh Anh', 'staff01@minishop.local', '0901000002', '25 Lê Lợi, Quận 1, TP.HCM', 'staff', 1),
(3, 'staff02', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Nguyễn Hoàng Nam', 'staff02@minishop.local', '0901000003', '88 Điện Biên Phủ, Bình Thạnh, TP.HCM', 'staff', 1),
(4, 'khach01', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Lê Quốc Bảo', 'bao.le@example.com', '0912000001', '12 Cách Mạng Tháng 8, Quận 3, TP.HCM', 'customer', 1),
(5, 'khach02', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Phạm Thu Hà', 'ha.pham@example.com', '0912000002', '45 Nguyễn Trãi, Quận 5, TP.HCM', 'customer', 1),
(6, 'khach03', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Võ Minh Khang', 'khang.vo@example.com', '0912000003', '18 Phan Xích Long, Phú Nhuận, TP.HCM', 'customer', 1),
(7, 'khach04', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Đặng Ngọc Mai', 'mai.dang@example.com', '0912000004', '73 Hoàng Văn Thụ, Tân Bình, TP.HCM', 'customer', 1),
(8, 'khach05', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Bùi Gia Huy', 'huy.bui@example.com', '0912000005', '31 Võ Văn Ngân, Thủ Đức, TP.HCM', 'customer', 1),
(9, 'khach06', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Nguyễn Thảo Vy', 'vy.nguyen@example.com', '0912000006', '20 Nguyễn Văn Linh, Quận 7, TP.HCM', 'customer', 1),
(10, 'khach07', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Trần Đức Long', 'long.tran@example.com', '0912000007', '15 Quang Trung, Gò Vấp, TP.HCM', 'customer', 1),
(11, 'khach08', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Phan Ngọc Hân', 'han.phan@example.com', '0912000008', '62 Lũy Bán Bích, Tân Phú, TP.HCM', 'customer', 1),
(12, 'khach09', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Lý Minh Tuấn', 'tuan.ly@example.com', '0912000009', '101 Kha Vạn Cân, Thủ Đức, TP.HCM', 'customer', 1),
(13, 'khach10', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Hoàng Anh Thư', 'thu.hoang@example.com', '0912000010', '9 Nguyễn Oanh, Gò Vấp, TP.HCM', 'customer', 1),
(14, 'khach11', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Đỗ Nhật Quang', 'quang.do@example.com', '0912000011', '52 Tô Hiến Thành, Quận 10, TP.HCM', 'customer', 1),
(15, 'khach12', '$2y$12$zRcJB6oEbab0Hiyz4JbGe.W1cOo5G2TZjz797f6DS6XJosBtZ.8i2', 'Ngô Khánh Linh', 'linh.ngo@example.com', '0912000012', '120 Âu Cơ, Tân Bình, TP.HCM', 'customer', 0);
INSERT INTO `categories` (`category_id`, `parent_id`, `category_name`, `slug`, `description`, `image`, `status`) VALUES
(1, NULL, 'Laptop', 'laptop', 'Máy tính xách tay cho học tập, văn phòng, đồ họa và gaming', 'laptop.jpg', 1),
(2, NULL, 'Điện thoại', 'dien-thoai', 'Điện thoại thông minh', 'phone.jpg', 1),
(3, NULL, 'Máy tính bảng', 'may-tinh-bang', 'Tablet và thiết bị di động màn hình lớn', 'tablet.jpg', 1),
(4, NULL, 'Màn hình', 'man-hinh', 'Màn hình máy tính', 'monitor.jpg', 1),
(5, NULL, 'Bàn phím', 'ban-phim', 'Bàn phím cơ và văn phòng', 'keyboard.jpg', 1),
(6, NULL, 'Chuột', 'chuot', 'Chuột gaming và văn phòng', 'mouse.jpg', 1),
(7, NULL, 'Tai nghe', 'tai-nghe', 'Tai nghe có dây và không dây', 'headphone.jpg', 1),
(8, NULL, 'Linh kiện PC', 'linh-kien-pc', 'CPU, RAM, SSD, VGA và linh kiện máy tính', 'components.jpg', 1),
(9, 1, 'Laptop Gaming', 'laptop-gaming', 'Laptop hiệu năng cao dành cho game', 'gaming-laptop.jpg', 1),
(10, 1, 'Laptop Văn phòng', 'laptop-van-phong', 'Laptop mỏng nhẹ cho học tập và công việc', 'office-laptop.jpg', 1),
(11, 8, 'Ổ cứng SSD', 'ssd', 'Ổ cứng thể rắn SATA và NVMe', 'ssd.jpg', 1),
(12, 8, 'RAM', 'ram', 'Bộ nhớ trong cho máy tính', 'ram.jpg', 1);
INSERT INTO `brands` (`brand_id`, `brand_name`, `slug`, `logo`, `description`, `website`, `status`) VALUES
(1, 'Apple', 'apple', 'apple.png', 'Thiết bị công nghệ Apple', 'https://www.apple.com', 1),
(2, 'ASUS', 'asus', 'asus.png', 'Máy tính và linh kiện ASUS', 'https://www.asus.com', 1),
(3, 'Dell', 'dell', 'dell.png', 'Máy tính Dell', 'https://www.dell.com', 1),
(4, 'HP', 'hp', 'hp.png', 'Máy tính HP', 'https://www.hp.com', 1),
(5, 'Lenovo', 'lenovo', 'lenovo.png', 'Máy tính Lenovo', 'https://www.lenovo.com', 1),
(6, 'Samsung', 'samsung', 'samsung.png', 'Thiết bị Samsung', 'https://www.samsung.com', 1),
(7, 'Logitech', 'logitech', 'logitech.png', 'Thiết bị ngoại vi Logitech', 'https://www.logitech.com', 1),
(8, 'MSI', 'msi', 'msi.png', 'Laptop và linh kiện MSI', 'https://www.msi.com', 1),
(9, 'Kingston', 'kingston', 'kingston.png', 'RAM và lưu trữ Kingston', 'https://www.kingston.com', 1),
(10, 'Acer', 'acer', 'acer.png', 'Máy tính Acer', 'https://www.acer.com', 1);
INSERT INTO `suppliers` (`supplier_id`, `supplier_name`, `contact_name`, `phone`, `email`, `address`, `tax_code`, `website`, `status`) VALUES
(1, 'Công ty Phân phối Công nghệ A', 'Nguyễn Văn An', '02873000001', 'sales@tech-a.vn', '102 Nguyễn Văn Trỗi, Phú Nhuận, TP.HCM', '0310000001', 'https://tech-a.vn', 1),
(2, 'Công ty Thiết bị Số B', 'Trần Minh Bình', '02873000002', 'contact@digital-b.vn', '25 Cộng Hòa, Tân Bình, TP.HCM', '0310000002', 'https://digital-b.vn', 1),
(3, 'Nhà phân phối Tin học C', 'Lê Thanh Cường', '02873000003', 'sales@it-c.vn', '88 Lý Thường Kiệt, Quận 10, TP.HCM', '0310000003', 'https://it-c.vn', 1),
(4, 'Công ty Công nghệ D', 'Phạm Thu Dung', '02873000004', 'hello@tech-d.vn', '40 Nguyễn Thị Minh Khai, Quận 3, TP.HCM', '0310000004', 'https://tech-d.vn', 1),
(5, 'Công ty Giải pháp Máy tính E', 'Võ Quốc Em', '02873000005', 'sales@computer-e.vn', '75 Hoàng Văn Thụ, Tân Bình, TP.HCM', '0310000005', 'https://computer-e.vn', 1),
(6, 'Nhà phân phối Điện tử F', 'Đặng Gia Phúc', '02873000006', 'contact@electronics-f.vn', '19 Điện Biên Phủ, Bình Thạnh, TP.HCM', '0310000006', 'https://electronics-f.vn', 1),
(7, 'Công ty Phụ kiện G', 'Bùi Ngọc Giang', '02873000007', 'sales@accessory-g.vn', '55 Quang Trung, Gò Vấp, TP.HCM', '0310000007', 'https://accessory-g.vn', 1),
(8, 'Công ty Linh kiện H', 'Nguyễn Quốc Hưng', '02873000008', 'contact@components-h.vn', '68 Tô Hiến Thành, Quận 10, TP.HCM', '0310000008', 'https://components-h.vn', 1),
(9, 'Kho Công nghệ I', 'Trần Minh Khoa', '02873000009', 'sales@warehouse-i.vn', '31 Võ Văn Ngân, Thủ Đức, TP.HCM', '0310000009', 'https://warehouse-i.vn', 1),
(10, 'Công ty Thương mại J', 'Hoàng Lan', '02873000010', 'contact@trade-j.vn', '112 Nguyễn Trãi, Quận 5, TP.HCM', '0310000010', 'https://trade-j.vn', 1);
INSERT INTO `products` (`product_id`, `category_id`, `brand_id`, `supplier_id`, `product_name`, `slug`, `sku`, `price`, `sale_price`, `short_description`, `description`, `thumbnail`, `featured`, `status`) VALUES
(1, 10, 3, 1, 'Dell Inspiron 15 3530', 'dell-inspiron-15-3530', 'DELL-3530', 16990000, 15990000, 'Laptop văn phòng Core i5, 16GB RAM', 'Dell Inspiron 15 phù hợp học tập và công việc văn phòng.', 'dell-3530.jpg', 1, 1),
(2, 9, 2, 1, 'ASUS TUF Gaming F15', 'asus-tuf-gaming-f15', 'ASUS-TUF-F15', 23990000, 22490000, 'Laptop gaming RTX 4050', 'ASUS TUF Gaming F15 hiệu năng cao cho game và đồ họa.', 'asus-tuf-f15.jpg', 1, 1),
(3, 10, 5, 2, 'Lenovo IdeaPad Slim 5', 'lenovo-ideapad-slim-5', 'LEN-SLIM5', 18990000, 17990000, 'Laptop mỏng nhẹ Ryzen 7', 'IdeaPad Slim 5 cân bằng hiệu năng và tính di động.', 'lenovo-slim5.jpg', 0, 1),
(4, 9, 8, 2, 'MSI Katana 15', 'msi-katana-15', 'MSI-KAT15', 27990000, 26490000, 'Laptop gaming 15.6 inch', 'MSI Katana 15 dành cho gaming và sáng tạo nội dung.', 'msi-katana15.jpg', 1, 1),
(5, 10, 10, 3, 'Acer Aspire 5', 'acer-aspire-5', 'ACER-A5', 15490000, 14990000, 'Laptop phổ thông Core i5', 'Acer Aspire 5 cho học tập và văn phòng.', 'acer-a5.jpg', 0, 1),
(6, 2, 1, 4, 'iPhone 15 128GB', 'iphone-15-128gb', 'APL-IP15-128', 19990000, 18990000, 'Điện thoại Apple 128GB', 'iPhone 15 màn hình OLED, camera chất lượng cao.', 'iphone15.jpg', 1, 1),
(7, 2, 6, 4, 'Samsung Galaxy S24 256GB', 'samsung-galaxy-s24-256gb', 'SS-S24-256', 20990000, 19490000, 'Galaxy S24 256GB', 'Điện thoại Samsung cao cấp hỗ trợ AI.', 's24.jpg', 1, 1),
(8, 3, 1, 5, 'iPad Air M2 11 inch', 'ipad-air-m2-11', 'APL-IPAD-AIR-M2', 16990000, 16490000, 'Máy tính bảng Apple M2', 'iPad Air M2 mạnh mẽ cho học tập và sáng tạo.', 'ipad-air-m2.jpg', 1, 1),
(9, 3, 6, 5, 'Samsung Galaxy Tab S9 FE', 'galaxy-tab-s9-fe', 'SS-TABS9FE', 10990000, 9990000, 'Tablet Android 10.9 inch', 'Galaxy Tab S9 FE hỗ trợ bút S Pen.', 'tabs9fe.jpg', 0, 1),
(10, 4, 3, 6, 'Dell Monitor P2425H 24 inch', 'dell-monitor-p2425h', 'DELL-P2425H', 4990000, 4590000, 'Màn hình FHD 24 inch', 'Màn hình Dell cho văn phòng, cổng kết nối đa dạng.', 'dell-p2425h.jpg', 0, 1),
(11, 4, 6, 6, 'Samsung Odyssey G5 27 inch', 'samsung-odyssey-g5-27', 'SS-G5-27', 7490000, 6990000, 'Màn hình gaming QHD', 'Odyssey G5 27 inch tần số quét cao.', 'odyssey-g5.jpg', 1, 1),
(12, 5, 7, 7, 'Logitech MX Keys S', 'logitech-mx-keys-s', 'LOG-MXKEYS-S', 2590000, 2390000, 'Bàn phím không dây cao cấp', 'Bàn phím Logitech tối ưu cho làm việc đa thiết bị.', 'mxkeys-s.jpg', 1, 1),
(13, 5, 8, 7, 'MSI Vigor GK30', 'msi-vigor-gk30', 'MSI-GK30', 1090000, 990000, 'Bàn phím gaming RGB', 'Bàn phím gaming MSI với đèn RGB.', 'msi-gk30.jpg', 0, 1),
(14, 6, 7, 7, 'Logitech MX Master 3S', 'logitech-mx-master-3s', 'LOG-MX3S', 2490000, 2290000, 'Chuột không dây cao cấp', 'Chuột công thái học cho người làm việc chuyên nghiệp.', 'mxmaster3s.jpg', 1, 1),
(15, 6, 2, 8, 'ASUS TUF Gaming M3', 'asus-tuf-gaming-m3', 'ASUS-M3', 690000, 590000, 'Chuột gaming 7000 DPI', 'Chuột gaming nhẹ, cảm biến chính xác.', 'asus-m3.jpg', 0, 1),
(16, 7, 7, 8, 'Logitech G435', 'logitech-g435', 'LOG-G435', 1590000, 1390000, 'Tai nghe gaming không dây', 'Tai nghe nhẹ, kết nối Lightspeed và Bluetooth.', 'g435.jpg', 0, 1),
(17, 7, 6, 8, 'Samsung Galaxy Buds3', 'samsung-galaxy-buds3', 'SS-BUDS3', 3990000, 3590000, 'Tai nghe true wireless', 'Tai nghe không dây Samsung hỗ trợ chống ồn.', 'buds3.jpg', 1, 1),
(18, 11, 9, 9, 'Kingston NV2 NVMe 1TB', 'kingston-nv2-1tb', 'KING-NV2-1TB', 1590000, 1450000, 'SSD NVMe PCIe 4.0 1TB', 'Ổ cứng SSD tốc độ cao cho PC và laptop.', 'kingston-nv2.jpg', 1, 1),
(19, 12, 9, 9, 'Kingston Fury Beast 16GB DDR5', 'kingston-fury-beast-16gb-ddr5', 'KING-FURY-16', 1390000, 1290000, 'RAM DDR5 16GB', 'RAM hiệu năng cao cho máy tính để bàn.', 'kingston-fury.jpg', 0, 1),
(20, 4, 2, 10, 'ASUS ProArt Display PA278QV', 'asus-proart-pa278qv', 'ASUS-PA278QV', 8290000, 7890000, 'Màn hình đồ họa 27 inch', 'Màn hình chuẩn màu dành cho thiết kế và sáng tạo.', 'proart-pa278qv.jpg', 1, 1);
INSERT INTO `product_images` (`image_id`, `product_id`, `image_url`, `is_primary`, `sort_order`) VALUES
(1, 1, 'uploads/products/dell-3530-1.jpg', 1, 1),
(2, 2, 'uploads/products/asus-tuf-f15-1.jpg', 1, 1),
(3, 3, 'uploads/products/lenovo-slim5-1.jpg', 1, 1),
(4, 4, 'uploads/products/msi-katana15-1.jpg', 1, 1),
(5, 5, 'uploads/products/acer-a5-1.jpg', 1, 1),
(6, 6, 'uploads/products/iphone15-1.jpg', 1, 1),
(7, 7, 'uploads/products/s24-1.jpg', 1, 1),
(8, 8, 'uploads/products/ipad-air-m2-1.jpg', 1, 1),
(9, 9, 'uploads/products/tabs9fe-1.jpg', 1, 1),
(10, 10, 'uploads/products/dell-p2425h-1.jpg', 1, 1),
(11, 11, 'uploads/products/odyssey-g5-1.jpg', 1, 1),
(12, 12, 'uploads/products/mxkeys-s-1.jpg', 1, 1),
(13, 13, 'uploads/products/msi-gk30-1.jpg', 1, 1),
(14, 14, 'uploads/products/mxmaster3s-1.jpg', 1, 1),
(15, 15, 'uploads/products/asus-m3-1.jpg', 1, 1),
(16, 16, 'uploads/products/g435-1.jpg', 1, 1),
(17, 17, 'uploads/products/buds3-1.jpg', 1, 1),
(18, 18, 'uploads/products/kingston-nv2-1.jpg', 1, 1),
(19, 19, 'uploads/products/kingston-fury-1.jpg', 1, 1),
(20, 20, 'uploads/products/proart-pa278qv-1.jpg', 1, 1);
INSERT INTO `product_specifications` (`spec_id`, `product_id`, `spec_name`, `spec_value`, `sort_order`) VALUES
(1, 1, 'CPU', 'Intel Core i5-1335U', 1),
(2, 1, 'RAM', '16GB DDR4', 2),
(3, 1, 'SSD', '512GB NVMe', 3),
(4, 1, 'Màn hình', '15.6 inch FHD', 4),
(5, 2, 'CPU', 'Intel Core i7-13620H', 1),
(6, 2, 'GPU', 'NVIDIA GeForce RTX 4050 6GB', 2),
(7, 2, 'RAM', '16GB DDR5', 3),
(8, 2, 'SSD', '512GB NVMe', 4),
(9, 6, 'Màn hình', '6.1 inch OLED', 1),
(10, 6, 'Bộ nhớ', '128GB', 2),
(11, 6, 'Camera chính', '48MP', 3),
(12, 6, 'Kết nối', '5G, Wi-Fi 6', 4),
(13, 10, 'Kích thước', '24 inch', 1),
(14, 10, 'Độ phân giải', '1920x1080', 2),
(15, 10, 'Tấm nền', 'IPS', 3),
(16, 10, 'Tần số quét', '100Hz', 4),
(17, 18, 'Dung lượng', '1TB', 1),
(18, 18, 'Chuẩn', 'NVMe PCIe 4.0', 2),
(19, 18, 'Đọc tuần tự', '3500 MB/s', 3),
(20, 18, 'Ghi tuần tự', '2100 MB/s', 4);
INSERT INTO `inventory` (`inventory_id`, `product_id`, `quantity`, `reserved_quantity`, `min_quantity`) VALUES
(1, 1, 18, 2, 5),
(2, 2, 12, 1, 4),
(3, 3, 15, 2, 4),
(4, 4, 9, 1, 3),
(5, 5, 22, 3, 5),
(6, 6, 30, 4, 8),
(7, 7, 24, 2, 6),
(8, 8, 14, 1, 4),
(9, 9, 17, 2, 5),
(10, 10, 20, 2, 5),
(11, 11, 11, 1, 3),
(12, 12, 35, 4, 8),
(13, 13, 28, 3, 6),
(14, 14, 32, 4, 8),
(15, 15, 40, 5, 10),
(16, 16, 26, 3, 6),
(17, 17, 19, 2, 5),
(18, 18, 45, 5, 10),
(19, 19, 50, 6, 12),
(20, 20, 8, 1, 3);
INSERT INTO `coupons` (`coupon_id`, `code`, `coupon_name`, `discount_type`, `discount_value`, `min_order_value`, `max_discount`, `usage_limit`, `used_count`, `start_date`, `end_date`, `status`) VALUES
(1, 'WELCOME10', 'Ưu đãi khách hàng mới', 'percent', 10, 500000, 200000, 100, 12, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1),
(2, 'LAPTOP500K', 'Giảm 500K cho đơn laptop', 'fixed', 500000, 15000000, NULL, 50, 8, '2026-09-01 00:00:00', '2026-10-31 23:59:59', 1),
(3, 'TECH5', 'Giảm 5% toàn shop', 'percent', 5, 1000000, 300000, 200, 21, '2026-08-01 00:00:00', '2026-12-31 23:59:59', 1),
(4, 'FREESHIP50', 'Hỗ trợ phí vận chuyển', 'fixed', 50000, 500000, NULL, 300, 45, '2026-09-01 00:00:00', '2026-12-31 23:59:59', 1),
(5, 'PHONE8', 'Giảm 8% điện thoại', 'percent', 8, 10000000, 500000, 60, 10, '2026-09-15 00:00:00', '2026-10-15 23:59:59', 1),
(6, 'VIP300K', 'Ưu đãi thành viên', 'fixed', 300000, 5000000, NULL, 100, 15, '2026-09-01 00:00:00', '2026-11-30 23:59:59', 1),
(7, 'WEEKEND7', 'Cuối tuần giảm 7%', 'percent', 7, 2000000, 250000, 80, 20, '2026-09-01 00:00:00', '2026-09-30 23:59:59', 1),
(8, 'ACCESSORY15', 'Phụ kiện giảm 15%', 'percent', 15, 1000000, 200000, 100, 30, '2026-09-01 00:00:00', '2026-10-31 23:59:59', 1),
(9, 'BACK2SCHOOL', 'Ưu đãi mùa tựu trường', 'fixed', 250000, 3000000, NULL, 150, 70, '2026-08-15 00:00:00', '2026-09-30 23:59:59', 1),
(10, 'EXPIRED10', 'Mã khuyến mãi đã hết hạn', 'percent', 10, 1000000, 150000, 20, 20, '2026-07-01 00:00:00', '2026-07-31 23:59:59', 0);
INSERT INTO `carts` (`cart_id`, `user_id`, `status`) VALUES
(1, 4, 'active'),
(2, 5, 'active'),
(3, 6, 'converted'),
(4, 7, 'active'),
(5, 8, 'converted'),
(6, 9, 'active'),
(7, 10, 'active'),
(8, 11, 'converted'),
(9, 12, 'active'),
(10, 13, 'abandoned');
INSERT INTO `cart_items` (`cart_item_id`, `cart_id`, `product_id`, `quantity`, `unit_price`) VALUES
(1, 1, 2, 1, 22490000),
(2, 1, 14, 1, 2290000),
(3, 2, 6, 1, 18990000),
(4, 2, 17, 1, 3590000),
(5, 3, 1, 1, 15990000),
(6, 3, 12, 1, 2390000),
(7, 4, 8, 1, 16490000),
(8, 4, 16, 1, 1390000),
(9, 5, 7, 1, 19490000),
(10, 5, 17, 1, 3590000),
(11, 6, 10, 2, 4590000),
(12, 6, 12, 1, 2390000),
(13, 7, 3, 1, 17990000),
(14, 7, 14, 1, 2290000),
(15, 8, 18, 2, 1450000),
(16, 8, 19, 2, 1290000),
(17, 9, 20, 1, 7890000),
(18, 9, 12, 1, 2390000),
(19, 10, 15, 1, 590000),
(20, 10, 16, 1, 1390000);
INSERT INTO `orders` (`order_id`, `user_id`, `coupon_id`, `order_code`, `receiver_name`, `receiver_phone`, `shipping_address`, `subtotal`, `discount_amount`, `shipping_fee`, `total_amount`, `payment_method`, `shipping_method`, `status`, `note`, `order_date`) VALUES
(1, 4, 1, 'MS202609001', 'Lê Quốc Bảo', '0912000001', '12 Cách Mạng Tháng 8, Quận 3, TP.HCM', 18280000, 200000, 30000, 18110000, 'COD', 'standard', 'completed', 'Giao giờ hành chính', '2026-09-03 09:15:00'),
(2, 5, 3, 'MS202609002', 'Phạm Thu Hà', '0912000002', '45 Nguyễn Trãi, Quận 5, TP.HCM', 19580000, 300000, 0, 19280000, 'Bank Transfer', 'standard', 'completed', NULL, '2026-09-04 14:20:00'),
(3, 6, 2, 'MS202609003', 'Võ Minh Khang', '0912000003', '18 Phan Xích Long, Phú Nhuận, TP.HCM', 22490000, 500000, 0, 21990000, 'VNPay', 'express', 'shipping', 'Gọi trước khi giao', '2026-09-06 10:05:00'),
(4, 7, NULL, 'MS202609004', 'Đặng Ngọc Mai', '0912000004', '73 Hoàng Văn Thụ, Tân Bình, TP.HCM', 10580000, 0, 30000, 10610000, 'COD', 'standard', 'confirmed', NULL, '2026-09-08 16:40:00'),
(5, 8, 5, 'MS202609005', 'Bùi Gia Huy', '0912000005', '31 Võ Văn Ngân, Thủ Đức, TP.HCM', 19490000, 500000, 0, 18990000, 'Momo', 'express', 'processing', NULL, '2026-09-10 11:00:00'),
(6, 9, 8, 'MS202609006', 'Nguyễn Thảo Vy', '0912000006', '20 Nguyễn Văn Linh, Quận 7, TP.HCM', 6260000, 200000, 30000, 6090000, 'COD', 'standard', 'completed', NULL, '2026-09-11 08:30:00'),
(7, 10, 4, 'MS202609007', 'Trần Đức Long', '0912000007', '15 Quang Trung, Gò Vấp, TP.HCM', 1450000, 50000, 30000, 1430000, 'Bank Transfer', 'standard', 'completed', NULL, '2026-09-12 19:10:00'),
(8, 11, 6, 'MS202609008', 'Phan Ngọc Hân', '0912000008', '62 Lũy Bán Bích, Tân Phú, TP.HCM', 9180000, 300000, 0, 8880000, 'VNPay', 'express', 'shipping', 'Giao sau 17h', '2026-09-14 13:25:00'),
(9, 12, NULL, 'MS202609009', 'Lý Minh Tuấn', '0912000009', '101 Kha Vạn Cân, Thủ Đức, TP.HCM', 2590000, 0, 30000, 2620000, 'COD', 'standard', 'cancelled', 'Khách đổi ý', '2026-09-15 10:45:00'),
(10, 13, 7, 'MS202609010', 'Hoàng Anh Thư', '0912000010', '9 Nguyễn Oanh, Gò Vấp, TP.HCM', 5040000, 250000, 30000, 4820000, 'Momo', 'standard', 'completed', NULL, '2026-09-16 15:50:00'),
(11, 14, 4, 'MS202609011', 'Đỗ Nhật Quang', '0912000011', '52 Tô Hiến Thành, Quận 10, TP.HCM', 2290000, 50000, 30000, 2270000, 'COD', 'standard', 'processing', NULL, '2026-09-18 09:00:00'),
(12, 4, NULL, 'MS202609012', 'Lê Quốc Bảo', '0912000001', '12 Cách Mạng Tháng 8, Quận 3, TP.HCM', 6990000, 0, 0, 6990000, 'Bank Transfer', 'express', 'pending', 'Xuất hóa đơn điện tử', '2026-09-21 18:15:00');
INSERT INTO `order_items` (`order_item_id`, `order_id`, `product_id`, `product_name`, `quantity`, `unit_price`, `subtotal`) VALUES
(1, 1, 1, 'Dell Inspiron 15 3530', 1, 15990000, 15990000),
(2, 1, 14, 'Logitech MX Master 3S', 1, 2290000, 2290000),
(3, 2, 6, 'iPhone 15 128GB', 1, 18990000, 18990000),
(4, 3, 2, 'ASUS TUF Gaming F15', 1, 22490000, 22490000),
(5, 4, 9, 'Samsung Galaxy Tab S9 FE', 1, 9990000, 9990000),
(6, 5, 7, 'Samsung Galaxy S24 256GB', 1, 19490000, 19490000),
(7, 6, 12, 'Logitech MX Keys S', 1, 2390000, 2390000),
(8, 6, 14, 'Logitech MX Master 3S', 1, 2290000, 2290000),
(9, 6, 15, 'ASUS TUF Gaming M3', 1, 590000, 590000),
(10, 6, 16, 'Logitech G435', 1, 990000, 990000),
(11, 7, 18, 'Kingston NV2 NVMe 1TB', 1, 1450000, 1450000),
(12, 8, 20, 'ASUS ProArt Display PA278QV', 1, 7890000, 7890000),
(13, 9, 12, 'Logitech MX Keys S', 1, 2590000, 2590000),
(14, 10, 17, 'Samsung Galaxy Buds3', 1, 3590000, 3590000),
(15, 11, 14, 'Logitech MX Master 3S', 1, 2290000, 2290000),
(16, 12, 11, 'Samsung Odyssey G5 27 inch', 1, 6990000, 6990000),
(17, 2, 15, 'ASUS TUF Gaming M3', 1, 590000, 590000),
(18, 4, 15, 'ASUS TUF Gaming M3', 1, 590000, 590000),
(19, 8, 19, 'Kingston Fury Beast 16GB DDR5', 1, 1290000, 1290000),
(20, 10, 18, 'Kingston NV2 NVMe 1TB', 1, 1450000, 1450000);
INSERT INTO `payments` (`payment_id`, `order_id`, `payment_method`, `amount`, `transaction_code`, `payment_status`, `paid_at`) VALUES
(1, 1, 'COD', 18110000, 'COD-MS202609001', 'paid', '2026-09-05 16:30:00'),
(2, 2, 'Bank Transfer', 19280000, 'BANK-0904-0002', 'paid', '2026-09-04 14:35:00'),
(3, 3, 'VNPay', 21990000, 'VNP-20260906-0003', 'paid', '2026-09-06 10:10:00'),
(4, 4, 'COD', 10610000, 'COD-MS202609004', 'pending', NULL),
(5, 5, 'Momo', 18990000, 'MOMO-20260910-0005', 'paid', '2026-09-10 11:03:00'),
(6, 6, 'COD', 6090000, 'COD-MS202609006', 'paid', '2026-09-13 09:20:00'),
(7, 7, 'Bank Transfer', 1430000, 'BANK-0912-0007', 'paid', '2026-09-12 19:20:00'),
(8, 8, 'VNPay', 8880000, 'VNP-20260914-0008', 'paid', '2026-09-14 13:30:00'),
(9, 9, 'COD', 2620000, 'COD-MS202609009', 'failed', NULL),
(10, 10, 'Momo', 4820000, 'MOMO-20260916-0010', 'paid', '2026-09-16 15:55:00'),
(11, 11, 'COD', 2270000, 'COD-MS202609011', 'pending', NULL),
(12, 12, 'Bank Transfer', 6990000, 'BANK-0921-0012', 'pending', NULL);
INSERT INTO `reviews` (`review_id`, `product_id`, `user_id`, `rating`, `title`, `comment`, `is_verified_purchase`, `admin_reply`, `replied_by`, `replied_at`, `status`, `created_at`) VALUES
(1, 1, 4, 5, 'Đúng nhu cầu văn phòng', 'Máy chạy ổn định, bàn phím dễ dùng.', 1, 'Cảm ơn bạn đã lựa chọn MiniShop.', 2, '2026-09-07 09:10:00', 1, '2026-09-06 20:00:00'),
(2, 6, 5, 5, 'Camera tốt', 'Máy đẹp, camera chụp tốt và pin đủ dùng.', 1, 'Cảm ơn bạn đã chia sẻ trải nghiệm.', 1, '2026-09-08 10:30:00', 1, '2026-09-07 18:20:00'),
(3, 2, 6, 4, 'Hiệu năng tốt', 'Chơi game mượt nhưng quạt hơi ồn khi tải nặng.', 1, 'Cảm ơn góp ý của bạn. Đây là đặc điểm thường gặp khi máy hoạt động ở hiệu năng cao.', 2, '2026-09-10 14:00:00', 1, '2026-09-09 21:15:00'),
(4, 9, 7, 4, 'Phù hợp học tập', 'Màn hình đẹp, bút dùng tiện.', 1, NULL, NULL, NULL, 1, '2026-09-12 08:45:00'),
(5, 7, 8, 5, 'Rất hài lòng', 'Máy nhỏ gọn, màn hình sáng.', 1, 'MiniShop cảm ơn bạn.', 3, '2026-09-13 16:10:00', 1, '2026-09-12 19:30:00'),
(6, 12, 9, 5, 'Gõ êm', 'Bàn phím tốt cho công việc văn phòng.', 1, NULL, NULL, NULL, 1, '2026-09-14 09:20:00'),
(7, 18, 10, 4, 'SSD nhanh', 'Tốc độ tốt, cài Windows nhanh.', 1, 'Cảm ơn bạn đã đánh giá sản phẩm.', 2, '2026-09-15 11:40:00', 1, '2026-09-14 22:05:00'),
(8, 20, 11, 5, 'Màu sắc đẹp', 'Màn hình hiển thị màu rất ổn cho thiết kế.', 1, NULL, NULL, NULL, 1, '2026-09-16 13:00:00'),
(9, 14, 12, 5, 'Chuột rất tốt', 'Cầm lâu không mỏi, cuộn rất tiện.', 0, 'Cảm ơn phản hồi chi tiết của bạn.', 1, '2026-09-17 08:30:00', 1, '2026-09-16 20:10:00'),
(10, 17, 13, 4, 'Âm thanh ổn', 'Chống ồn tốt, kết nối nhanh.', 1, NULL, NULL, NULL, 1, '2026-09-18 19:00:00'),
(11, 11, 14, 5, 'Màn hình gaming tốt', '144Hz mượt, màu đẹp.', 0, 'Cảm ơn bạn đã tin tưởng MiniShop.', 2, '2026-09-20 10:00:00', 1, '2026-09-19 18:00:00'),
(12, 15, 4, 4, 'Chuột nhẹ', 'Giá hợp lý và thao tác nhanh.', 0, NULL, NULL, NULL, 1, '2026-09-20 21:30:00'),
(13, 16, 5, 4, 'Tai nghe nhẹ', 'Đeo lâu khá thoải mái.', 0, 'Cảm ơn bạn. MiniShop ghi nhận phản hồi.', 3, '2026-09-21 09:15:00', 1, '2026-09-20 22:10:00'),
(14, 19, 6, 5, 'RAM ổn định', 'Lắp vào nhận ngay, chạy ổn định.', 0, NULL, NULL, NULL, 1, '2026-09-21 12:00:00'),
(15, 10, 7, 3, 'Màn hình ổn', 'Hình ảnh tốt nhưng chân đế hơi lớn.', 0, 'Cảm ơn góp ý của bạn. MiniShop sẽ bổ sung thông tin kích thước chân đế rõ hơn.', 2, '2026-09-22 08:00:00', 1, '2026-09-21 20:20:00');

SET FOREIGN_KEY_CHECKS = 1;

-- Quick checks
SELECT 'users' AS table_name, COUNT(*) AS row_count FROM `users`;
SELECT 'categories' AS table_name, COUNT(*) AS row_count FROM `categories`;
SELECT 'brands' AS table_name, COUNT(*) AS row_count FROM `brands`;
SELECT 'suppliers' AS table_name, COUNT(*) AS row_count FROM `suppliers`;
SELECT 'products' AS table_name, COUNT(*) AS row_count FROM `products`;
SELECT 'product_images' AS table_name, COUNT(*) AS row_count FROM `product_images`;
SELECT 'product_specifications' AS table_name, COUNT(*) AS row_count FROM `product_specifications`;
SELECT 'inventory' AS table_name, COUNT(*) AS row_count FROM `inventory`;
SELECT 'coupons' AS table_name, COUNT(*) AS row_count FROM `coupons`;
SELECT 'carts' AS table_name, COUNT(*) AS row_count FROM `carts`;
SELECT 'cart_items' AS table_name, COUNT(*) AS row_count FROM `cart_items`;
SELECT 'orders' AS table_name, COUNT(*) AS row_count FROM `orders`;
SELECT 'order_items' AS table_name, COUNT(*) AS row_count FROM `order_items`;
SELECT 'payments' AS table_name, COUNT(*) AS row_count FROM `payments`;
SELECT 'reviews' AS table_name, COUNT(*) AS row_count FROM `reviews`;
