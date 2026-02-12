import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/common/empty_state.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MY ORDERS',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        title: 'No orders yet',
        subtitle: 'When you place orders, they will appear here.',
        buttonText: 'START SHOPPING',
        onButtonTap: () => context.go('/shop'),
      ),
    );
  }
}
