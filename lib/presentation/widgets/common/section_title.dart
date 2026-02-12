import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        children: [
          // Centered title — Inter Regular (closest to Avenir Next Regular)
          Center(
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Action text on the right — Inter Medium
          if (actionText != null)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: GestureDetector(
                  onTap: onActionTap,
                  child: Text(
                    actionText!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
