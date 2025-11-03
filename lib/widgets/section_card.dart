import 'package:flutter/material.dart';
import '../styles/tokens.dart';

class SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const SectionCard({
    super.key,
    this.title,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.margin = const EdgeInsets.symmetric(vertical: AppSpacing.xs),
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final contents = <Widget>[];
    if (title != null) {
      contents.add(Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
        child: Text(
          title!,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: scheme.onSurface,
              ),
        ),
      ));
    }
    contents.add(child);

    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: AppRadius.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: contents),
    );
  }
}
