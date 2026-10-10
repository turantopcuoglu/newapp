import 'package:flutter/material.dart';

class OnboardingArtworkHeader extends StatelessWidget {
  final String name, title;
  const OnboardingArtworkHeader({
    super.key,
    required this.name,
    required this.title,
  });

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/onboarding/onboarding_$name.jpg',
            fit: BoxFit.cover,
            excludeFromSemantics: true,
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0x88000000), Colors.transparent],
              ),
            ),
          ),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 220),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 64, 70),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  height: 1.15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
