import 'package:flutter/material.dart';

import 'theme_toggle_action.dart';
import 'background.dart';
import 'package:flutter/services.dart';

class AppScaffold extends StatelessWidget {
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final Widget body;
  final EdgeInsetsGeometry padding;
  final bool includeThemeToggle;
  final bool withBackground;
  final bool seamlessAppBar;

  const AppScaffold({
    super.key,
    this.title,
    this.titleText,
    this.actions,
    required this.body,
    this.padding = const EdgeInsets.all(12.0),
    this.includeThemeToggle = true,
    this.withBackground = true,
    this.seamlessAppBar = false,
  });

  @override
  Widget build(BuildContext context) {
  final actionsList = <Widget>[...(actions ?? const [])];
    if (includeThemeToggle) actionsList.add(const ThemeToggleAction());

    final dir = Directionality.of(context);
    final basePad = padding.resolve(dir);
    final media = MediaQuery.of(context);
    final topInset = media.padding.top + kToolbarHeight;
    final resolvedPad = seamlessAppBar
        ? EdgeInsets.fromLTRB(basePad.left, basePad.top + topInset, basePad.right, basePad.bottom)
        : basePad;

    return Scaffold(
      extendBodyBehindAppBar: seamlessAppBar,
      appBar: AppBar(
        backgroundColor: seamlessAppBar ? Colors.transparent : null,
        surfaceTintColor: seamlessAppBar ? Colors.transparent : null,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: Theme.of(context).brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
        title: title ?? (titleText != null ? Text(titleText!) : null),
        actions: actionsList,
      ),
      body: Stack(
        children: [
          if (withBackground) const Background(),
          Padding(padding: resolvedPad, child: body),
        ],
      ),
    );
  }
}
