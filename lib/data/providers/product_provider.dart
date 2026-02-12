import 'package:flutter/material.dart';
import '../models/product.dart';
import '../demo_data.dart';
import '../services/google_sheets_service.dart';

enum ProductSortOption { popularity, newIn, priceLowToHigh, priceHighToLow }

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  Product? _selectedProduct;
  bool _isLoading = false;
  String? _error;

  // Filter state
  Set<String> _selectedBrands = {};
  Set<String> _selectedCategories = {};
  Set<String> _selectedGenders = {};
  RangeValues _priceRange = const RangeValues(0, 50000);
  ProductSortOption _sortOption = ProductSortOption.popularity;
  String _searchQuery = '';

  // Getters
  List<Product> get products =>
      _filteredProducts.isEmpty &&
          _searchQuery.isEmpty &&
          _selectedBrands.isEmpty &&
          _selectedCategories.isEmpty &&
          _selectedGenders.isEmpty
      ? _products
      : _filteredProducts;
  Product? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Set<String> get selectedBrands => _selectedBrands;
  Set<String> get selectedCategories => _selectedCategories;
  Set<String> get selectedGenders => _selectedGenders;
  RangeValues get priceRange => _priceRange;
  ProductSortOption get sortOption => _sortOption;
  String get searchQuery => _searchQuery;
  bool get hasActiveFilters =>
      _selectedBrands.isNotEmpty ||
      _selectedCategories.isNotEmpty ||
      _selectedGenders.isNotEmpty ||
      _priceRange.start > 0 ||
      _priceRange.end < 50000;

  int get activeFilterCount {
    int count = 0;
    count += _selectedBrands.length;
    count += _selectedCategories.length;
    count += _selectedGenders.length;
    if (_priceRange.start > 0 || _priceRange.end < 50000) count++;
    return count;
  }

  // Derived lists from loaded products
  List<Product> get newArrivals =>
      _products.where((p) => p.isAvailable && !p.isPreorder).take(6).toList();

  List<Product> get trending =>
      _products.where((p) => p.rating >= 4.5).take(6).toList();

  List<Product> get featured =>
      _products.where((p) => p.price > 10000).take(4).toList();

  Future<void> fetchProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Try fetching from Google Sheets first
      final sheetProducts = await GoogleSheetsService.fetchProducts();

      if (sheetProducts.isNotEmpty) {
        _products = sheetProducts;
      } else {
        // Fallback to demo data
        _products = DemoData.allProducts;
      }

      _applyFilters();
    } catch (e) {
      _error = e.toString();
      // Fallback to demo data on error
      _products = DemoData.allProducts;
      _applyFilters();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectProduct(Product product) {
    _selectedProduct = product;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void toggleBrand(String brand) {
    if (_selectedBrands.contains(brand)) {
      _selectedBrands.remove(brand);
    } else {
      _selectedBrands.add(brand);
    }
    _applyFilters();
    notifyListeners();
  }

  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    _applyFilters();
    notifyListeners();
  }

  void toggleGender(String gender) {
    if (_selectedGenders.contains(gender)) {
      _selectedGenders.remove(gender);
    } else {
      _selectedGenders.add(gender);
    }
    _applyFilters();
    notifyListeners();
  }

  void setPriceRange(RangeValues range) {
    _priceRange = range;
    _applyFilters();
    notifyListeners();
  }

  void setSortOption(ProductSortOption option) {
    _sortOption = option;
    _applyFilters();
    notifyListeners();
  }

  void clearFilters() {
    _selectedBrands = {};
    _selectedCategories = {};
    _selectedGenders = {};
    _priceRange = const RangeValues(0, 50000);
    _sortOption = ProductSortOption.popularity;
    _searchQuery = '';
    _filteredProducts = [];
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = List.from(_products);

    // Search
    if (_searchQuery.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.brand.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                p.category.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    // Brand filter
    if (_selectedBrands.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where((p) => _selectedBrands.contains(p.brand))
          .toList();
    }

    // Category filter
    if (_selectedCategories.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where((p) => _selectedCategories.contains(p.category))
          .toList();
    }

    // Gender filter
    if (_selectedGenders.isNotEmpty) {
      _filteredProducts = _filteredProducts
          .where((p) => _selectedGenders.contains(p.gender))
          .toList();
    }

    // Price range
    _filteredProducts = _filteredProducts
        .where(
          (p) =>
              p.effectivePrice >= _priceRange.start &&
              p.effectivePrice <= _priceRange.end,
        )
        .toList();

    // Sort
    switch (_sortOption) {
      case ProductSortOption.popularity:
        _filteredProducts.sort(
          (a, b) => b.reviewCount.compareTo(a.reviewCount),
        );
        break;
      case ProductSortOption.newIn:
        // Sort by ID as proxy for newest
        _filteredProducts.sort((a, b) => b.id.compareTo(a.id));
        break;
      case ProductSortOption.priceLowToHigh:
        _filteredProducts.sort(
          (a, b) => a.effectivePrice.compareTo(b.effectivePrice),
        );
        break;
      case ProductSortOption.priceHighToLow:
        _filteredProducts.sort(
          (a, b) => b.effectivePrice.compareTo(a.effectivePrice),
        );
        break;
    }
  }

  List<Product> getRelatedProducts(Product product) {
    return _products
        .where(
          (p) =>
              p.id != product.id &&
              (p.brand == product.brand || p.category == product.category),
        )
        .take(6)
        .toList();
  }
}
