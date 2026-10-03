import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../providers/profile_provider.dart';
import '../../providers/wellness_provider.dart';
import '../../data/allergens.dart';
import '../settings_screen.dart';
import 'health_connections_screen.dart';
import '../../components/health_condition_chips.dart';
import 'wellness_ui.dart';
import 'mood_widgets.dart';
import 'mood_picker_screen.dart';
import 'moonlit_page.dart';
import '../../data/mock_ingredients.dart';

class WellnessProfileScreen extends ConsumerWidget {
  const WellnessProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final data = ref.watch(wellnessProvider);
    final locale = Localizations.localeOf(context).languageCode;
    void settings() => Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
    );
    Widget line(
      String title,
      String value,
      VoidCallback action, {
      IconData? icon,
    }) => FineRow(
      icon: icon,
      title: title,
      onTap: action,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 136,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                color: context.palette.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 20),
        ],
      ),
    );
    String labels(List<String> values) => values.isEmpty
        ? context.w('Belirtmedin', 'Not specified')
        : values.join(' · ');
    return MoonlitPage(
      header: SceneTitle(
        title: context.w('Profilin', 'Your profile'),
        moon: false,
      ),
      children: [
        FeatureGrid(
          height: 142,
          children: [
            FeatureTile(
              title: context.w('Atmosfer', 'Atmosphere'),
              kind: context.palette.icon,
              info: context.w(
                'Dokuz atmosfer arasından seçim yap. Görünümü sabitleyebilir ya da günlük durumunu izlemesini seçebilirsin.',
                'Choose from nine atmospheres. Keep a fixed appearance or let it follow your daily check-in.',
              ),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const MoodPickerScreen(appearanceOnly: true),
                ),
              ),
            ),
            FeatureTile(
              title: context.w('Tercihlerim', 'Preferences'),
              kind: 'settings',
              onTap: settings,
            ),
            FeatureTile(
              title: context.w('Sağlık verileri', 'Health data'),
              kind: 'heart',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const HealthConnectionsScreen(),
                ),
              ),
            ),
            // Replaces a goal picker whose answers nothing ever read.
            FeatureTile(
              title: context.w('Sağlık durumum', 'My health'),
              kind: 'leaf',
              detail: profile.healthConditions.isEmpty
                  ? context.w('Belirtmedin', 'Not specified')
                  : context.w(
                      '${profile.healthConditions.length} seçili',
                      '${profile.healthConditions.length} selected',
                    ),
              onTap: () => showHealthConditionSheet(context),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: context.palette.mint,
                child: Text(
                  profile.name?.trim().isNotEmpty == true
                      ? profile.name!.trim().characters.first.toUpperCase()
                      : 'N',
                  style: TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.w300,
                    color: context.palette.background,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name?.isNotEmpty == true
                          ? profile.name!
                          : context.w('Hoş geldin', 'Welcome'),
                      style: TextStyle(
                        fontSize: 23,
                        color: context.palette.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        WellnessCard(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          child: Column(
            children: [
              line(
                context.w('Alerjiler', 'Allergies'),
                labels(
                  profile.allergies
                      .map((a) => localizedAllergen(a, locale))
                      .toList(),
                ),
                () => _allergies(context, ref),
              ),
              line(
                context.w('Hassasiyetler', 'Sensitivities'),
                profile.intolerances.contains('lactose')
                    ? context.w('Laktoz intoleransı', 'Lactose intolerance')
                    : context.w('Belirtmedin', 'Not specified'),
                () => _sensitivity(context, ref),
              ),
              line(
                context.w('Beslenme tercihleri', 'Food preferences'),
                labels(
                  profile.dietPreferences
                      .map(
                        (v) => switch (v) {
                          'vegan' => context.w('Vegan', 'Vegan'),
                          'vegetarian' => context.w('Vejetaryen', 'Vegetarian'),
                          'dairyFree' => context.w(
                            'Süt ürünü tüketmiyorum',
                            'No dairy',
                          ),
                          'glutenFree' => context.w('Glutensiz', 'Gluten-free'),
                          _ => v,
                        },
                      )
                      .toList(),
                ),
                settings,
              ),
              line(
                context.w('Sevmediklerim', 'Dislikes'),
                labels(
                  profile.dislikedIngredients
                      .map(
                        (id) =>
                            mockIngredients
                                .where((i) => i.id == id)
                                .firstOrNull
                                ?.localizedName(locale) ??
                            id,
                      )
                      .toList(),
                ),
                settings,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text(
          context.w('Verilerin ve izinlerin', 'Your data & permissions'),
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 9),
        WellnessCard(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
          child: Column(
            children: [
              line(
                context.w('Sağlık bağlantıları', 'Health connections'),
                data.health == null
                    ? context.w('Bağlı değil', 'Not connected')
                    : data.health!.platform,
                () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const HealthConnectionsScreen(),
                  ),
                ),
                icon: Icons.monitor_heart_outlined,
              ),
              line(
                context.w('Bildirimler', 'Notifications'),
                context.w('Tercihlerini düzenle', 'Manage preferences'),
                settings,
                icon: Icons.notifications_none_outlined,
              ),
              FineRow(
                icon: Icons.ios_share_outlined,
                title: context.w('Verilerini dışa aktar', 'Export your data'),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () => _export(context, ref),
              ),
              FineRow(
                icon: Icons.delete_outline,
                title: context.w('Kayıtlarını sil', 'Delete your records'),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: () => _delete(context, ref),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Icon(Icons.link, size: 21, color: context.palette.textSecondary),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  context.w(
                    'Sağlık bağlantısı olmadan da kullanabilirsin.',
                    'You can use it without a health connection.',
                  ),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        FineRow(
          icon: Icons.person_outline,
          title: context.w(
            'Profil ve beslenme tercihlerim',
            'Profile & food preferences',
          ),
          onTap: settings,
        ),
        FineRow(
          icon: Icons.shield_outlined,
          title: context.w('Sağlık verisi kullanımı', 'Health data use'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const HealthPrivacyScreen(),
            ),
          ),
        ),
      ],
    );
  }

  void _allergies(BuildContext context, WidgetRef ref) {
    final selected = ref.read(profileProvider).allergies.toSet();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => StatefulBuilder(
        builder: (sheet, update) => SafeArea(
          child: SizedBox(
            height: MediaQuery.sizeOf(sheet).height * .72,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Text(
                    context.w('Alerjilerin', 'Your allergies'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView(
                      children: allergenLabels.keys
                          .map(
                            (key) => CheckboxListTile(
                              title: Text(
                                localizedAllergen(
                                  key,
                                  Localizations.localeOf(context).languageCode,
                                ),
                              ),
                              value: selected.contains(key),
                              onChanged: (on) => update(() {
                                on == true
                                    ? selected.add(key)
                                    : selected.remove(key);
                              }),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  MoonButton(
                    label: context.w('Seçimlerimi kaydet', 'Save my choices'),
                    onPressed: () {
                      ref
                          .read(profileProvider.notifier)
                          .updateAllergies(selected.toList());
                      Navigator.pop(sheet);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _sensitivity(BuildContext context, WidgetRef ref) {
    var selected = ref.read(profileProvider).intolerances.contains('lactose');
    showModalBottomSheet<void>(
      context: context,
      builder: (sheet) => StatefulBuilder(
        builder: (sheet, update) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.w(
                    'Hassasiyet / intolerans',
                    'Sensitivity / intolerance',
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                CheckboxListTile(
                  title: Text(
                    context.w('Laktoz intoleransı', 'Lactose intolerance'),
                  ),
                  value: selected,
                  onChanged: (on) => update(() => selected = on == true),
                ),
                Text(
                  context.w(
                    'Süt alerjisi ayrı bir seçimdir. Laktoz miktarı bilinmeyen sütlü tarifler intoleransta da elenir.',
                    'Milk allergy is a separate choice. Dairy recipes with unknown lactose content are also excluded for intolerance.',
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 20),
                MoonButton(
                  label: context.w('Seçimimi kaydet', 'Save my choice'),
                  onPressed: () {
                    ref
                        .read(profileProvider.notifier)
                        .updateIntolerances(selected ? ['lactose'] : []);
                    Navigator.pop(sheet);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _export(BuildContext context, WidgetRef ref) {
    final json = const JsonEncoder.withIndent(
      '  ',
    ).convert(ref.read(wellnessProvider).toJson());
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(sheet).height * .7,
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                Text(
                  context.w(
                    'İyi oluş kayıtların · JSON',
                    'Wellbeing records · JSON',
                  ),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  context.w(
                    'Bu çıktı günlük durum, uyku, rutin ve içe aktardığın cihaz kayıtlarını içerir.',
                    'This export contains check-ins, sleep, routines and imported device records.',
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      json,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                MoonButton(
                  label: context.w('JSON verisini kopyala', 'Copy JSON data'),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: json));
                    if (sheet.mounted) Navigator.pop(sheet);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(
          context.w(
            'İyi oluş kayıtları silinsin mi?',
            'Delete wellbeing records?',
          ),
        ),
        content: Text(
          context.w(
            'Günlük durumların, uyku günlüğün, rutinlerin, alışkanlıkların ve içe aktarılan cihaz kayıtların silinir. Tariflerin, mutfağın, beslenme kayıtların ve profilin korunur. Üretici hesabındaki veriler silinmez.',
            'Your check-ins, sleep journal, routines, habits and imported device records will be deleted. Recipes, kitchen, food records and profile are kept. Provider records are not deleted.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(context.w('Vazgeç', 'Cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(context.w('Kayıtları sil', 'Delete records')),
          ),
        ],
      ),
    );
    if (yes == true && context.mounted) {
      await saveWellness(
        context,
        () => ref.read(wellnessProvider.notifier).deleteAll(),
      );
    }
  }
}
