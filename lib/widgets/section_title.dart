import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry margin;
  const SectionTitle(this.text, {super.key, this.margin = const EdgeInsets.only(top: 8, bottom: 4)});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
