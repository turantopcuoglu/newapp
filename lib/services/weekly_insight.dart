import '../models/wellness.dart';

/// What the weekly card may say. Every number comes from the user's own
/// records; the sentence states how often two things happened together and
/// never why ("çünkü" yok). Below [WeeklyInsight.minEvenings] evening answers
/// there is no claim at all, only how many more days are needed.
enum InsightKind { notEnough, cooked, breaks, evenings }

class WeeklyInsight {
  static const int minEvenings = 4;

  final InsightKind kind;

  /// Evening answers with an energy level in the window.
  final int recorded;

  /// Days in the compared group, and how many of them had a medium or high
  /// evening energy.
  final int days, good;

  /// The rest of the recorded evenings, for the contrast sentence.
  final int otherDays, otherGood;

  const WeeklyInsight({
    required this.kind,
    required this.recorded,
    this.days = 0,
    this.good = 0,
    this.otherDays = 0,
    this.otherGood = 0,
  });

  /// [dayKeys] are the app-days of the window (`DayBoundary.keyForDate`);
  /// [cookedDays] and [breakDays] are app-days with at least one cooked meal
  /// or completed break.
  factory WeeklyInsight.from({
    required Iterable<String> dayKeys,
    required List<EveningCheckIn> evenings,
    required Set<String> cookedDays,
    required Set<String> breakDays,
  }) {
    final window = dayKeys.toSet();
    final energy = <String, int>{
      for (final e in evenings)
        if (e.energy != null && window.contains(e.dayKey)) e.dayKey: e.energy!,
    };
    final recorded = energy.keys.toSet();
    if (recorded.length < minEvenings) {
      return WeeklyInsight(
        kind: InsightKind.notEnough,
        recorded: recorded.length,
      );
    }
    int goodIn(Iterable<String> keys) =>
        keys.where((k) => energy[k]! >= 2).length;
    WeeklyInsight compare(InsightKind kind, Set<String> marked) {
      final group = recorded.intersection(marked);
      final rest = recorded.difference(marked);
      return WeeklyInsight(
        kind: kind,
        recorded: recorded.length,
        days: group.length,
        good: goodIn(group),
        otherDays: rest.length,
        otherGood: goodIn(rest),
      );
    }

    // Cooking is the app's own loop, so it is the first thing compared; a
    // comparison needs at least two days on the marked side.
    if (recorded.intersection(cookedDays).length >= 2) {
      return compare(InsightKind.cooked, cookedDays);
    }
    if (recorded.intersection(breakDays).length >= 2) {
      return compare(InsightKind.breaks, breakDays);
    }
    return WeeklyInsight(
      kind: InsightKind.evenings,
      recorded: recorded.length,
      days: recorded.length,
      good: goodIn(recorded),
    );
  }

  String text(String locale) => locale == 'tr' ? _turkish() : _english();

  String _turkish() {
    switch (kind) {
      case InsightKind.notEnough:
        return 'Akşam kaydın $recorded/$minEvenings gün. Birkaç gün daha '
            'kayıt tutunca burada haftana dair bir gözlem göreceksin.';
      case InsightKind.cooked:
        return '${_trShare('Pişirdiğin $days günün', good)} akşam enerjin '
            '${_trLevel(good)}.'
            '${otherDays == 0 ? '' : ' Pişirmediğin $otherDays günde bu sayı $otherGood.'}';
      case InsightKind.breaks:
        return '${_trShare('Mola verdiğin $days günün', good)} akşam enerjin '
            '${_trLevel(good)}.'
            '${otherDays == 0 ? '' : ' Mola vermediğin $otherDays günde bu sayı $otherGood.'}';
      case InsightKind.evenings:
        return '${_trShare('Kayıt tuttuğun $days akşamın', good)} enerjin '
            '${_trLevel(good)}.';
    }
  }

  /// "3 günün 2'sinde", "hepsinde", "hiçbirinde".
  String _trShare(String whole, int part) => part == 0
      ? '$whole hiçbirinde'
      : part == days
      ? '$whole hepsinde'
      : '$whole $part${trLocativeSuffix(part)}';

  String _trLevel(int part) =>
      part == 0 ? 'orta ya da yüksek değildi' : 'orta ya da yüksekti';

  String _english() {
    switch (kind) {
      case InsightKind.notEnough:
        return '$recorded of $minEvenings evenings recorded. A few more days '
            'and you will see an observation about your week here.';
      case InsightKind.cooked:
        return 'On $good of the $days days you cooked, your evening energy '
            'was medium or high.'
            '${otherDays == 0 ? '' : ' On the $otherDays days you did not: $otherGood.'}';
      case InsightKind.breaks:
        return 'On $good of the $days days you took a break, your evening '
            'energy was medium or high.'
            '${otherDays == 0 ? '' : ' On the $otherDays days you did not: $otherGood.'}';
      case InsightKind.evenings:
        return 'On $good of the $days evenings you recorded, your energy was '
            'medium or high.';
    }
  }
}

/// Possessive + locative suffix for a number written in digits:
/// 1'inde, 2'sinde, 3'ünde, 6'sında, 10'unda. Follows the last spoken word.
String trLocativeSuffix(int n) {
  const ones = {
    1: "'inde",
    2: "'sinde",
    3: "'ünde",
    4: "'ünde",
    5: "'inde",
    6: "'sında",
    7: "'sinde",
    8: "'inde",
    9: "'unda",
  };
  const tens = {
    10: "'unda",
    20: "'sinde",
    30: "'unda",
    40: "'ında",
    50: "'sinde",
    60: "'ında",
    70: "'inde",
    80: "'inde",
    90: "'ında",
  };
  if (n == 0) return "'ında";
  final last = n % 10;
  if (last != 0) return ones[last]!;
  // Larger round numbers end in yüz/bin; a week never gets there.
  return tens[n % 100] ?? (n % 1000 == 0 ? "'inde" : "'ünde");
}
