import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/auth_provider.dart';
import '../../../data/providers/wishlist_provider.dart';
import '../../../data/providers/cart_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/vnv-white-bg-logo.png', height: 55),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile header
                Container(
                  padding: const EdgeInsets.all(24),
                  color: AppColors.primaryBlack,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.grey700,
                        child: Text(
                          auth.isLoggedIn
                              ? auth.userName[0].toUpperCase()
                              : 'G',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryWhite,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              auth.isLoggedIn ? auth.userName : 'Guest User',
                              style: const TextStyle(
                                color: AppColors.primaryWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (auth.isLoggedIn)
                              Text(
                                auth.userEmail,
                                style: const TextStyle(
                                  color: AppColors.grey400,
                                  fontSize: 13,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (!auth.isLoggedIn)
                        OutlinedButton(
                          onPressed: () => context.push('/login'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primaryWhite,
                            side: const BorderSide(color: AppColors.grey600),
                          ),
                          child: const Text(
                            'SIGN IN',
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                ),

                // Stats
                Consumer2<CartProvider, WishlistProvider>(
                  builder: (context, cart, wishlist, _) {
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        children: [
                          _StatItem(label: 'Orders', value: '0'),
                          _StatItem(
                            label: 'Wishlist',
                            value: '${wishlist.itemCount}',
                          ),
                          _StatItem(label: 'Cart', value: '${cart.itemCount}'),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 0),

                // Menu items
                _MenuItem(
                  icon: Icons.shopping_bag_outlined,
                  title: 'My Orders',
                  onTap: () => context.push('/orders'),
                ),
                _MenuItem(
                  icon: Icons.favorite_border,
                  title: 'Wishlist',
                  onTap: () => context.go('/wishlist'),
                ),
                _MenuItem(
                  icon: Icons.shopping_cart_outlined,
                  title: 'Shopping Bag',
                  onTap: () => context.push('/cart'),
                ),
                const Divider(height: 0),
                _MenuItem(
                  icon: Icons.location_on_outlined,
                  title: 'Saved Addresses',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.payment_outlined,
                  title: 'Payment Methods',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notification Settings',
                  onTap: () => context.push('/notification-settings'),
                ),
                const Divider(height: 0),
                _MenuItem(
                  icon: Icons.headset_mic_outlined,
                  title: 'Help Center',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.info_outline,
                  title: 'About VegNonVeg',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.description_outlined,
                  title: 'Terms & Conditions',
                  onTap: () {},
                ),
                _MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () {},
                ),
                const Divider(height: 0),
                if (auth.isLoggedIn)
                  _MenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    textColor: AppColors.accentRed,
                    onTap: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                      if (confirmed == true) {
                        await auth.logout();
                      }
                    },
                  ),
                const SizedBox(height: 24),
                const Text(
                  'VegNonVeg v1.0.0',
                  style: TextStyle(fontSize: 12, color: AppColors.grey500),
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.grey700, size: 22),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
        color: AppColors.grey400,
      ),
      onTap: onTap,
    );
  }
}
