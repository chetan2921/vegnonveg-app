import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/product_provider.dart';

import '../../../data/demo_data.dart';
import '../../widgets/common/shimmer_widgets.dart';
import '../../widgets/common/empty_state.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProductProvider>();
      if (provider.products.isEmpty) {
        provider.fetchProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Consumer<ProductProvider>(
          builder: (context, provider, _) {
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterSheet(context),
                ),
                if (provider.hasActiveFilters)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: AppColors.accentRed,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${provider.activeFilterCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        title: Image.asset('assets/images/vnv-white-bg-logo.png', height: 55),
        actions: [
          Consumer<ProductProvider>(
            builder: (context, provider, _) {
              return TextButton.icon(
                onPressed: () => _showSortSheet(context),
                icon: const Icon(Icons.sort, size: 18),
                label: const Text('Sort', style: TextStyle(fontSize: 13)),
              );
            },
          ),
        ],
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const ShimmerProductGrid(itemCount: 6);
          }

          if (provider.error != null) {
            return ErrorStateWidget(
              message: provider.error!,
              onRetry: () => provider.fetchProducts(),
            );
          }

          final products = provider.products;

          if (products.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.search_off,
              title: 'No products found',
              subtitle: 'Try adjusting your filters or search criteria.',
              buttonText: 'Clear Filters',
              onButtonTap: () => provider.clearFilters(),
            );
          }

          return Column(
            children: [
              // Active filters bar
              if (provider.hasActiveFilters)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${products.length} products',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey600,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => provider.clearFilters(),
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.accentRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Product grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 4,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () => context.push('/product/${product.id}'),
                      child: ClipRRect(
                        borderRadius: BorderRadius.zero,
                        child: CachedNetworkImage(
                          imageUrl: product.images.first,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.grey100,
                            child: const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.grey100,
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              color: AppColors.grey400,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSortSheet(BuildContext context) {
    final provider = context.read<ProductProvider>();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SORT BY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 16),
              ...[
                (ProductSortOption.popularity, 'Popularity'),
                (ProductSortOption.newIn, 'New In'),
                (ProductSortOption.priceLowToHigh, 'Price: Low to High'),
                (ProductSortOption.priceHighToLow, 'Price: High to Low'),
              ].map((entry) {
                final isSelected = provider.sortOption == entry.$1;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    entry.$2,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: AppColors.primaryBlack)
                      : null,
                  onTap: () {
                    provider.setSortOption(entry.$1);
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Consumer<ProductProvider>(
              builder: (context, provider, _) {
                return Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'FILTERS',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              provider.clearFilters();
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Clear All',
                              style: TextStyle(color: AppColors.accentRed),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),

                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Brand filter
                          const Text(
                            'BRAND',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: DemoData.brands.map((brand) {
                              final isSelected = provider.selectedBrands
                                  .contains(brand.name);
                              return FilterChip(
                                label: Text(brand.name),
                                selected: isSelected,
                                onSelected: (_) =>
                                    provider.toggleBrand(brand.name),
                                selectedColor: AppColors.primaryBlack,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primaryWhite
                                      : AppColors.primaryBlack,
                                  fontSize: 12,
                                ),
                                checkmarkColor: AppColors.primaryWhite,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Gender filter
                          const Text(
                            'GENDER',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: ['Men', 'Women', 'Unisex'].map((gender) {
                              final isSelected = provider.selectedGenders
                                  .contains(gender);
                              return FilterChip(
                                label: Text(gender),
                                selected: isSelected,
                                onSelected: (_) =>
                                    provider.toggleGender(gender),
                                selectedColor: AppColors.primaryBlack,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? AppColors.primaryWhite
                                      : AppColors.primaryBlack,
                                  fontSize: 12,
                                ),
                                checkmarkColor: AppColors.primaryWhite,
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Price range
                          const Text(
                            'PRICE RANGE',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RangeSlider(
                            values: provider.priceRange,
                            min: 0,
                            max: 50000,
                            divisions: 50,
                            activeColor: AppColors.primaryBlack,
                            labels: RangeLabels(
                              '₹${provider.priceRange.start.round()}',
                              '₹${provider.priceRange.end.round()}',
                            ),
                            onChanged: (values) =>
                                provider.setPriceRange(values),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${provider.priceRange.start.round()}',
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                '₹${provider.priceRange.end.round()}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Apply button
                    SafeArea(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'SHOW ${provider.products.length} RESULTS',
                              style: const TextStyle(letterSpacing: 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
