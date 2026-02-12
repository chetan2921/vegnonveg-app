import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../models/cart.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  String? _couponCode;
  double? _couponDiscount;

  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;

  double get subtotal => _items.fold(0, (sum, item) => sum + item.totalPrice);

  double get shipping => subtotal >= 5000 ? 0 : 99;

  bool get hasFreeShipping => subtotal >= 5000;

  double get discount => _couponDiscount ?? 0;

  double get tax => (subtotal - discount) * 0.18;

  double get total => subtotal - discount + shipping + tax;

  String? get couponCode => _couponCode;

  void addItem(Product product, String size, {String? color}) {
    final key = '${product.id}_$size';
    final existingIndex = _items.indexWhere((item) => item.uniqueKey == key);

    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(
        CartItem(product: product, selectedSize: size, selectedColor: color),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId, String size) {
    final key = '${productId}_$size';
    _items.removeWhere((item) => item.uniqueKey == key);
    notifyListeners();
  }

  void updateQuantity(String productId, String size, int quantity) {
    final key = '${productId}_$size';
    final index = _items.indexWhere((item) => item.uniqueKey == key);

    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void incrementQuantity(String productId, String size) {
    final key = '${productId}_$size';
    final index = _items.indexWhere((item) => item.uniqueKey == key);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String productId, String size) {
    final key = '${productId}_$size';
    final index = _items.indexWhere((item) => item.uniqueKey == key);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  bool isInCart(String productId) {
    return _items.any((item) => item.product.id == productId);
  }

  Future<bool> applyCoupon(String code) async {
    // Demo coupon logic
    await Future.delayed(const Duration(milliseconds: 500));
    if (code.toUpperCase() == 'SNEAKER10') {
      _couponCode = code;
      _couponDiscount = subtotal * 0.1;
      notifyListeners();
      return true;
    } else if (code.toUpperCase() == 'FIRST500') {
      _couponCode = code;
      _couponDiscount = 500;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeCoupon() {
    _couponCode = null;
    _couponDiscount = null;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _couponCode = null;
    _couponDiscount = null;
    notifyListeners();
  }
}
