import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animate_do/animate_do.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/providers/product_provider.dart';

import '../../../data/providers/cart_provider.dart';
import '../../../data/demo_data.dart';
import '../../widgets/common/section_title.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bannerIndex = 0;
  int _communityIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _shopTheLookKey = GlobalKey();
  double _shopTheLookProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchProducts();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final keyContext = _shopTheLookKey.currentContext;
    if (keyContext == null) return;

    final box = keyContext.findRenderObject() as RenderBox?;
    if (box == null || !box.attached) return;

    final position = box.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    // progress goes 0→1 as the widget top moves from bottom of screen to 1/3 from top
    final start = screenHeight; // widget top is at bottom edge
    final end = screenHeight * 0.25; // widget top is at 25% from top
    final raw = (start - position.dy) / (start - end);
    final progress = raw.clamp(0.0, 1.0);

    if ((progress - _shopTheLookProgress).abs() > 0.001) {
      setState(() => _shopTheLookProgress = progress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        color: AppColors.primaryBlack,
        onRefresh: () => context.read<ProductProvider>().fetchProducts(),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroBanner(),
              const SizedBox(height: 24),
              _buildCategoryChips(),
              const SizedBox(height: 24),
              const SectionTitle(title: 'Sneaker Launches'),
              _buildSneakerLaunches(),
              const SizedBox(height: 10),
              _buildShopAllButton('SHOP ALL FOOTWEAR'),
              const SizedBox(height: 40),
              _buildPromoBanner(),
              const SizedBox(height: 40),
              const SectionTitle(title: 'What\'s Trending'),
              _buildWhatsTrending(),
              const SizedBox(height: 16),
              const SectionTitle(title: 'What\'s Hot In Apparel'),
              _buildApparelGrid(),
              const SizedBox(height: 10),
              _buildShopAllButton('SHOP ALL APPAREL'),
              const SizedBox(height: 40),
              // const SectionTitle(title: 'Shop The Look'),
              // _buildShopTheLook(),
              // const SizedBox(height: 40),
              const SectionTitle(title: 'OUR COMMUNITY + CULTURE + EVENTS'),
              _buildCommunitySection(),
              const SizedBox(height: 32),
              _buildContactFooter(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
          child: GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: const Icon(Icons.menu, size: 24),
          ),
        ),
      ),
      title: Image.asset('assets/images/vnv-white-bg-logo.png', height: 55),
      centerTitle: true,
      actions: [
        Consumer<CartProvider>(
          builder: (context, cart, _) {
            return IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.shopping_bag_outlined, size: 24),
                  if (!cart.isEmpty)
                    Positioned(
                      right: -6,
                      top: -4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.accentRed,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${cart.itemCount}',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              onPressed: () => context.push('/cart'),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  static const List<String> _bannerAssets = [
    'assets/images/banner_2.jpeg',
    'assets/images/banner_3.jpeg',
    'assets/images/banner_1.jpeg',
    'assets/images/banner_4.jpeg',
    'assets/images/banner_5.jpeg',
  ];

  Widget _buildHeroBanner() {
    return FadeIn(
      child: SizedBox(
        height: 420,
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 420,
                viewportFraction: 1.0,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                autoPlayCurve: Curves.easeInOut,
                enlargeCenterPage: false,
                onPageChanged: (index, _) {
                  setState(() => _bannerIndex = index);
                },
              ),
              items: _bannerAssets.map((assetPath) {
                return Container(
                  width: double.infinity,
                  color: AppColors.grey100,
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 420,
                  ),
                );
              }).toList(),
            ),
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Center(
                child: AnimatedSmoothIndicator(
                  activeIndex: _bannerIndex,
                  count: _bannerAssets.length,
                  effect: SlideEffect(
                    dotHeight: 3,
                    dotWidth: 20,
                    spacing: 6,
                    activeDotColor: AppColors.primaryWhite,
                    dotColor: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    final categories = DemoData.categories;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => context.go('/shop'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: index == 0 ? AppColors.primaryBlack : AppColors.grey100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.grey300, width: 0.5),
              ),
              child: Center(
                child: Text(
                  categories[index].name.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: index == 0
                        ? AppColors.primaryWhite
                        : AppColors.primaryBlack,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.primaryWhite,
      child: SafeArea(
        child: Column(
          children: [
            // Top bar with close and logo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close, size: 24),
                  ),
                  const Spacer(),
                  Image.asset(
                    'assets/images/vnv-white-bg-logo.png',
                    height: 35,
                  ),
                  const Spacer(),
                  const SizedBox(width: 24), // Balance for close icon
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Menu items
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _drawerMenuText('NEW IN', () {
                      Navigator.pop(context);
                      context.go('/shop');
                    }),
                    _drawerMenuText('APPAREL', () {
                      Navigator.pop(context);
                      context.go('/shop');
                    }),
                    _drawerMenuText('FOOTWEAR', () {
                      Navigator.pop(context);
                      context.go('/shop');
                    }),
                    _drawerMenuText('RUNNING', () {
                      Navigator.pop(context);
                      context.go('/shop');
                    }),
                    _drawerMenuText('VEGNONVEG', () {
                      Navigator.pop(context);
                      context.go('/shop');
                    }),
                    _drawerMenuText('WOMEN', () {
                      Navigator.pop(context);
                      context.go('/shop');
                    }),
                    _drawerMenuText('LIFESTYLE', () {
                      Navigator.pop(context);
                      context.go('/shop');
                    }),
                    _drawerMenuText('BRANDS', () {
                      Navigator.pop(context);
                      context.go('/shop');
                    }),
                    _drawerMenuText('MARKDOWNS', () {
                      Navigator.pop(context);
                      context.go('/shop');
                    }),
                    _drawerMenuText('SHOP THE LOOK', () {
                      Navigator.pop(context);
                      context.go('/shop');
                    }),
                    const SizedBox(height: 24),
                    // Newsletter button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
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
                    ),
                    const SizedBox(height: 24),
                    // Footer links
                    _buildDrawerFooter(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerMenuText(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.5,
            color: AppColors.primaryBlack,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
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
          const SizedBox(height: 24),
        ],
      ),
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

  static const List<Map<String, String>> _communityItems = [
    {
      'title': 'Vandy The Pink Now Available',
      'subtitle': 'Exclusive at VegNonVeg',
      'image':
          'assets/images/vandy-the-pink-now-available-at-vegnonveg-687e1e6f32418.webp',
    },
    {
      'title': 'VegNonVeg Hyderabad Is Now Open',
      'subtitle': 'Visit our newest store',
      'image':
          'assets/images/vegnonveg-hyderabad-is-now-open-691d9fb51beab.webp',
    },
    {
      'title': 'Kissa Evenings In Gurgaon',
      'subtitle': 'Community vibes',
      'image':
          'assets/images/vegnonveg-kissa-evenings-in-gurgaon-67f36efd1fbc8.webp',
    },
    {
      'title': 'Charm School With Schwifty',
      'subtitle': 'Culture & events',
      'image':
          'assets/images/vegnonvegs-charm-school-with-schwifty-684a5fe130847.webp',
    },
  ];

  Widget _buildCommunitySection() {
    return SizedBox(
      height: 500,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 500,
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 2),
              autoPlayAnimationDuration: const Duration(milliseconds: 1000),
              autoPlayCurve: Curves.easeInOut,
              enlargeCenterPage: false,
              onPageChanged: (index, _) {
                setState(() => _communityIndex = index);
              },
            ),
            items: _communityItems.map((item) {
              return Container(
                width: double.infinity,
                color: AppColors.grey100,
                child: Stack(
                  children: [
                    Image.asset(
                      item['image']!,
                      width: double.infinity,
                      height: 500,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['subtitle']!,
                            style: GoogleFonts.inter(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedSmoothIndicator(
                activeIndex: _communityIndex,
                count: _communityItems.length,
                effect: SlideEffect(
                  dotHeight: 3,
                  dotWidth: 20,
                  spacing: 6,
                  activeDotColor: AppColors.primaryWhite,
                  dotColor: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopAllButton(String text) {
    return Center(
      child: GestureDetector(
        onTap: () => context.go('/shop'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlack,
              decoration: TextDecoration.underline,
              letterSpacing: 1.0,
            ),
          ),
        ),
      ),
    );
  }

  static const List<String> _trendingTags = [
    'BESTSELLERS',
    'COLLABS',
    'DUNKS',
    'AIR FORCE 1',
    'JORDAN',
    'GEN X SOFT CLUB',
    'PATTERNS AND TEXTURES',
    'PERFORMANCE INSPIRED',
    'VNV FW25 CAPSULE',
    'COZY BROWNS',
  ];

  Widget _buildWhatsTrending() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: _trendingTags.map((tag) {
          return GestureDetector(
            onTap: () => context.go('/shop'),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                tag,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5,
                  color: AppColors.primaryBlack,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static const List<String> _apparelAssets = [
    'assets/images/adidas-originals-mer-gr-gf-tee-m-george-russell-black-69848fd50de2e.webp',
    'assets/images/jordan-jordan-flight-printed-cat-scratch-short-black-6985df6fc69bb.webp',
    'assets/images/jordan-jordan-sport-dri-fit-printed-diamond-short-black-6985decf1e4c1.webp',
    'assets/images/adidas-originals-mer-ka-gf-tee-m-kimi-antonelli-black-698490b9734fb.webp',
  ];

  Widget _buildApparelGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: _apparelAssets.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          duration: const Duration(milliseconds: 400),
          child: GestureDetector(
            onTap: () => context.push('/shop'),
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: Image.asset(_apparelAssets[index], fit: BoxFit.cover),
            ),
          ),
        );
      },
    );
  }

  static const List<String> _shopTheLookAssets = [
    'assets/images/billionaire-boys-club-heavy-stripe-long-sleeve-rugby-polo-orange-stripe-69424075b421a.webp',
    'assets/images/converse-chuck-70-de-luxe-pointed-platform-woven-leather-high-egret-694fa1dc38144.webp',
    'assets/images/17704490456986e895dfed2-desktop.webp',
    'assets/images/vegnonveg-mesh-bubble-skirt-white-68a6b7c499c16.webp',
    'assets/images/vegnonveg-oversized-jacquard-cardigan-mustard-6944e82b025a6.webp',
  ];

  Widget _buildShopTheLook() {
    const double cardWidth = 180;
    const double cardHeight = 240;
    final int count = _shopTheLookAssets.length;
    final screenWidth = MediaQuery.of(context).size.width - 32; // minus padding

    final progress = _shopTheLookProgress;
    // Apply easeOutCubic for smooth physics
    final curved = Curves.easeOutCubic.transform(progress);

    // The spacing between cards when fully expanded
    final expandedSpacing = (screenWidth - cardWidth) / (count - 1);

    return Container(
      key: _shopTheLookKey,
      height: cardHeight + 40, // extra room for shadow + slight rotation
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(count, (index) {
          // Stagger each card's animation
          final staggerDelay = index * 0.10;
          final cardProgress = ((curved - staggerDelay) / (1.0 - staggerDelay))
              .clamp(0.0, 1.0);

          // Spring curve per card
          final spring = Curves.easeOutBack.transform(cardProgress);

          // Horizontal position: starts at 0, fans out to expandedSpacing * index
          final targetLeft = index * expandedSpacing;
          final left = targetLeft * spring;

          // Slight rotation when collapsed, straightens when expanded
          final rotation = (1 - spring) * (index - 2) * 0.03;

          // Scale: slightly smaller in back, full when fanned out
          final scale = 0.94 + 0.06 * spring;

          // Opacity: first card always visible, others fade in
          final opacity = index == 0 ? 1.0 : cardProgress.clamp(0.0, 1.0);

          // Z-order: reversed so first card is on top when collapsed
          return Positioned(
            top: 10,
            left: left,
            width: cardWidth,
            height: cardHeight,
            child: Transform(
              alignment: Alignment.bottomCenter,
              transform: Matrix4.identity()
                ..rotateZ(rotation)
                ..scale(scale, scale),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: 0.10 + 0.08 * cardProgress,
                        ),
                        blurRadius: 8 + 6 * cardProgress,
                        offset: Offset(0, 3 + 3 * cardProgress),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      _shopTheLookAssets[index],
                      fit: BoxFit.cover,
                      width: cardWidth,
                      height: cardHeight,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).reversed.toList(), // reversed so card 0 renders on top of the stack
      ),
    );
  }

  Widget _buildSneakerLaunches() {
    final products = context.watch<ProductProvider>().newArrivals;
    if (products.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    final displayProducts = products.take(4).toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: displayProducts.length,
      itemBuilder: (context, index) {
        final product = displayProducts[index];
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          duration: const Duration(milliseconds: 400),
          child: GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: ClipRRect(
              borderRadius: BorderRadius.zero,
              child: CachedNetworkImage(
                imageUrl: product.images.first,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.grey100,
                  child: const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.grey100,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.grey400,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      height: 400,
      decoration: const BoxDecoration(color: AppColors.grey100),
      child: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/promo_banner.webp',
            width: double.infinity,
            height: 400,
            fit: BoxFit.fill,
          ),
          // Gradient overlay
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.topCenter,
          //       end: Alignment.bottomCenter,
          //       colors: [
          //         Colors.black.withValues(alpha: 0.3),
          //         Colors.black.withValues(alpha: 0.6),
          //       ],
          //     ),
          //   ),
          // ),
          // Content
          // Positioned(
          //   left: 20,
          //   top: 20,
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          //     decoration: BoxDecoration(
          //       color: Colors.greenAccent.withValues(alpha: 0.9),
          //       borderRadius: BorderRadius.circular(4),
          //     ),
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Icon(Icons.add, size: 16, color: AppColors.primaryBlack),
          //         const SizedBox(width: 4),
          //         const Text(
          //           'SHOP NOW',
          //           style: TextStyle(
          //             color: AppColors.primaryBlack,
          //             fontSize: 11,
          //             fontWeight: FontWeight.w700,
          //             letterSpacing: 1,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Positioned(
          //   bottom: 20,
          //   left: 20,
          //   right: 20,
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       const Text(
          //         'RUNNING-INSPIRED',
          //         style: TextStyle(
          //           color: AppColors.primaryWhite,
          //           fontSize: 32,
          //           fontWeight: FontWeight.w900,
          //           letterSpacing: 1.5,
          //           height: 1.1,
          //         ),
          //       ),
          //       const Text(
          //         'NEW BALANCE',
          //         style: TextStyle(
          //           color: AppColors.primaryWhite,
          //           fontSize: 32,
          //           fontWeight: FontWeight.w900,
          //           letterSpacing: 1.5,
          //           height: 1.1,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
