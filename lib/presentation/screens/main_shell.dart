import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import '../../core/constants/app_colors.dart';
import '../../data/providers/cart_provider.dart';

class MainShell extends StatefulWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _routes = ['/home', '/shop', '/search', '/wishlist', '/profile'];

  void _onItemTapped(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
      context.go(_routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sync index from route
    final location = GoRouterState.of(context).uri.toString();
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) {
        if (_currentIndex != i) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _currentIndex = i);
          });
        }
        break;
      }
    }

    return Scaffold(
      extendBody: true,
      body: widget.child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 12, right: 12, bottom: 22),
        height: 56,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_outlined, Icons.home, 'Home', 0),
                  _navItem(
                    Icons.grid_view_outlined,
                    Icons.grid_view,
                    'Shop',
                    1,
                  ),
                  _navItem(Icons.search, Icons.search, 'Search', 2),
                  _navItem(
                    Icons.star_border_outlined,
                    Icons.star,
                    'Wishlist',
                    3,
                  ),
                  _navItem(Icons.person_outline, Icons.person, 'Profile', 4),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) return const SizedBox.shrink();
          return FloatingActionButton(
            backgroundColor: AppColors.primaryBlack,
            onPressed: () => context.push('/cart'),
            child: badges.Badge(
              badgeContent: Text(
                '${cart.itemCount}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
              badgeStyle: const badges.BadgeStyle(
                badgeColor: AppColors.accentRed,
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                color: AppColors.primaryWhite,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _navItem(IconData icon, IconData activeIcon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Icon(
          isSelected ? activeIcon : icon,
          size: 24,
          color: isSelected ? AppColors.primaryBlack : AppColors.grey500,
        ),
      ),
    );
  }
}
