class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.vegnonveg.com/api/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';

  // Products
  static const String products = '/products';
  static String productById(String id) => '/products/$id';
  static const String featuredProducts = '/products/featured';
  static const String newArrivals = '/products/new-arrivals';
  static const String trending = '/products/trending';
  static const String searchProducts = '/products/search';

  // Categories
  static const String categories = '/categories';
  static String categoryProducts(String id) => '/categories/$id/products';

  // Brands
  static const String brands = '/brands';
  static String brandProducts(String id) => '/brands/$id/products';

  // Cart
  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String removeFromCart = '/cart/remove';
  static const String updateCart = '/cart/update';

  // Wishlist
  static const String wishlistEndpoint = '/wishlist';
  static const String addToWishlist = '/wishlist/add';
  static const String removeFromWishlist = '/wishlist/remove';

  // Orders
  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';
  static const String createOrder = '/orders/create';

  // User
  static const String userProfile = '/user/profile';
  static const String updateProfile = '/user/profile/update';
  static const String addresses = '/user/addresses';
  static const String addAddress = '/user/addresses/add';

  // Coupons
  static const String validateCoupon = '/coupons/validate';
}
