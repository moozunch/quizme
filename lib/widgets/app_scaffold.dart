import 'package:flutter/material.dart';

import 'theme_toggle_action.dart';

class AppScaffold extends StatelessWidget {
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final Widget body;
  final EdgeInsetsGeometry padding;
  final bool includeThemeToggle;

  const AppScaffold({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    required this.body,
    this.padding = const EdgeInsets.all(12.0),
    this.includeThemeToggle = true,
  });

  @override
  Widget build(BuildContext context) {
  final actionsList = <Widget>[...(actions ?? const [])];
    if (includeThemeToggle) actionsList.add(const ThemeToggleAction());

    return Scaffold(
      appBar: AppBar(
        title: title ?? (titleText != null ? Text(titleText!) : null),
        actions: actionsList,
      ),
      body: Padding(
        padding: padding,
        child: body,
      ),
    );
  }
}
