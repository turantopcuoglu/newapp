import 'package:flutter/material.dart';

import '../components/health_condition_chips.dart';
import '../components/onboarding_artwork_header.dart';
import '../core/theme.dart';
import 'onboarding_allergies_screen.dart';
import 'wellness/moonlit_page.dart';
import 'wellness/wellness_ui.dart';

/// Second onboarding step: optional health conditions.
///
/// This used to be the pantry step. Asking what is in the fridge before
/// anything about the person put the least important question first; the
/// kitchen now fills in from Nourish as recipes are used.
class OnboardingHealthScreen extends StatelessWidget {
  const OnboardingHealthScreen({super.key});

  void _next(BuildContext context) => Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const OnboardingAllergiesScreen()),
  );

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 16, 22, 20),
                  child: OnboardingArtworkHeader(
                    name: 'health',
                    title: context.w(
                      'Bilmemizi istediğin bir durum var mı?',
                      'Anything you want us to know?',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        context.w(
                          'İstersen seç, istemezsen atla. Sonra Profil\'den değiştirebilirsin.',
                          'Choose if you like, or skip. You can change it later in Profile.',
                        ),
                        style: TextStyle(
                          fontSize: 15,
                          color: context.palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const HealthConditionChips(),
                      const SizedBox(height: 18),
                      Text(
                        healthConditionDisclaimer(locale),
                        style: const TextStyle(fontSize: 12, height: 1.35),
                      ),
                      const SizedBox(height: 26),
                      MoonButton(
                        label: context.w('Devam', 'Continue'),
                        onPressed: () => _next(context),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => _next(context),
                        child: Text(context.w('Atla', 'Skip')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
