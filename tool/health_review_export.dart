// Builds the physician review page from the health copy in the app's code.
//
//   dart run tool/health_review_export.dart
//
// Writes docs/hekim-inceleme/hekim-inceleme.html from the template next to
// this file. Every text comes from the same constants the app renders, so
// the review always covers exactly what users see; decisions are kept by
// the published page itself (artifact database), keyed by item id, with
// the reviewed Turkish text stored alongside so a later wording change
// shows up as "changed since review".
//
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:nutri_guide/core/enums.dart';
import 'package:nutri_guide/data/explore_data.dart';
import 'package:nutri_guide/data/focus_guidance.dart';
import 'package:nutri_guide/data/health_category_info.dart';
import 'package:nutri_guide/services/focus_rules.dart';

/// Suggested starting points for each claim. Names only, to be checked by
/// the reviewer; nothing here is presented to users.
const Map<String, List<String>> suggestedSources = {
  'magnesiumDeficiency': [
    'NIH Office of Dietary Supplements — Magnesium: Fact Sheet for Health Professionals',
  ],
  'ironDeficiency': [
    'NIH Office of Dietary Supplements — Iron: Fact Sheet for Health Professionals',
    'WHO — Anaemia (fact sheet)',
  ],
  'vitaminB12': [
    'NIH Office of Dietary Supplements — Vitamin B12: Fact Sheet for Health Professionals',
  ],
  'anemia': [
    'WHO — Anaemia (fact sheet)',
    'NIH Office of Dietary Supplements — Iron: Fact Sheet for Health Professionals',
  ],
  'pcos': [
    'International Evidence-based Guideline for the Assessment and Management of PCOS (2023)',
  ],
  'insulinResistance': [
    'ADA — Standards of Care in Diabetes: Facilitating Positive Health Behaviors',
  ],
  'glutenFree': [
    'ESsCD — European guideline on coeliac disease and other gluten-related disorders (2019)',
  ],
  'lactoseFree': [
    'EFSA NDA Panel — Scientific Opinion on lactose thresholds in lactose intolerance (2010)',
  ],
  'periodSupport': [
    'ACOG — Dysmenorrhea: Painful Periods (patient FAQ)',
    'NIH Office of Dietary Supplements — Magnesium; Iron',
  ],
};

const Map<CheckInType, String> focusLabelTr = {
  CheckInType.lowEnergy: 'Düşük Enerji',
  CheckInType.bloated: 'Şişkinlik',
  CheckInType.cravingSweets: 'Tatlı İsteği',
  CheckInType.cantFocus: 'Odaklanamıyorum',
  CheckInType.pms: 'PMS',
  CheckInType.periodCramps: 'Regl Krampları',
  CheckInType.periodFatigue: 'Regl Yorgunluğu',
  CheckInType.postWorkout: 'Egzersiz Sonrası',
  CheckInType.noSpecificIssue: 'İyiyim',
  CheckInType.stressed: 'Stresliyim',
  CheckInType.anxious: 'Kaygılıyım',
  CheckInType.poorSleep: 'Uykusuzum',
};

/// The proposed replacement for the current legal notice
/// (`disclaimer_screen.dart`), which says the content rests on no medical
/// source at all. Not in the app until approved.
const List<(String, String, String, String)> disclaimerDraft = [
  (
    'Genel bilgilendirme',
    'NutriGuide genel beslenme ve iyi oluş bilgisi sunar. Tanı koymaz, tedavi '
        'önermez ve bir sağlık profesyonelinin yerini tutmaz.',
    'General information',
    'NutriGuide offers general nutrition and wellbeing information. It does '
        'not diagnose, does not recommend treatment and does not replace a '
        'health professional.',
  ),
  (
    'İçerik nasıl hazırlanır',
    'Sağlık alanlarındaki açıklamalar genel kabul gören kaynaklara dayanılarak '
        'hazırlanır ve yayından önce bir hekim tarafından incelenir. Tarif '
        'önerileri, seçtiğin duruma ve tercihlere göre yapılan bir sıralamadır; '
        'kişisel bir beslenme planı değildir.',
    'How the content is prepared',
    'Explanations in the health areas are based on widely accepted sources '
        'and reviewed by a physician before publication. Recipe suggestions '
        'are a ranking by the state and preferences you choose, not a '
        'personal eating plan.',
  ),
  (
    'Alerjiler',
    'Alerjen filtresi tariflerin malzeme listesine dayanır. Hazır ürünlerde '
        'gizli içerik ya da çapraz bulaşma olabilir; ciddi bir alerjin varsa '
        'ürün etiketlerini her zaman kontrol et.',
    'Allergies',
    'The allergen filter relies on each recipe\'s ingredient list. Packaged '
        'products can contain hidden ingredients or cross-contamination; if '
        'you have a serious allergy, always check product labels.',
  ),
  (
    'Ne zaman hekime danışmalı',
    'Hamilelik, emzirme, kronik bir hastalık ya da düzenli ilaç kullanımı '
        'gibi durumlarda beslenmende büyük bir değişiklik yapmadan önce '
        'hekimine danış. Acil bir sağlık sorununda 112\'yi ara.',
    'When to see a doctor',
    'If you are pregnant, breastfeeding, have a chronic condition or take '
        'regular medication, talk to your doctor before making a big change '
        'to how you eat. In an emergency, call 112.',
  ),
];

void main() {
  final groups = <Map<String, Object?>>[];
  final items = <Map<String, Object?>>[];

  void add(
    String group,
    String id,
    String kind,
    String tr,
    String en, {
    required String claim,
    required bool shown,
    List<String> sources = const [],
  }) => items.add({
    'id': id,
    'group': group,
    'kind': kind,
    'tr': tr,
    'en': en,
    'claim': claim,
    'shown': shown,
    'sources': sources,
  });

  // Health areas, in the order users see them.
  for (final category in specialCategories) {
    final id = category.id;
    final info = healthCategoryInfo[id]!;
    groups.add({
      'id': 'cat-$id',
      'title': category.name['tr'],
      'note': 'Keşfet → Sana Özel → ${category.name['tr']}',
    });
    final sources = suggestedSources[id] ?? const <String>[];
    add(
      'cat-$id',
      'cat.$id.name',
      'Kategori adı',
      category.name['tr']!,
      category.name['en']!,
      claim: 'Kullanıcının seçtiği etiket; tıbbi iddia içermemeli.',
      shown: true,
    );
    add(
      'cat-$id',
      'cat.$id.subtitle',
      'Kart alt başlığı',
      category.subtitle['tr']!,
      category.subtitle['en']!,
      claim: 'Tariflerin neyi içerdiğini söyler, ne yaptığını değil.',
      shown: true,
    );
    add(
      'cat-$id',
      'cat.$id.summary',
      'Açıklama',
      info.summary['tr']!,
      info.summary['en']!,
      claim: 'Hangi besinlerde bulunduğu; gerekirse hekime yönlendirme.',
      shown: true,
      sources: sources,
    );
    for (var s = 0; s < info.sections.length; s++) {
      final section = info.sections[s];
      final trItems = section.items['tr']!;
      final enItems = section.items['en']!;
      for (var i = 0; i < trItems.length; i++) {
        add(
          'cat-$id',
          'cat.$id.s$s.i$i',
          section.title['tr']!,
          trItems[i],
          enItems[i],
          claim: s == 0
              ? 'Besin kaynağı listesi (içerik iddiası).'
              : 'Pratik öneri; kanıt düzeyi değerlendirilmeli.',
          shown: true,
          sources: sources,
        );
      }
    }
    final trFlags = info.redFlags['tr'] ?? const <String>[];
    final enFlags = info.redFlags['en'] ?? const <String>[];
    for (var i = 0; i < trFlags.length; i++) {
      add(
        'cat-$id',
        'cat.$id.flag$i',
        'Kırmızı bayrak',
        trFlags[i],
        enFlags[i],
        claim:
            '"Şu durumlarda hekimine başvur" altında listelenir. Onaylanana '
            'kadar ekranda değil.',
        shown: info.reviewed,
      );
    }
  }

  // The sentence under the day's recommendation.
  groups.add({
    'id': 'focus',
    'title': 'Günün önerisi: gerekçe cümleleri',
    'note':
        'Bugün sekmesi, önerilen tarifin altında. Yalnız sıralamanın '
        'yaptığını söyler.',
  });
  for (final entry in focusGuidance.entries) {
    final g = entry.value;
    final nutrient = g.nutrientTr == null
        ? ''
        : ' Tarif listesinde ${g.nutrientTr} kaynağı varsa adlarıyla eklenir '
              '(ör. "Bu tarifteki ${g.nutrientTr} kaynakları: ıspanak ve tahin.").';
    final protein = g.mentionsProteinFibre
        ? ' Tarifin verisi yüksek diyorsa "Protein ve lifi yüksek." eklenir.'
        : '';
    add(
      'focus',
      'focus.${entry.key.name}',
      'Mod: ${focusLabelTr[entry.key]}',
      g.reasonTr,
      g.reasonEn,
      claim: 'Sıralama kuralını anlatır.$nutrient$protein',
      shown: true,
    );
  }
  // The rules behind the three phase-4 moods are claims too.
  groups.add({
    'id': 'rules',
    'title': 'Yeni modlar: tarif seçme kuralları',
    'note':
        'Stresliyim, Kaygılıyım ve Uykusuzum seçildiğinde öne çıkan tarifler '
        'el ile değil, bu kurallarla seçilir. Kural ekranda yazmaz; '
        'gerekçe cümlesi yalnız “kafein içermeyen / hafif” der.',
  });
  for (final entry in focusRuleText.entries) {
    add(
      'rules',
      'rule.${entry.key.name}',
      'Kural: ${focusLabelTr[entry.key]}',
      entry.value.$1,
      entry.value.$2,
      claim:
          'Bu durumda bu özellikteki tariflerin öne alınmasının uygun olduğu.',
      shown: false,
    );
  }
  add(
    'focus',
    'focus.generic',
    'Mod seçilmediğinde',
    genericReasonTr,
    genericReasonEn,
    claim: 'Durum seçilmediğinde ya da etiketli tarif kalmadığında.',
    shown: true,
  );

  // Legal notice.
  groups.add({
    'id': 'legal',
    'title': 'Yasal uyarı (yeni taslak)',
    'note':
        'Kayıt sırasında ve Profil’de. Şu anki metin "içerik hiçbir tıbbi '
        'kaynağa dayanmaz" diyor; bu taslak onu değiştirecek.',
  });
  for (var i = 0; i < disclaimerDraft.length; i++) {
    final (trTitle, tr, _, en) = disclaimerDraft[i];
    add(
      'legal',
      'legal.$i',
      trTitle,
      tr,
      en,
      claim: 'Yasal metin; hukuki kontrol de gerekebilir.',
      shown: false,
    );
  }
  add(
    'legal',
    'legal.infoCard',
    'Sağlık kartı altı',
    'Bu bilgiler geneldir; kişisel tıbbi tavsiye yerine geçmez.',
    'General information — not a substitute for medical advice.',
    claim: 'Her sağlık alanı açıklamasının altında.',
    shown: true,
  );

  final data = {
    'generatedAt': DateTime.now().toIso8601String().substring(0, 10),
    'groups': groups,
    'items': items,
  };
  final template = File('tool/health_review/template.html').readAsStringSync();
  final json = const JsonEncoder.withIndent(' ')
      .convert(data)
      // Keep the embedded JSON from closing the script tag.
      .replaceAll('</', '<\\/');
  final out = File('docs/hekim-inceleme/hekim-inceleme.html')
    ..createSync(recursive: true)
    ..writeAsStringSync(template.replaceFirst('__REVIEW_DATA__', json));
  print('${items.length} items in ${groups.length} groups → ${out.path}');
}
