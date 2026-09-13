import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/atmosphere_surface.dart';
import 'moonlit_assets.dart';

extension WellnessLocale on BuildContext {
  String w(String tr, String en) =>
      Localizations.localeOf(this).languageCode == 'tr' ? tr : en;
}

void wellnessError(BuildContext context) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.w(
            'Kaydedilemedi. Kaydın değişmedi; lütfen tekrar dene.',
            'Could not save. Your record was not changed; please try again.',
          ),
        ),
      ),
    );

Future<void> saveWellness(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
  } catch (_) {
    if (context.mounted) wellnessError(context);
  }
}

class WellnessPage extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final Widget? action;
  final List<Widget> children;
  const WellnessPage({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.action,
    required this.children,
  });
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          eyebrow.toUpperCase(),
                          style: TextStyle(
                            color: context.palette.moon,
                            letterSpacing: 2.2,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (action != null) action!,
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(title, style: Theme.of(context).textTheme.headlineLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      subtitle!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                  const SizedBox(height: 28),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class WellnessCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  const WellnessCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.color,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Material(
      color: Colors.transparent,
      child: AtmosphereSurface(
        color: color,
        radius: 18,
        child: Padding(padding: padding, child: child),
      ),
    ),
  );
}

class WellnessSection extends StatelessWidget {
  final String title;
  final Widget? trailing;
  const WellnessSection(this.title, {super.key, this.trailing});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 12),
    child: Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        if (trailing != null) trailing!,
      ],
    ),
  );
}

class WellnessTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  const WellnessTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: AtmosphereSurface(
      radius: 16,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 2,
          ),
          leading: Icon(icon, color: context.palette.textPrimary, size: 24),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: context.palette.textSecondary,
            ),
          ),
          trailing:
              trailing ??
              (onTap == null
                  ? null
                  : const Icon(Icons.arrow_outward_rounded, size: 20)),
          onTap: onTap,
        ),
      ),
    ),
  );
}

class MoonlitSky extends StatelessWidget {
  final double height;
  final Widget? child;
  const MoonlitSky({super.key, this.height = 180, this.child});
  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: Stack(
      children: [
        const Positioned.fill(child: HorizonScene()),
        if (child != null) Positioned.fill(child: child!),
      ],
    ),
  );
}

String durationLabel(BuildContext context, int? minutes) {
  if (minutes == null) return context.w('Kayıt yok', 'No record');
  if (minutes < 60) return context.w('$minutes dk', '$minutes min');
  return context.w(
    '${minutes ~/ 60} sa ${minutes % 60} dk',
    '${minutes ~/ 60} h ${minutes % 60} min',
  );
}

class MetricPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const MetricPill({super.key, required this.icon, required this.label});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      border: Border.all(color: context.palette.dividerColor),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: context.palette.mint),
        const SizedBox(width: 7),
        Flexible(child: Text(label, style: const TextStyle(fontSize: 12))),
      ],
    ),
  );
}

class BreathingOrb extends StatelessWidget {
  final double progress;
  const BreathingOrb({super.key, required this.progress});
  @override
  Widget build(BuildContext context) {
    final reduced = MediaQuery.disableAnimationsOf(context);
    final scale = reduced ? 1.0 : .96 + .04 * math.sin(progress * math.pi);
    return Semantics(
      label: context.w(
        'Kendi ritminde. Rahatça nefes al.',
        'At your rhythm. Breathe comfortably.',
      ),
      child: Transform.scale(
        scale: scale,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            children: [
              const Positioned.fill(
                child: ReferenceCrop(
                  board: 'ritual',
                  crop: Rect.fromLTWH(358, 296, 376, 376),
                ),
              ),
              if (Localizations.localeOf(context).languageCode != 'tr')
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    color: context.palette.surface,
                    child: const Text(
                      'At your rhythm\nBreathe comfortably',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
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
