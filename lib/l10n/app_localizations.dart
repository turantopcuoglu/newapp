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
  String get homeYesterday => _t('homeYesterday');
  String get homeNoMealsForDay => _t('homeNoMealsForDay');
  String get homeMealOfDay => _t('homeMealOfDay');
  String get homeMealBreakfastTitle => _t('homeMealBreakfastTitle');
  String get homeMealLunchTitle => _t('homeMealLunchTitle');
  String get homeMealDinnerTitle => _t('homeMealDinnerTitle');
  String get homeMealSnackTitle => _t('homeMealSnackTitle');
  String get homeMealRecipeCount => _t('homeMealRecipeCount');
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
  String get checkInPeriodCramps => _t('checkInPeriodCramps');
  String get checkInPeriodFatigue => _t('checkInPeriodFatigue');
  String get checkInPeriodSection => _t('checkInPeriodSection');
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

  // Onboarding
  String get onboardingWelcome => _t('onboardingWelcome');
  String get onboardingWelcomeSubtitle => _t('onboardingWelcomeSubtitle');
  String get onboardingNameHint => _t('onboardingNameHint');
  String get onboardingNameLabel => _t('onboardingNameLabel');
  String get onboardingGenderTitle => _t('onboardingGenderTitle');
  String get onboardingGenderSubtitle => _t('onboardingGenderSubtitle');
  String get onboardingMale => _t('onboardingMale');
  String get onboardingFemale => _t('onboardingFemale');
  String get onboardingOther => _t('onboardingOther');
  String get onboardingContinue => _t('onboardingContinue');
  String get onboardingNameRequired => _t('onboardingNameRequired');
  String get onboardingGenderRequired => _t('onboardingGenderRequired');

  // Ingredient categories
  String get catAll => _t('catAll');
  String get catDairy => _t('catDairy');
  String get catGrain => _t('catGrain');
  String get catVegetable => _t('catVegetable');
  String get catFruit => _t('catFruit');
  String get catSpice => _t('catSpice');
  String get catOil => _t('catOil');
  String get catNut => _t('catNut');
  String get catLegume => _t('catLegume');
  String get catCondiment => _t('catCondiment');
  String get catOther => _t('catOther');

  // Ingredient selector
  String get ingredientSelect => _t('ingredientSelect');
  String get ingredientAddBtn => _t('ingredientAddBtn');
  String get ingredientSelected => _t('ingredientSelected');
  String get ingredientServing => _t('ingredientServing');
  String ingredientAddCount(int count) =>
      _t('ingredientAddCount').replaceFirst('{count}', count.toString());
  String get ingredientNone => _t('ingredientNone');
  String get ingredientGram => _t('ingredientGram');

  // Live nutrition
  String get nutritionLive => _t('nutritionLive');
  String get nutritionTotal => _t('nutritionTotal');
  String get recipeFat => _t('recipeFat');

  // Ingredient categories (new)
  String get catSnackFood => _t('catSnackFood');
  String get catBeverage => _t('catBeverage');

  // Beverages
  String get beverageTitle => _t('beverageTitle');
  String get beverageWater => _t('beverageWater');
  String get beverageTea => _t('beverageTea');
  String get beverageCoffee => _t('beverageCoffee');
  String get beverageJuice => _t('beverageJuice');
  String get beverageSoda => _t('beverageSoda');
  String get beverageMilk => _t('beverageMilk');
  String get beverageSmoothie => _t('beverageSmoothie');
  String get beverageOther => _t('beverageOther');
  String get beverageAddDrink => _t('beverageAddDrink');
  String get beverageTodayWater => _t('beverageTodayWater');
  String get beverageTodayCalories => _t('beverageTodayCalories');
  String get beverageTarget => _t('beverageTarget');
  String get beverageSelectAmount => _t('beverageSelectAmount');
  String get beverageCustomAmount => _t('beverageCustomAmount');
  String get beverageMl => _t('beverageMl');
  String get beverageGlasses => _t('beverageGlasses');
  String get beverageNoEntries => _t('beverageNoEntries');
  String get beverageLiters => _t('beverageLiters');
  String get navBeverages => _t('navBeverages');

  // Nutrition Stats
  String get nutritionStatsTitle => _t('nutritionStatsTitle');
  String get nutritionPeriodDaily => _t('nutritionPeriodDaily');
  String get nutritionPeriodWeekly => _t('nutritionPeriodWeekly');
  String get nutritionPeriodMonthly => _t('nutritionPeriodMonthly');
  String get nutritionTotalCalories => _t('nutritionTotalCalories');
  String get nutritionMacroBreakdown => _t('nutritionMacroBreakdown');
  String get nutritionProteinRatio => _t('nutritionProteinRatio');
  String get nutritionCarbsRatio => _t('nutritionCarbsRatio');
  String get nutritionFatRatio => _t('nutritionFatRatio');
  String get nutritionFiberTotal => _t('nutritionFiberTotal');
  String get nutritionMealsCount => _t('nutritionMealsCount');
  String get nutritionBeverageCals => _t('nutritionBeverageCals');
  String get nutritionWaterIntake => _t('nutritionWaterIntake');
  String get nutritionNoData => _t('nutritionNoData');

  // Health Tips
  String get healthTipTitle => _t('healthTipTitle');
  String get healthTipMoodTitle => _t('healthTipMoodTitle');
  String get healthTipReadMore => _t('healthTipReadMore');

  // Time picker
  String get plannerSelectTime => _t('plannerSelectTime');
  String get plannerTimeOptional => _t('plannerTimeOptional');
  String get plannerSkipTime => _t('plannerSkipTime');

  // Recipes section
  String get recipesBuiltIn => _t('recipesBuiltIn');
  String get recipesExplore => _t('recipesExplore');
  String get recipesAll => _t('recipesAll');
  String get recipesFilterByType => _t('recipesFilterByType');

  // Recipe Book
  String get recipeBookTitle => _t('recipeBookTitle');
  String get recipeBookSearch => _t('recipeBookSearch');
  String get recipeBookAll => _t('recipeBookAll');
  String get recipeBookMyRecipes => _t('recipeBookMyRecipes');
  String get recipeBookEmpty => _t('recipeBookEmpty');
  String get recipeBookMyRecipesEmpty => _t('recipeBookMyRecipesEmpty');
  String get recipeBookTotalRecipes => _t('recipeBookTotalRecipes');
  String get recipeBookAddToPlanner => _t('recipeBookAddToPlanner');
  String get recipeBookViewRecipe => _t('recipeBookViewRecipe');
  String get recipeBookDeleteConfirm => _t('recipeBookDeleteConfirm');

  // Mode Selection
  String get modeSelectionTitle => _t('modeSelectionTitle');
  String get modeSelectionSubtitle => _t('modeSelectionSubtitle');
  String get modeGeneralSection => _t('modeGeneralSection');
  String get modeDescLowEnergy => _t('modeDescLowEnergy');
  String get modeDescBloated => _t('modeDescBloated');
  String get modeDescCravingSweets => _t('modeDescCravingSweets');
  String get modeDescCantFocus => _t('modeDescCantFocus');
  String get modeDescPostWorkout => _t('modeDescPostWorkout');
  String get modeDescFeelingBalanced => _t('modeDescFeelingBalanced');
  String get modeDescNoSpecificIssue => _t('modeDescNoSpecificIssue');
  String get modeDescPms => _t('modeDescPms');
  String get modeDescPeriodCramps => _t('modeDescPeriodCramps');
  String get modeDescPeriodFatigue => _t('modeDescPeriodFatigue');

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
