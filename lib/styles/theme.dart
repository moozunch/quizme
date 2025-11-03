import 'package:flutter/material.dart';

import 'tokens.dart';

ThemeData buildLightTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(100, 30, 61, 161));
  return _baseTheme(scheme, Brightness.light);
}

ThemeData buildDarkTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: const Color.fromARGB(99, 40, 75, 190), brightness: Brightness.dark);
  return _baseTheme(scheme, Brightness.dark);
}

ThemeData _baseTheme(ColorScheme scheme, Brightness brightness) {
  final isDark = brightness == Brightness.dark;
  return ThemeData(
    brightness: brightness,
    colorScheme: scheme,
    // useMaterial3: true,
    fontFamily: 'PlusJakartaSans',

    // AppBar (base defaults; AppScaffold can override to make it seamless)
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: scheme.surfaceTint,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 18,
        color: scheme.onSurface,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
    ),

    // Cards
    cardTheme: CardTheme(
      elevation: 0,
      margin: const EdgeInsets.all(AppSpacing.xs),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      clipBehavior: Clip.antiAlias,
      surfaceTintColor: scheme.surfaceTint,
    ),

    // ListTile
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      titleTextStyle: TextStyle(fontSize: 16, color: scheme.onSurface, fontWeight: FontWeight.w600),
      subtitleTextStyle: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: AppRadius.card),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs + 2),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: const StadiumBorder(), // pill shape
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
        minimumSize: const Size(88, 44),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
      ),
    ),

    

    // Chips (for meta/status)
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceContainerHighest,
      labelStyle: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: const StadiumBorder(),
      side: BorderSide(color: scheme.outlineVariant, width: 1),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
    ),

    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant,
      thickness: 1,
      space: AppSpacing.md,
    ),

    // SnackBar
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? scheme.inverseSurface : scheme.surface,
      contentTextStyle: TextStyle(color: isDark ? scheme.onInverseSurface : scheme.onSurface),
      actionTextColor: scheme.primary,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
    ),
  );
}
