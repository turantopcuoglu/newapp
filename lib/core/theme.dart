import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'mood_palette.dart';
import 'enums.dart';
import 'wellness_motion.dart';
import 'atmosphere_surface.dart';
export 'mood_palette.dart';
export 'wellness_motion.dart' show WellnessIconButton;

abstract class AppTheme {
  // Moonlit palette. Legacy names remain aliases for existing recipe screens.
  static const Color primaryColor = Color(0xFF001426);
  static const Color mint = Color(0xFF9DE3D0);
  static const Color moon = Color(0xFFEAD5AE);
  static const Color elevated = Color(0xFF0B2940);
  static const Color danger = Color(0xFFFFB4A8);
  static const Color accentOrange = mint;
  static const Color accentTeal = Color(0xFFA9D9E7);
  static const Color warmCoral = danger;
  static const Color softLavender = Color(0xFFBCC2EC);
  static const Color successGreen = mint;
  static const Color warningAmber = moon;

  static const Color background = Color(0xFF001426);
  static const Color surface = Color(0xFF062036);
  static const Color cardDark = elevated;
  static const Color textPrimary = Color(0xFFF2F5F4);
  static const Color textSecondary = Color(0xFFADC4D3);
  static const Color textLight = Color(0xFF86A2B7);
  static const Color dividerColor = Color(0xFF34546B);

  // Meal type colors
  static const Color breakfastColor = Color(0xFFFFB020);
  static const Color lunchColor = Color(0xFF2ECC71);
  static const Color dinnerColor = Color(0xFF5B6FE6);
  static const Color snackColor = Color(0xFFE84393);

  // Gradient for dashboard header
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [background, elevated],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [mint, Color(0xFF8FD1C2)],
  );

  static ThemeData get light => dark;

  static ThemeData get dark =>
      forPalette(MoodPalette.all[CheckInType.lowEnergy]!);

  static ThemeData forPalette(MoodPalette p) => ThemeData(
    extensions: [p],
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: WellnessPageTransitions(),
        TargetPlatform.iOS: WellnessPageTransitions(),
        TargetPlatform.windows: WellnessPageTransitions(),
        TargetPlatform.linux: WellnessPageTransitions(),
        TargetPlatform.macOS: WellnessPageTransitions(),
      },
    ),
    iconTheme: IconThemeData(color: p.mint),
    dialogTheme: DialogThemeData(
      backgroundColor: p.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: p.surface,
      modalBackgroundColor: p.surface,
      showDragHandle: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: p.mint,
      contentTextStyle: TextStyle(color: p.onAction),
      actionTextColor: p.onAction,
      behavior: SnackBarBehavior.floating,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: p.mint),
    ),
    fontFamily: 'WellnessSans',
    useMaterial3: true,
    brightness: p.brightness,
    colorScheme: ColorScheme.fromSeed(
      seedColor: p.mint,
      brightness: p.brightness,
      primary: p.accentOrange,
      secondary: p.accentTeal,
      tertiary: p.softLavender,
      surface: p.surface,
      onPrimary: p.onAction,
      onSecondary: p.onAction,
      error: p.danger,
      onSurface: p.textPrimary,
    ),
    scaffoldBackgroundColor: p.background,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      backgroundColor: p.background,
      systemOverlayStyle: p.brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      foregroundColor: p.textPrimary,
      titleTextStyle: TextStyle(
        fontFamily: 'WellnessSans',
        color: p.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.3,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: p.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      margin: const EdgeInsets.symmetric(vertical: 6),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: p.accentOrange.withAlpha(50),
      selectedColor: p.accentOrange.withAlpha(45),
      labelStyle: const TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: p.textPrimary,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      side: BorderSide.none,
      showCheckmark: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: p.elevated,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: p.accentOrange, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style:
          FilledButton.styleFrom(
            backgroundColor: p.accentOrange,
            foregroundColor: p.onAction,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            textStyle: const TextStyle(
              fontFamily: 'WellnessSans',
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ).copyWith(
            backgroundBuilder: (context, states, child) =>
                AtmosphereButtonFinish(
                  pressed: states.contains(WidgetState.pressed),
                  disabled: states.contains(WidgetState.disabled),
                  child: child!,
                ),
          ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: p.accentOrange,
        side: BorderSide(color: p.accentOrange, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: p.surface,
      indicatorColor: p.accentOrange.withAlpha(30),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: p.accentOrange, size: 24);
        }
        return IconThemeData(color: p.textLight, size: 24);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return TextStyle(
            fontFamily: 'WellnessSans',
            color: p.accentOrange,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          );
        }
        return TextStyle(
          fontFamily: 'WellnessSans',
          color: p.textLight,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        );
      }),
      elevation: 0,
      height: 70,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: p.surface,
      selectedItemColor: p.accentOrange,
      unselectedItemColor: p.textLight,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: const TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: p.textPrimary,
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: p.textPrimary,
        letterSpacing: -0.3,
      ),
      titleLarge: TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: p.textPrimary,
      ),
      titleMedium: TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: p.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: p.textPrimary,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: p.textSecondary,
        height: 1.5,
      ),
      bodySmall: TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: p.textSecondary,
      ),
      labelLarge: TextStyle(
        fontFamily: 'WellnessSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: p.accentOrange,
      ),
    ),
    dividerTheme: DividerThemeData(color: p.dividerColor, thickness: 1),
  );
}
