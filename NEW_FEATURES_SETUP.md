# New Features Setup Guide

## 🔔 Push Notifications

### Features Implemented:
- ✅ Restock alerts for wishlisted items
- ✅ Price drop notifications
- ✅ New sneaker drop alerts from favorite brands
- ✅ Order status updates
- ✅ Flash sale notifications with countdown timers
- ✅ Personalized recommendations based on browsing history

### Firebase Setup:

1. **Create a Firebase Project**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Login to Firebase
   firebase login
   
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your Flutter project
   flutterfire configure
   ```

2. **Enable Firebase Cloud Messaging (FCM)**
   - Go to Firebase Console → Your Project → Build → Cloud Messaging
   - Enable Cloud Messaging API

3. **Android Setup**
   - Download `google-services.json` from Firebase Console
   - Place it in `android/app/` directory
   - The AndroidManifest.xml is already configured with required permissions

4. **iOS Setup**
   - Download `GoogleService-Info.plist` from Firebase Console
   - Place it in `ios/Runner/` directory using Xcode
   - Enable Push Notifications in Xcode:
     - Open `ios/Runner.xcworkspace`
     - Select Runner target → Signing & Capabilities
     - Click + Capability → Push Notifications
     - Click + Capability → Background Modes
     - Check "Remote notifications"

### Testing Notifications:

```dart
// Send a test notification from code
final notificationService = NotificationService();

// Restock alert
await notificationService.sendRestockAlert(
  'Air Jordan 1 Retro High',
  'product_123',
);

// Price drop alert
await notificationService.sendPriceDropAlert(
  'Nike Dunk Low',
  'product_456',
  12999.0, // old price
  9999.0,  // new price
);

// New drop alert
await notificationService.sendNewDropAlert(
  'Nike',
  'Air Max 270 React',
  'product_789',
);
```

### Notification Settings:

Users can manage notification preferences from:
**Profile → Notification Settings**

Available preferences:
- Restock Alerts
- Price Drop Alerts
- New Sneaker Drops
- Flash Sales
- Order Status Updates
- Personalized Recommendations

---

## 📸 Image Search

### Features Implemented:
- ✅ Search products by uploading photos from gallery
- ✅ Search products by capturing photos with camera
- ✅ Permission handling for camera and photo library
- ✅ Image preview and similar product results

### Usage:

Users can access image search from:
**Search Screen → "Search by Image" button**

### How It Works:

1. User taps "Search by Image"
2. Choose between:
   - Take a Photo (Camera)
   - Choose from Gallery
3. Select/capture image
4. App shows similar products

### Current Implementation:

The current implementation is a **demo version** that filters products by category. For production:

1. **Backend ML Integration** (Recommended):
   ```dart
   // In ImageSearchService, add method:
   Future<List<String>> searchSimilarProducts(String imagePath) async {
     final bytes = await File(imagePath).readAsBytes();
     final base64Image = base64Encode(bytes);
     
     // Send to your ML backend
     final response = await dio.post(
       'https://your-api.com/image-search',
       data: {'image': base64Image},
     );
     
     return List<String>.from(response.data['product_ids']);
   }
   ```

2. **Use Google Vision API or similar**:
   - Google Cloud Vision API
   - AWS Rekognition
   - Azure Computer Vision
   - Custom TensorFlow Lite model

### Permissions:

All required permissions are already configured:
- **Android**: Camera, Storage, Media Images permissions
- **iOS**: Camera, Photo Library usage descriptions

---

## 🚀 Running the App

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure Firebase** (Important!)
   ```bash
   flutterfire configure
   ```
   This will:
   - Create Firebase project (if needed)
   - Register iOS and Android apps
   - Generate `lib/firebase_options.dart`
   - Download configuration files

3. **Run the App**
   ```bash
   # Android
   flutter run
   
   # iOS
   flutter run -d ios
   
   # Web (limited notification support)
   flutter run -d chrome
   ```

---

## 📱 Testing on Physical Devices

### Android:
- Push notifications work on emulators with Google Play Services
- Image search requires camera (use physical device)

### iOS:
- Push notifications require physical device (not simulator)
- Image search requires camera (use physical device)

---

## 🎯 Future Enhancements

### Push Notifications:
- [ ] Rich notifications with images
- [ ] Action buttons (View, Dismiss, Add to Cart)
- [ ] Notification grouping
- [ ] Scheduled notifications for drops
- [ ] Geofencing for store-based notifications

### Image Search:
- [ ] ML model integration for accurate similarity matching
- [ ] Visual search filters (color, brand, style)
- [ ] Barcode/QR code scanning
- [ ] Search history
- [ ] Save searched images

---

## 🔧 Troubleshooting

### Notifications not working:

1. **Check Firebase setup**:
   ```bash
   flutterfire configure
   ```

2. **Verify permissions**:
   - Android: Check Settings → Apps → VegNonVeg → Permissions
   - iOS: Settings → VegNonVeg → Notifications

3. **Check FCM token**:
   ```dart
   final token = NotificationService().fcmToken;
   print('FCM Token: $token');
   ```

### Image picker not working:

1. **Check permissions in settings**
2. **Rebuild after permission changes**:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

3. **iOS Simulator limitations**: Use physical device for camera

---

## 📚 API Reference

### NotificationService

```dart
final notificationService = NotificationService();

// Get FCM token
String? token = notificationService.fcmToken;

// Subscribe to brand notifications
await notificationService.subscribeToBrand('Nike');

// Unsubscribe
await notificationService.unsubscribeFromBrand('Nike');

// Subscribe to flash sales
await notificationService.subscribeToFlashSales();

// Update preferences
await notificationService.updateNotificationPreference('restock_alerts', true);

// Get all preferences
Map<String, bool> prefs = await notificationService.getNotificationPreferences();
```

### ImageSearchService

```dart
final imageSearchService = ImageSearchService();

// Pick from gallery
String? imagePath = await imageSearchService.pickFromGallery();

// Capture from camera
String? imagePath = await imageSearchService.captureFromCamera();

// Check permissions
bool hasCameraAccess = await imageSearchService.isCameraPermissionGranted();
bool hasGalleryAccess = await imageSearchService.isGalleryPermissionGranted();
```

---

## 🎉 Ready to Go!

Your app now has:
- ✅ Push notifications for all major events
- ✅ Image search functionality
- ✅ User-controllable notification preferences
- ✅ Proper permission handling

Next steps:
1. Configure Firebase project
2. Set up backend for notifications
3. Integrate ML model for image search
4. Test on physical devices
5. Deploy to App Store and Play Store
