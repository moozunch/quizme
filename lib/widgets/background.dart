import 'dart:ui';

import 'package:flutter/material.dart';

///soft gradient background 
class Background extends StatelessWidget {
  final Alignment begin;
  final Alignment end;
  final bool enableBlur;

  const Background({
    super.key,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.enableBlur = true,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Base gradient
    final base = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: isDark
              ? [
                  scheme.surface.withValues(alpha: 0.98),
                  scheme.surfaceContainerHighest.withValues(alpha: 0.94),
                ]
              : [
                  // very light with subtle tint
                  scheme.surface.withValues(alpha: 0.98),
                  scheme.primaryContainer.withValues(alpha: 0.12),
                ],
        ),
      ),
    );

    // Decorative blobs using radial gradients
    Widget blob({required Offset center, required List<Color> colors, double radius = 220}) {
      return Positioned(
        left: center.dx - radius,
        top: center.dy - radius,
        child: IgnorePointer(
          child: Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: colors,
              ),
            ),
          ),
        ),
      );
    }

    final blobs = Stack(children: [
      // Top-left soft purple
      blob(
        center: const Offset(80, 40),
        colors: [
          scheme.primary.withValues(alpha: isDark ? 0.18 : 0.22),
          scheme.primary.withValues(alpha: 0.0),
        ],
        radius: 180,
      ),
      // Top-right pink
      blob(
        center: const Offset(360, -10),
        colors: [
          scheme.tertiary.withValues(alpha: isDark ? 0.14 : 0.18),
          scheme.tertiary.withValues(alpha: 0.0),
        ],
        radius: 200,
      ),
      // Bottom-left blue
      blob(
        center: const Offset(-40, 560),
        colors: [
          scheme.secondary.withValues(alpha: isDark ? 0.14 : 0.16),
          scheme.secondary.withValues(alpha: 0.0),
        ],
        radius: 220,
      ),
    ]);

    final blurLayer = enableBlur
        ? BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
            child: Container(color: Colors.transparent),
          )
        : const SizedBox.shrink();

    return Positioned.fill(
      child: Stack(
        children: [base, blobs, blurLayer],
      ),
    );
  }
}
