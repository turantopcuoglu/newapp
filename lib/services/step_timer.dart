/// A wait a recipe step names: "12-15 dakika", "45 saniye", "1 hour".
/// Read from the step text at runtime — the step already says it, so the
/// JSON does not repeat it.
class StepDuration {
  final int from;

  /// Upper end of a range ("12-15"); null for a single value.
  final int? to;
  final StepTimeUnit unit;

  const StepDuration(this.from, this.unit, {this.to});

  /// The timer counts the short end; the cook checks from there, as the
  /// step itself tells them to.
  Duration get duration => switch (unit) {
    StepTimeUnit.second => Duration(seconds: from),
    StepTimeUnit.minute => Duration(minutes: from),
    StepTimeUnit.hour => Duration(hours: from),
  };

  bool get isRange => to != null;

  @override
  bool operator ==(Object other) =>
      other is StepDuration &&
      other.from == from &&
      other.to == to &&
      other.unit == unit;

  @override
  int get hashCode => Object.hash(from, to, unit);

  @override
  String toString() => 'StepDuration($from${to == null ? '' : '-$to'} $unit)';
}

enum StepTimeUnit { second, minute, hour }

final _pattern = RegExp(
  r'(\d+)(?:\s*[-–]\s*(\d+))?[\s-]*(?:more\s+)?'
  r'(saniye|sn\b|dakika|dk\b|saat|seconds?\b|secs?\b|minutes?\b|mins?\b|hours?\b|hrs?\b)',
  caseSensitive: false,
);

/// Longer than a working session is a soak or an overnight rest, not a
/// timer anyone keeps a screen open for.
const _longest = Duration(hours: 12);

/// Every wait the step names, in reading order.
List<StepDuration> parseStepDurations(String step) => [
  for (final m in _pattern.allMatches(step))
    if (_build(m) case final d? when d.duration > Duration.zero) d,
];

StepDuration? _build(RegExpMatch m) {
  final from = int.parse(m.group(1)!);
  final to = m.group(2) == null ? null : int.parse(m.group(2)!);
  final word = m.group(3)!.toLowerCase();
  final unit = switch (word) {
    'saniye' || 'sn' => StepTimeUnit.second,
    'saat' => StepTimeUnit.hour,
    _ when word.startsWith('sec') => StepTimeUnit.second,
    _ when word.startsWith('h') => StepTimeUnit.hour,
    _ => StepTimeUnit.minute,
  };
  final d = StepDuration(from, unit, to: (to != null && to > from) ? to : null);
  return d.duration > _longest ? null : d;
}
