import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/recipe_visual.dart';
import '../../components/save_recipe_button.dart';
import '../../core/theme.dart';
import '../../models/recipe.dart';
import '../../providers/profile_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../providers/cooked_provider.dart';
import '../../services/preference_matcher.dart';
import '../../services/recommendation_service.dart';
import '../../services/recipe_timing.dart';
import '../recipe_detail/recipe_detail_screen.dart';
import 'moonlit_assets.dart';
import 'moonlit_page.dart';
import 'nourish_screen.dart';
import 'wellness_ui.dart';

class MoonlitRecipeScreen extends ConsumerWidget {
  final ScoredRecipe scored;
  const MoonlitRecipeScreen({super.key, required this.scored});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipe = scored.recipe;
    final profile = ref.watch(profileProvider);
    if (recipeHasAllergenConflict(recipe, profile)) {
      return RecipeDetailScreen(scoredRecipe: scored);
    }
    final locale = Localizations.localeOf(context).languageCode;
    final featured = recipe.id == 'moonlit_bulgur_bowl';
    final minutes = RecipeTiming.minutes(recipe);
    final large = MediaQuery.textScalerOf(context).scale(1) > 1.2;
    final inventory = ref.watch(inventoryIdsProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SaveRecipeButton(recipeId: recipe.id),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            children: [
              SizedBox(
                height: large ? 400 : 350,
                child: Stack(
                  children: [
                    Positioned(
                      left: -16,
                      right: -16,
                      top: 130,
                      bottom: 0,
                      child: featured
                          ? const OriginalFoodPhoto(detail: true)
                          : RecipeVisual(recipe: recipe, height: 220),
                    ),
                    if (large)
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                context.palette.background,
                                context.palette.background.withValues(
                                  alpha: .7,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.w('Senin için seçildi', 'Selected for you'),
                            style: TextStyle(
                              color: context.palette.moon,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            featured
                                ? context.w(
                                    'Nohutlu\nbulgur kasesi',
                                    'Chickpea\nbulgur bowl',
                                  )
                                : recipe.localizedName(locale),
                            style: Theme.of(
                              context,
                            ).textTheme.headlineLarge?.copyWith(height: 1.13),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${minutes == null ? context.w('Süre belirtilmemiş', 'Time not specified') : '${RecipeTiming.isEstimate(recipe) ? '~' : ''}$minutes ${context.w('dk', 'min')}'}  ·  ${recipe.servings} ${context.w('porsiyon', 'serving')}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 10),
                          if (featured)
                            Text(
                              context.w(
                                'Hazır nohut ve pişmiş bulgurla',
                                'With cooked chickpeas and bulgur',
                              ),
                              style: const TextStyle(fontSize: 13),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              WellnessCard(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
                color: context.palette.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.w('Neden sana göre?', 'Why does it fit?'),
                      style: const TextStyle(fontSize: 17),
                    ),
                    const SizedBox(height: 10),
                    FineRow(
                      icon: Icons.schedule_outlined,
                      title: minutes != null
                          ? context.w(
                              '$minutes dakikalık hazırlık',
                              '$minutes-minute preparation',
                            )
                          : context.w(
                              'Tercihlerinle eşleşir',
                              'Matches your preferences',
                            ),
                    ),
                    if (featured)
                      FineRow(
                        icon: Icons.no_food_outlined,
                        title: context.w(
                          'Süt ürünü kullanılmadı',
                          'Made without dairy ingredients',
                        ),
                      ),
                    FineRow(
                      icon: Icons.eco_outlined,
                      title: context.w(
                        'Seçtiğin besinleri birleştirir',
                        'Brings your selected foods together',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              WellnessCard(
                padding: EdgeInsets.zero,
                child: ExpansionTile(
                  shape: const Border(),
                  collapsedShape: const Border(),
                  title: Text(
                    context.w(
                      'Malzemeler ve miktarlar',
                      'Ingredients & quantities',
                    ),
                    style: const TextStyle(fontSize: 15),
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  children: [
                    ...recipe.ingredientIds.map(
                      (id) => FineRow(
                        title: foodName(id, locale, prepared: featured),
                        trailing: Text(
                          recipe.quantities[id]?.formatted() ?? '—',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    if (featured)
                      Text(
                        context.w(
                          'Bulgur miktarı kuru eşdeğeridir; önceden pişirilmiş olarak kullanılır.',
                          'Bulgur quantity is its dry equivalent; use it already cooked.',
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 4,
                ),
                child: Text(
                  context.w(
                    'Ürünlerin alerjen etiketlerini kontrol et.',
                    'Check the products’ allergen labels.',
                  ),
                  style: const TextStyle(fontSize: 11),
                ),
              ),
              MoonButton(
                label: context.w('Pişirmeye başla', 'Start cooking'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => MoonlitCookingScreen(recipe: recipe),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  final before = ref
                      .read(shoppingProvider)
                      .map((i) => i.id)
                      .toSet();
                  for (final id in recipe.ingredientIds.where(
                    (id) => !inventory.contains(id),
                  )) {
                    ref
                        .read(shoppingProvider.notifier)
                        .addItem(foodName(id, locale), forRecipeId: recipe.id);
                  }
                  final added = ref
                      .read(shoppingProvider)
                      .where((i) => !before.contains(i.id))
                      .map((i) => i.id)
                      .toList();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        context.w(
                          '${added.length} malzeme listene eklendi',
                          '${added.length} ingredients added',
                        ),
                      ),
                      action: SnackBarAction(
                        label: context.w('Geri al', 'Undo'),
                        onPressed: () => ref
                            .read(shoppingProvider.notifier)
                            .removeItems(added),
                      ),
                    ),
                  );
                },
                child: Text(
                  context.w(
                    'Eksikleri alışverişe ekle',
                    'Add missing ingredients to shopping',
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => RecipeDetailScreen(scoredRecipe: scored),
                  ),
                ),
                child: Text(
                  context.w(
                    'Besin değerleri ve öğün planı',
                    'Nutrition details & meal plan',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MoonlitCookingScreen extends ConsumerStatefulWidget {
  final Recipe recipe;
  const MoonlitCookingScreen({super.key, required this.recipe});
  @override
  ConsumerState<MoonlitCookingScreen> createState() => _CookingState();
}

class _CookingState extends ConsumerState<MoonlitCookingScreen> {
  int step = 0;
  bool saved = false;
  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final safe = !recipeHasAllergenConflict(recipe, ref.watch(profileProvider));
    final locale = Localizations.localeOf(context).languageCode;
    final steps = recipe.localizedSteps(locale);
    return Scaffold(
      appBar: AppBar(title: Text(recipe.localizedName(locale))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            safe
                ? context.w(
                    'Kendi temponda hazırla.',
                    'Prepare at your own pace.',
                  )
                : context.w(
                    'Tercihlerin değişti.',
                    'Your preferences changed.',
                  ),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 30),
          if (!safe)
            Text(
              context.w(
                'Bu tarif güncel alerji veya hassasiyet seçimlerine uygun değil.',
                'This recipe does not match your current allergy or sensitivity settings.',
              ),
            )
          else if (steps.isEmpty)
            Text(
              context.w(
                'Tarif adımları bulunamadı.',
                'Recipe instructions are missing.',
              ),
            )
          else ...[
            Text(
              context.w(
                'ADIM ${step + 1} / ${steps.length}',
                'STEP ${step + 1} / ${steps.length}',
              ),
              style: TextStyle(color: context.palette.moon),
            ),
            const SizedBox(height: 16),
            Text(
              steps[step],
              style: const TextStyle(fontSize: 22, height: 1.5),
            ),
            const SizedBox(height: 36),
            if (step < steps.length - 1)
              MoonButton(
                label: context.w('Sonraki adım', 'Next step'),
                onPressed: () => setState(() => step++),
              )
            else
              MoonButton(
                label: saved
                    ? context.w('Pişirdiğin kaydedildi', 'Logged as cooked')
                    : context.w('Pişirdim, kaydet', 'I cooked it, save'),
                onPressed: saved
                    ? null
                    : () {
                        ref.read(cookedProvider.notifier).markCooked(recipe);
                        setState(() => saved = true);
                      },
              ),
            if (step > 0 && !saved)
              TextButton(
                onPressed: () => setState(() => step--),
                child: Text(context.w('Önceki adım', 'Previous step')),
              ),
          ],
        ],
      ),
    );
  }
}
