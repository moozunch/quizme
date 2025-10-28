import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/app_state.dart';

class ThemeToggleAction extends StatelessWidget {
  const ThemeToggleAction({super.key});

  @override
  Widget build(BuildContext context) {
    final mode = context.watch<AppState>().themeMode;
    final isDark = mode == ThemeMode.dark;
    return IconButton(
      tooltip: isDark ? 'Switch to Light' : 'Switch to Dark',
      icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
      onPressed: () => context.read<AppState>().toggleTheme(),
    );
  }
}
