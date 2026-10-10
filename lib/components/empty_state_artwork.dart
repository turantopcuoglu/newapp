import 'package:flutter/material.dart';

/// The satin still life above an empty list.
///
/// The source images have dark plum edges. On a dark palette they fade into
/// the background; on a light one the same fade turns into a grey halo, so
/// there the image is cut as a clean rounded tile instead.
class EmptyStateArtwork extends StatelessWidget {
  final String name;
  const EmptyStateArtwork({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      'assets/images/empty/empty_$name.jpg',
      width: 160,
      height: 160,
      fit: BoxFit.cover,
      excludeFromSemantics: true,
    );
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Center(
        child: dark
            ? ShaderMask(
                blendMode: BlendMode.dstIn,
                shaderCallback: (bounds) => const RadialGradient(
                  radius: .5,
                  colors: [Colors.black, Colors.black, Colors.transparent],
                  stops: [0, .55, 1],
                ).createShader(bounds),
                child: image,
              )
            : ClipRRect(borderRadius: BorderRadius.circular(28), child: image),
      ),
    );
  }
}
