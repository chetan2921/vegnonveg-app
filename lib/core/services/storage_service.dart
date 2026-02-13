import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late SharedPreferences _prefs;

  factory StorageService() => _instance;

  StorageService._internal();

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Auth
  static const String _authTokenKey = 'auth_token';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userDataKey = 'user_data';

  // Onboarding
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';

  // Theme
  static const String _themeModeKey = 'theme_mode';

  // Recent searches
  static const String _recentSearchesKey = 'recent_searches';

  // FCM Token
  static const String _fcmTokenKey = 'fcm_token';

  // Notification preferences
  static const String _notifRestockKey = 'notif_restock_alerts';
  static const String _notifPriceDropKey = 'notif_price_drops';
  static const String _notifNewDropsKey = 'notif_new_drops';
  static const String _notifOrderUpdatesKey = 'notif_order_updates';
  static const String _notifFlashSalesKey = 'notif_flash_sales';
  static const String _notifRecommendationsKey = 'notif_recommendations';

  // Browsing history
  static const String _browsingHistoryKey = 'browsing_history';

  // Auth methods
  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(_authTokenKey, token);
    await _prefs.setBool(_isLoggedInKey, true);
  }

  String? getAuthToken() => _prefs.getString(_authTokenKey);

  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;

  Future<void> saveUserData(String userData) async {
    await _prefs.setString(_userDataKey, userData);
  }

  String? getUserData() => _prefs.getString(_userDataKey);

  Future<void> clearAuth() async {
    await _prefs.remove(_authTokenKey);
    await _prefs.remove(_userDataKey);
    await _prefs.setBool(_isLoggedInKey, false);
  }

  // Onboarding
  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_hasSeenOnboardingKey, true);
  }

  bool get hasSeenOnboarding => _prefs.getBool(_hasSeenOnboardingKey) ?? false;

  // Theme
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(_themeModeKey, mode);
  }

  String get themeMode => _prefs.getString(_themeModeKey) ?? 'system';

  // Recent searches
  Future<void> saveRecentSearches(List<String> searches) async {
    await _prefs.setStringList(_recentSearchesKey, searches);
  }

  List<String> getRecentSearches() =>
      _prefs.getStringList(_recentSearchesKey) ?? [];

  Future<void> addRecentSearch(String query) async {
    final searches = getRecentSearches();
    searches.remove(query);
    searches.insert(0, query);
    if (searches.length > 10) searches.removeLast();
    await saveRecentSearches(searches);
  }

  Future<void> clearRecentSearches() async {
    await _prefs.remove(_recentSearchesKey);
  }

  // FCM Token methods
  Future<void> saveFCMToken(String token) async {
    await _prefs.setString(_fcmTokenKey, token);
  }

  String? getFCMToken() => _prefs.getString(_fcmTokenKey);

  // Notification preferences
  Future<void> setNotificationPreference(String type, bool enabled) async {
    final key = _getNotificationKey(type);
    if (key != null) {
      await _prefs.setBool(key, enabled);
    }
  }

  bool getNotificationPreference(String type) {
    final key = _getNotificationKey(type);
    if (key != null) {
      return _prefs.getBool(key) ?? true; // Default: enabled
    }
    return true;
  }

  String? _getNotificationKey(String type) {
    switch (type) {
      case 'restock_alerts':
        return _notifRestockKey;
      case 'price_drops':
        return _notifPriceDropKey;
      case 'new_drops':
        return _notifNewDropsKey;
      case 'order_updates':
        return _notifOrderUpdatesKey;
      case 'flash_sales':
        return _notifFlashSalesKey;
      case 'recommendations':
        return _notifRecommendationsKey;
      default:
        return null;
    }
  }

  // Browsing history for recommendations
  Future<void> addToBrowsingHistory(String productId) async {
    final history = getBrowsingHistory();
    history.remove(productId); // Remove if exists
    history.insert(0, productId); // Add to beginning
    if (history.length > 50) history.removeLast(); // Keep max 50
    await _prefs.setStringList(_browsingHistoryKey, history);
  }

  List<String> getBrowsingHistory() {
    return _prefs.getStringList(_browsingHistoryKey) ?? [];
  }

  Future<void> clearBrowsingHistory() async {
    await _prefs.remove(_browsingHistoryKey);
  }

  // Clear all
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
