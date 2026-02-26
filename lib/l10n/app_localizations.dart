import 'package:flutter/widgets.dart';
import 'translations/en.dart';
import 'translations/tr.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('tr'),
  ];

  static final Map<String, Map<String, String>> _translations = {
    'en': enTranslations,
    'tr': trTranslations,
  };

  String _t(String key) =>
      _translations[locale.languageCode]?[key] ??
      _translations['en']?[key] ??
      key;

  // App
  String get appName => _t('appName');

  // Navigation
  String get navHome => _t('navHome');
  String get navPlanner => _t('navPlanner');
  String get navShopping => _t('navShopping');
  String get navMyRecipes => _t('navMyRecipes');
  String get navProfile => _t('navProfile');

  // Home
  String get homeGreeting => _t('homeGreeting');
  String get homeGreetingMorning => _t('homeGreetingMorning');
  String get homeGreetingAfternoon => _t('homeGreetingAfternoon');
  String get homeGreetingEvening => _t('homeGreetingEvening');
  String get homeHowAreYou => _t('homeHowAreYou');
  String get homeCheckIn => _t('homeCheckIn');
  String get homeChangeCheckIn => _t('homeChangeCheckIn');
  String get homeRecommendations => _t('homeRecommendations');
  String get homeNoCheckIn => _t('homeNoCheckIn');
  String get homeStartCheckIn => _t('homeStartCheckIn');
  String get homeKitchenInventory => _t('homeKitchenInventory');
  String get homeKitchenEmpty => _t('homeKitchenEmpty');
  String get homeItemsInKitchen => _t('homeItemsInKitchen');
  String get homeManageInventory => _t('homeManageInventory');
  String get homeYesterdayNutrition => _t('homeYesterdayNutrition');
  String get homeYesterdayMeals => _t('homeYesterdayMeals');
  String get homeNoMealsYesterday => _t('homeNoMealsYesterday');
  String get homeMealOfDay => _t('homeMealOfDay');
  String get homeQuickActions => _t('homeQuickActions');
  String get homeFat => _t('homeFat');

  // Check-in
  String get checkInTitle => _t('checkInTitle');
  String get checkInSubtitle => _t('checkInSubtitle');
  String get checkInLowEnergy => _t('checkInLowEnergy');
  String get checkInBloated => _t('checkInBloated');
  String get checkInCravingSweets => _t('checkInCravingSweets');
  String get checkInCantFocus => _t('checkInCantFocus');
  String get checkInPms => _t('checkInPms');
  String get checkInPostWorkout => _t('checkInPostWorkout');
  String get checkInFeelingBalanced => _t('checkInFeelingBalanced');
  String get checkInNoSpecificIssue => _t('checkInNoSpecificIssue');
  String get checkInDone => _t('checkInDone');

  // Recipes
  String get recipeBreakfast => _t('recipeBreakfast');
  String get recipeLunch => _t('recipeLunch');
  String get recipeDinner => _t('recipeDinner');
  String get recipeSnack => _t('recipeSnack');
  String get recipeIngredients => _t('recipeIngredients');
  String get recipeSteps => _t('recipeSteps');
  String get recipeNutrition => _t('recipeNutrition');
  String get recipeProtein => _t('recipeProtein');
  String get recipeFiber => _t('recipeFiber');
  String get recipeCarbs => _t('recipeCarbs');
  String get recipeCalories => _t('recipeCalories');
  String get recipeAddToPlanner => _t('recipeAddToPlanner');
  String get recipeAddMissing => _t('recipeAddMissing');
  String get recipeCompatibility => _t('recipeCompatibility');
  String get recipeNoResults => _t('recipeNoResults');

  // Planner
  String get plannerTitle => _t('plannerTitle');
  String get plannerEmpty => _t('plannerEmpty');
  String get plannerAddMeal => _t('plannerAddMeal');
  String get plannerSelectRecipe => _t('plannerSelectRecipe');
  String get plannerSelectDate => _t('plannerSelectDate');
  String get plannerSelectMealType => _t('plannerSelectMealType');
  String get plannerWeekOf => _t('plannerWeekOf');
  String get plannerToday => _t('plannerToday');

  // Shopping
  String get shoppingTitle => _t('shoppingTitle');
  String get shoppingEmpty => _t('shoppingEmpty');
  String get shoppingAddItem => _t('shoppingAddItem');
  String get shoppingClearPurchased => _t('shoppingClearPurchased');
  String get shoppingMoveToKitchen => _t('shoppingMoveToKitchen');
  String get shoppingItemHint => _t('shoppingItemHint');

  // My Recipes
  String get myRecipesTitle => _t('myRecipesTitle');
  String get myRecipesEmpty => _t('myRecipesEmpty');
  String get myRecipesCreate => _t('myRecipesCreate');
  String get myRecipesName => _t('myRecipesName');
  String get myRecipesDescription => _t('myRecipesDescription');
  String get myRecipesMealType => _t('myRecipesMealType');
  String get myRecipesIngredients => _t('myRecipesIngredients');
  String get myRecipesSteps => _t('myRecipesSteps');
  String get myRecipesTags => _t('myRecipesTags');
  String get myRecipesSave => _t('myRecipesSave');

  // Profile
  String get profileTitle => _t('profileTitle');
  String get profileAge => _t('profileAge');
  String get profileWeight => _t('profileWeight');
  String get profileHeight => _t('profileHeight');
  String get profileGender => _t('profileGender');
  String get profileGenderMale => _t('profileGenderMale');
  String get profileGenderFemale => _t('profileGenderFemale');
  String get profileGenderOther => _t('profileGenderOther');
  String get profileActivityLevel => _t('profileActivityLevel');
  String get profileAllergies => _t('profileAllergies');
  String get profileDisliked => _t('profileDisliked');
  String get profileLanguage => _t('profileLanguage');
  String get profileSave => _t('profileSave');
  String get profileSaved => _t('profileSaved');

  // Inventory
  String get inventoryTitle => _t('inventoryTitle');
  String get inventoryEmpty => _t('inventoryEmpty');
  String get inventoryAdd => _t('inventoryAdd');
  String get inventorySearch => _t('inventorySearch');
  String get inventoryCategories => _t('inventoryCategories');

  // Summary
  String get summaryTitle => _t('summaryTitle');
  String get summaryDaily => _t('summaryDaily');
  String get summaryWeekly => _t('summaryWeekly');
  String get summaryMonthly => _t('summaryMonthly');
  String get summaryMealsLogged => _t('summaryMealsLogged');
  String get summaryMealDistribution => _t('summaryMealDistribution');
  String get summaryProteinLevels => _t('summaryProteinLevels');
  String get summaryFiberLevels => _t('summaryFiberLevels');
  String get summaryCarbBalance => _t('summaryCarbBalance');
  String get summaryTopIngredients => _t('summaryTopIngredients');

  // Nutrient levels
  String get levelLow => _t('levelLow');
  String get levelMedium => _t('levelMedium');
  String get levelHigh => _t('levelHigh');

  // Carb types
  String get carbSimple => _t('carbSimple');
  String get carbComplex => _t('carbComplex');
  String get carbMixed => _t('carbMixed');

  // General
  String get save => _t('save');
  String get cancel => _t('cancel');
  String get delete => _t('delete');
  String get edit => _t('edit');
  String get add => _t('add');
  String get remove => _t('remove');
  String get search => _t('search');
  String get done => _t('done');
  String get close => _t('close');
  String get confirm => _t('confirm');
  String get noData => _t('noData');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'tr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
