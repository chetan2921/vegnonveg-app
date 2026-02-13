# VegNonVeg App Clone 👟

A premium, high-fidelity Flutter clone of the VegNonVeg sneaker store application. This project demonstrates modern Flutter UI development, complex animations, and real-time data integration featuring Firebase Cloud Messaging for push notifications and advanced AI-powered image search capabilities.

![Banner](https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange?style=for-the-badge&logo=firebase)

## ✨ Features

### 🔔 Push Notifications (Firebase Cloud Messaging)
Complete notification system with user-customizable preferences:
- **Restock Alerts**: Get notified when wishlisted items are back in stock
- **Price Drop Notifications**: Track price changes on favorite products
- **New Drops**: Alerts for new sneaker releases from subscribed brands
- **Order Updates**: Real-time order status tracking
- **Flash Sales**: Exclusive time-sensitive deals
- **Personalized Recommendations**: AI-curated product suggestions
- **Topic Subscriptions**: Subscribe to specific brands and categories
- **FCM Token Management**: Automatic token refresh and storage

### 📸 AI-Powered Image Search
Visual search functionality for finding products by image:
- **Camera Integration**: Capture photos directly in-app
- **Gallery Upload**: Search using existing photos
- **Permission Handling**: Smart runtime permission requests (iOS & Android)
- **Image Preview**: Review images before searching
- **Similar Products**: Find visually similar sneakers
- **Product Grid Results**: Beautiful grid layout with product cards
- Full-screen dedicated image search interface

### 🛍️ Enhanced Shopping Experience
- **Smart Add to Cart**: Dynamic "Go to Bag" button after adding items
- **Product Sharing**: Share sneakers via native share sheet (WhatsApp, Social Media, Email)
- **Size Selection**: Interactive size picker with validation
- **True to Size Slider**: Visual fit indicator for accurate sizing
- **Wishlist Integration**: Save favorites with one tap
- **Related Products**: AI-suggested similar items

### 🎨 Premium UI/UX
- **Custom Animations**: Physics-based "Shop the Look" card-fan animation
- **Smooth Transitions**: Hero animations for product details
- **Brand-Aligned Design**: _Anton_ and _Inter_ typography matching VegNonVeg aesthetics
- **Consistent Branding**: App logo in navigation bars across all screens
- **Responsive Forms**: Optimized checkout forms with proper keyboard handling
- **Loading States**: Shimmer effects and skeleton screens

### 🔍 Product Discovery
- **Home Screen**: Curated sections for Sneaker Launches, Apparel, and Trending items
- **Advanced Search**: Real-time text search with brand aggregation
- **Visual Search**: Search by image button integration
- **Shop Screen**: Filterable grid view with lazy loading
- **Dynamic Filters**: Sort by price, brand, size, and category

### 💰 Complete E-Commerce Flow
- **Product Details**: Comprehensive product information with multiple images
- **Cart Management**: Provider-based state with quantity controls
- **Wishlist**: Persistent favorites across sessions
- **Checkout Flow**: Multi-step checkout with address and payment selection
- **Order Summary**: Detailed cost breakdown before purchase

## 🛠️ Tech Stack

### Core Framework
- **Flutter**: 3.x (Cross-platform mobile development)
- **Dart**: ^3.10.8

### State Management & Architecture
- **Provider**: State management for cart, wishlist, auth, and products
- **Service Layer**: Singleton services for notifications, image search, and storage

### Backend & Cloud Services
- **Firebase Core**: ^2.24.2 (Firebase initialization)
- **Firebase Cloud Messaging**: ^14.7.10 (Push notifications)
- **Google APIs**: Integration for backend services

### Networking & Data
- **Dio**: ^5.4.0 (HTTP client)
- **Connectivity Plus**: ^5.0.2 (Network status monitoring)
- **Shared Preferences**: ^2.2.2 (Local storage)
- **SQLite**: ^2.3.0 (Local database)

### UI & Media
- **Google Fonts**: ^6.1.0 (Anton & Inter typography)
- **Cached Network Image**: ^3.3.1 (Optimized image loading)
- **Image Picker**: ^1.0.7 (Camera & gallery access)
- **Photo View**: ^0.15.0 (Image zoom and pan)
- **Shimmer**: ^3.0.0 (Loading animations)
- **Carousel Slider**: ^5.0.0 (Image carousels)
- **Animate Do**: ^3.1.2 (Entrance animations)

### Navigation & Sharing
- **Go Router**: ^14.0.0 (Declarative routing)
- **Share Plus**: ^7.2.2 (Native share functionality)
- **URL Launcher**: ^6.2.4 (External links)

### Permissions & Platform Integration
- **Permission Handler**: ^11.2.0 (Runtime permissions for camera, storage, notifications)

### Development & Build
- **Android SDK**: 36 (compileSdk & targetSdk)
- **Min SDK**: 21 (Android 5.0+)
- **iOS**: 12.0+
- **Core Library Desugaring**: Enabled for modern Java API support
- **MultiDex**: Enabled for large dependency count

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Android Studio / Xcode for mobile emulation

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/chetan2921/vegnonveg-app.git
   cd vegnonveg
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Firebase** (Required for push notifications)

   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase (auto-generates platform config files)
   flutterfire configure
   
   # Select your Firebase project and platforms (iOS/Android)
   # This creates google-services.json and GoogleService-Info.plist
   ```

4. **Platform-Specific Setup**

   **Android**:
   - Ensure `google-services.json` is in `android/app/`
   - Min SDK 21 or higher required
   - Build Tools 34.0.0 recommended

   **iOS**:
   - Ensure `GoogleService-Info.plist` is in `ios/Runner/`
   - Run `pod install` in the `ios/` directory
   - iOS 12.0+ deployment target

5. **Run the app**
   ```bash
   flutter run
   ```

6. **Build for Production**
   ```bash
   # Android
   flutter build apk --release
   flutter build appbundle --release
   
   # iOS
   flutter build ios --release
   ```

> 📖 **For detailed setup of new features (Push Notifications & Image Search), see [NEW_FEATURES_SETUP.md](NEW_FEATURES_SETUP.md)**

## 📱 Screenshots

| Home & Shop the Look |   Product Detail    |    Search & Shop    |
| :------------------: | :-----------------: | :-----------------: |
| _(Add screenshots)_  | _(Add screenshots)_ | _(Add screenshots)_ |

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/          # App colors, assets, strings
│   ├── services/          # Business logic services
│   │   ├── notification_service.dart    # FCM & push notifications
│   │   ├── image_search_service.dart    # Image picker & search
│   │   └── storage_service.dart         # Local storage management
│   ├── theme/             # App theme & typography
│   └── utils/             # Helpers, formatters, validators
├── data/
│   ├── models/            # Product, Cart, Wishlist, User models
│   ├── providers/         # State management (Provider)
│   └── services/          # API & data services
├── presentation/
│   ├── screens/           # All app screens
│   │   ├── home/          # Home screen with featured products
│   │   ├── shop/          # Product grid with filters
│   │   ├── search/        # Text & image search
│   │   │   ├── search_screen.dart
│   │   │   └── image_search_screen.dart
│   │   ├── product_detail/ # Product details & sizing
│   │   ├── cart/          # Shopping cart
│   │   ├── checkout/      # Checkout flow
│   │   ├── wishlist/      # Saved products
│   │   ├── profile/       # User profile
│   │   ├── orders/        # Order history
│   │   └── settings/      # App settings
│   │       └── notification_settings_screen.dart
│   └── widgets/           # Reusable UI components
│       ├── common/        # Buttons, cards, empty states
│       └── product_cards/ # Product display components
├── routes/                # Navigation configuration
│   └── app_routes.dart    # Go Router setup
└── main.dart              # App entry point & Firebase init
```

## 🔧 Configuration

### Android Setup
- **Permissions**: Internet, Camera, Storage (READ/WRITE), Notifications
- **Min SDK**: 21 (Android 5.0 Lollipop)
- **Target SDK**: 36 (Android 14+)
- **Compile SDK**: 36
- **Core Library Desugaring**: Enabled for Java 8+ API compatibility
- **MultiDex**: Enabled for apps with >64K methods
- **Network Security**: `usesCleartextTraffic` configured for image CDNs

### iOS Setup
- **Deployment Target**: iOS 12.0+
- **Permissions** (Info.plist):
  - `NSCameraUsageDescription`: "To search products by taking photos"
  - `NSPhotoLibraryUsageDescription`: "To search products using your photos"
- **App Transport Security**: Configured for arbitrary loads

### Firebase Configuration
1. Add `google-services.json` to `android/app/`
2. Add `GoogleService-Info.plist` to `ios/Runner/`
3. Configure Firebase project with Cloud Messaging enabled
4. Update package name/bundle ID to match Firebase console

### Environment Variables
- Firebase configuration files (not committed to version control)
- API keys stored in `.env` (if using external APIs)

## 🎯 Key Features Breakdown

### Notification System Architecture
```dart
NotificationService
├── FCM Token Management
├── Topic Subscriptions (brands, categories)
├── Permission Handling
├── Notification Routing
└── User Preferences Integration
```

**Notification Types:**
- `restock` - Product back in stock alerts
- `price_drop` - Price reduction notifications
- `new_drop` - New product launches
- `flash_sale` - Time-sensitive deals
- `order_update` - Order status changes
- `recommendation` - Personalized suggestions

### Image Search Flow
```
User Action → Image Picker → Image Preview → Search → Results
     ↓              ↓             ↓            ↓         ↓
  Camera/       Permission    Display      Backend   Product
  Gallery       Request       Selected      ML API     Grid
```

### Shopping Cart Features
- **Dynamic Button States**: "Add to Bag" → "Go to Bag"
- **Quantity Management**: Increment/decrement controls
- **Size Tracking**: Each cart item stores selected size
- **Price Calculations**: Subtotal, tax, shipping
- **Persistence**: Cart saved to local storage

### Product Detail Enhancements
- **Multi-Image Carousel**: Swipeable product images with indicators
- **Size Selection**: Visual size picker with availability
- **Fit Indicator**: "True to Size" slider visualization
- **Share Functionality**: Native platform share sheet
- **Related Products**: AI-suggested similar items
- **Wishlist Toggle**: Add/remove from favorites

## � Recent Updates & Improvements

### Version 2.0.0 (Latest)
**New Features:**
- ✅ Firebase Cloud Messaging integration for push notifications
- ✅ AI-powered image search with camera and gallery support
- ✅ Notification settings screen with customizable preferences
- ✅ Product sharing via native share sheet
- ✅ Dynamic "Go to Bag" button after adding items to cart
- ✅ App logo branding across all navigation bars

**UI/UX Improvements:**
- ✅ Fixed checkout form text field label clipping issue
- ✅ Improved keyboard handling with `resizeToAvoidBottomInset`
- ✅ Added proper spacing in forms to prevent label overlap
- ✅ Consistent branding with VegNonVeg logo in AppBars
- ✅ Enhanced loading states and error handling

**Technical Improvements:**
- ✅ Upgraded Android SDK to version 36
- ✅ Implemented core library desugaring for Java 8+ APIs
- ✅ Added MultiDex support for large dependency count
- ✅ Optimized permission handling for camera, storage, and notifications
- ✅ Service-based architecture for notifications and image search
- ✅ Local storage integration for FCM tokens and user preferences

### Version 1.0.0
- Initial release with core e-commerce functionality
- Product catalog with search and filters
- Cart and wishlist management
- Checkout flow with address and payment selection

## 🐛 Troubleshooting

### Firebase Issues
**Problem**: Build fails with Firebase configuration errors  
**Solution**: Ensure `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are properly placed and run `flutterfire configure` again.

**Problem**: Push notifications not working  
**Solution**: 
- Verify Firebase Cloud Messaging is enabled in Firebase Console
- Check notification permissions are granted on device
- Test on physical device (notifications may not work fully in emulators)
- Verify FCM server key is configured correctly

### Image Search Issues
**Problem**: Camera/Gallery not opening  
**Solution**: 
- Check permissions are granted in device settings
- Verify `Info.plist` (iOS) has camera and photo library usage descriptions
- Android: Ensure `AndroidManifest.xml` has camera and storage permissions

**Problem**: Images not uploading  
**Solution**: Check internet connectivity and ensure image file size is reasonable (<10MB recommended)

### Build Issues
**Problem**: Android build fails with "SDK version" error  
**Solution**: Update `compileSdk` and `targetSdk` to 36 in `android/app/build.gradle.kts`

**Problem**: Duplicate class errors  
**Solution**: Enable MultiDex in `build.gradle.kts`:
```kotlin
android {
    defaultConfig {
        multiDexEnabled = true
    }
}
```

## ⚡ Performance Optimizations

- **Image Caching**: `cached_network_image` reduces network calls
- **Lazy Loading**: Products load on-demand as user scrolls
- **State Management**: Provider ensures minimal rebuilds
- **Local Storage**: Cart and preferences persist offline
- **Optimized Assets**: Image compression for faster loading
- **Code Splitting**: Route-based lazy loading with GoRouter

## 🚧 Known Limitations & Future Enhancements

### Current Limitations
- Image search currently shows all products (ML backend integration needed)
- Payment gateway not integrated (UI only)
- Order management is local (backend integration pending)

### Planned Features
- [ ] Real-time product availability tracking
- [ ] User reviews and ratings system
- [ ] Size recommendation based on user history
- [ ] AR try-on for sneakers
- [ ] Social login (Google, Apple, Facebook)
- [ ] Backend ML integration for actual image similarity matching
- [ ] Payment gateway integration (Razorpay/Stripe)
- [ ] Order tracking with real-time updates
- [ ] In-app chat support
- [ ] Loyalty rewards program

## �🔧 Configuration

## 🤝 Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **VegNonVeg**: Original brand and design inspiration
- **Flutter Team**: Exceptional framework and documentation
- **Firebase**: Cloud messaging and backend services
- **Community**: Open-source packages that made this possible

## 👨‍💻 Author

**Chetan Jain**  
- GitHub: [@chetan2921](https://github.com/chetan2921)

## 📞 Support

For support, email your queries or open an issue in the GitHub repository.

---

**⭐ If you find this project helpful, please give it a star!**

Built with ❤️ using Flutter
