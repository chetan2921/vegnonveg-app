class Brand {
  final String id;
  final String name;
  final String? logo;
  final String? description;
  final int productCount;
  final bool isFeatured;

  Brand({
    required this.id,
    required this.name,
    this.logo,
    this.description,
    this.productCount = 0,
    this.isFeatured = false,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      description: json['description'] as String?,
      productCount: json['product_count'] as int? ?? 0,
      isFeatured: json['is_featured'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'description': description,
      'product_count': productCount,
      'is_featured': isFeatured,
    };
  }
}
