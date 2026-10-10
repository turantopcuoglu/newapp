import 'package:flutter/material.dart';

/// The top of a card that opens on a moonlit scene (family C): the picture,
/// cropped wide, with the title in the empty sky on the left. The scenes are
/// dark in every palette, so the text is always white over a soft scrim.
class SceneBanner extends StatelessWidget {
  /// File name in `assets/images/scenes/`, without extension.
  final String scene;
  final String title;
  final String? subtitle;
  final double height;

  const SceneBanner({
    super.key,
    required this.scene,
    required this.title,
    this.subtitle,
    this.height = 132,
  });

  @override
  Widget build(BuildContext context) {
    // Larger text gets a taller banner instead of clipping.
    final scale = MediaQuery.textScalerOf(context).scale(20) / 20;
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height * scale.clamp(1, 1.6)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/scenes/$scene.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0, .15),
              excludeFromSemantics: true,
            ),
          ),
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0x99000000), Color(0x00000000)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 72, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w600,
                    height: 1.15,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
