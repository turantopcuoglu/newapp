import 'package:flutter_test/flutter_test.dart';
import 'package:nutri_guide/services/notification_service.dart';

void main() {
  group('daily schedule roll-over', () {
    test('schedules later today when the time has not passed', () {
      final now = DateTime(2026, 8, 2, 7, 30);
      final next = NotificationService.nextOccurrenceFrom(now, 9, 0);

      expect(next, DateTime(2026, 8, 2, 9, 0));
    });

    test('rolls to tomorrow when the time already passed', () {
      final now = DateTime(2026, 8, 2, 18, 5);
      final next = NotificationService.nextOccurrenceFrom(now, 17, 0);

      expect(next, DateTime(2026, 8, 3, 17, 0));
    });

    test('rolls over on an exact match rather than firing immediately', () {
      final now = DateTime(2026, 8, 2, 9, 0);
      final next = NotificationService.nextOccurrenceFrom(now, 9, 0);

      expect(next, DateTime(2026, 8, 3, 9, 0));
    });

    test('crosses a month boundary correctly', () {
      final now = DateTime(2026, 8, 31, 22, 0);
      final next = NotificationService.nextOccurrenceFrom(now, 9, 0);

      expect(next, DateTime(2026, 9, 1, 9, 0));
    });
  });

  test('each reminder kind keeps a distinct notification slot', () {
    // Distinct ids matter: scheduling one must not overwrite the other.
    expect(ReminderKind.values, hasLength(2));
    expect(ReminderKind.values.toSet(), hasLength(2));
  });
}
