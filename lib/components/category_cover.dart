import 'package:flutter/material.dart';

/// Text always sits over a dark scrim, including in the light app palette.
class CategoryCover extends StatelessWidget {
  final String imagePath;
  final Widget child;
  final BorderRadius borderRadius;

  const CategoryCover({
    super.key,
    required this.imagePath,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(22)),
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: borderRadius,
    child: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            excludeFromSemantics: true,
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x66000000),
                  Color(0x22000000),
                  Color(0x55000000),
                  Color(0xEB000000),
                ],
                stops: [0, .22, .45, 1],
              ),
            ),
          ),
        ),
        child,
      ],
    ),
  );
}

class CategoryCoverHeader extends StatelessWidget {
  final String imagePath, title, count;
  final String? subtitle;

  const CategoryCoverHeader({
    super.key,
    required this.imagePath,
    required this.title,
    required this.count,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) => CategoryCover(
    imagePath: imagePath,
    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
    child: Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.paddingOf(context).top + 8,
        20,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BackButton(color: Colors.white),
          const SizedBox(height: 64),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            count,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    ),
  );
}
