import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/demo_data.dart';
import '../../../data/models/product.dart';
import '../../../data/providers/product_provider.dart';
import '../../widgets/common/empty_state.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  List<Product> _results = [];
  bool _hasSearched = false;

  final List<String> _trendingSearches = [
    'Jordan 1',
    'Dunk Low',
    'Yeezy',
    'Air Force 1',
    'New Balance 550',
    'Air Max',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String query) {
    final provider = context.read<ProductProvider>();
    if (query.trim().isEmpty) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }
    final q = query.toLowerCase();
    setState(() {
      _hasSearched = true;
      _results = provider.products.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.brand.toLowerCase().contains(q) ||
            p.category.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/vnv-white-bg-logo.png', height: 55),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _focusNode,
                onChanged: _search,
                decoration: InputDecoration(
                  hintText: 'Search sneakers, brands...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: AppColors.grey500,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.grey500,
                    size: 20,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                            color: AppColors.grey600,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            _search('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
          // Image Search Button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GestureDetector(
              onTap: () => context.push('/image-search'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primaryBlack),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      size: 18,
                      color: AppColors.primaryBlack,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Search by Image',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Results/Discovery
          Expanded(child: _hasSearched ? _buildResults() : _buildDiscovery()),
        ],
      ),
    );
  }

  Widget _buildDiscovery() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TRENDING SEARCHES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _trendingSearches.map((term) {
              return ActionChip(
                label: Text(
                  term,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryBlack,
                  ),
                ),
                onPressed: () {
                  _searchController.text = term;
                  _search(term);
                },
                backgroundColor: AppColors.grey50,
                side: const BorderSide(color: AppColors.grey200),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          const Text(
            'POPULAR BRANDS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 12),
          ...DemoData.brands.take(6).map((brand) {
            final count = context
                .read<ProductProvider>()
                .products
                .where((p) => p.brand.toLowerCase() == brand.name.toLowerCase())
                .length;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: AppColors.grey100,
                child: Text(
                  brand.name[0],
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlack,
                  ),
                ),
              ),
              title: Text(
                brand.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                '$count products',
                style: const TextStyle(fontSize: 12, color: AppColors.grey600),
              ),
              trailing: const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.grey400,
              ),
              onTap: () {
                _searchController.text = brand.name;
                _search(brand.name);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_results.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No results found',
        subtitle: 'Try a different search term or browse our collection.',
        buttonText: 'CLEAR SEARCH',
        onButtonTap: () {
          _searchController.clear();
          _search('');
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            '${_results.length} result${_results.length != 1 ? 's' : ''}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.grey600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: _results.length,
            itemBuilder: (context, index) {
              final product = _results[index];
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
                          child: CircularProgressIndicator(strokeWidth: 2),
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
  }
}
