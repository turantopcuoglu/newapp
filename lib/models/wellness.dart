import '../core/day_boundary.dart';
import '../core/enums.dart';

String calendarDay(DateTime time) => DayBoundary.keyForDate(time);

class DailyCheckIn {
  final DateTime recordedAt;
  final int? mood;
  final int? energy;
  final int? sleepQuality;
  final int? stress;
  final int? prepMinutes;
  final CheckInType? focus;

  const DailyCheckIn({
    required this.recordedAt,
    this.mood,
    this.energy,
    this.sleepQuality,
    this.stress,
    this.prepMinutes,
    this.focus,
  });
  String get dayKey => DayBoundary.keyFor(recordedAt);
  Map<String, dynamic> toJson() => {
    'at': recordedAt.toIso8601String(),
    'mood': mood,
    'energy': energy,
    'sleep': sleepQuality,
    'stress': stress,
    'prep': prepMinutes,
    'focus': focus?.name,
  };
  factory DailyCheckIn.fromJson(Map<String, dynamic> j) => DailyCheckIn(
    recordedAt: DateTime.parse(j['at'] as String),
    mood: j['mood'] as int?,
    energy: j['energy'] as int?,
    sleepQuality: j['sleep'] as int?,
    stress: j['stress'] as int?,
    prepMinutes: j['prep'] as int?,
    focus: CheckInType.values.where((v) => v.name == j['focus']).firstOrNull,
  );
}

/// How the day went, answered in the evening on the same 1–3 scales as the
/// morning check-in. A separate record, not extra fields on [DailyCheckIn]:
/// the evening answer must never overwrite the morning one, and the history
/// shows the two measurements side by side.
class EveningCheckIn {
  final DateTime recordedAt;
  final int? energy;
  final int? mood;
  final String? note;

  const EveningCheckIn({
    required this.recordedAt,
    this.energy,
    this.mood,
    this.note,
  });

  /// App-day, so an answer at 00:30 still closes the day before.
  String get dayKey => DayBoundary.keyFor(recordedAt);

  Map<String, dynamic> toJson() => {
    'at': recordedAt.toIso8601String(),
    'energy': energy,
    'mood': mood,
    'note': note,
  };
  factory EveningCheckIn.fromJson(Map<String, dynamic> j) => EveningCheckIn(
    recordedAt: DateTime.parse(j['at'] as String),
    energy: j['energy'] as int?,
    mood: j['mood'] as int?,
    note: j['note'] as String?,
  );
}

class RoutineLog {
  final String id;
  final DateTime at;
  final int seconds;
  const RoutineLog({required this.id, required this.at, required this.seconds});
  String get dayKey => DayBoundary.keyFor(at);
  Map<String, dynamic> toJson() => {
    'id': id,
    'at': at.toIso8601String(),
    'seconds': seconds,
  };
  factory RoutineLog.fromJson(Map<String, dynamic> j) => RoutineLog(
    id: j['id'] as String,
    at: DateTime.parse(j['at'] as String),
    seconds: j['seconds'] as int,
  );
}

class SleepLog {
  final DateTime start;
  final DateTime end;
  const SleepLog({required this.start, required this.end});
  int get minutes => end.difference(start).inMinutes;
  String get dayKey => calendarDay(end);
  Map<String, dynamic> toJson() => {
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
  };
  factory SleepLog.fromJson(Map<String, dynamic> j) => SleepLog(
    start: DateTime.parse(j['start'] as String),
    end: DateTime.parse(j['end'] as String),
  );
}

/// Source records stay distinct. Sleep/workout intervals are unioned only
/// within the selected source, never summed across competing devices.
class HealthInterval {
  final String id;
  final String kind;
  final String source;
  final DateTime start;
  final DateTime end;
  const HealthInterval({
    required this.id,
    required this.kind,
    required this.source,
    required this.start,
    required this.end,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'kind': kind,
    'source': source,
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
  };
  factory HealthInterval.fromJson(Map<String, dynamic> j) => HealthInterval(
    id: j['id'] as String,
    kind: j['kind'] as String,
    source: j['source'] as String,
    start: DateTime.parse(j['start'] as String),
    end: DateTime.parse(j['end'] as String),
  );
}

class HealthSnapshot {
  final DateTime syncedAt;
  final String platform;
  final Map<String, int> steps;
  final List<HealthInterval> intervals;
  final List<String> unavailable;
  const HealthSnapshot({
    required this.syncedAt,
    required this.platform,
    this.steps = const {},
    this.intervals = const [],
    this.unavailable = const [],
  });
  List<String> sources(String kind) =>
      intervals
          .where((e) => e.kind == kind)
          .map((e) => e.source)
          .toSet()
          .toList()
        ..sort();
  String? sourceFor(String kind, String? preferred) {
    final available = sources(kind);
    if (available.contains(preferred)) return preferred;
    return available.firstOrNull;
  }

  int? minutesFor(String kind, DateTime day, {String? preferredSource}) {
    final source = sourceFor(kind, preferredSource);
    final key = calendarDay(day);
    final records =
        intervals
            .where(
              (e) =>
                  e.kind == kind &&
                  e.source == source &&
                  e.end.isAfter(e.start),
            )
            .toList()
          ..sort((a, b) => a.start.compareTo(b.start));
    if (records.isEmpty) return null;
    if (kind != 'sleep') {
      final start = DateTime(day.year, day.month, day.day);
      final end = DateTime(day.year, day.month, day.day + 1);
      final clipped = records
          .where((r) => r.end.isAfter(start) && r.start.isBefore(end))
          .map(
            (r) => HealthInterval(
              id: r.id,
              kind: r.kind,
              source: r.source,
              start: r.start.isBefore(start) ? start : r.start,
              end: r.end.isAfter(end) ? end : r.end,
            ),
          )
          .toList();
      return clipped.isEmpty ? null : unionMinutes(clipped);
    }
    // Stage records lack a common session ID on some sources. Group nearby
    // stages into one sleep episode before assigning its wake-up calendar day.
    // Gaps remain excluded from the actual asleep duration.
    final episodes = <List<HealthInterval>>[];
    var episode = <HealthInterval>[];
    DateTime? episodeEnd;
    for (final record in records) {
      if (episodeEnd != null &&
          record.start.difference(episodeEnd) > const Duration(minutes: 90)) {
        episodes.add(episode);
        episode = [];
      }
      episode.add(record);
      if (episodeEnd == null || record.end.isAfter(episodeEnd)) {
        episodeEnd = record.end;
      }
    }
    if (episode.isNotEmpty) episodes.add(episode);
    final matching = episodes
        .where(
          (items) =>
              calendarDay(
                items
                    .map((r) => r.end)
                    .reduce((a, b) => a.isAfter(b) ? a : b)
                    .toLocal(),
              ) ==
              key,
        )
        .toList();
    return matching.isEmpty
        ? null
        : matching.fold<int>(0, (sum, items) => sum + unionMinutes(items));
  }

  Map<String, dynamic> toJson() => {
    'at': syncedAt.toIso8601String(),
    'platform': platform,
    'steps': steps,
    'intervals': intervals.map((v) => v.toJson()).toList(),
    'unavailable': unavailable,
  };
  factory HealthSnapshot.fromJson(Map<String, dynamic> j) => HealthSnapshot(
    syncedAt: DateTime.parse(j['at'] as String),
    platform: j['platform'] as String,
    steps: Map<String, int>.from(j['steps'] as Map),
    intervals: (j['intervals'] as List)
        .map(
          (e) => HealthInterval.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList(),
    unavailable: List<String>.from(j['unavailable'] as List? ?? []),
  );
}

int unionMinutes(List<HealthInterval> intervals) {
  final sorted = intervals.where((e) => e.end.isAfter(e.start)).toList()
    ..sort((a, b) => a.start.compareTo(b.start));
  if (sorted.isEmpty) return 0;
  var start = sorted.first.start;
  var end = sorted.first.end;
  var total = Duration.zero;
  for (final item in sorted.skip(1)) {
    if (!item.start.isAfter(end)) {
      if (item.end.isAfter(end)) end = item.end;
    } else {
      total += end.difference(start);
      start = item.start;
      end = item.end;
    }
  }
  return (total + end.difference(start)).inMinutes;
}

class WellnessData {
  final String? themeMode;
  final bool appearanceLocked;
  final String? contextPromptDay;
  final List<DailyCheckIn> checkIns;
  final List<EveningCheckIn> evenings;
  final List<RoutineLog> routines;
  final List<SleepLog> sleep;
  final Map<String, List<String>> eveningChecks;
  final List<String> goals;
  final List<String> habits;
  final Map<String, List<String>> habitChecks;
  final bool setupDone;
  final int? bedtimeMinutes;
  final bool healthEnabled;
  final List<String> healthScopes;
  final HealthSnapshot? health;
  final String? sleepSource;
  final String? workoutSource;
  const WellnessData({
    this.themeMode,
    this.appearanceLocked = false,
    this.contextPromptDay,
    this.checkIns = const [],
    this.evenings = const [],
    this.routines = const [],
    this.sleep = const [],
    this.eveningChecks = const {},
    this.goals = const ['nutrition', 'sleep', 'movement'],
    this.habits = const [],
    this.habitChecks = const {},
    this.setupDone = false,
    this.bedtimeMinutes,
    this.healthEnabled = false,
    this.healthScopes = const ['sleep', 'steps', 'workout'],
    this.health,
    this.sleepSource,
    this.workoutSource,
  });

  DailyCheckIn? checkInFor(DateTime time) =>
      checkIns.where((c) => c.dayKey == DayBoundary.keyFor(time)).lastOrNull;
  EveningCheckIn? eveningFor(DateTime time) =>
      evenings.where((e) => e.dayKey == DayBoundary.keyFor(time)).lastOrNull;
  int? manualSleepMinutes(DateTime day) =>
      sleep.where((s) => s.dayKey == calendarDay(day)).lastOrNull?.minutes;
  WellnessData copyWith({
    String? themeMode,
    bool? appearanceLocked,
    String? contextPromptDay,
    List<DailyCheckIn>? checkIns,
    List<EveningCheckIn>? evenings,
    List<RoutineLog>? routines,
    List<SleepLog>? sleep,
    Map<String, List<String>>? eveningChecks,
    List<String>? goals,
    List<String>? habits,
    Map<String, List<String>>? habitChecks,
    bool? setupDone,
    int? bedtimeMinutes,
    bool? healthEnabled,
    List<String>? healthScopes,
    HealthSnapshot? health,
    bool clearHealth = false,
    String? sleepSource,
    String? workoutSource,
  }) => WellnessData(
    themeMode: themeMode ?? this.themeMode,
    appearanceLocked: appearanceLocked ?? this.appearanceLocked,
    contextPromptDay: contextPromptDay ?? this.contextPromptDay,
    checkIns: checkIns ?? this.checkIns,
    evenings: evenings ?? this.evenings,
    routines: routines ?? this.routines,
    sleep: sleep ?? this.sleep,
    eveningChecks: eveningChecks ?? this.eveningChecks,
    goals: goals ?? this.goals,
    habits: habits ?? this.habits,
    habitChecks: habitChecks ?? this.habitChecks,
    setupDone: setupDone ?? this.setupDone,
    bedtimeMinutes: bedtimeMinutes ?? this.bedtimeMinutes,
    healthEnabled: healthEnabled ?? this.healthEnabled,
    healthScopes: healthScopes ?? this.healthScopes,
    health: clearHealth ? null : health ?? this.health,
    sleepSource: clearHealth ? null : sleepSource ?? this.sleepSource,
    workoutSource: clearHealth ? null : workoutSource ?? this.workoutSource,
  );
  Map<String, dynamic> toJson() => {
    'version': 1,
    'themeMode': themeMode,
    'appearanceLocked': appearanceLocked,
    'contextPromptDay': contextPromptDay,
    'checkIns': checkIns.map((v) => v.toJson()).toList(),
    'evenings': evenings.map((v) => v.toJson()).toList(),
    'routines': routines.map((v) => v.toJson()).toList(),
    'sleep': sleep.map((v) => v.toJson()).toList(),
    'eveningChecks': eveningChecks,
    'goals': goals,
    'habits': habits,
    'habitChecks': habitChecks,
    'setupDone': setupDone,
    'bedtimeMinutes': bedtimeMinutes,
    'healthEnabled': healthEnabled,
    'healthScopes': healthScopes,
    'health': health?.toJson(),
    'sleepSource': sleepSource,
    'workoutSource': workoutSource,
  };
  factory WellnessData.fromJson(Map<String, dynamic> j) {
    if (j['version'] != 1) {
      throw const FormatException('Unsupported wellness schema');
    }
    Map<String, List<String>> checks(String key) => (j[key] as Map? ?? {}).map(
      (k, v) => MapEntry(k as String, List<String>.from(v as List)),
    );
    return WellnessData(
      themeMode: j['themeMode'] as String?,
      appearanceLocked: j['appearanceLocked'] == true,
      contextPromptDay: j['contextPromptDay'] as String?,
      checkIns: (j['checkIns'] as List? ?? [])
          .map(
            (e) => DailyCheckIn.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      // Added after schema version 1 shipped; older snapshots have none.
      evenings: (j['evenings'] as List? ?? [])
          .map(
            (e) => EveningCheckIn.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList(),
      routines: (j['routines'] as List? ?? [])
          .map((e) => RoutineLog.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      sleep: (j['sleep'] as List? ?? [])
          .map((e) => SleepLog.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      eveningChecks: checks('eveningChecks'),
      habitChecks: checks('habitChecks'),
      goals: List<String>.from(j['goals'] as List? ?? []),
      habits: List<String>.from(j['habits'] as List? ?? []),
      setupDone: j['setupDone'] == true,
      bedtimeMinutes: j['bedtimeMinutes'] as int?,
      healthEnabled: j['healthEnabled'] == true,
      healthScopes: List<String>.from(j['healthScopes'] as List? ?? []),
      health: j['health'] == null
          ? null
          : HealthSnapshot.fromJson(
              Map<String, dynamic>.from(j['health'] as Map),
            ),
      sleepSource: j['sleepSource'] as String?,
      workoutSource: j['workoutSource'] as String?,
    );
  }
}
