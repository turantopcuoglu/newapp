import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import '../models/wellness.dart';

class HealthUnavailable implements Exception {}

class HealthConnectionService {
  final Health health;
  HealthConnectionService({Health? client}) : health = client ?? Health();
  bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);
  bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  String get platformName => isAndroid ? 'Health Connect' : 'Apple Health';
  List<HealthDataType> typesFor(String scope) => switch (scope) {
    'steps' => [HealthDataType.STEPS],
    'workout' => [HealthDataType.WORKOUT],
    'sleep' => [
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.SLEEP_LIGHT,
      HealthDataType.SLEEP_DEEP,
      HealthDataType.SLEEP_REM,
    ],
    _ => [],
  };
  Future<void> prepare() async {
    if (!supported) throw HealthUnavailable();
    await health.configure();
    if (isAndroid &&
        await health.getHealthConnectSdkStatus() !=
            HealthConnectSdkStatus.sdkAvailable) {
      throw HealthUnavailable();
    }
  }

  Future<void> authorize(List<String> scopes) async {
    await prepare();
    final types = scopes.expand(typesFor).toSet().toList();
    if (types.isEmpty) return;
    // iOS does not disclose which read permissions were granted. Read results
    // below are the source of truth; an authorization prompt is not a connection.
    await health.requestAuthorization(
      types,
      permissions: List.filled(types.length, HealthDataAccess.READ),
    );
  }

  Future<HealthSnapshot> read(List<String> scopes, {DateTime? now}) async {
    await prepare();
    final end = now ?? DateTime.now();
    final start = DateTime(
      end.year,
      end.month,
      end.day,
    ).subtract(const Duration(days: 7));
    final intervals = <HealthInterval>[];
    final steps = <String, int>{};
    final unavailable = <String>[];
    for (final scope in scopes) {
      try {
        final types = typesFor(scope);
        if (types.isEmpty) continue;
        if (isAndroid &&
            await health.hasPermissions(
                  types,
                  permissions: List.filled(types.length, HealthDataAccess.READ),
                ) !=
                true) {
          unavailable.add(scope);
          continue;
        }
        final points = await health.getHealthDataFromTypes(
          types: types,
          startTime: start,
          endTime: end,
        );
        if (scope == 'steps') {
          // Only dates with records are aggregated: denied/no-data is not zero.
          final dates = points
              .map((p) => calendarDay(p.dateFrom.toLocal()))
              .toSet();
          for (final date in dates) {
            final day = DateTime.parse(date);
            final next = DateTime(day.year, day.month, day.day + 1);
            final total = await health.getTotalStepsInInterval(
              day,
              next.isAfter(end) ? end : next,
            );
            if (total != null) steps[date] = total;
          }
        } else {
          for (final p in health.removeDuplicates(points)) {
            if (!p.dateTo.isAfter(p.dateFrom)) continue;
            intervals.add(
              HealthInterval(
                id: p.uuid,
                kind: scope,
                source: '${p.sourceName} · ${p.sourceId}',
                start: p.dateFrom.toUtc(),
                end: p.dateTo.toUtc(),
              ),
            );
          }
        }
      } catch (_) {
        // Keep successful scopes. Never invent successful zero-valued reads.
        unavailable.add(scope);
      }
    }
    if (scopes.isNotEmpty && unavailable.length == scopes.length) {
      throw StateError('No requested health scope could be read');
    }
    return HealthSnapshot(
      syncedAt: end,
      platform: platformName,
      steps: steps,
      intervals: intervals,
      unavailable: unavailable,
    );
  }

  Future<void> revoke() async {
    if (supported && isAndroid) await health.revokePermissions();
    // On iOS, the user manages system permissions in Apple Health.
  }
}
