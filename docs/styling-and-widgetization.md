# Styling & Widgetization Guide

This guide explains how I style the app and when to extract UI into reusable widgets.

## Principles

- Theme globally, widgetize locally.
  - Use ThemeData (Material sub-themes) for global look & feel: colors, typography, radii, paddings of core components (AppBar, Card, ListTile, Buttons, Inputs, SnackBar).
  - Extract widgets for repeated UI patterns or domain components (cards, rows, dialogs) that appear in multiple screens.
- Centralize design tokens to keep numbers consistent (spacing, radius, durations).
- Avoid magic numbers in screens; prefer tokens.

## Where things live

- Design tokens: `lib/styles/tokens.dart`
  - `AppSpacing`, `AppRadius`, `AppDurations`, `AppSeeds`
- Themes: `lib/styles/theme.dart`
  - `buildLightTheme()`, `buildDarkTheme()` and sub-themes for AppBar, Buttons, Cards, etc.
- Reusable widgets: `lib/widgets/`
  - `app_scaffold.dart` — standard screen shell (AppBar + padding + theme toggle)
  - `section_title.dart` — bold section header text
  - `copy_code_row.dart` — label + code with copy button
  - `attempt_list.dart` — renders attempts list
  - `quiz_card.dart` — quiz summary card
  - `dialogs.dart` — helpers: `showNamePrompt`, `showDeleteConfirm`, `copyToClipboard`

## When to widgetize vs theme

Widgetize if:
- The pattern appears in 2+ places or will likely be reused.
- The component contains business/domain logic (e.g., QuizCard actions).
- You want a single place to evolve behavior and layout together.

Theme if:
- You want to change the default look of Material components everywhere.
- The change is purely visual (radius, padding, colors) and applies broadly.

## How to add a new pattern

1) If it's a global style change
- Update `lib/styles/theme.dart` sub-themes.
- If you need new constants, add to `lib/styles/tokens.dart`.

2) If it's a repeated UI component
- Create a new widget under `lib/widgets/`.
- Use tokens for paddings/radii.
- Keep API simple and stateless if possible.

## Examples

- Change button radius/padding for entire app:
  - Edit `OutlinedButtonTheme`, `ElevatedButtonTheme`, `FilledButtonTheme` in `theme.dart`.
- Add a reusable banner (e.g., InfoBanner):
  - Create `lib/widgets/info_banner.dart` exposing `InfoBanner({icon, title, subtitle, color})`.
  - Replace per-screen inline banners with the component.

## Tips

- Favor composition: small widgets composed in screens.
- Keep dialogs in `dialogs.dart` for consistency (copy, prompts, confirms).
- Prefer `AppScaffold` so AppBar/actions/padding stay consistent across screens.
