import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as legacy;
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_provider.dart';
import 'providers/daily_mode_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/storage_provider.dart';
import 'screens/main_shell.dart';
import 'screens/mode_selection_screen.dart';
import 'screens/onboarding_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final storage = StorageService(prefs);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));

  runApp(
    ProviderScope(
      overrides: [
        storageProvider.overrideWithValue(storage),
      ],
      child: legacy.ChangeNotifierProvider(
        create: (_) => AppProvider(storage),
        child: const MyApp(),
      ),
    ),
  );
}

class _NoStretchScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      title: 'NutriGuide',
      debugShowCheckedModeBanner: false,
      scrollBehavior: _NoStretchScrollBehavior(),
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: ref.read(storageProvider).isOnboardingCompleted()
          ? const _AppGate()
          : const OnboardingScreen(),
    );
  }
}

/// Gates the app behind daily mode selection.
/// Shows ModeSelectionScreen if mode hasn't been selected today (resets at 6 AM).
class _AppGate extends ConsumerStatefulWidget {
  const _AppGate();

  @override
  ConsumerState<_AppGate> createState() => _AppGateState();
}

class _AppGateState extends ConsumerState<_AppGate> {
  bool _modeJustSelected = false;

  @override
  Widget build(BuildContext context) {
    final dailyMode = ref.watch(dailyModeProvider);

    if (dailyMode != null || _modeJustSelected) {
      return const MainShell();
    }

    return ModeSelectionScreen(
      onModeSelected: () {
        setState(() {
          _modeJustSelected = true;
        });
      },
    );
  }
}
