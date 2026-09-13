import 'package:flutter/material.dart';
import '../../core/theme.dart';
import 'moonlit_assets.dart';
import '../../core/wellness_motion.dart';
import '../../core/atmosphere_surface.dart';

class MoonlitPage extends StatelessWidget {
  final Widget header;
  final List<Widget> children;
  const MoonlitPage({super.key, required this.header, required this.children});
  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              header,
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class SceneTitle extends StatelessWidget {
  final String title;
  final String? eyebrow, subtitle;
  final bool moon;
  const SceneTitle({
    super.key,
    required this.title,
    this.eyebrow,
    this.subtitle,
    this.moon = true,
  });
  @override
  Widget build(BuildContext context) => MoonlitHeader(
    minHeight: eyebrow == null ? 160 : 190,
    moon: moon,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow == null) const SizedBox(height: 30),
        if (eyebrow != null) ...[
          Text(
            eyebrow!,
            style: TextStyle(fontSize: 17, color: context.palette.textPrimary),
          ),
          const SizedBox(height: 17),
        ],
        Text(
          title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            height: 1.15,
            fontSize: eyebrow == null ? 28 : 32,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 13,
              color: context.palette.textSecondary,
            ),
          ),
        ],
      ],
    ),
  );
}

class MoonButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const MoonButton({super.key, required this.label, this.onPressed});
  @override
  Widget build(BuildContext context) => MotionTap(
    onTap: onPressed,
    builder: (context, t) => AtmosphereSurface(
      primary: onPressed != null,
      activity: t,
      radius: 24,
      color: onPressed == null ? context.palette.elevated : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 52),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: onPressed == null
                        ? context.palette.textSecondary
                        : context.palette.onAction,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Transform.translate(
                offset: Offset(Curves.easeOut.transform(t) * (1 - t) * 14, 0),
                child: Icon(
                  Icons.arrow_forward,
                  size: 22,
                  color: context.palette.onAction,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class FineRow extends StatelessWidget {
  final IconData? icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;
  const FineRow({
    super.key,
    this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: context.palette.dividerColor.withAlpha(110),
              width: .6,
            ),
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 23, color: context.palette.textPrimary),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: context.palette.textPrimary,
                ),
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    ),
  );
}
