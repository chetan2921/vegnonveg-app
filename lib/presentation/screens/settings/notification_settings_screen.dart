import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final NotificationService _notificationService = NotificationService();

  Map<String, bool> _preferences = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await _notificationService.getNotificationPreferences();
    setState(() {
      _preferences = prefs;
      _isLoading = false;
    });
  }

  Future<void> _updatePreference(String type, bool value) async {
    setState(() {
      _preferences[type] = value;
    });
    await _notificationService.updateNotificationPreference(type, value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const SizedBox(height: 8),
                _buildSectionHeader('Shopping Updates'),
                _buildSettingTile(
                  'Restock Alerts',
                  'Get notified when wishlisted items are back in stock',
                  'restock_alerts',
                  Icons.inventory_2_outlined,
                ),
                _buildSettingTile(
                  'Price Drop Alerts',
                  'Get notified about price drops on wishlisted items',
                  'price_drops',
                  Icons.trending_down,
                ),
                _buildSettingTile(
                  'New Sneaker Drops',
                  'Stay updated on new releases from your favorite brands',
                  'new_drops',
                  Icons.new_releases_outlined,
                ),
                _buildSettingTile(
                  'Flash Sales',
                  'Don\'t miss limited-time offers and flash sales',
                  'flash_sales',
                  Icons.flash_on_outlined,
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('Order Updates'),
                _buildSettingTile(
                  'Order Status',
                  'Track your orders with real-time updates',
                  'order_updates',
                  Icons.local_shipping_outlined,
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('Personalization'),
                _buildSettingTile(
                  'Recommendations',
                  'Get personalized product recommendations',
                  'recommendations',
                  Icons.stars_outlined,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'You can change these settings anytime. We\'ll send you important account and order updates regardless of your preferences.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.grey600,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: AppColors.grey600,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    String title,
    String subtitle,
    String key,
    IconData icon,
  ) {
    final isEnabled = _preferences[key] ?? true;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isEnabled
                ? AppColors.primaryBlack.withOpacity(0.1)
                : AppColors.grey100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 24,
            color: isEnabled ? AppColors.primaryBlack : AppColors.grey400,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.grey600,
              height: 1.4,
            ),
          ),
        ),
        trailing: Switch(
          value: isEnabled,
          onChanged: (value) => _updatePreference(key, value),
          activeColor: AppColors.primaryBlack,
        ),
      ),
    );
  }
}
