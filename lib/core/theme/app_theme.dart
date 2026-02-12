import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primaryBlack,
      scaffoldBackgroundColor: AppColors.primaryWhite,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryBlack,
        secondary: AppColors.accentRed,
        surface: AppColors.primaryWhite,
        error: AppColors.error,
        onPrimary: AppColors.primaryWhite,
        onSecondary: AppColors.primaryWhite,
        onSurface: AppColors.primaryBlack,
        onError: AppColors.primaryWhite,
      ),
      textTheme:
          GoogleFonts.interTextTheme(
            const TextTheme(
              headlineLarge: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlack,
                letterSpacing: 0.5,
              ),
              headlineMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlack,
              ),
              headlineSmall: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlack,
              ),
              titleLarge: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlack,
              ),
              titleMedium: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlack,
                letterSpacing: 0.5,
              ),
              titleSmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.grey700,
                letterSpacing: 0.5,
              ),
              bodyLarge: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.primaryBlack,
              ),
              bodyMedium: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppColors.grey800,
              ),
              bodySmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: AppColors.grey600,
              ),
              labelLarge: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryWhite,
                letterSpacing: 1.0,
              ),
              labelMedium: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
              ),
              labelSmall: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.grey600,
                letterSpacing: 0.5,
              ),
            ),
          ).copyWith(
            // Anton for big display/banner text (e.g. "YOURS MINE OURS")
            displayLarge: GoogleFonts.anton(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryBlack,
              letterSpacing: 1.5,
            ),
            displayMedium: GoogleFonts.anton(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryBlack,
              letterSpacing: 1.0,
            ),
            displaySmall: GoogleFonts.anton(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryBlack,
              letterSpacing: 0.5,
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primaryWhite,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.primaryBlack),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.primaryBlack,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlack,
          foregroundColor: AppColors.primaryWhite,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryBlack,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          side: const BorderSide(color: AppColors.primaryBlack, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryBlack,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primaryBlack,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: GoogleFonts.inter(color: AppColors.grey500, fontSize: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey100,
        selectedColor: AppColors.primaryBlack,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        side: const BorderSide(color: AppColors.grey300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.primaryWhite,
        selectedItemColor: AppColors.primaryBlack,
        unselectedItemColor: AppColors.grey500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.grey200,
        thickness: 1,
        space: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColors.primaryWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.primaryWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.grey900,
        contentTextStyle: GoogleFonts.inter(color: AppColors.primaryWhite),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryWhite,
      scaffoldBackgroundColor: AppColors.surfaceDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryWhite,
        secondary: AppColors.accentRed,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: AppColors.primaryBlack,
        onSecondary: AppColors.primaryWhite,
        onSurface: AppColors.primaryWhite,
        onError: AppColors.primaryWhite,
      ),
      textTheme:
          GoogleFonts.interTextTheme(
            const TextTheme(
              headlineLarge: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryWhite,
              ),
              headlineMedium: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryWhite,
              ),
              headlineSmall: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryWhite,
              ),
              titleLarge: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryWhite,
              ),
              titleMedium: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryWhite,
              ),
              titleSmall: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.grey400,
              ),
              bodyLarge: TextStyle(fontSize: 16, color: AppColors.primaryWhite),
              bodyMedium: TextStyle(fontSize: 14, color: AppColors.grey300),
              bodySmall: TextStyle(fontSize: 12, color: AppColors.grey400),
              labelLarge: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlack,
              ),
              labelMedium: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.grey400,
              ),
              labelSmall: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.grey500,
              ),
            ),
          ).copyWith(
            // Anton for big display/banner text
            displayLarge: GoogleFonts.anton(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryWhite,
              letterSpacing: 1.5,
            ),
            displayMedium: GoogleFonts.anton(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryWhite,
              letterSpacing: 1.0,
            ),
            displaySmall: GoogleFonts.anton(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryWhite,
              letterSpacing: 0.5,
            ),
          ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        iconTheme: const IconThemeData(color: AppColors.primaryWhite),
        titleTextStyle: GoogleFonts.inter(
          color: AppColors.primaryWhite,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryWhite,
          foregroundColor: AppColors.primaryBlack,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryWhite,
          side: const BorderSide(color: AppColors.primaryWhite, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.grey800),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: AppColors.primaryWhite,
            width: 1.5,
          ),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryWhite,
        unselectedItemColor: AppColors.grey600,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
    );
  }
}
