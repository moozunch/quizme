import 'package:flutter/material.dart';

import 'dialogs.dart';

class CopyCodeRow extends StatelessWidget {
  final String label;
  final String code;
  final String snackText;
  const CopyCodeRow({super.key, this.label = 'Kode', required this.code, this.snackText = 'Kode disalin'});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text('$label: $code', style: const TextStyle(fontWeight: FontWeight.bold))),
        IconButton(
          icon: const Icon(Icons.copy),
          tooltip: 'Copy',
          onPressed: () => copyToClipboard(context, code, snack: snackText),
        ),
      ],
    );
  }
}
