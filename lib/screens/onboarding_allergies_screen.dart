import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/onboarding_artwork_header.dart';
import '../core/theme.dart';
import '../core/wellness_motion.dart';
import '../l10n/app_localizations.dart';
import '../providers/profile_provider.dart';
import '../providers/storage_provider.dart';
import '../services/diet_classifier.dart';
import 'main_shell.dart';

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
    label: {'en': 'Milk / Dairy allergy', 'tr': 'Süt / Süt ürünleri alerjisi'},
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
  final Set<String> _selectedDietPrefs = {};
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
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

  void _toggleDietPref(String tag) {
    setState(() {
      if (_selectedDietPrefs.contains(tag)) {
        _selectedDietPrefs.remove(tag);
      } else {
        _selectedDietPrefs.add(tag);
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

    // Save diet preferences
    for (final pref in _selectedDietPrefs) {
      notifier.toggleDietPreference(pref);
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
      MaterialPageRoute<void>(builder: (_) => const MainShell()),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.palette.background,
              context.palette.surface,
              context.palette.background,
            ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: reducedMotion(context)
                ? const AlwaysStoppedAnimation(1.0)
                : _fadeAnim,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        OnboardingArtworkHeader(
                          name: 'safety',
                          title: l10n.onboardingAllergiesTitle,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.onboardingAllergiesSubtitle,
                          style: TextStyle(
                            color: context.palette.textSecondary,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Allergens section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.palette.textPrimary.withAlpha(10),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: context.palette.textPrimary.withAlpha(15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: context.palette.warmCoral
                                          .withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.warning_amber_rounded,
                                      color: context.palette.warmCoral,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      l10n.onboardingAllergensSection,
                                      style: TextStyle(
                                        color: context.palette.warmCoral,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: _commonAllergens.map((item) {
                                  final isSelected = _selectedAllergens
                                      .contains(item.tag);
                                  return GestureDetector(
                                    onTap: () => _toggleAllergen(item.tag),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? item.color.withAlpha(40)
                                            : context.palette.textPrimary
                                                  .withAlpha(8),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? item.color.withAlpha(150)
                                              : context.palette.textPrimary
                                                    .withAlpha(25),
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
                                                : context.palette.textPrimary
                                                      .withAlpha(150),
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              item.label[locale] ??
                                                  item.label['en']!,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? item.color
                                                    : context
                                                          .palette
                                                          .textPrimary
                                                          .withAlpha(200),
                                                fontSize: 13,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
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
                            color: context.palette.textPrimary.withAlpha(10),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: context.palette.textPrimary.withAlpha(15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: context.palette.softLavender
                                          .withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.block_rounded,
                                      color: context.palette.softLavender,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      l10n.onboardingAvoidedSection,
                                      style: TextStyle(
                                        color: context.palette.softLavender,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
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
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? item.color.withAlpha(40)
                                            : context.palette.textPrimary
                                                  .withAlpha(8),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? item.color.withAlpha(150)
                                              : context.palette.textPrimary
                                                    .withAlpha(25),
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
                                              color: context.palette.textPrimary
                                                  .withAlpha(150),
                                              size: 16,
                                            ),
                                          const SizedBox(width: 6),
                                          Flexible(
                                            child: Text(
                                              item.label[locale] ??
                                                  item.label['en']!,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? item.color
                                                    : context
                                                          .palette
                                                          .textPrimary
                                                          .withAlpha(200),
                                                fontSize: 13,
                                                fontWeight: isSelected
                                                    ? FontWeight.w600
                                                    : FontWeight.w400,
                                              ),
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

                        // Diet preferences section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: context.palette.textPrimary.withAlpha(10),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: context.palette.textPrimary.withAlpha(15),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: context.palette.successGreen
                                          .withAlpha(30),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.eco_rounded,
                                      color: context.palette.successGreen,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      l10n.dietPreferencesTitle,
                                      style: TextStyle(
                                        color: context.palette.successGreen,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children:
                                    {
                                      DietClassifier.vegetarian:
                                          l10n.dietVegetarian,
                                      DietClassifier.vegan: l10n.dietVegan,
                                      DietClassifier.glutenFree:
                                          l10n.dietGlutenFree,
                                      DietClassifier.dairyFree:
                                          l10n.dietDairyFree,
                                    }.entries.map((entry) {
                                      final isSelected = _selectedDietPrefs
                                          .contains(entry.key);
                                      return GestureDetector(
                                        onTap: () => _toggleDietPref(entry.key),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? context.palette.successGreen
                                                      .withAlpha(40)
                                                : context.palette.textPrimary
                                                      .withAlpha(8),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: isSelected
                                                  ? context.palette.successGreen
                                                        .withAlpha(150)
                                                  : context.palette.textPrimary
                                                        .withAlpha(25),
                                              width: isSelected ? 1.5 : 1,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                isSelected
                                                    ? Icons.check_rounded
                                                    : Icons.eco_rounded,
                                                color: isSelected
                                                    ? context
                                                          .palette
                                                          .successGreen
                                                    : context
                                                          .palette
                                                          .textPrimary
                                                          .withAlpha(150),
                                                size: 16,
                                              ),
                                              const SizedBox(width: 6),
                                              Flexible(
                                                child: Text(
                                                  entry.value,
                                                  style: TextStyle(
                                                    color: isSelected
                                                        ? context
                                                              .palette
                                                              .successGreen
                                                        : context
                                                              .palette
                                                              .textPrimary
                                                              .withAlpha(200),
                                                    fontSize: 13,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.w400,
                                                  ),
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
                            color: context.palette.textPrimary.withAlpha(120),
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0x001B2838), context.palette.background],
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
                  color: context.palette.textPrimary.withAlpha(180),
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
                    backgroundColor: context.palette.accentOrange,
                    foregroundColor: context.palette.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'WellnessSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.onboardingContinue,
                          textAlign: TextAlign.center,
                        ),
                      ),
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
