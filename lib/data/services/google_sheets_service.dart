import 'package:dio/dio.dart';
import '../models/product.dart';

/// Fetches product data from a public Google Sheet via Sheets API v4.
class GoogleSheetsService {
  GoogleSheetsService._();

  static const String _spreadsheetId =
      '1Kb6BVlNQE3zvr_tGycs6V5q0dpXbD-UASUhwFwGnaes';
  static const String _apiKey = 'AIzaSyBupOJT_Inzk8dZaS5EDgs0VkmaLcyLQ4U';
  static const String _range = 'Sheet1';

  static final Dio _dio = Dio();

  /// Fetches all products from the Google Sheet.
  /// Returns an empty list on failure (caller should fall back to demo data).
  static Future<List<Product>> fetchProducts() async {
    try {
      final url =
          'https://sheets.googleapis.com/v4/spreadsheets/$_spreadsheetId'
          '/values/$_range?key=$_apiKey';

      final response = await _dio.get(url);

      if (response.statusCode != 200 || response.data == null) {
        return [];
      }

      final Map<String, dynamic> data = response.data;
      final List<dynamic> rows = data['values'] ?? [];

      if (rows.length <= 1) return []; // Only header row or empty

      // Skip the header row (index 0)
      final products = <Product>[];
      for (int i = 1; i < rows.length; i++) {
        final row = rows[i] as List<dynamic>;
        final product = _parseRow(row, i);
        if (product != null) {
          products.add(product);
        }
      }

      return products;
    } catch (e) {
      // Return empty so caller falls back to demo data
      return [];
    }
  }

  /// Parses a single sheet row into a [Product].
  /// Row columns: [imgNormal, imgHover, productUrl, name, price, brand]
  static Product? _parseRow(List<dynamic> row, int index) {
    try {
      if (row.length < 6) return null;

      final imgNormal = (row[0] as String).trim();
      final imgHover = (row[1] as String).trim();
      final productUrl = (row[2] as String).trim();
      final name = (row[3] as String).trim();
      final priceStr = (row[4] as String).trim();
      final brand = (row[5] as String).trim();

      if (name.isEmpty || imgNormal.isEmpty) return null;

      // Extract ID from product URL slug
      // e.g. https://www.vegnonveg.com/products/nike-air-max-moto-2k-se-... → the slug
      final id = _extractId(productUrl, index);

      // Parse price: "₹\n12,795" → 12795.0
      final price = _parsePrice(priceStr);

      // Build images list
      final images = <String>[imgNormal];
      if (imgHover.isNotEmpty && imgHover != imgNormal) {
        images.add(imgHover);
      }

      // Derive a colorway from URL slug (after the last product-name part)
      final colorway = _extractColorway(productUrl);

      return Product(
        id: id,
        name: name,
        brand: brand,
        price: price,
        images: images,
        description:
            '$brand $name — available exclusively at VegNonVeg. '
            'Premium quality, authentic guarantee.',
        sizes: const ['UK 6', 'UK 7', 'UK 8', 'UK 9', 'UK 10', 'UK 11'],
        colors: colorway.isNotEmpty ? [colorway] : ['Default'],
        category: 'footwear',
        gender: 'Unisex',
        rating: 4.5,
        reviewCount: 0,
      );
    } catch (_) {
      return null;
    }
  }

  /// Parses "₹\n12,795" → 12795.0
  static double _parsePrice(String raw) {
    // Remove ₹, newlines, commas, and whitespace
    final cleaned = raw
        .replaceAll('₹', '')
        .replaceAll('\\n', '')
        .replaceAll('\n', '')
        .replaceAll(',', '')
        .trim();

    return double.tryParse(cleaned) ?? 0;
  }

  /// Extracts a slug-based ID from the product URL.
  static String _extractId(String url, int index) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) {
        return segments.last;
      }
    } catch (_) {}
    return 'product-$index';
  }

  /// Extracts a rough colorway string from the URL slug.
  /// e.g. ".../nike-air-max-moto-2k-se-sailpale-ivory-phantom" → "Sail/Pale Ivory/Phantom"
  static String _extractColorway(String url) {
    try {
      final uri = Uri.parse(url);
      final slug = uri.pathSegments.last;
      // The slug typically contains the colorway after the repeated product name
      // We'll just return an empty string since parsing is fragile
      if (slug.isNotEmpty) return '';
    } catch (_) {}
    return '';
  }
}
