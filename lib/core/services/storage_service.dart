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

  // Clear all
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
