class AppAssets {
  AppAssets._();

  // Base paths
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';

  // Logo
  static const String logo = '$_imagesPath/logo.png';
  static const String logoDark = '$_imagesPath/logo_dark.png';
  static const String logoWhite = '$_imagesPath/logo_white.png';

  // Placeholder
  static const String placeholder = '$_imagesPath/placeholder.png';
  static const String productPlaceholder =
      '$_imagesPath/product_placeholder.png';

  // Onboarding
  static const String onboarding1 = '$_imagesPath/onboarding_1.png';
  static const String onboarding2 = '$_imagesPath/onboarding_2.png';
  static const String onboarding3 = '$_imagesPath/onboarding_3.png';

  // Brand Logos
  static const String nikeLogo = '$_iconsPath/nike.svg';
  static const String jordanLogo = '$_iconsPath/jordan.svg';
  static const String adidasLogo = '$_iconsPath/adidas.svg';
  static const String newBalanceLogo = '$_iconsPath/new_balance.svg';
  static const String pumaLogo = '$_iconsPath/puma.svg';

  // Empty States
  static const String emptyCart = '$_imagesPath/empty_cart.png';
  static const String emptyWishlist = '$_imagesPath/empty_wishlist.png';
  static const String emptyOrders = '$_imagesPath/empty_orders.png';
  static const String noResults = '$_imagesPath/no_results.png';

  // Network placeholder URLs (for demo data)
  static const String networkPlaceholder =
      'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400';

  static List<String> get demoProductImages => [
    'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
    'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=400',
    'https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400',
    'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=400',
    'https://images.unsplash.com/photo-1584735175315-9d5df23860e6?w=400',
    'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400',
  ];
}
