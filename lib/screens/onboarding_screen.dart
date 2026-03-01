import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import 'onboarding_ingredients_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  Gender? _selectedGender;
  bool _showNameError = false;
  bool _showGenderError = false;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _onContinue() async {
    final name = _nameController.text.trim();
    setState(() {
      _showNameError = name.isEmpty;
      _showGenderError = _selectedGender == null;
    });

    if (name.isEmpty || _selectedGender == null) return;

    final notifier = ref.read(profileProvider.notifier);
    notifier.updateName(name);
    notifier.updateGender(_selectedGender!);

    if (mounted) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const OnboardingIngredientsScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1B2838),
              Color(0xFF2D3E50),
              Color(0xFF1B2838),
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.06),

                  // Logo / Icon
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: AppTheme.accentGradient,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.accentOrange.withAlpha(80),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: Colors.white,
                      size: 44,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Welcome text
                  Text(
                    l10n.onboardingWelcome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.onboardingWelcomeSubtitle,
                    style: TextStyle(
                      color: Colors.white.withAlpha(160),
                      fontSize: 15,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: size.height * 0.05),

                  // Name input card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withAlpha(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.accentOrange.withAlpha(30),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.person_rounded,
                                color: AppTheme.accentOrange,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              l10n.onboardingNameLabel,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: l10n.onboardingNameHint,
                            hintStyle: TextStyle(
                              color: Colors.white.withAlpha(80),
                            ),
                            filled: true,
                            fillColor: Colors.white.withAlpha(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: const BorderSide(
                                color: AppTheme.accentOrange,
                                width: 1.5,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            errorText:
                                _showNameError ? l10n.onboardingNameRequired : null,
                            errorStyle: const TextStyle(
                              color: AppTheme.warmCoral,
                            ),
                          ),
                          onChanged: (_) {
                            if (_showNameError) {
                              setState(() => _showNameError = false);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Gender selection card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(15),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: _showGenderError
                            ? AppTheme.warmCoral.withAlpha(120)
                            : Colors.white.withAlpha(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.softLavender.withAlpha(30),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.wc_rounded,
                                color: AppTheme.softLavender,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.onboardingGenderTitle,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l10n.onboardingGenderSubtitle,
                                    style: TextStyle(
                                      color: Colors.white.withAlpha(120),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _GenderCard(
                                icon: Icons.male_rounded,
                                label: l10n.onboardingMale,
                                color: AppTheme.accentTeal,
                                isSelected: _selectedGender == Gender.male,
                                onTap: () => setState(() {
                                  _selectedGender = Gender.male;
                                  _showGenderError = false;
                                }),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _GenderCard(
                                icon: Icons.female_rounded,
                                label: l10n.onboardingFemale,
                                color: AppTheme.snackColor,
                                isSelected: _selectedGender == Gender.female,
                                onTap: () => setState(() {
                                  _selectedGender = Gender.female;
                                  _showGenderError = false;
                                }),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _GenderCard(
                                icon: Icons.transgender_rounded,
                                label: l10n.onboardingOther,
                                color: AppTheme.softLavender,
                                isSelected: _selectedGender == Gender.other,
                                onTap: () => setState(() {
                                  _selectedGender = Gender.other;
                                  _showGenderError = false;
                                }),
                              ),
                            ),
                          ],
                        ),
                        if (_showGenderError) ...[
                          const SizedBox(height: 10),
                          Text(
                            l10n.onboardingGenderRequired,
                            style: const TextStyle(
                              color: AppTheme.warmCoral,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: _onContinue,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.accentOrange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.onboardingContinue),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 22),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: isSelected ? color.withAlpha(30) : Colors.white.withAlpha(8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.white.withAlpha(15),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.white.withAlpha(120),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? color : Colors.white.withAlpha(160),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
