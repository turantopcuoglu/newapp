import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// One bundled neutral material map, shared through Flutter's image cache.
/// Each mounted consumer owns only its ImageInfo handle, not another bitmap.
class SatinTexture extends StatefulWidget {
  static const asset = 'assets/materials/satin-neutral.png';
  final Widget Function(BuildContext, ui.Image?) builder;
  const SatinTexture({super.key, required this.builder});

  @override
  State<SatinTexture> createState() => _SatinTextureState();
}

class _SatinTextureState extends State<SatinTexture> {
  ImageStream? stream;
  ImageInfo? info;
  late final listener = ImageStreamListener(receive);

  void receive(ImageInfo value, bool synchronous) {
    if (!mounted) {
      value.dispose();
      return;
    }
    final previous = info;
    if (synchronous) {
      info = value;
    } else {
      setState(() => info = value);
    }
    previous?.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = const AssetImage(
      SatinTexture.asset,
    ).resolve(createLocalImageConfiguration(context));
    if (next.key == stream?.key) return;
    stream?.removeListener(listener);
    stream = next..addListener(listener);
  }

  @override
  void dispose() {
    stream?.removeListener(listener);
    info?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, info?.image);
}

/// Soft-light keeps the palette's hue. A half-gray texel is optically neutral;
/// lighter/darker texels add local material depth without a white veil.
void paintSatin(Canvas canvas, Rect rect, ui.Image? texture, double opacity) {
  if (texture == null || rect.isEmpty) return;
  final source = Size(texture.width.toDouble(), texture.height.toDouble());
  final fitted = applyBoxFit(BoxFit.cover, source, rect.size);
  canvas.drawImageRect(
    texture,
    Alignment.center.inscribe(fitted.source, Offset.zero & source),
    rect,
    Paint()
      ..color = Colors.white.withValues(alpha: opacity)
      ..blendMode = BlendMode.softLight
      ..filterQuality = FilterQuality.medium,
  );
}
