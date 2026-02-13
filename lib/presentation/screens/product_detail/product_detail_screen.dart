import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/product.dart';
import '../../../data/providers/product_provider.dart';
import '../../../data/providers/cart_provider.dart';
import '../../../data/providers/wishlist_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  String? _selectedSize;
  bool _addedToBag = false;

  Product? _product;

  @override
  void initState() {
    super.initState();
    final provider = context.read<ProductProvider>();
    final allProducts = provider.products;
    try {
      _product = allProducts.firstWhere((p) => p.id == widget.productId);
    } catch (_) {
      _product = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = _product;
    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.primaryWhite,
      appBar: AppBar(
        title: Image.asset('assets/images/vnv-white-bg-logo.png', height: 55),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 22),
            onPressed: () => _shareProduct(product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageCarousel(product),
            const SizedBox(height: 16),
            _buildProductInfo(product),
            const SizedBox(height: 24),
            _buildSizeSelector(product),
            const SizedBox(height: 24),
            _buildSizeFitSlider(),
            const SizedBox(height: 24),
            _buildDescription(product),
            if (product.specifications != null &&
                product.specifications!.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildSpecifications(product),
            ],
            const SizedBox(height: 24),
            _buildActionButtons(product),
            const SizedBox(height: 100),
            _buildRelatedProducts(product),
            const SizedBox(height: 32),
            _buildContactFooter(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(product),
    );
  }

  Widget _buildImageCarousel(Product product) {
    return Container(
      color: AppColors.grey50,
      height: MediaQuery.of(context).size.height * 0.5,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: double.infinity,
              viewportFraction: 1.0,
              enableInfiniteScroll: product.images.length > 1,
              onPageChanged: (index, _) {
                setState(() => _currentImageIndex = index);
              },
            ),
            items: product.images.map((url) {
              return CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                width: double.infinity,
                placeholder: (_, __) => Container(
                  color: AppColors.grey50,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.grey50,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_outlined,
                      size: 64,
                      color: AppColors.grey300,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          if (product.images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: _currentImageIndex,
                  count: product.images.length,
                  effect: const SlideEffect(
                    dotHeight: 3,
                    dotWidth: 20,
                    spacing: 6,
                    activeDotColor: AppColors.primaryBlack,
                    dotColor: AppColors.grey300,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category/Gender
          Text(
            product.gender.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 8),

          // Product name
          Text(
            product.name.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),

          // Color/Variant
          if (product.colors.isNotEmpty)
            Text(
              product.colors.first.toUpperCase(),
              style: GoogleFonts.inter(fontSize: 14, color: AppColors.grey700),
            ),
          const SizedBox(height: 16),

          // Price
          Text(
            Formatters.currency(product.effectivePrice),
            style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'MRP Inclusive Of All Taxes',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSelector(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'UK SIZE',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              GestureDetector(
                onTap: () => _showSizeGuide(),
                child: Text(
                  'SIZE GUIDE',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    color: AppColors.grey600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: product.sizes.map((size) {
                final isSelected = _selectedSize == size;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedSize = size),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 52,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryBlack
                            : AppColors.primaryWhite,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryBlack
                              : AppColors.grey300,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.zero,
                      ),
                      child: Center(
                        child: Text(
                          size.replaceAll(
                            RegExp(r'UK\s*', caseSensitive: false),
                            '',
                          ),
                          style: GoogleFonts.inter(
                            color: isSelected
                                ? AppColors.primaryWhite
                                : AppColors.primaryBlack,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeFitSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Track background
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // 3 tick marks
                  for (final pos in [0.0, 0.5, 1.0])
                    Positioned(
                      left: pos * width - 4,
                      top: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: pos == 0.5
                              ? AppColors.primaryBlack
                              : AppColors.grey300,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  // Active indicator at center ("true to size")
                  Positioned(
                    left: 0.5 * width - 7,
                    top: -5,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlack,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryWhite,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Runs small',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey500,
                  letterSpacing: 0.3,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'True to size',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlack,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              Text(
                'Runs large',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.grey500,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PRODUCT DETAILS',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: GoogleFonts.inter(
              fontSize: 14,
              height: 1.6,
              color: AppColors.grey700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Product product) {
    final isWishlisted = context.watch<WishlistProvider>().isWishlisted(
      product.id,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => context.read<WishlistProvider>().toggle(product),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.grey300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Text(
                isWishlisted ? 'WISHLISTED' : 'ADD TO WISHLIST',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.primaryBlack,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Helpers.showSnackBar(context, 'Store locator coming soon');
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.grey300),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Text(
                'FIND IN STORE',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.primaryBlack,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecifications(Product product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SPECIFICATIONS',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ...product.specifications!.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      entry.key,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.grey600,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${entry.value}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRelatedProducts(Product product) {
    final related = context.read<ProductProvider>().getRelatedProducts(product);
    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.primaryBlack, width: 2),
                  ),
                ),
                child: Text(
                  'YOU MAY ALSO LIKE',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Text(
                'RECENTLY VIEWED',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 2),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
          ),
          itemCount: related.take(4).length,
          itemBuilder: (context, index) {
            final relatedProduct = related[index];
            return GestureDetector(
              onTap: () {
                context.push('/product/${relatedProduct.id}');
              },
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: CachedNetworkImage(
                  imageUrl: relatedProduct.images.first,
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
      ],
    );
  }

  Widget _footerLink(String text) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          color: AppColors.grey700,
        ),
      ),
    );
  }

  Widget _socialIcon(IconData icon, String url) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Icon(icon, size: 24, color: AppColors.primaryBlack),
    );
  }

  Widget _buildContactFooter() {
    return Container(
      color: AppColors.grey50,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        children: [
          // Newsletter
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.grey200,
                foregroundColor: AppColors.primaryBlack,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(
                'SIGN UP FOR OUR NEWSLETTER',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Footer links
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              _footerLink('ABOUT US'),
              _footerLink('CONTACT / LOCATE US'),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              _footerLink('SHIPPING INFORMATION'),
              _footerLink('RETURN AND EXCHANGE'),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 8,
            children: [
              _footerLink('LEGAL'),
              _footerLink('CAREERS'),
              _footerLink('VNV MAGAZINE'),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'FOLLOW US ON',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1,
              color: AppColors.grey600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(Icons.facebook, 'https://facebook.com'),
              const SizedBox(width: 20),
              _socialIcon(Icons.camera_alt_outlined, 'https://instagram.com'),
              const SizedBox(width: 20),
              _socialIcon(Icons.chat_bubble_outline, 'https://whatsapp.com'),
              const SizedBox(width: 20),
              _socialIcon(Icons.play_circle_outline, 'https://youtube.com'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(Product product) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.primaryWhite,
        border: Border(top: BorderSide(color: AppColors.grey200, width: 1)),
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: !product.isAvailable
                ? null
                : _addedToBag
                ? () => context.push('/cart')
                : _selectedSize == null
                ? () => Helpers.showSnackBar(
                    context,
                    'Please select a size first',
                    isError: true,
                  )
                : () {
                    context.read<CartProvider>().addItem(
                      product,
                      _selectedSize!,
                    );
                    setState(() => _addedToBag = true);
                    Helpers.showSnackBar(context, 'Added to bag');
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: !product.isAvailable
                  ? AppColors.grey400
                  : AppColors.primaryBlack,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              elevation: 0,
            ),
            child: Text(
              !product.isAvailable
                  ? 'SOLD OUT'
                  : _addedToBag
                  ? 'GO TO BAG'
                  : 'ADD TO BAG',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: AppColors.primaryWhite,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _shareProduct(Product product) async {
    final String shareText =
        '''
Check out this ${product.brand} sneaker on VegNonVeg!

${product.name}
${Formatters.currency(product.effectivePrice)}

${product.description}

#VegNonVeg #Sneakers #${product.brand}
'''
            .trim();

    try {
      await Share.share(shareText, subject: product.name);
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          'Unable to share at the moment',
          isError: true,
        );
      }
    }
  }

  void _showSizeGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.85,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SIZE GUIDE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Table(
                        border: TableBorder.all(color: AppColors.grey200),
                        children: [
                          const TableRow(
                            decoration: BoxDecoration(color: AppColors.grey100),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'UK',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'US',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'EU',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'CM',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...List.generate(8, (index) {
                            final uk = 6 + index;
                            return TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '$uk',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '${uk + 1}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '${39 + index}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(
                                    '${24.0 + index * 0.5}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
