import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/core/theme.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/l10n/app_localizations.dart';
import 'package:nutri_guide/models/wellness.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/screens/wellness/progress_screen.dart';
import 'package:nutri_guide/screens/wellness/today_screen.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:nutri_guide/services/weekly_insight.dart';
import 'package:nutri_guide/services/wellness_store.dart';

EveningCheckIn evening(String day, int energy, {int hour = 21}) =>
    EveningCheckIn(
      recordedAt: DateTime.parse(day).add(Duration(hours: hour)),
      energy: energy,
    );

void main() {
  const week = [
    '2026-10-02',
    '2026-10-03',
    '2026-10-04',
    '2026-10-05',
    '2026-10-06',
    '2026-10-07',
    '2026-10-08',
  ];

  group('weekly insight', () {
    test('makes no claim below four evenings', () {
      final insight = WeeklyInsight.from(
        dayKeys: week,
        evenings: [
          evening('2026-10-06', 3),
          evening('2026-10-07', 3),
          evening('2026-10-08', 3),
        ],
        cookedDays: week.toSet(),
        breakDays: const {},
      );
      expect(insight.kind, InsightKind.notEnough);
      expect(insight.text('tr'), contains('3/4'));
    });

    test('compares cooked days with the rest, counting only records', () {
      final insight = WeeklyInsight.from(
        dayKeys: week,
        evenings: [
          evening('2026-10-02', 3),
          evening('2026-10-03', 2),
          evening('2026-10-04', 1),
          evening('2026-10-05', 1),
          evening('2026-10-06', 2),
          // Outside the window: ignored.
          evening('2026-09-20', 3),
        ],
        cookedDays: {'2026-10-02', '2026-10-03', '2026-10-04', '2026-09-20'},
        breakDays: const {},
      );
      expect(insight.kind, InsightKind.cooked);
      expect(
        insight.text('tr'),
        "Pişirdiğin 3 günün 2'sinde akşam enerjin orta ya da yüksekti. "
        'Pişirmediğin 2 günde bu sayı 1.',
      );
      expect(
        insight.text('en'),
        'On 2 of the 3 days you cooked, your evening energy was medium or '
        'high. On the 2 days you did not: 1.',
      );
    });

    test('falls back to breaks, then to the evenings themselves', () {
      final evenings = [for (final day in week.take(4)) evening(day, 1)];
      final breaks = WeeklyInsight.from(
        dayKeys: week,
        evenings: evenings,
        cookedDays: const {},
        breakDays: {week[0], week[1]},
      );
      expect(breaks.kind, InsightKind.breaks);
      expect(breaks.text('tr'), startsWith('Mola verdiğin 2 günün hiçbirinde'));

      final plain = WeeklyInsight.from(
        dayKeys: week,
        evenings: [for (final day in week.take(4)) evening(day, 3)],
        cookedDays: const {},
        breakDays: const {},
      );
      expect(plain.kind, InsightKind.evenings);
      expect(plain.text('tr'), startsWith('Kayıt tuttuğun 4 akşamın hepsinde'));
    });

    test('an answer after midnight closes the day before', () {
      final late = evening('2026-10-07', 2, hour: 24 + 1); // 8 Oct, 01:00
      expect(late.dayKey, '2026-10-07');
    });

    test('never states a cause', () {
      final samples = [
        for (final kind in InsightKind.values)
          WeeklyInsight(
            kind: kind,
            recorded: 5,
            days: 3,
            good: 2,
            otherDays: 2,
            otherGood: 1,
          ),
      ];
      for (final insight in samples) {
        for (final locale in ['tr', 'en']) {
          final text = insight.text(locale).toLowerCase();
          for (final word in ['çünkü', 'sayesinde', 'because', 'thanks to']) {
            expect(text, isNot(contains(word)), reason: text);
          }
        }
      }
    });

    test('Turkish number suffixes follow the spoken word', () {
      expect(
        [
          for (final n in [0, 1, 2, 3, 4, 5, 6, 7, 10, 12])
            '$n${trLocativeSuffix(n)}',
        ],
        [
          "0'ında",
          "1'inde",
          "2'sinde",
          "3'ünde",
          "4'ünde",
          "5'inde",
          "6'sında",
          "7'sinde",
          "10'unda",
          "12'sinde",
        ],
      );
    });
  });

  group('evening record', () {
    test('merges answers and never touches the morning check-in', () async {
      final store = MemoryWellnessStore();
      final notifier = WellnessNotifier(store);
      addTearDown(notifier.dispose);
      final morning = DateTime(2026, 10, 8, 8);
      final night = DateTime(2026, 10, 8, 21);
      await notifier.checkIn(DailyCheckIn(recordedAt: morning, energy: 1));
      await notifier.saveEvening(night, energy: 3);
      await notifier.saveEvening(night, mood: 2, note: 'Yürüdüm');
      expect(store.initial.checkInFor(morning)!.energy, 1);
      final saved = store.initial.eveningFor(night)!;
      expect([saved.energy, saved.mood, saved.note], [3, 2, 'Yürüdüm']);
      expect(store.initial.evenings, hasLength(1));

      await notifier.saveEvening(night, clearNote: true);
      expect(store.initial.eveningFor(night)!.note, isNull);
      await notifier.deleteEvening(saved.dayKey);
      expect(store.initial.evenings, isEmpty);
      expect(store.initial.checkIns, hasLength(1));
    });

    test('survives a round trip; older snapshots load without evenings', () {
      final data = WellnessData(evenings: [evening('2026-10-08', 2)]);
      final back = WellnessData.fromJson(data.toJson());
      expect(back.evenings.single.energy, 2);
      final legacy = data.toJson()..remove('evenings');
      expect(WellnessData.fromJson(legacy).evenings, isEmpty);
    });
  });

  group('screens', () {
    final recipes = [
      for (final path in RecipeRepository.bundleFiles)
        ...RecipeRepository.decodeRecipeList(File(path).readAsStringSync()),
    ];

    Future<ProviderContainer> containerAt(DateTime now) async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer(
        overrides: [
          storageProvider.overrideWithValue(
            StorageService(await SharedPreferences.getInstance()),
          ),
          bundledRecipesProvider.overrideWithValue(recipes),
          wellnessStoreProvider.overrideWithValue(MemoryWellnessStore()),
          wellnessNowProvider.overrideWithValue(now),
        ],
      );
      addTearDown(container.dispose);
      return container;
    }

    Future<void> show(
      WidgetTester tester,
      ProviderContainer container,
      Widget screen,
    ) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            // The theme the app really uses (mood palette), not the legacy one.
            theme: AppTheme.forPalette(MoodPalette.all[CheckInType.lowEnergy]!),
            locale: const Locale('tr'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: Scaffold(body: screen),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('the closing card appears only in the evening', (tester) async {
      final morning = await containerAt(DateTime(2026, 10, 8, 10));
      await show(tester, morning, TodayScreen(navigate: (_) {}));
      expect(find.byKey(eveningCloseoutKey), findsNothing);
      await tester.pumpWidget(const SizedBox());

      final night = await containerAt(DateTime(2026, 10, 9, 0, 30));
      await show(tester, night, TodayScreen(navigate: (_) {}));
      expect(find.byKey(eveningCloseoutKey), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('one tap saves the evening answer, morning stays as it was', (
      tester,
    ) async {
      final now = DateTime(2026, 10, 8, 20);
      final container = await containerAt(now);
      await container
          .read(wellnessProvider.notifier)
          .checkIn(
            DailyCheckIn(recordedAt: DateTime(2026, 10, 8, 8), energy: 1),
          );
      await show(tester, container, TodayScreen(navigate: (_) {}));

      final card = find.byKey(eveningCloseoutKey);
      await tester.tap(find.descendant(of: card, matching: find.text('Orta')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(of: card, matching: find.text('Dengeli')),
      );
      await tester.pumpAndSettle();

      final data = container.read(wellnessProvider);
      expect(data.eveningFor(now)!.energy, 2);
      expect(data.eveningFor(now)!.mood, 2);
      expect(data.checkInFor(now)!.energy, 1);
      expect(find.textContaining('Kaydedildi'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('Progress shows the week as an observation, not a cause', (
      tester,
    ) async {
      final container = await containerAt(DateTime(2026, 10, 8, 21));
      final notifier = container.read(wellnessProvider.notifier);
      for (final (day, energy) in [
        ('2026-10-05', 3),
        ('2026-10-06', 2),
        ('2026-10-07', 1),
      ]) {
        await notifier.saveEvening(
          DateTime.parse(day).add(const Duration(hours: 21)),
          energy: energy,
        );
      }
      await show(tester, container, const ProgressScreen());
      final notEnough = find.textContaining('Akşam kaydın 3/4 gün');
      await tester.scrollUntilVisible(
        notEnough,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(notEnough, findsOneWidget);

      await notifier.saveEvening(DateTime(2026, 10, 8, 21), energy: 2);
      await tester.pumpAndSettle();
      expect(
        find.text(
          "Kayıt tuttuğun 4 akşamın 3'ünde enerjin orta ya da yüksekti.",
        ),
        findsOneWidget,
      );
      expect(find.textContaining('neden-sonuç iddiası değil'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    });
  });
}
