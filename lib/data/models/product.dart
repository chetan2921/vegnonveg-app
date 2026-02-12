class Product {
  final String id;
  final String name;
  final String brand;
  final double price;
  final double? discountedPrice;
  final List<String> images;
  final String description;
  final List<String> sizes;
  final List<String> colors;
  final String category;
  final String gender;
  final bool isAvailable;
  final bool isPreorder;
  final String? videoUrl;
  final Map<String, dynamic>? specifications;
  final double rating;
  final int reviewCount;
  final DateTime? releaseDate;
  final String? sku;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    this.discountedPrice,
    required this.images,
    required this.description,
    required this.sizes,
    required this.colors,
    required this.category,
    required this.gender,
    this.isAvailable = true,
    this.isPreorder = false,
    this.videoUrl,
    this.specifications,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.releaseDate,
    this.sku,
  });

  bool get hasDiscount => discountedPrice != null && discountedPrice! < price;

  double get effectivePrice => discountedPrice ?? price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return ((price - discountedPrice!) / price * 100).round();
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      price: (json['price'] as num).toDouble(),
      discountedPrice: (json['discounted_price'] as num?)?.toDouble(),
      images: List<String>.from(json['images'] as List),
      description: json['description'] as String,
      sizes: List<String>.from(json['sizes'] as List),
      colors: List<String>.from(json['colors'] as List),
      category: json['category'] as String,
      gender: json['gender'] as String,
      isAvailable: json['is_available'] as bool? ?? true,
      isPreorder: json['is_preorder'] as bool? ?? false,
      videoUrl: json['video_url'] as String?,
      specifications: json['specifications'] as Map<String, dynamic>?,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['review_count'] as int? ?? 0,
      releaseDate: json['release_date'] != null
          ? DateTime.parse(json['release_date'] as String)
          : null,
      sku: json['sku'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'discounted_price': discountedPrice,
      'images': images,
      'description': description,
      'sizes': sizes,
      'colors': colors,
      'category': category,
      'gender': gender,
      'is_available': isAvailable,
      'is_preorder': isPreorder,
      'video_url': videoUrl,
      'specifications': specifications,
      'rating': rating,
      'review_count': reviewCount,
      'release_date': releaseDate?.toIso8601String(),
      'sku': sku,
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? brand,
    double? price,
    double? discountedPrice,
    List<String>? images,
    String? description,
    List<String>? sizes,
    List<String>? colors,
    String? category,
    String? gender,
    bool? isAvailable,
    bool? isPreorder,
    String? videoUrl,
    Map<String, dynamic>? specifications,
    double? rating,
    int? reviewCount,
    DateTime? releaseDate,
    String? sku,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      discountedPrice: discountedPrice ?? this.discountedPrice,
      images: images ?? this.images,
      description: description ?? this.description,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      isAvailable: isAvailable ?? this.isAvailable,
      isPreorder: isPreorder ?? this.isPreorder,
      videoUrl: videoUrl ?? this.videoUrl,
      specifications: specifications ?? this.specifications,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      releaseDate: releaseDate ?? this.releaseDate,
      sku: sku ?? this.sku,
    );
  }
}
