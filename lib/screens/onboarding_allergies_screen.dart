import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import '../providers/storage_provider.dart';
import 'main_shell.dart';
import 'mode_selection_screen.dart';

/// Common allergens mapped to their allergenTag keys used in the system.
class _AllergenItem {
  final String tag;
  final Map<String, String> label;
  final IconData icon;
  final Color color;

  const _AllergenItem({
    required this.tag,
    required this.label,
    required this.icon,
    required this.color,
  });
}

const List<_AllergenItem> _commonAllergens = [
  _AllergenItem(
    tag: 'gluten',
    label: {'en': 'Gluten', 'tr': 'Gluten'},
    icon: Icons.grain_rounded,
    color: Color(0xFFE67E22),
  ),
  _AllergenItem(
    tag: 'dairy',
    label: {'en': 'Dairy / Lactose', 'tr': 'Süt Ürünleri / Laktoz'},
    icon: Icons.water_drop_rounded,
    color: Color(0xFF3498DB),
  ),
  _AllergenItem(
    tag: 'eggs',
    label: {'en': 'Eggs', 'tr': 'Yumurta'},
    icon: Icons.egg_rounded,
    color: Color(0xFFF39C12),
  ),
  _AllergenItem(
    tag: 'nuts',
    label: {'en': 'Tree Nuts', 'tr': 'Kabuklu Yemişler'},
    icon: Icons.park_rounded,
    color: Color(0xFF8E44AD),
  ),
  _AllergenItem(
    tag: 'peanuts',
    label: {'en': 'Peanuts', 'tr': 'Yer Fıstığı'},
    icon: Icons.grass_rounded,
    color: Color(0xFFD35400),
  ),
  _AllergenItem(
    tag: 'fish',
    label: {'en': 'Fish', 'tr': 'Balık'},
    icon: Icons.set_meal_rounded,
    color: Color(0xFF2980B9),
  ),
  _AllergenItem(
    tag: 'shellfish',
    label: {'en': 'Shellfish', 'tr': 'Kabuklu Deniz Ürünleri'},
    icon: Icons.water_rounded,
    color: Color(0xFF1ABC9C),
  ),
  _AllergenItem(
    tag: 'soy',
    label: {'en': 'Soy', 'tr': 'Soya'},
    icon: Icons.eco_rounded,
    color: Color(0xFF27AE60),
  ),
  _AllergenItem(
    tag: 'sesame',
    label: {'en': 'Sesame', 'tr': 'Susam'},
    icon: Icons.scatter_plot_rounded,
    color: Color(0xFFBDC3C7),
  ),
];

/// Common foods people avoid (not necessarily allergens).
class _AvoidedFoodItem {
  final String ingredientId;
  final Map<String, String> label;
  final IconData icon;
  final Color color;

  const _AvoidedFoodItem({
    required this.ingredientId,
    required this.label,
    required this.icon,
    required this.color,
  });
}

const List<_AvoidedFoodItem> _commonAvoidedFoods = [
  _AvoidedFoodItem(
    ingredientId: 'pork_chop',
    label: {'en': 'Pork', 'tr': 'Domuz Eti'},
    icon: Icons.do_not_disturb_alt_rounded,
    color: Color(0xFFE74C3C),
  ),
  _AvoidedFoodItem(
    ingredientId: 'lamb',
    label: {'en': 'Lamb', 'tr': 'Kuzu Eti'},
    icon: Icons.do_not_disturb_alt_rounded,
    color: Color(0xFFC0392B),
  ),
  _AvoidedFoodItem(
    ingredientId: 'shrimp',
    label: {'en': 'Shrimp', 'tr': 'Karides'},
    icon: Icons.water_rounded,
    color: Color(0xFF16A085),
  ),
  _AvoidedFoodItem(
    ingredientId: 'tofu',
    label: {'en': 'Tofu', 'tr': 'Tofu'},
    icon: Icons.square_rounded,
    color: Color(0xFF2ECC71),
  ),
  _AvoidedFoodItem(
    ingredientId: 'mushroom',
    label: {'en': 'Mushroom', 'tr': 'Mantar'},
    icon: Icons.filter_vintage_rounded,
    color: Color(0xFF795548),
  ),
  _AvoidedFoodItem(
    ingredientId: 'eggplant',
    label: {'en': 'Eggplant', 'tr': 'Patlıcan'},
    icon: Icons.eco_rounded,
    color: Color(0xFF9B59B6),
  ),
  _AvoidedFoodItem(
    ingredientId: 'celery',
    label: {'en': 'Celery', 'tr': 'Kereviz'},
    icon: Icons.grass_rounded,
    color: Color(0xFF2ECC71),
  ),
  _AvoidedFoodItem(
    ingredientId: 'avocado',
    label: {'en': 'Avocado', 'tr': 'Avokado'},
    icon: Icons.lens_rounded,
    color: Color(0xFF27AE60),
  ),
  _AvoidedFoodItem(
    ingredientId: 'coconut_oil',
    label: {'en': 'Coconut', 'tr': 'Hindistancevizi'},
    icon: Icons.circle_rounded,
    color: Color(0xFF8D6E63),
  ),
  _AvoidedFoodItem(
    ingredientId: 'anchovy',
    label: {'en': 'Anchovy', 'tr': 'Hamsi'},
    icon: Icons.set_meal_rounded,
    color: Color(0xFF607D8B),
  ),
];

class OnboardingAllergiesScreen extends ConsumerStatefulWidget {
  const OnboardingAllergiesScreen({super.key});

  @override
  ConsumerState<OnboardingAllergiesScreen> createState() =>
      _OnboardingAllergiesScreenState();
}

class _OnboardingAllergiesScreenState
    extends ConsumerState<OnboardingAllergiesScreen>
    with SingleTickerProviderStateMixin {
  final Set<String> _selectedAllergens = {};
  final Set<String> _selectedAvoidedFoods = {};
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
    _animController.dispose();
    super.dispose();
  }

  void _toggleAllergen(String tag) {
    setState(() {
      if (_selectedAllergens.contains(tag)) {
        _selectedAllergens.remove(tag);
      } else {
        _selectedAllergens.add(tag);
      }
    });
  }

  void _toggleAvoidedFood(String id) {
    setState(() {
      if (_selectedAvoidedFoods.contains(id)) {
        _selectedAvoidedFoods.remove(id);
      } else {
        _selectedAvoidedFoods.add(id);
      }
    });
  }

  void _onContinue() async {
    final notifier = ref.read(profileProvider.notifier);

    // Save allergens
    if (_selectedAllergens.isNotEmpty) {
      notifier.updateAllergies(_selectedAllergens.toList());
    }

    // Save avoided foods as disliked ingredients
    if (_selectedAvoidedFoods.isNotEmpty) {
      notifier.updateDislikedIngredients(_selectedAvoidedFoods.toList());
    }

    final storage = ref.read(storageProvider);
    await storage.setOnboardingCompleted();

    if (mounted) {
      _navigateToMoodCheck();
    }
  }

  void _onSkip() async {
    final storage = ref.read(storageProvider);
    await storage.setOnboardingCompleted();

    if (mounted) {
      _navigateToMoodCheck();
    }
  }

  void _navigateToMoodCheck() {
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const _OnboardingMoodGate(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = l10n.locale.languageCode;

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
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppTheme.warmCoral.withAlpha(30),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppTheme.warmCoral.withAlpha(60),
                          ),
                        ),
                        child: const Icon(
                          Icons.health_and_safety_rounded,
                          color: AppTheme.warmCoral,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.onboardingAllergiesTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.onboardingAllergiesSubtitle,
                        style: TextStyle(
                          color: Colors.white.withAlpha(160),
                          fontSize: 14,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Allergens section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(10),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.white.withAlpha(15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color:
                                          AppTheme.warmCoral.withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.warning_amber_rounded,
                                      color: AppTheme.warmCoral,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    l10n.onboardingAllergensSection,
                                    style: const TextStyle(
                                      color: AppTheme.warmCoral,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _commonAllergens.map((item) {
                                  final isSelected =
                                      _selectedAllergens.contains(item.tag);
                                  return GestureDetector(
                                    onTap: () => _toggleAllergen(item.tag),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? item.color.withAlpha(40)
                                            : Colors.white.withAlpha(8),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? item.color.withAlpha(150)
                                              : Colors.white.withAlpha(25),
                                          width: isSelected ? 1.5 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            isSelected
                                                ? Icons.check_rounded
                                                : item.icon,
                                            color: isSelected
                                                ? item.color
                                                : Colors.white.withAlpha(150),
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            item.label[locale] ??
                                                item.label['en']!,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? item.color
                                                  : Colors.white
                                                      .withAlpha(200),
                                              fontSize: 13,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Avoided foods section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(10),
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.white.withAlpha(15)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppTheme.softLavender
                                          .withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.block_rounded,
                                      color: AppTheme.softLavender,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    l10n.onboardingAvoidedSection,
                                    style: const TextStyle(
                                      color: AppTheme.softLavender,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _commonAvoidedFoods.map((item) {
                                  final isSelected = _selectedAvoidedFoods
                                      .contains(item.ingredientId);
                                  return GestureDetector(
                                    onTap: () =>
                                        _toggleAvoidedFood(item.ingredientId),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? item.color.withAlpha(40)
                                            : Colors.white.withAlpha(8),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? item.color.withAlpha(150)
                                              : Colors.white.withAlpha(25),
                                          width: isSelected ? 1.5 : 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isSelected)
                                            Icon(
                                              Icons.check_rounded,
                                              color: item.color,
                                              size: 16,
                                            )
                                          else
                                            Icon(
                                              item.icon,
                                              color:
                                                  Colors.white.withAlpha(150),
                                              size: 16,
                                            ),
                                          const SizedBox(width: 6),
                                          Text(
                                            item.label[locale] ??
                                                item.label['en']!,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? item.color
                                                  : Colors.white
                                                      .withAlpha(200),
                                              fontSize: 13,
                                              fontWeight: isSelected
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Info hint
                        Text(
                          l10n.onboardingAllergiesEditLater,
                          style: TextStyle(
                            color: Colors.white.withAlpha(120),
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // Bottom buttons
      bottomSheet: Container(
        padding: EdgeInsets.only(
          left: 28,
          right: 28,
          bottom: MediaQuery.of(context).padding.bottom + 16,
          top: 12,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0x001B2838),
              Color(0xFF1B2838),
            ],
          ),
        ),
        child: Row(
          children: [
            // Skip button
            TextButton(
              onPressed: _onSkip,
              child: Text(
                l10n.onboardingSkip,
                style: TextStyle(
                  color: Colors.white.withAlpha(180),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Continue button
            Expanded(
              child: SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _onContinue,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.accentOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(l10n.onboardingContinue),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Wrapper that shows ModeSelectionScreen after onboarding completes,
/// then navigates to MainShell once the user selects their mood.
class _OnboardingMoodGate extends ConsumerStatefulWidget {
  const _OnboardingMoodGate();

  @override
  ConsumerState<_OnboardingMoodGate> createState() =>
      _OnboardingMoodGateState();
}

class _OnboardingMoodGateState extends ConsumerState<_OnboardingMoodGate> {
  bool _modeSelected = false;

  @override
  Widget build(BuildContext context) {
    if (_modeSelected) {
      return const MainShell();
    }

    return ModeSelectionScreen(
      onModeSelected: () {
        setState(() => _modeSelected = true);
      },
    );
  }
}
