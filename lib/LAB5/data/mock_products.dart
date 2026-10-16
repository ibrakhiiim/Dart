import 'package:flutter/material.dart';

import '../models/product.dart';

// Бренды
const List<String> kBrands = ['All brands', 'Apple', 'Samsung'];

// Демо-товары
const List<Product> kMockProducts = [
  // iPhone 16 Pro
  Product(
    id: 'iphone-16-pro',
    name: 'iPhone 16 Pro',
    brand: 'Apple',
    category: ProductCategory.smartphones,
    description:
        'Титановый корпус, экран 6,3" ProMotion 120 Гц и чип A18 Pro. '
        'Основная камера 48 Мп, 5-кратный оптический зум и отдельная '
        'кнопка управления камерой. Отлично подходит для съёмки видео '
        'в 4K и мобильных игр.',
    imageUrl:
        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800',
    basePrice: 649990,
    oldPrice: 699990,
    rating: 4.9,
    reviewCount: 2140,
    tags: ['Smartphone', 'Bestseller', '5G', 'Titanium'],
    colors: [
      ProductColor('Desert Titanium', Color(0xFFC4A98C)),
      ProductColor('Natural Titanium', Color(0xFFB9B4AA)),
      ProductColor('Black Titanium', Color(0xFF3B3B3D)),
      ProductColor('White Titanium', Color(0xFFF2F1EC)),
    ],
    storageOptions: [
      StorageOption('128 GB'),
      StorageOption('256 GB', 70000),
      StorageOption('512 GB', 180000),
      StorageOption('1 TB', 290000),
    ],
    specs: [
      ProductSpec(Icons.smartphone_rounded, 'Display', '6.3" OLED 120 Hz'),
      ProductSpec(Icons.memory_rounded, 'Chip', 'A18 Pro'),
      ProductSpec(Icons.photo_camera_rounded, 'Camera', '48 MP triple'),
      ProductSpec(Icons.battery_charging_full_rounded, 'Battery',
          'Up to 27 h video'),
    ],
  ),
  // Galaxy S25 Ultra
  Product(
    id: 'galaxy-s25-ultra',
    name: 'Samsung Galaxy S25 Ultra',
    brand: 'Samsung',
    category: ProductCategory.smartphones,
    description:
        'Флагман Samsung с большим экраном 6,9", встроенным пером S Pen и '
        'камерой 200 Мп. Процессор Snapdragon 8 Elite for Galaxy и функции '
        'Galaxy AI: перевод звонков, умное редактирование фото и заметок.',
    imageUrl:
        'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=800',
    basePrice: 619990,
    oldPrice: 689990,
    rating: 4.8,
    reviewCount: 1675,
    tags: ['Smartphone', 'S Pen', 'Galaxy AI', '5G'],
    colors: [
      ProductColor('Titanium Silverblue', Color(0xFF8FA3B8)),
      ProductColor('Titanium Black', Color(0xFF2E2E30)),
      ProductColor('Titanium Gray', Color(0xFF8C8C8E)),
      ProductColor('Titanium Whitesilver', Color(0xFFE8E8EA)),
    ],
    storageOptions: [
      StorageOption('256 GB'),
      StorageOption('512 GB', 90000),
      StorageOption('1 TB', 230000),
    ],
    specs: [
      ProductSpec(Icons.smartphone_rounded, 'Display', '6.9" AMOLED 120 Hz'),
      ProductSpec(Icons.memory_rounded, 'Chip', 'Snapdragon 8 Elite'),
      ProductSpec(Icons.photo_camera_rounded, 'Camera', '200 MP quad'),
      ProductSpec(Icons.battery_charging_full_rounded, 'Battery', '5000 mAh'),
    ],
  ),
  // iPhone 16
  Product(
    id: 'iphone-16',
    name: 'iPhone 16',
    brand: 'Apple',
    category: ProductCategory.smartphones,
    description:
        'Яркие цвета, экран 6,1", чип A18 и камера 48 Мп с режимом '
        '2-кратного зума. Кнопка действия и кнопка управления камерой.',
    imageUrl:
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800',
    basePrice: 459990,
    rating: 4.7,
    reviewCount: 980,
    tags: ['Smartphone', '5G', 'New'],
    colors: [
      ProductColor('Ultramarine', Color(0xFF7A8DE8)),
      ProductColor('Teal', Color(0xFF9CC9C1)),
      ProductColor('Pink', Color(0xFFF2B8C9)),
      ProductColor('Black', Color(0xFF2B2B2D)),
    ],
    storageOptions: [
      StorageOption('128 GB'),
      StorageOption('256 GB', 70000),
      StorageOption('512 GB', 180000),
    ],
    specs: [
      ProductSpec(Icons.smartphone_rounded, 'Display', '6.1" OLED'),
      ProductSpec(Icons.memory_rounded, 'Chip', 'A18'),
      ProductSpec(Icons.photo_camera_rounded, 'Camera', '48 MP dual'),
      ProductSpec(Icons.battery_charging_full_rounded, 'Battery',
          'Up to 22 h video'),
    ],
  ),
  // Galaxy Z Flip6
  Product(
    id: 'galaxy-z-flip6',
    name: 'Samsung Galaxy Z Flip6',
    brand: 'Samsung',
    category: ProductCategory.smartphones,
    description:
        'Складной смартфон, который помещается в любой карман. Внешний '
        'экран 3,4" для уведомлений и селфи, основной экран 6,7".',
    imageUrl:
        'https://images.unsplash.com/photo-1610792516307-ea5acd9c3b00?w=800',
    basePrice: 499990,
    oldPrice: 549990,
    rating: 4.5,
    reviewCount: 612,
    tags: ['Smartphone', 'Foldable', 'Compact'],
    colors: [
      ProductColor('Mint', Color(0xFFBFE3D0)),
      ProductColor('Yellow', Color(0xFFF5E08A)),
      ProductColor('Silver Shadow', Color(0xFFBDBDC2)),
      ProductColor('Blue', Color(0xFF8FB0DE)),
    ],
    storageOptions: [
      StorageOption('256 GB'),
      StorageOption('512 GB', 60000),
    ],
    specs: [
      ProductSpec(Icons.smartphone_rounded, 'Display', '6.7" + 3.4" cover'),
      ProductSpec(Icons.memory_rounded, 'Chip', 'Snapdragon 8 Gen 3'),
      ProductSpec(Icons.photo_camera_rounded, 'Camera', '50 MP dual'),
      ProductSpec(Icons.battery_charging_full_rounded, 'Battery', '4000 mAh'),
    ],
  ),
  // iPad Air
  Product(
    id: 'ipad-air-m2',
    name: 'iPad Air 11" (M2)',
    brand: 'Apple',
    category: ProductCategory.tablets,
    description:
        'Лёгкий планшет для учёбы и творчества. Чип M2, поддержка '
        'Apple Pencil Pro и клавиатуры Magic Keyboard — удобно вести '
        'конспекты на парах.',
    imageUrl:
        'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=800',
    basePrice: 379990,
    rating: 4.8,
    reviewCount: 430,
    tags: ['Tablet', 'For students', 'Apple Pencil'],
    colors: [
      ProductColor('Space Gray', Color(0xFF5E5E62)),
      ProductColor('Blue', Color(0xFFA5B8CF)),
      ProductColor('Purple', Color(0xFFC8BCD9)),
      ProductColor('Starlight', Color(0xFFEDE6DA)),
    ],
    storageOptions: [
      StorageOption('128 GB'),
      StorageOption('256 GB', 60000),
      StorageOption('512 GB', 170000),
    ],
    specs: [
      ProductSpec(Icons.tablet_mac_rounded, 'Display', '11" Liquid Retina'),
      ProductSpec(Icons.memory_rounded, 'Chip', 'Apple M2'),
      ProductSpec(Icons.photo_camera_rounded, 'Camera', '12 MP'),
      ProductSpec(Icons.battery_charging_full_rounded, 'Battery',
          'Up to 10 h'),
    ],
  ),
  // MacBook Air
  Product(
    id: 'macbook-air-m3',
    name: 'MacBook Air 13" (M3)',
    brand: 'Apple',
    category: ProductCategory.laptops,
    description:
        'Тонкий и тихий ноутбук без вентилятора. Чип M3, до 18 часов '
        'работы от батареи — хватит на целый учебный день.',
    imageUrl:
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800',
    basePrice: 599990,
    oldPrice: 649990,
    rating: 4.9,
    reviewCount: 815,
    tags: ['Laptop', 'For students', 'Lightweight'],
    colors: [
      ProductColor('Midnight', Color(0xFF2E3440)),
      ProductColor('Starlight', Color(0xFFEDE6DA)),
      ProductColor('Space Gray', Color(0xFF7D7E80)),
      ProductColor('Silver', Color(0xFFE3E4E5)),
    ],
    storageOptions: [
      StorageOption('256 GB'),
      StorageOption('512 GB', 120000),
    ],
    specs: [
      ProductSpec(Icons.laptop_mac_rounded, 'Display', '13.6" Liquid Retina'),
      ProductSpec(Icons.memory_rounded, 'Chip', 'Apple M3'),
      ProductSpec(Icons.sd_storage_rounded, 'Memory', '16 GB RAM'),
      ProductSpec(Icons.battery_charging_full_rounded, 'Battery',
          'Up to 18 h'),
    ],
  ),
  // AirPods Pro 2
  Product(
    id: 'airpods-pro-2',
    name: 'AirPods Pro 2',
    brand: 'Apple',
    category: ProductCategory.audio,
    description:
        'Беспроводные наушники с активным шумоподавлением и режимом '
        'прозрачности. Кейс с зарядкой через USB-C.',
    imageUrl:
        'https://images.unsplash.com/photo-1600294037681-c80b4cb5b434?w=800',
    basePrice: 119990,
    oldPrice: 139990,
    rating: 4.7,
    reviewCount: 3020,
    tags: ['Audio', 'Noise cancelling', 'Bestseller'],
    colors: [
      ProductColor('White', Color(0xFFF7F7F7)),
    ],
    specs: [
      ProductSpec(Icons.hearing_rounded, 'Noise control', 'Active ANC'),
      ProductSpec(Icons.memory_rounded, 'Chip', 'Apple H2'),
      ProductSpec(Icons.usb_rounded, 'Charging', 'USB-C case'),
      ProductSpec(Icons.battery_charging_full_rounded, 'Battery',
          'Up to 6 h'),
    ],
  ),
];
