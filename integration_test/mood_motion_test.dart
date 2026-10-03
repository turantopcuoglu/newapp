import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/data/recipe_repository.dart';
import 'package:nutri_guide/main.dart';
import 'package:nutri_guide/models/recipe.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/screens/main_shell.dart';
import 'package:nutri_guide/screens/wellness/mood_picker_screen.dart';
import 'package:nutri_guide/screens/wellness/routines_screen.dart';
import 'package:nutri_guide/screens/wellness/today_screen.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:nutri_guide/services/wellness_store.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  testWidgets(
    'native onboarding, theme changes, navigation and session motion',
    (tester) async {
      // Memory-backed demo state; never touches a person's existing health records.
      SharedPreferences.setMockInitialValues({});
      final storage = StorageService(await SharedPreferences.getInstance());
      await storage.setDisclaimerAccepted();
      final recipes = <Recipe>[];
      for (final file in RecipeRepository.bundleFiles) {
        recipes.addAll(
          RecipeRepository.decodeRecipeList(await rootBundle.loadString(file)),
        );
      }
      final container = ProviderContainer(
        overrides: [
          storageProvider.overrideWithValue(storage),
          wellnessStoreProvider.overrideWithValue(MemoryWellnessStore()),
          bundledRecipesProvider.overrideWithValue(recipes),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const MyApp()),
      );
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField).first, 'Demo');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      for (final label in ['Diğer', 'Devam Et', 'Atla', 'Atla']) {
        expect(
          find.text(label),
          findsOneWidget,
          reason: 'Onboarding step: $label',
        );
        await tester.ensureVisible(find.text(label));
        await tester.tap(find.text(label));
        await tester.pumpAndSettle();
      }
      expect(find.byType(MoodPickerScreen), findsOneWidget);
      await tester.tap(find.text('Şişkinlik'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Şimdilik atla'));
      await tester.tap(find.text('Şimdilik atla'));
      await tester.pumpAndSettle();
      expect(find.byType(MainShell), findsOneWidget);
      expect(container.read(moodPaletteProvider).mode, CheckInType.bloated);
      expect(tester.takeException(), isNull);
      for (final tab in ['Beslen', 'İyi oluş', 'Gelişim', 'Profil', 'Bugün']) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byKey(todayCheckInKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Düşük Enerji'));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Şimdilik atla'));
      await tester.tap(find.text('Şimdilik atla'));
      await tester.pumpAndSettle();
      expect(container.read(moodPaletteProvider).mode, CheckInType.lowEnergy);
      expect(tester.takeException(), isNull);
      final navigator = Navigator.of(tester.element(find.byType(MainShell)));
      for (final routine in routineLibrary) {
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => RoutineSessionScreen(routine: routine),
          ),
        );
        await tester.pumpAndSettle();
        await tester.ensureVisible(find.text('Başlat'));
        await tester.tap(find.text('Başlat'));
        await tester.pump(const Duration(milliseconds: 1200));
        if (const bool.fromEnvironment('MEASURE_NATIVE_MOTION')) {
          await binding.watchPerformance(() async {
            await tester.runAsync(
              () => Future<void>.delayed(const Duration(seconds: 8)),
            );
          }, reportKey: 'native_${routine.id}');
        } else {
          await tester.pump(const Duration(milliseconds: 600));
        }
        await tester.ensureVisible(find.text('Duraklat'));
        await tester.tap(find.text('Duraklat'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        navigator.pop();
        await tester.pumpAndSettle();
      }
      binding.reportData ??= {};
      binding.reportData!['verification'] = {
        'onboarding_theme_without_restart': true,
        'five_tabs': true,
        'routine_count': routineLibrary.length,
        'environment':
            'Android emulator, debug build; timings are diagnostic, not physical-device performance',
      };
      // Capturing the Android surface is expensive; do it after all timing samples.
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
      await binding.takeScreenshot('android-home');
      await tester.tap(find.text('Beslen').last);
      await tester.pumpAndSettle();
      await binding.takeScreenshot('android-discover');
      navigator.push(
        MaterialPageRoute<void>(
          builder: (_) => RoutineSessionScreen(routine: routineLibrary.first),
        ),
      );
      await tester.pumpAndSettle();
      await binding.takeScreenshot('android-breath');
      await tester.pumpWidget(const SizedBox());
    },
    timeout: const Timeout(Duration(minutes: 4)),
  );
}
