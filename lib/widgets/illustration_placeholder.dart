import 'package:flutter/material.dart';

/// Simple decorative placeholder widget for cards/sections when no SVG is provided.
/// Uses theme colors and rounded shapes to suggest an illustration without assets.
class IllustrationPlaceholder extends StatelessWidget {
  final double size;
  final Color? color;

  const IllustrationPlaceholder({super.key, this.size = 56, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = color ?? scheme.primary;
  final soft = base.withValues(alpha: 0.15);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer soft circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: soft,
              shape: BoxShape.circle,
            ),
          ),
          // Inner solid blob
          Container(
            width: size * 0.6,
            height: size * 0.6,
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(size * 0.22),
            ),
          ),
          // Accent dot
          Positioned(
            bottom: size * 0.12,
            right: size * 0.12,
            child: Container(
              width: size * 0.18,
              height: size * 0.18,
              decoration: BoxDecoration(
                color: scheme.onPrimary.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
            ),
          )
        ],
      ),
    );
  }
}
