import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums.dart';
import '../core/theme.dart';
import '../data/mock_ingredients.dart';
import '../l10n/app_localizations.dart';
import '../models/ingredient.dart';
import '../providers/inventory_provider.dart';
import 'onboarding_allergies_screen.dart';

/// Curated list of ~8 most common ingredients per food group for onboarding.
const Map<IngredientCategory, List<String>> _onboardingIngredientIds = {
  IngredientCategory.protein: [
    'chicken_breast',
    'ground_beef',
    'eggs',
    'salmon',
    'turkey_breast',
    'lamb',
    'tuna',
    'shrimp',
  ],
  IngredientCategory.dairy: [
    'milk',
    'yogurt',
    'cheddar_cheese',
    'feta_cheese',
    'butter',
    'cream',
    'mozzarella',
    'greek_yogurt',
  ],
  IngredientCategory.grain: [
    'white_rice',
    'pasta',
    'bread',
    'flour',
    'oats',
    'bulgur',
    'quinoa',
    'brown_rice',
  ],
  IngredientCategory.vegetable: [
    'tomato',
    'onion',
    'garlic',
    'potato',
    'carrot',
    'bell_pepper',
    'cucumber',
    'spinach',
  ],
  IngredientCategory.fruit: [
    'apple',
    'banana',
    'lemon',
    'orange',
    'strawberry',
    'avocado',
    'grape',
    'watermelon',
  ],
  IngredientCategory.legume: [
    'red_lentil',
    'green_lentil',
    'chickpea',
    'white_bean',
    'black_eyed_pea',
  ],
  IngredientCategory.spice: [
    'black_pepper',
    'cumin',
    'paprika',
    'red_pepper_flakes',
    'cinnamon',
    'oregano',
    'mint',
    'parsley',
  ],
  IngredientCategory.oil: [
    'olive_oil',
    'sunflower_oil',
    'coconut_oil',
    'sesame_oil',
  ],
};

class OnboardingIngredientsScreen extends ConsumerStatefulWidget {
  const OnboardingIngredientsScreen({super.key});

  @override
  ConsumerState<OnboardingIngredientsScreen> createState() =>
      _OnboardingIngredientsScreenState();
}

class _OnboardingIngredientsScreenState
    extends ConsumerState<OnboardingIngredientsScreen>
    with SingleTickerProviderStateMixin {
  final Set<String> _selectedIds = {};
  late final AnimationController _animController;
  late final Animation<double> _fadeAnim;

  // Build lookup map
  static final Map<String, Ingredient> _ingredientMap = {
    for (final ing in mockIngredients) ing.id: ing,
  };

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

  void _toggleIngredient(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _onContinue() {
    // Save selected ingredients to inventory
    final notifier = ref.read(inventoryProvider.notifier);
    for (final id in _selectedIds) {
      notifier.addItem(id);
    }

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingAllergiesScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _onSkip() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingAllergiesScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
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
                          gradient: AppTheme.accentGradient,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.accentOrange.withAlpha(60),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.kitchen_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        l10n.onboardingIngredientsTitle,
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
                        l10n.onboardingIngredientsSubtitle,
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
                const SizedBox(height: 20),

                // Scrollable ingredient groups
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        ..._onboardingIngredientIds.entries.map((entry) {
                          return _CategorySection(
                            category: entry.key,
                            ingredientIds: entry.value,
                            selectedIds: _selectedIds,
                            ingredientMap: _ingredientMap,
                            locale: locale,
                            l10n: l10n,
                            onToggle: _toggleIngredient,
                          );
                        }),
                        const SizedBox(height: 16),
                        // "Add later" hint
                        Text(
                          l10n.onboardingIngredientsAddLater,
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
                      Text(
                        _selectedIds.isEmpty
                            ? l10n.onboardingContinue
                            : '${l10n.onboardingIngredientsAdd} (${_selectedIds.length})',
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

class _CategorySection extends StatelessWidget {
  final IngredientCategory category;
  final List<String> ingredientIds;
  final Set<String> selectedIds;
  final Map<String, Ingredient> ingredientMap;
  final String locale;
  final AppLocalizations l10n;
  final ValueChanged<String> onToggle;

  const _CategorySection({
    required this.category,
    required this.ingredientIds,
    required this.selectedIds,
    required this.ingredientMap,
    required this.locale,
    required this.l10n,
    required this.onToggle,
  });

  String _categoryLabel() {
    switch (category) {
      case IngredientCategory.protein:
        return l10n.catProtein;
      case IngredientCategory.dairy:
        return l10n.catDairy;
      case IngredientCategory.grain:
        return l10n.catGrain;
      case IngredientCategory.vegetable:
        return l10n.catVegetable;
      case IngredientCategory.fruit:
        return l10n.catFruit;
      case IngredientCategory.spice:
        return l10n.catSpice;
      case IngredientCategory.oil:
        return l10n.catOil;
      case IngredientCategory.legume:
        return l10n.catLegume;
      case IngredientCategory.condiment:
        return l10n.catCondiment;
      case IngredientCategory.nut:
        return l10n.catNut;
      case IngredientCategory.snackFood:
        return l10n.catSnackFood;
      case IngredientCategory.beverage:
        return l10n.catBeverage;
      case IngredientCategory.other:
        return l10n.catOther;
    }
  }

  IconData _categoryIcon() {
    switch (category) {
      case IngredientCategory.protein:
        return Icons.set_meal_rounded;
      case IngredientCategory.dairy:
        return Icons.water_drop_rounded;
      case IngredientCategory.grain:
        return Icons.grain_rounded;
      case IngredientCategory.vegetable:
        return Icons.eco_rounded;
      case IngredientCategory.fruit:
        return Icons.apple_rounded;
      case IngredientCategory.spice:
        return Icons.local_fire_department_rounded;
      case IngredientCategory.oil:
        return Icons.opacity_rounded;
      case IngredientCategory.legume:
        return Icons.grass_rounded;
      case IngredientCategory.condiment:
        return Icons.soup_kitchen_rounded;
      case IngredientCategory.nut:
        return Icons.park_rounded;
      case IngredientCategory.snackFood:
        return Icons.cookie_rounded;
      case IngredientCategory.beverage:
        return Icons.local_cafe_rounded;
      case IngredientCategory.other:
        return Icons.category_rounded;
    }
  }

  Color _categoryColor() {
    switch (category) {
      case IngredientCategory.protein:
        return const Color(0xFFE74C3C);
      case IngredientCategory.dairy:
        return const Color(0xFF3498DB);
      case IngredientCategory.grain:
        return const Color(0xFFE67E22);
      case IngredientCategory.vegetable:
        return const Color(0xFF2ECC71);
      case IngredientCategory.fruit:
        return const Color(0xFFE84393);
      case IngredientCategory.spice:
        return const Color(0xFFFF6B35);
      case IngredientCategory.oil:
        return const Color(0xFFF1C40F);
      case IngredientCategory.legume:
        return const Color(0xFF8E44AD);
      default:
        return const Color(0xFF95A5A6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(10),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withAlpha(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(_categoryIcon(), color: color, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  _categoryLabel(),
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Ingredient chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ingredientIds.map((id) {
                final ingredient = ingredientMap[id];
                if (ingredient == null) return const SizedBox.shrink();
                final isSelected = selectedIds.contains(id);
                return GestureDetector(
                  onTap: () => onToggle(id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withAlpha(40)
                          : Colors.white.withAlpha(8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? color.withAlpha(150)
                            : Colors.white.withAlpha(25),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          Icon(
                            Icons.check_rounded,
                            color: color,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          ingredient.localizedName(locale),
                          style: TextStyle(
                            color: isSelected
                                ? color
                                : Colors.white.withAlpha(200),
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
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
    );
  }
}
