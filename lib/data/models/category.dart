class Category {
  final String id;
  final String name;
  final String? image;
  final String? description;
  final int productCount;

  Category({
    required this.id,
    required this.name,
    this.image,
    this.description,
    this.productCount = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
      description: json['description'] as String?,
      productCount: json['product_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'product_count': productCount,
    };
  }
}
