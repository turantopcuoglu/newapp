import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/core/theme.dart';
import 'package:nutri_guide/main.dart';
import 'package:nutri_guide/providers/recipe_provider.dart';
import 'package:nutri_guide/providers/storage_provider.dart';
import 'package:nutri_guide/providers/wellness_provider.dart';
import 'package:nutri_guide/screens/main_shell.dart';
import 'package:nutri_guide/screens/onboarding_screen.dart';
import 'package:nutri_guide/screens/onboarding_ingredients_screen.dart';
import 'package:nutri_guide/screens/onboarding_allergies_screen.dart';
import 'package:nutri_guide/screens/wellness/mood_picker_screen.dart';
import 'package:nutri_guide/services/storage_service.dart';
import 'package:nutri_guide/services/wellness_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('WellnessSans');
    for (final weight in ['regular', 'medium', 'bold']) {
      font.addFont(rootBundle.load('assets/fonts/roboto-$weight.ttf'));
    }
    await font.load();
  });
  testWidgets('theme changes after onboarding disposes every previous route', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({});
    final storage = StorageService(await SharedPreferences.getInstance());
    await storage.setDisclaimerAccepted();
    final store = MemoryWellnessStore();
    final container = ProviderContainer(
      overrides: [
        storageProvider.overrideWithValue(storage),
        wellnessStoreProvider.overrideWithValue(store),
        bundledRecipesProvider.overrideWithValue([]),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const MyApp()),
    );
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
    await tester.enterText(find.byType(TextField).first, 'Demo');
    await tester.ensureVisible(find.text('Diğer'));
    await tester.tap(find.text('Diğer'));
    await tester.ensureVisible(find.text('Devam Et'));
    await tester.tap(find.text('Devam Et'));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingIngredientsScreen), findsOneWidget);
    await tester.ensureVisible(find.text('Atla'));
    await tester.tap(find.text('Atla'));
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingAllergiesScreen), findsOneWidget);
    await tester.ensureVisible(find.text('Atla'));
    await tester.tap(find.text('Atla'));
    await tester.pumpAndSettle();
    expect(find.byType(MoodPickerScreen), findsOneWidget);
    expect(
      find.byType(OnboardingAllergiesScreen, skipOffstage: false),
      findsNothing,
    );
    await tester.tap(find.text('Şişkinlik'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(MainShell), findsOneWidget);
    expect(container.read(moodPaletteProvider).mode, CheckInType.bloated);
    expect(
      Theme.of(tester.element(find.byType(MainShell))).scaffoldBackgroundColor,
      MoodPalette.all[CheckInType.bloated]!.background,
    );
    // A second change and system accessibility rebuild exercise the retained route.
    await tester.tap(find.text('Durumu değiştir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Düşük Enerji'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.binding.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    tester.binding.platformDispatcher.clearAccessibilityFeaturesTestValue();
    await tester.pumpWidget(const SizedBox());
  });
}
