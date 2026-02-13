import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'storage_service.dart';

/// Background message handler - must be top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message: ${message.messageId}');
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize notification service
  Future<void> init() async {
    try {
      // Request permissions
      await _requestPermissions();

      // Get FCM token
      _fcmToken = await _messaging.getToken();
      debugPrint('FCM Token: $_fcmToken');

      // Save token to storage for backend sync
      if (_fcmToken != null) {
        await StorageService().saveFCMToken(_fcmToken!);
      }

      // Listen to token refresh
      _messaging.onTokenRefresh.listen((newToken) {
        _fcmToken = newToken;
        StorageService().saveFCMToken(newToken);
        debugPrint('FCM Token refreshed: $newToken');
      });

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle background message clicks
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageClick);

      // Check if app was opened from a notification (terminated state)
      RemoteMessage? initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageClick(initialMessage);
      }
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('Notification permission: ${settings.authorizationStatus}');
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground message: ${message.messageId}');
    debugPrint('Title: ${message.notification?.title}');
    debugPrint('Body: ${message.notification?.body}');
    // Firebase Messaging handles displaying the notification automatically on iOS
    // For Android, you may want to show a local notification or update UI
  }

  /// Handle notification click
  void _handleMessageClick(RemoteMessage message) {
    debugPrint('Message clicked: ${message.messageId}');
    final data = message.data;

    // Route based on notification type
    final notificationType = data['type'] as String?;

    switch (notificationType) {
      case 'restock':
        _handleRestockNotification(data);
        break;
      case 'price_drop':
        _handlePriceDropNotification(data);
        break;
      case 'new_drop':
        _handleNewDropNotification(data);
        break;
      case 'order_update':
        _handleOrderUpdateNotification(data);
        break;
      case 'flash_sale':
        _handleFlashSaleNotification(data);
        break;
      case 'recommendation':
        _handleRecommendationNotification(data);
        break;
      default:
        debugPrint('Unknown notification type: $notificationType');
    }
  }

  // ==================== Notification Type Handlers ====================

  void _handleRestockNotification(Map<String, dynamic> data) {
    final productId = data['product_id'] as String?;
    if (productId != null) {
      // Navigate to product detail
      debugPrint('Navigate to restocked product: $productId');
      // TODO: Implement navigation using GoRouter
    }
  }

  void _handlePriceDropNotification(Map<String, dynamic> data) {
    final productId = data['product_id'] as String?;
    final oldPrice = data['old_price'] as String?;
    final newPrice = data['new_price'] as String?;
    if (productId != null) {
      debugPrint('Price drop for $productId: $oldPrice → $newPrice');
      // Navigate to product detail
    }
  }

  void _handleNewDropNotification(Map<String, dynamic> data) {
    final brandId = data['brand_id'] as String?;
    final productId = data['product_id'] as String?;
    if (productId != null) {
      debugPrint('New drop from $brandId: $productId');
      // Navigate to product detail or brand page
    }
  }

  void _handleOrderUpdateNotification(Map<String, dynamic> data) {
    final orderId = data['order_id'] as String?;
    final status = data['status'] as String?;
    if (orderId != null) {
      debugPrint('Order $orderId updated: $status');
      // Navigate to order detail
    }
  }

  void _handleFlashSaleNotification(Map<String, dynamic> data) {
    final saleId = data['sale_id'] as String?;
    debugPrint('Flash sale notification: $saleId');
    // Navigate to shop/sale page
  }

  void _handleRecommendationNotification(Map<String, dynamic> data) {
    final productId = data['product_id'] as String?;
    if (productId != null) {
      debugPrint('Recommended product: $productId');
      // Navigate to product detail
    }
  }

  // ==================== Topic Subscriptions ====================

  /// Subscribe to brand notifications
  Future<void> subscribeToBrand(String brandName) async {
    final topic = brandName.toLowerCase().replaceAll(' ', '_');
    await _messaging.subscribeToTopic('brand_$topic');
    debugPrint('Subscribed to brand: $topic');
  }

  /// Unsubscribe from brand notifications
  Future<void> unsubscribeFromBrand(String brandName) async {
    final topic = brandName.toLowerCase().replaceAll(' ', '_');
    await _messaging.unsubscribeFromTopic('brand_$topic');
    debugPrint('Unsubscribed from brand: $topic');
  }

  /// Subscribe to flash sale notifications
  Future<void> subscribeToFlashSales() async {
    await _messaging.subscribeToTopic('flash_sales');
  }

  /// Unsubscribe from flash sale notifications
  Future<void> unsubscribeFromFlashSales() async {
    await _messaging.unsubscribeFromTopic('flash_sales');
  }

  /// Get notification preferences from storage
  Future<Map<String, bool>> getNotificationPreferences() async {
    return {
      'restock_alerts': StorageService().getNotificationPreference(
        'restock_alerts',
      ),
      'price_drops': StorageService().getNotificationPreference('price_drops'),
      'new_drops': StorageService().getNotificationPreference('new_drops'),
      'order_updates': StorageService().getNotificationPreference(
        'order_updates',
      ),
      'flash_sales': StorageService().getNotificationPreference('flash_sales'),
      'recommendations': StorageService().getNotificationPreference(
        'recommendations',
      ),
    };
  }

  /// Update notification preference
  Future<void> updateNotificationPreference(String type, bool enabled) async {
    await StorageService().setNotificationPreference(type, enabled);

    // Subscribe/unsubscribe from topics based on preference
    if (type == 'flash_sales') {
      if (enabled) {
        await subscribeToFlashSales();
      } else {
        await unsubscribeFromFlashSales();
      }
    }
  }
}
