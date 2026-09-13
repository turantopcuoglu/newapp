import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme.dart';
import '../../providers/wellness_provider.dart';
import '../../services/health_connection_service.dart';
import 'wellness_ui.dart';

final healthConnectionProvider = Provider<HealthConnectionService>(
  (ref) => HealthConnectionService(),
);

class HealthConnectionsScreen extends ConsumerStatefulWidget {
  const HealthConnectionsScreen({super.key});
  @override
  ConsumerState<HealthConnectionsScreen> createState() =>
      _HealthConnectionsState();
}

class _HealthConnectionsState extends ConsumerState<HealthConnectionsScreen> {
  late Set<String> scopes;
  bool busy = false;
  String? message;
  @override
  void initState() {
    super.initState();
    scopes = ref.read(wellnessProvider).healthScopes.toSet();
  }

  Future<void> sync() async {
    setState(() {
      busy = true;
      message = null;
    });
    try {
      final service = ref.read(healthConnectionProvider);
      await service.authorize(scopes.toList());
      final result = await service.read(scopes.toList());
      await ref
          .read(wellnessProvider.notifier)
          .update(
            (s) => s.copyWith(
              health: result,
              healthEnabled: true,
              healthScopes: scopes.toList(),
            ),
          );
      if (mounted) {
        setState(
          () => message = result.steps.isEmpty && result.intervals.isEmpty
              ? context.w(
                  'Okuma tamamlandı, seçilen alanlarda kayıt bulunamadı. Sağlık uygulamandaki veri ve izinleri kontrol edebilirsin.',
                  'Read completed, but no records were found in the selected areas. Check data and permissions in your health app.',
                )
              : result.unavailable.isNotEmpty
              ? context.w(
                  'Bazı alanlar okunamadı. Alınabilen kayıtlar güncellendi.',
                  'Some areas could not be read. Available records were updated.',
                )
              : context.w(
                  'Seçtiğin alanlar güncellendi.',
                  'Your selected areas are up to date.',
                ),
        );
      }
    } on HealthUnavailable {
      if (mounted) {
        setState(
          () => message = context.w(
            'Bu cihazda sağlık merkezi kullanılamıyor. Android’de Health Connect’in kurulu ve güncel olduğundan emin ol.',
            'Health data is unavailable on this device. On Android, check that Health Connect is installed and up to date.',
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => message = context.w(
            'Eşitleme tamamlanamadı. Önceki kayıtların korundu. İzinleri kontrol edip tekrar deneyebilirsin.',
            'Sync did not complete. Your previous records are preserved. Check permissions and try again.',
          ),
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(wellnessProvider);
    final service = ref.watch(healthConnectionProvider);
    final health = data.health;
    return Scaffold(
      appBar: AppBar(
        title: Text(context.w('Sağlık bağlantılarım', 'My health connections')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MoonlitSky(
              height: 120,
              child: Center(
                child: Icon(
                  Icons.watch_outlined,
                  size: 48,
                  color: context.palette.mint,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              context.w(
                'Verilerin,\nsenin kontrolünde.',
                'Your data,\nyour choice.',
              ),
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 12),
            Text(
              context.w(
                'Saatin veya yüzüğünün telefonundaki sağlık merkezine aktardığı kayıtları kullan. Yalnız aşağıda seçtiğin alanlar okunur; bu sürüm dışarıya sağlık kaydı yazmaz.',
                'Use records your watch or ring shares with your phone’s health hub. Only the areas selected below are read; this version does not write health records.',
              ),
            ),
            const SizedBox(height: 20),
            WellnessCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.supported
                        ? service.platformName
                        : context.w(
                            'Mobil sağlık bağlantısı',
                            'Mobile health connection',
                          ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    !service.supported
                        ? context.w(
                            'Apple Health iPhone’da, Health Connect Android’de kullanılabilir. Burada manuel kayıtlarla devam edebilirsin.',
                            'Apple Health is available on iPhone and Health Connect on Android. You can use manual records here.',
                          )
                        : health == null
                        ? context.w(
                            'Henüz kayıt alınmadı.',
                            'No records imported yet.',
                          )
                        : '${context.w('Son okuma', 'Last read')}: ${DateFormat('dd.MM.yyyy HH:mm').format(health.syncedAt.toLocal())}',
                  ),
                  const SizedBox(height: 12),
                  ...[
                    (
                      'sleep',
                      context.w('Uyku', 'Sleep'),
                      context.w('Süre ve uyku düzeni', 'Duration and routine'),
                    ),
                    (
                      'steps',
                      context.w('Adım', 'Steps'),
                      context.w(
                        'Günlük toplam; kaynaklar tekrar toplanmaz',
                        'Daily totals, without adding duplicate sources',
                      ),
                    ),
                    (
                      'workout',
                      context.w('Antrenman', 'Workouts'),
                      context.w(
                        'Oturum süreleri; konum alınmaz',
                        'Session duration; no location is collected',
                      ),
                    ),
                  ].map(
                    (scope) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(scope.$2),
                      subtitle: Text(scope.$3),
                      value: scopes.contains(scope.$1),
                      onChanged: busy
                          ? null
                          : (on) => setState(() {
                              on == true
                                  ? scopes.add(scope.$1)
                                  : scopes.remove(scope.$1);
                            }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: busy || !service.supported || scopes.isEmpty
                          ? null
                          : sync,
                      icon: busy
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.sync),
                      label: Text(
                        busy
                            ? context.w(
                                'Kayıtlar okunuyor…',
                                'Reading records…',
                              )
                            : context.w(
                                'Seçilen alanları bağla / yenile',
                                'Connect / refresh selected areas',
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Semantics(liveRegion: true, child: Text(message!)),
            ],
            const SizedBox(height: 16),
            Text(
              context.w(
                'Bugün ve önceki 7 gün okunur. Otomatik arka plan takibi yapılmaz. Saatin veya yüzüğün önce kendi uygulamasıyla eşitlenmelidir.',
                'Today and the previous 7 days are read. There is no automatic background monitoring. Your watch or ring must sync with its own app first.',
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (health != null) ...[
              WellnessSection(
                context.w('Veri kaynakların', 'Your data sources'),
              ),
              ...['sleep', 'workout'].map((kind) {
                final sources = health.sources(kind);
                final preferred = kind == 'sleep'
                    ? data.sleepSource
                    : data.workoutSource;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        kind == 'sleep'
                            ? context.w('Uyku kaynağı', 'Sleep source')
                            : context.w('Antrenman kaynağı', 'Workout source'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (sources.isEmpty)
                        Text(
                          context.w(
                            'Bu alanda kayıt bulunamadı.',
                            'No records in this area.',
                          ),
                        ),
                      ...sources.map(
                        (source) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            source,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Icon(
                            health.sourceFor(kind, preferred) == source
                                ? Icons.check_circle
                                : Icons.circle_outlined,
                            color: context.palette.mint,
                          ),
                          onTap: busy
                              ? null
                              : () => saveWellness(
                                  context,
                                  () => ref
                                      .read(wellnessProvider.notifier)
                                      .update(
                                        (s) => kind == 'sleep'
                                            ? s.copyWith(sleepSource: source)
                                            : s.copyWith(workoutSource: source),
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
              Text(
                context.w(
                  'Her alan için tek kaynak seçilir. Çakışan uyku/antrenman aralıkları iki kez sayılmaz. Diğer kaynakların kayıtları kaybolmaz.',
                  'One source is selected per area. Overlapping intervals are counted once. Other source records remain available.',
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (data.healthEnabled || health != null) ...[
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: busy ? null : disconnect,
                icon: const Icon(Icons.link_off),
                label: Text(
                  context.w(
                    'Bağlantıyı ve alınan kayıtları kaldır',
                    'Remove connection and imported records',
                  ),
                ),
              ),
            ],
            WellnessSection(
              context.w('Saatin veya yüzüğün', 'Your watch or ring'),
            ),
            Text(
              context.w(
                'Apple Watch ve uyumlu Android cihazların paylaşabildiği alanlar sağlık merkezi üzerinden okunur. Her markanın tüm ölçümleri aktarılmayabilir. Oura, Garmin ve WHOOP gibi doğrudan marka hesap bağlantıları sonraki geliştirme aşamasındadır.',
                'Shared data from Apple Watch and compatible Android devices is read through the health hub. Not all brand metrics may be shared. Direct Oura, Garmin and WHOOP account connections are planned for a later release.',
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const HealthPrivacyScreen(),
                ),
              ),
              child: Text(
                context.w(
                  'Sağlık verisi kullanımını incele',
                  'Review health data use',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> disconnect() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(
          context.w(
            'Alınan kayıtlar kaldırılsın mı?',
            'Remove imported records?',
          ),
        ),
        content: Text(
          context.w(
            'NutriGuide içindeki cihaz kayıtları silinir ve yeni okuma durur. Manuel günlüklerin ve üretici hesabındaki verilerin korunur. iPhone’da sistem iznini ayrıca Apple Health’ten yönetebilirsin.',
            'Device records in NutriGuide will be removed and new reads will stop. Your manual journal and provider records are kept. On iPhone, manage system permissions separately in Apple Health.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(context.w('Vazgeç', 'Cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(context.w('Kaldır', 'Remove')),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    setState(() => busy = true);
    try {
      await ref
          .read(wellnessProvider.notifier)
          .update((s) => s.copyWith(clearHealth: true, healthEnabled: false));
      try {
        await ref.read(healthConnectionProvider).revoke();
      } catch (_) {
        if (mounted) {
          setState(
            () => message = context.w(
              'Yerel kayıtlar kaldırıldı. Sistem iznini sağlık uygulamandan kontrol et.',
              'Local records removed. Review system permissions in your health app.',
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) wellnessError(context);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }
}

class HealthPrivacyScreen extends StatelessWidget {
  const HealthPrivacyScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(context.w('Sağlık verisi kullanımı', 'Health data use')),
    ),
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          context.w('Neyi, neden okuyoruz?', 'What do we read, and why?'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Text(
          context.w(
            'Seçtiğinde uyku aralıkları, günlük adım toplamları ve antrenman süreleri okunur. Kaynak ve kayıt zamanları, tekrarları önlemek ve geçmişini göstermek için saklanır.',
            'When selected, sleep intervals, daily step totals and workout durations are read. Sources and timestamps are kept to prevent duplicates and display your history.',
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.w(
            'Bu sürüm yeni iyi oluş günlüklerini ve içe aktarılan cihaz kayıtlarını cihazında şifreli saklar. Bu kayıtları sunucuya, reklam hizmetine veya yapay zekâ servisine göndermez. Sağlık merkezine kayıt yazmaz.',
            'This version encrypts new wellbeing journals and imported device records on your device. These records are not sent to a server, advertising service or AI service. It does not write to your health hub.',
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.w(
            'İzin vermeden manuel kayıtlarla devam edebilirsin. Bağlantılar ekranından alınan cihaz verilerini, Profil’den yeni iyi oluş kayıtlarını silebilirsin. Üretici hesabındaki kayıtların bu işlemlerle silinmez.',
            'You can continue with manual records without granting access. Remove imported data in Connections and new wellbeing records in Profile. These actions do not delete records in your provider account.',
          ),
        ),
        const SizedBox(height: 20),
        Text(
          context.w(
            'Uyku, adım ve antrenmanlar günlük geçmişini görünür kılar. Bu uygulama tıbbi tanı, ilaç dozu veya acil sağlık izleme hizmeti sunmaz.',
            'Sleep, steps and workouts make your daily history visible. This app does not provide medical diagnosis, medication doses or emergency health monitoring.',
          ),
        ),
      ],
    ),
  );
}
