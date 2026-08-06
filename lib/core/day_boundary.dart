/// The app's "day" runs from 06:00 to 05:59 the next morning, so a late-night
/// meal still belongs to the day the user checked in for. Daily mode and the
/// consumed-calorie log share this definition — keep it in one place.
class DayBoundary {
  static const int resetHour = 6;

  /// The calendar date a moment belongs to, e.g. "2026-08-02".
  static String keyFor(DateTime dt) {
    final effective =
        dt.hour < resetHour ? dt.subtract(const Duration(days: 1)) : dt;
    return '${effective.year}-'
        '${effective.month.toString().padLeft(2, '0')}-'
        '${effective.day.toString().padLeft(2, '0')}';
  }

  /// Key for a calendar date that is already an app-day.
  ///
  /// [keyFor] shifts anything before 06:00 back a day, which is right for a
  /// timestamp but wrong for a date: `DateTime(2026, 8, 4)` is midnight, so
  /// passing it to [keyFor] would silently return 2026-08-03. Charts and
  /// day-by-day lists build their buckets from dates, so they use this.
  static String keyForDate(DateTime date) =>
      '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  /// A timestamp that lands inside the app-day of [date], for logging
  /// something on a day other than today.
  static DateTime middayOf(DateTime date) =>
      DateTime(date.year, date.month, date.day, 12);

  /// Key for the day that contains "now".
  static String today() => keyFor(DateTime.now());

  /// The calendar date of the app-day that contains "now", at midday.
  ///
  /// Ekranlar "bugün"ü buradan almalı. `DateTime.now()` gece yarısı ile
  /// 06:00 arasında bir sonraki takvim gününü gösterir; o saatlerde pişirilen
  /// öğün günün kovasına düşmez ve listede görünmez.
  static DateTime currentDay() {
    final now = DateTime.now();
    final effective =
        now.hour < resetHour ? now.subtract(const Duration(days: 1)) : now;
    return DateTime(effective.year, effective.month, effective.day, 12);
  }

  /// Whether two moments fall on the same app-day.
  static bool sameDay(DateTime a, DateTime b) => keyFor(a) == keyFor(b);
}
