import '../core/enums.dart';

/// What the app tells the user about a check-in choice: why the recommended
/// recipe was put first, and which small steps fit the day.
///
/// This is health-adjacent copy, so it is kept here as data, in one place,
/// for the physician review (roadmap phase 4). Until an entry is reviewed it
/// stays deliberately modest: it says what the app *prioritised*, never what
/// the user lacks or what a food will fix. No deficiency, diagnosis or
/// treatment wording — that is the line between a wellness app and a
/// medical device.
///
/// The reason may only describe what the app checked. An earlier draft said
/// "warm, light recipes" for cramps and the top pick was a cold tuna
/// sandwich: the tag was right, the adjectives were invented. Anything
/// specific about the recipe is now derived from its own data — see
/// [nutrientSource] and [mentionsProteinFibre].
class FocusGuidance {
  final CheckInType focus;

  /// One sentence shown under the recommendation, about the ranking only.
  final String reasonTr, reasonEn;

  /// When set, the sentence goes on to name the recipe's own ingredients
  /// that appear in this condition's list in `healthConditionIngredients`
  /// ("…magnesium sources in this recipe: spinach and tahini").
  final HealthCondition? nutrientSource;
  final String? nutrientTr, nutrientEn;

  /// Adds "high in protein / fibre" when the recipe's levels say so.
  final bool mentionsProteinFibre;

  /// Small steps for the day, in order. Routine ids from `routineLibrary`
  /// plus `water`.
  final List<String> steps;

  /// Set once the physician has signed the entry off (with the date in
  /// [reviewNote]); the UI may then show a "reviewed" mark.
  final bool reviewed;
  final String? reviewNote;

  const FocusGuidance({
    required this.focus,
    required this.reasonTr,
    required this.reasonEn,
    required this.steps,
    this.nutrientSource,
    this.nutrientTr,
    this.nutrientEn,
    this.mentionsProteinFibre = false,
    this.reviewed = false,
    this.reviewNote,
  });

  String reason(String locale) => locale == 'tr' ? reasonTr : reasonEn;
}

const Map<CheckInType, FocusGuidance> focusGuidance = {
  CheckInType.lowEnergy: FocusGuidance(
    focus: CheckInType.lowEnergy,
    reasonTr:
        'Enerjin düşük dediğin için düşük enerjili günlere uygun işaretlenen '
        'tarifleri öne aldık.',
    reasonEn:
        'You said your energy is low, so recipes marked for low-energy days '
        'come first.',
    mentionsProteinFibre: true,
    steps: ['walk', 'water'],
  ),
  CheckInType.bloated: FocusGuidance(
    focus: CheckInType.bloated,
    reasonTr:
        'Şişkinlik hissettiğin için bu durumda tercih edilmek üzere '
        'işaretlenen tarifleri öne aldık.',
    reasonEn: 'You feel bloated, so recipes marked for days like this come first.',
    steps: ['walk', 'breathe'],
  ),
  CheckInType.cravingSweets: FocusGuidance(
    focus: CheckInType.cravingSweets,
    reasonTr:
        'Tatlı isteği için işaretlenen, daha dengeli tatlı seçeneklerini öne '
        'aldık.',
    reasonEn:
        'For a sweet craving, more balanced sweet options marked for it come '
        'first.',
    mentionsProteinFibre: true,
    steps: ['water', 'walk'],
  ),
  CheckInType.cantFocus: FocusGuidance(
    focus: CheckInType.cantFocus,
    reasonTr:
        'Odaklanmakta zorlandığın günler için işaretlenen tarifleri öne aldık.',
    reasonEn: 'Recipes marked for days when focusing is hard come first.',
    steps: ['breathe', 'walk'],
  ),
  CheckInType.pms: FocusGuidance(
    focus: CheckInType.pms,
    reasonTr: 'Regl öncesi dönem için işaretlenen tarifleri öne aldık.',
    reasonEn: 'Recipes marked for the days before your period come first.',
    nutrientSource: HealthCondition.magnesiumDeficiency,
    nutrientTr: 'magnezyum',
    nutrientEn: 'magnesium',
    steps: ['stretch', 'breathe'],
  ),
  CheckInType.periodCramps: FocusGuidance(
    focus: CheckInType.periodCramps,
    reasonTr: 'Regl krampı için işaretlenen tarifleri öne aldık.',
    reasonEn: 'Recipes marked for period cramps come first.',
    nutrientSource: HealthCondition.magnesiumDeficiency,
    nutrientTr: 'magnezyum',
    nutrientEn: 'magnesium',
    steps: ['stretch', 'breathe'],
  ),
  CheckInType.periodFatigue: FocusGuidance(
    focus: CheckInType.periodFatigue,
    reasonTr: 'Regl yorgunluğu için işaretlenen tarifleri öne aldık.',
    reasonEn: 'Recipes marked for period tiredness come first.',
    nutrientSource: HealthCondition.ironDeficiency,
    nutrientTr: 'demir',
    nutrientEn: 'iron',
    steps: ['breathe', 'mindful'],
  ),
  CheckInType.postWorkout: FocusGuidance(
    focus: CheckInType.postWorkout,
    reasonTr: 'Egzersiz sonrası için işaretlenen tarifleri öne aldık.',
    reasonEn: 'Recipes marked for after a workout come first.',
    mentionsProteinFibre: true,
    steps: ['stretch', 'water'],
  ),
  CheckInType.noSpecificIssue: FocusGuidance(
    focus: CheckInType.noSpecificIssue,
    reasonTr:
        'Belirli bir şikâyetin olmadığı günler için işaretlenen tarifleri öne '
        'aldık.',
    reasonEn: 'Recipes marked for an ordinary, easy day come first.',
    steps: ['walk', 'breathe'],
  ),
};

/// Shown when there is no check-in, or the recipe that came first does not
/// carry the day's tag (filters left nothing that matches). Saying "we
/// prioritised X" there would be untrue.
const String genericReasonTr =
    'Alerji ve beslenme tercihlerine uyan tarifler arasından, mutfağındaki '
    'malzemelere en yakın olanı öne aldık.';
const String genericReasonEn =
    'Among recipes that fit your allergies and food preferences, the one '
    'closest to what is in your kitchen comes first.';
