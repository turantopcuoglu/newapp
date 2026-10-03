import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../components/recipe_visual.dart';
import '../../core/theme.dart';
import '../../core/atmosphere_surface.dart';
import '../../data/mock_ingredients.dart';
import '../../data/allergens.dart';
import '../../providers/wellness_provider.dart';
import '../../providers/profile_provider.dart';
import '../../providers/inventory_provider.dart';
import '../../providers/shopping_provider.dart';
import '../../services/recipe_timing.dart';
import '../../services/recommendation_service.dart';
import '../shopping/shopping_screen.dart';
import '../planner/planner_screen.dart';
import '../recipe_book/recipe_book_screen.dart';
import '../beverages/beverages_screen.dart';
import '../explore/explore_screen.dart';
import 'moonlit_recipe_screen.dart';
import 'moonlit_assets.dart';
import 'moonlit_page.dart';
import 'wellness_ui.dart';
import 'mood_widgets.dart';
import '../../core/wellness_motion.dart';

void openWellnessRecipe(BuildContext context, ScoredRecipe recipe) =>
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => MoonlitRecipeScreen(scored: recipe),
      ),
    );

String foodName(String id, String locale, {bool prepared = false}) {
  if (prepared && id == 'chickpea') {
    return locale == 'tr' ? 'Haşlanmış nohut' : 'Cooked chickpeas';
  }
  if (prepared && id == 'bulgur') {
    return locale == 'tr' ? 'Pişmiş bulgur' : 'Cooked bulgur';
  }
  return mockIngredients
          .where((i) => i.id == id)
          .firstOrNull
          ?.localizedName(locale) ??
      id;
}

class WellnessFoodCard extends StatelessWidget {
  final ScoredRecipe scored;
  final VoidCallback? onExplore;
  final bool compact;
  const WellnessFoodCard({
    super.key,
    required this.scored,
    this.onExplore,
    this.compact = false,
  });
  @override
  Widget build(BuildContext context) {
    final p = context.palette;
    final recipe = scored.recipe;
    final title = compact
        ? context.w('Beslenme', 'Nourish')
        : recipe.localizedName(Localizations.localeOf(context).languageCode);
    final scale = MediaQuery.textScalerOf(context).scale(1);
    final h = (compact ? 170.0 : 238.0) + (scale - 1) * 86;
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: p.dividerColor, width: .8),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: recipeHeroTag(recipe.id),
                child: RecipeVisual(
                  recipe: recipe,
                  height: h,
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      p.background.withValues(alpha: .82),
                      p.background.withValues(alpha: .36),
                      p.background.withValues(alpha: 0),
                    ],
                    stops: const [0, .30, .68],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: MotionTap(
                onTap: onExplore ?? () => openWellnessRecipe(context, scored),
                builder: (context, t) => Padding(
                  padding: const EdgeInsets.all(17),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 35),
                        child: Text(
                          title,
                          maxLines: compact ? 1 : 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: compact ? 23 : 25,
                            fontWeight: FontWeight.w500,
                            height: 1.1,
                            color: p.textPrimary,
                          ),
                        ),
                      ),
                      if (compact && RecipeTiming.minutes(recipe) != null) ...[
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 17,
                              color: p.textPrimary,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              context.w(
                                '${RecipeTiming.minutes(recipe)} dk',
                                '${RecipeTiming.minutes(recipe)} min',
                              ),
                              style: TextStyle(
                                fontSize: 14,
                                color: p.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                      const Spacer(),
                      if (!compact) ...[
                        Text(
                          '${RecipeTiming.minutes(recipe) == null ? '' : context.w('${RecipeTiming.minutes(recipe)} dk · ', '${RecipeTiming.minutes(recipe)} min · ')}${context.w('Tarif görseli', 'Recipe illustration')}',
                          style: TextStyle(fontSize: 12, color: p.textPrimary),
                        ),
                        const SizedBox(height: 10),
                      ],
                      AtmosphereSurface(
                        primary: true,
                        activity: t,
                        radius: 28,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(4, 4, 14, 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Transform.translate(
                                offset: Offset(
                                  4 * (t < .5 ? t * 2 : (1 - t) * 2),
                                  0,
                                ),
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: .16),
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    color: p.onAction,
                                    size: 23,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  context.w(
                                    compact ? 'Tarifleri gör' : 'Tarife geç',
                                    compact ? 'Find recipes' : 'View recipe',
                                  ),
                                  style: TextStyle(
                                    color: p.onAction,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InfoDot(
                title: context.w('Beslenme', 'Nourish'),
                description: context.w(
                  'Tarifler alerji ve beslenme tercihlerine göre filtrelenir. Günlük durumun, hazırlık süren ve mutfağındaki besinler sıralamaya yön verir. Fotoğraflar tarif için üretilmiş temsili görsellerdir; içerik listesini tarifte görebilirsin.',
                  'Recipes are filtered for allergies and food preferences, then ordered using your check-in, available time and pantry. Photos are generated recipe illustrations; see each recipe for its ingredient list.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NourishScreen extends ConsumerWidget {
  const NourishScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipes = ref.watch(wellnessRecipesProvider);
    final profile = ref.watch(profileProvider);
    final inventory = ref.watch(inventoryIdsProvider);
    final shopping = ref.watch(shoppingProvider);
    final check = ref.watch(todayCheckInProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final chosen = recipes.firstOrNull;
    final prepared = chosen?.recipe.id == 'moonlit_bulgur_bowl';
    final ids = chosen?.recipe.ingredientIds.take(3).toList() ?? <String>[];
    final minutes = chosen == null ? null : RecipeTiming.minutes(chosen.recipe);
    void open(Widget screen) => Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => screen),
    );
    return MoonlitPage(
      header: SceneTitle(
        eyebrow: 'NutriGuide',
        title: context.w('Beslenme', 'Nourish'),
        subtitle: check?.prepMinutes != null
            ? context.w(
                '${check!.prepMinutes} dakikalık tercihine göre',
                'For your ${check.prepMinutes}-minute preference',
              )
            : context.w(
                'Tercihlerin ve mutfağına göre',
                'For your preferences and kitchen',
              ),
      ),
      children: [
        if (chosen != null) ...[
          WellnessFoodCard(scored: chosen),
          const SizedBox(height: 12),
        ],
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 14),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (prepared)
                MetricPill(
                  icon: Icons.no_food_outlined,
                  label: context.w('Süt ürünü yok', 'No dairy ingredients'),
                ),
              ...profile.allergies
                  .take(2)
                  .map(
                    (a) => MetricPill(
                      icon: Icons.shield_outlined,
                      label: context.w(
                        '${localizedAllergen(a, locale)} filtresi',
                        '${localizedAllergen(a, locale)} filter',
                      ),
                    ),
                  ),
              if (profile.allergies.isEmpty)
                MetricPill(
                  icon: Icons.tune_outlined,
                  label: context.w('Tercihlerim', 'My preferences'),
                ),
            ],
          ),
        ),
        const Divider(height: 1, thickness: .5),
        if (chosen == null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Text(
              context.w(
                'Seçimlerinle eşleşen tarif yok. Süreni veya besin seçimini değiştirebilirsin.',
                'No matching recipes. Try another time or ingredient.',
              ),
            ),
          ),
        ...ids.map((id) {
          final inPantry = inventory.contains(id);
          final name = foodName(id, locale, prepared: prepared);
          final listed = shopping.any((s) => s.name == foodName(id, locale));
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: context.palette.dividerColor.withAlpha(110),
                  width: .5,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 124,
                  height: 90,
                  child: IngredientPhoto(id: id),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          color: context.palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 3),
                      InkWell(
                        onTap: inPantry
                            ? null
                            : () {
                                if (listed) return;
                                final before = ref
                                    .read(shoppingProvider)
                                    .map((i) => i.id)
                                    .toSet();
                                ref
                                    .read(shoppingProvider.notifier)
                                    .addItem(
                                      foodName(id, locale),
                                      forRecipeId: chosen?.recipe.id,
                                    );
                                final added = ref
                                    .read(shoppingProvider)
                                    .where((i) => !before.contains(i.id))
                                    .map((i) => i.id)
                                    .toList();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      context.w(
                                        'Alışveriş listene eklendi',
                                        'Added to shopping',
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  inPantry
                                      ? context.w(
                                          'Mutfağında var',
                                          'In your kitchen',
                                        )
                                      : listed
                                      ? context.w(
                                          'Listene eklendi',
                                          'On your list',
                                        )
                                      : context.w(
                                          'Alışverişe ekle',
                                          'Add to shopping',
                                        ),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              Icon(
                                inPantry || listed
                                    ? Icons.check_circle
                                    : Icons.add_circle_outline,
                                size: 19,
                                color: inPantry || listed
                                    ? context.palette.mint
                                    : context.palette.moon,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 0,
                            ),
                            side: BorderSide(
                              color: context.palette.textSecondary.withAlpha(
                                150,
                              ),
                              width: .6,
                            ),
                            shape: const StadiumBorder(),
                          ),
                          onPressed: () =>
                              _choose(context, ref, recipes, excluded: id),
                          child: Text(
                            context.w('Değiştir', 'Change'),
                            style: TextStyle(
                              fontSize: 12,
                              color: context.palette.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
        if (chosen != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 31,
                  color: context.palette.moon,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.w('Neden bu besinler?', 'Why these foods?'),
                        style: TextStyle(
                          fontSize: 14,
                          color: context.palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prepared
                            ? context.w(
                                'Hazır malzemelerle pratik bir öğün.\nBaklagil, tahıl ve sebze bir arada.',
                                'A practical meal with prepared ingredients.\nLegumes, grains and vegetables, together.',
                              )
                            : context.w(
                                'Alerji ve tercih filtrelerine uygun. ${minutes == null ? 'Mutfağındaki malzemeler öncelikli.' : '$minutes dakikalık hazırlık.'}',
                                'Matches your allergy and preference filters. ${minutes == null ? 'Your pantry comes first.' : '$minutes-minute preparation.'}',
                              ),
                        style: const TextStyle(fontSize: 12, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          MoonButton(
            label: context.w(
              'Bu besinlerle tarif bul',
              'Find a recipe with these foods',
            ),
            onPressed: () => openWellnessRecipe(context, chosen),
          ),
        ],
        const SizedBox(height: 18),
        FineRow(
          icon: Icons.search,
          title: context.w(
            'Diğer uygun tarifleri seç',
            'Choose another matching recipe',
          ),
          onTap: () => _choose(context, ref, recipes),
        ),
        FineRow(
          icon: Icons.calendar_month_outlined,
          title: context.w('Öğün planım', 'My meal plan'),
          onTap: () => open(const PlannerScreen()),
        ),
        FineRow(
          icon: Icons.kitchen_outlined,
          title: context.w('Mutfağım ve alışveriş', 'Kitchen & shopping'),
          onTap: () => open(const ShoppingScreen()),
        ),
        FineRow(
          icon: Icons.water_drop_outlined,
          title: context.w('Su ve içecekler', 'Water & drinks'),
          onTap: () => open(const BeveragesScreen()),
        ),
        FineRow(
          icon: Icons.auto_stories_outlined,
          title: context.w('Tarif defterim', 'My recipe book'),
          onTap: () => open(const RecipeBookScreen()),
        ),
        FineRow(
          icon: Icons.explore_outlined,
          title: context.w('Tüm tarifleri keşfet', 'Explore all recipes'),
          onTap: () => open(const ExploreScreen()),
        ),
      ],
    );
  }

  void _choose(
    BuildContext context,
    WidgetRef ref,
    List<ScoredRecipe> recipes, {
    String? excluded,
  }) {
    var query = '';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => StatefulBuilder(
        builder: (sheet, update) => SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(sheet).height * .75,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Text(
                    excluded == null
                        ? context.w('Sana uygun tarifler', 'Matching recipes')
                        : context.w(
                            'Bu besin yerine başka bir öğün',
                            'Another meal without this ingredient',
                          ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    onChanged: (s) => update(() => query = s),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: context.w('Tarif ara', 'Search recipes'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: recipes
                          .where(
                            (s) =>
                                (excluded == null ||
                                    !s.recipe.ingredientIds.contains(
                                      excluded,
                                    )) &&
                                s.recipe
                                    .localizedName(
                                      Localizations.localeOf(
                                        context,
                                      ).languageCode,
                                    )
                                    .toLowerCase()
                                    .contains(query.toLowerCase()),
                          )
                          .map(
                            (s) => ListTile(
                              title: Text(
                                s.recipe.localizedName(
                                  Localizations.localeOf(context).languageCode,
                                ),
                              ),
                              subtitle: Text(
                                s.recipe.ingredientIds
                                    .take(3)
                                    .map(
                                      (id) => foodName(
                                        id,
                                        Localizations.localeOf(
                                          context,
                                        ).languageCode,
                                      ),
                                    )
                                    .join(' · '),
                              ),
                              onTap: () {
                                ref
                                    .read(wellnessRecipeChoiceProvider.notifier)
                                    .state = s
                                    .recipe
                                    .id;
                                Navigator.pop(sheet);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
