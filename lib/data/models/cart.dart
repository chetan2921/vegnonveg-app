import 'product.dart';

class CartItem {
  final Product product;
  final String selectedSize;
  final String? selectedColor;
  int quantity;

  CartItem({
    required this.product,
    required this.selectedSize,
    this.selectedColor,
    this.quantity = 1,
  });

  double get totalPrice => product.effectivePrice * quantity;

  String get uniqueKey => '${product.id}_$selectedSize';

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      selectedSize: json['selected_size'] as String,
      selectedColor: json['selected_color'] as String?,
      quantity: json['quantity'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'selected_size': selectedSize,
      'selected_color': selectedColor,
      'quantity': quantity,
    };
  }
}

class Cart {
  final List<CartItem> items;
  final String? couponCode;
  final double? couponDiscount;

  Cart({this.items = const [], this.couponCode, this.couponDiscount});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  double get shipping => subtotal >= 5000 ? 0 : 99;

  double get discount => couponDiscount ?? 0;

  double get tax => (subtotal - discount) * 0.18;

  double get total => subtotal - discount + shipping + tax;

  bool get isEmpty => items.isEmpty;

  bool get hasFreeShipping => subtotal >= 5000;
}
