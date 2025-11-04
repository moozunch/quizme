import 'package:flutter/material.dart';

/// Design tokens for spacing, radius, durations, and color seeds.
class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppRadius {
  static const Radius rSm = Radius.circular(8);
  static const Radius rMd = Radius.circular(12);
  static const Radius rLg = Radius.circular(16);
  static const BorderRadius card = BorderRadius.all(rMd);
  static const BorderRadius button = BorderRadius.all(rLg);
  static const BorderRadius pill = BorderRadius.all(Radius.circular(28));
}

class AppDurations {
  static const fast = Duration(milliseconds: 120);
  static const normal = Duration(milliseconds: 200);
  static const slow = Duration(milliseconds: 300);
}

class AppSeeds {
  // Main brand seed color
  static const Color seed = Color(0xFF065750); // rgb(6,87,80)
}

/// Centralized color palette in HEX for easy tweak.
class AppPalette {
  // Brand seeds 
  static const Color lightSeed = Color(0xFF065750); // rgb(6,87,80)
  static const Color darkSeed = Color(0xFF065750); // same seed for dark; scheme adjusts via brightness

  // Optional accents used by custom widgets (e.g., decorative blobs)
  static const Color accentPrimary = Color.fromARGB(244, 90, 120, 177); 
  static const Color accentSecondary = Color.fromARGB(244, 90, 177, 97); // #4D77FF
  static const Color accentTertiary = Color.fromARGB(244, 177, 90, 134); // #FF6EC7

  // Neutral surfaces (if needed outside ColorScheme)
  static const Color surfaceLight = Color(0xFFF7F7FA); // #F7F7FA
  static const Color surfaceLightAlt = Color(0xFFEFEFF6); // #EFEFF6
  static const Color surfaceDark = Color(0xFF0E0F15); // #0E0F15
  static const Color surfaceDarkAlt = Color(0xFF171A2A); // #171A2A
}

/// Palette for card backgrounds (pastel / muted tones). Edit HEX values to change look.
class CardPalette {
  static const List<Color> colors = [
    AppPalette.accentPrimary, 
    AppPalette.accentSecondary, 
    AppPalette.accentTertiary, 
  ];
}
