import 'models/product.dart';
import 'models/brand.dart';
import 'models/category.dart';

/// Provides demo data for the app when no backend is connected.
class DemoData {
  DemoData._();

  static List<String> get bannerImages => [
    'https://images.unsplash.com/photo-1556906781-9a412961c28c?w=800&q=80',
    'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=800&q=80',
    'https://images.unsplash.com/photo-1597045566677-8cf032ed6634?w=800&q=80',
  ];

  static List<Brand> get brands => [
    Brand(id: 'nike', name: 'Nike', productCount: 42, isFeatured: true),
    Brand(id: 'jordan', name: 'Jordan', productCount: 35, isFeatured: true),
    Brand(id: 'adidas', name: 'Adidas', productCount: 28, isFeatured: true),
    Brand(
      id: 'new-balance',
      name: 'New Balance',
      productCount: 18,
      isFeatured: true,
    ),
    Brand(id: 'puma', name: 'Puma', productCount: 15, isFeatured: false),
    Brand(
      id: 'converse',
      name: 'Converse',
      productCount: 12,
      isFeatured: false,
    ),
    Brand(id: 'reebok', name: 'Reebok', productCount: 10, isFeatured: false),
    Brand(id: 'asics', name: 'ASICS', productCount: 8, isFeatured: false),
    Brand(id: 'vans', name: 'Vans', productCount: 14, isFeatured: false),
    Brand(
      id: 'on-running',
      name: 'On Running',
      productCount: 6,
      isFeatured: true,
    ),
  ];

  static List<Category> get categories => [
    Category(id: 'new-in', name: 'New In', productCount: 45),
    Category(id: 'apparel', name: 'Apparel', productCount: 65),
    Category(id: 'footwear', name: 'Footwear', productCount: 120),
    Category(id: 'running', name: 'Running', productCount: 30),
    Category(id: 'vegnonveg', name: 'VegNonVeg', productCount: 50),
    Category(id: 'women', name: 'Women', productCount: 40),
    Category(id: 'lifestyle', name: 'Lifestyle', productCount: 35),
    Category(id: 'brands', name: 'Brands', productCount: 80),
    Category(id: 'markdowns', name: 'Markdowns', productCount: 25),
    Category(id: 'shop-the-look', name: 'Shop The Look', productCount: 15),
  ];

  static final List<String> _defaultSizes = [
    'UK 6',
    'UK 7',
    'UK 8',
    'UK 9',
    'UK 10',
    'UK 11',
  ];

  static List<Product> get allProducts => [
    Product(
      id: 'p001',
      name: 'Air Jordan 1 Retro High OG',
      brand: 'Jordan',
      price: 16995,
      images: [
        'https://images.unsplash.com/photo-1584735175315-9d5df23860e6?w=400&q=80',
        'https://images.unsplash.com/photo-1597045566677-8cf032ed6634?w=400&q=80',
      ],
      description:
          'The Air Jordan 1 Retro High OG brings back the iconic silhouette with premium leather and original colorway. A timeless shoe that started it all.',
      sizes: _defaultSizes,
      colors: ['Black', 'Red', 'White'],
      category: 'sneakers',
      gender: 'Unisex',
      rating: 4.8,
      reviewCount: 342,
      specifications: {
        'Style Code': '555088-134',
        'Colorway': 'Black/Red/White',
        'Release Date': '2025-12-01',
      },
    ),
    Product(
      id: 'p002',
      name: 'Nike Dunk Low Retro',
      brand: 'Nike',
      price: 8695,
      discountedPrice: 7495,
      images: [
        'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400&q=80',
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&q=80',
      ],
      description:
          'Created for the hardwood but taken to the streets, the Nike Dunk Low Retro returns with crisp overlays and classic team colors.',
      sizes: _defaultSizes,
      colors: ['White', 'Black'],
      category: 'sneakers',
      gender: 'Men',
      rating: 4.6,
      reviewCount: 215,
      specifications: {
        'Style Code': 'DD1391-100',
        'Colorway': 'White/Black',
        'Collection': 'Dunk Low',
      },
    ),
    Product(
      id: 'p003',
      name: 'Adidas Yeezy Boost 350 V2',
      brand: 'Adidas',
      price: 22999,
      images: [
        'https://images.unsplash.com/photo-1587563871167-1ee9c731aefb?w=400&q=80',
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400&q=80',
      ],
      description:
          'The Adidas Yeezy Boost 350 V2 features Primeknit upper and full-length Boost for unparalleled comfort. The signature side stripe adds a bold look.',
      sizes: ['UK 6', 'UK 7', 'UK 8', 'UK 9', 'UK 10'],
      colors: ['Onyx'],
      category: 'sneakers',
      gender: 'Unisex',
      isAvailable: false,
      rating: 4.9,
      reviewCount: 520,
      specifications: {
        'Style Code': 'HQ4540',
        'Colorway': 'Onyx/Onyx/Onyx',
        'Technology': 'Boost',
      },
    ),
    Product(
      id: 'p004',
      name: 'New Balance 550',
      brand: 'New Balance',
      price: 12999,
      images: [
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=400&q=80',
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',
      ],
      description:
          'The New Balance 550 is a retro basketball sneaker brought back with leather upper and vintage-inspired design. Clean, classic, and versatile.',
      sizes: _defaultSizes,
      colors: ['White', 'Green'],
      category: 'sneakers',
      gender: 'Unisex',
      rating: 4.5,
      reviewCount: 178,
      specifications: {
        'Style Code': 'BB550WT1',
        'Colorway': 'White/Green',
        'Material': 'Leather',
      },
    ),
    Product(
      id: 'p005',
      name: 'Nike Air Force 1 \'07',
      brand: 'Nike',
      price: 7495,
      images: [
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400&q=80',
        'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400&q=80',
      ],
      description:
          'The radiance lives on. The Nike Air Force 1 \'07 features the iconic AF-1 with premium leather and Air cushioning that revolutionized the game.',
      sizes: _defaultSizes,
      colors: ['White'],
      category: 'sneakers',
      gender: 'Men',
      rating: 4.7,
      reviewCount: 890,
      specifications: {
        'Style Code': 'CW2288-111',
        'Colorway': 'White/White',
        'Air': 'Air-Sole unit',
      },
    ),
    Product(
      id: 'p006',
      name: 'Air Jordan 4 Retro',
      brand: 'Jordan',
      price: 19995,
      isPreorder: true,
      images: [
        'https://images.unsplash.com/photo-1584735175315-9d5df23860e6?w=400&q=80',
        'https://images.unsplash.com/photo-1597045566677-8cf032ed6634?w=400&q=80',
      ],
      description:
          'Originally released in 1989, the Air Jordan 4 is one of the most beloved silhouettes. This retro release features premium materials and classic detailing.',
      sizes: ['UK 7', 'UK 8', 'UK 9', 'UK 10'],
      colors: ['Military Black'],
      category: 'sneakers',
      gender: 'Men',
      releaseDate: DateTime(2026, 3, 15),
      rating: 4.9,
      reviewCount: 67,
      specifications: {
        'Style Code': 'DH6927-111',
        'Colorway': 'White/Military Black',
        'Release Date': 'March 15, 2026',
      },
    ),
    Product(
      id: 'p007',
      name: 'Adidas Ultraboost Light',
      brand: 'Adidas',
      price: 16999,
      discountedPrice: 13599,
      images: [
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400&q=80',
        'https://images.unsplash.com/photo-1587563871167-1ee9c731aefb?w=400&q=80',
      ],
      description:
          'The lightest Ultraboost ever, featuring Light BOOST midsole for ultimate energy return. Adidas Primeknit+ upper adapts to your foot for a perfect fit.',
      sizes: _defaultSizes,
      colors: ['Core Black', 'Cloud White'],
      category: 'sneakers',
      gender: 'Men',
      rating: 4.4,
      reviewCount: 156,
      specifications: {
        'Technology': 'Light BOOST',
        'Upper': 'Primeknit+',
        'Drop': '10mm',
      },
    ),
    Product(
      id: 'p008',
      name: 'Nike Air Max 90',
      brand: 'Nike',
      price: 11895,
      images: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&q=80',
      ],
      description:
          'Nothing as iconic, nothing as comfortable. The Nike Air Max 90 stays true to its OG running roots with the iconic waffle outsole and Max Air cushioning.',
      sizes: _defaultSizes,
      colors: ['Infrared'],
      category: 'sneakers',
      gender: 'Unisex',
      rating: 4.7,
      reviewCount: 445,
      specifications: {
        'Style Code': 'DQ3987-100',
        'Colorway': 'White/Infrared',
        'Cushioning': 'Max Air',
      },
    ),
    Product(
      id: 'p009',
      name: 'Puma Suede Classic XXI',
      brand: 'Puma',
      price: 6999,
      discountedPrice: 5249,
      images: [
        'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400&q=80',
        'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400&q=80',
      ],
      description:
          'The Puma Suede has been a street icon since 1968. This 21st-century update keeps the classic suede upper and formstrip with modern comfort upgrades.',
      sizes: _defaultSizes,
      colors: ['Black', 'Navy', 'Burgundy'],
      category: 'sneakers',
      gender: 'Unisex',
      rating: 4.3,
      reviewCount: 98,
      specifications: {
        'Material': 'Premium Suede',
        'Sole': 'Rubber',
        'Closure': 'Lace-up',
      },
    ),
    Product(
      id: 'p010',
      name: 'Converse Chuck 70 High Top',
      brand: 'Converse',
      price: 7495,
      images: [
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400&q=80',
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=400&q=80',
      ],
      description:
          'The Converse Chuck 70 revamps the iconic Chuck Taylor with premium canvas, better cushioning, and a vintage-inspired look for everyday wear.',
      sizes: _defaultSizes,
      colors: ['Black', 'Parchment'],
      category: 'sneakers',
      gender: 'Unisex',
      rating: 4.5,
      reviewCount: 234,
      specifications: {
        'Material': 'Canvas',
        'Cushioning': 'OrthoLite',
        'Style': 'High Top',
      },
    ),
    Product(
      id: 'p011',
      name: 'On Cloud 5',
      brand: 'On Running',
      price: 13990,
      images: [
        'https://images.unsplash.com/photo-1539185441755-769473a23570?w=400&q=80',
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&q=80',
      ],
      description:
          'The On Cloud 5 is the ultimate everyday shoe. CloudTec sole absorbs impact and propels you forward. Speed-lacing for easy on-off.',
      sizes: _defaultSizes,
      colors: ['All Black', 'White/Pearl'],
      category: 'sneakers',
      gender: 'Unisex',
      rating: 4.6,
      reviewCount: 312,
      specifications: {
        'Technology': 'CloudTec',
        'Weight': '245g',
        'Drop': '6mm',
      },
    ),
    Product(
      id: 'p012',
      name: 'Nike Dunk High Retro',
      brand: 'Nike',
      price: 9695,
      images: [
        'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400&q=80',
        'https://images.unsplash.com/photo-1584735175315-9d5df23860e6?w=400&q=80',
      ],
      description:
          'Hoops heritage with street-style swagger. The Nike Dunk High features padded collar, premium leather, and vibrant team-inspired colorways.',
      sizes: ['UK 7', 'UK 8', 'UK 9', 'UK 10', 'UK 11'],
      colors: ['Panda'],
      category: 'sneakers',
      gender: 'Men',
      rating: 4.5,
      reviewCount: 189,
      specifications: {
        'Style Code': 'DD1399-105',
        'Colorway': 'White/Black',
        'Style': 'High Top',
      },
    ),
  ];

  static List<Product> get newArrivals =>
      allProducts.where((p) => p.isAvailable && !p.isPreorder).take(6).toList();

  static List<Product> get trending =>
      allProducts.where((p) => p.rating >= 4.5).take(6).toList();

  static List<Product> get featured =>
      allProducts.where((p) => p.price > 10000).take(4).toList();

  static List<Product> productsByBrand(String brand) => allProducts
      .where((p) => p.brand.toLowerCase() == brand.toLowerCase())
      .toList();

  static List<Product> productsByCategory(String category) => allProducts
      .where((p) => p.category.toLowerCase() == category.toLowerCase())
      .toList();

  static Product? productById(String id) {
    try {
      return allProducts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<String> get trendingSearches => [
    'Jordan 1',
    'Dunk Low',
    'Air Force 1',
    'Yeezy',
    'New Balance 550',
    'Air Max 90',
  ];
}
