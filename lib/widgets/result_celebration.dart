import 'package:flutter/material.dart';
import '../styles/tokens.dart';

class ResultCelebration extends StatelessWidget {
  final String title;
  final String caption;
  final VoidCallback onHome;
  final VoidCallback onDetail;
  final VoidCallback onShare;
  final int score;
  final int total;

  const ResultCelebration({
    super.key,
    required this.title,
    required this.caption,
    required this.onHome,
    required this.onDetail,
    required this.onShare,
    required this.score,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = scheme.secondaryContainer; // soft, friendly

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Decorative header (simple placeholder icon + score)
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppPalette.accentSecondary.withValues(alpha: 0.9),
                      AppPalette.accentPrimary.withValues(alpha: 0.9),
                    ],
                  ),
                ),
                child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.onSecondaryContainer,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                caption,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSecondaryContainer.withValues(alpha: 0.85),
                    ),
              ),
              const SizedBox(height: 12),
              // Small score badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: scheme.onSecondaryContainer.withValues(alpha: 0.08),
                  borderRadius: const BorderRadius.all(Radius.circular(999)),
                ),
                child: Text(
                  '$score / $total correct',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: scheme.onSecondaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ActionPill(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    bg: Colors.white,
                    fg: Colors.black87,
                    onTap: onHome,
                  ),
                  _ActionPill(
                    icon: Icons.grade_rounded,
                    label: 'Rating',
                    bg: AppPalette.accentPrimary,
                    fg: Colors.white,
                    onTap: onDetail,
                  ),
                  _ActionPill(
                    icon: Icons.ios_share_rounded,
                    label: 'Share',
                    bg: AppPalette.accentSecondary,
                    fg: Colors.white,
                    onTap: onShare,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bg;
  final Color fg;
  final VoidCallback onTap;

  const _ActionPill({
    required this.icon,
    required this.label,
    required this.bg,
    required this.fg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: fg),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
