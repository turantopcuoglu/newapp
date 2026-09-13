import 'package:flutter/material.dart';
import 'enums.dart';

/// The approved nine palettes are inherited by every route and overlay.
@immutable
class MoodPalette extends ThemeExtension<MoodPalette> {
  final CheckInType mode;
  final String tr, en, icon;
  final Brightness brightness;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color mint;
  final Color onAction;
  final Color dividerColor;
  const MoodPalette({
    required this.mode,
    required this.tr,
    required this.en,
    required this.icon,
    required this.brightness,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.mint,
    required this.onAction,
    required this.dividerColor,
  });
  static const all = <CheckInType, MoodPalette>{
    CheckInType.lowEnergy: MoodPalette(
      mode: CheckInType.lowEnergy,
      tr: 'Düşük Enerji',
      en: 'Low energy',
      icon: 'battery',
      brightness: Brightness.dark,
      background: Color(0xFF211625),
      surface: Color(0xFF39283F),
      textPrimary: Color(0xFFFFF1E7),
      textSecondary: Color(0xFFDBC5D4),
      mint: Color(0xFFFBD7B5),
      onAction: Color(0xFF211625),
      dividerColor: Color(0xFFB99FAF),
    ),
    CheckInType.bloated: MoodPalette(
      mode: CheckInType.bloated,
      tr: 'Şişkinlik',
      en: 'Bloating',
      icon: 'belly',
      brightness: Brightness.light,
      background: Color(0xFFEDF3E4),
      surface: Color(0xFFD2E4BC),
      textPrimary: Color(0xFF183C29),
      textSecondary: Color(0xFF4D634F),
      mint: Color(0xFF226A44),
      onAction: Color(0xFFF3F7EA),
      dividerColor: Color(0xFF627857),
    ),
    CheckInType.cravingSweets: MoodPalette(
      mode: CheckInType.cravingSweets,
      tr: 'Tatlı İsteği',
      en: 'Sweet cravings',
      icon: 'cookie',
      brightness: Brightness.dark,
      background: Color(0xFF29170F),
      surface: Color(0xFF4C2B1C),
      textPrimary: Color(0xFFFFF0DE),
      textSecondary: Color(0xFFD4BAA8),
      mint: Color(0xFFF0BA69),
      onAction: Color(0xFF29170F),
      dividerColor: Color(0xFFB59881),
    ),
    CheckInType.cantFocus: MoodPalette(
      mode: CheckInType.cantFocus,
      tr: 'Odaklanamıyorum',
      en: 'Trouble focusing',
      icon: 'focus',
      brightness: Brightness.dark,
      background: Color(0xFF101A35),
      surface: Color(0xFF233565),
      textPrimary: Color(0xFFF0F3FF),
      textSecondary: Color(0xFFBFC9E3),
      mint: Color(0xFFAEC4FF),
      onAction: Color(0xFF101A35),
      dividerColor: Color(0xFF8499CC),
    ),
    CheckInType.pms: MoodPalette(
      mode: CheckInType.pms,
      tr: 'PMS / Adet Öncesi',
      en: 'PMS / Before period',
      icon: 'calendarHeart',
      brightness: Brightness.dark,
      background: Color(0xFF281921),
      surface: Color(0xFF532D3A),
      textPrimary: Color(0xFFFFF0EC),
      textSecondary: Color(0xFFDFC4CF),
      mint: Color(0xFFFFD4C5),
      onAction: Color(0xFF281921),
      dividerColor: Color(0xFFC799AA),
    ),
    CheckInType.periodCramps: MoodPalette(
      mode: CheckInType.periodCramps,
      tr: 'Regl Krampları',
      en: 'Period cramps',
      icon: 'waves',
      brightness: Brightness.dark,
      background: Color(0xFF29170F),
      surface: Color(0xFF5B3022),
      textPrimary: Color(0xFFFFF0DF),
      textSecondary: Color(0xFFF4CDB5),
      mint: Color(0xFFFFD7A0),
      onAction: Color(0xFF29170F),
      dividerColor: Color(0xFFD7A991),
    ),
    CheckInType.periodFatigue: MoodPalette(
      mode: CheckInType.periodFatigue,
      tr: 'Regl Yorgunluğu',
      en: 'Period fatigue',
      icon: 'moonBattery',
      brightness: Brightness.dark,
      background: Color(0xFF211D30),
      surface: Color(0xFF39304C),
      textPrimary: Color(0xFFF2EFFA),
      textSecondary: Color(0xFFCEC5E1),
      mint: Color(0xFFE5D0FF),
      onAction: Color(0xFF211D30),
      dividerColor: Color(0xFFA99AC6),
    ),
    CheckInType.postWorkout: MoodPalette(
      mode: CheckInType.postWorkout,
      tr: 'Egzersiz Sonrası',
      en: 'After exercise',
      icon: 'dumbbell',
      brightness: Brightness.dark,
      background: Color(0xFF082F38),
      surface: Color(0xFF145564),
      textPrimary: Color(0xFFEEF9F6),
      textSecondary: Color(0xFFBEDBD9),
      mint: Color(0xFF89E0E1),
      onAction: Color(0xFF082F38),
      dividerColor: Color(0xFF86B6BA),
    ),
    CheckInType.noSpecificIssue: MoodPalette(
      mode: CheckInType.noSpecificIssue,
      tr: 'Belirli Bir Sorun Yok',
      en: 'Feeling balanced',
      icon: 'leaf',
      brightness: Brightness.dark,
      background: Color(0xFF093336),
      surface: Color(0xFF185348),
      textPrimary: Color(0xFFEDF8EE),
      textSecondary: Color(0xFFC0D9D4),
      mint: Color(0xFF9FE0BC),
      onAction: Color(0xFF093336),
      dividerColor: Color(0xFF92B9B0),
    ),
  };
  Color get primaryColor => background;
  Color get elevated => Color.lerp(surface, mint, .05)!;
  Color get cardDark => elevated;
  Color get moon => mint;
  Color get accentOrange => mint;
  Color get accentTeal => mint;
  Color get warmCoral => danger;
  Color get softLavender => mint;
  Color get successGreen => mint;
  Color get warningAmber => mint;
  Color get textLight => textSecondary;
  Color get breakfastColor => mint;
  Color get lunchColor => mint;
  Color get dinnerColor => mint;
  Color get snackColor => mint;
  Color get danger => brightness == Brightness.light
      ? const Color(0xFF9D2929)
      : const Color(0xFFFFB4A8);
  LinearGradient get headerGradient =>
      LinearGradient(colors: [background, surface]);
  LinearGradient get accentGradient =>
      LinearGradient(colors: [mint, Color.lerp(mint, surface, .12)!]);
  @override
  MoodPalette copyWith({
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? mint,
    Color? onAction,
    Color? dividerColor,
  }) => MoodPalette(
    mode: mode,
    tr: tr,
    en: en,
    icon: icon,
    brightness: brightness,
    background: background ?? this.background,
    surface: surface ?? this.surface,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    mint: mint ?? this.mint,
    onAction: onAction ?? this.onAction,
    dividerColor: dividerColor ?? this.dividerColor,
  );
  @override
  MoodPalette lerp(covariant MoodPalette? other, double t) {
    if (other == null) return this;
    return MoodPalette(
      mode: other.mode,
      tr: other.tr,
      en: other.en,
      icon: other.icon,
      brightness: other.brightness,
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      onAction: Color.lerp(onAction, other.onAction, t)!,
      dividerColor: Color.lerp(dividerColor, other.dividerColor, t)!,
    );
  }
}

extension MoodColors on BuildContext {
  MoodPalette get palette =>
      Theme.of(this).extension<MoodPalette>() ??
      MoodPalette.all[CheckInType.lowEnergy]!;
}
