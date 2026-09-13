import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_guide/models/wellness.dart';
import 'package:nutri_guide/models/user_profile.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/services/wellness_store.dart';
import 'package:nutri_guide/services/recommendation_service.dart';
import 'package:nutri_guide/services/private_storage.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:nutri_guide/services/preference_matcher.dart';
import 'package:nutri_guide/models/beverage_entry.dart';
import 'package:nutri_guide/core/enums.dart';

HealthInterval interval(String start, String end,
        {String source = 'ring', String kind = 'sleep'}) =>
    HealthInterval(
        id: '$source-$start',
        kind: kind,
        source: source,
        start: DateTime.parse(start),
        end: DateTime.parse(end));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('missing recipe ingredients cannot pass an allergy restriction', () {
    expect(recipeHasAllergenConflict(
        const Recipe(id: 'empty', name: {}, description: {}),
        const UserProfile(allergies: ['nuts'])), isTrue);
  });
  test('overlapping stages and duplicate sources never double sleep', () {
    final health = HealthSnapshot(
        syncedAt: DateTime(2026, 9, 7),
        platform: 'test',
        intervals: [
          interval('2026-09-06T23:00:00', '2026-09-07T02:00:00'),
          interval('2026-09-07T01:00:00', '2026-09-07T07:00:00'),
          interval('2026-09-06T23:00:00', '2026-09-07T07:00:00',
              source: 'watch'),
        ]);
    expect(health.minutesFor('sleep', DateTime(2026, 9, 7)), 480);
    expect(
        health.minutesFor('sleep', DateTime(2026, 9, 7),
            preferredSource: 'watch'),
        480);
    expect(health.minutesFor('sleep', DateTime(2026, 9, 6)), isNull);
  });
  test('stages before midnight are assigned to the same wake-up day', () {
    final health = HealthSnapshot(
        syncedAt: DateTime(2026, 9, 7),
        platform: 'test',
        intervals: [
          interval('2026-09-06T22:00:00', '2026-09-06T23:50:00'),
          interval('2026-09-07T00:10:00', '2026-09-07T06:00:00'),
        ]);
    expect(health.minutesFor('sleep', DateTime(2026, 9, 7)), 460);
  });
  test('missing measurement remains null and workouts clip at midnight', () {
    final health = HealthSnapshot(
        syncedAt: DateTime(2026, 9, 7),
        platform: 'test',
        intervals: [
          interval('2026-09-06T23:50:00', '2026-09-07T00:20:00',
              kind: 'workout'),
        ]);
    expect(health.minutesFor('workout', DateTime(2026, 9, 7)), 20);
    expect(health.minutesFor('sleep', DateTime(2026, 9, 7)), isNull);
    expect(health.steps['2026-09-07'], isNull);
  });
  test('check-in day rolls over at 06:00; past days survive updates', () async {
    final store = MemoryWellnessStore();
    final notifier = WellnessNotifier(store);
    addTearDown(notifier.dispose);
    await notifier
        .checkIn(DailyCheckIn(recordedAt: DateTime(2026, 9, 7, 5), energy: 1));
    await notifier
        .checkIn(DailyCheckIn(recordedAt: DateTime(2026, 9, 7, 7), energy: 2));
    await notifier
        .checkIn(DailyCheckIn(recordedAt: DateTime(2026, 9, 7, 9), energy: 3));
    expect(store.initial.checkIns.length, 2);
    expect(store.initial.checkInFor(DateTime(2026, 9, 7, 5))!.energy, 1);
    expect(store.initial.checkInFor(DateTime(2026, 9, 7, 12))!.energy, 3);
  });
  test('concurrent writes preserve both actions', () async {
    final store = MemoryWellnessStore();
    final notifier = WellnessNotifier(store);
    addTearDown(notifier.dispose);
    await Future.wait([
      notifier.logRoutine('breathe', 120),
      notifier.logRoutine('walk', 600),
    ]);
    expect(store.initial.routines.map((r) => r.id), ['breathe', 'walk']);
  });
  test(
      'failed persistence does not report successful state, next action can retry',
      () async {
    final store = _FailingStore();
    final notifier = WellnessNotifier(store);
    addTearDown(notifier.dispose);
    await expectLater(notifier.logRoutine('breathe', 120), throwsStateError);
    expect(notifier.state.routines, isEmpty);
    store.fail = false;
    await notifier.logRoutine('breathe', 120);
    expect(notifier.state.routines.length, 1);
  });
  test('encrypted records survive restart; tampering does not silently reset',
      () async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final store = await EncryptedWellnessStore.open(prefs);
    await store.save(WellnessData(checkIns: [
      DailyCheckIn(recordedAt: DateTime(2026, 9, 7, 12), mood: 1)
    ]));
    final encrypted = prefs.getString(EncryptedWellnessStore.snapshotKey)!;
    expect(encrypted, isNot(contains('checkIns')));
    expect(
        (await EncryptedWellnessStore.open(prefs)).initial.checkIns.single.mood,
        1);
    await prefs.setString(
        EncryptedWellnessStore.snapshotKey, 'not-valid-encrypted-data');
    await expectLater(EncryptedWellnessStore.open(prefs), throwsA(anything));
  });
  test('legacy profile keeps allergy data and intolerance is separate', () {
    final legacy = UserProfile.fromJson({
      'allergies': ['dairy']
    });
    expect(legacy.allergies, ['dairy']);
    expect(legacy.intolerances, isEmpty);
    final profile = legacy.copyWith(intolerances: ['lactose']);
    final service = RecommendationService();
    const dairy = Recipe(
        id: 'milk',
        name: {'tr': 'Süt'},
        description: {},
        allergenTags: ['dairy']);
    expect(
        service.getAllSafeRecipes(
            allRecipes: [dairy], profile: profile, inventoryIds: {}),
        isEmpty);
    expect(
        service.getAllSafeRecipes(
            allRecipes: [dairy],
            profile: const UserProfile(intolerances: ['lactose']),
            inventoryIds: {}),
        isEmpty);
  });
  test('removing imported health data preserves manual journals', () {
    final data = WellnessData(
        checkIns: [DailyCheckIn(recordedAt: DateTime(2026, 9, 7), mood: 2)],
        healthEnabled: true,
        health:
            HealthSnapshot(syncedAt: DateTime(2026, 9, 7), platform: 'test'));
    final disconnected = data.copyWith(clearHealth: true, healthEnabled: false);
    expect(disconnected.checkIns.length, 1);
    expect(disconnected.health, isNull);
    expect(WellnessData.fromJson(disconnected.toJson()).healthEnabled, isFalse);
  });
  test(
      'private migration preserves existing data and concurrent legacy appends',
      () async {
    SharedPreferences.setMockInitialValues({
      'user_profile': '{"allergies":["dairy"]}',
      'today_check_in': 'lowEnergy'
    });
    FlutterSecureStorage.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final vault = await PrivateStorage.open(prefs);
    final storage = StorageService(prefs, privateData: vault);
    expect(prefs.getString('user_profile'), isNull);
    expect(storage.getProfile()!.allergies, ['dairy']);
    final now = DateTime.now();
    await Future.wait([
      storage.addBeverage(BeverageEntry(
          id: 'a', type: BeverageType.water, milliliters: 250, dateTime: now)),
      storage.addBeverage(BeverageEntry(
          id: 'b', type: BeverageType.water, milliliters: 250, dateTime: now))
    ]);
    final reopened =
        StorageService(prefs, privateData: await PrivateStorage.open(prefs));
    expect(reopened.getBeverages().length, 2);
    expect(prefs.getString('beverages'), isNull);
  });
}

class _FailingStore extends MemoryWellnessStore {
  bool fail = true;
  @override
  Future<void> save(WellnessData data) async {
    if (fail) throw StateError('disk unavailable');
    await super.save(data);
  }
}
