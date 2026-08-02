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

  /// Key for the day that contains "now".
  static String today() => keyFor(DateTime.now());

  /// Whether two moments fall on the same app-day.
  static bool sameDay(DateTime a, DateTime b) => keyFor(a) == keyFor(b);
}
