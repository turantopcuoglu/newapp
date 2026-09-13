import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'data/recipe_repository.dart';
import 'l10n/app_localizations.dart';
import 'providers/wellness_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/recipe_provider.dart';
import 'providers/storage_provider.dart';
import 'screens/disclaimer_screen.dart';
import 'screens/main_shell.dart';
import 'screens/wellness/health_connections_screen.dart';
import 'services/wellness_store.dart';
import 'services/private_storage.dart';
import 'screens/onboarding_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  late final StorageService storage;
  late final WellnessStore wellnessStore;
  try {
    wellnessStore = await EncryptedWellnessStore.open(prefs);
    storage = StorageService(
      prefs,
      privateData: await PrivateStorage.open(prefs),
    );
  } catch (_) {
    runApp(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.lock_outline, size: 48),
                    SizedBox(height: 20),
                    Text(
                      'Kayıtların güvenli biçimde açılamadı. Cihaz kilidini açıp tekrar dene.\nYour records could not be opened securely. Unlock your device and try again.',
                    ),
                    SizedBox(height: 20),
                    FilledButton(
                      onPressed: main,
                      child: Text('Tekrar dene / Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return;
  }
  final recipeRepository = RecipeRepository();
  final bundledRecipes = await recipeRepository.loadLatest();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        storageProvider.overrideWithValue(storage),
        wellnessStoreProvider.overrideWithValue(wellnessStore),
        activeRecipeContextProvider.overrideWith(
          (ref) => ref.watch(todayCheckInProvider)?.focus,
        ),
        bundledRecipesProvider.overrideWithValue(bundledRecipes),
      ],
      child: const MyApp(),
    ),
  );

  // Content refresh runs after first frame and applies on the next launch,
  // so recipes never change under the user mid-session.
  unawaited(recipeRepository.refreshFromRemote());
}

class _NoStretchScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAccessibilityFeatures() {
    setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final palette = ref.watch(moodPaletteProvider);

    return MaterialApp(
      title: 'NutriGuide',
      debugShowCheckedModeBanner: false,
      scrollBehavior: _NoStretchScrollBehavior(),
      theme: AppTheme.forPalette(palette),
      themeAnimationDuration:
          WidgetsBinding
              .instance
              .platformDispatcher
              .accessibilityFeatures
              .disableAnimations
          ? Duration.zero
          : const Duration(milliseconds: 700),
      themeAnimationCurve: Curves.easeInOutCubic,
      builder: (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: palette.brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        child: child!,
      ),
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const _DisclaimerGate(),
      routes: {'/health-privacy': (_) => const HealthPrivacyScreen()},
    );
  }
}

/// Gates the app behind the legal disclaimer.
/// Shows DisclaimerScreen if the user hasn't accepted the disclaimer yet.
class _DisclaimerGate extends ConsumerStatefulWidget {
  const _DisclaimerGate();

  @override
  ConsumerState<_DisclaimerGate> createState() => _DisclaimerGateState();
}

class _DisclaimerGateState extends ConsumerState<_DisclaimerGate> {
  bool _disclaimerAccepted = false;

  @override
  void initState() {
    super.initState();
    _disclaimerAccepted = ref.read(storageProvider).isDisclaimerAccepted();
  }

  @override
  Widget build(BuildContext context) {
    if (!_disclaimerAccepted) {
      return DisclaimerScreen(
        onAccepted: () {
          setState(() {
            _disclaimerAccepted = true;
          });
        },
      );
    }

    final storage = ref.read(storageProvider);
    if (storage.isOnboardingCompleted()) {
      return const MainShell();
    }
    return const OnboardingScreen();
  }
}
