import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<bool> showDeleteConfirm(
  BuildContext context, {
  String title = 'Delete quiz?',
  String content = 'Tindakan ini tidak dapat dibatalkan.',
  String cancelLabel = 'Cancel',
  String confirmLabel = 'Delete',
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelLabel)),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(confirmLabel)),
      ],
    ),
  );
  return ok == true;
}

Future<String?> showNamePrompt(
  BuildContext context, {
  String title = 'Masukkan nama',
  String hint = 'Nama kamu',
  String cancelLabel = 'Batal',
  String confirmLabel = 'Mulai',
}) async {
  String name = '';
  final ok = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(hintText: hint),
        onChanged: (v) => name = v.trim(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(cancelLabel)),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(confirmLabel)),
      ],
    ),
  );
  if (ok == true && name.isNotEmpty) return name;
  return null;
}

Future<void> copyToClipboard(BuildContext context, String text, {String snack = 'Copied'}) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(snack)));
  }
}
