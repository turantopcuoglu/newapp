import 'package:flutter/material.dart';

/// Lossless source-rectangle rendering: original generated assets stay intact.
/// Image dimensions are resolved from the asset, never assumed by the layout.
class AtlasImage extends StatefulWidget {
  final String asset;
  final int columns, rows, index;
  final BoxFit fit;
  const AtlasImage({
    super.key,
    required this.asset,
    required this.columns,
    required this.rows,
    required this.index,
    this.fit = BoxFit.cover,
  });
  @override
  State<AtlasImage> createState() => _AtlasImageState();
}

class _AtlasImageState extends State<AtlasImage> {
  ImageStream? stream;
  ImageStreamListener? listener;
  ImageInfo? info;
  void resolve() {
    if (listener != null) stream?.removeListener(listener!);
    stream = AssetImage(
      widget.asset,
    ).resolve(createLocalImageConfiguration(context));
    listener = ImageStreamListener(
      (value, synchronous) {
        final old = info;
        if (synchronous) {
          info = value;
        } else if (mounted) {
          setState(() => info = value);
        } else {
          value.dispose();
        }
        old?.dispose();
      },
      onError: (Object error, StackTrace? stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stack,
            library: 'wellness image atlas',
            context: ErrorDescription(widget.asset),
          ),
        );
      },
    );
    stream!.addListener(listener!);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resolve();
  }

  @override
  void didUpdateWidget(covariant AtlasImage old) {
    super.didUpdateWidget(old);
    if (old.asset != widget.asset) resolve();
  }

  @override
  void dispose() {
    if (listener != null) stream?.removeListener(listener!);
    info?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: RepaintBoundary(
      child: CustomPaint(
        painter: info == null
            ? null
            : _AtlasPainter(
                info!,
                widget.columns,
                widget.rows,
                widget.index,
                widget.fit,
              ),
        size: Size.infinite,
      ),
    ),
  );
}

class _AtlasPainter extends CustomPainter {
  final ImageInfo info;
  final int columns, rows, index;
  final BoxFit fit;
  _AtlasPainter(this.info, this.columns, this.rows, this.index, this.fit);
  @override
  void paint(Canvas canvas, Size size) {
    final w = info.image.width / columns, h = info.image.height / rows;
    final fitted = applyBoxFit(fit, Size(w - 2, h - 2), size);
    final source = Alignment.center.inscribe(
      fitted.source,
      Rect.fromLTWH(
        (index % columns) * w + 1,
        (index ~/ columns) * h + 1,
        w - 2,
        h - 2,
      ),
    );
    final destination = Alignment.center.inscribe(
      fitted.destination,
      Offset.zero & size,
    );
    canvas.drawImageRect(
      info.image,
      source,
      destination,
      Paint()..filterQuality = FilterQuality.medium,
    );
  }

  @override
  bool shouldRepaint(covariant _AtlasPainter old) =>
      old.info != info ||
      old.index != index ||
      old.columns != columns ||
      old.rows != rows ||
      old.fit != fit;
}
