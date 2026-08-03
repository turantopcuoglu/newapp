import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// The two reminders the app schedules, entirely on-device — no push
/// infrastructure, so this works with no backend.
enum ReminderKind {
  /// Morning nudge to record how you feel, which drives recommendations.
  checkIn,

  /// Late-afternoon nudge to cook with what's already in the pantry.
  dinnerIdea,
}

/// Schedules daily local reminders.
///
/// All methods are safe to call on platforms without notification support:
/// failures are swallowed so a missing plugin can never break startup.
class NotificationService {
  static const int _checkInId = 1001;
  static const int _dinnerId = 1002;

  static const _androidDetails = AndroidNotificationDetails(
    'daily_reminders',
    'Daily reminders',
    channelDescription: 'Check-in and dinner suggestion reminders',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
  );

  static const _details = NotificationDetails(
    android: _androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  NotificationService({FlutterLocalNotificationsPlugin? plugin})
      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  /// Prepares the plugin and timezone database. Returns false when the
  /// platform can't schedule notifications.
  Future<bool> init() async {
    if (_initialized) return true;
    try {
      tz_data.initializeTimeZones();
      const settings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          // Permission is requested explicitly via [requestPermissions] so
          // the prompt appears when the user opts in, not at first launch.
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      );
      await _plugin.initialize(settings: settings);
      _initialized = true;
      return true;
    } catch (e) {
      debugPrint('NotificationService: init failed ($e)');
      return false;
    }
  }

  /// Asks the OS for permission. Returns false when denied or unsupported.
  Future<bool> requestPermissions() async {
    try {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      if (ios != null) {
        return await ios.requestPermissions(alert: true, sound: true) ?? false;
      }
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android != null) {
        return await android.requestNotificationsPermission() ?? false;
      }
      return false;
    } catch (e) {
      debugPrint('NotificationService: permission request failed ($e)');
      return false;
    }
  }

  /// Schedules a daily reminder at [hour]:[minute] local time.
  Future<void> scheduleDaily({
    required ReminderKind kind,
    required String title,
    required String body,
    required int hour,
    int minute = 0,
  }) async {
    if (!await init()) return;
    try {
      await _plugin.zonedSchedule(
        id: _idFor(kind),
        title: title,
        body: body,
        scheduledDate: _nextOccurrence(hour, minute),
        notificationDetails: _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time, // repeat daily
      );
    } catch (e) {
      debugPrint('NotificationService: schedule failed ($e)');
    }
  }

  Future<void> cancel(ReminderKind kind) async {
    try {
      await _plugin.cancel(id: _idFor(kind));
    } catch (e) {
      debugPrint('NotificationService: cancel failed ($e)');
    }
  }

  Future<void> cancelAll() async {
    for (final kind in ReminderKind.values) {
      await cancel(kind);
    }
  }

  static int _idFor(ReminderKind kind) =>
      kind == ReminderKind.checkIn ? _checkInId : _dinnerId;

  /// The next time today's [hour]:[minute] occurs; tomorrow if already past.
  static tz.TZDateTime _nextOccurrence(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Exposed for testing the roll-over rule without a device.
  static DateTime nextOccurrenceFrom(DateTime now, int hour, int minute) {
    var scheduled =
        DateTime(now.year, now.month, now.day, hour, minute);
    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
