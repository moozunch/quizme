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
      filled: false,
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: AppRadius.card,
        borderSide: BorderSide(color: scheme.outlineVariant, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.card,
        borderSide: BorderSide(color: scheme.outlineVariant, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.card,
        borderSide: BorderSide(color: scheme.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.card,
        borderSide: BorderSide(color: scheme.error, width: 1.8),
      ),
    ),

    // Buttons
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.button),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
        minimumSize: const Size(64, 48),
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
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        minimumSize: const Size(64, 48),
      ),
    ),

    

    // Chips (for meta/status)
    chipTheme: ChipThemeData(
      backgroundColor: scheme.surface,
      selectedColor: scheme.secondaryContainer,
      labelStyle: TextStyle(color: scheme.onSurface, fontWeight: FontWeight.w600),
      secondaryLabelStyle: TextStyle(color: scheme.onSecondaryContainer, fontWeight: FontWeight.w700),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.button,
        side: BorderSide(color: scheme.outlineVariant, width: 1),
      ),
      iconTheme: IconThemeData(color: scheme.onSurfaceVariant),
      selectedShadowColor: scheme.shadow,
      elevation: 0,
      pressElevation: 0,
      showCheckmark: false,
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
