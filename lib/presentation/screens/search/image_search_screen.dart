import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/image_search_service.dart';
import '../../../data/providers/product_provider.dart';
import '../../widgets/product_cards/product_card.dart';
import '../../../core/utils/helpers.dart';

class ImageSearchScreen extends StatefulWidget {
  const ImageSearchScreen({super.key});

  @override
  State<ImageSearchScreen> createState() => _ImageSearchScreenState();
}

class _ImageSearchScreenState extends State<ImageSearchScreen> {
  final ImageSearchService _imageSearchService = ImageSearchService();
  String? _imagePath;
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/vnv-white-bg-logo.png', height: 55),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: _imagePath == null ? _buildImagePicker() : _buildSearchResults(),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_search, size: 100, color: AppColors.grey300),
            const SizedBox(height: 24),
            Text(
              'Search by Image',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Upload a photo or take a picture to find similar products',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.grey600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _pickImageFromGallery,
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(
                  'CHOOSE FROM GALLERY',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlack,
                  foregroundColor: AppColors.primaryWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _captureFromCamera,
                icon: const Icon(Icons.camera_alt_outlined),
                label: Text(
                  'TAKE A PHOTO',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlack,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: AppColors.primaryBlack),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      children: [
        // Selected Image Preview
        Container(
          height: 200,
          width: double.infinity,
          color: AppColors.grey100,
          child: Stack(
            children: [
              Image.file(
                File(_imagePath!),
                width: double.infinity,
                height: 200,
                fit: BoxFit.contain,
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      _imagePath = null;
                      _isSearching = false;
                    });
                  },
                  icon: const Icon(Icons.close),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primaryWhite,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Search Button
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isSearching ? null : _performImageSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlack,
                foregroundColor: AppColors.primaryWhite,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: _isSearching
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.primaryWhite,
                        ),
                      ),
                    )
                  : Text(
                      'SEARCH SIMILAR PRODUCTS',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),

        // Results
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    if (_isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    final productProvider = context.watch<ProductProvider>();
    final products = productProvider.products; // Use all products for demo

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.grey300),
            const SizedBox(height: 16),
            Text(
              'No similar products found',
              style: GoogleFonts.inter(fontSize: 16, color: AppColors.grey600),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () => context.push('/product/${product.id}'),
        );
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final imagePath = await _imageSearchService.pickFromGallery();
    if (imagePath != null) {
      setState(() {
        _imagePath = imagePath;
      });
    } else {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          'Unable to access gallery. Please check permissions.',
        );
      }
    }
  }

  Future<void> _captureFromCamera() async {
    final imagePath = await _imageSearchService.captureFromCamera();
    if (imagePath != null) {
      setState(() {
        _imagePath = imagePath;
      });
    } else {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          'Unable to access camera. Please check permissions.',
        );
      }
    }
  }

  Future<void> _performImageSearch() async {
    setState(() {
      _isSearching = true;
    });

    // Simulate AI image search (in production, send image to backend ML service)
    await Future.delayed(const Duration(seconds: 2));

    // For demo: just show results
    if (mounted) {
      final productProvider = context.read<ProductProvider>();
      final totalProducts = productProvider.products.length;

      setState(() {
        _isSearching = false;
      });

      Helpers.showSnackBar(context, 'Found $totalProducts similar products');
    }
  }
}
